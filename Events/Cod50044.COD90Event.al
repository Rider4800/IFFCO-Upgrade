codeunit 50044 COD90Event
{

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header")
    begin
        GenJnlLine."Finance Branch A/c Code" := PurchHeader."Finance Branch A/c Code";//ACX-anu
    end;

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostBalancingEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostBalancingEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header")
    var
        recdim: Record "Dimension Value";
        recpaymentmethod: Record "Payment Method";
    begin
        PurchHeader.TESTFIELD("Shortcut Dimension 1 Code");
        IF PurchHeader."Branch Accounting" = TRUE THEN BEGIN
            PurchHeader.TESTFIELD("Finance Branch A/c Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", PurchHeader."Finance Branch A/c Code");
        END
        ELSE
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 1 Code");
        //HT  24022021+
        recdim.RESET();
        recdim.SETRANGE("Dimension Code", 'STATE');
        recdim.SETRANGE(Code, recpaymentmethod."Payment Method Branch");
        IF recdim.FINDFIRST THEN
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", recdim."STATE-FIN");
    END;//Acx_Anubha

}
