codeunit 50001 "WebService - E-Way Bill"
{
//     Permissions = TableData 112 = m;

//     trigger OnRun()
//     begin
//         //InitializeAccessToken;
//         //InitializeEwayBillGenerate;
//         //InitializeUpdateVehicleNo;
//         //InitializeCancelBillNo;
//         //InitializeRejectBillNo;
//         //InitializeCalculateDistance;
//     end;

//     var
//         SecurityProtocol: DotNet ServicePointManager;
//         JSONTextWriter: DotNet JsonTextWriter;
//         GetAccessTokenNo: Text;
//         GetGenerateBillNo: Text;
//         GetGenerateBillDate: Text;
//         GetGenerateBillValidUpto: Text;
//         GetUpdateVehicleDate: Text;
//         GetUpdateVehicleValidUptoDate: Text;
//         GetCancelBillDate: Text;
//         GetRejectBillDate: Text;
//         GetRejectBillNo: Text;
//         GetCalculatedDistance: Text;
//         RecCompanyInfo: Record 79;
//         RecDGLE: Record "16419";
//         recItem: Record 27;
//         recUOM: Record 204;
//         RecSalesInvHdr: Record 112;
//         decCGSTper: Decimal;
//         decSGSTper: Decimal;
//         decIGSTper: Decimal;
//         decCESSper: Decimal;
//         RecSalesInvLine: Record 113;
//         RecState: Record State;
//         TotalGSTBaseAmt: Decimal;
//         TotalCGSTAmt: Decimal;
//         TotalSGSTAmt: Decimal;
//         TotalIGSTAmt: Decimal;
//         TotalCESSAmt: Decimal;
//         RecLoc: Record 14;
//         RecShiptoAdd: Record 222;
//         RecVendor: Record 23;
//         recHSN: Record "16411";
//         decQty: Decimal;
//         decGSTBaseAmt: Decimal;
//         txtProdName: Text;
//         txtHSN: Text;
//         txtUOM: Text;
//         RecSalesInvLineInnerLoop: Record 113;
//         cdePrvHSN: Code[30];
//         Date: Integer;
//         Month: Integer;
//         Year: Integer;
//         transportdate: Text;
//         txtmonth: Text;
//         WorkDatet: Integer;
//         WorkMonth: Integer;
//         WorkYear: Integer;
//         WorkdateFinal: Text;
//         txtWorkmonth: Text;
//         PrintURL: Text;
//         JSONManagement: Codeunit 5459;
//         JSONArray: DotNet JArray;
//         recPurchInvHdr: Record 124;
//         recPurchInvHdr1: Record 124;
//         frompincode: Text;
//         topincode: Text;
//         dattext: Text;
//         dateLR: Text;
//         EwayBill: Record 50000;
//         TransRCPT: Record 5746;
//         recTransferShipmentLine: Record 5745;
//         dateTS: Text;
//         recEWayBill: Record 50000;
//         recLocation: Record 14;
//         ConsgineeGSTIN: Code[20];
//         ArrAddress: array[8] of Text;
//         GSTINNo: Code[15];
//         DateTxt: Text;
//         SubSupplyType: Text;
//         DocumentType: Text;
//         SubSpplyDesc: Text;
//         EwayBillType: Text;
//         recEwayBillocType: Record 50000;
//         Recsaleheader: Record 112;


//     procedure InitializeAccessToken(DocNo: Code[30]): Text[500]
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//     begin

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
//         //MESSAGE('Authentication For Access Token : %1',JsonAsText);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             //MESSAGE('Return Value Of Access Token : '+FORMAT(TempBlob.ReadAsText('',TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 GetAccessTokenNo := JObject.GetValue('access_token').ToString;
//                 //MESSAGE('Access Token No. : ' + JObject.GetValue('access_token').ToString);
//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         EXIT(GetAccessTokenNo);
//     end;


//     procedure CreateJsonforAccessToken(DocNo: Code[30]): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//         RecGSTNO: Record "16400";
//         RecSalesInvHdr1: Record 112;
//     begin
//         recEWayBill.RESET();
//         recEWayBill.SETRANGE("No.", DocNo);
//         IF recEWayBill.FINDFIRST THEN BEGIN
//             RecGSTNO.RESET();
//             RecGSTNO.SETRANGE(Code, recEWayBill."Location GST Reg. No.");
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

//                 StringBuilder := StringBuilder.StringBuilder;
//                 StringWriter := StringWriter.StringWriter(StringBuilder);
//                 JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//                 JSONTextWriter.WriteStartObject;

//                 CreateJsonAttribute('username', RecGSTNO.Username, JSONTextWriter);
//                 CreateJsonAttribute('password', RecGSTNO.Password, JSONTextWriter);
//                 CreateJsonAttribute('client_id', RecGSTNO."Client ID", JSONTextWriter);
//                 CreateJsonAttribute('client_secret', RecGSTNO."Client Secret", JSONTextWriter);
//                 CreateJsonAttribute('ReasonCode', '1', JSONTextWriter);
//                 CreateJsonAttribute('grant_type', RecGSTNO."Grant Type", JSONTextWriter);

//                 JSONTextWriter.WriteEndObject;
//             END;
//             EXIT(StringBuilder.ToString);
//         END;

//         //E-Way Bill Return

//         recPurchInvHdr1.RESET();
//         recPurchInvHdr1.SETRANGE("No.", DocNo);
//         IF recPurchInvHdr1.FINDFIRST THEN BEGIN
//             RecGSTNO.RESET();
//             RecGSTNO.SETRANGE(Code, recPurchInvHdr1."Location GST Reg. No.");
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

//                 StringBuilder := StringBuilder.StringBuilder;
//                 StringWriter := StringWriter.StringWriter(StringBuilder);
//                 JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//                 JSONTextWriter.WriteStartObject;

//                 CreateJsonAttribute('username', RecGSTNO.Username, JSONTextWriter);
//                 CreateJsonAttribute('password', RecGSTNO.Password, JSONTextWriter);
//                 CreateJsonAttribute('client_id', RecGSTNO."Client ID", JSONTextWriter);
//                 CreateJsonAttribute('client_secret', RecGSTNO."Client Secret", JSONTextWriter);
//                 CreateJsonAttribute('ReasonCode', '1', JSONTextWriter);
//                 CreateJsonAttribute('grant_type', RecGSTNO."Grant Type", JSONTextWriter);

//                 JSONTextWriter.WriteEndObject;
//             END;
//             EXIT(StringBuilder.ToString);
//         END;
//     end;


//     procedure InitializeEwayBillGenerate(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Alert: Text;
//         Error: Text;
//         Status: Text;
//         "Code": Text;
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         Url := 'https://pro.mastersindia.co/ewayBillsGenerate';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforEwayBillGenerate(DocNo, ReceiveTokenNo)); //Use WriteText function instead of write
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Generate E-Way Bill : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Generate E-Way Bill : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //    MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetGenerateBillNo := (JObject.GetValue('ewayBillNo').ToString);
//                     MESSAGE('E-Way Bill No. : ' + JObject.GetValue('ewayBillNo').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetGenerateBillDate := (JObject.GetValue('ewayBillDate').ToString);
//                     //MESSAGE('E-Way Bill Date : ' + JObject.GetValue('ewayBillDate').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetGenerateBillValidUpto := (JObject.GetValue('validUpto').ToString);
//                     //MESSAGE('E-Way Bill Valid Upto : ' + JObject.GetValue('validUpto').ToString);

//                     JObject := JObject.Parse(temp01);
//                     Alert := (JObject.GetValue('alert').ToString);
//                     //    MESSAGE('Alert : ' + JObject.GetValue('alert').ToString);

//                     JObject := JObject.Parse(temp01);
//                     Error := (JObject.GetValue('error').ToString);
//                     //    MESSAGE('Error : ' + JObject.GetValue('error').ToString);

//                     JObject := JObject.Parse(temp01);
//                     PrintURL := (JObject.GetValue('url').ToString);
//                     //MESSAGE('URL : ' + JObject.GetValue('url').ToString);

//                     RecSalesInvHdr.RESET();
//                     RecSalesInvHdr.SETRANGE("No.", DocNo);
//                     IF RecSalesInvHdr.FIND('-') THEN BEGIN
//                         RecSalesInvHdr."E-Way Bill No." := GetGenerateBillNo;
//                         RecSalesInvHdr."E-Way Bill Date" := GetGenerateBillDate;
//                         RecSalesInvHdr."E-Way Bill Valid Upto" := GetGenerateBillValidUpto;
//                         RecSalesInvHdr."E-Way Bill Report URL" := PrintURL;
//                         RecSalesInvHdr."Vehicle Update Date" := '';
//                         RecSalesInvHdr."Vehicle Valid Upto" := '';
//                         RecSalesInvHdr."Cancel E-Way Bill Date" := '';
//                         RecSalesInvHdr."Reason Code for Vehicle Update" := RecSalesInvHdr."Reason Code for Vehicle Update"::" ";
//                         RecSalesInvHdr."Reason for Vehicle Update" := '';
//                         RecSalesInvHdr."Reason Code for Cancel" := RecSalesInvHdr."Reason Code for Cancel"::" ";
//                         RecSalesInvHdr."Reason for Cancel Remarks" := '';
//                         RecSalesInvHdr."Old Vehicle No." := RecSalesInvHdr."Vehicle No.";
//                         RecSalesInvHdr.MODIFY;
//                     END;

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := Status + ' ' + Code;
//             RecSalesInvHdr.MODIFY;
//         END
//         ELSE BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             RecSalesInvHdr.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforEwayBillGenerate(DocNo: Code[30]; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//         RecDetailedGSTLedEntry: Record "16419";
//         Value: array[50] of Text;
//     begin
//         RecSalesInvHdr.RESET();
//         RecSalesInvHdr.SETRANGE("No.", DocNo);
//         IF RecSalesInvHdr.FIND('-') THEN BEGIN
//             RecCompanyInfo.GET();
//             //ACX-RK 07072021 Begin
//             IF RecSalesInvHdr."GST Customer Type" = RecSalesInvHdr."GST Customer Type"::Unregistered THEN
//                 GSTINNo := 'URP'
//             ELSE
//                 GSTINNo := RecSalesInvHdr."Customer GST Reg. No.";
//             //ACX-RK End

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', RecSalesInvHdr."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('supply_type', 'Outward', JSONTextWriter);
//             CreateJsonAttribute('sub_supply_type', 'Supply', JSONTextWriter);
//             CreateJsonAttribute('sub_supply_description', '', JSONTextWriter); //HT
//                                                                                //CreateJsonAttribute('document_type',  'Tax Invoice',JSONTextWriter);
//             Recsaleheader.RESET;
//             Recsaleheader.SETRANGE("No.", DocNo);
//             IF Recsaleheader.FINDFIRST THEN
//                 CreateJsonAttribute('document_type', FORMAT(Recsaleheader."Document Type"), JSONTextWriter);
//             CreateJsonAttribute('document_number', RecSalesInvHdr."No.", JSONTextWriter);

//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, RecSalesInvHdr."Location Code");
//             IF RecLoc.FIND('-') THEN BEGIN

//                 WorkDatet := DATE2DMY(RecSalesInvHdr."Posting Date", 1);
//                 IF WorkDatet < 10 THEN
//                     dattext := '0' + FORMAT(WorkDatet)
//                 ELSE
//                     dattext := FORMAT(WorkDatet);

//                 //dattext := FORMAT(DATE2DMY(RecSalesInvHdr."Posting Date",1));
//                 WorkMonth := DATE2DMY(RecSalesInvHdr."Posting Date", 2);
//                 IF WorkMonth < 10 THEN
//                     txtWorkmonth := FORMAT(0) + FORMAT(WorkMonth)
//                 ELSE
//                     txtWorkmonth := FORMAT(WorkMonth);

//                 WorkYear := DATE2DMY(RecSalesInvHdr."Posting Date", 3);
//                 //WorkdateFinal := FORMAT(WorkDatet)+'/'+txtWorkmonth+'/'+FORMAT(WorkYear);
//                 WorkdateFinal := FORMAT(dattext) + '/' + txtWorkmonth + '/' + FORMAT(WorkYear);
//                 CreateJsonAttribute('document_date', WorkdateFinal, JSONTextWriter);

//                 CreateJsonAttribute('gstin_of_consignor', RecLoc."GST Registration No.", JSONTextWriter);
//                 CreateJsonAttribute('legal_name_of_consignor', RecCompanyInfo.Name, JSONTextWriter);
//                 CreateJsonAttribute('address1_of_consignor', RecLoc.Address, JSONTextWriter);
//                 CreateJsonAttribute('address2_of_consignor', RecLoc."Address 2", JSONTextWriter);
//                 CreateJsonAttribute('place_of_consignor', RecLoc.City, JSONTextWriter);
//                 CreateJsonAttribute('pincode_of_consignor', RecLoc."Post Code", JSONTextWriter);
//             END;

//             RecState.RESET();
//             RecState.SETRANGE(Code, RecLoc."State Code");
//             IF RecState.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('state_of_consignor', RecState.Description, JSONTextWriter);
//                 CreateJsonAttribute('actual_from_state_name', RecState.Description, JSONTextWriter);
//             END;

//             IF RecSalesInvHdr."Ship-to Code" <> '' THEN BEGIN
//                 RecShiptoAdd.RESET();
//                 RecShiptoAdd.SETRANGE("Customer No.", RecSalesInvHdr."Sell-to Customer No.");
//                 RecShiptoAdd.SETRANGE(Code, RecSalesInvHdr."Ship-to Code");
//                 IF RecShiptoAdd.FIND('-') THEN BEGIN
//                     //ACX-RK 07072021 Begin
//                     IF RecSalesInvHdr."GST Customer Type" = RecSalesInvHdr."GST Customer Type"::Unregistered THEN
//                         GSTINNo := 'URP'
//                     ELSE
//                         GSTINNo := RecShiptoAdd."GST Registration No.";
//                     //ACX-RK End
//                     CreateJsonAttribute('gstin_of_consignee', GSTINNo, JSONTextWriter);
//                     CreateJsonAttribute('legal_name_of_consignee', RecShiptoAdd.Name, JSONTextWriter);
//                     CreateJsonAttribute('address1_of_consignee', RecShiptoAdd.Address, JSONTextWriter);
//                     CreateJsonAttribute('address2_of_consignee', RecShiptoAdd."Address 2", JSONTextWriter);
//                     CreateJsonAttribute('place_of_consignee', RecShiptoAdd.City, JSONTextWriter);
//                     CreateJsonAttribute('pincode_of_consignee', RecShiptoAdd."Post Code", JSONTextWriter);
//                 END;
//             END
//             ELSE BEGIN
//                 CreateJsonAttribute('gstin_of_consignee', GSTINNo, JSONTextWriter);
//                 CreateJsonAttribute('legal_name_of_consignee', RecSalesInvHdr."Sell-to Customer Name", JSONTextWriter);
//                 CreateJsonAttribute('address1_of_consignee', RecSalesInvHdr."Sell-to Address", JSONTextWriter);
//                 CreateJsonAttribute('address2_of_consignee', RecSalesInvHdr."Sell-to Address 2", JSONTextWriter);
//                 CreateJsonAttribute('place_of_consignee', RecSalesInvHdr."Sell-to City", JSONTextWriter);
//                 CreateJsonAttribute('pincode_of_consignee', RecSalesInvHdr."Sell-to Post Code", JSONTextWriter);
//             END;

//             IF RecSalesInvHdr."Ship-to Code" <> '' THEN BEGIN
//                 RecShiptoAdd.RESET();
//                 RecShiptoAdd.SETRANGE("Customer No.", RecSalesInvHdr."Sell-to Customer No.");
//                 RecShiptoAdd.SETRANGE(Code, RecSalesInvHdr."Ship-to Code");
//                 IF RecShiptoAdd.FIND('-') THEN BEGIN
//                     RecState.RESET();
//                     RecState.SETRANGE(Code, RecShiptoAdd.State);
//                     IF RecState.FIND('-') THEN BEGIN
//                         CreateJsonAttribute('state_of_supply', RecState.Description, JSONTextWriter);
//                         CreateJsonAttribute('actual_to_state_name', RecState.Description, JSONTextWriter);
//                     END;
//                 END;
//             END
//             ELSE BEGIN
//                 RecState.RESET();
//                 RecState.SETRANGE(Code, RecSalesInvHdr.State);
//                 IF RecState.FIND('-') THEN BEGIN
//                     CreateJsonAttribute('state_of_supply', RecState.Description, JSONTextWriter);
//                     CreateJsonAttribute('actual_to_state_name', RecState.Description, JSONTextWriter);
//                 END;
//             END;

//             CreateJsonAttribute('transaction_type', 'Regular', JSONTextWriter);

//             CreateJsonAttribute('other_value', 0, JSONTextWriter); //HT

//             RecSalesInvHdr.CALCFIELDS("Amount to Customer");
//             CreateJsonAttribute('total_invoice_value', RecSalesInvHdr."Amount to Customer", JSONTextWriter);

//             TotalGSTBaseAmt := 0;
//             RecSalesInvLine.RESET();
//             RecSalesInvLine.SETRANGE("Document No.", RecSalesInvHdr."No.");
//             RecSalesInvLine.SETRANGE(Type, RecSalesInvLine.Type::Item);
//             RecSalesInvLine.SETFILTER(Quantity, '<>%1', 0);
//             IF RecSalesInvLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     TotalGSTBaseAmt += ABS(RecSalesInvLine."GST Base Amount");
//                 UNTIL
//                   RecSalesInvLine.NEXT = 0;
//             END;

//             CreateJsonAttribute('taxable_amount', TotalGSTBaseAmt, JSONTextWriter);

//             TotalCGSTAmt := 0;
//             RecDGLE.RESET();
//             RecDGLE.SETRANGE("Document No.", RecSalesInvHdr."No.");
//             RecDGLE.SETRANGE("GST Component Code", 'CGST');
//             IF RecDGLE.FIND('-') THEN BEGIN
//                 REPEAT
//                     TotalCGSTAmt += ABS(RecDGLE."GST Amount");
//                 UNTIL
//                   RecDGLE.NEXT = 0;
//             END;

//             TotalSGSTAmt := 0;
//             RecDGLE.RESET();
//             RecDGLE.SETRANGE("Document No.", RecSalesInvHdr."No.");
//             RecDGLE.SETRANGE("GST Component Code", 'SGST');
//             IF RecDGLE.FIND('-') THEN BEGIN
//                 REPEAT
//                     TotalSGSTAmt += ABS(RecDGLE."GST Amount");
//                 UNTIL
//                   RecDGLE.NEXT = 0;
//             END;

//             TotalIGSTAmt := 0;
//             RecDGLE.RESET();
//             RecDGLE.SETRANGE("Document No.", RecSalesInvHdr."No.");
//             RecDGLE.SETRANGE("GST Component Code", 'IGST');
//             IF RecDGLE.FIND('-') THEN BEGIN
//                 REPEAT
//                     TotalIGSTAmt += ABS(RecDGLE."GST Amount");
//                 UNTIL
//                   RecDGLE.NEXT = 0;
//             END;

//             TotalCESSAmt := 0;
//             RecDGLE.RESET();
//             RecDGLE.SETRANGE("Document No.", RecSalesInvHdr."No.");
//             RecDGLE.SETRANGE("GST Component Code", 'CESS');
//             IF RecDGLE.FIND('-') THEN BEGIN
//                 REPEAT
//                     TotalCESSAmt += RecDGLE."GST Amount";
//                 UNTIL
//                   RecDGLE.NEXT = 0;
//             END;

//             CreateJsonAttribute('cgst_amount', TotalCGSTAmt, JSONTextWriter);
//             CreateJsonAttribute('sgst_amount', TotalSGSTAmt, JSONTextWriter);
//             CreateJsonAttribute('igst_amount', TotalIGSTAmt, JSONTextWriter);
//             CreateJsonAttribute('cess_amount', TotalCESSAmt, JSONTextWriter);

//             CreateJsonAttribute('cess_nonadvol_value', 0, JSONTextWriter); //HT
//             IF RecSalesInvHdr."Transporter Code" <> '' THEN BEGIN
//                 RecVendor.RESET();
//                 RecVendor.SETRANGE("No.", RecSalesInvHdr."Transporter Code");
//                 IF RecVendor.FIND('-') THEN BEGIN
//                     CreateJsonAttribute('transporter_id', RecVendor."GST Registration No.", JSONTextWriter);
//                     CreateJsonAttribute('transporter_name', RecVendor.Name, JSONTextWriter);
//                 END;
//             END ELSE
//                 CreateJsonAttribute('transporter_id', RecSalesInvHdr."Transporter GSTIN", JSONTextWriter);
//             CreateJsonAttribute('transporter_name', RecSalesInvHdr."Transporter Name", JSONTextWriter);
//             CreateJsonAttribute('transporter_document_number', RecSalesInvHdr."LR/RR No.", JSONTextWriter);
//             IF RecSalesInvHdr."LR/RR Date" <> 0D THEN BEGIN//ACX-RK 100521
//                 Date := DATE2DMY(RecSalesInvHdr."LR/RR Date", 1);
//                 Month := DATE2DMY(RecSalesInvHdr."LR/RR Date", 2);
//                 Year := DATE2DMY(RecSalesInvHdr."LR/RR Date", 3);
//             END;
//             IF Date < 10 THEN
//                 dateLR := '0' + FORMAT(Date)
//             ELSE
//                 dateLR := FORMAT(Date);

//             IF Month < 10 THEN
//                 txtmonth := FORMAT(0) + FORMAT(Month)
//             ELSE
//                 txtmonth := FORMAT(Month);

//             transportdate := FORMAT(dateLR) + '/' + txtmonth + '/' + FORMAT(Year);
//             CreateJsonAttribute('transporter_document_date', transportdate, JSONTextWriter);
//             //CreateJsonAttribute('transporter_document_date',  WorkdateFinal,JSONTextWriter); //HT16092019 (replace error for upper line)

//             CreateJsonAttribute('transportation_mode', FORMAT(RecSalesInvHdr."Mode of Transport"), JSONTextWriter);
//             CreateJsonAttribute('transportation_distance', RecSalesInvHdr."Distance (Km)", JSONTextWriter);
//             CreateJsonAttribute('vehicle_number', FORMAT(RecSalesInvHdr."Vehicle No."), JSONTextWriter);
//             CreateJsonAttribute('vehicle_type', FORMAT(RecSalesInvHdr."Vehicle Type"), JSONTextWriter);

//             CreateJsonAttribute('generate_status', 1, JSONTextWriter); //HT
//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT
//             CreateJsonAttribute('user_ref', '1232435466sdsf234', JSONTextWriter); //HT
//             CreateJsonAttribute('location_code', 'XYZ', JSONTextWriter); //HT
//                                                                          //RK 05May22 Begin
//             IF EwayBill."E-way Bill Part" = EwayBill."E-way Bill Part"::Registered THEN
//                 EwayBillType := 'AC'
//             ELSE
//                 EwayBillType := 'ABC';

//             IF RecSalesInvHdr."E-way Bill Part" = RecSalesInvHdr."E-way Bill Part"::Registered THEN
//                 EwayBillType := 'AC'
//             ELSE
//                 EwayBillType := 'ABC';
//             CreateJsonAttribute('eway_bill_status', EwayBillType, JSONTextWriter); //HT
//                                                                                    //RK End
//             CreateJsonAttribute('auto_print', 'Y', JSONTextWriter); //HT
//             CreateJsonAttribute('email', 'mayanksharma@mastersindia.co', JSONTextWriter); //HT

//             //Array Start-
//             JSONTextWriter.Formatting;

//             JSONTextWriter.WritePropertyName('itemList');

//             JSONTextWriter.WriteStartArray();

//             cdePrvHSN := '';
//             RecSalesInvLine.SETCURRENTKEY("HSN/SAC Code");
//             RecSalesInvLine.RESET();
//             RecSalesInvLine.SETRANGE("Document No.", RecSalesInvHdr."No.");
//             RecSalesInvLine.SETRANGE(Type, RecSalesInvLine.Type::Item);
//             RecSalesInvLine.SETFILTER(Quantity, '<>%1', 0);
//             IF RecSalesInvLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     txtProdName := '';
//                     txtHSN := '';
//                     txtUOM := '';
//                     decCGSTper := 0;
//                     decSGSTper := 0;
//                     decIGSTper := 0;
//                     decCESSper := 0;
//                     decQty := 0;
//                     decGSTBaseAmt := 0;

//                     IF RecSalesInvLine."HSN/SAC Code" <> cdePrvHSN THEN BEGIN

//                         RecSalesInvLineInnerLoop.RESET();
//                         RecSalesInvLineInnerLoop.SETRANGE("Document No.", RecSalesInvLine."Document No.");
//                         RecSalesInvLineInnerLoop.SETRANGE("HSN/SAC Code", RecSalesInvLine."HSN/SAC Code");
//                         RecSalesInvLineInnerLoop.SETRANGE(Type, RecSalesInvLineInnerLoop.Type::Item);
//                         RecSalesInvLineInnerLoop.SETFILTER(Quantity, '<>%1', 0);
//                         IF RecSalesInvLineInnerLoop.FINDFIRST THEN BEGIN
//                             cdePrvHSN := RecSalesInvLineInnerLoop."HSN/SAC Code";
//                             REPEAT

//                                 recHSN.RESET();
//                                 recHSN.SETRANGE(Code, RecSalesInvLineInnerLoop."HSN/SAC Code");
//                                 IF recHSN.FIND('-') THEN BEGIN
//                                     txtProdName := recHSN.Description;
//                                 END;
//                                 txtHSN := RecSalesInvLineInnerLoop."HSN/SAC Code";
//                                 txtUOM := RecSalesInvLineInnerLoop."Unit of Measure Code";

//                                 RecDGLE.RESET();
//                                 RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
//                                 RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
//                                 RecDGLE.SETRANGE("GST Component Code", 'CGST');
//                                 IF RecDGLE.FIND('-') THEN BEGIN
//                                     decCGSTper := RecDGLE."GST %";
//                                 END;

//                                 RecDGLE.RESET();
//                                 RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
//                                 RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
//                                 RecDGLE.SETRANGE("GST Component Code", 'SGST');
//                                 IF RecDGLE.FIND('-') THEN BEGIN
//                                     decSGSTper := RecDGLE."GST %";
//                                 END;

//                                 RecDGLE.RESET();
//                                 RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
//                                 RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
//                                 RecDGLE.SETRANGE("GST Component Code", 'IGST');
//                                 IF RecDGLE.FIND('-') THEN BEGIN
//                                     decIGSTper := RecDGLE."GST %";
//                                 END;

//                                 RecDGLE.RESET();
//                                 RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
//                                 RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
//                                 RecDGLE.SETRANGE("GST Component Code", 'CESS');
//                                 IF RecDGLE.FIND('-') THEN BEGIN
//                                     decCESSper := RecDGLE."GST %";
//                                 END;
//                                 //ACX-RK 100521 Begin
//                                 decCGSTper := ROUND(decCGSTper, 1);
//                                 decSGSTper := ROUND(decSGSTper, 1);
//                                 decIGSTper := ROUND(decIGSTper, 1);
//                                 //ACX-RK End
//                                 decQty += RecSalesInvLineInnerLoop.Quantity;
//                                 decGSTBaseAmt += RecSalesInvLineInnerLoop."GST Base Amount";

//                             UNTIL RecSalesInvLineInnerLoop.NEXT = 0;
//                         END;
//                         JSONTextWriter.WriteStartObject();

//                         JSONTextWriter.WritePropertyName('product_name');
//                         JSONTextWriter.WriteValue(txtProdName);

//                         JSONTextWriter.WritePropertyName('product_description');
//                         JSONTextWriter.WriteValue(txtProdName);

//                         JSONTextWriter.WritePropertyName('hsn_code');
//                         JSONTextWriter.WriteValue(txtHSN);

//                         JSONTextWriter.WritePropertyName('unit_of_product');
//                         JSONTextWriter.WriteValue(txtUOM);
//                         //            JSONTextWriter.WriteValue('PCS');

//                         JSONTextWriter.WritePropertyName('cgst_rate');
//                         JSONTextWriter.WriteValue(decCGSTper);

//                         JSONTextWriter.WritePropertyName('sgst_rate');
//                         JSONTextWriter.WriteValue(decSGSTper);

//                         JSONTextWriter.WritePropertyName('igst_rate');
//                         JSONTextWriter.WriteValue(decIGSTper);

//                         JSONTextWriter.WritePropertyName('cess_rate');
//                         JSONTextWriter.WriteValue(decCESSper);

//                         JSONTextWriter.WritePropertyName('quantity');
//                         JSONTextWriter.WriteValue(decQty);

//                         JSONTextWriter.WritePropertyName('cessNonAdvol'); //HT
//                         JSONTextWriter.WriteValue('0');

//                         JSONTextWriter.WritePropertyName('taxable_amount');
//                         JSONTextWriter.WriteValue(decGSTBaseAmt);

//                         JSONTextWriter.WriteEndObject;
//                     END;
//                 UNTIL
//                 RecSalesInvLine.NEXT = 0;
//             END;

//             JSONTextWriter.WriteEndArray();
//             //Array Start+

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

//         END;
//     end;


//     procedure InitializeUpdateVehicleNo(DocNo: Code[30]; VehicleNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         Url := 'https://pro.mastersindia.co/updateVehicleNumber';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforUpdateVehicleNo(DocNo, VehicleNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Update Vehicle No. : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Update Vehicle No. : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //    MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //    MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetUpdateVehicleDate := (JObject.GetValue('vehUpdDate').ToString);
//                     MESSAGE('Vehicle Update Date : ' + JObject.GetValue('vehUpdDate').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetUpdateVehicleValidUptoDate := (JObject.GetValue('validUpto').ToString);
//                     MESSAGE('Vehicle Valid Upto : ' + JObject.GetValue('validUpto').ToString);

//                     RecSalesInvHdr.RESET();
//                     RecSalesInvHdr.SETRANGE("No.", DocNo);
//                     IF RecSalesInvHdr.FIND('-') THEN BEGIN
//                         RecSalesInvHdr."Vehicle Update Date" := FORMAT(GetUpdateVehicleDate);
//                         RecSalesInvHdr."Vehicle Valid Upto" := FORMAT(GetUpdateVehicleValidUptoDate);
//                         RecSalesInvHdr."Old Vehicle No." := RecSalesInvHdr."Vehicle No.";
//                         RecSalesInvHdr.MODIFY;
//                     END;

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := Status + ' ' + Code;
//             RecSalesInvHdr.MODIFY
//         END
//         ELSE BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             RecSalesInvHdr.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforUpdateVehicleNo(DocNo: Code[30]; VehicleNo: Text; ReceiveTokenNo: Text): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//     begin
//         RecSalesInvHdr.RESET();
//         RecSalesInvHdr.SETRANGE("No.", DocNo);
//         RecSalesInvHdr.SETRANGE("Vehicle No.", VehicleNo);
//         IF RecSalesInvHdr.FIND('-') THEN BEGIN

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', RecSalesInvHdr."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('eway_bill_number', RecSalesInvHdr."E-Way Bill No.", JSONTextWriter);
//             CreateJsonAttribute('vehicle_number', RecSalesInvHdr."Vehicle No.", JSONTextWriter);
//             CreateJsonAttribute('vehicle_type', FORMAT(RecSalesInvHdr."Vehicle Type"), JSONTextWriter);

//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, RecSalesInvHdr."Location Code");
//             IF RecLoc.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('place_of_consignor', RecLoc.City, JSONTextWriter);
//             END;

//             RecState.RESET();
//             RecState.SETRANGE(Code, RecSalesInvHdr."Location State Code");
//             IF RecState.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('state_of_consignor', RecState.Description, JSONTextWriter);
//             END;

//             CreateJsonAttribute('reason_code_for_vehicle_updation', FORMAT(RecSalesInvHdr."Reason Code for Vehicle Update"), JSONTextWriter); //HT
//             CreateJsonAttribute('reason_for_vehicle_updation', FORMAT(RecSalesInvHdr."Reason for Vehicle Update"), JSONTextWriter); //HT

//             CreateJsonAttribute('transporter_document_number', RecSalesInvHdr."LR/RR No.", JSONTextWriter);

//             Date := DATE2DMY(RecSalesInvHdr."LR/RR Date", 1);
//             //ACX-RK 08102021
//             IF Date < 10 THEN
//                 DateTxt := FORMAT(0) + FORMAT(Date)
//             ELSE
//                 DateTxt := FORMAT(Date);
//             //ACX-RK End
//             Month := DATE2DMY(RecSalesInvHdr."LR/RR Date", 2);
//             IF Month < 10 THEN
//                 txtmonth := FORMAT(0) + FORMAT(Month)
//             ELSE
//                 txtmonth := FORMAT(Month);

//             Year := DATE2DMY(RecSalesInvHdr."LR/RR Date", 3);
//             transportdate := DateTxt + '/' + txtmonth + '/' + FORMAT(Year);
//             CreateJsonAttribute('transporter_document_date', transportdate, JSONTextWriter);


//             CreateJsonAttribute('mode_of_transport', FORMAT(RecSalesInvHdr."Mode of Transport"), JSONTextWriter);

//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

//         END;
//     end;


//     procedure InitializeCancelBillNo(DocNo: Code[30]; EwayBillNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//     begin

//         Url := 'https://pro.mastersindia.co/ewayBillCancel';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforCancelBillNo(DocNo, EwayBillNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Cancel E-Way Bill No. : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Cancel E-Way Bill No. : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //    MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //    MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetCancelBillDate := (JObject.GetValue('cancelDate').ToString);
//                     MESSAGE('Cancel E-Way Bill Date : ' + JObject.GetValue('cancelDate').ToString);

//                     RecSalesInvHdr.RESET();
//                     RecSalesInvHdr.SETRANGE("No.", DocNo);
//                     RecSalesInvHdr.SETRANGE("E-Way Bill No.", EwayBillNo);
//                     IF RecSalesInvHdr.FIND('-') THEN BEGIN
//                         RecSalesInvHdr."Cancel E-Way Bill Date" := FORMAT(GetCancelBillDate);
//                         RecSalesInvHdr."Old Vehicle No." := '';
//                         RecSalesInvHdr.MODIFY;
//                     END;

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := Status + ' ' + Code;
//             //      RecSalesInvHdr."E-Way Bill Report URL" := '';
//             RecSalesInvHdr.MODIFY;
//         END
//         ELSE BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             RecSalesInvHdr.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforCancelBillNo(DocNo: Code[30]; EwayBillNo: Text; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         RecSalesInvHdr.RESET();
//         RecSalesInvHdr.SETRANGE("No.", DocNo);
//         IF RecSalesInvHdr.FIND('-') THEN BEGIN

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', RecSalesInvHdr."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('eway_bill_number', RecSalesInvHdr."E-Way Bill No.", JSONTextWriter);
//             CreateJsonAttribute('reason_of_cancel', FORMAT(RecSalesInvHdr."Reason Code for Cancel"), JSONTextWriter);
//             CreateJsonAttribute('cancel_remark', FORMAT(RecSalesInvHdr."Reason for Cancel Remarks"), JSONTextWriter);
//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

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
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         frompincode := '';
//         topincode := '';
//         RecSalesInvHdr.RESET();
//         RecSalesInvHdr.SETRANGE("No.", DocNo);
//         IF RecSalesInvHdr.FIND('-') THEN BEGIN
//             IF RecSalesInvHdr."Ship-to Code" <> '' THEN
//                 frompincode := FORMAT(RecSalesInvHdr."Ship-to Post Code")
//             ELSE
//                 frompincode := FORMAT(RecSalesInvHdr."Sell-to Post Code");

//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, RecSalesInvHdr."Location Code");
//             IF RecLoc.FIND('-') THEN
//                 topincode := FORMAT(RecLoc."Post Code");
//         END;

//         Url := 'https://pro.mastersindia.co/distance?access_token=' + ReceiveTokenNo + '&fromPincode=' + frompincode + '&toPincode=' + topincode;

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
//                     MESSAGE('Distance for E-Way Bill ' + JObject.GetValue('distance').ToString);

//                     RecSalesInvHdr.RESET();
//                     RecSalesInvHdr.SETRANGE("No.", DocNo);
//                     IF RecSalesInvHdr.FIND('-') THEN BEGIN
//                         EVALUATE(RecSalesInvHdr."Distance (Km)", GetCalculatedDistance);
//                         RecSalesInvHdr.MODIFY;
//                     END;
//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := Status + ' ' + Code;
//             RecSalesInvHdr.MODIFY
//         END
//         ELSE BEGIN
//             RecSalesInvHdr.RESET();
//             RecSalesInvHdr.SETRANGE("No.", DocNo);
//             IF RecSalesInvHdr.FIND('-') THEN
//                 RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             RecSalesInvHdr.MODIFY;
//         END;
//     end;


//     procedure CreateJsonAttribute(PropertyName: Text; Value: Variant; JSONTextWriter: DotNet JsonTextWriter)
//     var
//         StringWriter: DotNet StringWriter;
//     begin
//         JSONTextWriter.WritePropertyName(PropertyName);
//         JSONTextWriter.WriteValue(Value);
//     end;


//     procedure InitializeCancelBillNoSalesReturn(DocNo: Code[30]; EwayBillNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//         recResponseLog: Record "50003";
//         recSalesCrMemo: Record 114;
//         recEwayBill: Record "50000";
//     begin

//         Url := 'https://pro.mastersindia.co/ewayBillCancel';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforCancelBillNoSalesReturn(DocNo, EwayBillNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Cancel E-Way Bill No. : %1', JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Cancel E-Way Bill No. : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //    MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //    MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetCancelBillDate := (JObject.GetValue('cancelDate').ToString);
//                     MESSAGE('Cancel E-Way Bill Date : ' + JObject.GetValue('cancelDate').ToString);

//                     recEwayBill.RESET();
//                     recEwayBill.SETRANGE("No.", DocNo);
//                     recEwayBill.SETRANGE("E-Way Bill No.", EwayBillNo);
//                     IF recEwayBill.FIND('-') THEN BEGIN
//                         recEwayBill."Cancel E-Way Bill Date" := FORMAT(GetCancelBillDate);
//                         recEwayBill."Old Vehicle No." := '';
//                         recEwayBill.MODIFY;
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
//                     recResponseLog.Status := 'Failure';
//                     recResponseLog."Called API" := 'Cancel E-Way Bill';
//                     recResponseLog.INSERT;

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             recEwayBill.RESET();
//             recEwayBill.SETRANGE("No.", DocNo);
//             IF recEwayBill.FIND('-') THEN
//                 recEwayBill."E-Way Bill Status" := Status + ' ' + Code;
//             //      RecSalesInvHdr."E-Way Bill Report URL" := '';
//             RecSalesInvHdr.MODIFY;
//         END
//         ELSE BEGIN

//             recResponseLog.INIT;
//             recResponseLog."Document No." := DocNo;
//             recResponseLog."Response Date" := TODAY;
//             recResponseLog."Response Time" := TIME;
//             recResponseLog."Response Log 1" := COPYSTR(ApiResult, 1, 250);
//             recResponseLog."Response Log 2" := COPYSTR(ApiResult, 251, 250);
//             recResponseLog."Response Log 3" := COPYSTR(ApiResult, 501, 250);
//             recResponseLog."Response Log 4" := COPYSTR(ApiResult, 751, 250);
//             recResponseLog."Response Log 5" := COPYSTR(ApiResult, 1001, 250);
//             recResponseLog."Response Log 6" := COPYSTR(ApiResult, 1251, 250);
//             recResponseLog."Response Log 7" := COPYSTR(ApiResult, 1501, 250);
//             recResponseLog."Response Log 8" := COPYSTR(ApiResult, 1751, 250);
//             recResponseLog."Response Log 9" := COPYSTR(ApiResult, 2001, 250);
//             recResponseLog."Response Log 10" := COPYSTR(ApiResult, 2251, 250);
//             recResponseLog."Response Log 11" := COPYSTR(ApiResult, 2501, 250);
//             recResponseLog."Response Log 12" := COPYSTR(ApiResult, 2751, 250);
//             recResponseLog."Response Log 13" := COPYSTR(ApiResult, 3001, 250);
//             recResponseLog."Response Log 14" := COPYSTR(ApiResult, 3251, 250);
//             recResponseLog."Response Log 15" := COPYSTR(ApiResult, 3501, 250);
//             recResponseLog."Response Log 16" := COPYSTR(ApiResult, 3751, 100);
//             recResponseLog.Status := 'Failure';
//             recResponseLog."Called API" := 'Cancel E-Way Bill';
//             recResponseLog.INSERT;

//             recEwayBill.RESET();
//             recEwayBill.SETRANGE("No.", DocNo);
//             IF recEwayBill.FIND('-') THEN
//                 recEwayBill."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             recEwayBill.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforCancelBillNoSalesReturn(DocNo: Code[30]; EwayBillNo: Text; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//         recEwayBill: Record "50000";
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         recEwayBill.RESET();
//         recEwayBill.SETRANGE("No.", DocNo);
//         IF recEwayBill.FIND('-') THEN BEGIN

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', recEwayBill."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('eway_bill_number', recEwayBill."E-Way Bill No.", JSONTextWriter);
//             CreateJsonAttribute('reason_of_cancel', FORMAT(recEwayBill."Reason Code for Cancel"), JSONTextWriter);
//             CreateJsonAttribute('cancel_remark', FORMAT(recEwayBill."Reason for Cancel Remarks"), JSONTextWriter);
//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

//         END;
//     end;


//     procedure InitializeCalculateDistanceTransferShipment(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         frompincode := '';
//         topincode := '';
//         EwayBill.RESET();
//         EwayBill.SETRANGE("No.", DocNo);
//         IF EwayBill.FIND('-') THEN BEGIN
//             frompincode := FORMAT(EwayBill."Sell-to Post Code");
//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, EwayBill."Location Code");
//             IF RecLoc.FIND('-') THEN
//                 topincode := FORMAT(RecLoc."Post Code");
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
//             MESSAGE('Return Value of Calculate Distance for E-Way Bill for Transfer Shipment : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
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

//                     EwayBill.RESET();
//                     EwayBill.SETRANGE("No.", DocNo);
//                     IF EwayBill.FIND('-') THEN BEGIN
//                         EVALUATE(EwayBill."Distance (Km)", GetCalculatedDistance);
//                         EwayBill.MODIFY;
//                     END;

//                     MESSAGE('Dictance (KM) has been Calculated Successfully');

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := Status + ' ' + Code;
//             EwayBill.MODIFY
//         END
//         ELSE BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             EwayBill.MODIFY;
//         END;
//     end;


//     procedure InitializeEwayBillGenerateTransferShipment(DocNo: Code[30])
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Alert: Text;
//         Error: Text;
//         Status: Text;
//         "Code": Text;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         Url := 'https://pro.mastersindia.co/ewayBillsGenerate';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforEwayBillGenerateTransferShipment(DocNo, ReceiveTokenNo)); //Use WriteText function instead of write
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         MESSAGE('Generate E-Way Bill for Transfer Shipment : %1', JsonAsText);


//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Generate E-Way Bill for Transfer Shipment : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetGenerateBillNo := (JObject.GetValue('ewayBillNo').ToString);
//                     //MESSAGE('E-Way Bill No. : ' + JObject.GetValue('ewayBillNo').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetGenerateBillDate := (JObject.GetValue('ewayBillDate').ToString);
//                     //MESSAGE('E-Way Bill Date : ' + JObject.GetValue('ewayBillDate').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetGenerateBillValidUpto := (JObject.GetValue('validUpto').ToString);
//                     //MESSAGE('E-Way Bill Valid Upto : ' + JObject.GetValue('validUpto').ToString);

//                     JObject := JObject.Parse(temp01);
//                     Alert := (JObject.GetValue('alert').ToString);
//                     //MESSAGE('Alert : ' + JObject.GetValue('alert').ToString);

//                     JObject := JObject.Parse(temp01);
//                     Error := (JObject.GetValue('error').ToString);
//                     //MESSAGE('Error : ' + JObject.GetValue('error').ToString);

//                     JObject := JObject.Parse(temp01);
//                     PrintURL := (JObject.GetValue('url').ToString);
//                     //MESSAGE('URL : ' + JObject.GetValue('url').ToString);

//                     EwayBill.RESET();
//                     EwayBill.SETRANGE("No.", DocNo);
//                     IF EwayBill.FIND('-') THEN BEGIN
//                         EwayBill."E-Way Bill No." := GetGenerateBillNo;
//                         EwayBill."E-Way Bill Date" := GetGenerateBillDate;
//                         EwayBill."E-Way Bill Valid Upto" := GetGenerateBillValidUpto;
//                         EwayBill."E-Way Bill Report URL" := PrintURL;
//                         //    EwayBill."E-Way Bill Report URL" := 'C:\Users\HEMANT.THAPA\Downloads\'+PrintURL;
//                         EwayBill."Vehicle Update Date" := '';
//                         EwayBill."Vehicle Valid Upto" := '';
//                         EwayBill."Cancel E-Way Bill Date" := '';
//                         EwayBill."Reason Code for Vehicle Update" := EwayBill."Reason Code for Vehicle Update"::" ";
//                         EwayBill."Reason for Vehicle Update" := '';
//                         EwayBill."Reason Code for Cancel" := EwayBill."Reason Code for Cancel"::" ";
//                         EwayBill."Reason for Cancel Remarks" := '';
//                         EwayBill."Old Vehicle No." := EwayBill."Vehicle No.";
//                         EwayBill.MODIFY;
//                     END;

//                     MESSAGE('E-Way Bill has Generated Successfully');

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := Status + ' ' + Code;
//             EwayBill.MODIFY;
//         END
//         ELSE BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             EwayBill.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforEwayBillGenerateTransferShipment(DocNo: Code[30]; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//         RecDetailedGSTLedEntry: Record "16419";
//         Value: array[50] of Text;
//         recCust: Record "18";
//         recStateforGST: Record "13762";
//         fromstateforGST: Text;
//         tostateforGST: Text;
//         recTransferShipmentLineGST: Record "5745";
//         recTransferShipmentHdr: Record "5744";
//         FromState: Text;
//         ToState: Text;
//         recLocation: Record "14";
//         RecordTransferShipmentHeader: Record "5744";
//         InvValue: Decimal;
//         recGSTLedEntry: Record "16418";
//         fromLoc: Record "14";
//         toLoc: Record "14";
//     begin
//         EwayBill.RESET();
//         EwayBill.SETRANGE("No.", DocNo);
//         IF EwayBill.FIND('-') THEN BEGIN
//             RecCompanyInfo.GET();

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
//             //RK 04Mar22 Begin
//             IF EwayBill."Customer GST Reg. No." = EwayBill."Location GST Reg. No." THEN BEGIN
//                 SubSupplyType := 'Others';
//                 DocumentType := 'Others';
//                 SubSpplyDesc := 'Stock transfer';
//             END ELSE BEGIN
//                 SubSupplyType := 'Supply';
//                 DocumentType := 'Bill of Supply';
//                 SubSpplyDesc := '';
//             END;
//             //Rk End

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', EwayBill."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('supply_type', 'Outward', JSONTextWriter);
//             CreateJsonAttribute('sub_supply_type', SubSupplyType, JSONTextWriter);
//             CreateJsonAttribute('sub_supply_description', SubSpplyDesc, JSONTextWriter); //HT
//                                                                                          //CreateJsonAttribute('document_type',  DocumentType,JSONTextWriter);
//             recEwayBillocType.RESET;
//             recEwayBillocType.SETRANGE("No.", DocNo);
//             IF recEwayBillocType.FINDFIRST THEN
//                 CreateJsonAttribute('document_type', FORMAT(recEwayBillocType."Document Type"), JSONTextWriter);//ACXVG

//             CreateJsonAttribute('document_number', EwayBill."No.", JSONTextWriter);

//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, EwayBill."Location Code");
//             IF RecLoc.FIND('-') THEN BEGIN

//                 WorkDatet := DATE2DMY(EwayBill."Posting Date", 1);
//                 IF WorkDatet < 10 THEN
//                     dattext := '0' + FORMAT(WorkDatet)
//                 ELSE
//                     dattext := FORMAT(WorkDatet);

//                 //dattext := FORMAT(DATE2DMY(EwayBill."Posting Date",1));
//                 WorkMonth := DATE2DMY(EwayBill."Posting Date", 2);
//                 IF WorkMonth < 10 THEN
//                     txtWorkmonth := FORMAT(0) + FORMAT(WorkMonth)
//                 ELSE
//                     txtWorkmonth := FORMAT(WorkMonth);

//                 //////////////////////////////////////////////////////////
//                 IF recLocation.GET(EwayBill."Transfer-to Code") THEN BEGIN
//                     ConsgineeGSTIN := recLocation."GST Registration No.";
//                     ArrAddress[1] := recLocation.Name;
//                     ArrAddress[2] := recLocation.Address;
//                     ArrAddress[3] := recLocation."Address 2";
//                     ArrAddress[4] := recLocation.City;
//                     ArrAddress[5] := recLocation."Post Code";
//                     ArrAddress[6] := recLocation."State Code";
//                 END;
//                 /////////////////ACX_SR?/////////////////////////////////



//                 WorkYear := DATE2DMY(EwayBill."Posting Date", 3);
//                 //WorkdateFinal := FORMAT(WorkDatet)+'/'+txtWorkmonth+'/'+FORMAT(WorkYear);
//                 WorkdateFinal := FORMAT(dattext) + '/' + txtWorkmonth + '/' + FORMAT(WorkYear);
//                 CreateJsonAttribute('document_date', WorkdateFinal, JSONTextWriter);

//                 CreateJsonAttribute('gstin_of_consignor', RecLoc."GST Registration No.", JSONTextWriter);
//                 CreateJsonAttribute('legal_name_of_consignor', RecCompanyInfo.Name, JSONTextWriter);
//                 CreateJsonAttribute('address1_of_consignor', RecLoc.Address, JSONTextWriter);
//                 CreateJsonAttribute('address2_of_consignor', RecLoc."Address 2", JSONTextWriter);
//                 CreateJsonAttribute('place_of_consignor', RecLoc.City, JSONTextWriter);
//                 CreateJsonAttribute('pincode_of_consignor', RecLoc."Post Code", JSONTextWriter);
//             END;

//             RecState.RESET();
//             RecState.SETRANGE(Code, RecLoc."State Code");
//             IF RecState.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('state_of_consignor', RecState.Description, JSONTextWriter);
//                 CreateJsonAttribute('actual_from_state_name', RecState.Description, JSONTextWriter);
//             END;
//             ////////////////////////////////////////ACX_SR////////////////////////////////////////////////////////////
//             // IF ConsgineeGSTIN<>'' THEN BEGIN

//             IF ConsgineeGSTIN <> '' THEN
//                 CreateJsonAttribute('gstin_of_consignee', ConsgineeGSTIN, JSONTextWriter)
//             ELSE
//                 CreateJsonAttribute('gstin_of_consignee', 'URP', JSONTextWriter);


//             CreateJsonAttribute('legal_name_of_consignee', ArrAddress[1], JSONTextWriter);
//             CreateJsonAttribute('address1_of_consignee', ArrAddress[2], JSONTextWriter);
//             CreateJsonAttribute('address2_of_consignee', ArrAddress[3], JSONTextWriter);
//             CreateJsonAttribute('place_of_consignee', ArrAddress[4], JSONTextWriter);
//             CreateJsonAttribute('pincode_of_consignee', ArrAddress[5], JSONTextWriter);
//             //   END;
//             //////////////////////////////////ACX_SR///////////////////////////////////////////////////////////////////
//             RecState.RESET();
//             RecState.SETRANGE(Code, EwayBill.State);
//             // RecState.SETRANGE(Code,ArrAddress[6]);
//             IF RecState.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('state_of_supply', RecState.Description, JSONTextWriter);
//                 CreateJsonAttribute('actual_to_state_name', RecState.Description, JSONTextWriter);
//             END;

//             //HT 01112020-
//             RecordTransferShipmentHeader.RESET();
//             RecordTransferShipmentHeader.SETRANGE("No.", EwayBill."No.");
//             IF RecordTransferShipmentHeader.FIND('-') THEN BEGIN
//                 //    CreateJsonAttribute('transaction_type',  'Regular',JSONTextWriter)
//                 CreateJsonAttribute('transaction_type', '1', JSONTextWriter)
//             END;
//             //HT 01112020+

//             CreateJsonAttribute('other_value', 0, JSONTextWriter); //HT\

//             ///////////AC_SR////////////////////

//             InvValue := 0;
//             recTransferShipmentLineGST.RESET();
//             recTransferShipmentLineGST.SETRANGE("Document No.", EwayBill."No.");
//             IF recTransferShipmentLineGST.FIND('-') THEN BEGIN
//                 REPEAT
//                     InvValue += recTransferShipmentLineGST.Amount;
//                 UNTIL recTransferShipmentLineGST.NEXT = 0;
//             END;

//             ///////AC_SR////////////////

//             // CreateJsonAttribute('total_invoice_value',InvValue,JSONTextWriter);


//             CreateJsonAttribute('total_invoice_value', EwayBill."Amount to Transfer", JSONTextWriter);

//             FromState := '';
//             ToState := '';
//             recTransferShipmentHdr.RESET();
//             recTransferShipmentHdr.SETRANGE("No.", EwayBill."No.");
//             IF recTransferShipmentHdr.FIND('-') THEN BEGIN
//                 recLocation.RESET();
//                 recLocation.SETRANGE(Code, recTransferShipmentHdr."Transfer-to Code");
//                 IF recLocation.FIND('-') THEN BEGIN
//                     ToState := recLocation."State Code";
//                 END;
//                 recLocation.RESET();
//                 recLocation.SETRANGE(Code, recTransferShipmentHdr."Transfer-from Code");
//                 IF recLocation.FIND('-') THEN BEGIN
//                     FromState := recLocation."State Code";
//                 END;
//             END;

//             TotalGSTBaseAmt := 0;
//             recTransferShipmentLine.RESET();
//             recTransferShipmentLine.SETRANGE("Document No.", EwayBill."No.");
//             recTransferShipmentLine.SETFILTER(Quantity, '<>%1', 0);
//             IF recTransferShipmentLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     TotalGSTBaseAmt += ABS(recTransferShipmentLine.Amount);
//                 UNTIL
//                   recTransferShipmentLine.NEXT = 0;
//             END;

//             CreateJsonAttribute('taxable_amount', TotalGSTBaseAmt, JSONTextWriter);

//             //HT 29102020-
//             TotalCGSTAmt := 0;
//             TotalSGSTAmt := 0;
//             TotalIGSTAmt := 0;
//             recTransferShipmentLineGST.RESET();
//             recTransferShipmentLineGST.SETRANGE("Document No.", EwayBill."No.");
//             IF recTransferShipmentLineGST.FIND('-') THEN BEGIN
//                 REPEAT

//                     IF ToState = FromState THEN BEGIN
//                         TotalCGSTAmt += recTransferShipmentLineGST."Total GST Amount" / 2;
//                         TotalSGSTAmt += recTransferShipmentLineGST."Total GST Amount" / 2;
//                     END
//                     ELSE
//                         IF ToState <> FromState THEN BEGIN
//                             TotalIGSTAmt += recTransferShipmentLineGST."Total GST Amount";
//                         END;
//                 //          TotalIGSTAmt += recTransferShipmentLineGST."Total GST Amount";//ACX-RK 280421
//                 UNTIL
//                   recTransferShipmentLineGST.NEXT = 0;
//             END;
//             //HT 29102020+
//             // CreateJsonAttribute('total_invoice_value',  InvValue,JSONTextWriter);
//             TotalCESSAmt := 0;

//             CreateJsonAttribute('cgst_amount', TotalCGSTAmt, JSONTextWriter);
//             CreateJsonAttribute('sgst_amount', TotalSGSTAmt, JSONTextWriter);
//             CreateJsonAttribute('igst_amount', TotalIGSTAmt, JSONTextWriter);
//             CreateJsonAttribute('cess_amount', TotalCESSAmt, JSONTextWriter);


//             // CreateJsonAttribute('cgst_amount',  0,JSONTextWriter);
//             // CreateJsonAttribute('sgst_amount',  0,JSONTextWriter);
//             // CreateJsonAttribute('igst_amount',  0,JSONTextWriter);
//             // CreateJsonAttribute('cess_amount',  0,JSONTextWriter);



//             CreateJsonAttribute('cess_nonadvol_value', 0, JSONTextWriter); //HT
//             IF EwayBill."Transporter Code" <> '' THEN BEGIN
//                 RecVendor.RESET();
//                 RecVendor.SETRANGE("No.", EwayBill."Transporter Code");
//                 IF RecVendor.FIND('-') THEN BEGIN
//                     CreateJsonAttribute('transporter_id', RecVendor."GST Registration No.", JSONTextWriter);
//                     CreateJsonAttribute('transporter_name', RecVendor.Name, JSONTextWriter);
//                     //    CreateJsonAttribute('transporter_id',  EwayBill."Location GST Reg. No.",JSONTextWriter);
//                     //    CreateJsonAttribute('transporter_name',  'Transporter Name XYZ',JSONTextWriter);
//                 END;
//             END ELSE BEGIN
//                 CreateJsonAttribute('transporter_id', EwayBill."Transporter GSTIN", JSONTextWriter);
//                 CreateJsonAttribute('transporter_name', recTransferShipmentHdr."Transporter Name", JSONTextWriter);
//             END;
//             CreateJsonAttribute('transporter_document_number', EwayBill."LR/RR No.", JSONTextWriter);
//             //ACX-RK Begin
//             IF EwayBill."LR/RR Date" <> 0D THEN BEGIN
//                 Date := DATE2DMY(EwayBill."LR/RR Date", 1);
//                 Month := DATE2DMY(EwayBill."LR/RR Date", 2);
//                 Year := DATE2DMY(EwayBill."LR/RR Date", 3);
//             END;
//             IF Date < 10 THEN
//                 dateLR := '0' + FORMAT(Date)
//             ELSE
//                 dateLR := FORMAT(Date);

//             IF Month < 10 THEN
//                 txtmonth := FORMAT(0) + FORMAT(Month)
//             ELSE
//                 txtmonth := FORMAT(Month);
//             transportdate := FORMAT(dateLR) + '/' + txtmonth + '/' + FORMAT(Year);
//             CreateJsonAttribute('transporter_document_date', transportdate, JSONTextWriter);
//             //CreateJsonAttribute('transporter_document_date',  WorkdateFinal,JSONTextWriter); //HT16092019 (replace error for upper line)

//             //CreateJsonAttribute('transportation_mode',  FORMAT(EwayBill."Transportation Mode"),JSONTextWriter);
//             CreateJsonAttribute('transportation_mode', FORMAT(EwayBill."Mode of Transport"), JSONTextWriter);
//             CreateJsonAttribute('transportation_distance', EwayBill."Distance (Km)", JSONTextWriter);
//             CreateJsonAttribute('vehicle_number', FORMAT(EwayBill."Vehicle No."), JSONTextWriter);
//             CreateJsonAttribute('vehicle_type', FORMAT(EwayBill."Vehicle Type"), JSONTextWriter);

//             CreateJsonAttribute('generate_status', 1, JSONTextWriter); //HT
//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT
//             CreateJsonAttribute('user_ref', '1232435466sdsf234', JSONTextWriter); //HT
//             CreateJsonAttribute('location_code', 'XYZ', JSONTextWriter); //HT
//             CreateJsonAttribute('eway_bill_status', 'AC', JSONTextWriter); //HT
//             CreateJsonAttribute('auto_print', 'Y', JSONTextWriter); //HT
//             CreateJsonAttribute('email', 'mayanksharma@mastersindia.co', JSONTextWriter); //HT

//             //Array Start-
//             JSONTextWriter.Formatting;

//             JSONTextWriter.WritePropertyName('itemList');

//             JSONTextWriter.WriteStartArray();

//             cdePrvHSN := '';
//             recTransferShipmentLine.SETCURRENTKEY("HSN/SAC Code");
//             recTransferShipmentLine.RESET();
//             recTransferShipmentLine.SETRANGE("Document No.", EwayBill."No.");
//             recTransferShipmentLine.SETCURRENTKEY("HSN/SAC Code");
//             recTransferShipmentLine.SETFILTER(Quantity, '<>%1', 0);
//             IF recTransferShipmentLine.FIND('-') THEN BEGIN
//                 REPEAT
//                     txtProdName := '';
//                     txtHSN := '';
//                     txtUOM := '';
//                     decCGSTper := 0;
//                     decSGSTper := 0;
//                     decIGSTper := 0;
//                     decCESSper := 0;
//                     decQty := 0;
//                     decGSTBaseAmt := 0;
//                     //
//                     //      IF recTransferShipmentLine."HSN/SAC Code"<> cdePrvHSN THEN BEGIN
//                     //
//                     //         recTransferShipmentLineInnerLoop.RESET();
//                     //         recTransferShipmentLineInnerLoop.SETRANGE("Document No.",recTransferShipmentLine."Document No.");
//                     //         recTransferShipmentLineInnerLoop.SETCURRENTKEY("HSN/SAC Code");
//                     //         recTransferShipmentLineInnerLoop.SETRANGE("HSN/SAC Code",recTransferShipmentLine."HSN/SAC Code");
//                     //         recTransferShipmentLineInnerLoop.SETFILTER(Quantity,'<>%1',0);
//                     //         IF recTransferShipmentLineInnerLoop.FINDFIRST THEN BEGIN
//                     //            cdePrvHSN:=recTransferShipmentLineInnerLoop."HSN/SAC Code";
//                     //           REPEAT

//                     recHSN.RESET();
//                     recHSN.SETRANGE(Code, recTransferShipmentLine."HSN/SAC Code");
//                     recHSN.SETRANGE("GST Group Code", recTransferShipmentLine."GST Group Code");
//                     IF recHSN.FIND('-') THEN BEGIN
//                         txtProdName := recHSN.Description;
//                     END;

//                     IF txtProdName = '' THEN BEGIN
//                         ERROR('HSN Description does not exist')
//                     END;

//                     txtHSN := recTransferShipmentLine."HSN/SAC Code";
//                     txtUOM := recTransferShipmentLine."Unit of Measure Code";

//                     recTransferShipmentLineGST.RESET();
//                     recTransferShipmentLineGST.SETRANGE("Document No.", recTransferShipmentLine."Document No.");
//                     recTransferShipmentLineGST.SETRANGE("HSN/SAC Code", recTransferShipmentLine."HSN/SAC Code");
//                     recTransferShipmentLineGST.SETRANGE("Line No.", recTransferShipmentLine."Line No.");
//                     IF recTransferShipmentLineGST.FIND('-') THEN BEGIN
//                         IF ToState = FromState THEN BEGIN
//                             decCGSTper := recTransferShipmentLineGST."GST %" / 2;
//                             decSGSTper := recTransferShipmentLineGST."GST %" / 2;
//                         END
//                         ELSE
//                             IF ToState <> FromState THEN BEGIN
//                                 decIGSTper := recTransferShipmentLineGST."GST %";
//                             END;
//                         //                    decIGSTper := recTransferShipmentLineGST."GST %";
//                     END;

//                     //                 IF recTransferShipmentLineGST."GST Value"=0 THEN BEGIN//ACX-RK 280421
//                     IF recTransferShipmentLineGST."Total GST Amount" = 0 THEN BEGIN//ACX-RK 280421
//                         decCGSTper := 0;
//                         decIGSTper := 0;
//                         decSGSTper := 0;
//                     END;

//                     IF recTransferShipmentLine.Description <> '' THEN
//                         txtProdName := recTransferShipmentLine.Description;

//                     decQty := recTransferShipmentLine.Quantity;
//                     decGSTBaseAmt := recTransferShipmentLine.Amount;

//                     //   UNTIL recTransferShipmentLineInnerLoop.NEXT=0;
//                     //   END;

//                     //ACX-RK 100521 Begin
//                     decCGSTper := ROUND(decCGSTper, 1);
//                     decSGSTper := ROUND(decSGSTper, 1);
//                     decIGSTper := ROUND(decIGSTper, 1);
//                     //ACX-RK End
//                     // /////AC_SR///
//                     // decCGSTper:=0;
//                     // decIGSTper:=0;
//                     // decSGSTper:=0;
//                     // ////AC_SR////
//                     JSONTextWriter.WriteStartObject();

//                     JSONTextWriter.WritePropertyName('product_name');
//                     JSONTextWriter.WriteValue(txtProdName);

//                     JSONTextWriter.WritePropertyName('product_description');
//                     JSONTextWriter.WriteValue('');

//                     JSONTextWriter.WritePropertyName('hsn_code');
//                     JSONTextWriter.WriteValue(txtHSN);

//                     JSONTextWriter.WritePropertyName('unit_of_product');
//                     JSONTextWriter.WriteValue(txtUOM);

//                     JSONTextWriter.WritePropertyName('cgst_rate');
//                     JSONTextWriter.WriteValue(decCGSTper);

//                     JSONTextWriter.WritePropertyName('sgst_rate');
//                     JSONTextWriter.WriteValue(decSGSTper);

//                     JSONTextWriter.WritePropertyName('igst_rate');
//                     JSONTextWriter.WriteValue(decIGSTper);

//                     JSONTextWriter.WritePropertyName('cess_rate');
//                     JSONTextWriter.WriteValue(decCESSper);

//                     JSONTextWriter.WritePropertyName('quantity');
//                     JSONTextWriter.WriteValue(decQty);

//                     JSONTextWriter.WritePropertyName('cessNonAdvol'); //HT
//                     JSONTextWriter.WriteValue('0');

//                     JSONTextWriter.WritePropertyName('taxable_amount');
//                     JSONTextWriter.WriteValue(decGSTBaseAmt);

//                     JSONTextWriter.WriteEndObject;
//                 //END;
//                 UNTIL
//                 recTransferShipmentLine.NEXT = 0;
//             END;

//             JSONTextWriter.WriteEndArray();
//             //Array Start+

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

//         END;
//     end;


//     procedure InitializeUpdateVehicleNoTransferShipment(DocNo: Code[30]; VehicleNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         Url := 'https://pro.mastersindia.co/updateVehicleNumber';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforUpdateVehicleNoTransferShipment(DocNo, VehicleNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         //MESSAGE('Update Vehicle No. for Transfer Shipment : %1',JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Update Vehicle No. for Transfer Shipment : ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetUpdateVehicleDate := (JObject.GetValue('vehUpdDate').ToString);
//                     //MESSAGE('Vehicle Update Date : ' + JObject.GetValue('vehUpdDate').ToString);

//                     JObject := JObject.Parse(temp01);
//                     GetUpdateVehicleValidUptoDate := (JObject.GetValue('validUpto').ToString);
//                     //MESSAGE('Vehicle Valid Upto : ' + JObject.GetValue('validUpto').ToString);

//                     EwayBill.RESET();
//                     EwayBill.SETRANGE("No.", DocNo);
//                     IF EwayBill.FIND('-') THEN BEGIN
//                         EwayBill."Vehicle Update Date" := FORMAT(GetUpdateVehicleDate);
//                         EwayBill."Vehicle Valid Upto" := FORMAT(GetUpdateVehicleValidUptoDate);
//                         EwayBill."Old Vehicle No." := EwayBill."Vehicle No.";
//                         EwayBill.MODIFY;
//                     END;

//                     MESSAGE('Vehicle No. has been Updated Successfully');

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := Status + ' ' + Code;
//             EwayBill.MODIFY
//         END
//         ELSE BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             EwayBill.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforUpdateVehicleNoTransferShipment(DocNo: Code[30]; VehicleNo: Text; ReceiveTokenNo: Text): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//     begin
//         EwayBill.RESET();
//         EwayBill.SETRANGE("No.", DocNo);
//         EwayBill.SETRANGE("Vehicle No.", VehicleNo);
//         IF EwayBill.FIND('-') THEN BEGIN

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', EwayBill."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('eway_bill_number', EwayBill."E-Way Bill No.", JSONTextWriter);
//             CreateJsonAttribute('vehicle_number', EwayBill."Vehicle No.", JSONTextWriter);
//             CreateJsonAttribute('vehicle_type', FORMAT(EwayBill."Vehicle Type"), JSONTextWriter);

//             RecLoc.RESET();
//             RecLoc.SETRANGE(Code, EwayBill."Location Code");
//             IF RecLoc.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('place_of_consignor', RecLoc.City, JSONTextWriter);
//             END;

//             RecState.RESET();
//             RecState.SETRANGE(Code, EwayBill."Location State Code");
//             IF RecState.FIND('-') THEN BEGIN
//                 CreateJsonAttribute('state_of_consignor', RecState.Description, JSONTextWriter);
//             END;

//             CreateJsonAttribute('reason_code_for_vehicle_updation', FORMAT(EwayBill."Reason Code for Vehicle Update"), JSONTextWriter); //HT
//             CreateJsonAttribute('reason_for_vehicle_updation', FORMAT(EwayBill."Reason for Vehicle Update"), JSONTextWriter); //HT

//             CreateJsonAttribute('transporter_document_number', EwayBill."LR/RR No.", JSONTextWriter);
//             IF EwayBill."LR/RR Date" <> 0D THEN BEGIN
//                 Date := DATE2DMY(EwayBill."LR/RR Date", 1);
//                 Month := DATE2DMY(EwayBill."LR/RR Date", 2);
//                 Year := DATE2DMY(EwayBill."LR/RR Date", 3);
//             END;
//             IF Date < 10 THEN
//                 dateTS := '0' + FORMAT(Date)
//             ELSE
//                 dateTS := FORMAT(Date);


//             IF Month < 10 THEN
//                 txtmonth := FORMAT(0) + FORMAT(Month)
//             ELSE
//                 txtmonth := FORMAT(Month);


//             transportdate := FORMAT(dateTS) + '/' + txtmonth + '/' + FORMAT(Year);
//             CreateJsonAttribute('transporter_document_date', transportdate, JSONTextWriter);


//             CreateJsonAttribute('mode_of_transport', FORMAT(EwayBill."Transportation Mode"), JSONTextWriter);

//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

//         END;
//     end;


//     procedure InitializeCancelBillNoTransferShipment(DocNo: Code[30]; EwayBillNo: Text)
//     var
//         Url: Text;
//         ApiResult: Text;
//         HttpWebRequestMgt: Codeunit "1297";
//         TempBlob: Record "99008535";
//         Instr: InStream;
//         [RunOnClient]
//         HttpStatusCode: DotNet HttpStatusCode;
//         [RunOnClient]
//         ResponseHeaders: DotNet NameValueCollection;
//         [RunOnClient]
//         streamWritter: DotNet StreamWriter;
//         [RunOnClient]
//         XMLHttpRequest: DotNet HttpWebRequest;
//         temp: Text;
//         TempBlob2: Record "99008535";
//         ReqBodyOutStream: OutStream;
//         ReqBodyInStream: InStream;
//         [RunOnClient]
//         JObject: DotNet JObject;
//         [RunOnClient]
//         XMLDoc: DotNet XmlDocument;
//         Token: Label 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJnc3AiXSwiZXhwIjoxNTY2ODEzMzUwLCJhdXRob3JpdGllcyI6WyJST0xFX1NCX0VfQVBJX0dTVF9SRVRVUk5TIiwiUk9MRV9TQl9FX0FQSV9FV0IiXSwianRpIjoiYjlhNDUxZWEtNzZkOC00N2U3LTg2ZDktNzJhMTk2MjM2MmNhIiwiY2xpZW50X2lkIjoiRTRCMTcyNDMzNkE5NDI5Q0ExQjM4M0ZEODAzMjBCOEYifQ.1BGkFnecJeY0aaQveGdadj9zU5iRe4qaMJ81HKzKOh8';
//         JsonAsText: Text;
//         JsonBillGenerate: Text;
//         temp01: Text;
//         temp02: Text;
//         ReceiveTokenNo: Text[500];
//         Status: Text;
//         "Code": Text;
//     begin
//         SecurityProtocol := SecurityProtocol.SecurityProtocol(SecurityProtocol.SecurityProtocol.Tls12);

//         Url := 'https://pro.mastersindia.co/ewayBillCancel';

//         TempBlob2.INIT;
//         TempBlob2.Blob.CREATEOUTSTREAM(ReqBodyOutStream, TEXTENCODING::UTF8);
//         ReqBodyOutStream.WRITETEXT(CreateJsonforCancelBillNoTransferShipment(DocNo, EwayBillNo, ReceiveTokenNo));
//         TempBlob2.Blob.CREATEINSTREAM(ReqBodyInStream);

//         HttpWebRequestMgt.Initialize(Url);
//         HttpWebRequestMgt.DisableUI;
//         HttpWebRequestMgt.SetMethod('POST');
//         HttpWebRequestMgt.SetContentType('application/json');
//         HttpWebRequestMgt.SetReturnType('application/json');

//         JsonAsText := TempBlob2.ReadAsText('', TEXTENCODING::UTF8);
//         //MESSAGE('Cancel E-Way Bill No. for Transfer Shipment : %1',JsonAsText);

//         HttpWebRequestMgt.AddBodyBlob(TempBlob2);

//         TempBlob.INIT;
//         TempBlob.Blob.CREATEINSTREAM(Instr);
//         IF HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeaders) THEN BEGIN
//             MESSAGE('Return Value of Cancel E-Way Bill No. for Transfer Shipment: ' + FORMAT(TempBlob.ReadAsText('', TEXTENCODING::UTF8)));
//             IF HttpStatusCode.ToString = HttpStatusCode.OK.ToString THEN BEGIN
//                 ApiResult := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
//                 JObject := JObject.JObject;
//                 JObject := JObject.Parse(ApiResult);
//                 temp := JObject.GetValue('results').ToString;
//                 //MESSAGE(JObject.GetValue('results').ToString);

//                 JObject := JObject.Parse(temp);
//                 temp01 := JObject.GetValue('message').ToString;
//                 //MESSAGE := (JObject.GetValue('message').ToString);

//                 JObject := JObject.Parse(temp);
//                 Status := (JObject.GetValue('status').ToString);
//                 //MESSAGE('Status : ' + JObject.GetValue('status').ToString);

//                 JObject := JObject.Parse(temp);
//                 Code := (JObject.GetValue('code').ToString);
//                 //MESSAGE('Code : ' + JObject.GetValue('code').ToString);

//                 IF Code = FORMAT(200) THEN BEGIN

//                     JObject := JObject.Parse(temp01);
//                     GetCancelBillDate := (JObject.GetValue('cancelDate').ToString);
//                     //MESSAGE('Cancel E-Way Bill Date : ' + JObject.GetValue('cancelDate').ToString);

//                     EwayBill.RESET();
//                     EwayBill.SETRANGE("No.", DocNo);
//                     EwayBill.SETRANGE("E-Way Bill No.", EwayBillNo);
//                     IF EwayBill.FIND('-') THEN BEGIN
//                         EwayBill."Cancel E-Way Bill Date" := FORMAT(GetCancelBillDate);
//                         EwayBill."Old Vehicle No." := '';
//                         EwayBill.MODIFY;
//                     END;

//                     MESSAGE('E-Way Bill has been Cancelled Successfully');

//                 END;

//             END ELSE
//                 MESSAGE('status code not ok');
//         END ELSE
//             MESSAGE('no response from api');

//         IF Code = FORMAT(200) THEN BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := Status + ' ' + Code;
//             //      EwayBill."E-Way Bill Report URL" := '';
//             EwayBill.MODIFY;
//         END
//         ELSE BEGIN
//             EwayBill.RESET();
//             EwayBill.SETRANGE("No.", DocNo);
//             IF EwayBill.FIND('-') THEN
//                 EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + Code;
//             EwayBill.MODIFY;
//         END;
//     end;


//     procedure CreateJsonforCancelBillNoTransferShipment(DocNo: Code[30]; EwayBillNo: Text; ReceiveTokenNo: Text[500]): Text
//     var
//         StringBuilder: DotNet StringBuilder;
//         StringWriter: DotNet StringWriter;
//         JSON: DotNet String;
//     begin
//         ReceiveTokenNo := '';
//         ReceiveTokenNo := InitializeAccessToken(DocNo);

//         EwayBill.RESET();
//         EwayBill.SETRANGE("No.", DocNo);
//         IF EwayBill.FIND('-') THEN BEGIN

//             StringBuilder := StringBuilder.StringBuilder;
//             StringWriter := StringWriter.StringWriter(StringBuilder);
//             JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);

//             JSONTextWriter.WriteStartObject;

//             CreateJsonAttribute('access_token', ReceiveTokenNo, JSONTextWriter);
//             CreateJsonAttribute('userGstin', EwayBill."Location GST Reg. No.", JSONTextWriter);
//             CreateJsonAttribute('eway_bill_number', EwayBill."E-Way Bill No.", JSONTextWriter);
//             CreateJsonAttribute('reason_of_cancel', FORMAT(EwayBill."Reason Code for Cancel"), JSONTextWriter);
//             CreateJsonAttribute('cancel_remark', FORMAT(EwayBill."Reason for Cancel Remarks"), JSONTextWriter);
//             CreateJsonAttribute('data_source', 'erp', JSONTextWriter); //HT

//             JSONTextWriter.WriteEndObject;

//             EXIT(StringBuilder.ToString);

//         END;
//     end;

//     trigger JSONArray::ListChanged(sender: Variant; e: DotNet ListChangedEventArgs)
//     begin
//     end;

//     trigger JSONArray::AddingNew(sender: Variant; e: DotNet AddingNewEventArgs)
//     begin
//     end;

//     trigger JSONArray::CollectionChanged(sender: Variant; e: DotNet NotifyCollectionChangedEventArgs)
//     begin
//     end;
}

