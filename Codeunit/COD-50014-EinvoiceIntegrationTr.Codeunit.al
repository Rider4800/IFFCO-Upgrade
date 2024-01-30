codeunit 50014 EInvoiceIntegrationTr
{
    Permissions = tabledata "Transfer Shipment Header" = rimd;
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

    procedure CreateJsonTransferShipOrder(TransferShipHeaderRec: Record "Transfer Shipment Header")
    var
        JsonObjectHeader: JsonObject;
        JsonObjectHeaderTransDet: JsonObject;
        JsonObjectHeaderDocDet: JsonObject;
        JsonObjectHeaderSellerDet: JsonObject;
        JsonObjectHeaderBuyerDet: JsonObject;
        JsonObjectHeaderDispatchDet: JsonObject;
        JsonObjectHeaderShipDet: JsonObject;
        JsonObjectHeaderExpDet: JsonObject;
        JsonObjectHeaderPmntDet: JsonObject;
        JsonObjectAddDocDtls: JsonObject;
        JsonObjectEWayBillDtls: JsonObject;
        JsonArrayAddDocDtls: JsonArray;
        JsonObjectValueDet: JsonObject;
        JsonObjectLine: JsonObject;
        JsonObjectBatchDet: JsonObject;
        JsonArrayBatchDet: JsonArray;
        JsonArrayLine: JsonArray;
        TransShipLineRec: Record "Transfer Shipment Line";
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
        EInvoiceIntegration: Record "E-Way Bill & E-Invoice";
        LocationBuff: Record Location;
        StateBuff: Record State;
        T50000: Record 50000;
        SalesLinesErr: Label 'E-Invoice allowes only 100 lines per Invoice. Curent transaction is having %1 lines.';
        InstreamVar: InStream;
        ToFileName: Variant;
    begin
        AuthenticateCredentials(TransferShipHeaderRec."No.");
        CompInfoRec.Get();
        LocRec.Get(TransferShipHeaderRec."Transfer-from Code");

        EInvoiceIntegration.GET(TransferShipHeaderRec."No.");
        JsonObjectHeader.Add('access_token', accesstoken);
        //JsonObjectHeader.Add('user_gstin', EInvoiceIntegration."Location GST Reg. No."); //For production
        JsonObjectHeader.Add('user_gstin', '09AAAPG7885R002');                           //For Sandbox
        JsonObjectHeader.Add('data_source', 'erp');

        JsonObjectHeaderTransDet.Add('supply_type', 'B2B');
        JsonObjectHeaderTransDet.Add('charge_type', 'N');
        JsonObjectHeaderTransDet.Add('igst_on_intra', 'N');
        JsonObjectHeaderTransDet.Add('ecommerce_gstin', '');
        JsonObjectHeader.Add('transaction_details', JsonObjectHeaderTransDet);

        JsonObjectHeaderDocDet.Add('document_type', 'INV');
        JsonObjectHeaderDocDet.Add('document_number', TransferShipHeaderRec."No.");
        JsonObjectHeaderDocDet.Add('document_date', FORMAT(TransferShipHeaderRec."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'));
        JsonObjectHeader.Add('document_details', JsonObjectHeaderDocDet);

        SendSalesInvSellerDetails(TransferShipHeaderRec."Transfer-from Code");
        //JsonObjectHeaderSellerDet.Add('gstin', LocRec."GST Registration No.");                    //For production
        JsonObjectHeaderSellerDet.Add('gstin', '09AAAPG7885R002');                                  //For sandbox
        JsonObjectHeaderSellerDet.Add('legal_name', LocRec.Name);
        JsonObjectHeaderSellerDet.Add('trade_name', LocRec.Name);
        JsonObjectHeaderSellerDet.Add('address1', LocRec.Address);
        JsonObjectHeaderSellerDet.Add('address2', LocRec."Address 2");
        JsonObjectHeaderSellerDet.Add('location', LocRec.City);
        //JsonObjectHeaderSellerDet.Add('pincode', COPYSTR(LocRec."Post Code", 1, 6));              //For productoin
        JsonObjectHeaderSellerDet.Add('pincode', 201301);                                           //For sandbox
        //JsonObjectHeaderSellerDet.Add('state_code', SIStateCodeDesc);                             //For productoin
        JsonObjectHeaderSellerDet.Add('state_code', 'Uttar Pradesh');                               //For sandbox
        JsonObjectHeaderSellerDet.Add('phone_number', COPYSTR(LocRec."Phone No.", 1, 10));
        JsonObjectHeaderSellerDet.Add('email', COPYSTR(LocRec."E-Mail", 1, 50));
        JsonObjectHeader.Add('seller_details', JsonObjectHeaderSellerDet);

        //JsonObjectHeaderBuyerDet.Add('gstin', LocRec."GST Registration No.");                     //For production
        JsonObjectHeaderBuyerDet.Add('gstin', '05AAAPG7885R002');                                   //For sandbox
        JsonObjectHeaderBuyerDet.Add('legal_name', LocRec.Name);
        JsonObjectHeaderBuyerDet.Add('trade_name', LocRec.Name);
        JsonObjectHeaderBuyerDet.Add('address1', LocRec.Address);
        JsonObjectHeaderBuyerDet.Add('address2', LocRec."Address 2");
        JsonObjectHeaderBuyerDet.Add('location', LocRec.City);
        //JsonObjectHeaderBuyerDet.Add('pincode', COPYSTR(LocRec."Post Code", 1, 6));               //For production                                                                                 //For production
        JsonObjectHeaderBuyerDet.Add('pincode', 263001);                                            //For sandbox
        IF StateBuff.GET(LocRec."State Code") then;
        JsonObjectHeaderBuyerDet.Add('place_of_supply', StateBuff."State Code (GST Reg. No.)");
        //JsonObjectHeaderBuyerDet.Add('state_code', StateBuff.Description);                        //For production
        JsonObjectHeaderBuyerDet.Add('state_code', 'Uttarakhand');                                  //For sandbox
        JsonObjectHeaderBuyerDet.Add('phone_number', COPYSTR(LocRec."Phone No.", 1, 10));
        JsonObjectHeaderBuyerDet.Add('email', COPYSTR(LocRec."E-Mail", 1, 50));
        JsonObjectHeader.Add('buyer_details', JsonObjectHeaderBuyerDet);

        //JsonObjectHeaderDispatchDet.Add('gstin', 'GSTIN :');
        JsonObjectHeaderDispatchDet.Add('company_name', LocRec.Name);
        JsonObjectHeaderDispatchDet.Add('address1', LocRec.Address);
        JsonObjectHeaderDispatchDet.Add('address2', LocRec."Address 2");
        JsonObjectHeaderDispatchDet.Add('location', LocRec.City);
        //JsonObjectHeaderDispatchDet.Add('pincode', LocRec."Post Code");                   //For production
        JsonObjectHeaderDispatchDet.Add('pincode', 201301);                                 //For sandbox
        IF StateBuff.GET(LocRec."State Code") then;
        //JsonObjectHeaderDispatchDet.Add('state_code', StateBuff.Description);             //For production
        JsonObjectHeaderDispatchDet.Add('state_code', 'Uttar Pradesh');                     //For sandbox
        JsonObjectHeader.Add('dispatch_details', JsonObjectHeaderDispatchDet);

        //JsonObjectHeaderShipDet.Add('gstin', LocRec."GST Registration No.");              //For production
        JsonObjectHeaderShipDet.Add('gstin', '05AAAPG7885R002');                            //For sandbox
        JsonObjectHeaderShipDet.Add('legal_name', LocRec.Name);
        JsonObjectHeaderShipDet.Add('trade_name', LocRec.Name);
        JsonObjectHeaderShipDet.Add('address1', LocRec.Address);
        JsonObjectHeaderShipDet.Add('address2', LocRec."Address 2");
        JsonObjectHeaderShipDet.Add('location', LocRec.City);
        //JsonObjectHeaderShipDet.Add('pincode', COPYSTR(LocRec."Post Code", 1, 6));        //For production
        JsonObjectHeaderShipDet.Add('pincode', 263001);                                     //For sandbox
        //JsonObjectHeaderShipDet.Add('state_code', StateBuff.Description);                 //for production            
        JsonObjectHeaderShipDet.Add('state_code', 'UTTARAKHAND');                           //for sandbox
        JsonObjectHeader.Add('ship_details', JsonObjectHeaderShipDet);

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

        SendSalesInvValueDetails(TransferShipHeaderRec);
        JsonObjectValueDet.Add('total_assessable_value', SIValueDetTotAssVal);
        JsonObjectValueDet.Add('total_cgst_value', SIValueDetCGSTVal);
        JsonObjectValueDet.Add('total_sgst_value', SIValueDetSGSTVal);
        JsonObjectValueDet.Add('total_igst_value', SIValueDetIGSTVal);
        JsonObjectValueDet.Add('total_cess_value', 0);
        JsonObjectValueDet.Add('total_cess_nonadvol_value', SIValueDetCesNonAdval);
        JsonObjectValueDet.Add('total_discount', 0);
        JsonObjectValueDet.Add('total_other_charge', 0);
        JsonObjectValueDet.Add('total_invoice_value', SIValueDetTotInvVal);
        JsonObjectValueDet.Add('total_cess_value_of_state', 0);
        JsonObjectValueDet.Add('round_off_amount', 0);
        JsonObjectValueDet.Add('total_invoice_value_additional_currency', 0);
        JsonObjectHeader.Add('value_details', JsonObjectValueDet);

        SendEWayBillDetails(TransferShipHeaderRec);
        JsonObjectEWayBillDtls.Add('transporter_id', transporterid);
        JsonObjectEWayBillDtls.Add('transporter_name', transportername);
        JsonObjectEWayBillDtls.Add('transportation_mode', transportationmode);
        JsonObjectEWayBillDtls.Add('transportation_distance', transportationdistance);
        JsonObjectEWayBillDtls.Add('transporter_document_number', transporterdocumentnumber);
        JsonObjectEWayBillDtls.Add('transporter_document_date', transporterdocumentdate);
        JsonObjectEWayBillDtls.Add('vehicle_number', vehiclenumber);
        JsonObjectEWayBillDtls.Add('vehicle_type', vehicletype);
        JsonObjectHeader.Add('ewaybill_details', JsonObjectEWayBillDtls);

        i := 1;
        TransShipLineRec.Reset();
        TransShipLineRec.SetRange("Document No.", TransferShipHeaderRec."No.");
        TransShipLineRec.SETFILTER(Quantity, '<>%1', 0);
        TransShipLineRec.SETFILTER("Item No.", '<>%1', '427000210');
        if TransShipLineRec.FindFirst() then begin
            repeat
                Clear(JsonObjectLine);
                Clear(JsonObjectBatchDet);
                SendSalesInvItemDetails(TransferShipHeaderRec, TransShipLineRec);
                IF TransShipLineRec.COUNT > 100 THEN
                    ERROR(SalesLinesErr, TransShipLineRec.COUNT);
                JsonObjectLine.Add('item_serial_number', TransShipLineRec."Line No.");
                JsonObjectLine.Add('product_description', TransShipLineRec.Description);
                JsonObjectLine.Add('is_service', 'N');
                JsonObjectLine.Add('hsn_code', COPYSTR(TransShipLineRec."HSN/SAC Code", 1, 8));
                JsonObjectLine.Add('bar_code', '');
                JsonObjectLine.Add('quantity', TransShipLineRec.Quantity);
                JsonObjectLine.Add('free_quantity', 0);
                JsonObjectLine.Add('unit', TransShipLineRec."Unit of Measure Code");
                JsonObjectLine.Add('unit_price', TransShipLineRec."Unit Price");
                JsonObjectLine.Add('total_amount', TransShipLineRec.Amount);
                JsonObjectLine.Add('pre_tax_value', 0);
                JsonObjectLine.Add('discount', 0);
                JsonObjectLine.Add('other_charge', 0);
                JsonObjectLine.Add('assessable_value', TransShipLineRec.Quantity * TransShipLineRec."Unit Price");
                JsonObjectLine.Add('gst_rate', SIItemGSTPer);
                JsonObjectLine.Add('igst_amount', SIItemIGSTRt);
                JsonObjectLine.Add('cgst_amount', SIItemCGSTRt);
                JsonObjectLine.Add('sgst_amount', SIItemSGSTRt);
                JsonObjectLine.Add('cess_rate', SIItemCesRt);
                JsonObjectLine.Add('cess_amount', 0);
                JsonObjectLine.Add('cess_nonadvol_amount', SIItemCesNonAdval);
                JsonObjectLine.Add('state_cess_rate', SIItemStateCes);
                JsonObjectLine.Add('state_cess_amount', 0);
                JsonObjectLine.Add('state_cess_nonadvol_amount', 0);
                JsonObjectLine.Add('total_item_value', SIItemTotItemVal);
                JsonObjectLine.Add('country_origin', 91);
                JsonObjectLine.Add('order_line_reference', '');
                JsonObjectLine.Add('product_serial_number', '');

                SendSalesInvBatchDetails(TransShipLineRec);
                JsonObjectBatchDet.Add('name', SIBatchName);
                JsonObjectBatchDet.Add('expiry_date', SIBatchExpDate);
                JsonObjectBatchDet.Add('warranty_date', SIBatchWarrDate);
                JsonObjectLine.Add('batch_details', JsonObjectBatchDet);

                i := i + 1;
                JsonArrayLine.Add(JsonObjectLine);
            until TransShipLineRec.Next() = 0;
        end;
        JsonObjectHeader.Add('item_list', JsonArrayLine);

        JSONText := Format(JsonObjectHeader);
        Message('Generate E-Invoice : ' + JSONText);

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
                        recResponseLog.INIT;
                        recResponseLog."Document No." := TransferShipHeaderRec."No.";
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
                        EWayBillandEinvoice.SETRANGE("No.", TransferShipHeaderRec."No.");
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
                        if SignedQRCode <> '' then begin
                            Clear(RecRef);
                            RecRef.Get(EWayBillandEinvoice.RecordId);
                            QRGenerator.GenerateQRCodeImage(SignedQRCode, TempBlob);
                            if TempBlob.HasValue() then begin
                                FldRef := RecRef.Field(EWayBillandEinvoice.FieldNo("QR Code"));
                                TempBlob.ToRecordRef(RecRef, EWayBillandEinvoice.FieldNo("QR Code"));
                                RecRef.Modify();
                            end;
                        end;
                    end else begin
                        JOutputObject.Get('errorMessage', JOutputToken);
                        errorMessage := JOutputToken.AsValue().AsText();
                        recResponseLog.INIT;
                        recResponseLog."Document No." := TransferShipHeaderRec."No.";
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
                        EWayBillandEinvoice.SETRANGE("No.", TransferShipHeaderRec."No.");
                        IF EWayBillandEinvoice.FindFirst() THEN
                            EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + StatusCode;
                        MESSAGE('Error Message : ' + errorMessage);
                        EWayBillandEinvoice.MODIFY;
                    end;
                end;
            end;
        end;
    end;

    procedure CanceTransShpmntEInvoice(DocNo: Code[20]; EinvoiceBillNo: Code[200])
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

    procedure SendSalesInvBatchDetails(TSLRec: Record "Transfer Shipment Line")
    var
        recVE: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SIBatchName := '';
        SIBatchExpDate := '';
        SIBatchWarrDate := '';
        recVE.Reset();
        //recVE.SetCurrentKey("Item Ledger Entry No.", "Document No.", "Document Line No.");
        recVE.SETRANGE("Document No.", TSLRec."Document No.");
        recVE.SETRANGE("Document Line No.", TSLRec."Line No.");
        IF recVE.FindFirst() THEN BEGIN
            repeat
                ItemLedgerEntry.GET(recVE."Item Ledger Entry No.");
                SIBatchName := COPYSTR(ItemLedgerEntry."Lot No." + ItemLedgerEntry."Serial No.", 1, 20);
                SIBatchExpDate := FORMAT(ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>');
                SIBatchWarrDate := FORMAT(ItemLedgerEntry."Warranty Date", 0, '<Day,2>/<Month,2>/<Year4>');
            until recVE.Next() = 0;
        END;
    end;

    procedure SendSalesInvItemDetails(TSHRec: Record "Transfer Shipment Header"; TSLRec: Record "Transfer Shipment Line")
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
        recDetailedGSTLedEntry.RESET();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", TSLRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", TSLRec."Line No.");
        IF recDetailedGSTLedEntry.FINDFIRST THEN BEGIN
            //repeat
            SIItemPreTaxValue := ABS(recDetailedGSTLedEntry."GST Base Amount");
            //until recDetailedGSTLedEntry.Next() = 0;
        END;
        SIItemGSTPer := CU50200.GetGSTPerPostedLine(TSLRec."Document No.", TSLRec."Line No.");
        SIItemIGSTRt := CU50200.GetIGSTAmtPostedLine(TSLRec."Document No.", TSLRec."Line No.");
        SIItemSGSTRt := CU50200.GetSGSTAmtPostedLine(TSLRec."Document No.", TSLRec."Line No.");
        SIItemCGSTRt := CU50200.GetCGSTAmtPostedLine(TSLRec."Document No.", TSLRec."Line No.");

        recDetailedGSTLedEntry.Reset();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", TSLRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", TSLRec."Line No.");
        recDetailedGSTLedEntry.SETRANGE("GST Component Code", 'CESS');
        IF recDetailedGSTLedEntry.FINDFIRST THEN begin
            IF (recDetailedGSTLedEntry."GST %" > 0) THEN
                SIItemCesRt := recDetailedGSTLedEntry."GST %"
            ELSE
                SIItemCesNonAdval := ABS(recDetailedGSTLedEntry."GST Amount");
        end;
        recDetailedGSTLedEntry.Reset();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", TSLRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", TSLRec."Line No.");
        recDetailedGSTLedEntry.SETRANGE("GST Component Code", 'INTERCESS');
        IF recDetailedGSTLedEntry.FINDFIRST THEN
            SIItemCesRt := recDetailedGSTLedEntry."GST %";

        recDetailedGSTLedEntry.Reset();
        recDetailedGSTLedEntry.SetCurrentKey("Document No.", "Document Line No.", "GST Component Code");
        recDetailedGSTLedEntry.SETRANGE("Document No.", TSLRec."Document No.");
        recDetailedGSTLedEntry.SETRANGE("Document Line No.", TSLRec."Line No.");
        IF recDetailedGSTLedEntry.FINDSET THEN
            REPEAT
                IF NOT (recDetailedGSTLedEntry."GST Component Code" IN ['CGST', 'SGST', 'IGST', 'CESS', 'INTERCESS']) THEN
                    SIItemStateCes := recDetailedGSTLedEntry."GST %";
            UNTIL recDetailedGSTLedEntry.NEXT = 0;

        SIItemTotItemVal := TSLRec.Amount + CU50200.TotalGSTAmtDoc(TSLRec."Document No.");
    end;

    procedure SendSalesInvValueDetails(TSHRec: Record "Transfer Shipment Header")
    var
        recTSLine: Record "Transfer Shipment Line";
        GSTLedgerEntry: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        CU50200: Codeunit 50200;
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
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", TSHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetCGSTVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        end;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", TSHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetSGSTVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        END;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", TSHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetIGSTVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        END;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", TSHRec."No.");
        GSTLedgerEntry.SETRANGE("GST Component Code", 'INTERCESS');
        IF GSTLedgerEntry.FindFirst() THEN begin
            REPEAT
                SIValueDetTotCessVal += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        end;
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SETRANGE("Document No.", TSHRec."No.");
        DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CESS');
        IF DetailedGSTLedgerEntry.FINDFIRST THEN begin
            REPEAT
                IF DetailedGSTLedgerEntry."GST %" > 0 THEN
                    SIValueDetTotCessVal += ABS(DetailedGSTLedgerEntry."GST Amount")
                ELSE
                    SIValueDetCesNonAdval += ABS(DetailedGSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        end;
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SETRANGE("Document No.", TSHRec."No.");
        GSTLedgerEntry.SETFILTER("GST Component Code", '<>CGST|<>SGST|<>IGST|<>CESS|<>INTERCESS');
        IF GSTLedgerEntry.FindFirst() THEN BEGIN
            REPEAT
                SIValueDetTotCesValOfState += ABS(GSTLedgerEntry."GST Amount");
            UNTIL GSTLedgerEntry.NEXT = 0;
        END;
        recTSLine.Reset();
        recTSLine.SETRANGE("Document No.", TSHRec."No.");
        IF recTSLine.FINDSET THEN BEGIN
            REPEAT
                SIValueDetTotAssVal += recTSLine.Quantity * recTSLine."Unit Price";
                SIValueDetTotInvVal += recTSLine.Quantity * recTSLine."Unit Price" + CU50200.TotalGSTAmtDoc(recTSLine."Document No.");
            UNTIL recTSLine.NEXT = 0;
        END;
    end;

    procedure SendEWayBillDetails(TSHRec: Record "Transfer Shipment Header")
    var
        recVend: Record Vendor;
        recEinvoice: Record 50000;
    begin
        transportername := '';
        transporterid := '';
        transportationmode := '';
        transportationdistance := '';
        transporterdocumentnumber := '';
        transporterdocumentdate := '';
        vehiclenumber := '';
        vehicletype := '';
        if recVend.GET(TSHRec."Transporter Code") then begin
            transportername := recVend.Name;
            transporterid := recVend."GST Registration No.";
        end;
        IF TSHRec."Mode of Transport" = 'Road' THEN
            transportationmode := '1'
        ELSE
            IF TSHRec."Mode of Transport" = 'Rail' THEN
                transportationmode := '2'
            ELSE
                IF TSHRec."Mode of Transport" = 'Air' THEN
                    transportationmode := '3'
                ELSE
                    IF TSHRec."Mode of Transport" = 'Ship' THEN
                        transportationmode := '4'
                    ELSE
                        IF TSHRec."Mode of Transport" = '' THEN
                            transportationmode := '';

        recEinvoice.RESET();
        recEinvoice.SETRANGE("No.", TSHRec."No.");
        IF recEinvoice.FIND('-') THEN
            transportationdistance := recEinvoice."Distance (Km)"
        ELSE
            transportationdistance := '';

        transporterdocumentnumber := TSHRec."LR/RR No.";
        transporterdocumentdate := FORMAT(TSHRec."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');

        vehiclenumber := TSHRec."Vehicle No.";

        IF TSHRec."Vehicle Type" = TSHRec."Vehicle Type"::ODC THEN
            vehicletype := 'O'
        ELSE
            IF TSHRec."Vehicle Type" = TSHRec."Vehicle Type"::Regular THEN
                vehicletype := 'R'
            ELSE
                IF TSHRec."Vehicle Type" = TSHRec."Vehicle Type"::" " THEN
                    vehicletype := '';
    end;

    var
        CU50200: Codeunit 50200;
        accesstoken: Text;
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
        EwbNo: Text;
        EwbDt: Text;
        EwbValidTill: Text;
        transportername: Text;
        transporterid: Text;
        transportationmode: Text;
        transportationdistance: Text;
        transporterdocumentnumber: Text;
        transporterdocumentdate: Text;
        vehiclenumber: Text;
        vehicletype: Text;
}