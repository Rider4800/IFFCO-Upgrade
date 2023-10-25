codeunit 50054 ItemTrackingMgmt
{
    procedure BatchMRP(ItemNo: Code[20]; LotNo: Code[20]) MRP: Decimal
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTracingMgt: Codeunit "Item Tracing Mgt.";
        recLotInfo: Record "Lot No. Information";
    begin
        /*
        IF NOT GetLotSNDataSet(ItemNo, '', LotNo, '', ItemLedgEntry) THEN BEGIN
                    EntriesExist := FALSE;
                    EXIT;
                END;
        */
        //EntriesExist := TRUE;
        recLotInfo.RESET();
        recLotInfo.SETRANGE("Item No.", ItemNo);
        recLotInfo.SETRANGE("Lot No.", LotNo);
        IF recLotInfo.FINDFIRST THEN
            MRP := recLotInfo."Batch MRP"
        ELSE
            MRP := 0;
    end;

    procedure BatchMFG(ItemNo: Code[20]; LotNo: Code[20]) LotMFG: Date
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTracingMgt: Codeunit "Item Tracing Mgt.";
        recLotInfo: Record "Lot No. Information";
    begin
        /*
        IF NOT GetLotSNDataSet(ItemNo,'',LotNo,'',ItemLedgEntry) THEN BEGIN
          EntriesExist := FALSE;
          EXIT;
        END;
        */
        //EntriesExist := TRUE;
        recLotInfo.RESET();
        recLotInfo.SETRANGE("Item No.", ItemNo);
        recLotInfo.SETRANGE("Lot No.", LotNo);
        IF recLotInfo.FINDFIRST THEN
            LotMFG := recLotInfo."MFG Date"
        ELSE
            LotMFG := 0D;
    end;
}