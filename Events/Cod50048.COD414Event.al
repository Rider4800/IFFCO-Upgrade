codeunit 50048 COD414Event
{
    [EventSubscriber(ObjectType::Codeunit, 414, 'OnCodeOnBeforeSetStatusReleased', '', false, false)]
    local procedure OnCodeOnBeforeSetStatusReleased(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TESTFIELD("Salesperson Code");
    end;
}
