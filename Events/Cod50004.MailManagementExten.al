codeunit 50004 MailManagementExten
{
    procedure SendMailOrDownloadAcxiom(TempEmailItem: Record "Email Item" temporary; HideMailDialog: Boolean; DocNo: Text)
    var
        ReturnParameter: Boolean;
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        MailManagement.InitializeFrom(HideMailDialog, TRUE);
        IF MailManagement.IsEnabled THEN BEGIN
            if SendAcxiom(TempEmailItem, DocNo) THEN BEGIN
                EXIT;
            END;
        END;

        IF NOT CONFIRM(CannotSendMailThenDownloadQst) THEN
            EXIT;

        MailManagement.DownloadPdfAttachment(TempEmailItem);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    procedure SendAcxiom(ParmEmailItem: Record "Email Item"; DocNo: Text): Boolean
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        TempEmailItem := ParmEmailItem;
        QualifyFromAddress;
        MailSent := FALSE;
        EXIT(DoSendAcxiom(DocNo));

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+

    end;

    local procedure DoSendAcxiom(DocNo: Text): Boolean
    var
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        Cancelled := TRUE;
        IF NOT HideMailDialog THEN BEGIN
            IF RunMailDialog THEN BEGIN
                Cancelled := FALSE;
                SalesInvHdr.RESET;
                SalesInvHdr.SETRANGE("No.", DocNo);
                IF SalesInvHdr.FINDFIRST THEN BEGIN
                    SalesInvHdr."E-Mail Sent" := TRUE;
                    SalesInvHdr.MODIFY;
                    COMMIT;
                END;
            END
            ELSE BEGIN
                EXIT(TRUE);
            END;

            IF OutlookSupported THEN
                IF DoEdit THEN BEGIN
                    IF SendMailOnWinClient THEN
                        EXIT(TRUE);
                    OutlookSupported := FALSE;
                    IF NOT SMTPSupported THEN
                        EXIT(FALSE);
                    IF CONFIRM(OutlookNotAvailableContinueEditQst) THEN
                        EXIT(DoSend);
                END
        END;
        IF SMTPSupported THEN
            EXIT(SendViaSMTP);

        EXIT(FALSE);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+

    end;

    var
        MailManagement: Codeunit "Mail Management";
        CannotSendMailThenDownloadQst: Label 'You cannot send the e-mail.\\Verify that the SMTP settings are correct.\\Do you want to download the attachment?';
}
