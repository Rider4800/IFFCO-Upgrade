codeunit 50051 COD226Event
{
    [EventSubscriber(ObjectType::Codeunit, 226, 'OnBeforePostUnApplyCustomerCommit', '', false, false)]
    local procedure OnBeforePostUnApplyCustomerCommit(DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry")
    begin
        MESSAGE(FORMAT(DetailedCustLedgEntry2."Cust. Ledger Entry No."));//
    end;
}
