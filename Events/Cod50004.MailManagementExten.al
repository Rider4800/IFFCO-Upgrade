codeunit 50004 MailManagementExten
{
    procedure SendMailOrDownloadAcxiom(TempEmailItem: Record "Email Item" temporary; HideMailDialog: Boolean; DocNo: Text)
    var
        ReturnParameter: Boolean;
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        MailManagement.InitializeFrom(HideMailDialog, TRUE);
        IF MailManagement.IsEnabled THEN BEGIN
            if MailManagement.Send(TempEmailItem, EmailScenario::Default) THEN BEGIN
                SalesInvHdr.RESET;
                SalesInvHdr.SETRANGE("No.", DocNo);
                IF SalesInvHdr.FINDFIRST THEN BEGIN
                    SalesInvHdr."E-Mail Sent" := TRUE;
                    SalesInvHdr.MODIFY;
                    COMMIT;
                END;
                EXIT;
            END;
        END;

        IF NOT CONFIRM(CannotSendMailThenDownloadQst) THEN
            EXIT;

        MailManagement.DownloadPdfAttachment(TempEmailItem);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    var
        MailManagement: Codeunit "Mail Management";
        SalesInvHdr: Record "Sales Invoice Header";
        EmailScenario: Enum "Email Scenario";
        CannotSendMailThenDownloadQst: Label 'You cannot send the e-mail.\\Verify that the SMTP settings are correct.\\Do you want to download the attachment?';
}
