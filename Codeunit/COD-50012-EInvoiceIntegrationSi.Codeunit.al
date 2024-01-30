codeunit 50012 EInvoiceIntegrationSi
{
    Permissions = tabledata 112 = rimd;
    procedure AuthenticateCredentials(DocNo: Code[20]): Text[500]
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
    begin
        GSTRegValidations(DocNo);
        //TokenRequestbody := 'username=aman@mastersindia.co&password=Miitspl@123&client_id=tanXTzDrwWgjdNdwfe&client_secret=CyaE3Mp43h92IFHH2bSVMQlI&grant_type=password';         //For Production
        TokenRequestbody := 'username=aman@mastersindia.co&password=Miitspl@123&grant_type=password';       //For Sandbox
        _HttpContent.WriteFrom(TokenRequestbody);
        _HttpContent.GetHeaders(_HttpHeader);
        _HttpHeader.Clear();
        _HttpHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        _HttpHeader.Add('Return-Type', 'application/text');
        _HttpRequest.Content := _HttpContent;
        _HttpRequest.SetRequestUri('https://sandb-api.mastersindia.co/api/v1/token-auth/');
        _HttpRequest.Method := 'POST';
        if _HttpClient.Send(_HttpRequest, _HttpResponse) then begin
            _HttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);

            //if JResultObject.Get('access_token', JResultToken) then begin             //For Production
            if JResultObject.Get('token', JResultToken) then begin                      //For Sandbox
                accesstoken := JResultToken.AsValue().AsText();
                Message('Return Value Of Access Token : ' + accesstoken)
            end else
                Message('status code not ok');
        end else
            Message('no response from api');
        exit(accesstoken);
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
        JsonObjectHeaderTransDet: JsonObject;
        JsonObjectHeaderDocDet: JsonObject;
        JsonObjectHeaderSellerDet: JsonObject;
        JsonObjectHeaderBuyerDet: JsonObject;
        JsonObjectHeaderDispatchDet: JsonObject;
        JsonObjectHeaderShipDet: JsonObject;
        JsonObjectHeaderPmntDet: JsonObject;
        JsonObjectAddDocDtls: JsonObject;
        JsonArrayAddDocDtls: JsonArray;
        JsonObjectValueDet: JsonObject;
        JsonObjectLine: JsonObject;
        JsonObjectBatchDet: JsonObject;
        JsonObjectHeaderExpDet: JsonObject;
        JsonArrayBatchDet: JsonArray;
        JsonArrayLine: JsonArray;
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        i: Integer;
        ItemRec: Record Item;
        CompInfoRec: Record "Company Information";
        LocRec: Record Location;
        JSONText: Text;
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JResultObject: JsonObject;
        JResultToken: JsonToken;
        OutputMessage: Text;
        JOutputObject: JsonObject;
        JOutputObject1: JsonObject;
        JOutputToken: JsonToken;
        JOutputToken1: JsonToken;
        ResultMessage: Text;
        ResponseCode: Text;
        AckNo: Text;
        AckDt: Text;
        AckDtTimeVar: DateTime;
        Irn: Text;
        SignedInvoice: Text;
        SignedQRCode: Text;
        errorMessage: Text;
        InfoDtls: Text;
        status: Text;
        StatusCode: Text;
        requestId: Text;
        QRCodeUrl: Text;
        EinvoicePdf: Text;
        QRGenerator: Codeunit "QR Generator";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        FldRef: FieldRef;
        recResponseLog: Record "Response Logs";
        EWayBillandEinvoice: Record "E-Way Bill & E-Invoice";
        UnRegCusrErr: Label 'E-Invoicing is not applicable for Unregistered Customer.';
    begin
        AuthenticateCredentials(SalesInvoiceHeader."No.");
        IsSalesInvOrSalesCrMemoHeader(SalesInvoiceHeader."No.");
        CompInfoRec.Get();
        LocRec.Get(SalesInvoiceHeader."Location Code");
        IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Unregistered, "GST Customer Type"::" "] THEN
            ERROR(UnRegCusrErr);

        JsonObjectHeader.Add('access_token', accesstoken);
        //JsonObjectHeader.Add('user_gstin', SalesInvoiceHeader."Location GST Reg. No.");  //For production
        JsonObjectHeader.Add('user_gstin', '09AAAPG7885R002');                           //For Sandbox
        JsonObjectHeader.Add('data_source', 'erp');

        SendSalesInvTransactionDetails(SalesInvoiceHeader);
        JsonObjectHeaderTransDet.Add('supply_type', SIcatg);
        JsonObjectHeaderTransDet.Add('charge_type', 'N');
        JsonObjectHeaderTransDet.Add('igst_on_intra', 'N');
        JsonObjectHeaderTransDet.Add('ecommerce_gstin', '');
        JsonObjectHeader.Add('transaction_details', JsonObjectHeaderTransDet);

        JsonObjectHeaderDocDet.Add('document_type', SITyp);
        JsonObjectHeaderDocDet.Add('document_number', SalesInvoiceHeader."No.");
        JsonObjectHeaderDocDet.Add('document_date', FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        JsonObjectHeader.Add('document_details', JsonObjectHeaderDocDet);

        SendSalesInvSellerDetails(LocRec."State Code");
        //JsonObjectHeaderSellerDet.Add('gstin', SalesInvoiceHeader."Location GST Reg. No.");       //For production
        JsonObjectHeaderSellerDet.Add('gstin', '09AAAPG7885R002');                                  //For sandbox
        JsonObjectHeaderSellerDet.Add('legal_name', CompInfoRec.Name);
        JsonObjectHeaderSellerDet.Add('trade_name', CompInfoRec.Name);
        JsonObjectHeaderSellerDet.Add('address1', LocRec.Address);
        JsonObjectHeaderSellerDet.Add('address2', LocRec."Address 2");
        JsonObjectHeaderSellerDet.Add('location', LocRec.City);
        //JsonObjectHeaderSellerDet.Add('pincode', COPYSTR(LocRec."Post Code", 1, 6));              //For productoin
        JsonObjectHeaderSellerDet.Add('pincode', 201301);                                         //For sandbox
        //JsonObjectHeaderSellerDet.Add('state_code', SIStateCodeDesc);                             //For productoin
        JsonObjectHeaderSellerDet.Add('state_code', 'Uttar Pradesh');                               //For sandbox
        JsonObjectHeaderSellerDet.Add('phone_number', COPYSTR(LocRec."Phone No.", 1, 10));
        JsonObjectHeaderSellerDet.Add('email', COPYSTR(LocRec."E-Mail", 1, 50));
        JsonObjectHeader.Add('seller_details', JsonObjectHeaderSellerDet);

        SendSalesInvBuyerDetails(SalesInvoiceHeader);
        /*
        IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
            JsonObjectHeaderBuyerDet.Add('gstin', 'URP')
        else
            JsonObjectHeaderBuyerDet.Add('gstin', SalesInvoiceHeader."Customer GST Reg. No.");
        */                                                                                          //For production
        JsonObjectHeaderBuyerDet.Add('gstin', '05AAAPG7885R002');                                   //For sandbox
        JsonObjectHeaderBuyerDet.Add('legal_name', SalesInvoiceHeader."Bill-to Name");
        JsonObjectHeaderBuyerDet.Add('trade_name', SalesInvoiceHeader."Bill-to Name");
        JsonObjectHeaderBuyerDet.Add('address1', SalesInvoiceHeader."Bill-to Address");
        if StrLen(SalesInvoiceHeader."Bill-to Address 2") < 3 then
            JsonObjectHeaderBuyerDet.Add('address2', SalesInvoiceHeader."Bill-to Address 2" + '...')
        else
            JsonObjectHeaderBuyerDet.Add('address2', SalesInvoiceHeader."Bill-to Address 2");
        if SalesInvoiceHeader."Bill-to City" <> '' then
            JsonObjectHeaderBuyerDet.Add('location', SalesInvoiceHeader."Bill-to City")
        else
            JsonObjectHeaderBuyerDet.Add('location', SalesInvoiceHeader."Ship-to City");
        /*
        IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN
            JsonObjectHeaderBuyerDet.Add('pincode', '999999')
        else
            JsonObjectHeaderBuyerDet.Add('pincode', SalesInvoiceHeader."Bill-to Post Code");
        */                                                                                        //For production
        JsonObjectHeaderBuyerDet.Add('pincode', 263001);                                        //For sandbox
        JsonObjectHeaderBuyerDet.Add('place_of_supply', SIBuyerStcd);
        //JsonObjectHeaderBuyerDet.Add('state_code', SIBuyerStatename);                           //For production
        JsonObjectHeaderBuyerDet.Add('state_code', 'Uttarakhand');                                //For sandbox
        JsonObjectHeaderBuyerDet.Add('phone_number', SIBuyerPh);
        JsonObjectHeaderBuyerDet.Add('email', SIBuyerEm);
        JsonObjectHeader.Add('buyer_details', JsonObjectHeaderBuyerDet);

        SendSalesInvDispath_Details(LocRec."State Code");
        //JsonObjectHeaderDispatchDet.Add('gstin', 'GSTIN :');
        JsonObjectHeaderDispatchDet.Add('company_name', CompInfoRec.Name);
        JsonObjectHeaderDispatchDet.Add('address1', LocRec.Address);
        JsonObjectHeaderDispatchDet.Add('address2', LocRec."Address 2");
        JsonObjectHeaderDispatchDet.Add('location', LocRec.City);
        //JsonObjectHeaderDispatchDet.Add('pincode', LocRec."Post Code");                   //For production
        JsonObjectHeaderDispatchDet.Add('pincode', 201301);                               //For sandbox
        //JsonObjectHeaderDispatchDet.Add('state_code', SIDispatchstate_code);              //For production
        JsonObjectHeaderDispatchDet.Add('state_code', 'Uttar Pradesh');                     //For sandbox
        JsonObjectHeader.Add('dispatch_details', JsonObjectHeaderDispatchDet);

        SendSalesInvShipDetails(SalesInvoiceHeader);
        //JsonObjectHeaderShipDet.Add('gstin', SIShipGSTIN);                      //For production
        JsonObjectHeaderShipDet.Add('gstin', '05AAAPG7885R002');                  //For sandbox
        JsonObjectHeaderShipDet.Add('legal_name', SIShipTrdNm);
        JsonObjectHeaderShipDet.Add('trade_name', SIShipTrdNm);
        JsonObjectHeaderShipDet.Add('address1', SIShipBno);
        JsonObjectHeaderShipDet.Add('address2', SIShipBnm);
        JsonObjectHeaderShipDet.Add('location', SIShipLoc);
        //JsonObjectHeaderShipDet.Add('pincode', SIShipPin);                      //For production
        JsonObjectHeaderShipDet.Add('pincode', 263001);                        //For sandbox
        //JsonObjectHeaderShipDet.Add('state_code', SIShipStatename);             //for production            
        JsonObjectHeaderShipDet.Add('state_code', 'UTTARAKHAND');                 //for sandbox
        JsonObjectHeader.Add('ship_details', JsonObjectHeaderShipDet);

        IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export, SalesInvoiceHeader."GST Customer Type"::"SEZ Development", SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
            SendSalesInvExportDetails(SalesInvoiceHeader);
            JsonObjectHeaderExpDet.Add('ship_bill_number', ship_bill_number);
            JsonObjectHeaderExpDet.Add('ship_bill_date', ship_bill_date);
            JsonObjectHeaderExpDet.Add('country_code', country_code);
            JsonObjectHeaderExpDet.Add('foreign_currency', foreign_currency);
            JsonObjectHeaderExpDet.Add('refund_claim', 'N');
            JsonObjectHeaderExpDet.Add('port_code', port_code);
            JsonObjectHeaderExpDet.Add('export_duty', export_duty);
            JsonObjectHeader.Add('export_details', JsonObjectHeaderExpDet);
        end;

        JsonObjectHeaderPmntDet.Add('bank_account_number', '');
        JsonObjectHeaderPmntDet.Add('paid_balance_amount', 0);
        JsonObjectHeaderPmntDet.Add('credit_days', 0);
        JsonObjectHeaderPmntDet.Add('credit_transfer', '');
        JsonObjectHeaderPmntDet.Add('direct_debit', '');
        JsonObjectHeaderPmntDet.Add('branch_or_ifsc', '');
        JsonObjectHeaderPmntDet.Add('payment_mode', '');
        JsonObjectHeaderPmntDet.Add('payee_name', '');
        JsonObjectHeaderPmntDet.Add('payment_due_date', '');
        JsonObjectHeaderPmntDet.Add('payment_instruction', '');
        JsonObjectHeaderPmntDet.Add('payment_term', '');
        JsonObjectHeader.Add('payment_details', JsonObjectHeaderPmntDet);

        JsonObjectAddDocDtls.Add('supporting_document_url', '');
        JsonObjectAddDocDtls.Add('supporting_document', '');
        JsonObjectAddDocDtls.Add('additional_information', '');
        JsonArrayAddDocDtls.Add(JsonObjectAddDocDtls);
        JsonObjectHeader.Add('additional_document_details', JsonArrayAddDocDtls);

        SendSalesInvValueDetails(SalesInvoiceHeader);
        JsonObjectValueDet.Add('total_assessable_value', SIValueDetTotAssVal);
        JsonObjectValueDet.Add('total_cgst_value', SIValueDetCGSTVal);
        JsonObjectValueDet.Add('total_sgst_value', SIValueDetSGSTVal);
        JsonObjectValueDet.Add('total_igst_value', SIValueDetIGSTVal);
        //JsonObjectValueDet.Add('total_cess_value', SIValueDetTotCessVal);         //to be assigned to 0
        JsonObjectValueDet.Add('total_cess_value', 0);
        JsonObjectValueDet.Add('total_cess_nonadvol_value', SIValueDetCesNonAdval);
        JsonObjectValueDet.Add('total_discount', 0);
        JsonObjectValueDet.Add('total_other_charge', SIValueDetOthrChrg);
        JsonObjectValueDet.Add('total_invoice_value', SIValueDetTotInvVal);
        //JsonObjectValueDet.Add('total_cess_value_of_state', SIValueDetTotCesValOfState);      //to be assigned to 0
        JsonObjectValueDet.Add('total_cess_value_of_state', 0);
        JsonObjectValueDet.Add('round_off_amount', SIValueDetRoundOffAmt);
        JsonObjectValueDet.Add('total_invoice_value_additional_currency', 0);
        JsonObjectHeader.Add('value_details', JsonObjectValueDet);

        i := 1;
        SalesInvoiceLineRec.Reset();
        SalesInvoiceLineRec.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLineRec.SETFILTER(Quantity, '<>%1', 0);
        SalesInvoiceLineRec.SETFILTER("No.", '<>%1', '427000210');
        if SalesInvoiceLineRec.FindFirst() then begin
            repeat
                Clear(JsonObjectLine);
                Clear(JsonObjectBatchDet);
                SendSalesInvItemDetails(SalesInvoiceHeader, SalesInvoiceLineRec);
                JsonObjectLine.Add('item_serial_number', SalesInvoiceLineRec."Line No.");
                JsonObjectLine.Add('product_description', SalesInvoiceLineRec.Description);
                JsonObjectLine.Add('is_service', SIItemIsService);
                JsonObjectLine.Add('hsn_code', SalesInvoiceLineRec."HSN/SAC Code");
                JsonObjectLine.Add('bar_code', '');
                JsonObjectLine.Add('quantity', SalesInvoiceLineRec.Quantity);
                JsonObjectLine.Add('free_quantity', 0);
                JsonObjectLine.Add('unit', COPYSTR(SalesInvoiceLineRec."Unit of Measure Code", 1, 3));
                JsonObjectLine.Add('unit_price', ROUND(SalesInvoiceLineRec."Unit Price" / SIItemCurrFector, 0.01) + 0);
                JsonObjectLine.Add('total_amount', ROUND((SalesInvoiceLineRec.Quantity * SalesInvoiceLineRec."Unit Price") / SIItemCurrFector, 0.01) + 0);//ask ramesh g 
                JsonObjectLine.Add('pre_tax_value', SIItemPreTaxValue);
                JsonObjectLine.Add('discount', ROUND(SalesInvoiceLineRec."Line Discount Amount" / SIItemCurrFector, 0.01) + ROUND(SalesInvoiceLineRec."Inv. Discount Amount" / SIItemCurrFector, 0.01) + 0);      //ask ramesh g
                JsonObjectLine.Add('other_charge', 0);
                JsonObjectLine.Add('assessable_value', SIItemAssValue);
                JsonObjectLine.Add('gst_rate', SIItemGSTPer);
                JsonObjectLine.Add('igst_amount', SIItemIGSTRt);
                JsonObjectLine.Add('cgst_amount', SIItemCGSTRt);
                JsonObjectLine.Add('sgst_amount', SIItemSGSTRt);
                JsonObjectLine.Add('cess_rate', SIItemCesRt);
                JsonObjectLine.Add('cess_amount', SIItemCesAmt);
                JsonObjectLine.Add('cess_nonadvol_amount', SIItemCesNonAdval);
                JsonObjectLine.Add('state_cess_rate', SIItemStateCes);
                JsonObjectLine.Add('state_cess_amount', 0);
                JsonObjectLine.Add('state_cess_nonadvol_amount', 0);
                JsonObjectLine.Add('total_item_value', SIItemTotItemVal);
                JsonObjectLine.Add('country_origin', 91);
                JsonObjectLine.Add('order_line_reference', '');
                JsonObjectLine.Add('product_serial_number', '');

                SendSalesInvBatchDetails(SalesInvoiceLineRec);
                JsonObjectBatchDet.Add('name', SIBatchName);
                JsonObjectBatchDet.Add('expiry_date', SIBatchExpDate);
                JsonObjectBatchDet.Add('warranty_date', SIBatchWarrDate);
                JsonObjectLine.Add('batch_details', JsonObjectBatchDet);

                i := i + 1;
                JsonArrayLine.Add(JsonObjectLine);
            until SalesInvoiceLineRec.Next() = 0;
        end;
        JsonObjectHeader.Add('item_list', JsonArrayLine);

        JSONText := Format(JsonObjectHeader);
        Message('Generate E-Invoice : ' + Format(JSONText));

        EinvoiceHttpContent.WriteFrom(JSONText);
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', accesstoken));
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri('https://sandb-api.mastersindia.co/api/v1/einvoice/');
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Return Value of Generate E-Invoice : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultToken.IsObject then begin
                    JResultToken.WriteTo(OutputMessage);
                    JOutputObject.ReadFrom(OutputMessage);
                    JOutputObject.Get('code', JOutputToken);
                    StatusCode := JOutputToken.AsValue().AsText();
                    JOutputObject.Get('InfoDtls', JOutputToken);
                    InfoDtls := JOutputToken.AsValue().AsText();
                    JOutputObject.Get('status', JOutputToken);
                    status := JOutputToken.AsValue().AsText();
                    JOutputObject.Get('requestId', JOutputToken);
                    requestId := JOutputToken.AsValue().AsText();
                    if StatusCode = '200' then begin
                        if JOutputObject.Get('message', JOutputToken) then begin
                            Clear(OutputMessage);
                            JOutputToken.WriteTo(OutputMessage);
                            JOutputObject1.ReadFrom(OutputMessage);
                            JOutputObject1.Get('AckNo', JOutputToken1);
                            AckNo := JOutputToken1.AsValue().AsText();
                            JOutputObject1.Get('AckDt', JOutputToken1);
                            AckDt := JOutputToken1.AsValue().AsText();
                            JOutputObject1.Get('Irn', JOutputToken1);
                            Irn := JOutputToken1.AsValue().AsText();
                            JOutputObject1.Get('SignedQRCode', JOutputToken1);
                            SignedQRCode := JOutputToken1.AsValue().AsText();
                            JOutputObject1.Get('QRCodeUrl', JOutputToken1);
                            QRCodeUrl := JOutputToken1.AsValue().AsText();
                            JOutputObject1.Get('EinvoicePdf', JOutputToken1);
                            EinvoicePdf := JOutputToken1.AsValue().AsText();
                        end;
                        if SignedQRCode <> '' then begin
                            Clear(RecRef);
                            RecRef.Get(SalesInvoiceHeader.RecordId);
                            if QRGenerator.GenerateQRCodeImage(SignedQRCode, TempBlob) then begin
                                if TempBlob.HasValue() then begin
                                    FldRef := RecRef.Field(SalesInvoiceHeader.FieldNo("QR Code"));
                                    TempBlob.ToRecordRef(RecRef, SalesInvoiceHeader.FieldNo("QR Code"));
                                    RecRef.Field(SalesInvoiceHeader.FieldNo("IRN Hash")).Value := Irn;
                                    RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement No.")).Value := AckNo;
                                    Evaluate(AckDtTimeVar, AckDt);
                                    RecRef.Field(SalesInvoiceHeader.FieldNo("Acknowledgement Date")).Value := AckDtTimeVar;
                                    RecRef.Modify();
                                end;
                            end;
                        end;
                        recResponseLog.INIT;
                        recResponseLog."Document No." := SalesInvoiceHeader."No.";
                        recResponseLog."Response Date" := TODAY;
                        recResponseLog."Response Time" := TIME;
                        recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                        recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                        recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                        recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                        recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                        recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                        recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                        recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                        recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                        recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                        recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                        recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                        recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                        recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                        recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                        recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                        recResponseLog.Status := 'Success';
                        recResponseLog."Called API" := 'Generate IRN';
                        recResponseLog.INSERT;

                        EWayBillandEinvoice.RESET();
                        EWayBillandEinvoice.SETRANGE("No.", SalesInvoiceHeader."No.");
                        IF EWayBillandEinvoice.FindFirst() THEN BEGIN
                            EWayBillandEinvoice.VALIDATE("E-Invoice IRN No", IRN);
                            EWayBillandEinvoice.VALIDATE("E-Invoice Acknowledge No.", AckNo);
                            EWayBillandEinvoice.VALIDATE("E-Invoice Acknowledge Date", AckDt);
                            EWayBillandEinvoice."E-Invoice QR Code" := QRCodeUrl;
                            EWayBillandEinvoice."E-Invoice PDF" := EinvoicePdf;
                            EWayBillandEinvoice."E-Invoice IRN Status" := Status;
                            //EWayBillandEinvoice.VALIDATE("E-Invoice Cancel Date", '');
                            EWayBillandEinvoice."E-Invoice Cancel Reason" := EWayBillandEinvoice."E-Invoice Cancel Reason"::" ";
                            EWayBillandEinvoice."E-Invoice Cancel Remarks" := '';
                            EWayBillandEinvoice."E-Invoice Status" := Status + ' ' + StatusCode;
                            EWayBillandEinvoice.MODIFY;
                        END;
                    end else begin
                        JOutputObject.Get('errorMessage', JOutputToken);
                        errorMessage := JOutputToken.AsValue().AsText();
                        recResponseLog.INIT;
                        recResponseLog."Document No." := SalesInvoiceHeader."No.";
                        recResponseLog."Response Date" := TODAY;
                        recResponseLog."Response Time" := TIME;
                        recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                        recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                        recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                        recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                        recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                        recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                        recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                        recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                        recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                        recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                        recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                        recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                        recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                        recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                        recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                        recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                        recResponseLog.Status := 'Failure';
                        recResponseLog."Called API" := 'Generate IRN';
                        recResponseLog.INSERT;

                        EWayBillandEinvoice.RESET();
                        EWayBillandEinvoice.SETRANGE("No.", SalesInvoiceHeader."No.");
                        IF EWayBillandEinvoice.FindFirst() THEN
                            EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + StatusCode;
                        MESSAGE('Error Message : ' + errorMessage);
                        EWayBillandEinvoice.MODIFY;
                    end;
                end;
            end;
        end;
    end;

    procedure CanceSalesInvEInvoice(DocNo: Code[20]; EinvoiceBillNo: Code[200])
    var
        JsonObjectHeader: JsonObject;
        recEinvoice: Record 50000;
        JSONText: Text;
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JResultObject: JsonObject;
        JResultToken: JsonToken;
        OutputMessage: Text;
        JOutputObject: JsonObject;
        JOutputObject1: JsonObject;
        JOutputToken: JsonToken;
        JOutputToken1: JsonToken;
        ResultMessage: Text;
        ResponseCode: Text;
        AckNo: Text;
        AckDt: Text;
        AckDtTimeVar: DateTime;
        Irn: Text;
        SignedInvoice: Text;
        SignedQRCode: Text;
        errorMessage: Text;
        InfoDtls: Text;
        status: Text;
        StatusCode: Text;
        requestId: Text;
        QRCodeUrl: Text;
        EinvoicePdf: Text;
        QRGenerator: Codeunit "QR Generator";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        FldRef: FieldRef;
        recResponseLog: Record "Response Logs";
        EWayBillandEinvoice: Record "E-Way Bill & E-Invoice";
    begin
        Clear(accesstoken);
        AuthenticateCredentials(DocNo);
        recEinvoice.RESET();
        recEinvoice.SETRANGE("No.", DocNo);
        IF recEinvoice.FindFirst then;
        JsonObjectHeader.Add('access_token', accesstoken);
        //JsonObjectHeader.Add('user_gstin', recEinvoice."Location GST Reg. No.");
        JsonObjectHeader.Add('user_gstin', '09AAAPG7885R002');
        JsonObjectHeader.Add('irn', recEinvoice."E-Invoice IRN No");
        IF recEinvoice."E-Invoice Cancel Reason" = recEinvoice."E-Invoice Cancel Reason"::"Wrong entry" THEN
            JsonObjectHeader.Add('cancel_reason', '1');
        JsonObjectHeader.Add('cancel_remarks', FORMAT(recEinvoice."E-Invoice Cancel Remarks"));

        JSONText := Format(JsonObjectHeader);
        Message('Cancel E-Invoice : ' + Format(JSONText));

        EinvoiceHttpContent.WriteFrom(JSONText);
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', accesstoken));
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri('https://sandb-api.mastersindia.co/api/v1/cancel-einvoice/');
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Return Value of Cancel E-Invoice : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultToken.IsObject then begin
                    JResultToken.WriteTo(OutputMessage);
                    JOutputObject.ReadFrom(OutputMessage);
                    JOutputObject.Get('code', JOutputToken);
                    StatusCode := JOutputToken.AsValue().AsText();
                    JOutputObject.Get('status', JOutputToken);
                    status := JOutputToken.AsValue().AsText();
                    if StatusCode = '200' then begin
                        if JOutputObject.Get('message', JOutputToken) then begin
                            Clear(OutputMessage);
                            JOutputToken.WriteTo(OutputMessage);
                            JOutputObject1.ReadFrom(OutputMessage);
                            JOutputObject1.Get('Irn', JOutputToken1);
                            AckNo := JOutputToken1.AsValue().AsText();
                            JOutputObject1.Get('CancelDate', JOutputToken1);
                            AckDt := JOutputToken1.AsValue().AsText();
                        end;
                        recResponseLog.INIT;
                        recResponseLog."Document No." := DocNo;
                        recResponseLog."Response Date" := TODAY;
                        recResponseLog."Response Time" := TIME;
                        recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                        recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                        recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                        recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                        recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                        recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                        recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                        recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                        recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                        recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                        recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                        recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                        recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                        recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                        recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                        recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                        recResponseLog.Status := 'Success';
                        recResponseLog."Called API" := 'Cancel IRN';
                        recResponseLog.INSERT;

                        EWayBillandEinvoice.RESET();
                        EWayBillandEinvoice.SETRANGE("No.", DocNo);
                        //EWayBillandEinvoice.SETRANGE("E-Invoice IRN No", EinvoiceBillNo);
                        IF EWayBillandEinvoice.FindFirst() THEN BEGIN
                            EWayBillandEinvoice.VALIDATE("E-Invoice Cancel Date", AckDt);
                            EWayBillandEinvoice."E-Invoice Status" := Status + ' ' + StatusCode;
                            EWayBillandEinvoice.MODIFY;
                        END;
                    end else begin
                        JOutputObject.Get('errorMessage', JOutputToken);
                        errorMessage := JOutputToken.AsValue().AsText();
                        recResponseLog.INIT;
                        recResponseLog."Document No." := DocNo;
                        recResponseLog."Response Date" := TODAY;
                        recResponseLog."Response Time" := TIME;
                        recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                        recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                        recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                        recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                        recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                        recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                        recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                        recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                        recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                        recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                        recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                        recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                        recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                        recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                        recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                        recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                        recResponseLog.Status := 'Failure';
                        recResponseLog."Called API" := 'Cancel IRN';
                        recResponseLog.INSERT;

                        EWayBillandEinvoice.RESET();
                        EWayBillandEinvoice.SETRANGE("No.", DocNo);
                        IF EWayBillandEinvoice.FindFirst() THEN
                            EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + StatusCode;
                        MESSAGE('Error Message : ' + errorMessage);
                        EWayBillandEinvoice.MODIFY;
                    end;
                end;
            end;
        end;
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

    procedure SendSalesInvTransactionDetails(SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
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
            IF (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Registered) or (SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Exempted) THEN
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

    procedure SendSalesInvBatchDetails(SILRec: Record "Sales Invoice Line")
    var
        recVE: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SIBatchName := '';
        SIBatchExpDate := '';
        SIBatchWarrDate := '';
        recVE.Reset();
        //recVE.SetCurrentKey("Item Ledger Entry No.", "Document No.", "Document Line No.");
        recVE.SETRANGE("Document No.", SILRec."Document No.");
        recVE.SETRANGE("Document Line No.", SILRec."Line No.");
        IF recVE.FindFirst() THEN BEGIN
            repeat
                ItemLedgerEntry.GET(recVE."Item Ledger Entry No.");
                SIBatchName := COPYSTR(ItemLedgerEntry."Lot No." + ItemLedgerEntry."Serial No.", 1, 20);
                SIBatchExpDate := FORMAT(ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>');
                SIBatchWarrDate := FORMAT(ItemLedgerEntry."Warranty Date", 0, '<Day,2>/<Month,2>/<Year4>');
            until recVE.Next() = 0;
        END;
    end;

    procedure SendSalesInvItemDetails(SIHRec: Record "Sales Invoice Header"; SILRec: Record "Sales Invoice Line")
    var
        recDetailedGSTLedEntry: Record "Detailed GST Ledger Entry";
    begin
        SIItemIsService := '';
        SIItemCurrFector := 0;
        SIItemPreTaxValue := 0;
        SIItemAssValue := 0;
        SIItemGSTPer := 0;
        SIItemCGSTRt := 0;
        SIItemSGSTRt := 0;
        SIItemIGSTRt := 0;
        SIItemCesRt := 0;
        SIItemCesAmt := 0;
        SIItemCesNonAdval := 0;
        SIItemStateCes := 0;
        SIItemTotItemVal := 0;
        IF SILRec."GST Group Type" = SILRec."GST Group Type"::Goods THEN
            SIItemIsService := 'N'
        ELSE
            SIItemIsService := 'Y';
        IF SIHRec."Currency Code" = '' THEN
            SIItemCurrFector := 1
        ELSE
            SIItemCurrFector := SIHRec."Currency Factor";
        recDetailedGSTLedEntry.RESET();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", SILRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", SILRec."Line No.");
        IF recDetailedGSTLedEntry.FINDFIRST THEN BEGIN
            //repeat
            SIItemPreTaxValue := ABS(recDetailedGSTLedEntry."GST Base Amount");
            //until recDetailedGSTLedEntry.Next() = 0;
        END;
        IF SILRec."GST Assessable Value (LCY)" <> 0 THEN
            SIItemAssValue := SILRec."GST Assessable Value (LCY)"
        ELSE
            SIItemAssValue := CU50200.GetGSTBaseAmtPostedLine(SILRec."Document No.", SILRec."Line No.");
        SIItemGSTPer := CU50200.GetGSTPerPostedLine(SILRec."Document No.", SILRec."Line No.");
        SIItemIGSTRt := CU50200.GetIGSTAmtPostedLine(SILRec."Document No.", SILRec."Line No.");
        SIItemSGSTRt := CU50200.GetSGSTAmtPostedLine(SILRec."Document No.", SILRec."Line No.");
        SIItemCGSTRt := CU50200.GetCGSTAmtPostedLine(SILRec."Document No.", SILRec."Line No.");

        recDetailedGSTLedEntry.Reset();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", SILRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", SILRec."Line No.");
        recDetailedGSTLedEntry.SETRANGE("GST Component Code", 'CESS');
        IF recDetailedGSTLedEntry.FINDFIRST THEN begin
            IF recDetailedGSTLedEntry."GST %" > 0 THEN
                SIItemCesRt := recDetailedGSTLedEntry."GST %"
            ELSE
                SIItemCesNonAdval := ABS(recDetailedGSTLedEntry."GST Amount");
        end;
        recDetailedGSTLedEntry.Reset();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", SILRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", SILRec."Line No.");
        recDetailedGSTLedEntry.SETRANGE("GST Component Code", 'INTERCESS');
        IF recDetailedGSTLedEntry.FINDFIRST THEN
            SIItemCesRt := recDetailedGSTLedEntry."GST %";

        recDetailedGSTLedEntry.Reset();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", SILRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", SILRec."Line No.");
        IF recDetailedGSTLedEntry.FINDSET THEN
            REPEAT
                IF NOT (recDetailedGSTLedEntry."GST Component Code" IN ['CGST', 'SGST', 'IGST', 'CESS', 'INTERCESS'])
                THEN
                    SIItemStateCes := recDetailedGSTLedEntry."GST %";
            UNTIL recDetailedGSTLedEntry.NEXT = 0;

        SIItemTotItemVal := CU50200.GetAmttoCustomerPostedLine(SILRec."Document No.", SILRec."Line No.");
    end;

    procedure SendSalesInvValueDetails(SIHRec: Record "Sales Invoice Header")
    var
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
        GSTLedgerEntry: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        recTCSEntry: Record "TCS Entry";
    begin
        SIValueDetCurrFactor := 0;
        SIValueDetCGSTVal := 0;
        SIValueDetSGSTVal := 0;
        SIValueDetIGSTVal := 0;
        SIValueDetTotCessVal := 0;
        SIValueDetCesNonAdval := 0;
        SIValueDetOthrChrg := 0;
        SIValueDetTotInvVal := 0;
        SIValueDetTotCesValOfState := 0;
        SIValueDetRoundOffAmt := 0;
        SIValueDetTotAssVal := 0;
        if recSalesInvHead.Get(SIHRec."No.") then begin
            IF recSalesInvHead."Currency Code" = '' THEN
                SIValueDetCurrFactor := 1
            ELSE
                SIValueDetCurrFactor := recSalesInvHead."Currency Factor";
        END;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetCGSTVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        end;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetSGSTVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        END;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetIGSTVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        END;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'INTERCESS');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetTotCessVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        end;
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CESS');
        IF DetailedGSTLedgerEntry.FINDFIRST THEN begin
            REPEAT
                IF DetailedGSTLedgerEntry."GST %" > 0 THEN
                    SIValueDetTotCessVal += ABS(DetailedGSTLedgerEntry."GST Amount")
                ELSE
                    SIValueDetCesNonAdval += ABS(DetailedGSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        end;
        recTCSEntry.RESET;
        recTCSEntry.SETRANGE("Document No.", SIHRec."No.");
        IF recTCSEntry.FindFirst() THEN
            SIValueDetOthrChrg := recTCSEntry."TCS Amount";
        IF recSalesInvHead."GST Customer Type" = recSalesInvHead."GST Customer Type"::Export THEN BEGIN
            GSTLedgerEntry.RESET();
            GSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
            IF GSTLedgerEntry.FINDFIRST THEN
                SIValueDetTotInvVal := ABS(GSTLedgerEntry."GST Base Amount" + GSTLedgerEntry."GST Amount");
        END;
        IF recSalesInvHead."GST Customer Type" <> recSalesInvHead."GST Customer Type"::Export THEN BEGIN
            recSalesInvLine.RESET;
            recSalesInvLine.SETRANGE("Document No.", SIHRec."No.");
            IF recSalesInvLine.FindFirst() THEN BEGIN
                REPEAT
                    SIValueDetTotInvVal += CU50200.GetAmttoCustomerPostedLine(recSalesInvLine."Document No.", recSalesInvLine."Line No.");
                UNTIL recSalesInvLine.NEXT = 0;
            END;
        END;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        GSTLedgerEntry.SETFILTER("GST Component Code", '<>CGST|<>SGST|<>IGST|<>CESS|<>INTERCESS');
        IF GSTLedgerEntry.FindFirst() THEN BEGIN
            REPEAT
                SIValueDetTotCesValOfState += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        END;
        recSalesInvLine.RESET();
        recSalesInvLine.SETRANGE("Document No.", SIHRec."No.");
        recSalesInvLine.SETRANGE(Type, recSalesInvLine.Type::"G/L Account");
        recSalesInvLine.SETRANGE("No.", '427000210');
        IF recSalesInvLine.FindFirst() THEN
            SIValueDetRoundOffAmt := ROUND(recSalesInvLine.Amount / SIValueDetCurrFactor, 0.01);
        DetailedGSTLedgerEntry.RESET;
        DetailedGSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        DetailedGSTLedgerEntry.SETFILTER("GST Jurisdiction Type", 'Interstate');
        IF DetailedGSTLedgerEntry.FindFirst() THEN BEGIN
            REPEAT
                SIValueDetTotAssVal += ABS(DetailedGSTLedgerEntry."GST Base Amount");
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        END;
        DetailedGSTLedgerEntry.RESET;
        DetailedGSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
        DetailedGSTLedgerEntry.SETFILTER("GST Jurisdiction Type", 'Intrastate');
        IF DetailedGSTLedgerEntry.FindFirst() THEN BEGIN
            REPEAT
                SIValueDetTotAssVal += ABS(DetailedGSTLedgerEntry."GST Base Amount") / 2;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        END;
        IF SIValueDetTotAssVal = 0 THEN begin
            IF recSalesInvHead."GST Customer Type" = recSalesInvHead."GST Customer Type"::Export THEN BEGIN
                DetailedGSTLedgerEntry.RESET();
                DetailedGSTLedgerEntry.SETRANGE("Document No.", SIHRec."No.");
                IF DetailedGSTLedgerEntry.FINDFIRST THEN
                    SIValueDetTotAssVal := ABS(DetailedGSTLedgerEntry."GST Base Amount" + DetailedGSTLedgerEntry."GST Amount");
            END;
            IF recSalesInvHead."GST Customer Type" <> recSalesInvHead."GST Customer Type"::Export THEN BEGIN
                recSalesInvLine.RESET;
                recSalesInvLine.SETRANGE("Document No.", SIHRec."No.");
                IF recSalesInvLine.FindFirst() THEN BEGIN
                    REPEAT
                        SIValueDetTotAssVal += CU50200.GetAmttoCustomerPostedLine(recSalesInvLine."Document No.", recSalesInvLine."Line No.")
                    UNTIL
                  recSalesInvLine.NEXT = 0;
                END;
            END;
        end;
    end;

    procedure SendSalesInvExportDetails(SIHRec: Record "Sales Invoice Header")
    var
        RecCountry: Record "Country/Region";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        ship_bill_number := '';
        ship_bill_date := '';
        port_code := '';
        country_code := '';
        foreign_currency := '';
        export_duty := '';
        IF SIHRec."GST Customer Type" IN ["GST Customer Type"::Export, "GST Customer Type"::"Deemed Export", "GST Customer Type"::"SEZ Unit", "GST Customer Type"::"SEZ Development"] THEN BEGIN
            ship_bill_number := COPYSTR(SIHRec."Bill Of Export No.", 1, 16);
            ship_bill_date := FORMAT(SIHRec."Bill Of Export Date", 0, '<Day,2>/<Month,2>/<Year4>');
            port_code := SIHRec."Exit Point";
            foreign_currency := COPYSTR(SIHRec."Currency Code", 1, 3);
            export_duty := Format(CU50200.TotalGSTAmtDoc(SIHRec."No."));
            IF RecCountry.GET(SIHRec."Bill-to Country/Region Code") THEN
                country_code := COPYSTR(SIHRec."Bill-to Country/Region Code", 1, 2)
            ELSE
                country_code := '';
        end;
    end;

    var
        CU50200: Codeunit 50200;
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
        SIBatchName: Code[50];
        SIBatchExpDate: Text[50];
        SIBatchWarrDate: Text[50];
        SIItemIsService: Text[5];
        SIItemCurrFector: Decimal;
        SIItemPreTaxValue: Decimal;
        SIItemAssValue: Decimal;
        SIItemGSTPer: Decimal;
        SIItemCGSTRt: Decimal;
        SIItemSGSTRt: Decimal;
        SIItemIGSTRt: Decimal;
        SIItemCesRt: Decimal;
        SIItemCesAmt: Decimal;
        SIItemCesNonAdval: Decimal;
        SIItemStateCes: Decimal;
        SIItemTotItemVal: Decimal;
        SIValueDetCurrFactor: Decimal;
        SIValueDetCGSTVal: Decimal;
        SIValueDetSGSTVal: Decimal;
        SIValueDetIGSTVal: Decimal;
        SIValueDetTotCessVal: Decimal;
        SIValueDetCesNonAdval: Decimal;
        SIValueDetOthrChrg: Decimal;
        SIValueDetTotInvVal: Decimal;
        SIValueDetTotCesValOfState: Decimal;
        SIValueDetRoundOffAmt: Decimal;
        SIValueDetTotAssVal: Decimal;
        ship_bill_number: Text;
        ship_bill_date: Text;
        country_code: Text;
        foreign_currency: Text;
        port_code: Text;
        export_duty: Text;
}