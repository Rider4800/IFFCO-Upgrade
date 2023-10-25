codeunit 50050 ReleaseTransferDocument
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Transfer Release", 'OnAfterReopen', '', false, false)]
    local procedure OnAfterReopen(var TransferHeader: Record "Transfer Header")
    begin
        TransferHeader.Validate(ExpiryStockMovementAllowed, false);
    end;
}