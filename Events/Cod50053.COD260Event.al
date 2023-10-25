codeunit 50053 COD260Event
{
    [EventSubscriber(ObjectType::Codeunit, 260, 'OnBeforeSendEmail', '', false, false)]
    local procedure OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var PostedDocNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        recCustomer: Record Customer;
        GLsetup: Record "General Ledger Setup";
    begin
        GLsetup.GET;
        SalesInvHdr.RESET;
        SalesInvHdr.SETRANGE("No.", PostedDocNo);
        IF SalesInvHdr.FINDFIRST THEN BEGIN
            recCustomer.RESET;
            recCustomer.SETRANGE("No.", SalesInvHdr."Sell-to Customer No.");
            IF recCustomer.FINDFIRST THEN BEGIN
                TempEmailItem."Send to" := recCustomer."E-Mail";
                TempEmailItem."Send CC" := GLsetup."E-Mail CC";
            END
            ELSE BEGIN
                TempEmailItem."Send to" := '';
                TempEmailItem."Send CC" := '';
                TempEmailItem."Send BCC" := '';
                CLEAR(TempEmailItem.Body);
            END;
        END;

    end;
}
