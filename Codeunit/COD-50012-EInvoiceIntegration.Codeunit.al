codeunit 50012 EInvoiceIntegration
{
    trigger OnRun()
    begin

    end;

    procedure AuthenticateCredentials(DocNo: Code[20])
    var

        _HttpClient: HttpClient;
        _HttpRequest: HttpRequestMessage;
        _HttpContent: HttpContent;
        _HttpHeader: HttpHeaders;
        _HttpResponse: HttpResponseMessage;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        ResultMessage: Text;
        TokenRequestbody: Text;
        GSTRegistrationNos: Record "GST Registration Nos.";
        RECEwayBillEinvoice: Record "E-Way Bill & E-Invoice";
    begin
        GSTRegValidations(DocNo);
        TokenRequestbody := 'username=info@iffcomc.in&password=Iffco@123&client_id=tanXTzDrwWgjdNdwfe&client_secret=CyaE3Mp43h92IFHH2bSVMQlI&grant_type=password';
        _HttpContent.WriteFrom(TokenRequestbody);
        _HttpContent.GetHeaders(_HttpHeader);
        _HttpHeader.Clear();
        _HttpHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        _HttpHeader.Add('Return-Type', 'application/text');
        _HttpRequest.Content := _HttpContent;
        _HttpRequest.SetRequestUri('https://pro.mastersindia.co/oauth/access_token');
        _HttpRequest.Method := 'POST';
        if _HttpClient.Send(_HttpRequest, _HttpResponse) then begin
            _HttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);

            if JResultObject.Get('access_token', JResultToken) then
                accesstoken := JResultToken.AsValue().AsText();
            Message(accesstoken);
        end else
            Message('Authentication Failed');
    end;

    procedure GSTRegValidations(DocNo: Code[20]): Text
    var
        RecGSTNO: Record "GST Registration Nos.";
        RECEwayBillEinvoice: Record "E-Way Bill & E-Invoice";
    begin
        RECEwayBillEinvoice.RESET();
        RECEwayBillEinvoice.SETRANGE("No.", DocNo);
        IF RECEwayBillEinvoice.FINDFIRST THEN BEGIN
            RecGSTNO.RESET();
            RecGSTNO.SETRANGE(Code, RECEwayBillEinvoice."Location GST Reg. No.");
            IF RecGSTNO.FINDFIRST THEN BEGIN
                IF RecGSTNO.Username = '' THEN
                    ERROR('Username must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO.Password = '' THEN
                    ERROR('Password must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO."Client ID" = '' THEN
                    ERROR('Client ID must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO."Client Secret" = '' THEN
                    ERROR('Client Secret must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO."Grant Type" = '' THEN
                    ERROR('Grant Type must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
            END
            ELSE
                ERROR('Location GST Reg. No. cannot be blank');
        end;
    end;

    procedure CreateJsonSalesInvoiceOrder(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        JsonObjectHeader: JsonObject;
        JsonObjectHeader1: JsonObject;
        JsonObjectHeader2: JsonObject;
        JsonObjectHeader3: JsonObject;
        JsonObjectHeader4: JsonObject;
        JsonObjectHeader5: JsonObject;
        JsonObjectHeader6: JsonObject;
        JsonObjectHeader7: JsonObject;
        JsonObjectAddDocDtls: JsonObject;
        JsonArrayAddDocDtls: JsonArray;
        JsonObjectLine: JsonObject;
        JsonArrayLine: JsonArray;
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        i: Integer;
        ItemRec: Record Item;
        CompInfoRec: Record "Company Information";
        LocRec: Record Location;
    begin
        CompInfoRec.Get();
        LocRec.Get(SalesInvoiceHeader."Location Code");

        JsonObjectHeader.Add('access_token', accesstoken);
        SendSalesInvUser_gstin(SalesInvoiceHeader."No.");
        JsonObjectHeader.Add('user_gstin', SIusergstin);
        JsonObjectHeader.Add('data_source', 'erp');

        SendSalesInvTransactionDetails(SalesInvoiceHeader);
        JsonObjectHeader1.Add('supply_type', SIcatg);
        JsonObjectHeader1.Add('charge_type', 'N');
        JsonObjectHeader1.Add('igst_on_intra', 'N');
        JsonObjectHeader1.Add('ecommerce_gstin', '');
        JsonObjectHeader.Add('transaction_details', JsonObjectHeader1);

        JsonObjectHeader2.Add('document_type', SITyp);
        JsonObjectHeader2.Add('document_number', SalesInvoiceHeader."No.");
        JsonObjectHeader2.Add('document_date', FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        JsonObjectHeader.Add('document_details', JsonObjectHeader2);

        SendSalesInvSellerDetails(LocRec."State Code");
        JsonObjectHeader3.Add('gstin', SalesInvoiceHeader."Location GST Reg. No.");
        JsonObjectHeader3.Add('legal_name', CompInfoRec.Name);
        JsonObjectHeader3.Add('trade_name', CompInfoRec.Name);
        JsonObjectHeader3.Add('address1', LocRec.Address);
        JsonObjectHeader3.Add('address2', LocRec."Address 2");
        JsonObjectHeader3.Add('location', LocRec.City);
        JsonObjectHeader3.Add('pincode', COPYSTR(LocRec."Post Code", 1, 6));
        JsonObjectHeader3.Add('state_code', SIStateCodeDesc);
        JsonObjectHeader3.Add('phone_number', COPYSTR(LocRec."Phone No.", 1, 10));
        JsonObjectHeader3.Add('email', COPYSTR(LocRec."E-Mail", 1, 50));
        JsonObjectHeader.Add('seller_details', JsonObjectHeader3);

        SendSalesInvBuyerDetails(SalesInvoiceHeader);
        IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
            JsonObjectHeader4.Add('gstin', 'URP')
        else
            JsonObjectHeader4.Add('gstin', SalesInvoiceHeader."Customer GST Reg. No.");
        JsonObjectHeader4.Add('legal_name', SalesInvoiceHeader."Bill-to Name");
        JsonObjectHeader4.Add('trade_name', SalesInvoiceHeader."Bill-to Name");
        JsonObjectHeader4.Add('address1', SalesInvoiceHeader."Bill-to Address");
        if StrLen(SalesInvoiceHeader."Bill-to Address 2") < 3 then
            JsonObjectHeader4.Add('address2', SalesInvoiceHeader."Bill-to Address 2" + '...')
        else
            JsonObjectHeader4.Add('address2', SalesInvoiceHeader."Bill-to Address 2");
        if SalesInvoiceHeader."Bill-to City" <> '' then
            JsonObjectHeader4.Add('location', SalesInvoiceHeader."Bill-to City")
        else
            JsonObjectHeader4.Add('location', SalesInvoiceHeader."Ship-to City");
        IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
            JsonObjectHeader4.Add('pincode', '999999')
        else
            JsonObjectHeader4.Add('pincode', SalesInvoiceHeader."Bill-to Post Code");
        JsonObjectHeader4.Add('place_of_supply', SIBuyerStcd);
        JsonObjectHeader4.Add('state_code', SIBuyerStatename);
        JsonObjectHeader4.Add('phone_number', SIBuyerPh);
        JsonObjectHeader4.Add('email', SIBuyerEm);
        JsonObjectHeader.Add('buyer_details', JsonObjectHeader4);

        SendSalesInvDispath_Details(LocRec."State Code");
        JsonObjectHeader5.Add('gstin', 'GSTIN :');
        JsonObjectHeader5.Add('company_name', CompInfoRec.Name);
        JsonObjectHeader5.Add('address1', LocRec.Address + ' ' + LocRec."Address 2");
        JsonObjectHeader5.Add('address2', 'GSTIN :' + ' ' + SalesInvoiceHeader."Location GST Reg. No.");
        JsonObjectHeader5.Add('location', LocRec.City);
        JsonObjectHeader5.Add('pincode', LocRec."Post Code");
        JsonObjectHeader5.Add('state_code', SIDispatchstate_code);
        JsonObjectHeader.Add('dispatch_details', JsonObjectHeader5);

        SendSalesInvShipDetails(SalesInvoiceHeader);
        JsonObjectHeader6.Add('gstin', SIShipGSTIN);
        JsonObjectHeader6.Add('legal_name', SIShipTrdNm);
        JsonObjectHeader6.Add('trade_name', SIShipTrdNm);
        JsonObjectHeader6.Add('address1', SIShipBno);
        JsonObjectHeader6.Add('address2', SIShipBnm);
        JsonObjectHeader6.Add('location', SIShipLoc);
        JsonObjectHeader6.Add('pincode', SIShipPin);
        JsonObjectHeader6.Add('state_code', SIShipStatename);
        JsonObjectHeader.Add('ship_details', JsonObjectHeader6);

        JsonObjectHeader7.Add('bank_account_number', '');
        JsonObjectHeader7.Add('paid_balance_amount', 0);
        JsonObjectHeader7.Add('credit_days', 0);
        JsonObjectHeader7.Add('credit_transfer', '');
        JsonObjectHeader7.Add('direct_debit', '');
        JsonObjectHeader7.Add('branch_or_ifsc', '');
        JsonObjectHeader7.Add('payment_mode', '');
        JsonObjectHeader7.Add('payee_name', '');
        JsonObjectHeader7.Add('payment_due_date', '');
        JsonObjectHeader7.Add('payment_instruction', '');
        JsonObjectHeader7.Add('payment_term', '');
        JsonObjectHeader.Add('ship_details', JsonObjectHeader7);

        JsonObjectAddDocDtls.Add('supporting_document_url', '');
        JsonObjectAddDocDtls.Add('supporting_document', '');
        JsonObjectAddDocDtls.Add('additional_information', '');
        JsonObjectHeader.Add('additional_document_details', JsonObjectHeader7);

        i := 1;
        SalesInvoiceLineRec.Reset();
        SalesInvoiceLineRec.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvoiceLineRec.FindFirst() then begin
            repeat
                Clear(JsonObjectLine);
                JsonObjectLine.Add('SiNo', i);
                JsonObjectLine.Add('ProductDesc', SalesInvoiceLineRec.Description);
                if ItemRec.Get(SalesInvoiceLineRec."No.") then begin
                    if ItemRec.Type = ItemRec.Type::Service then
                        JsonObjectLine.Add('IsService', 'Y')
                    else
                        JsonObjectLine.Add('IsService', 'N');
                end;
                JsonObjectLine.Add('HsnCode', SalesInvoiceLineRec."Item Category Code");

                JsonObjectLine.Add('LineNo', SalesInvoiceLineRec."Line No.");
                JsonObjectLine.Add('Type', SalesInvoiceLineRec.Type.AsInteger());
                JsonObjectLine.Add('No', SalesInvoiceLineRec."No.");
                JsonObjectLine.Add('Quantity', SalesInvoiceLineRec.Quantity);
                JsonObjectLine.Add('UnitPrice', SalesInvoiceLineRec."Unit Price");
                i := i + 1;
                JsonArrayLine.Add(JsonObjectLine);
            until SalesInvoiceLineRec.Next() = 0;
        end;
        JsonObjectHeader.Add('TpApiItemList', JsonArrayLine);

        Message(Format(JsonObjectHeader));
    end;

    procedure IsSalesInvOrSalesCrMemoHeader(DocNo: Code[20])
    var
        SIHRec: Record "Sales Invoice Header";
        SCrMHRec: Record "Sales Cr.Memo Header";
    begin
        if SIHRec.Get(DocNo) then
            IsInvoice := true;
        if SCrMHRec.Get(DocNo) then
            IsInvoice := false;
    end;

    procedure SendSalesInvUser_gstin(DocNo: Code[20])
    var
        T50000: Record 50000;
    begin
        SIusergstin := '';
        if T50000.Get(DocNo) then
            SIusergstin := T50000."Location GST Reg. No.";
    end;

    procedure SendSalesInvTransactionDetails(SalesInvHeader: Record "Sales Invoice Header")
    begin
        SIcatg := '';
        SITyp := '';
        if IsInvoice then begin
            IF SalesInvHeader."Invoice Type" = SalesInvHeader."Invoice Type"::Taxable THEN
                SITyp := 'INV'
            ELSE
                IF (SalesInvHeader."Invoice Type" = SalesInvHeader."Invoice Type"::"Debit Note") OR
                   (SalesInvHeader."Invoice Type" = SalesInvHeader."Invoice Type"::Supplementary)
                THEN
                    SITyp := 'DBN'
                ELSE
                    SITyp := 'INV';
            IF (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Registered) and (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Exempted) THEN
                SIcatg := 'B2B'
            ELSE
                //    catg := 'EXP';
                IF (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Export) AND (SalesInvHeader."GST Without Payment of Duty" = TRUE) THEN
                    SIcatg := 'EXPWOP'
                ELSE
                    IF (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Export) AND (SalesInvHeader."GST Without Payment of Duty" = FALSE) THEN
                        SIcatg := 'EXPWP'
                    ELSE
                        //    catg := 'EXP';
                        IF (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::"SEZ Unit") AND (SalesInvHeader."GST Without Payment of Duty" = TRUE) THEN
                            SIcatg := 'SEZWOP'
                        ELSE
                            IF (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::"SEZ Unit") AND (SalesInvHeader."GST Without Payment of Duty" = FALSE) THEN
                                SIcatg := 'SEZWP';
        end;
    end;

    procedure SendSalesInvSellerDetails(DocNo: Code[20])
    var
        recState: Record State;
        Statebuff: Record State;
    begin
        SIStateCodeDesc := '';
        if Statebuff.GET(DocNo) then begin
            recState.RESET;
            recState.SETRANGE("State Code (GST Reg. No.)", Statebuff."State Code (GST Reg. No.)");
            IF recState.FindFirst THEN
                SIStateCodeDesc := recState.Description
            else
                SIStateCodeDesc := '';
        end;
    end;

    procedure SendSalesInvBuyerDetails(SIHRec: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        StateBuff: Record State;
        recState: Record State;
        Contact: Record Contact;
        recCust: Record Customer;
        ShipToAddr: Record "Ship-to Address";
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SETRANGE("Document No.", SIHRec."No.");
        SalesInvoiceLine.SETFILTER(Quantity, '<>%1', 0);
        IF SalesInvoiceLine.FINDFIRST THEN begin
            IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Bill-to Address" THEN BEGIN
                IF NOT (SIHRec."GST Customer Type" = "GST Customer Type"::Export) THEN BEGIN
                    StateBuff.GET(SIHRec."GST Bill-to State Code");
                    SIBuyerStcd := StateBuff."State Code (GST Reg. No.)";
                END ELSE
                    SIBuyerStcd := '96';

                IF SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Export THEN
                    SIBuyerStatename := '96'
                ELSE
                    IF SIHRec."GST Customer Type" <> SIHRec."GST Customer Type"::Export THEN BEGIN
                        recState.SETRANGE("State Code (GST Reg. No.)", SIBuyerStcd);
                        IF recState.FIND('-') THEN BEGIN
                            SIBuyerStatename := recState.Description;
                        END;
                    END;
                IF Contact.GET(SIHRec."Bill-to Contact No.") THEN BEGIN
                    SIBuyerPh := '';// COPYSTR(Contact."Phone No.",1,10);
                    SIBuyerEm := '';//COPYSTR(Contact."E-Mail",1,50);
                END ELSE BEGIN
                    IF recCust.GET(SIHRec."Sell-to Customer No.") THEN BEGIN
                        SIBuyerPh := ''; //srecCust."Phone No.";
                        SIBuyerEm := '';//recCust."E-Mail";
                    END;
                END;
            end;
        end else begin
            IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Ship-to Address" THEN BEGIN
                IF NOT (SIHRec."GST Customer Type" = "GST Customer Type"::Export) THEN BEGIN
                    StateBuff.GET(SIHRec."GST Ship-to State Code");
                    SIBuyerStcd := StateBuff."State Code (GST Reg. No.)";
                END ELSE
                    SIBuyerStcd := '96';

                IF SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Export THEN
                    SIBuyerStatename := '96'
                ELSE
                    IF SIHRec."GST Customer Type" <> SIHRec."GST Customer Type"::Export THEN BEGIN
                        recState.SETRANGE("State Code (GST Reg. No.)", SIBuyerStcd);
                        IF recState.FIND('-') THEN BEGIN
                            SIBuyerStatename := recState.Description;
                        END;
                    END;
                IF ShipToAddr.GET(SIHRec."Sell-to Customer No.", SIHRec."Ship-to Code") THEN BEGIN
                    SIBuyerPh := '';//COPYSTR(ShipToAddr."Phone No.",1,10);
                    SIBuyerEm := '';// COPYSTR(ShipToAddr."E-Mail",1,50);
                END ELSE BEGIN
                    IF recCust.GET(SIHRec."Sell-to Customer No.") THEN BEGIN
                        SIBuyerPh := '';//recCust."Phone No.";
                        SIBuyerEm := '';//recCust."E-Mail";
                    END;
                END;
            end else begin
                SIBuyerStcd := '';
                SIBuyerPh := '';
                SIBuyerEm := '';
            end;
        end;
    end;

    procedure SendSalesInvDispath_Details(DocNo: Code[20])
    var
        recState: Record State;
    begin
        SIDispatchstate_code := '';
        if recState.Get(DocNo) then
            SIDispatchstate_code := recState.Description;
    end;

    procedure SendSalesInvShipDetails(SIHRec: Record "Sales Invoice Header")
    var
        ShipToAddr: Record "Ship-to Address";
        recShiptoCode: Record "Ship-to Address";
        recCust: Record Customer;
        Cust: Record Customer;
        StateBuff: Record State;
        recState: Record State;
    begin
        SIShipGSTIN := '';
        SIShipTrdNm := '';
        SIShipBno := '';
        SIShipBnm := '';
        SIShipLoc := '';
        SIShipPin := '';
        SIShipStcd := '';
        SIShipStatename := '';
        if SIHRec."Ship-to Code" <> '' then begin
            ShipToAddr.GET(SIHRec."Sell-to Customer No.", SIHRec."Ship-to Code");
            SIShipGSTIN := ShipToAddr."GST Registration No.";
            SIShipTrdNm := SIHRec."Ship-to Name";
            SIShipBno := SIHRec."Ship-to Address";
            SIShipBnm := SIHRec."Ship-to Address 2";
            IF STRLEN(SIShipBnm) < 3 THEN
                SIShipBnm := SIShipBnm + '...';
            SIShipLoc := SIHRec."Ship-to City";
            IF SIShipLoc = '' THEN BEGIN
                recShiptoCode.RESET();
                recShiptoCode.SETRANGE(Code, SIHRec."Ship-to Code");
                IF recShiptoCode.FINDFIRST THEN
                    SIShipLoc := recShiptoCode.City;
            END;
            SIShipPin := COPYSTR(SIHRec."Ship-to Post Code", 1, 6);
            IF SIHRec."GST Customer Type" <> SIHRec."GST Customer Type"::Export THEN begin
                StateBuff.GET(SIHRec."GST Ship-to State Code");
                SIShipStcd := StateBuff."State Code (GST Reg. No.)";
            end;
            IF SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Export THEN BEGIN
                SIShipStatename := 'Other Country';
                SIShipPin := '999999';
                SIShipStcd := '96';//ACXRaman 05022021
            end else begin
                IF SIHRec."GST Customer Type" IN [SIHRec."GST Customer Type"::Registered, SIHRec."GST Customer Type"::Unregistered, SIHRec."GST Customer Type"::"SEZ Unit"] THEN BEGIN
                    recState.SETRANGE("State Code (GST Reg. No.)", SIShipStcd);
                    IF recState.FIND('-') THEN BEGIN
                        SIShipStatename := recState.Description;
                    END;
                END;
            end;
        end else begin
            Cust.GET(SIHRec."Sell-to Customer No.");
            SIShipGSTIN := SIHRec."Customer GST Reg. No.";
            SIShipTrdNm := SIHRec."Sell-to Customer Name";
            SIShipBno := SIHRec."Sell-to Address";
            SIShipBnm := SIHRec."Sell-to Address 2";
            IF STRLEN(SIShipBnm) < 3 THEN
                SIShipBnm := SIShipBnm + '...';
            SIShipLoc := SIHRec."Sell-to City";
            IF SIShipLoc = '' THEN BEGIN
                recCust.RESET();
                recCust.SETRANGE("No.", SIHRec."Sell-to Customer No.");
                IF recCust.FINDFIRST THEN
                    SIShipLoc := recCust.City;
            END;
            SIShipPin := COPYSTR(SIHRec."Sell-to Post Code", 1, 6);
            IF StateBuff.GET(Cust."State Code") THEN
                SIShipStcd := StateBuff."State Code (GST Reg. No.)";
            IF SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Export THEN begin
                SIShipLoc := Cust.City;
                SIShipPin := '999999';
                SIShipStatename := '96';
                SIShipGstin := 'URP';
                SIShipStcd := '96';
            end else begin
                IF SIHRec."GST Customer Type" IN [SIHRec."GST Customer Type"::Registered, SIHRec."GST Customer Type"::Unregistered, SIHRec."GST Customer Type"::"SEZ Unit"] THEN BEGIN
                    recState.SETRANGE("State Code (GST Reg. No.)", SIShipStcd);
                    IF recState.FIND('-') THEN BEGIN
                        SIShipStatename := recState.Description;
                    END;
                END;
            end;
        end;
    end;

    var
        accesstoken: Text;
        IsInvoice: Boolean;
        SIcatg: Text[10];
        SITyp: Text[3];
        SIStateCodeDesc: Text;
        SIBuyerStcd: Text[2];
        SIBuyerStatename: Text;
        SIBuyerPh: Text[10];
        SIBuyerEm: text[50];
        SIDispatchstate_code: Text;
        SIShipGSTIN: Text[15];
        SIShipTrdNm: Text[100];
        SIShipBno: Text[60];
        SIShipBnm: Text[60];
        SIShipLoc: Text[60];
        SIShipPin: Text[6];
        SIShipStcd: Text[2];
        SIShipStatename: Text;
        SIusergstin: Code[15];
}