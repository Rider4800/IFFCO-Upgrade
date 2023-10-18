codeunit 50010 ReportDistributionMgmtExt
{
    trigger OnRun()
    begin

    end;

    procedure SendDocumentReportAcxiom(VAR TempDocumentSendingProfile: Record "Document Sending Profile" temporary; PostedDocumentVariant: Variant)
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        IF TempDocumentSendingProfile."Electronic Document" <> TempDocumentSendingProfile."Electronic Document"::No THEN
            VANDocumentReport(PostedDocumentVariant, TempDocumentSendingProfile);

        IF TempDocumentSendingProfile.Printer <> TempDocumentSendingProfile.Printer::No THEN BEGIN
            HideDialog := TempDocumentSendingProfile.Printer = TempDocumentSendingProfile.Printer::"Yes (Use Default Settings)";
            PrintDocumentReport(PostedDocumentVariant);
        END;

        IF TempDocumentSendingProfile."E-Mail" <> TempDocumentSendingProfile."E-Mail"::No THEN BEGIN
            HideDialog := TempDocumentSendingProfile."E-Mail" = TempDocumentSendingProfile."E-Mail"::"Yes (Use Default Settings)";
            EmailDocumentReportWithElectronicOptionAcxiom(PostedDocumentVariant, TempDocumentSendingProfile);
        END;

        IF TempDocumentSendingProfile.Disk <> TempDocumentSendingProfile.Disk::No THEN
            SaveDocumentReport(PostedDocumentVariant, TempDocumentSendingProfile);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure EmailDocumentReportWithElectronicOptionAcxiom(HeaderDoc: Variant; TempDocumentSendingProfile: Record "Document Sending Profile" temporary)
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        IF TempDocumentSendingProfile."E-Mail Attachment" = TempDocumentSendingProfile."E-Mail Attachment"::PDF THEN
            HandleDocumentReportAcxiom(HeaderDoc, DocumentSendingProfile."Send To"::"E-Mail");

        IF TempDocumentSendingProfile."E-Mail Attachment" = TempDocumentSendingProfile."E-Mail Attachment"::"Electronic Document" THEN
            SendXmlEmailAttachment(HeaderDoc, TempDocumentSendingProfile."E-Mail Format");

        IF TempDocumentSendingProfile."E-Mail Attachment" = TempDocumentSendingProfile."E-Mail Attachment"::"PDF & Electronic Document"
        THEN
            SendZipFile(HeaderDoc, TempDocumentSendingProfile."E-Mail Format", TempDocumentSendingProfile."Send To"::Email);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure HandleDocumentReportAcxiom(HeaderDoc: Variant; SendTo: Option)
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        CustomReportID :=
          CustomReportSelection.PrintCustomReports(HeaderDoc, NOT (SendTo = DocumentSendingProfile."Send To"::Print), NOT HideDialog);

        IF CustomReportID = 0 THEN BEGIN
            CreateDocumentReport(HeaderDoc, ReportSelections);
            IF ReportSelections.FINDSET THEN
                REPEAT
                    SendReportAcxiom(HeaderDoc, ReportSelections."Report ID", SendTo, CustomReportSelection);
                UNTIL ReportSelections.NEXT = 0;
        END;

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure SendReportAcxiom(HeaderDoc: Variant; ReportID: Integer; SendTo: Option; VAR CustomReportSelection: Record "Custom Report Selection")
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        IF SendTo = DocumentSendingProfile."Send To"::Print THEN BEGIN
            IF CustomReportLayout.GET(CustomReportSelection."Custom Report Layout ID") THEN BEGIN
                ReportLayoutSelection.SetTempLayoutSelected(CustomReportLayout.ID);
                REPORT.RUNMODAL(CustomReportSelection."Report ID", NOT HideDialog, FALSE, HeaderDoc);
                ReportLayoutSelection.SetTempLayoutSelected(0);
            END ELSE
                REPORT.RUNMODAL(ReportID, NOT HideDialog, FALSE, HeaderDoc)
        END ELSE BEGIN
            RecRef.GETTABLE(HeaderDoc);
            IF RecRef.FINDSET THEN BEGIN
                IF (NOT HideDialog) AND (RecRef.COUNT > 1) THEN
                    IF CONFIRM(SuppresSendDialogQst) THEN
                        HideDialog := TRUE;
                REPEAT
                    EmailDocumentAcxiom(HeaderDoc, RecRef.RECORDID, ReportID, SendTo, CustomReportSelection);
                UNTIL RecRef.NEXT = 0;
            END;
        END;

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure EmailDocumentAcxiom(SourceRec: Variant; RecID: RecordID; ReportID: Integer; SendTo: Option; VAR CustomReportSelection: Record "Custom Report Selection")
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        HeaderDoc := SourceRec; // to initialize Variant
        RecRef.GET(RecID);
        RecRef.SETRECFILTER;
        RecRef.SETTABLE(HeaderDoc);
        DocumentType := GetDocumentType(HeaderDoc);
        SalesDocumentNo := ElectronicDocumentFormat.GetDocumentNo(HeaderDoc);
        GetBillToCustomer(Customer, HeaderDoc);
        ServerAttachmentFilePath := GenerateReport(HeaderDoc, ReportID, CustomReportSelection);
        AttachmentFileName := ElectronicDocumentFormat.GetAttachmentFileName(SalesDocumentNo, DocumentType, 'pdf');
        SendAttachmentAcxiom(
          SalesDocumentNo, Customer."No.", ServerAttachmentFilePath, AttachmentFileName, DocumentType, SendTo, CustomReportSelection);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure SendAttachmentAcxiom(PostedDocumentNo: Code[20]; SendEmaillToCustNo: Code[20]; AttachmentFilePath: Text[250]; AttachmentFileName: Text[250]; DocumentType: Text[50]; SendTo: Option; CustomReportSelection: Record "Custom Report Selection")
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        IF SendTo = DocumentSendingProfile."Send To"::Disk THEN BEGIN
            SaveFileOnClient(AttachmentFilePath, AttachmentFileName);
            EXIT;
        END;

        DocumentMailing.EmailFileAcxiom(
          AttachmentFilePath, AttachmentFileName, PostedDocumentNo, SendEmaillToCustNo, DocumentType, HideDialog, CustomReportSelection);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure VANDocumentReport(HeaderDoc: Variant; TempDocumentSendingProfile: Record "Document Sending Profile" temporary)
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        RecordExportBuffer: Record "Record Export Buffer";
        DocExchServiceMgt: Codeunit "Doc. Exch. Service Mgt.";
        TempBlob: Codeunit "Temp Blob";
        RecordRef: RecordRef;
        SpecificRecordRef: RecordRef;
        ClientFileName: Text[250];
    begin
        RecordRef.GetTable(HeaderDoc);
        if RecordRef.FindSet() then
            repeat
                SpecificRecordRef.Get(RecordRef.RecordId);
                SpecificRecordRef.SetRecFilter();
                ElectronicDocumentFormat.SendElectronically(
                    TempBlob, ClientFileName, SpecificRecordRef, TempDocumentSendingProfile."Electronic Format");
                if ElectronicDocumentFormat."Delivery Codeunit ID" = 0 then
                    DocExchServiceMgt.SendDocument(SpecificRecordRef, TempBlob)
                else begin
                    RecordExportBuffer.RecordID := SpecificRecordRef.RecordId;
                    RecordExportBuffer.ClientFileName := ClientFileName;
                    RecordExportBuffer.SetFileContent(TempBlob);
                    RecordExportBuffer."Electronic Document Format" := TempDocumentSendingProfile."Electronic Format";
                    RecordExportBuffer."Document Sending Profile" := TempDocumentSendingProfile.Code;
                    CODEUNIT.Run(ElectronicDocumentFormat."Delivery Codeunit ID", RecordExportBuffer);
                end;
            until RecordRef.Next() = 0;
    end;
}