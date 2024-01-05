codeunit 50000 "E-Invoice Integration-Master"
 {
    
//     Permissions = TableData 112 = m;

//     trigger OnRun()
//     begin
//         //InitializeAccessToken;
//         //CreateJsonforSalesInv;
//         //CreateJsonforSalesCRM;
//         //InitializeEinvoiceGenerate;
//         //InitializeCancelEinvoice;
//         //InitializeGenerateEwayBillByIRN;
//         //InitializeGetEInvoive;
//         //InitializeCalculateDistance;
//     end;

//     var
//         SecurityProtocol: DotNet ServicePointManager;
//         JSONTextWriter: DotNet JsonTextWriter;
//         GetAccessTokenNo: Text;
//         SalesInvoiceHeader: Record "112";
//         SalesCrMemoHeader: Record "114";
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JsonFormatting: DotNet Formatting;
//         GlobalNULL: Variant;
//         IsInvoice: Boolean;
//         DocumentNo: Text[20];
//         UnRegCusrErr: Label 'E-Invoicing is not applicable for Unregistered Customer.';
//         RecIsEmptyErr: Label 'Record variable uninitialized.';
//         SalesLinesErr: Label 'E-Invoice allowes only 100 lines per Invoice. Curent transaction is having %1 lines.', Comment = '%1 = Sales Lines count';
//         TokenNo: Text;
//         EInvoiceIntegration: Record "50000";
//         JsonStingEInvoice: Text;
//         Instr: OutStream;
//         recSalesInvHead: Record "112";
//         CurrFector: Decimal;
//         TransferShipHeader: Record "5744";
//         JsonStingEInvoiceTransferShip: Text;
//         recShiptoCode: Record "222";
//         recCust: Record "18";

//     procedure QRCodeManagement(DocNo: Code[30]; QRText: Text; IRNno: Text)
//     var
//         TextToQR: Text;
//         ImageFormat: DotNet ImageFormat;
//         QrCodeBitmap: DotNet Bitmap;
//         MyURL: Text;
//         BarcodeFormat: DotNet BarcodeFormat;
//         BarcodeWriter: DotNet BarcodeWriter;
//         EncodingOption: DotNet EncodingOptions;
//         BitMatrix: DotNet BitMatrix;
//         FileManagement: Codeunit 419;
//         TempBlob: Record "99008535";
//         SaveLocation: Text;
//         TempLocation: Text;
//         recEwayEinvoice: Record "50000";
//         Instream: InStream;
//         TempBlob2: Record "99008535";
//         recSalesinvoiceHeader: Record "112";
//         recSalesCrMemoHeader: Record "114";
//     begin
//         /*12887
//         recEwayEinvoice.RESET();
//         recEwayEinvoice.SETRANGE("No.",DocNo);
//           IF recEwayEinvoice.FIND('-') THEN BEGIN
//             EncodingOption := EncodingOption.EncodingOptions();
//             EncodingOption.Height := 100;
//             EncodingOption.Width := 100;
//             TempLocation:='D:\QR Code\';
//             BarcodeWriter := BarcodeWriter.BarcodeWriter();
//             BarcodeWriter.Format := BarcodeFormat.QR_CODE;
//             BarcodeWriter.Options := EncodingOption;
//             TextToQR := QRText;
//             BitMatrix := BarcodeWriter.Encode(TextToQR);
//             QrCodeBitmap := BarcodeWriter.Write(BitMatrix);
//             SaveLocation := TempLocation + TextToQR + '.bmp';
        
//             IF NOT ISSERVICETIER THEN
//               IF EXISTS(SaveLocation) THEN
//                 ERASE(SaveLocation);
        
//             TempBlob2.INIT;
//             TempBlob2.Blob.CREATEINSTREAM(Instream);
//             Instream.READTEXT(SaveLocation);
        
//             QrCodeBitmap.Save(Instream, ImageFormat.Bmp);
        
//             recEwayEinvoice.RESET();
//             recEwayEinvoice.SETRANGE("No.",DocNo);
//             IF recEwayEinvoice.FIND('-') THEN
//             recEwayEinvoice."QR Code".CREATEOUTSTREAM(Instr);
//             QrCodeBitmap.Save(Instr,ImageFormat.Bmp);
//             recEwayEinvoice.MODIFY;
//           END;
//         12887*/

//     end;

//     procedure CreateJsonforSalesInv(DocNo: Code[30])
//     begin
//         SalesInvoiceHeader.RESET();
//         SalesInvoiceHeader.SETRANGE("No.", DocNo);
//         IF SalesInvoiceHeader.FIND('-') THEN BEGIN


//             ////ACX_Sr
//             // IF SalesInvoiceHeader."GST Customer Type"=SalesInvoiceHeader."GST Customer Type"::Export THEN
//             //   ERROR('Export einvoice not available');
//             ///ACX_SR

//             TokenNo := '';
//             TokenNo := InitializeAccessToken(SalesInvoiceHeader."No.");

//             EInvoiceIntegration.GET(SalesInvoiceHeader."No.");

//             IF ISNULL(StringBuilder) THEN
//                 Initialize;

//             IF IsInvoice THEN
//                 WITH SalesInvoiceHeader DO BEGIN

//                     IF "GST Customer Type" IN ["GST Customer Type"::Unregistered, "GST Customer Type"::" "]
//                     THEN
//                         ERROR(UnRegCusrErr);
//                     DocumentNo := "No.";
//                     WriteFileHeader;
//                     ReadTransDtls("GST Customer Type", "Ship-to Code");
//                     ReadDocDtls;
//                     ReadSellerDtls;
//                     ReadBuyerDtls;
//                     ReadDispDtls;//Bill From Sell From Same

//                     //    IF SalesInvoiceHeader."Ship-to Code"<>'' THEN
//                     ReadShipDtls;

//                     IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export, SalesInvoiceHeader."GST Customer Type"::"SEZ Development", SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                         ReadExpDtls;
//                     END;
//                     ReadPaymentDtls;
//                     //    ReadReferenceDtls;
//                     ReadAdditionalDocumentDtls;
//                     ReadValDtls;
//                     //    ReadEwaybillDtls;
//                     ReadItemList;
//                     JSONTextWriter.WriteEndObject;
//                     JSONTextWriter.Flush;
//                 END;

//             JsonStingEInvoice := '';
//             JsonStingEInvoice := (StringBuilder.ToString);

//             /* IF DocumentNo <> '' THEN
//               ExportAsJson(DocumentNo)
//              ELSE
//               ERROR(RecIsEmptyErr);
//              */

//             InitializeEinvoiceGenerate(SalesInvoiceHeader."No.");

//         END;

//     end;

//     procedure CreateJsonforSalesCRM(DocNo: Code[30])
//     begin
//         SalesCrMemoHeader.RESET();
//         SalesCrMemoHeader.SETRANGE("No.", DocNo);
//         IF SalesCrMemoHeader.FIND('-') THEN BEGIN

//             TokenNo := '';
//             TokenNo := InitializeAccessToken(SalesCrMemoHeader."No.");

//             EInvoiceIntegration.GET(SalesCrMemoHeader."No.");

//             IF ISNULL(StringBuilder) THEN
//                 Initialize;

//             WITH SalesCrMemoHeader DO BEGIN
//                 IF "GST Customer Type" IN ["GST Customer Type"::Unregistered, "GST Customer Type"::" "]
//                 THEN
//                     ERROR(UnRegCusrErr);
//                 DocumentNo := "No.";
//                 WriteFileHeader;
//                 ReadTransDtls("GST Customer Type", "Ship-to Code");
//                 ReadDocDtls;
//                 ReadSellerDtls;
//                 ReadBuyerDtls;
//                 ReadDispDtls;
//                 ReadShipDtls;
//                 IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Export, SalesCrMemoHeader."GST Customer Type"::"SEZ Development", SalesCrMemoHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                     ReadExpDtls;
//                 END;
//                 ReadPaymentDtls;
//                 //    ReadReferenceDtls;
//                 ReadAdditionalDocumentDtls;
//                 ReadValDtls;
//                 //    ReadEwaybillDtls;
//                 ReadItemList;
//                 JSONTextWriter.WriteEndObject;
//                 JSONTextWriter.Flush;
//             END;

//             JsonStingEInvoice := '';
//             JsonStingEInvoice := (StringBuilder.ToString);
//             /*
//             IF DocumentNo <> '' THEN
//               ExportAsJson(DocumentNo)
//             ELSE
//               ERROR(RecIsEmptyErr);
//             */
//             InitializeEinvoiceGenerate(SalesCrMemoHeader."No.");

//         END;

//     end;

//     procedure InitializeAccessToken(DocNo: Code[30]): Text[500]
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         Url := 'https://pro.mastersindia.co/oauth/access_token';

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforAccessToken(DocNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Authentication For Access Token : %1', JsonAsText);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value Of Access Token : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 GetAccessTokenNo := JObject.GetValue('access_token').ToString;
//                 //    MESSAGE('Access Token No. : ' + JObject.GetValue('access_token').ToString);
//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         EXIT(GetAccessTokenNo);
//     end;


//     procedure CreateJsonforAccessToken(DocNo: Code[30]): Text
//     var
//         StringBuilder1: DotNet StringBuilder;
//                             StringWriter1: DotNet StringWriter;
//                             JSONTextWriter1: DotNet JsonTextWriter;
//                             JSON: DotNet String;
//                             RecGSTNO: Record "16400";
//                             recSalesInv: Record "112";
//                             recSalesCrm: Record "114";
//                             RECEwayBillEinvoice: Record "50000";
//     begin
//         RECEwayBillEinvoice.RESET();
//         RECEwayBillEinvoice.SETRANGE("No.", DocNo);
//         IF RECEwayBillEinvoice.FINDFIRST THEN BEGIN
//             RecGSTNO.RESET();
//             RecGSTNO.SETRANGE(Code, RECEwayBillEinvoice."Location GST Reg. No.");
//             IF RecGSTNO.FINDFIRST THEN BEGIN
//                 IF RecGSTNO.Username = '' THEN
//                     ERROR('Username must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
//                 IF RecGSTNO.Password = '' THEN
//                     ERROR('Password must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
//                 IF RecGSTNO."Client ID" = '' THEN
//                     ERROR('Client ID must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
//                 IF RecGSTNO."Client Secret" = '' THEN
//                     ERROR('Client Secret must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
//                 IF RecGSTNO."Grant Type" = '' THEN
//                     ERROR('Grant Type must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
//             END
//             ELSE
//                 ERROR('Location GST Reg. No. cannot be blank');

//             StringBuilder1 := StringBuilder1.StringBuilder;
//             StringWriter1 := StringWriter1.StringWriter(StringBuilder1);
//             JSONTextWriter1 := JSONTextWriter1.JsonTextWriter(StringWriter1);

//             JSONTextWriter1.WriteStartObject;

//             CreateJsonAttribute('username', RecGSTNO.Username, JSONTextWriter1);
//             CreateJsonAttribute('password', RecGSTNO.Password, JSONTextWriter1);
//             CreateJsonAttribute('client_id', RecGSTNO."Client ID", JSONTextWriter1);
//             CreateJsonAttribute('client_secret', RecGSTNO."Client Secret", JSONTextWriter1);
//             CreateJsonAttribute('grant_type', RecGSTNO."Grant Type", JSONTextWriter1);

//             JSONTextWriter1.WriteEndObject;
//             EXIT(StringBuilder1.ToString);
//         END;
//     end;


//     procedure InitializeEinvoiceGenerate(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Alert: Text;
//     Error: Text;
//     Status: Text;
//     "Code": Text;
//     results: Text;
//     message1: Text;
//     AckNo: Text;
//     AckDt: Text;
//     Status1: Text;
//     QRCodeUrl: Text;
//     EinvoicePdf: Text;
//     EWayBillandEinvoice: Record "50000";
//     errorMessage: Text;
//     IRNNo: Text;
//     EwbValidTill: Text;
//     EwbDt: Text;
//     EwbNo: Text;
//     recResponseLog: Record "50003";
//     QRcode: Text;
//     recSIH: Record "112";
//     Day: Integer;
//     Month: Integer;
//     Year: Integer;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         Url := 'https://pro.mastersindia.co/generateEinvoice';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(JsonStingEInvoice);
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := '';
//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Generate E-Invoice : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Generate E-Invoice : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 results := JObject.GetValue('results').ToString;
//                 //    MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(results);
//                 Status := (JObject.GetValue('status').ToString);
//                 //    MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(results);
//                 Code := (JObject.GetValue('code').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 JObject := JObject.Parse(results);
//                 errorMessage := (JObject.GetValue('errorMessage').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('errorMessage').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(results);
//                     message1 := JObject.GetValue('message').ToString;
//                     //    MESSAGE := (JObject.GetValue('message').ToString);

//                     JObject := JObject.Parse(message1);
//                     AckNo := (JObject.GetValue('AckNo').ToString);
//                     MESSAGE('Ack No. : ' + JObject.GetValue('AckNo').ToString);

//                     JObject := JObject.Parse(message1);
//                     AckDt := (JObject.GetValue('AckDt').ToString);
//                     MESSAGE('Ack Date : ' + JObject.GetValue('AckDt').ToString);

//                     JObject := JObject.Parse(message1);
//                     IRNNo := (JObject.GetValue('Irn').ToString);
//                     MESSAGE('Irn No. : ' + JObject.GetValue('Irn').ToString);

//                     JObject := JObject.Parse(message1);
//                     QRCodeUrl := (JObject.GetValue('QRCodeUrl').ToString);
//                     MESSAGE('QR Code Url : ' + JObject.GetValue('QRCodeUrl').ToString);

//                     JObject := JObject.Parse(message1);
//                     EinvoicePdf := (JObject.GetValue('EinvoicePdf').ToString);
//                     MESSAGE('E-Invoice Pdf : ' + JObject.GetValue('EinvoicePdf').ToString);

//                     JObject := JObject.Parse(message1);
//                     EwbNo := (JObject.GetValue('EwbNo').ToString);
//                     //    MESSAGE('E-Way Bill No. : ' + JObject.GetValue('EwbNo').ToString);

//                     JObject := JObject.Parse(message1);
//                     EwbDt := (JObject.GetValue('EwbDt').ToString);
//                     //    MESSAGE('E-Way Bill Date : ' + JObject.GetValue('EwbDt').ToString);

//                     JObject := JObject.Parse(message1);
//                     EwbValidTill := (JObject.GetValue('EwbValidTill').ToString);
//                     //    MESSAGE('E-Way Bill Valid Upto : ' + JObject.GetValue('EwbValidTill').ToString);

//                     JObject := JObject.Parse(message1);
//                     Status1 := (JObject.GetValue('Status').ToString);
//                     //    MESSAGE('Status : ' + JObject.GetValue('Status').ToString);

//                     JObject := JObject.Parse(message1);
//                     Alert := (JObject.GetValue('alert').ToString);
//                     //    MESSAGE('Alert : ' + JObject.GetValue('alert').ToString);

//                     JObject := JObject.Parse(message1);
//                     Error := (JObject.GetValue('error').ToString);
//                     //    MESSAGE('Error : ' + JObject.GetValue('error').ToString);

//                     JObject := JObject.Parse(message1);
//                     QRcode := (JObject.GetValue('SignedQRCode').ToString);
//                     MESSAGE('Signed QR Code : ' + JObject.GetValue('SignedQRCode').ToString);

//                     IF QRcode <> '' THEN BEGIN
//                         QRCodeManagement(DocNo, QRcode, IRNNo);
//                     END;
//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Success';
//                     recResponseLog."Called API" := 'Generate IRN';
//                     recResponseLog.INSERT;

//                     EWayBillandEinvoice.RESET();
//                     EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                     IF EWayBillandEinvoice.FIND('-') THEN BEGIN
//                         EWayBillandEinvoice.VALIDATE("E-Invoice IRN No", IRNNo);
//                         EWayBillandEinvoice.VALIDATE("E-Invoice Acknowledge No.", AckNo);
//                         EWayBillandEinvoice.VALIDATE("E-Invoice Acknowledge Date", AckDt);
//                         EWayBillandEinvoice."E-Invoice QR Code" := QRCodeUrl;
//                         EWayBillandEinvoice."E-Invoice PDF" := EinvoicePdf;
//                         IF EwbNo <> '' THEN
//                             EWayBillandEinvoice.VALIDATE("E-Way Bill No.", EwbNo);
//                         IF EwbDt <> '' THEN
//                             EWayBillandEinvoice."E-Way Bill Date" := EwbDt;
//                         IF EwbValidTill <> '' THEN
//                             EWayBillandEinvoice."E-Way Bill Valid Upto" := EwbValidTill;
//                         EWayBillandEinvoice."E-Invoice IRN Status" := Status1;
//                         //        EWayBillandEinvoice."E-Invoice Cancel Date" := '';
//                         EWayBillandEinvoice.VALIDATE("E-Invoice Cancel Date", '');
//                         EWayBillandEinvoice."E-Invoice Cancel Reason" := EWayBillandEinvoice."E-Invoice Cancel Reason"::" ";
//                         EWayBillandEinvoice."E-Invoice Cancel Remarks" := '';
//                         EWayBillandEinvoice."E-Invoice Status" := Status + ' ' + Code;
//                         EWayBillandEinvoice.MODIFY;
//                     END;
//                 END
//                 ELSE BEGIN
//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Generate IRN';
//                     recResponseLog.INSERT;

//                     EWayBillandEinvoice.RESET();
//                     EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                     IF EWayBillandEinvoice.FIND('-') THEN
//                         EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                     MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                     EWayBillandEinvoice.MODIFY;
//                 END;
//             END;
//         END
//         ELSE
//             MESSAGE('no response from api');
//     end;


//     procedure InitializeCancelEinvoice(DocNo: Code[30]; EinvoiceBillNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Status: Text;
//     "Code": Text;
//     GetCancelBillDate: Text;
//     recEinvoice: Record "50000";
//     GetCancelIrn: Text;
//     errorMessage: Text;
//     recResponseLog: Record "50003";
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         Url := 'https://pro.mastersindia.co/cancelEinvoice';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforCancelEinvoice(DocNo, EinvoiceBillNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Cancel E-Invoice : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Cancel E-Invoice : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //    MESSAGE('Results : ' + JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 errorMessage := (JObject.GetValue('errorMessage').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //    MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp);
//                     temp01 := JObject.GetValue('message').ToString;
//                     //    MESSAGE('Message : ' + JObject.GetValue('message').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetCancelIrn := (JObject.GetValue('Irn').ToString);
//                     MESSAGE('Cancel E-Invoice IRN No. : ' + JObject.GetValue('Irn').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetCancelBillDate := (JObject.GetValue('CancelDate').ToString);
//                     MESSAGE('Cancel E-Invoice Date : ' + JObject.GetValue('CancelDate').ToString);

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Success';
//                     recResponseLog."Called API" := 'Cancel IRN';
//                     recResponseLog.INSERT;

//                     recEinvoice.RESET();
//                     recEinvoice.SETRANGE("No.", DocNo);
//                     recEinvoice.SETRANGE("E-Invoice IRN No", EinvoiceBillNo);
//                     IF recEinvoice.FIND('-') THEN BEGIN
//                         //        recEinvoice."E-Invoice Cancel Date" := FORMAT(GetCancelBillDate);
//                         recEinvoice.VALIDATE("E-Invoice Cancel Date", GetCancelBillDate);
//                         recEinvoice."E-Invoice Status" := Status + ' ' + Code;
//                         recEinvoice.MODIFY;
//                     END;
//                 END
//                 ELSE BEGIN

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Cancel IRN';
//                     recResponseLog.INSERT;

//                     recEinvoice.RESET();
//                     recEinvoice.SETRANGE("No.", DocNo);
//                     IF recEinvoice.FIND('-') THEN
//                         recEinvoice."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                     MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                     recEinvoice.MODIFY;
//                 END;
//             END;
//         END
//         ELSE
//             MESSAGE('no response from api');
//     end;


//     procedure CreateJsonforCancelEinvoice(DocNo: Code[30]; EinvoiceNo: Text; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder1: DotNet StringBuilder;
//                             StringWriter1: DotNet StringWriter;
//                             JSONTextWriter1: DotNet JsonTextWriter;
//                             JSON: DotNet String;
//                             recEinvoice: Record "50000";
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         recEinvoice.RESET();
//         recEinvoice.SETRANGE("No.", DocNo);
//         IF recEinvoice.FIND('-') THEN BEGIN

//             StringBuilder1 := StringBuilder1.StringBuilder;
//             StringWriter1 := StringWriter1.StringWriter(StringBuilder1);
//             JSONTextWriter1 := JSONTextWriter1.JsonTextWriter(StringWriter1);

//             JSONTextWriter1.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter1);
//             CreateJsonAttribute('user_gstin', recEinvoice."Location GST Reg. No.", JSONTextWriter1);
//             CreateJsonAttribute('irn', recEinvoice."E-Invoice IRN No", JSONTextWriter1);
//             IF recEinvoice."E-Invoice Cancel Reason" = recEinvoice."E-Invoice Cancel Reason"::"Wrong entry" THEN
//                 CreateJsonAttribute('cancel_reason', '1', JSONTextWriter1);
//             CreateJsonAttribute('cancel_remarks', FORMAT(recEinvoice."E-Invoice Cancel Remarks"), JSONTextWriter1);

//             JSONTextWriter1.WriteEndObject;

//             EXIT(StringBuilder1.ToString);

//         END;
//     end;


//     procedure InitializeCalculateDistance(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Status: Text;
//     "Code": Text;
//     frompincode: Text;
//     topincode: Text;
//     EINV: Record "50000";
//     RecVendor: Record "23";
//     RecLoc: Record "14";
//     GetCalculatedDistance: Text;
//     recResponseLog: Record "50003";
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         EINV.RESET();
//         EINV.SETRANGE("No.", DocNo);
//         IF EINV.FIND('-') THEN BEGIN
//             IF EINV."GST Customer Type" IN [EINV."GST Customer Type"::Export, EINV."GST Customer Type"::"SEZ Development", EINV."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                 frompincode := '';
//                 topincode := '';
//                 RecVendor.RESET();
//                 RecVendor.SETRANGE("No.", EINV."Port Code");
//                 IF RecVendor.FIND('-') THEN
//                     frompincode := FORMAT(RecVendor."Post Code");

//                 RecLoc.RESET();
//                 RecLoc.SETRANGE(Code, EINV."Location Code");
//                 IF RecLoc.FIND('-') THEN
//                     topincode := FORMAT(RecLoc."Post Code");
//             END;
//         END;

//         EINV.RESET();
//         EINV.SETRANGE("No.", DocNo);
//         IF EINV.FIND('-') THEN BEGIN
//             IF EINV."GST Customer Type" IN [EINV."GST Customer Type"::" ", EINV."GST Customer Type"::"Deemed Export", EINV."GST Customer Type"::Exempted, EINV."GST Customer Type"::Registered, EINV."GST Customer Type"::Unregistered]
//                   THEN BEGIN
//                 frompincode := '';
//                 topincode := '';
//                 IF EINV."Ship-to Code" = '' THEN
//                     frompincode := FORMAT(EINV."Sell-to Post Code")
//                 ELSE
//                     frompincode := FORMAT(EINV."Ship-to Post Code");

//                 RecLoc.RESET();
//                 RecLoc.SETRANGE(Code, EINV."Location Code");
//                 IF RecLoc.FIND('-') THEN
//                     topincode := FORMAT(RecLoc."Post Code");
//             END;
//         END;

//         Url := 'http://pro.mastersindia.co/distance?access_token=' + ReceiveTokenNo + '&fromPincode=' + frompincode + '&toPincode=' + topincode;

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('GET');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Calculate Distance for E-Way Bill : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp);
//                     GetCalculatedDistance := (JObject.GetValue('distance').ToString);
//                     //MESSAGE('Distance for E-Way Bill ' + JObject.GetValue('distance').ToString);

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Success';
//                     recResponseLog."Called API" := 'Calculate Distance';
//                     recResponseLog.INSERT;

//                     EINV.RESET();
//                     EINV.SETRANGE("No.", DocNo);
//                     IF EINV.FIND('-') THEN BEGIN
//                         EVALUATE(EINV."Distance (Km)", GetCalculatedDistance);
//                         EINV."E-Invoice Status" := Status + ' ' + Code;
//                         EINV.MODIFY;
//                     END;
//                 END
//                 ELSE BEGIN

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Calculate Distance';
//                     recResponseLog.INSERT;

//                     EINV.RESET();
//                     EINV.SETRANGE("No.", DocNo);
//                     IF EINV.FIND('-') THEN
//                         EINV."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                     MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                     EINV.MODIFY;
//                 END;
//             END;
//         END
//         ELSE
//             MESSAGE('no response from api');
//     end;

//     procedure InitializeGenerateEwayBillByIRN(DocNo: Code[30]; EinvoiceBillNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Status: Text;
//     "Code": Text;
//     GetCancelBillDate: Text;
//     recEinvoice: Record "50000";
//     GetCancelIrn: Text;
//     errorMessage: Text;
//     EwayBillNo: Text;
//     EwayBillDate: Text;
//     EwayBillValidUpto: Text;
//     recResponseLog: Record "50003";
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         Url := 'https://pro.mastersindia.co/generateEwaybillByIrn';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforGenerateEwayBillByIRN(DocNo, EinvoiceBillNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Generate E-Way Bill By Irn : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of  E-Way Bill By Irn : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //    MESSAGE('Results : ' + JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //    MESSAGE('Message : ' + JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 errorMessage := (JObject.GetValue('errorMessage').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //    MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     EwayBillNo := (JObject.GetValue('EwbNo').ToString);
//                     MESSAGE('E-Way Bill No. : ' + JObject.GetValue('EwbNo').ToString);

//                     JObject := JObject.Parse(temp01);
//                     EwayBillDate := (JObject.GetValue('EwbDt').ToString);
//                     MESSAGE('E-Way Bill Date : ' + JObject.GetValue('EwbDt').ToString);

//                     JObject := JObject.Parse(temp01);
//                     EwayBillValidUpto := (JObject.GetValue('EwbValidTill').ToString);
//                     MESSAGE('E-Way Bill Valid Upto : ' + JObject.GetValue('EwbValidTill').ToString);

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Success';
//                     recResponseLog."Called API" := 'Generate E-Way Bill By IRN';
//                     recResponseLog.INSERT;

//                     recEinvoice.RESET();
//                     recEinvoice.SETRANGE("No.", DocNo);
//                     recEinvoice.SETRANGE("E-Invoice IRN No", EinvoiceBillNo);
//                     IF recEinvoice.FIND('-') THEN BEGIN
//                         recEinvoice.VALIDATE("E-Way Bill No.", FORMAT(EwayBillNo));
//                         recEinvoice."E-Way Bill Date" := FORMAT(EwayBillDate);
//                         recEinvoice."E-Way Bill Valid Upto" := FORMAT(EwayBillValidUpto);
//                         recEinvoice."E-Invoice Status" := Status + ' ' + Code;
//                         recEinvoice.MODIFY;
//                     END
//                 END
//                 ELSE BEGIN

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Generate E-Way Bill By IRN';
//                     recResponseLog.INSERT;

//                     recEinvoice.RESET();
//                     recEinvoice.SETRANGE("No.", DocNo);
//                     IF recEinvoice.FIND('-') THEN
//                         recEinvoice."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                     MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                     recEinvoice.MODIFY;
//                 END;
//             END;
//         END
//         ELSE
//             MESSAGE('no response from api');
//     end;


//     procedure CreateJsonforGenerateEwayBillByIRN(DocNo: Code[30]; EinvoiceNo: Text; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder1: DotNet StringBuilder;
//                             StringWriter1: DotNet StringWriter;
//                             JSONTextWriter1: DotNet JsonTextWriter;
//                             JSON: DotNet String;
//                             recEinvoice: Record "50000";
//                             recVend: Record "23";
//                             transporterdocumentdate: Text;
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         recEinvoice.RESET();
//         recEinvoice.SETRANGE("No.", DocNo);
//         IF recEinvoice.FIND('-') THEN BEGIN

//             StringBuilder1 := StringBuilder1.StringBuilder;
//             StringWriter1 := StringWriter1.StringWriter(StringBuilder1);
//             JSONTextWriter1 := JSONTextWriter1.JsonTextWriter(StringWriter1);

//             JSONTextWriter1.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter1);
//             CreateJsonAttribute('user_gstin', recEinvoice."Location GST Reg. No.", JSONTextWriter1);
//             CreateJsonAttribute('irn', recEinvoice."E-Invoice IRN No", JSONTextWriter1);
//             recVend.RESET();
//             recVend.SETRANGE("No.", recEinvoice."Transporter Code");
//             IF recVend.FIND('-') THEN
//                 CreateJsonAttribute('transporter_id', recVend."GST Registration No.", JSONTextWriter1)
//             ELSE
//                 CreateJsonAttribute('transporter_id', '', JSONTextWriter1);
//             /*
//             IF recEinvoice."Transportation Mode" = recEinvoice."Transportation Mode"::Road THEN
//               CreateJsonAttribute('transportation_mode',  '1',JSONTextWriter1)
//             ELSE
//             IF recEinvoice."Transportation Mode" = recEinvoice."Transportation Mode"::Rail THEN
//               CreateJsonAttribute('transportation_mode',  '2',JSONTextWriter1)
//             ELSE
//             IF recEinvoice."Transportation Mode" = recEinvoice."Transportation Mode"::Air THEN
//               CreateJsonAttribute('transportation_mode',  '3',JSONTextWriter1)
//             ELSE
//             IF recEinvoice."Transportation Mode" = recEinvoice."Transportation Mode"::Ship THEN
//               CreateJsonAttribute('transportation_mode',  '4',JSONTextWriter1)
//             ELSE
//             IF recEinvoice."Transportation Mode" = recEinvoice."Transportation Mode"::" " THEN
//               CreateJsonAttribute('transportation_mode',  '',JSONTextWriter1);
//             */

//             IF recEinvoice."Mode of Transport" = 'Road' THEN
//                 CreateJsonAttribute('transportation_mode', '1', JSONTextWriter1)
//             ELSE
//                 IF recEinvoice."Mode of Transport" = 'Rail' THEN
//                     CreateJsonAttribute('transportation_mode', '2', JSONTextWriter1)
//                 ELSE
//                     IF recEinvoice."Mode of Transport" = 'Air' THEN
//                         CreateJsonAttribute('transportation_mode', '3', JSONTextWriter1)
//                     ELSE
//                         IF recEinvoice."Mode of Transport" = 'Ship' THEN
//                             CreateJsonAttribute('transportation_mode', '4', JSONTextWriter1)
//                         ELSE
//                             IF recEinvoice."Mode of Transport" = '' THEN
//                                 CreateJsonAttribute('transportation_mode', '', JSONTextWriter1);

//             CreateJsonAttribute('transporter_document_number', recEinvoice."LR/RR No.", JSONTextWriter1);

//             transporterdocumentdate := FORMAT(recEinvoice."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             CreateJsonAttribute('transporter_document_date', transporterdocumentdate, JSONTextWriter1);
//             CreateJsonAttribute('vehicle_number', recEinvoice."Vehicle No.", JSONTextWriter1);
//             CreateJsonAttribute('distance', recEinvoice."Distance (Km)", JSONTextWriter1);
//             IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::"over dimensional cargo" THEN
//                 CreateJsonAttribute('vehicle_type', 'O', JSONTextWriter1)
//             ELSE
//                 IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::regular THEN
//                     CreateJsonAttribute('vehicle_type', 'R', JSONTextWriter1)
//                 ELSE
//                     IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::" " THEN
//                         CreateJsonAttribute('vehicle_type', '', JSONTextWriter1);
//             CreateJsonAttribute('transporter_name', recVend.Name, JSONTextWriter1);
//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter1);

//             JSONTextWriter1.WriteEndObject;

//             EXIT(StringBuilder1.ToString);

//         END;

//     end;


//     procedure InitializeGetEInvoive(DocNo: Code[30]; IRN: Text)
//     var
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Status: Text;
//     "Code": Text;
//     GetCancelBillDate: Text;
//     recEinvoice: Record "50000";
//     GetCancelIrn: Text;
//     errorMessage: Text;
//     results: Text;
//     message1: Text;
//     IrnNo: Text;
//     Status1: Text;
//     EWayBillandEinvoice: Record "50000";
//     recResponseLog: Record "50003";
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         recEinvoice.RESET();
//         recEinvoice.SETRANGE("No.", DocNo);
//         IF recEinvoice.FIND('-') THEN BEGIN

//             Url := 'https://pro.mastersindia.co/getEinvoiceData?' + 'access_token=' + ReceiveTokenNo + '&gstin=' + recEinvoice."Location GST Reg. No." + '&irn=' + IRN;

//             HttpWebRequestMgt.Initialize(Url);
//             HttpWebRequestMgt.DisableUI;
//             HttpWebRequestMgt.SetMethod('GET');
//             HttpWebRequestMgt.SetContentType('application/json');
//             HttpWebRequestMgt.SetReturnType('application/json');

//             TempBlob.INIT;
//             TempBlob.Blob.CREATEINSTREAM(Instr);
//             IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//                 MESSAGE('Return Value of Get E-Invoice No. : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//                 IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                     ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                     JObject := JObject.JObject;
//                     JObject := JObject.Parse(ApiResult);
//                     temp := JObject.GetValue('results').ToString;
//                     //    MESSAGE(temp);

//                     JObject := JObject.Parse(temp);
//                     errorMessage := (JObject.GetValue('errorMessage').ToString);
//                     //    MESSAGE('Code : ' + JObject.GetValue('errorMessage').ToString);

//                     JObject := JObject.Parse(temp);
//                     Status := (JObject.GetValue('status').ToString);
//                     //    MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                     JObject := JObject.Parse(temp);
//                     Code := (JObject.GetValue('code').ToString);
//                     //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                     IF Code = FORMAT(200) THEN BEGIN
//                         JObject := JObject.Parse(temp);
//                         message1 := JObject.GetValue('message').ToString;
//                         //    MESSAGE := (message1);

//                         JObject := JObject.Parse(message1);
//                         IrnNo := (JObject.GetValue('Irn').ToString);
//                         MESSAGE('Irn No. : ' + IrnNo);

//                         JObject := JObject.Parse(message1);
//                         Status1 := (JObject.GetValue('Status').ToString);
//                         MESSAGE('Status. : ' + Status1);
//                         /*
//                             JObject := JObject.Parse(message1);
//                             MESSAGE('E-Way Bill No. : ' + JObject.GetValue('EwbNo').ToString);

//                             JObject := JObject.Parse(message1);
//                             MESSAGE('E-Way Bill Date. : ' + JObject.GetValue('EwbDt').ToString);

//                             JObject := JObject.Parse(message1);
//                             MESSAGE('E-Way Bill Valid Upto. : ' + JObject.GetValue('EwbValidTill').ToString);
//                         */

//                         recResponseLog.INIT;
//                         recResponseLog."Document No." := DocNo;
//                         recResponseLog."Response Date" := TODAY;
//                         recResponseLog."Response Time" := TIME;
//                         recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                         recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                         recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                         recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                         recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                         recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                         recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                         recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                         recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                         recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                         recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                         recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                         recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                         recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                         recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                         recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                         recResponseLog.Status := 'Success';
//                         recResponseLog."Called API" := 'Get E-Invoice';
//                         recResponseLog.INSERT;

//                         EWayBillandEinvoice.RESET();
//                         EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                         IF EWayBillandEinvoice.FIND('-') THEN BEGIN
//                             EWayBillandEinvoice."E-Invoice IRN Status" := Status1;
//                             EWayBillandEinvoice."E-Invoice Status" := Status + ' ' + Code;
//                             EWayBillandEinvoice.MODIFY;
//                         END;
//                     END
//                     ELSE BEGIN

//                         recResponseLog.INIT;
//                         recResponseLog."Document No." := DocNo;
//                         recResponseLog."Response Date" := TODAY;
//                         recResponseLog."Response Time" := TIME;
//                         recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                         recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                         recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                         recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                         recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                         recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                         recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                         recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                         recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                         recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                         recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                         recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                         recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                         recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                         recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                         recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                         recResponseLog.Status := 'Failure';
//                         recResponseLog."Called API" := 'Get E-Invoice';
//                         recResponseLog.INSERT;

//                         EWayBillandEinvoice.RESET();
//                         EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                         IF EWayBillandEinvoice.FIND('-') THEN
//                             EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                         MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                         EWayBillandEinvoice.MODIFY;
//                     END;
//                 END;
//             END
//             ELSE
//                 MESSAGE('no response from api');
//         END;

//     end;


//     procedure CreateJsonAttribute(PropertyName: Text; Value: Variant; JSONTextWriter: DotNet JsonTextWriter)
//     var
//         StringWriter1: DotNet StringWriter;
//     begin
//         JSONTextWriter.WritePropertyName(PropertyName);
//         JSONTextWriter.WriteValue(Value);
//     end;

//     local procedure Initialize()
//     begin
//         StringBuilder := StringBuilder.StringBuilder;
//         StringWriter := StringWriter.StringWriter(StringBuilder);
//         JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
//         JSONTextWriter.Formatting := JsonFormatting.Indented;
//     end;

//     local procedure WriteFileHeader()
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN

//                 JSONTextWriter.WriteStartObject;
//                 JSONTextWriter.WritePropertyName('access_token');
//                 JSONTextWriter.WriteValue(TokenNo);
//                 JSONTextWriter.WritePropertyName('user_gstin');
//                 JSONTextWriter.WriteValue(SalesInvoiceHeader."Location GST Reg. No.");
//                 JSONTextWriter.WritePropertyName('data_source');
//                 JSONTextWriter.WriteValue('erp');
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN

//                 JSONTextWriter.WriteStartObject;
//                 JSONTextWriter.WritePropertyName('access_token');
//                 JSONTextWriter.WriteValue(TokenNo);
//                 JSONTextWriter.WritePropertyName('user_gstin');
//                 JSONTextWriter.WriteValue(SalesCrMemoHeader."Location GST Reg. No.");
//                 JSONTextWriter.WritePropertyName('data_source');
//                 JSONTextWriter.WriteValue('erp');
//             END;
//     end;

//     local procedure ReadTransDtls(GSTCustType: Option " ",Registered,Unregistered,Export,"Deemed Export",Exempted,"SEZ Development","SEZ Unit"; ShipToCode: Code[12])
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         catg: Text[8];
//         Typ: Text[3];
//         IgstIntra: Text[1];
//     begin
//         IF IsInvoice THEN BEGIN
//             IF GSTCustType IN [SalesInvoiceHeader."GST Customer Type"::Registered, SalesInvoiceHeader."GST Customer Type"::Exempted] THEN
//                 catg := 'B2B'
//             ELSE
//                 //    catg := 'EXP';
//                 IF (GSTCustType IN [SalesInvoiceHeader."GST Customer Type"::Export]) AND (SalesInvoiceHeader."GST Without Payment of Duty" = TRUE) THEN
//                     catg := 'EXPWOP'
//                 ELSE
//                     IF (GSTCustType IN [SalesInvoiceHeader."GST Customer Type"::Export]) AND (SalesInvoiceHeader."GST Without Payment of Duty" = FALSE) THEN
//                         catg := 'EXPWP'
//                     ELSE
//                         //    catg := 'EXP';
//                         IF (GSTCustType IN [SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"]) AND (SalesInvoiceHeader."GST Without Payment of Duty" = TRUE) THEN
//                             catg := 'SEZWOP'
//                         ELSE
//                             IF (GSTCustType IN [SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"]) AND (SalesInvoiceHeader."GST Without Payment of Duty" = FALSE) THEN
//                                 catg := 'SEZWP';


//             IgstIntra := 'N';
//             IF ShipToCode <> '' THEN BEGIN
//                 SalesInvoiceLine.SETRANGE("Document No.", DocumentNo);
//                 IF SalesInvoiceLine.FINDSET THEN
//                     REPEAT
//                         IF SalesInvoiceLine."GST Place of Supply" <> SalesInvoiceLine."GST Place of Supply"::"Ship-to Address" THEN
//                             Typ := 'SHP'
//                         ELSE
//                             Typ := 'REG';
//                     UNTIL SalesInvoiceLine.NEXT = 0;
//             END ELSE
//                 Typ := 'REG';
//         END ELSE BEGIN
//             IF GSTCustType IN [SalesCrMemoHeader."GST Customer Type"::Registered, SalesCrMemoHeader."GST Customer Type"::Exempted] THEN
//                 catg := 'B2B'
//             ELSE
//                 //    catg := 'EXP';
//                 IF (GSTCustType IN [SalesCrMemoHeader."GST Customer Type"::Export]) AND (SalesCrMemoHeader."GST Without Payment of Duty" = TRUE) THEN
//                     catg := 'EXPWOP'
//                 ELSE
//                     IF (GSTCustType IN [SalesCrMemoHeader."GST Customer Type"::Export]) AND (SalesCrMemoHeader."GST Without Payment of Duty" = FALSE) THEN
//                         catg := 'EXPWP'
//                     ELSE
//                         IF (GSTCustType IN [SalesCrMemoHeader."GST Customer Type"::"SEZ Unit"]) AND (SalesCrMemoHeader."GST Without Payment of Duty" = TRUE) THEN
//                             catg := 'SEZWOP'
//                         ELSE
//                             IF (GSTCustType IN [SalesCrMemoHeader."GST Customer Type"::"SEZ Unit"]) AND (SalesCrMemoHeader."GST Without Payment of Duty" = FALSE) THEN
//                                 catg := 'SEZWP';


//             IgstIntra := 'N';
//             SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
//             IF SalesCrMemoLine.FINDSET THEN
//                 REPEAT
//                     IF SalesCrMemoLine."GST Place of Supply" = SalesCrMemoLine."GST Place of Supply"::"Ship-to Address" THEN
//                         Typ := 'REG'
//                     ELSE
//                         Typ := 'SHP';
//                 UNTIL SalesCrMemoLine.NEXT = 0;
//         END;

//         WriteTransDtls(catg, 'RG', Typ, 'false', 'Y', '', IgstIntra);
//     end;

//     local procedure WriteTransDtls(catg: Text[8]; RegRev: Text[2]; Typ: Text[3]; EcmTrnSel: Text[5]; EcmTrn: Text[1]; EcmGstin: Text[15]; IgstIntra: Text[1])
//     var
//         recCust: Record "18";
//     begin

//         JSONTextWriter.WritePropertyName('transaction_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('supply_type');
//         JSONTextWriter.WriteValue(catg);
//         JSONTextWriter.WritePropertyName('charge_type');
//         JSONTextWriter.WriteValue('N');
//         JSONTextWriter.WritePropertyName('igst_on_intra');
//         JSONTextWriter.WriteValue(IgstIntra);
//         IF recCust.GET(SalesInvoiceHeader."Sell-to Customer No.") THEN BEGIN
//             IF recCust."e-Commerce Operator" = TRUE THEN BEGIN
//                 JSONTextWriter.WritePropertyName('ecommerce_gstin');
//                 //    JSONTextWriter.WriteValue(SalesInvoiceHeader."Customer GST Reg. No.");//ACXRaman 02032021
//             END
//             ELSE BEGIN
//                 JSONTextWriter.WritePropertyName('ecommerce_gstin');
//                 JSONTextWriter.WriteValue('');
//             END;
//         END;
//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadDocDtls()
//     var
//         Typ: Text[3];
//         Dt: Text[10];
//         OrgInvNo: Text[16];
//     begin
//         IF IsInvoice THEN BEGIN
//             IF SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::Taxable THEN
//                 Typ := 'INV'
//             ELSE
//                 IF (SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::"Debit Note") OR
//                    (SalesInvoiceHeader."Invoice Type" = SalesInvoiceHeader."Invoice Type"::Supplementary)
//                 THEN
//                     Typ := 'DBN'
//                 ELSE
//                     Typ := 'INV';
//             Dt := FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//         END ELSE BEGIN
//             Typ := 'CRN';
//             Dt := FORMAT(SalesCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//         END;

//         OrgInvNo := COPYSTR(GetRefInvNo(DocumentNo), 1, 16);

//         WriteDocDtls(Typ, COPYSTR(DocumentNo, 1, 16), Dt, OrgInvNo);
//     end;

//     local procedure WriteDocDtls(Typ: Text[3]; No: Text[16]; Dt: Text[10]; OrgInvNo: Text[16])
//     begin

//         JSONTextWriter.WritePropertyName('document_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('document_type');
//         JSONTextWriter.WriteValue(Typ);
//         JSONTextWriter.WritePropertyName('document_number');
//         JSONTextWriter.WriteValue(No);
//         JSONTextWriter.WritePropertyName('document_date');
//         JSONTextWriter.WriteValue(Dt);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadExpDtls()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         GSTManagement: Codeunit "16401";
//         ExpCat: Text[3];
//         WithPay: Text[1];
//         ShipBNo: Text[16];
//         ShipBDt: Text[10];
//         Port: Text[10];
//         InvForCur: Decimal;
//         ForCur: Text[3];
//         CntCode: Text[2];
//         ExpDuty: Decimal;
//         RecCountry: Record "9";
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 IF "GST Customer Type" IN
//                    ["GST Customer Type"::Export,
//                     "GST Customer Type"::"Deemed Export",
//                     "GST Customer Type"::"SEZ Unit",
//                     "GST Customer Type"::"SEZ Development"]
//                 THEN BEGIN
//                     CASE "GST Customer Type" OF
//                         "GST Customer Type"::Export:
//                             ExpCat := 'DIR';
//                         "GST Customer Type"::"Deemed Export":
//                             ExpCat := 'DEM';
//                         "GST Customer Type"::"SEZ Unit":
//                             ExpCat := 'SEZ';
//                         "GST Customer Type"::"SEZ Development":
//                             ExpCat := 'SED';
//                     END;
//                     IF "GST Without Payment of Duty" THEN
//                         WithPay := 'N'
//                     ELSE
//                         WithPay := 'Y';
//                     ShipBNo := COPYSTR("Bill Of Export No.", 1, 16);
//                     ShipBDt := FORMAT("Bill Of Export Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                     Port := "Exit Point";
//                     ExpDuty := 0;
//                     SalesInvoiceLine.SETRANGE("Document No.", "No.");
//                     IF SalesInvoiceLine.FINDSET THEN
//                         REPEAT
//                             ExpDuty += SalesInvoiceLine."Total GST Amount";
//                             IF GSTManagement.IsGSTApplicable(Structure) THEN
//                                 InvForCur := RoundGSTInvoicePrecision(InvForCur + SalesInvoiceLine.Amount)
//                             ELSE
//                                 InvForCur := InvForCur + SalesInvoiceLine.Amount;
//                         UNTIL SalesInvoiceLine.NEXT = 0;
//                     ForCur := COPYSTR("Currency Code", 1, 3);

//                     IF (RecCountry.GET("Bill-to Country/Region Code")) /*AND (RecCountry."e-Code"<>'') */THEN
//                         CntCode := COPYSTR("Bill-to Country/Region Code", 1, 2)
//                     ELSE
//                         CntCode := '';
//                 END
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 IF "GST Customer Type" IN
//                    ["GST Customer Type"::Export,
//                     "GST Customer Type"::"Deemed Export",
//                     "GST Customer Type"::"SEZ Unit",
//                     "GST Customer Type"::"SEZ Development"]
//                 THEN BEGIN
//                     CASE "GST Customer Type" OF
//                         "GST Customer Type"::Export:
//                             ExpCat := 'DIR';
//                         "GST Customer Type"::"Deemed Export":
//                             ExpCat := 'DEM';
//                         "GST Customer Type"::"SEZ Unit":
//                             ExpCat := 'SEZ';
//                         "GST Customer Type"::"SEZ Development":
//                             ExpCat := 'SED';
//                     END;
//                     IF "GST Without Payment of Duty" THEN
//                         WithPay := 'N'
//                     ELSE
//                         WithPay := 'Y';
//                     ShipBNo := COPYSTR("Bill Of Export No.", 1, 16);
//                     ShipBDt := FORMAT("Bill Of Export Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                     Port := "Exit Point";
//                     ExpDuty := 0;
//                     ;
//                     SalesCrMemoLine.SETRANGE("Document No.", "No.");
//                     IF SalesCrMemoLine.FINDSET THEN
//                         REPEAT
//                             ExpDuty += SalesInvoiceLine."Total GST Amount";
//                             IF GSTManagement.IsGSTApplicable(Structure) THEN
//                                 InvForCur := InvForCur + SalesCrMemoLine.Amount
//                             ELSE
//                                 InvForCur := InvForCur + SalesCrMemoLine.Amount;
//                         UNTIL SalesCrMemoLine.NEXT = 0;
//                     ForCur := COPYSTR("Currency Code", 1, 3);

//                     IF (RecCountry.GET("Bill-to Country/Region Code")) /*AND (RecCountry."e-Code"<>'') */THEN
//                         CntCode := COPYSTR("Bill-to Country/Region Code", 1, 2)
//                     ELSE
//                         CntCode := '';

//                     //  CntCode := COPYSTR("Bill-to Country/Region Code",1,2);
//                 END;
//             END;
//         WriteExpDtls(ExpCat, WithPay, ShipBNo, ShipBDt, Port, InvForCur, ForCur, CntCode, ExpDuty);

//     end;

//     local procedure WriteExpDtls(ExpCat: Text[3]; WithPay: Text[1]; ShipBNo: Text[16]; ShipBDt: Text[10]; Port: Text[10]; InvForCur: Decimal; ForCur: Text[3]; CntCode: Text[2]; ExpDuty: Decimal)
//     begin

//         JSONTextWriter.WritePropertyName('export_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('ship_bill_number');
//         IF ShipBNo <> '' THEN
//             JSONTextWriter.WriteValue(ShipBNo)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('ship_bill_date');
//         IF ShipBDt <> '' THEN
//             JSONTextWriter.WriteValue(ShipBDt)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('country_code');
//         IF CntCode <> '' THEN
//             JSONTextWriter.WriteValue(CntCode)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('foreign_currency');
//         IF ForCur <> '' THEN
//             JSONTextWriter.WriteValue(ForCur)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('refund_claim');
//         JSONTextWriter.WriteValue('N');
//         JSONTextWriter.WritePropertyName('port_code');
//         IF Port <> '' THEN
//             JSONTextWriter.WriteValue(Port)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('export_duty');
//         JSONTextWriter.WriteValue(ExpDuty);
//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadSellerDtls()
//     var
//         CompanyInformationBuff: Record "79";
//         LocationBuff: Record "14";
//         StateBuff: Record "13762";
//         Gstin: Text[15];
//         TrdNm: Text[100];
//         Bno: Text[60];
//         Bnm: Text[60];
//         Flno: Text[60];
//         Loc: Text[60];
//         Dst: Text[60];
//         Pin: Text[6];
//         Stcd: Text[2];
//         Ph: Text[10];
//         Em: Text[50];
//         Statename: Text;
//         recState: Record "13762";
//         recEwayEinvoice: Record "50000";
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 Gstin := "Location GST Reg. No.";
//                 CompanyInformationBuff.GET;
//                 TrdNm := CompanyInformationBuff.Name;
//                 LocationBuff.GET("Location Code");
//                 Bno := LocationBuff.Address;
//                 Bnm := LocationBuff."Address 2";
//                 Flno := '';
//                 Loc := LocationBuff.City;
//                 Dst := LocationBuff.City;
//                 Pin := COPYSTR(LocationBuff."Post Code", 1, 6);
//                 StateBuff.GET(LocationBuff."State Code");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                 recState.RESET;
//                 recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                 IF recState.FIND('-') THEN BEGIN
//                     Statename := recState.Description;
//                 END;
//                 Ph := COPYSTR(LocationBuff."Phone No.", 1, 10);
//                 Em := COPYSTR(LocationBuff."E-Mail", 1, 50);
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 Gstin := "Location GST Reg. No.";
//                 CompanyInformationBuff.GET;
//                 TrdNm := CompanyInformationBuff.Name;
//                 LocationBuff.GET("Location Code");
//                 Bno := LocationBuff.Address;
//                 Bnm := LocationBuff."Address 2";
//                 Flno := '';
//                 Loc := LocationBuff.City;
//                 Dst := LocationBuff.City;
//                 Pin := COPYSTR(LocationBuff."Post Code", 1, 6);
//                 StateBuff.GET(LocationBuff."State Code");
//                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                 recState.RESET;
//                 recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                 IF recState.FIND('-') THEN BEGIN
//                     Statename := recState.Description;
//                 END;
//                 Ph := COPYSTR(LocationBuff."Phone No.", 1, 10);
//                 Em := COPYSTR(LocationBuff."E-Mail", 1, 50);
//             END;

//         WriteSellerDtls(Gstin, TrdNm, Bno, Bnm, Flno, Loc, Dst, Pin, Stcd, Ph, Em, Statename);
//     end;

//     local procedure WriteSellerDtls(Gstin: Text[15]; TrdNm: Text[100]; Bno: Text[60]; Bnm: Text[60]; Flno: Text[60]; Loc: Text[60]; Dst: Text[60]; Pin: Text[6]; Stcd: Text[2]; Ph: Text[10]; Em: Text[50]; Statename: Text[70])
//     begin

//         JSONTextWriter.WritePropertyName('seller_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('gstin');
//         IF Gstin <> '' THEN
//             JSONTextWriter.WriteValue(Gstin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('legal_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('trade_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('address1');
//         IF Bno <> '' THEN
//             JSONTextWriter.WriteValue(Bno)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address2');
//         IF Bnm <> '' THEN
//             JSONTextWriter.WriteValue(Bnm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('location');
//         IF Loc <> '' THEN
//             JSONTextWriter.WriteValue(Loc)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('pincode');
//         IF Pin <> '' THEN
//             JSONTextWriter.WriteValue(Pin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('state_code');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Statename)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('phone_number');
//         IF Ph <> '' THEN
//             JSONTextWriter.WriteValue(Ph)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('email');
//         IF Em <> '' THEN
//             JSONTextWriter.WriteValue(Em)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadBuyerDtls()
//     var
//         Contact: Record "5050";
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         ShipToAddr: Record "222";
//         StateBuff: Record "13762";
//         Gstin: Text[15];
//         TrdNm: Text[100];
//         Bno: Text[60];
//         Bnm: Text[60];
//         Flno: Text[60];
//         Loc: Text[60];
//         Dst: Text[60];
//         Pin: Text[6];
//         Stcd: Text[2];
//         Ph: Text[10];
//         Em: Text[50];
//         Statename: Text;
//         recState: Record "13762";
//         recLoc: Record "14";
//         recCust: Record "18";
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 recLoc.GET(SalesInvoiceHeader."Location Code");
//                 //    Gstin := "Customer GST Reg. No.";
//                 IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export] THEN
//                     Gstin := 'URP'
//                 ELSE
//                     Gstin := "Customer GST Reg. No.";

//                 TrdNm := "Bill-to Name";
//                 Bno := "Bill-to Address";
//                 Bnm := "Bill-to Address 2";

//                 IF STRLEN(Bnm) < 3 THEN
//                     Bnm := Bnm + '...';
//                 Flno := '';
//                 IF "Bill-to City" <> '' THEN
//                     Loc := "Bill-to City"
//                 ELSE
//                     Loc := "Ship-to City";
//                 //    Loc := 'Outside Country';
//                 Dst := "Bill-to City";

//                 IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export] THEN
//                     Pin := '999999'
//                 ELSE
//                     Pin := COPYSTR("Bill-to Post Code", 1, 6);

//                 SalesInvoiceLine.SETRANGE("Document No.", "No.");
//                 SalesInvoiceLine.SETFILTER(Quantity, '<>%1', 0);
//                 IF SalesInvoiceLine.FINDFIRST THEN
//                     IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Bill-to Address" THEN BEGIN
//                         IF NOT ("GST Customer Type" = "GST Customer Type"::Export) THEN BEGIN
//                             StateBuff.GET("GST Bill-to State Code");
//                             Stcd := StateBuff."State Code (GST Reg. No.)";
//                         END ELSE
//                             Stcd := '96';

//                         IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export] THEN BEGIN
//                             Statename := '96'
//                         END
//                         ELSE
//                             IF SalesInvoiceHeader."GST Customer Type" <> SalesInvoiceHeader."GST Customer Type"::Export THEN BEGIN
//                                 recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                                 IF recState.FIND('-') THEN BEGIN
//                                     Statename := recState.Description;
//                                 END;
//                             END;

//                         IF Contact.GET("Bill-to Contact No.") THEN BEGIN
//                             Ph := '';// COPYSTR(Contact."Phone No.",1,10);
//                             Em := '';//COPYSTR(Contact."E-Mail",1,50);
//                         END ELSE BEGIN
//                             IF recCust.GET("Sell-to Customer No.") THEN BEGIN
//                                 Ph := ''; //srecCust."Phone No.";
//                                 Em := '';//recCust."E-Mail";
//                             END;
//                         END;
//                     END ELSE
//                         IF SalesInvoiceLine."GST Place of Supply" = SalesInvoiceLine."GST Place of Supply"::"Ship-to Address" THEN BEGIN
//                             IF NOT ("GST Customer Type" = "GST Customer Type"::Export) THEN BEGIN
//                                 StateBuff.GET("GST Ship-to State Code");
//                                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                             END ELSE
//                                 Stcd := '96';

//                             IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export] THEN BEGIN
//                                 Statename := '96'
//                             END
//                             ELSE
//                                 IF SalesInvoiceHeader."GST Customer Type" <> SalesInvoiceHeader."GST Customer Type"::Export THEN BEGIN
//                                     recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                                     IF recState.FIND('-') THEN BEGIN
//                                         Statename := recState.Description;
//                                     END;
//                                 END;

//                             IF ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code") THEN BEGIN
//                                 Ph := '';//COPYSTR(ShipToAddr."Phone No.",1,10);
//                                 Em := '';// COPYSTR(ShipToAddr."E-Mail",1,50);
//                             END ELSE BEGIN
//                                 IF recCust.GET("Sell-to Customer No.") THEN BEGIN
//                                     Ph := '';//recCust."Phone No.";
//                                     Em := '';//recCust."E-Mail";
//                                 END;
//                             END;
//                         END ELSE BEGIN
//                             Stcd := '';
//                             Ph := '';
//                             Em := '';
//                         END;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 recLoc.GET(SalesCrMemoHeader."Location Code");
//                 //    Gstin := "Customer GST Reg. No.";
//                 IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Export] THEN
//                     Gstin := 'URP'
//                 ELSE
//                     Gstin := "Customer GST Reg. No.";

//                 TrdNm := "Bill-to Name";
//                 Bno := "Bill-to Address";
//                 Bnm := "Bill-to Address 2";

//                 IF STRLEN(Bnm) < 3 THEN
//                     Bnm := Bnm + '...';

//                 Flno := '';
//                 Loc := "Bill-to City";
//                 Dst := "Bill-to City";

//                 IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Export] THEN
//                     Pin := '999999'
//                 ELSE
//                     Pin := COPYSTR("Bill-to Post Code", 1, 6);

//                 SalesCrMemoLine.SETRANGE("Document No.", "No.");
//                 SalesCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
//                 IF SalesCrMemoLine.FINDFIRST THEN
//                     IF SalesCrMemoLine."GST Place of Supply" = SalesCrMemoLine."GST Place of Supply"::"Bill-to Address" THEN BEGIN
//                         IF NOT ("GST Customer Type" = "GST Customer Type"::Export) THEN BEGIN
//                             StateBuff.GET("GST Bill-to State Code");
//                             Stcd := StateBuff."State Code (GST Reg. No.)";
//                         END ELSE
//                             Stcd := '96';

//                         IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Export] THEN BEGIN
//                             Statename := '96'
//                         END
//                         ELSE
//                             IF SalesCrMemoHeader."GST Customer Type" <> SalesCrMemoHeader."GST Customer Type"::Export THEN BEGIN
//                                 recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                                 IF recState.FIND('-') THEN BEGIN
//                                     Statename := recState.Description;
//                                 END;
//                             END;

//                         IF Contact.GET("Bill-to Contact No.") THEN BEGIN
//                             Ph := '';//COPYSTR(Contact."Phone No.",1,10);
//                             Em := '';//COPYSTR(Contact."E-Mail",1,50);
//                         END ELSE BEGIN
//                             IF recCust.GET("Sell-to Customer No.") THEN BEGIN
//                                 Ph := '';//recCust."Phone No.";
//                                 Em := '';//recCust."E-Mail";
//                             END;
//                         END;
//                     END ELSE
//                         IF SalesCrMemoLine."GST Place of Supply" = SalesCrMemoLine."GST Place of Supply"::"Ship-to Address" THEN BEGIN
//                             IF NOT ("GST Customer Type" = "GST Customer Type"::Export) THEN BEGIN
//                                 StateBuff.GET("GST Ship-to State Code");
//                                 Stcd := StateBuff."State Code (GST Reg. No.)";
//                             END ELSE
//                                 Stcd := '96';

//                             IF SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Export THEN BEGIN
//                                 Statename := '96'
//                             END
//                             ELSE
//                                 IF SalesCrMemoHeader."GST Customer Type" <> SalesCrMemoHeader."GST Customer Type"::Export THEN BEGIN
//                                     recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                                     IF recState.FIND('-') THEN BEGIN
//                                         Statename := recState.Description;
//                                     END;
//                                 END;


//                             IF ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code") THEN BEGIN
//                                 Ph := '';// COPYSTR(ShipToAddr."Phone No.",1,10);
//                                 Em := '';//COPYSTR(ShipToAddr."E-Mail",1,50);
//                             END ELSE BEGIN
//                                 IF recCust.GET("Sell-to Customer No.") THEN BEGIN
//                                     Ph := '';// recCust."Phone No.";
//                                     Em := '';// recCust."E-Mail";
//                                 END;
//                             END;
//                         END ELSE BEGIN
//                             Stcd := '';
//                             Ph := '';
//                             Em := '';
//                         END;
//             END;

//         WriteBuyerDtls(Gstin, TrdNm, Bno, Bnm, Flno, Loc, Dst, Pin, Stcd, Ph, Em, Statename);
//     end;

//     local procedure WriteBuyerDtls(Gstin: Text[15]; TrdNm: Text[100]; Bno: Text[60]; Bnm: Text[60]; Flno: Text[60]; Loc: Text[60]; Dst: Text[60]; Pin: Text[6]; Stcd: Text[2]; Ph: Text[10]; Em: Text[50]; Statename: Text)
//     begin

//         JSONTextWriter.WritePropertyName('buyer_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('gstin');
//         IF Gstin <> '' THEN
//             JSONTextWriter.WriteValue(Gstin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('legal_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('trade_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address1');
//         IF Bno <> '' THEN
//             JSONTextWriter.WriteValue(Bno)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address2');
//         IF Bnm <> '' THEN
//             JSONTextWriter.WriteValue(Bnm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('location');
//         IF Loc <> '' THEN
//             JSONTextWriter.WriteValue(Loc)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('pincode');
//         IF Pin <> '' THEN
//             JSONTextWriter.WriteValue(Pin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('place_of_supply');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Stcd)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('state_code');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Statename)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('phone_number');
//         IF Ph <> '' THEN
//             JSONTextWriter.WriteValue(Ph)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('email');
//         IF Em <> '' THEN
//             JSONTextWriter.WriteValue(Em)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadShipDtls()
//     var
//         ShipToAddr: Record "222";
//         StateBuff: Record "13762";
//         Gstin: Text[15];
//         TrdNm: Text[100];
//         Bno: Text[60];
//         Bnm: Text[60];
//         Flno: Text[60];
//         Loc: Text[60];
//         Dst: Text[60];
//         Pin: Text[6];
//         Stcd: Text[2];
//         Ph: Text[10];
//         Em: Text[50];
//         Statename: Text;
//         recState: Record "13762";
//         recLoc: Record "14";
//         Cust: Record "18";
//     begin
//         IF IsInvoice THEN BEGIN
//             WITH SalesInvoiceHeader DO BEGIN
//                 IF SalesInvoiceHeader."Ship-to Code" <> '' THEN BEGIN
//                     recLoc.GET(SalesInvoiceHeader."Location Code");
//                     ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
//                     Gstin := ShipToAddr."GST Registration No.";
//                     TrdNm := "Ship-to Name";
//                     Bno := "Ship-to Address";
//                     Bnm := "Ship-to Address 2";

//                     IF STRLEN(Bnm) < 3 THEN
//                         Bnm := Bnm + '...';

//                     Flno := '';
//                     Loc := "Ship-to City";
//                     IF Loc = '' THEN BEGIN
//                         recShiptoCode.RESET();
//                         recShiptoCode.SETRANGE(Code, SalesInvoiceHeader."Ship-to Code");
//                         IF recShiptoCode.FINDFIRST THEN
//                             Loc := recShiptoCode.City;
//                     END;
//                     Dst := "Ship-to City";
//                     Pin := COPYSTR("Ship-to Post Code", 1, 6);
//                     IF SalesInvoiceHeader."GST Customer Type" <> SalesInvoiceHeader."GST Customer Type"::Export THEN
//                         StateBuff.GET("GST Ship-to State Code");
//                     Stcd := StateBuff."State Code (GST Reg. No.)";

//                     IF SalesInvoiceHeader."GST Customer Type" = SalesInvoiceHeader."GST Customer Type"::Export THEN BEGIN
//                         Statename := 'Other Country';
//                         Pin := '999999';
//                         Stcd := '96';//ACXRaman 05022021
//                     END
//                     ELSE
//                         IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Registered, SalesInvoiceHeader."GST Customer Type"::Unregistered, SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                             recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                             IF recState.FIND('-') THEN BEGIN
//                                 Statename := recState.Description;
//                             END;
//                         END;

//                     Ph := COPYSTR(ShipToAddr."Phone No.", 1, 10);
//                     Em := COPYSTR(ShipToAddr."E-Mail", 1, 50);
//                 END
//                 ELSE
//                     IF SalesInvoiceHeader."Ship-to Code" = '' THEN BEGIN
//                         recLoc.GET(SalesInvoiceHeader."Location Code");
//                         Cust.GET("Sell-to Customer No.");
//                         Gstin := "Customer GST Reg. No.";
//                         TrdNm := SalesInvoiceHeader."Sell-to Customer Name";
//                         Bno := "Sell-to Address";
//                         Bnm := "Sell-to Address 2";

//                         IF STRLEN(Bnm) < 3 THEN
//                             Bnm := Bnm + '...';

//                         Flno := '';
//                         Loc := "Sell-to City";
//                         IF Loc = '' THEN BEGIN
//                             recCust.RESET();
//                             recCust.SETRANGE("No.", SalesInvoiceHeader."Sell-to Customer No.");
//                             IF recCust.FINDFIRST THEN
//                                 Loc := recCust.City;
//                         END;
//                         //      Loc := 'Outside Country';
//                         Dst := "Sell-to City";
//                         Pin := COPYSTR("Sell-to Post Code", 1, 6);
//                         IF StateBuff.GET(Cust."State Code") THEN
//                             Stcd := StateBuff."State Code (GST Reg. No.)";

//                         IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Export] THEN BEGIN
//                             Statename := '96';//'Other Country';
//                             Pin := '999999';
//                             Loc := Cust.City;
//                             Gstin := 'URP';
//                             Stcd := '96';
//                         END
//                         ELSE
//                             IF SalesInvoiceHeader."GST Customer Type" IN [SalesInvoiceHeader."GST Customer Type"::Registered, SalesInvoiceHeader."GST Customer Type"::Unregistered, SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                                 recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                                 IF recState.FIND('-') THEN BEGIN
//                                     Statename := recState.Description;
//                                 END;
//                             END;

//                         Ph := COPYSTR(Cust."Phone No.", 1, 10);
//                         Em := COPYSTR(Cust."E-Mail", 1, 50);
//                     END;
//             END;
//         END ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 IF SalesCrMemoHeader."Ship-to Code" <> '' THEN BEGIN
//                     recLoc.GET(SalesCrMemoHeader."Location Code");
//                     ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
//                     Gstin := ShipToAddr."GST Registration No.";
//                     /*TrdNm := "Ship-to Name";
//                     Bno := "Ship-to Address";
//                     Bnm := "Ship-to Address 2";
//                     Flno := '';
//                     Loc := "Ship-to City";
//                     Dst := "Ship-to City";
//                     Pin := COPYSTR("Ship-to Post Code",1,6);
//                     StateBuff.GET("GST Ship-to State Code");
//                     Stcd := StateBuff."State Code (GST Reg. No.)";*/
//                     TrdNm := ShipToAddr.Name;
//                     Bno := ShipToAddr.Address;
//                     Bnm := ShipToAddr."Address 2";

//                     IF STRLEN(Bnm) < 3 THEN
//                         Bnm := Bnm + '...';
//                     Flno := '';
//                     Loc := ShipToAddr.City;
//                     Dst := ShipToAddr.City;
//                     Pin := COPYSTR(ShipToAddr."Post Code", 1, 6);
//                     StateBuff.GET(ShipToAddr.State);
//                     Stcd := StateBuff."State Code (GST Reg. No.)";


//                     IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Export] THEN BEGIN
//                         Statename := 'Other Country';
//                         Stcd := '96';
//                         Gstin := 'URP';
//                         Pin := '999999';
//                     END
//                     ELSE
//                         IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Registered, SalesCrMemoHeader."GST Customer Type"::Unregistered, SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                             recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                             IF recState.FIND('-') THEN BEGIN
//                                 Statename := recState.Description;
//                             END;
//                         END;

//                     Ph := COPYSTR(ShipToAddr."Phone No.", 1, 10);
//                     Em := COPYSTR(ShipToAddr."E-Mail", 1, 50);
//                 END
//                 ELSE
//                     IF SalesCrMemoHeader."Ship-to Code" = '' THEN BEGIN
//                         recLoc.GET(SalesCrMemoHeader."Location Code");
//                         Cust.GET("Sell-to Customer No.");
//                         Gstin := "Customer GST Reg. No.";
//                         TrdNm := SalesCrMemoHeader."Sell-to Customer Name";
//                         Bno := "Sell-to Address";
//                         Bnm := "Sell-to Address 2";

//                         IF STRLEN(Bnm) < 3 THEN
//                             Bnm := Bnm + '...';
//                         Flno := '';
//                         Loc := "Sell-to City";
//                         Dst := "Sell-to City";
//                         Pin := COPYSTR("Sell-to Post Code", 1, 6);
//                         IF StateBuff.GET(Cust."State Code") THEN
//                             Stcd := StateBuff."State Code (GST Reg. No.)";

//                         IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Export] THEN BEGIN
//                             Statename := 'Other Country';
//                             Stcd := '96';
//                             Gstin := 'URP';
//                             Pin := '999999';
//                         END
//                         ELSE
//                             IF SalesCrMemoHeader."GST Customer Type" IN [SalesCrMemoHeader."GST Customer Type"::Registered, SalesCrMemoHeader."GST Customer Type"::Unregistered, SalesInvoiceHeader."GST Customer Type"::"SEZ Unit"] THEN BEGIN
//                                 recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//                                 IF recState.FIND('-') THEN BEGIN
//                                     Statename := recState.Description;
//                                 END;
//                             END;

//                         Ph := COPYSTR(Cust."Phone No.", 1, 10);
//                         Em := COPYSTR(Cust."E-Mail", 1, 50);
//                     END;
//             END;
//         WriteShipDtls(Gstin, TrdNm, Bno, Bnm, Flno, Loc, Dst, Pin, Stcd, Ph, Em, Statename);

//     end;

//     local procedure WriteShipDtls(Gstin: Text[15]; TrdNm: Text[100]; Bno: Text[60]; Bnm: Text[60]; Flno: Text[60]; Loc: Text[60]; Dst: Text[60]; Pin: Text[6]; Stcd: Text[2]; Ph: Text[10]; Em: Text[50]; Statename: Text)
//     begin

//         JSONTextWriter.WritePropertyName('ship_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('gstin');
//         IF Gstin <> '' THEN
//             JSONTextWriter.WriteValue(Gstin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('legal_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('trade_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address1');
//         IF Bno <> '' THEN
//             JSONTextWriter.WriteValue(Bno)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address2');
//         IF Bnm <> '' THEN
//             JSONTextWriter.WriteValue(Bnm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('location');
//         IF Loc <> '' THEN
//             JSONTextWriter.WriteValue(Loc)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('pincode');
//         IF Pin <> '' THEN
//             JSONTextWriter.WriteValue(Pin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('state_code');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Statename)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadValDtls()
//     var
//         AssVal: Decimal;
//         CgstVal: Decimal;
//         SgstVal: Decimal;
//         IgstVal: Decimal;
//         CesVal: Decimal;
//         StCesVal: Decimal;
//         CesNonAdval: Decimal;
//         Disc: Decimal;
//         OthChrg: Decimal;
//         TotInvVal: Decimal;
//         roundoffamount: Decimal;
//     begin
//         GetGSTVal(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, CesNonAdval, Disc, OthChrg, TotInvVal, roundoffamount);
//         WriteValDtls(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, CesNonAdval, Disc, OthChrg, TotInvVal, roundoffamount);
//     end;

//     local procedure WriteValDtls(Assval: Decimal; CgstVal: Decimal; SgstVAl: Decimal; IgstVal: Decimal; CesVal: Decimal; StCesVal: Decimal; CesNonAdVal: Decimal; Disc: Decimal; OthChrg: Decimal; TotInvVal: Decimal; roundoffamount: Decimal)
//     begin

//         JSONTextWriter.WritePropertyName('value_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('total_assessable_value');
//         JSONTextWriter.WriteValue(Assval);
//         JSONTextWriter.WritePropertyName('total_cgst_value');
//         JSONTextWriter.WriteValue(CgstVal);
//         JSONTextWriter.WritePropertyName('total_sgst_value');
//         JSONTextWriter.WriteValue(SgstVAl);
//         JSONTextWriter.WritePropertyName('total_igst_value');
//         JSONTextWriter.WriteValue(IgstVal);
//         JSONTextWriter.WritePropertyName('total_cess_value');
//         JSONTextWriter.WriteValue(CesVal);
//         JSONTextWriter.WritePropertyName('total_cess_nonadvol_value');
//         JSONTextWriter.WriteValue(CesNonAdVal);
//         JSONTextWriter.WritePropertyName('total_discount');
//         JSONTextWriter.WriteValue(0);
//         JSONTextWriter.WritePropertyName('total_other_charge');
//         JSONTextWriter.WriteValue(OthChrg);
//         JSONTextWriter.WritePropertyName('total_invoice_value');
//         JSONTextWriter.WriteValue(TotInvVal);
//         JSONTextWriter.WritePropertyName('total_cess_value_of_state');
//         JSONTextWriter.WriteValue(StCesVal);
//         JSONTextWriter.WritePropertyName('round_off_amount');
//         JSONTextWriter.WriteValue(roundoffamount);
//         JSONTextWriter.WritePropertyName('total_invoice_value_additional_currency');
//         JSONTextWriter.WriteValue(0);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadItemList()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         AssAmt: Decimal;
//         CgstRt: Decimal;
//         SgstRt: Decimal;
//         IgstRt: Decimal;
//         CesRt: Decimal;
//         CesNonAdval: Decimal;
//         StateCes: Decimal;
//         FreeQty: Decimal;
//         recSalesInvLine: Record "113";
//         Isservice: Text[2];
//         GSTBaseamt: Decimal;
//         GSTper: Decimal;
//         cessamount: Decimal;
//         statecessamount: Decimal;
//         statecessnonadvolamount: Decimal;
//         recILE: Record "32";
//         Expiry: Text;
//         Warranty: Text;
//         Lotno: Text;
//         itemattributedetails: Text;
//         itemattributevalue: Text;
//         recVE: Record "5802";
//         decDiscAmt: Decimal;
//         recStrOdrDet: Record "13798";
//         StrAmount: Decimal;
//         decUnitPrice: Decimal;
//         decUnitPricetoRoundoff: Decimal;
//         recSalesCrMemoHead: Record "114";
//         SrNo: Integer;
//         recDetailedGSTLedEntry: Record "16419";
//         RecPostedStrLineDetails: Record "13798";
//         DiscUnitPrice: Decimal;
//     begin
//         IF IsInvoice THEN BEGIN
//             recSalesInvHead.SETRANGE("No.", DocumentNo);
//             IF recSalesInvHead.FINDFIRST THEN BEGIN
//                 IF recSalesInvHead."Currency Code" = '' THEN
//                     CurrFector := 1
//                 ELSE
//                     CurrFector := recSalesInvHead."Currency Factor";
//             END;
//             SalesInvoiceLine.SETRANGE("Document No.", DocumentNo);
//             SalesInvoiceLine.SETFILTER(Quantity, '<>%1', 0);
//             SalesInvoiceLine.SETFILTER("No.", '<>%1', '427000210');
//             IF SalesInvoiceLine.FINDSET THEN BEGIN
//                 IF SalesInvoiceLine.COUNT > 100 THEN
//                     ERROR(SalesLinesErr, SalesInvoiceLine.COUNT);
//                 JSONTextWriter.WritePropertyName('item_list');
//                 JSONTextWriter.WriteStartArray;
//                 REPEAT
//                     decDiscAmt := ROUND(SalesInvoiceLine."Inv. Discount Amount" + SalesInvoiceLine."Line Discount Amount" / CurrFector, 0.01);
//                     IF SalesInvoiceLine."GST Assessable Value (LCY)" <> 0 THEN
//                         AssAmt := SalesInvoiceLine."GST Assessable Value (LCY)"
//                     ELSE BEGIN
//                         //ACXRaman 221220 begin
//                         recDetailedGSTLedEntry.RESET();
//                         recDetailedGSTLedEntry.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
//                         recDetailedGSTLedEntry.SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
//                         IF recDetailedGSTLedEntry.FINDFIRST THEN BEGIN
//                             AssAmt := ABS(recDetailedGSTLedEntry."GST Base Amount");
//                         END;
//                     END;
//                     //ACXRaman 221220 End

//                     //        AssAmt := (SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price") - decDiscAmt;
//                     IF SalesInvoiceLine."Free Supply" THEN
//                         FreeQty := SalesInvoiceLine.Quantity
//                     ELSE
//                         FreeQty := 0;
//                     GetGSTCompRate(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.",
//                       CgstRt, SgstRt, IgstRt, CesRt, CesNonAdval, StateCes);

//                     IF SalesInvoiceLine."GST Group Type" = SalesInvoiceLine."GST Group Type"::Goods THEN BEGIN
//                         Isservice := 'N';
//                     END ELSE BEGIN
//                         Isservice := 'Y';
//                     END;
//                     //ACXRaman 221220 begin
//                     recDetailedGSTLedEntry.RESET();
//                     recDetailedGSTLedEntry.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
//                     recDetailedGSTLedEntry.SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
//                     IF recDetailedGSTLedEntry.FINDFIRST THEN BEGIN
//                         GSTBaseamt := ABS(recDetailedGSTLedEntry."GST Base Amount");
//                     END;
//                     //ACXRaman 221220 End
//                     //AK-01
//                     decUnitPrice := 0;
//                     RecPostedStrLineDetails.RESET;
//                     RecPostedStrLineDetails.SETRANGE("Invoice No.", SalesInvoiceLine."Document No.");
//                     RecPostedStrLineDetails.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
//                     RecPostedStrLineDetails.SETFILTER("Tax/Charge Type", 'Charges');
//                     RecPostedStrLineDetails.SETFILTER(Amount, '<%1', 0);
//                     IF RecPostedStrLineDetails.FIND('-') THEN BEGIN
//                         REPEAT
//                             decUnitPrice += ABS(RecPostedStrLineDetails."Amount (LCY)");
//                         UNTIL RecPostedStrLineDetails.NEXT = 0;
//                     END;
//                     //AK-01 END
//                     //ACX-RK 220421 Begin //Unit Price calculation wish discount
//                     DiscUnitPrice := 0;
//                     RecPostedStrLineDetails.RESET;
//                     RecPostedStrLineDetails.SETRANGE("Invoice No.", SalesInvoiceLine."Document No.");
//                     RecPostedStrLineDetails.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
//                     RecPostedStrLineDetails.SETFILTER("Tax/Charge Type", 'Charges');
//                     RecPostedStrLineDetails.SETFILTER(Amount, '>%1', 0);
//                     IF RecPostedStrLineDetails.FIND('-') THEN BEGIN
//                         REPEAT
//                             DiscUnitPrice += ABS(RecPostedStrLineDetails."Amount (LCY)");
//                         UNTIL RecPostedStrLineDetails.NEXT = 0;
//                     END;
//                     //ACX-RK End
//                     //GSTBaseamt:=ROUND(SalesInvoiceLine."GST Base Amount");//AK-01
//                     IF SalesInvoiceLine."GST %" < 1 THEN
//                         GSTper := ROUND(SalesInvoiceLine."GST %", 0.01)
//                     ELSE
//                         GSTper := ROUND(SalesInvoiceLine."GST %", 1);
//                     cessamount := 0;
//                     statecessamount := 0;
//                     statecessnonadvolamount := 0;
//                     //ACX-KD 31032021 BEGIN
//                     IF AssAmt = 0 THEN
//                         AssAmt := SalesInvoiceLine."GST Base Amount";
//                     //ACX-KD 31032021 END

//                     /*
//                           WriteItem(
//                             SalesInvoiceLine."Line No.",SalesInvoiceLine.Description,
//                             SalesInvoiceLine."HSN/SAC Code",'',
//                             SalesInvoiceLine.Quantity,FreeQty,
//                             COPYSTR(SalesInvoiceLine."Unit of Measure Code",1,3),
//                             SalesInvoiceLine."Unit Price",
//                             SalesInvoiceLine."Li
//                             ne Amount" + SalesInvoiceLine."Line Discount Amount",
//                             SalesInvoiceLine."Line Discount Amount",0,
//                             AssAmt,CgstRt,SgstRt,IgstRt,CesRt,CesNonAdval,StateCes,
//                             SalesInvoiceLine."Amount Including Tax" + SalesInvoiceLine."Total GST Amount",
//                             SalesInvoiceLine."Line No.",Isservice,GSTBaseamt,GSTper,cessamount,statecessamount,statecessnonadvolamount,SalesInvoiceLine."Line No.");
//                     */
//                     WriteItem(
//                       SalesInvoiceLine."Line No.", SalesInvoiceLine.Description,
//                       SalesInvoiceLine."HSN/SAC Code", '',
//                       SalesInvoiceLine.Quantity, FreeQty,
//                       COPYSTR(SalesInvoiceLine."Unit of Measure Code", 1, 3),
//                       ROUND(SalesInvoiceLine."Unit Price" / CurrFector, 0.01) + DiscUnitPrice,
//                       ROUND((SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price") / CurrFector, 0.01) + DiscUnitPrice,
//                       ROUND(SalesInvoiceLine."Line Discount Amount" / CurrFector, 0.01) + ROUND(SalesInvoiceLine."Inv. Discount Amount" / CurrFector, 0.01) + decUnitPrice, 0,
//                       AssAmt, CgstRt, SgstRt, IgstRt, CesRt, CesNonAdval, StateCes,
//                       /*AssAmt + CgstRt+SgstRt+IgstRt+CesRt+CesNonAdval+StateCes+0*/SalesInvoiceLine."Amount To Customer",
//                       SalesInvoiceLine."Line No.", Isservice, GSTBaseamt, GSTper, cessamount, statecessamount, statecessnonadvolamount, SalesInvoiceLine."Line No.");

//                 UNTIL SalesInvoiceLine.NEXT = 0;
//                 JSONTextWriter.WriteEndArray;
//             END;
//         END ELSE BEGIN
//             SalesCrMemoHeader.SETRANGE("No.", DocumentNo);
//             IF SalesCrMemoHeader.FINDFIRST THEN BEGIN
//                 IF SalesCrMemoHeader."Currency Code" = '' THEN
//                     CurrFector := 1
//                 ELSE
//                     CurrFector := SalesCrMemoHeader."Currency Factor";
//             END;
//             SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
//             SalesCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
//             SalesCrMemoLine.SETFILTER("No.", '<>%1', '427000210');
//             IF SalesCrMemoLine.FIND('-') THEN BEGIN
//                 IF SalesCrMemoLine.COUNT > 100 THEN
//                     ERROR(SalesLinesErr, SalesCrMemoLine.COUNT);
//                 JSONTextWriter.WritePropertyName('item_list');
//                 JSONTextWriter.WriteStartArray;
//                 REPEAT
//                     decDiscAmt := ROUND(SalesCrMemoLine."Inv. Discount Amount" / CurrFector, 0.01) + ROUND(SalesCrMemoLine."Line Discount Amount" / CurrFector, 0.01);
//                     IF SalesCrMemoLine."GST Assessable Value (LCY)" <> 0 THEN
//                         AssAmt := SalesCrMemoLine."GST Assessable Value (LCY)"
//                     ELSE BEGIN
//                         //AK-01 221220 begin
//                         recDetailedGSTLedEntry.RESET();
//                         recDetailedGSTLedEntry.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
//                         recDetailedGSTLedEntry.SETRANGE("Document Line No.", SalesCrMemoLine."Line No.");
//                         IF recDetailedGSTLedEntry.FINDFIRST THEN BEGIN
//                             REPEAT
//                                 AssAmt := ABS(recDetailedGSTLedEntry."GST Base Amount");
//                             UNTIL recDetailedGSTLedEntry.NEXT = 0;
//                         END;
//                     END;
//                     // AssAmt := SalesCrMemoLine."GST Base Amount";
//                     //AK-01 221220 End
//                     //        AssAmt := (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price") - decDiscAmt;

//                     IF SalesCrMemoLine."Free Supply" THEN
//                         FreeQty := SalesCrMemoLine.Quantity
//                     ELSE
//                         FreeQty := 0;
//                     GetGSTCompRate(SalesCrMemoLine."Document No.", SalesCrMemoLine."Line No.",
//                       CgstRt, SgstRt, IgstRt, CesRt, CesNonAdval, StateCes);

//                     IF SalesCrMemoLine."GST Group Type" = SalesCrMemoLine."GST Group Type"::Goods THEN BEGIN
//                         Isservice := 'N';
//                     END ELSE BEGIN
//                         Isservice := 'Y';
//                     END;
//                     //AK-01 221220 begin
//                     recDetailedGSTLedEntry.RESET();
//                     recDetailedGSTLedEntry.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
//                     recDetailedGSTLedEntry.SETRANGE("Document Line No.", SalesCrMemoLine."Line No.");
//                     IF recDetailedGSTLedEntry.FINDFIRST THEN BEGIN
//                         GSTBaseamt := ABS(recDetailedGSTLedEntry."GST Base Amount");
//                     END;
//                     decUnitPrice := 0;
//                     RecPostedStrLineDetails.RESET;
//                     RecPostedStrLineDetails.SETRANGE("Invoice No.", SalesCrMemoLine."Document No.");
//                     RecPostedStrLineDetails.SETRANGE("Line No.", SalesCrMemoLine."Line No.");
//                     RecPostedStrLineDetails.SETFILTER("Tax/Charge Type", 'Charges');
//                     RecPostedStrLineDetails.SETFILTER(Amount, '<%1', 0);
//                     IF RecPostedStrLineDetails.FIND('-') THEN BEGIN
//                         REPEAT
//                             decUnitPrice += ABS(RecPostedStrLineDetails."Amount (LCY)");
//                         UNTIL RecPostedStrLineDetails.NEXT = 0;
//                     END;
//                     //AK-01 END
//                     //ACX-RK 220421 Begin //Unit Price calculation wish discount
//                     DiscUnitPrice := 0;
//                     RecPostedStrLineDetails.RESET;
//                     RecPostedStrLineDetails.SETRANGE("Invoice No.", SalesCrMemoLine."Document No.");
//                     RecPostedStrLineDetails.SETRANGE("Line No.", SalesCrMemoLine."Line No.");
//                     RecPostedStrLineDetails.SETFILTER("Tax/Charge Type", 'Charges');
//                     RecPostedStrLineDetails.SETFILTER(Amount, '>%1', 0);
//                     IF RecPostedStrLineDetails.FIND('-') THEN BEGIN
//                         REPEAT
//                             DiscUnitPrice += ABS(RecPostedStrLineDetails."Amount (LCY)");
//                         UNTIL RecPostedStrLineDetails.NEXT = 0;
//                     END;
//                     //ACX-RK End
//                     //  GSTBaseamt := SalesCrMemoLine."GST Base Amount";
//                     GSTBaseamt := ROUND((SalesCrMemoLine."GST Base Amount" / CurrFector), 0.01);
//                     GSTper := ROUND(SalesCrMemoLine."GST %", 1);
//                     cessamount := 0;
//                     statecessamount := 0;
//                     statecessnonadvolamount := 0;
//                     //AK-01 221220 End
//                     /*
//                           WriteItem(
//                             SalesCrMemoLine."Line No.",SalesCrMemoLine.Description,
//                             SalesCrMemoLine."HSN/SAC Code",'',
//                             SalesCrMemoLine.Quantity,FreeQty,
//                             COPYSTR(SalesCrMemoLine."Unit of Measure Code",1,3),
//                             SalesCrMemoLine."Unit Price",
//                             SalesCrMemoLine."Line Amount" + SalesCrMemoLine."Line Discount Amount",
//                             SalesCrMemoLine."Line Discount Amount",0,
//                             AssAmt,CgstRt,SgstRt,IgstRt,CesRt,CesNonAdval,StateCes,
//                             SalesCrMemoLine."Amount Including Tax" + SalesCrMemoLine."Total GST Amount",
//                             SalesCrMemoLine."Line No.",Isservice,GSTBaseamt,GSTper,cessamount,statecessamount,statecessnonadvolamount,SalesCrMemoLine."Line No.");
//                     */
//                     WriteItem(
//                       SalesCrMemoLine."Line No.", SalesCrMemoLine.Description,
//                       SalesCrMemoLine."HSN/SAC Code", '',
//                       SalesCrMemoLine.Quantity, FreeQty,
//                       COPYSTR(SalesCrMemoLine."Unit of Measure Code", 1, 3),
//                       ROUND((SalesCrMemoLine."Unit Price" / CurrFector), 0.01) + DiscUnitPrice,
//                       (SalesCrMemoLine.Quantity * ROUND(SalesCrMemoLine."Unit Price" / CurrFector, 0.01)) + DiscUnitPrice,
//                       ROUND(SalesCrMemoLine."Line Discount Amount" / CurrFector, 0.01) + ROUND(SalesCrMemoLine."Inv. Discount Amount" / CurrFector, 0.01) + decUnitPrice, 0,
//                       AssAmt, CgstRt, SgstRt, IgstRt, CesRt, CesNonAdval, StateCes,
//                       AssAmt + CgstRt + SgstRt + IgstRt + CesRt + CesNonAdval + StateCes + 0,
//                       SalesCrMemoLine."Line No.", Isservice, GSTBaseamt, GSTper, cessamount, statecessamount, statecessnonadvolamount, SalesCrMemoLine."Line No.");

//                 UNTIL SalesCrMemoLine.NEXT = 0;
//                 JSONTextWriter.WriteEndArray;
//             END;
//         END;

//     end;

//     local procedure WriteItem(PrdNm: Integer; PrdDesc: Text[100]; HsnCd: Text[8]; Barcde: Text[30]; Qty: Decimal; FreeQty: Decimal; Unit: Text[3]; UnitPrice: Decimal; TotAmt: Decimal; Discount: Decimal; OthChrg: Decimal; AssAmt: Decimal; CgstRt: Decimal; SgstRt: Decimal; IgstRt: Decimal; CesRt: Decimal; CesNonAdval: Decimal; StateCes: Decimal; TotItemVal: Decimal; SILineNo: Integer; IsService: Text[2]; GSTBaseamt: Decimal; GSTper: Decimal; cessamount: Decimal; statecessamount: Decimal; statecessnonadvolamount: Decimal; LineNo: Integer)
//     var
//         ValueEntry: Record "5802";
//         ItemLedgerEntry: Record "32";
//         ValueEntryRelation: Record "6508";
//         ItemTrackingManagement: Codeunit "6500";
//         InvoiceRowID: Text[250];
//         recSalesInvLine: Record "113";
//         recSalesCrMemoLine: Record "115";
//         recVE: Record "5802";
//         recSalesInvLine1: Record "113";
//         recSalesCrMemoLine1: Record "115";
//     begin

//         JSONTextWriter.WriteStartObject;
//         JSONTextWriter.WritePropertyName('item_serial_number');
//         //IF PrdNm <> '' THEN
//         IF (PrdNm <> 0) OR (PrdNm < 999999) THEN
//             JSONTextWriter.WriteValue(PrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('product_description');
//         IF PrdDesc <> '' THEN
//             JSONTextWriter.WriteValue(PrdDesc)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('is_service');
//         JSONTextWriter.WriteValue(IsService);

//         JSONTextWriter.WritePropertyName('hsn_code');
//         IF HsnCd <> '' THEN
//             JSONTextWriter.WriteValue(HsnCd)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('bar_code');
//         IF Barcde <> '' THEN
//             JSONTextWriter.WriteValue(Barcde)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('quantity');
//         JSONTextWriter.WriteValue(Qty);
//         JSONTextWriter.WritePropertyName('free_quantity');
//         JSONTextWriter.WriteValue(FreeQty);

//         JSONTextWriter.WritePropertyName('unit');
//         IF Unit <> '' THEN
//             JSONTextWriter.WriteValue(Unit)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('unit_price');
//         JSONTextWriter.WriteValue(UnitPrice);
//         JSONTextWriter.WritePropertyName('total_amount');
//         JSONTextWriter.WriteValue(TotAmt);
//         JSONTextWriter.WritePropertyName('pre_tax_value');
//         JSONTextWriter.WriteValue(GSTBaseamt);
//         JSONTextWriter.WritePropertyName('discount');
//         JSONTextWriter.WriteValue(Discount);
//         JSONTextWriter.WritePropertyName('other_charge');
//         JSONTextWriter.WriteValue(OthChrg);
//         JSONTextWriter.WritePropertyName('assessable_value');
//         JSONTextWriter.WriteValue(AssAmt);
//         JSONTextWriter.WritePropertyName('gst_rate');
//         JSONTextWriter.WriteValue(GSTper);
//         JSONTextWriter.WritePropertyName('igst_amount');
//         JSONTextWriter.WriteValue(IgstRt);
//         JSONTextWriter.WritePropertyName('cgst_amount');
//         JSONTextWriter.WriteValue(CgstRt);
//         JSONTextWriter.WritePropertyName('sgst_amount');
//         JSONTextWriter.WriteValue(SgstRt);
//         JSONTextWriter.WritePropertyName('cess_rate');
//         JSONTextWriter.WriteValue(CesRt);
//         JSONTextWriter.WritePropertyName('cess_amount');
//         JSONTextWriter.WriteValue(cessamount);
//         JSONTextWriter.WritePropertyName('cess_nonadvol_amount');
//         JSONTextWriter.WriteValue(CesNonAdval);
//         JSONTextWriter.WritePropertyName('state_cess_rate');
//         JSONTextWriter.WriteValue(StateCes);
//         JSONTextWriter.WritePropertyName('state_cess_amount');
//         JSONTextWriter.WriteValue(statecessamount);
//         JSONTextWriter.WritePropertyName('state_cess_nonadvol_amount');
//         JSONTextWriter.WriteValue(statecessnonadvolamount);
//         JSONTextWriter.WritePropertyName('total_item_value');
//         JSONTextWriter.WriteValue(TotItemVal);
//         JSONTextWriter.WritePropertyName('country_origin');
//         JSONTextWriter.WriteValue('91');
//         JSONTextWriter.WritePropertyName('order_line_reference');
//         JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('product_serial_number');
//         JSONTextWriter.WriteValue('');

//         IF IsInvoice THEN BEGIN
//             recVE.RESET();
//             recVE.SETRANGE("Document No.", DocumentNo);
//             recVE.SETRANGE("Document Line No.", LineNo);
//             IF recVE.FIND('-') THEN BEGIN
//                 JSONTextWriter.WritePropertyName('batch_details');
//                 JSONTextWriter.WriteStartObject;
//                 REPEAT
//                     ItemLedgerEntry.GET(recVE."Item Ledger Entry No.");
//                     WriteBchDtls(
//                     COPYSTR(ItemLedgerEntry."Lot No." + ItemLedgerEntry."Serial No.", 1, 20),
//                     FORMAT(ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>'),
//                     FORMAT(ItemLedgerEntry."Warranty Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//                 UNTIL recVE.NEXT = 0;
//                 JSONTextWriter.WriteEndObject;
//             END;
//         END
//         ELSE BEGIN
//             recVE.RESET();
//             recVE.SETRANGE("Document No.", DocumentNo);
//             recVE.SETRANGE("Document Line No.", LineNo);
//             IF recVE.FIND('-') THEN BEGIN
//                 JSONTextWriter.WritePropertyName('batch_details');
//                 JSONTextWriter.WriteStartObject;
//                 REPEAT
//                     ItemLedgerEntry.GET(recVE."Item Ledger Entry No.");
//                     WriteBchDtls(
//                     COPYSTR(ItemLedgerEntry."Lot No." + ItemLedgerEntry."Serial No.", 1, 20),
//                     FORMAT(ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>'),
//                     FORMAT(ItemLedgerEntry."Warranty Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//                 UNTIL recVE.NEXT = 0;
//                 JSONTextWriter.WriteEndObject;
//             END;
//         END;
//         /*
//         IF IsInvoice THEN
//           Attributedetails('','')
//         ELSE
//           Attributedetails('','');
//         */
//         JSONTextWriter.WriteEndObject();

//     end;

//     local procedure WriteBchDtls(Nm: Text[20]; ExpDt: Text[10]; WrDt: Text[10])
//     begin

//         JSONTextWriter.WritePropertyName('name');
//         IF Nm <> '' THEN
//             JSONTextWriter.WriteValue(Nm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('expiry_date');
//         IF ExpDt <> '' THEN
//             JSONTextWriter.WriteValue(ExpDt)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('warranty_date');
//         IF WrDt <> '' THEN
//             JSONTextWriter.WriteValue(WrDt)
//         ELSE
//             JSONTextWriter.WriteValue('');
//     end;

//     local procedure ExportAsJson(FileName: Text[20])
//     var
//         TempFile: File;
//         ToFile: Variant;
//         NewStream: InStream;
//     begin

//         TempFile.CREATETEMPFILE;
//         TempFile.WRITE(StringBuilder.ToString);
//         TempFile.CREATEINSTREAM(NewStream);
//         ToFile := FileName + '.json';
//         DOWNLOADFROMSTREAM(NewStream, 'e-Invoice', '', 'JSON files|*.json|All files (*.*)|*.*', ToFile);
//         TempFile.CLOSE;
//     end;


//     procedure SetSalesInvHeader(SalesInvoiceHeaderBuff: Record "112")
//     begin

//         CLEAR(SalesInvoiceHeader);
//         SalesInvoiceHeader := SalesInvoiceHeaderBuff;
//         IsInvoice := TRUE;
//     end;


//     procedure SetCrMemoHeader(SalesCrMemoHeaderBuff: Record "114")
//     begin
//         SalesCrMemoHeader := SalesCrMemoHeaderBuff;
//         IsInvoice := FALSE;
//     end;

//     local procedure GetRefInvNo(DocNo: Code[20]) RefInvNo: Code[20]
//     var
//         ReferenceInvoiceNo: Record "16470";
//     begin
//         ReferenceInvoiceNo.SETRANGE("Document No.", DocNo);
//         IF ReferenceInvoiceNo.FINDFIRST THEN
//             RefInvNo := ReferenceInvoiceNo."Reference Invoice Nos."
//         ELSE
//             RefInvNo := '';
//     end;

//     local procedure GetGSTCompRate(DocNo: Code[20]; LineNo: Integer; var CgstRt: Decimal; var SgstRt: Decimal; var IgstRt: Decimal; var CesRt: Decimal; var CesNonAdval: Decimal; var StateCes: Decimal)
//     var
//         DetailedGSTLedgerEntry: Record "16419";
//         GSTComponent: Record "16405";
//     begin
//         DetailedGSTLedgerEntry.SETRANGE("Document No.", DocNo);
//         DetailedGSTLedgerEntry.SETRANGE("Document Line No.", LineNo);

//         CgstRt := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             //  CgstRt := ABS(DetailedGSTLedgerEntry."GST Amount")
//             //ELSE
//             //  CgstRt := 0;
//             REPEAT
//                 CgstRt += ABS(DetailedGSTLedgerEntry."GST Amount")
//           UNTIL DetailedGSTLedgerEntry.NEXT = 0
//         ELSE
//             CgstRt := 0;

//         SgstRt := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             //  SgstRt := ABS(DetailedGSTLedgerEntry."GST Amount")
//             //ELSE
//             //  SgstRt := 0;
//             REPEAT
//                 SgstRt += ABS(DetailedGSTLedgerEntry."GST Amount")
//           UNTIL DetailedGSTLedgerEntry.NEXT = 0
//         ELSE
//             SgstRt := 0;

//         IgstRt := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             //  IgstRt := ABS(DetailedGSTLedgerEntry."GST Amount")
//             //ELSE
//             //  IgstRt := 0;
//             REPEAT
//                 IgstRt += ABS(DetailedGSTLedgerEntry."GST Amount")
//         UNTIL
//           DetailedGSTLedgerEntry.NEXT = 0
//         ELSE
//             IgstRt := 0;

//         CesRt := 0;
//         CesNonAdval := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             IF DetailedGSTLedgerEntry."GST %" > 0 THEN
//                 CesRt := DetailedGSTLedgerEntry."GST %"
//             ELSE
//                 CesNonAdval := ABS(DetailedGSTLedgerEntry."GST Amount");

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'INTERCESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             CesRt := DetailedGSTLedgerEntry."GST %";

//         StateCes := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code");
//         IF DetailedGSTLedgerEntry.FINDSET THEN
//             REPEAT
//                 IF NOT (DetailedGSTLedgerEntry."GST Component Code" IN ['CGST', 'SGST', 'IGST', 'CESS', 'INTERCESS'])
//                 THEN
//                     IF GSTComponent.GET(DetailedGSTLedgerEntry."GST Component Code") THEN
//                         IF GSTComponent."Exclude from Reports" THEN
//                             StateCes := DetailedGSTLedgerEntry."GST %";
//             UNTIL DetailedGSTLedgerEntry.NEXT = 0;
//     end;

//     local procedure GetGSTVal(var AssVal: Decimal; var CgstVal: Decimal; var SgstVal: Decimal; var IgstVal: Decimal; var CesVal: Decimal; var StCesVal: Decimal; var CesNonAdval: Decimal; var Disc: Decimal; var OthChrg: Decimal; var TotInvVal: Decimal; var roundoffamount: Decimal)
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         GSTLedgerEntry: Record "16418";
//         DetailedGSTLedgerEntry: Record "16419";
//         CurrExchRate: Record "330";
//         CustLedgerEntry: Record "21";
//         GSTComponent: Record "16405";
//         TotGSTAmt: Decimal;
//         recGLentry: Record "17";
//         recPostedStrOdrLine: Record "13798";
//         recSalesInvLine: Record "113";
//         recSalesCRMLine: Record "115";
//         decTDS: Decimal;
//         decStrDet: Decimal;
//         decPreTotalInvAmt: Decimal;
//         recDetailedGSTLedEntry: Record "16419";
//         Direction: Text;
//         Precesion: Integer;
//         FinTotInvVal: Decimal;
//         recSalesInvHeader: Record "112";
//         recSalesInvLine2: Record "113";
//         RecDgLe: Record "16419";
//         recTCSEntry: Record "16514";
//         DecTCSAmnt: Decimal;
//         recGSTLedEntry: Record "16418";
//         DecInvAmt: Decimal;
//         recSalesCrMemoHead: Record "114";
//     begin
//         CurrFector := 0;
//         recSalesInvHead.SETRANGE("No.", DocumentNo);
//         IF recSalesInvHead.FIND('-') THEN BEGIN
//             IF recSalesInvHead."Currency Code" = '' THEN
//                 CurrFector := 1
//             ELSE
//                 CurrFector := recSalesInvHead."Currency Factor";
//         END;
//         GSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
//         GSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 CgstVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             CgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 SgstVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             SgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 IgstVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             IgstVal := 0;

//         CesVal := 0;
//         CesNonAdval := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'INTERCESS');
//         IF GSTLedgerEntry.FINDSET THEN
//             REPEAT
//                 CesVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;

//         DetailedGSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             REPEAT
//                 IF DetailedGSTLedgerEntry."GST %" > 0 THEN
//                     CesVal += ABS(DetailedGSTLedgerEntry."GST Amount")
//                 ELSE
//                     CesNonAdval += ABS(DetailedGSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;

//         GSTLedgerEntry.SETFILTER("GST Component Code", '<>CGST|<>SGST|<>IGST|<>CESS|<>INTERCESS');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 IF GSTComponent.GET(GSTLedgerEntry."GST Component Code") THEN
//                     IF GSTComponent."Exclude from Reports" THEN
//                         StCesVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END;
//         IF IsInvoice THEN BEGIN
//             recSalesInvHead.SETRANGE("No.", DocumentNo);
//             CurrFector := 0;
//             IF recSalesInvHead.FIND('-') THEN BEGIN
//                 IF recSalesInvHead."Currency Code" = '' THEN
//                     CurrFector := 1
//                 ELSE
//                     CurrFector := recSalesInvHead."Currency Factor";
//             END;
//             SalesInvoiceLine.SETRANGE("Document No.", DocumentNo);
//             SalesInvoiceLine.SETFILTER("No.", '<>%1', '427000210');
//             IF SalesInvoiceLine.FINDSET THEN BEGIN
//                 REPEAT
//                     // AssVal += SalesInvoiceLine.Amount;
//                     TotGSTAmt += ROUND((SalesInvoiceLine."Total GST Amount" / CurrFector), 0.01);
//                     Disc += ROUND((SalesInvoiceLine."Inv. Discount Amount" / CurrFector), 0.01);
//                     decTDS += ROUND((SalesInvoiceLine."TDS/TCS Amount" / CurrFector), 0.01);
//                 UNTIL SalesInvoiceLine.NEXT = 0;
//             END;
//             //AK-01 BEGIN 23122020
//             RecDgLe.RESET;
//             RecDgLe.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
//             RecDgLe.SETFILTER("GST Jurisdiction Type", 'Interstate');
//             IF RecDgLe.FIND('-') THEN BEGIN
//                 REPEAT
//                     AssVal += ABS(RecDgLe."GST Base Amount");
//                 UNTIL RecDgLe.NEXT = 0;
//             END;
//             RecDgLe.RESET;
//             RecDgLe.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
//             RecDgLe.SETFILTER("GST Jurisdiction Type", 'Intrastate');
//             IF RecDgLe.FIND('-') THEN BEGIN
//                 REPEAT
//                     AssVal += ABS(RecDgLe."GST Base Amount") / 2;
//                 UNTIL RecDgLe.NEXT = 0;
//             END;
//             //AK-01 END 23122020
//             /*AssVal := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   WORKDATE,SalesInvoiceHeader."Currency Code",AssVal,SalesInvoiceHeader."Currency Factor"),0.01,'=');*/

//             /* TotGSTAmt := ROUND(
//                  CurrExchRate.ExchangeAmtFCYToLCY(
//                    WORKDATE,SalesInvoiceHeader."Currency Code",TotGSTAmt,SalesInvoiceHeader."Currency Factor"),0.01,'=');*/
//             Disc := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   WORKDATE, SalesInvoiceHeader."Currency Code", Disc, SalesInvoiceHeader."Currency Factor"), 0.01, '=');

//             roundoffamount := 0;
//             recSalesInvLine.RESET();
//             recSalesInvLine.SETRANGE("Document No.", DocumentNo);
//             recSalesInvLine.SETRANGE(Type, recSalesInvLine.Type::"G/L Account");
//             recSalesInvLine.SETRANGE("No.", '427000210');
//             IF recSalesInvLine.FIND('-') THEN BEGIN
//                 roundoffamount := ROUND(recSalesInvLine.Amount / CurrFector, 0.01);
//             END;

//             decStrDet := 0;
//             recPostedStrOdrLine.RESET();
//             recPostedStrOdrLine.SETRANGE("Invoice No.", DocumentNo);
//             recPostedStrOdrLine.SETRANGE("Tax/Charge Type", recPostedStrOdrLine."Tax/Charge Type"::Charges);
//             IF recPostedStrOdrLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     decStrDet := recPostedStrOdrLine."Amount (LCY)";
//                 UNTIL
//                   recPostedStrOdrLine.NEXT = 0;
//             END;
//             //AK-01 BEGIN
//             // DecTCSAmnt:=0;
//             recTCSEntry.RESET;
//             recTCSEntry.SETRANGE("Document No.", DocumentNo);
//             IF recTCSEntry.FIND('-') THEN BEGIN
//                 //   recTCSEntry.CALCSUMS("TDS/TCS Amount");
//                 DecTCSAmnt := recTCSEntry."TCS Amount";
//             END;
//             //MESSAGE(FORMAT(DecTCSAmnt));
//             OthChrg := DecTCSAmnt;
//             //AK-01 END


//             decPreTotalInvAmt := ROUND(((OthChrg + AssVal + CgstVal + IgstVal + SgstVal + roundoffamount) - Disc) / CurrFector, 0.01);
//             //AK-01 BEGIN
//             IF recSalesInvHead."GST Customer Type" = recSalesInvHead."GST Customer Type"::Export THEN BEGIN
//                 recGSTLedEntry.RESET();
//                 recGSTLedEntry.SETRANGE("Document No.", DocumentNo);
//                 IF recGSTLedEntry.FINDFIRST THEN BEGIN
//                     DecInvAmt := ABS(recGSTLedEntry."GST Base Amount" + recGSTLedEntry."GST Amount");
//                 END;
//             END;
//             IF recSalesInvHead."GST Customer Type" <> recSalesInvHead."GST Customer Type"::Export THEN BEGIN
//                 recSalesInvLine.RESET;
//                 recSalesInvLine.SETRANGE("Document No.", DocumentNo);
//                 IF recSalesInvLine.FIND('-') THEN BEGIN
//                     REPEAT
//                         DecInvAmt += recSalesInvLine."Amount To Customer";
//                     UNTIL
//                   recSalesInvLine.NEXT = 0;
//                 END;
//             END;
//             //ACX-RK End
//             TotInvVal := DecInvAmt;
//             //AK-01 END

//             //ACX-KD 31032021 BEGIN
//             IF AssVal = 0 THEN
//                 AssVal := TotInvVal;
//             //ACX-KD 31032021 END

//         END ELSE BEGIN
//             recSalesCrMemoHead.SETRANGE("No.", DocumentNo);
//             IF recSalesCrMemoHead.FIND('-') THEN BEGIN
//                 IF recSalesCrMemoHead."Currency Code" = '' THEN
//                     CurrFector := 1
//                 ELSE
//                     CurrFector := recSalesCrMemoHead."Currency Factor";
//             END;
//             SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
//             SalesCrMemoLine.SETFILTER("No.", '<>%1', '427000210');
//             IF SalesCrMemoLine.FINDSET THEN BEGIN
//                 REPEAT
//                     // AssVal += SalesCrMemoLine.Amount;
//                     TotGSTAmt += ROUND(SalesCrMemoLine."Total GST Amount" / CurrFector, 0.01);
//                     Disc += ROUND(SalesCrMemoLine."Inv. Discount Amount" / CurrFector, 0.01);
//                     decTDS += ROUND(SalesInvoiceLine."TDS/TCS Amount" / CurrFector, 0.01);
//                 UNTIL SalesCrMemoLine.NEXT = 0;
//             END;
//             //AK-01 BEGIN 23122020

//             RecDgLe.RESET;
//             RecDgLe.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
//             RecDgLe.SETFILTER("GST Jurisdiction Type", 'Interstate');
//             IF RecDgLe.FIND('-') THEN BEGIN
//                 REPEAT
//                     AssVal += ABS(RecDgLe."GST Base Amount");
//                 UNTIL RecDgLe.NEXT = 0;
//             END;
//             RecDgLe.RESET;
//             RecDgLe.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
//             RecDgLe.SETFILTER("GST Jurisdiction Type", 'Intrastate');
//             IF RecDgLe.FIND('-') THEN BEGIN
//                 REPEAT
//                     AssVal += ABS(RecDgLe."GST Base Amount") / 2;
//                 UNTIL RecDgLe.NEXT = 0;
//             END;
//             //AK-01 END 23122020
//             /*AssVal := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   WORKDATE,SalesCrMemoHeader."Currency Code",AssVal,SalesCrMemoHeader."Currency Factor"),0.01,'=');*/
//             /*TotGSTAmt := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   WORKDATE,SalesCrMemoHeader."Currency Code",TotGSTAmt,SalesCrMemoHeader."Currency Factor"),0.01,'=');
//             Disc := ROUND(
//                 CurrExchRate.ExchangeAmtFCYToLCY(
//                   WORKDATE,SalesCrMemoHeader."Currency Code",Disc,SalesCrMemoHeader."Currency Factor"),0.01,'=');*/

//             roundoffamount := 0;
//             recSalesCRMLine.RESET();
//             recSalesCRMLine.SETRANGE("Document No.", DocumentNo);
//             recSalesCRMLine.SETRANGE(Type, recSalesCRMLine.Type::"G/L Account");
//             recSalesCRMLine.SETRANGE("No.", '427000210');
//             IF recSalesCRMLine.FIND('-') THEN BEGIN
//                 roundoffamount := ROUND(recSalesCRMLine.Amount / CurrFector, 0.01);
//             END;

//             decStrDet := 0;
//             recPostedStrOdrLine.RESET();
//             recPostedStrOdrLine.SETRANGE("Invoice No.", DocumentNo);
//             recPostedStrOdrLine.SETRANGE("Tax/Charge Type", recPostedStrOdrLine."Tax/Charge Type"::Charges);
//             IF recPostedStrOdrLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     decStrDet := recPostedStrOdrLine."Amount (LCY)";
//                 UNTIL
//                   recPostedStrOdrLine.NEXT = 0;
//             END;
//             //AK-01 BEGIN
//             DecTCSAmnt := 0;
//             recSalesCRMLine.RESET;
//             recSalesCRMLine.SETRANGE("Document No.", DocumentNo);
//             IF recSalesCRMLine.FIND('-') THEN BEGIN
//                 recSalesCRMLine.CALCSUMS("TDS/TCS Amount");
//                 DecTCSAmnt := ROUND(recSalesCRMLine."TDS/TCS Amount" / CurrFector, 0.01);
//             END;
//             //MESSAGE(FORMAT(DecTCSAmnt));
//             OthChrg := DecTCSAmnt;
//             //AK-01 END
//             decPreTotalInvAmt := 0;
//             decPreTotalInvAmt := (OthChrg + AssVal + CgstVal + IgstVal + SgstVal + roundoffamount) - Disc;
//             //AK-01 BEGIN
//             recSalesCRMLine.RESET;
//             recSalesCRMLine.SETRANGE("Document No.", DocumentNo);
//             IF recSalesCRMLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     DecInvAmt += recSalesCRMLine."Amount To Customer";
//                 UNTIL
//               recSalesCRMLine.NEXT = 0;
//             END;
//             TotInvVal := ROUND(DecInvAmt / CurrFector, 0.01);

//         END;
//         /*
//         CustLedgerEntry.SETCURRENTKEY("Document No.");
//         CustLedgerEntry.SETRANGE("Document No.",DocumentNo);
//         IF IsInvoice THEN BEGIN
//           CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
//           CustLedgerEntry.SETRANGE("Customer No.",SalesInvoiceHeader."Bill-to Customer No.");
//         END ELSE BEGIN
//           CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::"Credit Memo");
//           CustLedgerEntry.SETRANGE("Customer No.",SalesCrMemoHeader."Bill-to Customer No.");
//         END;
//         IF CustLedgerEntry.FINDFIRST THEN BEGIN
//           CustLedgerEntry.CALCFIELDS("Amount (LCY)");
//           TotInvVal := ABS(CustLedgerEntry."Amount (LCY)");
//         END;
//         */
//         /*
//         OthChrg := 0;
        
//         roundoffamount := 0;
//         recGLentry.RESET();
//         recGLentry.SETRANGE("Document No.",DocumentNo);
//         recGLentry.SETRANGE("G/L Account No.",'2131110');
//           IF recGLentry.FIND('-') THEN BEGIN
//             roundoffamount := recGLentry.Amount * (-1);
//           END;
//         */

//     end;

//     local procedure BatchDetail(Lotno: Text; Expiry: Text; Warranty: Text)
//     begin

//         JSONTextWriter.WritePropertyName('batch_details');
//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WritePropertyName('name');
//         IF Lotno <> '' THEN
//             JSONTextWriter.WriteValue(Lotno)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('expiry_date');
//         JSONTextWriter.WriteValue(Expiry);
//         JSONTextWriter.WritePropertyName('warranty_date');
//         JSONTextWriter.WriteValue(Warranty);

//         JSONTextWriter.WriteEndArray;
//     end;

//     local procedure Attributedetails(itemattributedetails: Text; itemattributevalue: Text)
//     begin

//         JSONTextWriter.WritePropertyName('attribute_details');
//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('item_attribute_details');
//         IF itemattributedetails <> '' THEN
//             JSONTextWriter.WriteValue(itemattributedetails)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('item_attribute_value');
//         IF itemattributevalue <> '' THEN
//             JSONTextWriter.WriteValue(itemattributevalue)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;

//         JSONTextWriter.WriteEndArray;
//     end;

//     local procedure ReadDispDtls()
//     var
//         company_name: Text;
//         address1: Text;
//         address2: Text;
//         location: Text;
//         pincode: Text;
//         state_code: Text;
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recState: Record "13762";
//         Gstin: Code[15];
//         CompanyInformationBuff: Record "79";
//         TrdNm: Text;
//         LocationBuff: Record "14";
//         Bno: Text;
//         Bnm: Text;
//         Flno: Text;
//         Loc: Text;
//         Dst: Text;
//         Pin: Code[10];
//         StateBuff: Record "13762";
//         Stcd: Code[15];
//         Statename: Text;
//         Ph: Text;
//         Em: Text;
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 Gstin := 'GSTIN :';
//                 recLoc.GET(SalesInvoiceHeader."Location Code");
//                 recCompInfo.GET();
//                 company_name := recCompInfo.Name;
//                 address1 := recLoc.Address + ' ' + recLoc."Address 2";
//                 IF Gstin <> '' THEN
//                     address2 := Gstin + ' ' + "Location GST Reg. No.";
//                 location := recLoc.City;
//                 pincode := recLoc."Post Code";
//                 recState.RESET();
//                 recState.SETRANGE(Code, recLoc."State Code");
//                 IF recState.FIND('-') THEN
//                     state_code := recState.Description;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 recLoc.GET(SalesCrMemoHeader."Location Code");
//                 recCompInfo.GET();
//                 company_name := recLoc.Name;
//                 address1 := recLoc.Address;
//                 address2 := recLoc."Address 2";
//                 location := recLoc.City;
//                 pincode := recLoc."Post Code";
//                 recState.RESET();
//                 recState.SETRANGE(Code, recLoc."State Code");
//                 IF recState.FIND('-') THEN
//                     state_code := recState.Description;
//             END;

//         WriteDispDtls(Gstin, company_name, address1, address2, location, pincode, state_code);
//     end;

//     local procedure WriteDispDtls(Gstin: Code[15]; company_name: Text; address1: Text; address2: Text; location: Text; pincode: Code[10]; state_code: Code[20])
//     begin
//         JSONTextWriter.WritePropertyName('dispatch_details');
//         JSONTextWriter.WriteStartObject;
//         JSONTextWriter.WritePropertyName('gstin');
//         JSONTextWriter.WriteValue(Gstin);
//         JSONTextWriter.WritePropertyName('company_name');
//         JSONTextWriter.WriteValue(company_name);
//         JSONTextWriter.WritePropertyName('address1');
//         JSONTextWriter.WriteValue(address1);
//         JSONTextWriter.WritePropertyName('address2');
//         JSONTextWriter.WriteValue(address2);
//         JSONTextWriter.WritePropertyName('location');
//         JSONTextWriter.WriteValue(location);
//         JSONTextWriter.WritePropertyName('pincode');
//         JSONTextWriter.WriteValue(pincode);
//         JSONTextWriter.WritePropertyName('state_code');
//         JSONTextWriter.WriteValue(state_code);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadPaymentDtls()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recState: Record "13762";
//         bankaccno: Text;
//         paidbalamt: Decimal;
//         creditdays: Decimal;
//         credittransfer: Text;
//         directdebit: Text;
//         branchIFSC: Text;
//         paymentmode: Text;
//         payeename: Text;
//         paymentduedate: Text;
//         paymentinstruction: Text;
//         paymentterm: Text;
//     begin

//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 recLoc.GET(SalesInvoiceHeader."Location Code");
//                 recCompInfo.GET();
//                 bankaccno := '';
//                 paidbalamt := 0;
//                 creditdays := 0;
//                 credittransfer := '';
//                 directdebit := '';
//                 branchIFSC := '';
//                 paymentmode := '';
//                 payeename := '';
//                 paymentduedate := '';
//                 paymentinstruction := '';
//                 paymentterm := '';
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 recLoc.GET(SalesCrMemoHeader."Location Code");
//                 recCompInfo.GET();
//                 bankaccno := '';
//                 paidbalamt := 0;
//                 creditdays := 0;
//                 credittransfer := '';
//                 directdebit := '';
//                 branchIFSC := '';
//                 paymentmode := '';
//                 payeename := '';
//                 paymentduedate := '';
//                 paymentinstruction := '';
//                 paymentterm := '';
//             END;

//         WritePaymentDtls(bankaccno, paidbalamt, creditdays, credittransfer, directdebit, branchIFSC, paymentmode, payeename, paymentduedate, paymentinstruction, paymentterm);
//     end;

//     local procedure WritePaymentDtls(bankaccno: Text; paidbalamt: Decimal; creditdays: Decimal; credittransfer: Text; directdebit: Text; branchIFSC: Text; paymentmode: Text; payeename: Text; paymentduedate: Text; paymentinstruction: Text; paymentterm: Text)
//     begin

//         JSONTextWriter.WritePropertyName('payment_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('bank_account_number');
//         JSONTextWriter.WriteValue(bankaccno);
//         JSONTextWriter.WritePropertyName('paid_balance_amount');
//         JSONTextWriter.WriteValue(paidbalamt);
//         JSONTextWriter.WritePropertyName('credit_days');
//         JSONTextWriter.WriteValue(creditdays);
//         JSONTextWriter.WritePropertyName('credit_transfer');
//         JSONTextWriter.WriteValue(credittransfer);
//         JSONTextWriter.WritePropertyName('direct_debit');
//         JSONTextWriter.WriteValue(directdebit);
//         JSONTextWriter.WritePropertyName('branch_or_ifsc');
//         JSONTextWriter.WriteValue(branchIFSC);
//         JSONTextWriter.WritePropertyName('payment_mode');
//         JSONTextWriter.WriteValue(paymentmode);
//         JSONTextWriter.WritePropertyName('payee_name');
//         JSONTextWriter.WriteValue(payeename);
//         JSONTextWriter.WritePropertyName('payment_due_date');
//         JSONTextWriter.WriteValue(paymentduedate);
//         JSONTextWriter.WritePropertyName('payment_instruction');
//         JSONTextWriter.WriteValue(paymentinstruction);
//         JSONTextWriter.WritePropertyName('payment_term');
//         JSONTextWriter.WriteValue(paymentterm);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadAdditionalDocumentDtls()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recState: Record "13762";
//         supportingdocumenturl: Text;
//         supportingdocument: Text;
//         additionalinfo: Text;
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 JSONTextWriter.WritePropertyName('additional_document_details');
//                 JSONTextWriter.WriteStartArray;

//                 recLoc.GET(SalesInvoiceHeader."Location Code");
//                 recCompInfo.GET();
//                 supportingdocument := '';
//                 supportingdocumenturl := '';
//                 additionalinfo := '';

//                 WriteAdditionalDocumentDtls(supportingdocument, supportingdocumenturl, additionalinfo);

//                 JSONTextWriter.WriteEndArray;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 JSONTextWriter.WritePropertyName('additional_document_details');
//                 JSONTextWriter.WriteStartArray;
//                 recLoc.GET(SalesCrMemoHeader."Location Code");
//                 recCompInfo.GET();
//                 supportingdocument := '';
//                 supportingdocumenturl := '';
//                 additionalinfo := '';

//                 WriteAdditionalDocumentDtls(supportingdocument, supportingdocumenturl, additionalinfo);

//                 JSONTextWriter.WriteEndArray;
//             END;
//     end;

//     local procedure WriteAdditionalDocumentDtls(supportingdocumenturl: Text; supportingdocument: Text; additionalinfo: Text)
//     begin

//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('supporting_document_url');
//         JSONTextWriter.WriteValue(supportingdocument);
//         JSONTextWriter.WritePropertyName('supporting_document');
//         JSONTextWriter.WriteValue(supportingdocumenturl);
//         JSONTextWriter.WritePropertyName('additional_information');
//         JSONTextWriter.WriteValue(additionalinfo);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadEwaybillDtls()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recVend: Record "23";
//         transporterid: Text;
//         transportername: Text;
//         transportationmode: Text;
//         transportationdistance: Text;
//         transporterdocumentnumber: Text;
//         transporterdocumentdate: Text;
//         vehiclenumber: Text;
//         vehicletype: Text;
//         recEinvoice: Record "50000";
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 IF recVend.GET(SalesInvoiceHeader."Transporter Code") THEN
//                     transportername := recVend.Name
//                 ELSE
//                     transportername := '';

//                 transporterid := recVend."GST Registration No.";

//                 IF SalesInvoiceHeader."Mode of Transport" = 'Road' THEN
//                     transportationmode := '1'
//                 ELSE
//                     IF SalesInvoiceHeader."Mode of Transport" = 'Rail' THEN
//                         transportationmode := '2'
//                     ELSE
//                         IF SalesInvoiceHeader."Mode of Transport" = 'Air' THEN
//                             transportationmode := '3'
//                         ELSE
//                             IF SalesInvoiceHeader."Mode of Transport" = 'Ship' THEN
//                                 transportationmode := '4'
//                             ELSE
//                                 IF SalesInvoiceHeader."Mode of Transport" = '' THEN
//                                     transportationmode := '';

//                 recEinvoice.RESET();
//                 recEinvoice.SETRANGE("No.", SalesInvoiceHeader."No.");
//                 IF recEinvoice.FIND('-') THEN
//                     transportationdistance := recEinvoice."Distance (Km)"
//                 ELSE
//                     transportationdistance := '';

//                 transporterdocumentnumber := SalesInvoiceHeader."LR/RR No.";
//                 transporterdocumentdate := FORMAT(SalesInvoiceHeader."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');

//                 vehiclenumber := SalesInvoiceHeader."Vehicle No.";

//                 IF SalesInvoiceHeader."Vehicle Type" = SalesInvoiceHeader."Vehicle Type"::ODC THEN
//                     vehicletype := 'O'
//                 ELSE
//                     IF SalesInvoiceHeader."Vehicle Type" = SalesInvoiceHeader."Vehicle Type"::Regular THEN
//                         vehicletype := 'R'
//                     ELSE
//                         IF SalesInvoiceHeader."Vehicle Type" = SalesInvoiceHeader."Vehicle Type"::" " THEN
//                             vehicletype := '';
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 IF recVend.GET(SalesCrMemoHeader."Transporter Code") THEN
//                     transportername := recVend.Name
//                 ELSE
//                     transportername := '';

//                 transporterid := recVend."GST Registration No.";

//                 IF SalesInvoiceHeader."Mode of Transport" = 'Road' THEN
//                     transportationmode := '1'
//                 ELSE
//                     IF SalesInvoiceHeader."Mode of Transport" = 'Rail' THEN
//                         transportationmode := '2'
//                     ELSE
//                         IF SalesInvoiceHeader."Mode of Transport" = 'Air' THEN
//                             transportationmode := '3'
//                         ELSE
//                             IF SalesInvoiceHeader."Mode of Transport" = 'Ship' THEN
//                                 transportationmode := '4'
//                             ELSE
//                                 IF SalesInvoiceHeader."Mode of Transport" = '' THEN
//                                     transportationmode := '';

//                 //    transportationmode := FORMAT(recEinvoice."Transportation Mode");

//                 recEinvoice.RESET();
//                 recEinvoice.SETRANGE("No.", SalesCrMemoHeader."No.");
//                 IF recEinvoice.FIND('-') THEN
//                     transportationdistance := recEinvoice."Distance (Km)"
//                 ELSE
//                     transportationdistance := '';

//                 transporterdocumentnumber := '';
//                 transporterdocumentdate := '';

//                 vehiclenumber := SalesCrMemoHeader."Vehicle No.";

//                 IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::ODC THEN
//                     vehicletype := 'O'
//                 ELSE
//                     IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::Regular THEN
//                         vehicletype := 'R'
//                     ELSE
//                         IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::" " THEN
//                             vehicletype := '';
//             END;

//         WriteEwaybilDtls(transporterid, transportername, transportationmode, transportationdistance, transporterdocumentnumber, transporterdocumentdate, vehiclenumber, vehicletype);
//     end;

//     local procedure WriteEwaybilDtls(transporterid: Text; transportername: Text; transportationmode: Text; transportationdistance: Text; transporterdocumentnumber: Text; transporterdocumentdate: Text; vehiclenumber: Text; vehicletype: Text)
//     begin

//         JSONTextWriter.WritePropertyName('ewaybill_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('transporter_id');
//         JSONTextWriter.WriteValue(transporterid);
//         JSONTextWriter.WritePropertyName('transporter_name');
//         JSONTextWriter.WriteValue(transportername);
//         JSONTextWriter.WritePropertyName('transportation_mode');
//         JSONTextWriter.WriteValue(transportationmode);
//         JSONTextWriter.WritePropertyName('transportation_distance');
//         JSONTextWriter.WriteValue(transportationdistance);
//         JSONTextWriter.WritePropertyName('transporter_document_number');
//         JSONTextWriter.WriteValue(transporterdocumentnumber);
//         JSONTextWriter.WritePropertyName('transporter_document_date');
//         JSONTextWriter.WriteValue(transporterdocumentdate);
//         JSONTextWriter.WritePropertyName('vehicle_number');
//         JSONTextWriter.WriteValue(vehiclenumber);
//         JSONTextWriter.WritePropertyName('vehicle_type');
//         JSONTextWriter.WriteValue(vehicletype);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadReferenceDtls()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         invoiceremarks: Text;
//         invoiceperiodstartdate: Text;
//         invoiceperiodenddate: Text;
//         referenceoforiginalinvoice: Text;
//         precedinginvoicedate: Text;
//         otherreference: Text;
//         receiptadvicenumber: Text;
//         receiptadvicedate: Text;
//         batchreferencenumber: Text;
//         contractreferencenumber: Text;
//         otherreferenceContract: Text;
//         projectreferencenumber: Text;
//         vendorporeferencenumber: Text;
//         vendorporeferencedate: Text;
//     begin
//         IF IsInvoice THEN
//             WITH SalesInvoiceHeader DO BEGIN
//                 invoiceremarks := '';
//                 invoiceperiodstartdate := FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 invoiceperiodenddate := FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 ;
//                 referenceoforiginalinvoice := SalesInvoiceHeader."No.";
//                 precedinginvoicedate := FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 otherreference := '';
//                 receiptadvicenumber := '';
//                 receiptadvicedate := '';
//                 batchreferencenumber := '';
//                 contractreferencenumber := '';
//                 otherreferenceContract := '';
//                 projectreferencenumber := '';
//                 vendorporeferencenumber := SalesInvoiceHeader."External Document No.";
//                 vendorporeferencedate := FORMAT(SalesInvoiceHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 ;
//             END
//         ELSE
//             WITH SalesCrMemoHeader DO BEGIN
//                 invoiceremarks := '';
//                 invoiceperiodstartdate := FORMAT(SalesCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 ;
//                 invoiceperiodenddate := FORMAT(SalesCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 ;
//                 referenceoforiginalinvoice := '';
//                 precedinginvoicedate := '';
//                 otherreference := '';
//                 receiptadvicenumber := '';
//                 receiptadvicedate := '';
//                 batchreferencenumber := '';
//                 contractreferencenumber := '';
//                 otherreferenceContract := '';
//                 projectreferencenumber := '';
//                 vendorporeferencenumber := SalesCrMemoHeader."External Document No.";
//                 vendorporeferencedate := FORMAT(SalesCrMemoHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 ;
//             END;

//         WriteReferenceDtls(invoiceremarks, invoiceperiodstartdate, invoiceperiodenddate, referenceoforiginalinvoice, precedinginvoicedate, otherreference, receiptadvicenumber, receiptadvicedate, batchreferencenumber, contractreferencenumber, otherreferenceContract
//         ,
//                             projectreferencenumber, vendorporeferencenumber, vendorporeferencedate);
//     end;

//     local procedure WriteReferenceDtls(invoiceremarks: Text; invoiceperiodstartdate: Text; invoiceperiodenddate: Text; referenceoforiginalinvoice: Text; precedinginvoicedate: Text; otherreference: Text; receiptadvicenumber: Text; receiptadvicedate: Text; batchreferencenumber: Text; contractreferencenumber: Text; otherreferenceContract: Text; projectreferencenumber: Text; vendorporeferencenumber: Text; vendorporeferencedate: Text)
//     begin

//         JSONTextWriter.WritePropertyName('reference_details');
//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('invoice_remarks');
//         JSONTextWriter.WriteValue(invoiceremarks);

//         JSONTextWriter.WritePropertyName('document_period_details');
//         JSONTextWriter.Formatting;
//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('invoice_period_start_date');
//         JSONTextWriter.WriteValue(invoiceperiodstartdate);
//         JSONTextWriter.WritePropertyName('invoice_period_end_date');
//         JSONTextWriter.WriteValue(invoiceperiodenddate);
//         JSONTextWriter.WriteEndObject();

//         JSONTextWriter.WritePropertyName('preceding_document_details');

//         JSONTextWriter.Formatting;

//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('reference_of_original_invoice');
//         JSONTextWriter.WriteValue(referenceoforiginalinvoice);
//         JSONTextWriter.WritePropertyName('preceding_invoice_date');
//         JSONTextWriter.WriteValue(precedinginvoicedate);
//         JSONTextWriter.WritePropertyName('other_reference');
//         JSONTextWriter.WriteValue(otherreference);
//         JSONTextWriter.WriteEndObject;

//         JSONTextWriter.WriteEndArray;

//         JSONTextWriter.WritePropertyName('contract_details');

//         JSONTextWriter.Formatting;

//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('receipt_advice_number');
//         JSONTextWriter.WriteValue(receiptadvicenumber);
//         JSONTextWriter.WritePropertyName('receipt_advice_date');
//         JSONTextWriter.WriteValue(receiptadvicedate);
//         JSONTextWriter.WritePropertyName('batch_reference_number');
//         JSONTextWriter.WriteValue(batchreferencenumber);
//         JSONTextWriter.WritePropertyName('contract_reference_number');
//         JSONTextWriter.WriteValue(contractreferencenumber);
//         JSONTextWriter.WritePropertyName('other_reference');
//         JSONTextWriter.WriteValue(otherreference);
//         JSONTextWriter.WritePropertyName('project_reference_number');
//         JSONTextWriter.WriteValue(projectreferencenumber);
//         JSONTextWriter.WritePropertyName('vendor_po_reference_number');
//         JSONTextWriter.WriteValue(vendorporeferencenumber);
//         JSONTextWriter.WritePropertyName('vendor_po_reference_date');
//         JSONTextWriter.WriteValue(vendorporeferencedate);

//         JSONTextWriter.WriteEndObject();

//         JSONTextWriter.WriteEndArray;

//         JSONTextWriter.WriteEndObject();
//     end;

//     procedure InitializeCalculateDistanceTransferShip(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Status: Text;
//     "Code": Text;
//     frompincode: Text;
//     topincode: Text;
//     EINV: Record "50000";
//     RecVendor: Record "23";
//     RecLoc: Record "14";
//     GetCalculatedDistance: Text;
//     recResponseLog: Record "50003";
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         EINV.RESET();
//         EINV.SETRANGE("No.", DocNo);
//         IF EINV.FIND('-') THEN BEGIN
//             frompincode := '';
//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, EINV."Location Code");
//             IF RecLoc.FIND('-') THEN BEGIN
//                 frompincode := RecLoc."Post Code";
//             END;

//             topincode := '';
//             IF EINV."Port Code" <> '' THEN BEGIN
//                 RecVendor.RESET();
//                 RecVendor.SETRANGE("No.", EINV."Port Code");
//                 IF RecVendor.FIND('-') THEN
//                     frompincode := FORMAT(RecVendor."Post Code");
//             END
//             ELSE BEGIN
//                 RecLoc.RESET();
//                 RecLoc.SETRANGE(Code, EINV."Transfer-to Code");
//                 IF RecLoc.FIND('-') THEN
//                     topincode := FORMAT(RecLoc."Post Code");
//             END;
//         END;

//         Url := 'http://pro.mastersindia.co/distance?access_token=' + ReceiveTokenNo + '&fromPincode=' + frompincode + '&toPincode=' + topincode;

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('GET');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Calculate Distance for E-Way Bill : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp);
//                     GetCalculatedDistance := (JObject.GetValue('distance').ToString);
//                     //MESSAGE('Distance for E-Way Bill ' + JObject.GetValue('distance').ToString);

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Success';
//                     recResponseLog."Called API" := 'Calculate Distance';
//                     recResponseLog.INSERT;

//                     EINV.RESET();
//                     EINV.SETRANGE("No.", DocNo);
//                     IF EINV.FIND('-') THEN BEGIN
//                         EVALUATE(EINV."Distance (Km)", GetCalculatedDistance);
//                         EINV."E-Invoice Status" := Status + ' ' + Code;
//                         EINV.MODIFY;
//                     END;
//                 END
//                 ELSE BEGIN

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Calculate Distance';
//                     recResponseLog.INSERT;

//                     EINV.RESET();
//                     EINV.SETRANGE("No.", DocNo);
//                     IF EINV.FIND('-') THEN
//                         EINV."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                     MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                     EINV.MODIFY;
//                 END;
//             END;
//         END
//         ELSE
//             MESSAGE('no response from api');
//     end;


//     procedure CreateJsonforTransferShip(DocNo: Code[30])
//     begin
//         TransferShipHeader.RESET();
//         TransferShipHeader.SETRANGE("No.", DocNo);
//         IF TransferShipHeader.FIND('-') THEN BEGIN

//             CLEAR(JSONTextWriter);

//             TokenNo := '';
//             TokenNo := InitializeAccessToken(TransferShipHeader."No.");

//             EInvoiceIntegration.GET(TransferShipHeader."No.");

//             IF ISNULL(StringBuilder) THEN
//                 InitializeTransferShip;

//             WITH TransferShipHeader DO BEGIN
//                 DocumentNo := "No.";
//                 WriteFileHeaderTransferShip;
//                 ReadTransDtlsTransferShip;
//                 ReadDocDtlsTransferShip;
//                 ReadSellerDtlsTransferShip;
//                 ReadBuyerDtlsTransferShip;
//                 ReadDispDtlsTransferShip;
//                 ReadShipDtlsTransferShip;
//                 ReadPaymentDtlsTransferShip;
//                 //    ReadReferenceDtlsTransferShip;
//                 ReadAdditionalDocumentDtlsTransferShip;
//                 ReadValDtlsTransferShip;
//                 ReadEwaybillDtlsTransferShip;
//                 ReadItemListTransferShip;
//                 JSONTextWriter.WriteEndObject;
//                 JSONTextWriter.Flush;
//             END;

//             JsonStingEInvoiceTransferShip := '';
//             JsonStingEInvoiceTransferShip := (StringBuilder.ToString);
//             /*
//             IF DocumentNo <> '' THEN
//               ExportAsJsonTransferShip(DocumentNo)
//             ELSE
//               ERROR(RecIsEmptyErr);
//             */
//             InitializeEinvoiceGenerateTransferShip(TransferShipHeader."No.");

//         END;

//     end;


//     procedure InitializeEinvoiceGenerateTransferShip(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Alert: Text;
//     Error: Text;
//     Status: Text;
//     "Code": Text;
//     results: Text;
//     message1: Text;
//     AckNo: Text;
//     AckDt: Text;
//     Status1: Text;
//     QRCodeUrl: Text;
//     EinvoicePdf: Text;
//     EWayBillandEinvoice: Record "50000";
//     errorMessage: Text;
//     IRNNo: Text;
//     EwbValidTill: Text;
//     EwbDt: Text;
//     EwbNo: Text;
//     recResponseLog: Record "50003";
//     QRcode: Text;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         Url := 'https://pro.mastersindia.co/generateEinvoice';
//         AckDt := '';
//         AckNo := '';
//         QRcode := '';
//         QRCodeUrl := '';
//         EinvoicePdf := '';
//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(JsonStingEInvoiceTransferShip);
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := '';
//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Generate E-Invoice : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Generate E-Invoice : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 results := JObject.GetValue('results').ToString;
//                 //    MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(results);
//                 Status := (JObject.GetValue('status').ToString);
//                 //    MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(results);
//                 Code := (JObject.GetValue('code').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 JObject := JObject.Parse(results);
//                 errorMessage := (JObject.GetValue('errorMessage').ToString);
//                 //    MESSAGE('Code : ' + JObject.GetValue('errorMessage').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(results);
//                     message1 := JObject.GetValue('message').ToString;
//                     //    MESSAGE := (JObject.GetValue('message').ToString);

//                     JObject := JObject.Parse(message1);
//                     AckNo := (JObject.GetValue('AckNo').ToString);
//                     MESSAGE('Ack No. : ' + JObject.GetValue('AckNo').ToString);

//                     JObject := JObject.Parse(message1);
//                     AckDt := (JObject.GetValue('AckDt').ToString);
//                     MESSAGE('Ack Date : ' + JObject.GetValue('AckDt').ToString);

//                     JObject := JObject.Parse(message1);
//                     IRNNo := (JObject.GetValue('Irn').ToString);
//                     MESSAGE('Irn No. : ' + JObject.GetValue('Irn').ToString);

//                     JObject := JObject.Parse(message1);
//                     QRCodeUrl := (JObject.GetValue('QRCodeUrl').ToString);
//                     MESSAGE('QR Code Url : ' + JObject.GetValue('QRCodeUrl').ToString);

//                     JObject := JObject.Parse(message1);
//                     EinvoicePdf := (JObject.GetValue('EinvoicePdf').ToString);
//                     MESSAGE('E-Invoice Pdf : ' + JObject.GetValue('EinvoicePdf').ToString);

//                     JObject := JObject.Parse(message1);
//                     EwbNo := (JObject.GetValue('EwbNo').ToString);
//                     //    MESSAGE('E-Way Bill No. : ' + JObject.GetValue('EwbNo').ToString);

//                     JObject := JObject.Parse(message1);
//                     EwbDt := (JObject.GetValue('EwbDt').ToString);
//                     //    MESSAGE('E-Way Bill Date : ' + JObject.GetValue('EwbDt').ToString);

//                     JObject := JObject.Parse(message1);
//                     EwbValidTill := (JObject.GetValue('EwbValidTill').ToString);
//                     //    MESSAGE('E-Way Bill Valid Upto : ' + JObject.GetValue('EwbValidTill').ToString);

//                     JObject := JObject.Parse(message1);
//                     Status1 := (JObject.GetValue('Status').ToString);
//                     //    MESSAGE('Status : ' + JObject.GetValue('Status').ToString);

//                     JObject := JObject.Parse(message1);
//                     Alert := (JObject.GetValue('alert').ToString);
//                     //    MESSAGE('Alert : ' + JObject.GetValue('alert').ToString);

//                     JObject := JObject.Parse(message1);
//                     Error := (JObject.GetValue('error').ToString);
//                     //    MESSAGE('Error : ' + JObject.GetValue('error').ToString);

//                     JObject := JObject.Parse(message1);
//                     QRcode := (JObject.GetValue('SignedQRCode').ToString);
//                     MESSAGE('Signed QR Code : ' + JObject.GetValue('SignedQRCode').ToString);


//                     IF QRcode <> '' THEN BEGIN
//                         QRCodeManagement(DocNo, QRcode, IRNNo);
//                     END;

//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Success';
//                     recResponseLog."Called API" := 'Generate IRN';
//                     recResponseLog.INSERT;

//                     EWayBillandEinvoice.RESET();
//                     EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                     IF EWayBillandEinvoice.FIND('-') THEN BEGIN
//                         EWayBillandEinvoice.VALIDATE("E-Invoice IRN No", IRNNo);
//                         EWayBillandEinvoice."E-Invoice Acknowledge No." := AckNo;
//                         EWayBillandEinvoice."E-Invoice Acknowledge Date" := AckDt;
//                         EWayBillandEinvoice."E-Invoice QR Code" := QRCodeUrl;
//                         EWayBillandEinvoice."E-Invoice PDF" := EinvoicePdf;
//                         IF EwbNo <> '' THEN
//                             EWayBillandEinvoice.VALIDATE("E-Way Bill No.", EwbNo);
//                         IF EwbDt <> '' THEN
//                             EWayBillandEinvoice."E-Way Bill Date" := EwbDt;
//                         IF EwbValidTill <> '' THEN
//                             EWayBillandEinvoice."E-Way Bill Valid Upto" := EwbValidTill;
//                         EWayBillandEinvoice."E-Invoice IRN Status" := Status1;
//                         EWayBillandEinvoice."E-Invoice Cancel Date" := '';
//                         EWayBillandEinvoice."E-Invoice Cancel Reason" := EWayBillandEinvoice."E-Invoice Cancel Reason"::" ";
//                         EWayBillandEinvoice."E-Invoice Cancel Remarks" := '';
//                         EWayBillandEinvoice."E-Invoice Status" := Status + ' ' + Code;
//                         EWayBillandEinvoice.MODIFY;
//                     END;
//                 END
//                 ELSE BEGIN
//                     recResponseLog.INIT;
//                     recResponseLog."Document No." := DocNo;
//                     recResponseLog."Response Date" := TODAY;
//                     recResponseLog."Response Time" := TIME;
//                     recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                     recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                     recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                     recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                     recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                     recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                     recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                     recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                     recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                     recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                     recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                     recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                     recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                     recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                     recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                     recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Generate IRN';
//                     recResponseLog.INSERT;

//                     EWayBillandEinvoice.RESET();
//                     EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                     IF EWayBillandEinvoice.FIND('-') THEN
//                         EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                     MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                     EWayBillandEinvoice.MODIFY;
//                 END;
//             END;
//         END
//         ELSE
//             MESSAGE('no response from api');
//     end;


//     procedure InitializeGetEInvoiveTransferShip(DocNo: Code[30]; IRN: Text)
//     var
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//     [RunOnClient]

//     ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//     [RunOnClient]

//     XMLHttpRequest: DotNet HttpWebRequest;
//     temp: Text;
//     TempBlob2: Record "99008535";
//     ReqBodyOutStream: OutStream;
//     ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//     [RunOnClient]

//     XMLDoc: DotNet XmlDocument;
//     JsonAsText: Text;
//     JsonBillGenerate: Text;
//     temp01: Text;
//     temp02: Text;
//     ReceiveTokenNo: Text[500];
//     Status: Text;
//     "Code": Text;
//     GetCancelBillDate: Text;
//     recEinvoice: Record "50000";
//     GetCancelIrn: Text;
//     errorMessage: Text;
//     results: Text;
//     message1: Text;
//     IrnNo: Text;
//     Status1: Text;
//     EWayBillandEinvoice: Record "50000";
//     recResponseLog: Record "50003";
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         recEinvoice.RESET();
//         recEinvoice.SETRANGE("No.", DocNo);
//         IF recEinvoice.FIND('-') THEN BEGIN

//             Url := 'https://pro.mastersindia.co/getEinvoiceData?' + 'access_token=' + ReceiveTokenNo + '&gstin=' + recEinvoice."Location GST Reg. No." + '&irn=' + IRN;

//             HttpWebRequestMgt.Initialize(Url);
//             HttpWebRequestMgt.DisableUI;
//             HttpWebRequestMgt.SetMethod('GET');
//             HttpWebRequestMgt.SetContentType('application/json');
//             HttpWebRequestMgt.SetReturnType('application/json');

//             TempBlob.INIT;
//             TempBlob.Blob.CREATEINSTREAM(Instr);
//             IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//                 MESSAGE('Return Value of Get E-Invoice No. : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//                 IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                     ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                     JObject := JObject.JObject;
//                     JObject := JObject.Parse(ApiResult);
//                     temp := JObject.GetValue('results').ToString;
//                     //    MESSAGE(temp);

//                     JObject := JObject.Parse(temp);
//                     errorMessage := (JObject.GetValue('errorMessage').ToString);
//                     //    MESSAGE('Code : ' + JObject.GetValue('errorMessage').ToString);

//                     JObject := JObject.Parse(temp);
//                     Status := (JObject.GetValue('status').ToString);
//                     //    MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                     JObject := JObject.Parse(temp);
//                     Code := (JObject.GetValue('code').ToString);
//                     //    MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                     IF Code = FORMAT(200) THEN BEGIN
//                         JObject := JObject.Parse(temp);
//                         message1 := JObject.GetValue('message').ToString;
//                         //    MESSAGE := (message1);

//                         JObject := JObject.Parse(message1);
//                         IrnNo := (JObject.GetValue('Irn').ToString);
//                         MESSAGE('Irn No. : ' + IrnNo);

//                         JObject := JObject.Parse(message1);
//                         Status1 := (JObject.GetValue('Status').ToString);
//                         MESSAGE('Status. : ' + Status1);
//                         /*
//                             JObject := JObject.Parse(message1);
//                             MESSAGE('E-Way Bill No. : ' + JObject.GetValue('EwbNo').ToString);

//                             JObject := JObject.Parse(message1);
//                             MESSAGE('E-Way Bill Date. : ' + JObject.GetValue('EwbDt').ToString);

//                             JObject := JObject.Parse(message1);
//                             MESSAGE('E-Way Bill Valid Upto. : ' + JObject.GetValue('EwbValidTill').ToString);
//                         */

//                         recResponseLog.INIT;
//                         recResponseLog."Document No." := DocNo;
//                         recResponseLog."Response Date" := TODAY;
//                         recResponseLog."Response Time" := TIME;
//                         recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                         recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                         recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                         recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                         recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                         recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                         recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                         recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                         recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                         recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                         recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                         recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                         recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                         recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                         recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                         recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                         recResponseLog.Status := 'Success';
//                         recResponseLog."Called API" := 'Get E-Invoice';
//                         recResponseLog.INSERT;

//                         EWayBillandEinvoice.RESET();
//                         EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                         IF EWayBillandEinvoice.FIND('-') THEN BEGIN
//                             EWayBillandEinvoice."E-Invoice IRN Status" := Status1;
//                             EWayBillandEinvoice."E-Invoice Status" := Status + ' ' + Code;
//                             EWayBillandEinvoice.MODIFY;
//                         END;
//                     END
//                     ELSE BEGIN

//                         recResponseLog.INIT;
//                         recResponseLog."Document No." := DocNo;
//                         recResponseLog."Response Date" := TODAY;
//                         recResponseLog."Response Time" := TIME;
//                         recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//                         recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//                         recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//                         recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//                         recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//                         recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//                         recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//                         recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//                         recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//                         recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//                         recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//                         recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//                         recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//                         recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//                         recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//                         recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//                         recResponseLog.Status := 'Failure';
//                         recResponseLog."Called API" := 'Get E-Invoice';
//                         recResponseLog.INSERT;

//                         EWayBillandEinvoice.RESET();
//                         EWayBillandEinvoice.SETRANGE("No.", DocNo);
//                         IF EWayBillandEinvoice.FIND('-') THEN
//                             EWayBillandEinvoice."E-Invoice Status" := 'Faliure' + ' ' + Code;
//                         MESSAGE('Error Message : ' + JObject.GetValue('errorMessage').ToString);
//                         EWayBillandEinvoice.MODIFY;
//                     END;
//                 END;
//             END
//             ELSE
//                 MESSAGE('no response from api');
//         END;

//     end;

//     local procedure InitializeTransferShip()
//     begin
//         StringBuilder := StringBuilder.StringBuilder;
//         StringWriter := StringWriter.StringWriter(StringBuilder);
//         JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
//         JSONTextWriter.Formatting := JsonFormatting.Indented;
//     end;

//     local procedure WriteFileHeaderTransferShip()
//     var
//         recLocation: Record "14";
//     begin
//         WITH TransferShipHeader DO BEGIN
//             recLocation.RESET();
//             recLocation.SETRANGE(Code, TransferShipHeader."Transfer-from Code");
//             IF recLocation.FIND('-') THEN BEGIN
//                 JSONTextWriter.WriteStartObject;
//                 JSONTextWriter.WritePropertyName('access_token');
//                 JSONTextWriter.WriteValue(TokenNo);
//                 JSONTextWriter.WritePropertyName('user_gstin');
//                 JSONTextWriter.WriteValue(EInvoiceIntegration."Location GST Reg. No.");
//                 JSONTextWriter.WritePropertyName('data_source');
//                 JSONTextWriter.WriteValue('erp');
//             END;
//         END;
//     end;

//     local procedure ReadTransDtlsTransferShip()
//     var
//         catg: Text[3];
//         Typ: Text[3];
//         IgstIntra: Text[1];
//         TransShiLine: Record "5745";
//     begin
//         catg := 'B2B';
//         IgstIntra := 'N';
//         WriteTransDtlsTransferShip(catg, 'RG', Typ, 'false', 'Y', '', IgstIntra);
//     end;

//     local procedure WriteTransDtlsTransferShip(catg: Text[3]; RegRev: Text[2]; Typ: Text[3]; EcmTrnSel: Text[5]; EcmTrn: Text[1]; EcmGstin: Text[15]; IgstIntra: Text[1])
//     var
//         recCust: Record "18";
//     begin

//         JSONTextWriter.WritePropertyName('transaction_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('supply_type');
//         JSONTextWriter.WriteValue(catg);
//         JSONTextWriter.WritePropertyName('charge_type');
//         JSONTextWriter.WriteValue('N');
//         JSONTextWriter.WritePropertyName('igst_on_intra');
//         JSONTextWriter.WriteValue(IgstIntra);
//         JSONTextWriter.WritePropertyName('ecommerce_gstin');
//         JSONTextWriter.WriteValue('');
//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadDocDtlsTransferShip()
//     var
//         Typ: Text[3];
//         Dt: Text[10];
//         OrgInvNo: Text[16];
//     begin
//         Typ := 'INV';
//         Dt := FORMAT(TransferShipHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//         OrgInvNo := COPYSTR(GetRefInvNoTransferShip(DocumentNo), 1, 16);

//         WriteDocDtlsTransferShip(Typ, COPYSTR(DocumentNo, 1, 16), Dt, OrgInvNo);
//     end;

//     local procedure WriteDocDtlsTransferShip(Typ: Text[3]; No: Text[16]; Dt: Text[10]; OrgInvNo: Text[16])
//     begin

//         JSONTextWriter.WritePropertyName('document_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('document_type');
//         JSONTextWriter.WriteValue(Typ);
//         JSONTextWriter.WritePropertyName('document_number');
//         JSONTextWriter.WriteValue(No);
//         JSONTextWriter.WritePropertyName('document_date');
//         JSONTextWriter.WriteValue(Dt);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadSellerDtlsTransferShip()
//     var
//         CompanyInformationBuff: Record "79";
//         LocationBuff: Record "14";
//         StateBuff: Record "13762";
//         Gstin: Text[15];
//         TrdNm: Text[100];
//         Bno: Text[60];
//         Bnm: Text[60];
//         Flno: Text[60];
//         Loc: Text[60];
//         Dst: Text[60];
//         Pin: Text[6];
//         Stcd: Text[2];
//         Ph: Text[10];
//         Em: Text[50];
//         Statename: Text;
//         recState: Record "13762";
//     begin
//         WITH TransferShipHeader DO BEGIN
//             CompanyInformationBuff.GET;
//             LocationBuff.GET(TransferShipHeader."Transfer-from Code");
//             TrdNm := LocationBuff.Name;
//             Gstin := LocationBuff."GST Registration No.";
//             Bno := LocationBuff.Address;
//             Bnm := LocationBuff."Address 2";
//             Flno := '';
//             Loc := LocationBuff.City;
//             Dst := LocationBuff.City;
//             Pin := COPYSTR(LocationBuff."Post Code", 1, 6);
//             StateBuff.GET(LocationBuff."State Code");
//             Stcd := StateBuff."State Code (GST Reg. No.)";
//             recState.RESET;
//             recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//             IF recState.FIND('-') THEN BEGIN
//                 Statename := recState.Description;
//             END;
//             Ph := COPYSTR(LocationBuff."Phone No.", 1, 10);
//             Em := COPYSTR(LocationBuff."E-Mail", 1, 50);
//         END;

//         WriteSellerDtlsTransferShip(Gstin, TrdNm, Bno, Bnm, Flno, Loc, Dst, Pin, Stcd, Ph, Em, Statename);
//     end;

//     local procedure WriteSellerDtlsTransferShip(Gstin: Text[15]; TrdNm: Text[100]; Bno: Text[60]; Bnm: Text[60]; Flno: Text[60]; Loc: Text[60]; Dst: Text[60]; Pin: Text[6]; Stcd: Text[2]; Ph: Text[10]; Em: Text[50]; Statename: Text[70])
//     begin

//         JSONTextWriter.WritePropertyName('seller_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('gstin');
//         IF Gstin <> '' THEN
//             JSONTextWriter.WriteValue(Gstin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('legal_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('trade_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('address1');
//         IF Bno <> '' THEN
//             JSONTextWriter.WriteValue(Bno)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address2');
//         IF Bnm <> '' THEN
//             JSONTextWriter.WriteValue(Bnm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('location');
//         IF Loc <> '' THEN
//             JSONTextWriter.WriteValue(Loc)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('pincode');
//         IF Pin <> '' THEN
//             JSONTextWriter.WriteValue(Pin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('state_code');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Statename)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('phone_number');
//         IF Ph <> '' THEN
//             JSONTextWriter.WriteValue(Ph)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('email');
//         IF Em <> '' THEN
//             JSONTextWriter.WriteValue(Em)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadBuyerDtlsTransferShip()
//     var
//         Contact: Record "5050";
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         ShipToAddr: Record "222";
//         StateBuff: Record "13762";
//         Gstin: Text[15];
//         TrdNm: Text[100];
//         Bno: Text[60];
//         Bnm: Text[60];
//         Flno: Text[60];
//         Loc: Text[60];
//         Dst: Text[60];
//         Pin: Text[6];
//         Stcd: Text[2];
//         Ph: Text[10];
//         Em: Text[50];
//         Statename: Text;
//         recState: Record "13762";
//         recLoc: Record "14";
//         recCust: Record "18";
//     begin
//         WITH TransferShipHeader DO BEGIN
//             recLoc.GET(TransferShipHeader."Transfer-to Code");
//             Gstin := recLoc."GST Registration No.";
//             TrdNm := recLoc.Name;
//             Bno := recLoc.Address;
//             Bnm := recLoc."Address 2";
//             Flno := '';
//             Loc := recLoc.City;
//             Dst := recLoc.City;
//             Pin := COPYSTR(recLoc."Post Code", 1, 6);

//             IF StateBuff.GET(recLoc."State Code") THEN
//                 Stcd := StateBuff."State Code (GST Reg. No.)"
//             ELSE
//                 Stcd := '';

//             recState.RESET();
//             recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//             IF recState.FIND('-') THEN BEGIN
//                 Statename := recState.Description;
//             END;

//             Ph := COPYSTR(recLoc."Phone No.", 1, 10);
//             Em := COPYSTR(recLoc."E-Mail", 1, 50);
//         END;

//         WriteBuyerDtlsTransferShip(Gstin, TrdNm, Bno, Bnm, Flno, Loc, Dst, Pin, Stcd, Ph, Em, Statename);
//     end;

//     local procedure WriteBuyerDtlsTransferShip(Gstin: Text[15]; TrdNm: Text[100]; Bno: Text[60]; Bnm: Text[60]; Flno: Text[60]; Loc: Text[60]; Dst: Text[60]; Pin: Text[6]; Stcd: Text[2]; Ph: Text[10]; Em: Text[50]; Statename: Text)
//     begin

//         JSONTextWriter.WritePropertyName('buyer_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('gstin');
//         IF Gstin <> '' THEN
//             JSONTextWriter.WriteValue(Gstin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('legal_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('trade_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address1');
//         IF Bno <> '' THEN
//             JSONTextWriter.WriteValue(Bno)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address2');
//         IF Bnm <> '' THEN
//             JSONTextWriter.WriteValue(Bnm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('location');
//         IF Loc <> '' THEN
//             JSONTextWriter.WriteValue(Loc)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('pincode');
//         IF Pin <> '' THEN
//             JSONTextWriter.WriteValue(Pin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('place_of_supply');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Stcd)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('state_code');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Statename)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('phone_number');
//         IF Ph <> '' THEN
//             JSONTextWriter.WriteValue(Ph)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('email');
//         IF Em <> '' THEN
//             JSONTextWriter.WriteValue(Em)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadShipDtlsTransferShip()
//     var
//         ShipToAddr: Record "222";
//         StateBuff: Record "13762";
//         Gstin: Text[15];
//         TrdNm: Text[100];
//         Bno: Text[60];
//         Bnm: Text[60];
//         Flno: Text[60];
//         Loc: Text[60];
//         Dst: Text[60];
//         Pin: Text[6];
//         Stcd: Text[2];
//         Ph: Text[10];
//         Em: Text[50];
//         Statename: Text;
//         recState: Record "13762";
//         recLoc: Record "14";
//         Cust: Record "18";
//     begin
//         WITH TransferShipHeader DO BEGIN
//             recLoc.GET(TransferShipHeader."Transfer-to Code");
//             Gstin := recLoc."GST Registration No.";
//             TrdNm := recLoc.Name;
//             Bno := recLoc.Address;
//             Bnm := recLoc."Address 2";
//             Flno := '';
//             Loc := recLoc.City;
//             Dst := recLoc.City;
//             Pin := COPYSTR(recLoc."Post Code", 1, 6);
//             IF StateBuff.GET(recLoc."State Code") THEN
//                 Stcd := StateBuff."State Code (GST Reg. No.)"
//             ELSE
//                 Stcd := '';
//             recState.SETRANGE("State Code (GST Reg. No.)", Stcd);
//             IF recState.FIND('-') THEN BEGIN
//                 Statename := recState.Description;
//             END;
//             Ph := COPYSTR(recLoc."Phone No.", 1, 10);
//             Em := COPYSTR(recLoc."E-Mail", 1, 50);
//         END;

//         WriteShipDtlsTransferShip(Gstin, TrdNm, Bno, Bnm, Flno, Loc, Dst, Pin, Stcd, Ph, Em, Statename);
//     end;

//     local procedure WriteShipDtlsTransferShip(Gstin: Text[15]; TrdNm: Text[100]; Bno: Text[60]; Bnm: Text[60]; Flno: Text[60]; Loc: Text[60]; Dst: Text[60]; Pin: Text[6]; Stcd: Text[2]; Ph: Text[10]; Em: Text[50]; Statename: Text)
//     begin

//         JSONTextWriter.WritePropertyName('ship_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('gstin');
//         IF Gstin <> '' THEN
//             JSONTextWriter.WriteValue(Gstin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('legal_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('trade_name');
//         IF TrdNm <> '' THEN
//             JSONTextWriter.WriteValue(TrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address1');
//         IF Bno <> '' THEN
//             JSONTextWriter.WriteValue(Bno)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('address2');
//         IF Bnm <> '' THEN
//             JSONTextWriter.WriteValue(Bnm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('location');
//         IF Loc <> '' THEN
//             JSONTextWriter.WriteValue(Loc)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('pincode');
//         IF Pin <> '' THEN
//             JSONTextWriter.WriteValue(Pin)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('state_code');
//         IF Stcd <> '' THEN
//             JSONTextWriter.WriteValue(Statename)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadValDtlsTransferShip()
//     var
//         AssVal: Decimal;
//         CgstVal: Decimal;
//         SgstVal: Decimal;
//         IgstVal: Decimal;
//         CesVal: Decimal;
//         StCesVal: Decimal;
//         CesNonAdval: Decimal;
//         Disc: Decimal;
//         OthChrg: Decimal;
//         TotInvVal: Decimal;
//         roundoffamount: Decimal;
//     begin
//         GetGSTValvTransferShip(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, CesNonAdval, Disc, OthChrg, TotInvVal, roundoffamount);
//         WriteValDtlsTransferShip(AssVal, CgstVal, SgstVal, IgstVal, CesVal, StCesVal, CesNonAdval, Disc, OthChrg, TotInvVal, roundoffamount);
//     end;

//     local procedure WriteValDtlsTransferShip(Assval: Decimal; CgstVal: Decimal; SgstVAl: Decimal; IgstVal: Decimal; CesVal: Decimal; StCesVal: Decimal; CesNonAdVal: Decimal; Disc: Decimal; OthChrg: Decimal; TotInvVal: Decimal; roundoffamount: Decimal)
//     begin

//         JSONTextWriter.WritePropertyName('value_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('total_assessable_value');
//         JSONTextWriter.WriteValue(Assval);
//         JSONTextWriter.WritePropertyName('total_cgst_value');
//         JSONTextWriter.WriteValue(CgstVal);
//         JSONTextWriter.WritePropertyName('total_sgst_value');
//         JSONTextWriter.WriteValue(SgstVAl);
//         JSONTextWriter.WritePropertyName('total_igst_value');
//         JSONTextWriter.WriteValue(IgstVal);
//         JSONTextWriter.WritePropertyName('total_cess_value');
//         JSONTextWriter.WriteValue(CesVal);
//         JSONTextWriter.WritePropertyName('total_cess_nonadvol_value');
//         JSONTextWriter.WriteValue(CesNonAdVal);
//         JSONTextWriter.WritePropertyName('total_discount');
//         JSONTextWriter.WriteValue(Disc);
//         JSONTextWriter.WritePropertyName('total_other_charge');
//         JSONTextWriter.WriteValue(OthChrg);
//         JSONTextWriter.WritePropertyName('total_invoice_value');
//         JSONTextWriter.WriteValue(TotInvVal);
//         JSONTextWriter.WritePropertyName('total_cess_value_of_state');
//         JSONTextWriter.WriteValue(StCesVal);
//         JSONTextWriter.WritePropertyName('round_off_amount');
//         JSONTextWriter.WriteValue(roundoffamount);
//         JSONTextWriter.WritePropertyName('total_invoice_value_additional_currency');
//         JSONTextWriter.WriteValue(0);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadItemListTransferShip()
//     var
//         TransferShipmentLine: Record "5745";
//         AssAmt: Decimal;
//         CgstRt: Decimal;
//         SgstRt: Decimal;
//         IgstRt: Decimal;
//         CesRt: Decimal;
//         CesNonAdval: Decimal;
//         StateCes: Decimal;
//         FreeQty: Decimal;
//         rectransferShipLine: Record "5745";
//         Isservice: Text[2];
//         GSTBaseamt: Decimal;
//         GSTper: Decimal;
//         cessamount: Decimal;
//         statecessamount: Decimal;
//         statecessnonadvolamount: Decimal;
//         recILE: Record "32";
//         Expiry: Text;
//         Warranty: Text;
//         Lotno: Text;
//         itemattributedetails: Text;
//         itemattributevalue: Text;
//         recVE: Record "5802";
//     begin
//         /*TransferShipmentLine.SETRANGE("Document No.",DocumentNo);
//         TransferShipmentLine.SETFILTER(Quantity,'<>%1',0);
//           IF TransferShipmentLine.FINDSET THEN BEGIN
//             IF TransferShipmentLine.COUNT > 100 THEN
//               ERROR(SalesLinesErr,TransferShipmentLine.COUNT);
//             JSONTextWriter.WritePropertyName('item_list');
//             JSONTextWriter.WriteStartArray;
//             REPEAT
//                 AssAmt := TransferShipmentLine."GST Base Amount";
//                 FreeQty := 0;
//                 GetGSTCompRateTransferShip(TransferShipmentLine."Document No.",TransferShipmentLine."Line No.",
//                   CgstRt,SgstRt,IgstRt,CesRt,CesNonAdval,StateCes);
//                 Isservice := 'N';
//               GSTBaseamt := TransferShipmentLine."Unit Price"*TransferShipmentLine.Quantity;
//               GSTper := ROUND(TransferShipmentLine."GST %",1);
//               cessamount := 0;
//               statecessamount := 0;
//               statecessnonadvolamount := 0;
//               WriteItemTransferShip(
//                 TransferShipmentLine."Line No.",TransferShipmentLine.Description,
//                 TransferShipmentLine."HSN/SAC Code",'',
//                 TransferShipmentLine.Quantity,FreeQty,
//                 COPYSTR(TransferShipmentLine."Unit of Measure Code",1,3),
//                 TransferShipmentLine."Unit Price",
//                 TransferShipmentLine.Amount,
//                 0,0,
//                 TransferShipmentLine."Unit Price"*TransferShipmentLine.Quantity,CgstRt,SgstRt,IgstRt,CesRt,CesNonAdval,StateCes,
//                 TransferShipmentLine.Amount+ TransferShipmentLine."Total GST Amount",
//                 TransferShipmentLine."Line No.",Isservice,GSTBaseamt,GSTper,cessamount,statecessamount,statecessnonadvolamount,TransferShipmentLine."Line No.");
//             UNTIL TransferShipmentLine.NEXT = 0;
//             JSONTextWriter.WriteEndArray;
//           END;
//         */
//         TransferShipmentLine.SETRANGE("Document No.", DocumentNo);
//         TransferShipmentLine.SETFILTER(Quantity, '<>%1', 0);
//         IF TransferShipmentLine.FINDSET THEN BEGIN
//             IF TransferShipmentLine.COUNT > 100 THEN
//                 ERROR(SalesLinesErr, TransferShipmentLine.COUNT);
//             JSONTextWriter.WritePropertyName('item_list');
//             JSONTextWriter.WriteStartArray;
//             REPEAT
//                 AssAmt := TransferShipmentLine.Quantity * TransferShipmentLine."Unit Price";
//                 FreeQty := 0;
//                 GetGSTCompRateTransferShip(TransferShipmentLine."Document No.", TransferShipmentLine."Line No.",
//                   CgstRt, SgstRt, IgstRt, CesRt, CesNonAdval, StateCes);
//                 Isservice := 'N';
//                 GSTBaseamt := TransferShipmentLine.Quantity * TransferShipmentLine."Unit Price";
//                 GSTper := ROUND(TransferShipmentLine."GST %", 1);
//                 cessamount := 0;
//                 statecessamount := 0;
//                 statecessnonadvolamount := 0;
//                 WriteItemTransferShip(
//                   TransferShipmentLine."Line No.", TransferShipmentLine.Description,
//                   COPYSTR(TransferShipmentLine."HSN/SAC Code", 1, 8), '',
//                   TransferShipmentLine.Quantity, FreeQty,
//                   TransferShipmentLine."Unit of Measure Code",
//                   TransferShipmentLine."Unit Price",
//                   TransferShipmentLine.Amount,
//                   0, 0,
//                   AssAmt, CgstRt, SgstRt, IgstRt, CesRt, CesNonAdval, StateCes,
//                   TransferShipmentLine.Amount + TransferShipmentLine."Total GST Amount",
//                   TransferShipmentLine."Line No.", Isservice, GSTBaseamt, GSTper, cessamount, statecessamount, statecessnonadvolamount, TransferShipmentLine."Line No.");
//             UNTIL TransferShipmentLine.NEXT = 0;
//             JSONTextWriter.WriteEndArray;
//         END;

//     end;

//     local procedure WriteItemTransferShip(PrdNm: Integer; PrdDesc: Text[100]; HsnCd: Text[8]; Barcde: Text[30]; Qty: Decimal; FreeQty: Decimal; Unit: Text[3]; UnitPrice: Decimal; TotAmt: Decimal; Discount: Decimal; OthChrg: Decimal; AssAmt: Decimal; CgstRt: Decimal; SgstRt: Decimal; IgstRt: Decimal; CesRt: Decimal; CesNonAdval: Decimal; StateCes: Decimal; TotItemVal: Decimal; SILineNo: Integer; IsService: Text[2]; GSTBaseamt: Decimal; GSTper: Decimal; cessamount: Decimal; statecessamount: Decimal; statecessnonadvolamount: Decimal; LineNo: Integer)
//     var
//         ValueEntry: Record "5802";
//         ItemLedgerEntry: Record "32";
//         ValueEntryRelation: Record "6508";
//         ItemTrackingManagement: Codeunit "6500";
//         InvoiceRowID: Text[250];
//         recSalesInvLine: Record "113";
//         recSalesCrMemoLine: Record "115";
//         recVE: Record "5802";
//         recSalesInvLine1: Record "113";
//         recSalesCrMemoLine1: Record "115";
//     begin

//         JSONTextWriter.WriteStartObject;
//         JSONTextWriter.WritePropertyName('item_serial_number');
//         //IF PrdNm <> '' THEN
//         IF (PrdNm <> 0) OR (PrdNm < 999999) THEN
//             JSONTextWriter.WriteValue(PrdNm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('product_description');
//         IF PrdDesc <> '' THEN
//             JSONTextWriter.WriteValue(PrdDesc)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('is_service');
//         JSONTextWriter.WriteValue(IsService);

//         JSONTextWriter.WritePropertyName('hsn_code');
//         IF HsnCd <> '' THEN
//             JSONTextWriter.WriteValue(HsnCd)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('bar_code');
//         IF Barcde <> '' THEN
//             JSONTextWriter.WriteValue(Barcde)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('quantity');
//         JSONTextWriter.WriteValue(Qty);
//         JSONTextWriter.WritePropertyName('free_quantity');
//         JSONTextWriter.WriteValue(FreeQty);

//         JSONTextWriter.WritePropertyName('unit');
//         IF Unit <> '' THEN
//             JSONTextWriter.WriteValue(Unit)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('unit_price');
//         JSONTextWriter.WriteValue(UnitPrice);
//         JSONTextWriter.WritePropertyName('total_amount');
//         JSONTextWriter.WriteValue(TotAmt);
//         JSONTextWriter.WritePropertyName('pre_tax_value');
//         JSONTextWriter.WriteValue(ROUND(GSTBaseamt, 0.01));
//         JSONTextWriter.WritePropertyName('discount');
//         JSONTextWriter.WriteValue(Discount);
//         JSONTextWriter.WritePropertyName('other_charge');
//         JSONTextWriter.WriteValue(OthChrg);
//         JSONTextWriter.WritePropertyName('assessable_value');
//         JSONTextWriter.WriteValue(ROUND(AssAmt, 0.01));
//         JSONTextWriter.WritePropertyName('gst_rate');
//         JSONTextWriter.WriteValue(GSTper);
//         JSONTextWriter.WritePropertyName('igst_amount');
//         JSONTextWriter.WriteValue(IgstRt);
//         JSONTextWriter.WritePropertyName('cgst_amount');
//         JSONTextWriter.WriteValue(CgstRt);
//         JSONTextWriter.WritePropertyName('sgst_amount');
//         JSONTextWriter.WriteValue(SgstRt);
//         JSONTextWriter.WritePropertyName('cess_rate');
//         JSONTextWriter.WriteValue(CesRt);
//         JSONTextWriter.WritePropertyName('cess_amount');
//         JSONTextWriter.WriteValue(cessamount);
//         JSONTextWriter.WritePropertyName('cess_nonadvol_amount');
//         JSONTextWriter.WriteValue(CesNonAdval);
//         JSONTextWriter.WritePropertyName('state_cess_rate');
//         JSONTextWriter.WriteValue(StateCes);
//         JSONTextWriter.WritePropertyName('state_cess_amount');
//         JSONTextWriter.WriteValue(statecessamount);
//         JSONTextWriter.WritePropertyName('state_cess_nonadvol_amount');
//         JSONTextWriter.WriteValue(statecessnonadvolamount);
//         JSONTextWriter.WritePropertyName('total_item_value');
//         JSONTextWriter.WriteValue(TotItemVal);
//         JSONTextWriter.WritePropertyName('country_origin');
//         JSONTextWriter.WriteValue('91');
//         JSONTextWriter.WritePropertyName('order_line_reference');
//         JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('product_serial_number');
//         JSONTextWriter.WriteValue('');

//         recVE.RESET();
//         recVE.SETRANGE("Document No.", DocumentNo);
//         recVE.SETRANGE("Document Line No.", LineNo);
//         IF recVE.FIND('-') THEN BEGIN
//             JSONTextWriter.WritePropertyName('batch_details');
//             JSONTextWriter.WriteStartObject;
//             REPEAT
//                 ItemLedgerEntry.GET(recVE."Item Ledger Entry No.");
//                 WriteBchDtlsTransferShip(
//                 COPYSTR(ItemLedgerEntry."Lot No." + ItemLedgerEntry."Serial No.", 1, 20),
//                 FORMAT(ItemLedgerEntry."Expiration Date", 0, '<Day,2>/<Month,2>/<Year4>'),
//                 FORMAT(ItemLedgerEntry."Warranty Date", 0, '<Day,2>/<Month,2>/<Year4>'));
//             UNTIL recVE.NEXT = 0;
//             JSONTextWriter.WriteEndObject;
//         END;
//         /*
//         IF IsInvoice THEN
//           Attributedetails('','')
//         ELSE
//           Attributedetails('','');
//         */
//         JSONTextWriter.WriteEndObject();

//     end;

//     local procedure WriteBchDtlsTransferShip(Nm: Text[20]; ExpDt: Text[10]; WrDt: Text[10])
//     begin

//         JSONTextWriter.WritePropertyName('name');
//         IF Nm <> '' THEN
//             JSONTextWriter.WriteValue(Nm)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('expiry_date');
//         IF ExpDt <> '' THEN
//             JSONTextWriter.WriteValue(ExpDt)
//         ELSE
//             JSONTextWriter.WriteValue('');
//         JSONTextWriter.WritePropertyName('warranty_date');
//         IF WrDt <> '' THEN
//             JSONTextWriter.WriteValue(WrDt)
//         ELSE
//             JSONTextWriter.WriteValue('');
//     end;

//     local procedure ExportAsJsonTransferShip(FileName: Text[20])
//     var
//         TempFile: File;
//         ToFile: Variant;
//         NewStream: InStream;
//     begin

//         TempFile.CREATETEMPFILE;
//         TempFile.WRITE(StringBuilder.ToString);
//         TempFile.CREATEINSTREAM(NewStream);
//         ToFile := FileName + '.json';
//         DOWNLOADFROMSTREAM(NewStream, 'e-Invoice', '', 'JSON files|*.json|All files (*.*)|*.*', ToFile);
//         TempFile.CLOSE;
//     end;


//     procedure SetTransferShipHdr(TransferShipHeaderBuff: Record "5744")
//     begin

//         CLEAR(TransferShipHeader);
//         TransferShipHeader := TransferShipHeaderBuff;
//         IsInvoice := TRUE;
//     end;

//     local procedure GetRefInvNoTransferShip(DocNo: Code[20]) RefInvNo: Code[20]
//     var
//         ReferenceInvoiceNo: Record "16470";
//     begin
//         ReferenceInvoiceNo.SETRANGE("Document No.", DocNo);
//         IF ReferenceInvoiceNo.FINDFIRST THEN
//             RefInvNo := ReferenceInvoiceNo."Reference Invoice Nos."
//         ELSE
//             RefInvNo := '';
//     end;

//     local procedure GetGSTCompRateTransferShip(DocNo: Code[20]; LineNo: Integer; var CgstRt: Decimal; var SgstRt: Decimal; var IgstRt: Decimal; var CesRt: Decimal; var CesNonAdval: Decimal; var StateCes: Decimal)
//     var
//         DetailedGSTLedgerEntry: Record "16419";
//         GSTComponent: Record "16405";
//     begin
//         DetailedGSTLedgerEntry.SETRANGE("Document No.", DocNo);
//         DetailedGSTLedgerEntry.SETRANGE("Document Line No.", LineNo);

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             CgstRt := ABS(DetailedGSTLedgerEntry."GST Amount")
//         ELSE
//             CgstRt := 0;

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             SgstRt := ABS(DetailedGSTLedgerEntry."GST Amount")
//         ELSE
//             SgstRt := 0;

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             IgstRt := ABS(DetailedGSTLedgerEntry."GST Amount")
//         ELSE
//             IgstRt := 0;

//         CesRt := 0;
//         CesNonAdval := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             IF DetailedGSTLedgerEntry."GST %" > 0 THEN
//                 CesRt := DetailedGSTLedgerEntry."GST %"
//             ELSE
//                 CesNonAdval := ABS(DetailedGSTLedgerEntry."GST Amount");

//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'INTERCESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             CesRt := DetailedGSTLedgerEntry."GST %";

//         StateCes := 0;
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code");
//         IF DetailedGSTLedgerEntry.FINDSET THEN
//             REPEAT
//                 IF NOT (DetailedGSTLedgerEntry."GST Component Code" IN ['CGST', 'SGST', 'IGST', 'CESS', 'INTERCESS'])
//                 THEN
//                     IF GSTComponent.GET(DetailedGSTLedgerEntry."GST Component Code") THEN
//                         IF GSTComponent."Exclude from Reports" THEN
//                             StateCes := DetailedGSTLedgerEntry."GST %";
//             UNTIL DetailedGSTLedgerEntry.NEXT = 0;
//     end;

//     local procedure GetGSTValvTransferShip(var AssVal: Decimal; var CgstVal: Decimal; var SgstVal: Decimal; var IgstVal: Decimal; var CesVal: Decimal; var StCesVal: Decimal; var CesNonAdval: Decimal; var Disc: Decimal; var OthChrg: Decimal; var TotInvVal: Decimal; var roundoffamount: Decimal)
//     var
//         GSTLedgerEntry: Record "16418";
//         DetailedGSTLedgerEntry: Record "16419";
//         CurrExchRate: Record "330";
//         CustLedgerEntry: Record "21";
//         GSTComponent: Record "16405";
//         TotGSTAmt: Decimal;
//         recGLentry: Record "17";
//         TransferShipmentHdr: Record "5744";
//         TransferShipmentLine: Record "5745";
//     begin
//         GSTLedgerEntry.SETRANGE("Document No.", DocumentNo);

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 CgstVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             CgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'SGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 SgstVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             SgstVal := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 IgstVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END ELSE
//             IgstVal := 0;

//         CesVal := 0;
//         CesNonAdval := 0;

//         GSTLedgerEntry.SETRANGE("GST Component Code", 'INTERCESS');
//         IF GSTLedgerEntry.FINDSET THEN
//             REPEAT
//                 CesVal += ABS(GSTLedgerEntry."GST Amount")
//             UNTIL GSTLedgerEntry.NEXT = 0;

//         DetailedGSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
//         DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CESS');
//         IF DetailedGSTLedgerEntry.FINDFIRST THEN
//             REPEAT
//                 IF DetailedGSTLedgerEntry."GST %" > 0 THEN
//                     CesVal += ABS(DetailedGSTLedgerEntry."GST Amount")
//                 ELSE
//                     CesNonAdval += ABS(DetailedGSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;

//         GSTLedgerEntry.SETFILTER("GST Component Code", '<>CGST|<>SGST|<>IGST|<>CESS|<>INTERCESS');
//         IF GSTLedgerEntry.FINDSET THEN BEGIN
//             REPEAT
//                 IF GSTComponent.GET(GSTLedgerEntry."GST Component Code") THEN
//                     IF GSTComponent."Exclude from Reports" THEN
//                         StCesVal += ABS(GSTLedgerEntry."GST Amount");
//             UNTIL GSTLedgerEntry.NEXT = 0;
//         END;

//         TransferShipmentLine.SETRANGE("Document No.", DocumentNo);
//         IF TransferShipmentLine.FINDSET THEN BEGIN
//             REPEAT
//                 AssVal += TransferShipmentLine.Quantity * TransferShipmentLine."Unit Price";
//                 TotGSTAmt += TransferShipmentLine."Total GST Amount";
//                 //      TotInvVal += TransferShipmentLine."Total Amount to Transfer";
//                 TotInvVal += TransferShipmentLine.Quantity * TransferShipmentLine."Unit Price" + TransferShipmentLine."Total GST Amount";
//                 Disc += 0;
//             UNTIL TransferShipmentLine.NEXT = 0;
//         END;
//         //ACX-RK 150521 Begin
//         AssVal := ROUND(AssVal, 0.01);
//         TotInvVal := ROUND(TotInvVal, 0.01);
//         //ACX-RK End
//         OthChrg := 0;
//         roundoffamount := 0;
//     end;

//     local procedure BatchDetailTransferShip(Lotno: Text; Expiry: Text; Warranty: Text)
//     begin

//         JSONTextWriter.WritePropertyName('batch_details');
//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WritePropertyName('name');
//         IF Lotno <> '' THEN
//             JSONTextWriter.WriteValue(Lotno)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('expiry_date');
//         JSONTextWriter.WriteValue(Expiry);
//         JSONTextWriter.WritePropertyName('warranty_date');
//         JSONTextWriter.WriteValue(Warranty);

//         JSONTextWriter.WriteEndArray;
//     end;

//     local procedure AttributedetailsTransferShip(itemattributedetails: Text; itemattributevalue: Text)
//     begin

//         JSONTextWriter.WritePropertyName('attribute_details');
//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('item_attribute_details');
//         IF itemattributedetails <> '' THEN
//             JSONTextWriter.WriteValue(itemattributedetails)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WritePropertyName('item_attribute_value');
//         IF itemattributevalue <> '' THEN
//             JSONTextWriter.WriteValue(itemattributevalue)
//         ELSE
//             JSONTextWriter.WriteValue('');

//         JSONTextWriter.WriteEndObject;

//         JSONTextWriter.WriteEndArray;
//     end;

//     local procedure ReadDispDtlsTransferShip()
//     var
//         company_name: Text;
//         address1: Text;
//         address2: Text;
//         location: Text;
//         pincode: Text;
//         state_code: Text;
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recState: Record "13762";
//     begin
//         WITH TransferShipHeader DO BEGIN
//             recLoc.GET(TransferShipHeader."Transfer-from Code");
//             recCompInfo.GET();
//             company_name := recLoc.Name;
//             address1 := recLoc.Address;
//             address2 := recLoc."Address 2";
//             location := recLoc.City;
//             pincode := recLoc."Post Code";
//             recState.RESET();
//             recState.SETRANGE(Code, recLoc."State Code");
//             IF recState.FIND('-') THEN
//                 state_code := recState.Description;
//         END;

//         WriteDispDtlsTransferShip(company_name, address1, address2, location, pincode, state_code);
//     end;

//     local procedure WriteDispDtlsTransferShip(company_name: Text; address1: Text; address2: Text; location: Text; pincode: Text; state_code: Text)
//     begin

//         JSONTextWriter.WritePropertyName('dispatch_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('company_name');
//         JSONTextWriter.WriteValue(company_name);
//         JSONTextWriter.WritePropertyName('address1');
//         JSONTextWriter.WriteValue(address1);
//         JSONTextWriter.WritePropertyName('address2');
//         JSONTextWriter.WriteValue(address2);
//         JSONTextWriter.WritePropertyName('location');
//         JSONTextWriter.WriteValue(location);
//         JSONTextWriter.WritePropertyName('pincode');
//         JSONTextWriter.WriteValue(pincode);
//         JSONTextWriter.WritePropertyName('state_code');
//         JSONTextWriter.WriteValue(state_code);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadPaymentDtlsTransferShip()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recState: Record "13762";
//         bankaccno: Text;
//         paidbalamt: Decimal;
//         creditdays: Decimal;
//         credittransfer: Text;
//         directdebit: Text;
//         branchIFSC: Text;
//         paymentmode: Text;
//         payeename: Text;
//         paymentduedate: Text;
//         paymentinstruction: Text;
//         paymentterm: Text;
//     begin
//         WITH TransferShipHeader DO BEGIN
//             recLoc.GET(TransferShipHeader."Transfer-from Code");
//             recCompInfo.GET();
//             bankaccno := '';
//             paidbalamt := 0;
//             creditdays := 0;
//             credittransfer := '';
//             directdebit := '';
//             branchIFSC := '';
//             paymentmode := '';
//             payeename := '';
//             paymentduedate := '';
//             paymentinstruction := '';
//             paymentterm := '';
//         END;

//         WritePaymentDtlsTransferShip(bankaccno, paidbalamt, creditdays, credittransfer, directdebit, branchIFSC, paymentmode, payeename, paymentduedate, paymentinstruction, paymentterm);
//     end;

//     local procedure WritePaymentDtlsTransferShip(bankaccno: Text; paidbalamt: Decimal; creditdays: Decimal; credittransfer: Text; directdebit: Text; branchIFSC: Text; paymentmode: Text; payeename: Text; paymentduedate: Text; paymentinstruction: Text; paymentterm: Text)
//     begin

//         JSONTextWriter.WritePropertyName('payment_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('bank_account_number');
//         JSONTextWriter.WriteValue(bankaccno);
//         JSONTextWriter.WritePropertyName('paid_balance_amount');
//         JSONTextWriter.WriteValue(paidbalamt);
//         JSONTextWriter.WritePropertyName('credit_days');
//         JSONTextWriter.WriteValue(creditdays);
//         JSONTextWriter.WritePropertyName('credit_transfer');
//         JSONTextWriter.WriteValue(credittransfer);
//         JSONTextWriter.WritePropertyName('direct_debit');
//         JSONTextWriter.WriteValue(directdebit);
//         JSONTextWriter.WritePropertyName('branch_or_ifsc');
//         JSONTextWriter.WriteValue(branchIFSC);
//         JSONTextWriter.WritePropertyName('payment_mode');
//         JSONTextWriter.WriteValue(paymentmode);
//         JSONTextWriter.WritePropertyName('payee_name');
//         JSONTextWriter.WriteValue(payeename);
//         JSONTextWriter.WritePropertyName('payment_due_date');
//         JSONTextWriter.WriteValue(paymentduedate);
//         JSONTextWriter.WritePropertyName('payment_instruction');
//         JSONTextWriter.WriteValue(paymentinstruction);
//         JSONTextWriter.WritePropertyName('payment_term');
//         JSONTextWriter.WriteValue(paymentterm);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadAdditionalDocumentDtlsTransferShip()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recState: Record "13762";
//         supportingdocumenturl: Text;
//         supportingdocument: Text;
//         additionalinfo: Text;
//     begin
//         WITH TransferShipHeader DO BEGIN
//             JSONTextWriter.WritePropertyName('additional_document_details');
//             JSONTextWriter.WriteStartArray;
//             recLoc.GET(TransferShipHeader."Transfer-from Code");
//             recCompInfo.GET();
//             supportingdocument := '';
//             supportingdocumenturl := '';
//             additionalinfo := '';

//             WriteAdditionalDocumentDtlsTransferShip(supportingdocument, supportingdocumenturl, additionalinfo);

//             JSONTextWriter.WriteEndArray;
//         END;
//     end;

//     local procedure WriteAdditionalDocumentDtlsTransferShip(supportingdocumenturl: Text; supportingdocument: Text; additionalinfo: Text)
//     begin

//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('supporting_document_url');
//         JSONTextWriter.WriteValue(supportingdocument);
//         JSONTextWriter.WritePropertyName('supporting_document');
//         JSONTextWriter.WriteValue(supportingdocumenturl);
//         JSONTextWriter.WritePropertyName('additional_information');
//         JSONTextWriter.WriteValue(additionalinfo);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadEwaybillDtlsTransferShip()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         recLoc: Record "14";
//         recCompInfo: Record "79";
//         recVend: Record "23";
//         transporterid: Text;
//         transportername: Text;
//         transportationmode: Text;
//         transportationdistance: Text;
//         transporterdocumentnumber: Text;
//         transporterdocumentdate: Text;
//         vehiclenumber: Text;
//         vehicletype: Text;
//         recEinvoice: Record "50000";
//     begin
//         WITH TransferShipHeader DO BEGIN
//             IF recVend.GET(TransferShipHeader."Transporter Code") THEN
//                 transportername := recVend.Name
//             ELSE
//                 transportername := '';

//             transporterid := recVend."GST Registration No.";
//             IF TransferShipHeader."Mode of Transport" = 'Road' THEN
//                 transportationmode := '1'
//             ELSE
//                 IF TransferShipHeader."Mode of Transport" = 'Rail' THEN
//                     transportationmode := '2'
//                 ELSE
//                     IF TransferShipHeader."Mode of Transport" = 'Air' THEN
//                         transportationmode := '3'
//                     ELSE
//                         IF TransferShipHeader."Mode of Transport" = 'Ship' THEN
//                             transportationmode := '4'
//                         ELSE
//                             IF TransferShipHeader."Mode of Transport" = '' THEN
//                                 transportationmode := '';

//             recEinvoice.RESET();
//             recEinvoice.SETRANGE("No.", TransferShipHeader."No.");
//             IF recEinvoice.FIND('-') THEN
//                 transportationdistance := recEinvoice."Distance (Km)"
//             ELSE
//                 transportationdistance := '';

//             transporterdocumentnumber := TransferShipHeader."LR/RR No.";
//             transporterdocumentdate := FORMAT(TransferShipHeader."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');

//             vehiclenumber := TransferShipHeader."Vehicle No.";

//             IF TransferShipHeader."Vehicle Type" = TransferShipHeader."Vehicle Type"::ODC THEN
//                 vehicletype := 'O'
//             ELSE
//                 IF TransferShipHeader."Vehicle Type" = TransferShipHeader."Vehicle Type"::Regular THEN
//                     vehicletype := 'R'
//                 ELSE
//                     IF TransferShipHeader."Vehicle Type" = TransferShipHeader."Vehicle Type"::" " THEN
//                         vehicletype := '';
//         END;

//         WriteEwaybilDtlsTransferShip(transporterid, transportername, transportationmode, transportationdistance, transporterdocumentnumber, transporterdocumentdate, vehiclenumber, vehicletype);
//     end;

//     local procedure WriteEwaybilDtlsTransferShip(transporterid: Text; transportername: Text; transportationmode: Text; transportationdistance: Text; transporterdocumentnumber: Text; transporterdocumentdate: Text; vehiclenumber: Text; vehicletype: Text)
//     begin

//         JSONTextWriter.WritePropertyName('ewaybill_details');
//         JSONTextWriter.WriteStartObject;

//         JSONTextWriter.WritePropertyName('transporter_id');
//         JSONTextWriter.WriteValue(transporterid);
//         JSONTextWriter.WritePropertyName('transporter_name');
//         JSONTextWriter.WriteValue(transportername);
//         JSONTextWriter.WritePropertyName('transportation_mode');
//         JSONTextWriter.WriteValue(transportationmode);
//         JSONTextWriter.WritePropertyName('transportation_distance');
//         JSONTextWriter.WriteValue(transportationdistance);
//         JSONTextWriter.WritePropertyName('transporter_document_number');
//         JSONTextWriter.WriteValue(transporterdocumentnumber);
//         JSONTextWriter.WritePropertyName('transporter_document_date');
//         JSONTextWriter.WriteValue(transporterdocumentdate);
//         JSONTextWriter.WritePropertyName('vehicle_number');
//         JSONTextWriter.WriteValue(vehiclenumber);
//         JSONTextWriter.WritePropertyName('vehicle_type');
//         JSONTextWriter.WriteValue(vehicletype);

//         JSONTextWriter.WriteEndObject;
//     end;

//     local procedure ReadReferenceDtlsTransferShip()
//     var
//         SalesInvoiceLine: Record "113";
//         SalesCrMemoLine: Record "115";
//         invoiceremarks: Text;
//         invoiceperiodstartdate: Text;
//         invoiceperiodenddate: Text;
//         referenceoforiginalinvoice: Text;
//         precedinginvoicedate: Text;
//         otherreference: Text;
//         receiptadvicenumber: Text;
//         receiptadvicedate: Text;
//         batchreferencenumber: Text;
//         contractreferencenumber: Text;
//         otherreferenceContract: Text;
//         projectreferencenumber: Text;
//         vendorporeferencenumber: Text;
//         vendorporeferencedate: Text;
//     begin
//         WITH TransferShipHeader DO BEGIN
//             invoiceremarks := '';
//             invoiceperiodstartdate := FORMAT(TransferShipHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             invoiceperiodenddate := FORMAT(TransferShipHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             ;
//             referenceoforiginalinvoice := TransferShipHeader."No.";
//             precedinginvoicedate := FORMAT(TransferShipHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             otherreference := '';
//             receiptadvicenumber := '';
//             receiptadvicedate := '';
//             batchreferencenumber := '';
//             contractreferencenumber := '';
//             otherreferenceContract := '';
//             projectreferencenumber := '';
//             vendorporeferencenumber := TransferShipHeader."External Document No.";
//             vendorporeferencedate := FORMAT(TransferShipHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             ;
//         END;

//         WriteReferenceDtlsTransferShip(invoiceremarks, invoiceperiodstartdate, invoiceperiodenddate, referenceoforiginalinvoice, precedinginvoicedate, otherreference, receiptadvicenumber, receiptadvicedate, batchreferencenumber, contractreferencenumber,
//         otherreferenceContract, projectreferencenumber, vendorporeferencenumber, vendorporeferencedate);
//     end;

//     local procedure WriteReferenceDtlsTransferShip(invoiceremarks: Text; invoiceperiodstartdate: Text; invoiceperiodenddate: Text; referenceoforiginalinvoice: Text; precedinginvoicedate: Text; otherreference: Text; receiptadvicenumber: Text; receiptadvicedate: Text; batchreferencenumber: Text; contractreferencenumber: Text; otherreferenceContract: Text; projectreferencenumber: Text; vendorporeferencenumber: Text; vendorporeferencedate: Text)
//     begin

//         JSONTextWriter.WritePropertyName('reference_details');
//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('invoice_remarks');
//         JSONTextWriter.WriteValue(invoiceremarks);

//         JSONTextWriter.WritePropertyName('document_period_details');
//         JSONTextWriter.Formatting;
//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('invoice_period_start_date');
//         JSONTextWriter.WriteValue(invoiceperiodstartdate);
//         JSONTextWriter.WritePropertyName('invoice_period_end_date');
//         JSONTextWriter.WriteValue(invoiceperiodenddate);
//         JSONTextWriter.WriteEndObject();

//         JSONTextWriter.WritePropertyName('preceding_document_details');

//         JSONTextWriter.Formatting;

//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('reference_of_original_invoice');
//         JSONTextWriter.WriteValue(referenceoforiginalinvoice);
//         JSONTextWriter.WritePropertyName('preceding_invoice_date');
//         JSONTextWriter.WriteValue(precedinginvoicedate);
//         JSONTextWriter.WritePropertyName('other_reference');
//         JSONTextWriter.WriteValue(otherreference);
//         JSONTextWriter.WriteEndObject;

//         JSONTextWriter.WriteEndArray;

//         JSONTextWriter.WritePropertyName('contract_details');

//         JSONTextWriter.Formatting;

//         JSONTextWriter.WriteStartArray;

//         JSONTextWriter.WriteStartObject();
//         JSONTextWriter.WritePropertyName('receipt_advice_number');
//         JSONTextWriter.WriteValue(receiptadvicenumber);
//         JSONTextWriter.WritePropertyName('receipt_advice_date');
//         JSONTextWriter.WriteValue(receiptadvicedate);
//         JSONTextWriter.WritePropertyName('batch_reference_number');
//         JSONTextWriter.WriteValue(batchreferencenumber);
//         JSONTextWriter.WritePropertyName('contract_reference_number');
//         JSONTextWriter.WriteValue(contractreferencenumber);
//         JSONTextWriter.WritePropertyName('other_reference');
//         JSONTextWriter.WriteValue(otherreference);
//         JSONTextWriter.WritePropertyName('project_reference_number');
//         JSONTextWriter.WriteValue(projectreferencenumber);
//         JSONTextWriter.WritePropertyName('vendor_po_reference_number');
//         JSONTextWriter.WriteValue(vendorporeferencenumber);
//         JSONTextWriter.WritePropertyName('vendor_po_reference_date');
//         JSONTextWriter.WriteValue(vendorporeferencedate);

//         JSONTextWriter.WriteEndObject();

//         JSONTextWriter.WriteEndArray;

//         JSONTextWriter.WriteEndObject();
//     end;
}