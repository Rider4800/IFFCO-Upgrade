codeunit 50044 COD90Event
{

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header")
    begin
        GenJnlLine."Finance Branch A/c Code" := PurchHeader."Finance Branch A/c Code";//ACX-anu
    end;
}
