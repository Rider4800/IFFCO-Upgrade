codeunit 50042 COD22Event
{
    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."Warranty Date" := ItemJournalLine."Warranty Date";
        NewItemLedgEntry."Expiration Date" := ItemJournalLine."Item Expiration Date";
        NewItemLedgEntry.Narration := ItemJournalLine.Narration; //ACXCP_180921 //Capture Narration
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeCheckPostingDateWithExpirationDate', '', false, false)]
    local procedure OnBeforeCheckPostingDateWithExpirationDate(var IsHandled: Boolean; ItemTrackingCode: Record "Item Tracking Code"; OldItemLedgEntry: Record "Item Ledger Entry"; var ItemJnlLine: Record "Item Journal Line"; var ItemLedgEntry: Record "Item Ledger Entry")
    var
        RecTransferorder: Record "Transfer Header";
        Text017: Label ' is before the posting date.';
    begin
        IsHandled := true;
        if ItemTrackingCode."Strict Expiration Posting" and (OldItemLedgEntry."Expiration Date" <> 0D) and
           not ItemLedgEntry.Correction and
           not (ItemLedgEntry."Document Type" in
                [ItemLedgEntry."Document Type"::"Purchase Return Shipment", ItemLedgEntry."Document Type"::"Purchase Credit Memo"])
        then
            if ItemLedgEntry."Posting Date" > OldItemLedgEntry."Expiration Date" then
                if (ItemLedgEntry."Entry Type" <> ItemLedgEntry."Entry Type"::"Negative Adjmt.") and
                   not ItemJnlLine.IsReclass(ItemJnlLine)
                then
                    IF ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Transfer THEN BEGIN
                        RecTransferorder.RESET();
                        RecTransferorder.SETRANGE("No.", ItemLedgEntry."Order No.");
                        IF (RecTransferorder.FINDFIRST) AND (NOT RecTransferorder.ExpiryStockMovementAllowed) THEN

                            //ACXSK 13082023 End
                            OldItemLedgEntry.FIELDERROR("Expiration Date", Text017);
                    END ELSE
                        OldItemLedgEntry.FIELDERROR("Expiration Date", Text017);
        //ACXSK 13082023
    end;



}
