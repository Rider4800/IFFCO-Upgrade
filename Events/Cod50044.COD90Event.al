codeunit 50044 COD90Event
{

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnAfterSetApplyToDocNo', '', false, false)]
    local procedure OnAfterSetApplyToDocNo(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        recdim: Record "Dimension Value";
        recpaymentmethod: Record "Payment Method";
    begin
        if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Refund then begin
            PurchaseHeader.TestField("Shortcut Dimension 1 Code");
            IF PurchaseHeader."Branch Accounting" = TRUE THEN BEGIN
                PurchaseHeader.TestField("Finance Branch A/c Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PurchaseHeader."Finance Branch A/c Code");
            END
            ELSE
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PurchaseHeader."Shortcut Dimension 1 Code");
            //HT  24022021+
            recdim.RESET();
            recdim.SETRANGE("Dimension Code", 'STATE');
            recdim.SETRANGE(Code, recpaymentmethod."Payment Method Branch");
            IF recdim.FINDFIRST THEN
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", recdim."STATE-FIN");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Finance Branch A/c Code" := PurchaseHeader."Finance Branch A/c Code";//ACX-anu
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

    [EventSubscriber(ObjectType::Page, 6510, 'OnBeforeLotNoAssistEdit', '', false, false)]
    local procedure OnBeforeLotNoAssistEdit(var TrackingSpecification: Record "Tracking Specification"; xTrackingSpecification: Record "Tracking Specification"; CurrentSignFactor: Integer; var MaxQuantity: Decimal; UndefinedQtyArray: array[3] of Decimal; var IsHandled: Boolean; ForBinCode: Code[20]; Inbound: Boolean; CurrentRunMode: Enum "Item Tracking Run Mode"; ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection"; CurrentSourceType: Integer; SourceQuantityArray: array[5] of Decimal; InsertIsBlocked: Boolean)
    begin
        //KM010721
        IF TrackingSpecification."Source Type" = 37 THEN BEGIN
            IF TrackingSpecification."Lot No." <> '' THEN
                ERROR('Multi lot selection not allowed against same sales line');
        END;
        //KM010721
    end;

}
