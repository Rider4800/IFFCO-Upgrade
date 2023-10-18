codeunit 50037 CustomerTabEvent
{
    [EventSubscriber(ObjectType::Page, Page::"Check Credit Limit", 'OnCalcOverdueBalanceLCYAfterSetFilter', '', false, false)]
    local procedure OnCalcOverdueBalanceLCYAfterSetFilter(var Customer: Record Customer)
    begin
        Customer.SETFILTER("Date Filter", '..%1', (WORKDATE + 1));
    end;
}