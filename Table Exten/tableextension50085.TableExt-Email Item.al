tableextension 50085 tableextension50085 extends "Email Item"
{
    local procedure "//------------------------------------"()
    begin
    end;

    procedure SendAcxiom(HideMailDialog: Boolean; DocNo: Text)
    var
        MailManagement: Codeunit 9520;
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        //12887 need to handle this code MailManagement.SendMailOrDownloadAcxiom(Rec, HideMailDialog, DocNo);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;
}

