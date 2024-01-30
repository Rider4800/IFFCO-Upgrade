codeunit 50055 ItemTrackingDataCollection
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnBeforeInsertOrModify', '', false, false)]
    local procedure OnCreateEntrySummary2OnBeforeInsertOrModify(var TempGlobalEntrySummary: Record "Entry Summary" temporary; TempReservEntry: Record "Reservation Entry" temporary; TrackingSpecification: Record "Tracking Specification")
    begin
        IF TempReservEntry.Positive THEN BEGIN
            //ACX-RK 13032021 Begsin
            TempGlobalEntrySummary."Manufacturing Date" := TempReservEntry."MFG Date";
            TempGlobalEntrySummary."Batch MRP" := TempReservEntry."Batch MRP";
            //ACX-RK End
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterAssistEditTrackingNo', '', false, false)]
    local procedure OnAfterAssistEditTrackingNo(var TrackingSpecification: Record "Tracking Specification"; var TempGlobalEntrySummary: Record "Entry Summary" temporary; CurrentSignFactor: Integer; MaxQuantity: Decimal)
    begin
        //KM
        IF (TrackingSpecification."Lot No." <> '') AND (TrackingSpecification."Source Type" = 37) THEN BEGIN
            recSaleLine.RESET;//acxcp090622
            recSaleLine.SETRANGE("Document No.", TrackingSpecification."Source ID");//acxcp090622
            IF recSaleLine.FINDFIRST THEN BEGIN//acxcp090622
                recCust.RESET;
                recCust.SETRANGE("No.", recSaleLine."Sell-to Customer No.");
                IF recCust.FINDFIRST THEN BEGIN
                    recCPG.RESET;
                    recCPG.SETRANGE(Code, recCust."Customer Posting Group");
                    IF recCPG.FINDFIRST THEN BEGIN  //team
                        IF NOT recCPG.ExcludeFIFOExpiry THEN
                            IF TrackingSpecification."Expiration Date" > TODAY THEN
                                if recCPG."Multi-Lot Selection Allowed" then
                                    NewMultiSelectionLot(TrackingSpecification)
                                else
                                    CheckNearExp(TrackingSpecification."Item No.", TrackingSpecification."Location Code", TrackingSpecification."Expiration Date", TrackingSpecification."Source ID"); //ACXCP_18052022 //Near Expiry Check uncommented
                        IF Expire = TRUE THEN BEGIN //ACXCP_18052022
                            //TempItemTrackLineInsert.DELETE();//ACXCP_18052022
                            TrackingSpecification.DELETE();//ACXCP_18052022
                        END;//ACXCP_18052022
                    END;//acxcp090622
                END;//acxcp090622
            END;//acxcp090622
        END;
        MRP := CU50054.BatchMRP(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
        IF MRP <> 0 THEN
            TrackingSpecification."Batch MRP" := MRP;
        LotMFG := CU50054.BatchMFG(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
        IF LotMFG <> 0D THEN
            TrackingSpecification."MFG Date" := LotMFG;
        //KM
        //acxcp_01072022 -
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnBeforeTempTrackingSpecificationInsert', '', false, false)]
    local procedure OnBeforeTempTrackingSpecificationInsert(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        //KM
        IF (TempTrackingSpecification."Lot No." <> '') AND (TempTrackingSpecification."Source Type" = 37) THEN BEGIN
            recSaleLine.RESET;//acxcp090622
            recSaleLine.SETRANGE("Document No.", TempTrackingSpecification."Source ID");//acxcp090622
            IF recSaleLine.FINDFIRST THEN BEGIN//acxcp090622
                recCust.RESET;
                recCust.SETRANGE("No.", recSaleLine."Sell-to Customer No.");
                IF recCust.FINDFIRST THEN BEGIN
                    recCPG.RESET;
                    recCPG.SETRANGE(Code, recCust."Customer Posting Group");
                    IF recCPG.FINDFIRST THEN BEGIN  //team
                        IF NOT recCPG.ExcludeFIFOExpiry THEN
                            IF TempTrackingSpecification."Expiration Date" > TODAY THEN
                                if recCPG."Multi-Lot Selection Allowed" then
                                    NewMultiSelectionLot(TempTrackingSpecification)
                                else
                                    CheckNearExp(TempTrackingSpecification."Item No.", TempTrackingSpecification."Location Code", TempTrackingSpecification."Expiration Date", TempTrackingSpecification."Source ID"); //ACXCP_18052022 //Near Expiry Check uncommented
                        IF Expire = TRUE THEN BEGIN //ACXCP_18052022
                            //TempItemTrackLineInsert.DELETE();//ACXCP_18052022
                            TempTrackingSpecification.DELETE();//ACXCP_18052022
                        END;//ACXCP_18052022
                    END;//acxcp090622
                END;//acxcp090622
            END;//acxcp090622
        END;
        MRP := CU50054.BatchMRP(TempTrackingSpecification."Item No.", TempTrackingSpecification."Lot No.");
        IF MRP <> 0 THEN
            TempTrackingSpecification."Batch MRP" := MRP;
        LotMFG := CU50054.BatchMFG(TempTrackingSpecification."Item No.", TempTrackingSpecification."Lot No.");
        IF LotMFG <> 0D THEN
            TempTrackingSpecification."MFG Date" := LotMFG;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAddSelectedTrackingToDataSetOnBeforeUpdateWithChange', '', false, false)]
    local procedure OnAddSelectedTrackingToDataSetOnBeforeUpdateWithChange(var TempEntrySummary: Record "Entry Summary" temporary; var TempTrackingSpecification: Record "Tracking Specification"; ChangeType: Option)
    begin
        //KM
        IF (TempTrackingSpecification."Lot No." <> '') AND (TempTrackingSpecification."Source Type" = 37) THEN BEGIN
            recSaleLine.RESET;//acxcp090622
            recSaleLine.SETRANGE("Document No.", TempTrackingSpecification."Source ID");//acxcp090622
            IF recSaleLine.FINDFIRST THEN BEGIN//acxcp090622
                recCust.RESET;
                recCust.SETRANGE("No.", recSaleLine."Sell-to Customer No.");
                IF recCust.FINDFIRST THEN BEGIN
                    recCPG.RESET;
                    recCPG.SETRANGE(Code, recCust."Customer Posting Group");
                    IF recCPG.FINDFIRST THEN BEGIN  //team
                        IF NOT recCPG.ExcludeFIFOExpiry THEN
                            IF TempTrackingSpecification."Expiration Date" > TODAY THEN begin
                                if recCPG."Multi-Lot Selection Allowed" then
                                    NewMultiSelectionLot(TempTrackingSpecification)
                                else
                                    CheckNearExp(TempTrackingSpecification."Item No.", TempTrackingSpecification."Location Code", TempTrackingSpecification."Expiration Date", TempTrackingSpecification."Source ID"); //ACXCP_18052022 //Near Expiry Check uncommented
                            end;
                        IF Expire = TRUE THEN BEGIN //ACXCP_18052022
                            //TempItemTrackLineInsert.DELETE();//ACXCP_18052022
                            TempTrackingSpecification.DELETE();//ACXCP_18052022
                        END;//ACXCP_18052022
                    END;//acxcp090622
                END;//acxcp090622
            END;//acxcp090622
        END;
        MRP := CU50054.BatchMRP(TempTrackingSpecification."Item No.", TempTrackingSpecification."Lot No.");
        IF MRP <> 0 THEN
            TempTrackingSpecification."Batch MRP" := MRP;
        LotMFG := CU50054.BatchMFG(TempTrackingSpecification."Item No.", TempTrackingSpecification."Lot No.");
        IF LotMFG <> 0D THEN
            TempTrackingSpecification."MFG Date" := LotMFG;
    end;

    procedure CheckNearExp("ItemNo.": Code[20]; LocationCode: Code[20]; Date: Date; DocNo: Code[20])
    var
        ILE: Record "Item Ledger Entry";
        "Qty.": Decimal;
        "RevQty.": Decimal;
        ILE2: Record "Item Ledger Entry";
        recReserv1: Record 337;
        recReservLotNo: Code[20];
    begin
        ILE.RESET();
        "Qty." := 0;
        "RevQty." := 0;
        Expire := FALSE;
        ILE.SETRANGE("Item No.", "ItemNo.");
        ILE.SETRANGE("Location Code", LocationCode);
        ILE.SETFILTER("Remaining Quantity", '>%1', 0);
        ILE.SETFILTER("Expiration Date", '<%1', Date);
        IF ILE.FINDFIRST THEN BEGIN
            REPEAT
                IF Expire = FALSE THEN BEGIN
                    ILE2.RESET();
                    ILE2.SETRANGE("Item No.", ILE."Item No.");
                    ILE2.SETRANGE("Lot No.", ILE."Lot No.");
                    ILE2.SETFILTER("Remaining Quantity", '>%1', 0);           //17783->Newly Added, correction found.
                    ILE2.SETRANGE("Location Code", ILE."Location Code");
                    IF ILE2.FINDFIRST THEN
                        "Qty." := ILE2."Remaining Quantity";
                    recReserv.RESET();
                    recReserv.SETRANGE("Item No.", ILE."Item No.");
                    recReserv.SETRANGE("Lot No.", ILE."Lot No.");
                    recReserv.SETRANGE("Location Code", ILE."Location Code");
                    IF recReserv.FINDFIRST THEN BEGIN
                        REPEAT
                            "RevQty." := "RevQty." + ABS(recReserv.Quantity);
                        UNTIL recReserv.NEXT = 0;
                    END;
                    //IF "Qty." - "RevQty." >0 THEN BEGIN
                    IF "Qty." - "RevQty." > 0 THEN BEGIN
                        IF ILE."Expiration Date" <= TODAY THEN //acxcp_23052022
                            Expire := FALSE //acxcp_23052022
                        ELSE begin//acxcp_23052022
                            Expire := TRUE;
                            ERROR('Wrong Selection, as per near expiration please select %1, Lot...', ILE2."Lot No."); //17783->Newly Added, correction found.
                        end;
                    END;
                END;
            UNTIL ILE.NEXT = 0;
        END;
    end;

    procedure NewMultiSelectionLot(var TrackingSpecification: Record "Tracking Specification")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        QtyResereve: Decimal;
        ItemLedgeEntry2: Record "Item Ledger Entry";
        QtyResereve2: Decimal;
        QtyTracking: Decimal;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        LotNoInfo: Record "Lot No. Information";
    begin
        if (TrackingSpecification."Source Type" = 37) then begin
            ItemLedgerEntry.SetCurrentKey("Expiration Date");
            ItemLedgerEntry.SetRange("Item No.", TrackingSpecification."Item No.");
            ItemLedgerEntry.SetRange("Location Code", TrackingSpecification."Location Code");
            ItemLedgerEntry.SetRange(Open, true);
            ItemLedgerEntry.SETFILTER("Expiration Date", '>%1', Today);
            if ItemLedgerEntry.FindFirst() then begin
                TempTrackingSpecification.Init();
                TempTrackingSpecification := (TrackingSpecification);
                TempTrackingSpecification.Insert();
                repeat
                    ItemLedgeEntry2.Reset();
                    ItemLedgeEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                    ItemLedgeEntry2.SetRange("Location Code", ItemLedgerEntry."Location Code");
                    ItemLedgeEntry2.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                    ItemLedgeEntry2.SetRange(Open, true);
                    ItemLedgeEntry2.CalcSums("Remaining Quantity");
                    // if ItemLedgerEntry."Remaining Quantity" <> TempGlobalEntrySummary."Total Requested Quantity" then
                    if (ItemLedgerEntry."Lot No." <> TrackingSpecification."Lot No.") then begin

                        ReservationEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                        ReservationEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                        ReservationEntry.SetRange("Location Code", ItemLedgerEntry."Location Code");
                        ReservationEntry.SetFilter("Source ID", '<>%1', TrackingSpecification."Source ID");
                        //ReservationEntry.SetFilter("Source Ref. No.", '<>%1', TrackingSpecification."Source Ref. No.");
                        ReservationEntry.CalcSums(Quantity);
                        QtyResereve2 := abs(ReservationEntry.Quantity);

                        ReservationEntry2.Reset();
                        ReservationEntry2.SetRange("Item No.", ItemLedgerEntry."Item No.");
                        ReservationEntry2.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                        ReservationEntry2.SetRange("Location Code", ItemLedgerEntry."Location Code");
                        ReservationEntry2.SetFilter("Source ID", TrackingSpecification."Source ID");
                        //ReservationEntry2.SetFilter("Source Ref. No.", '<>%1', TrackingSpecification."Source Ref. No.");
                        ReservationEntry2.CalcSums(Quantity);
                        QtyResereve := abs(ReservationEntry2.Quantity);

                        if ItemLedgeEntry2."Remaining Quantity" <> (QtyResereve2 + QtyResereve) then begin
                            TrackingSpecification.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                            TrackingSpecification.SetRange("Location Code", ItemLedgerEntry."Location Code");
                            TrackingSpecification.SetRange("Item No.", ItemLedgerEntry."Item No.");
                            TrackingSpecification.SetRange("Source ID", TrackingSpecification."Source ID");
                            TrackingSpecification.CalcSums("Quantity (Base)");
                            QtyTracking := Abs(TrackingSpecification."Quantity (Base)");
                            if ItemLedgeEntry2."Remaining Quantity" <> (QtyTracking + QtyResereve2 + QtyResereve) then
                                Error('Please Select the Lot No On FIFO basis.')
                            else begin
                                TrackingSpecification.SetCurrentKey("Entry No.");
                                if TrackingSpecification.FindFirst() then
                                    if TrackingSpecification."Batch MRP" <> 0 then begin
                                        LotNoInfo.Reset();
                                        LotNoInfo.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                        LotNoInfo.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                        LotNoInfo.SetFilter("Batch MRP", '<>%1', 0);
                                        if LotNoInfo.FindFirst() then begin
                                            if LotNoInfo."Batch MRP" <> TrackingSpecification."Batch MRP" then;
                                            Error('MRP Price Should be Same As in First Line in Tracking Specification');
                                        end;
                                    end;
                                TrackingSpecification.SetRange("Lot No.");
                                TrackingSpecification.TransferFields(TempTrackingSpecification);
                            end;
                        end;
                    end else begin
                        TrackingSpecification.SetCurrentKey("Entry No.");
                        if TrackingSpecification.FindFirst() then
                            if TrackingSpecification."Batch MRP" <> 0 then begin
                                LotNoInfo.Reset();
                                LotNoInfo.SetRange("Item No.", ItemLedgerEntry."Item No.");
                                LotNoInfo.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                                LotNoInfo.SetFilter("Batch MRP", '<>%1', 0);
                                if LotNoInfo.FindFirst() then begin
                                    if LotNoInfo."Batch MRP" <> TrackingSpecification."Batch MRP" then
                                        Error('MRP Price Should be Same As in First Line in Tracking Specification');
                                end;
                            end;
                        TrackingSpecification.SetRange("Lot No.");
                        TrackingSpecification.TransferFields(TempTrackingSpecification);
                        exit;
                    end;
                until ItemLedgerEntry.Next() = 0;
            end;
        end;

    end;

    var
        Expire: Boolean;
        recReserv: Record "Reservation Entry";
        MRP: Decimal;
        LotMFG: Date;
        recEntrySummary: Record "Entry Summary";
        recSaleLine: Record "Sales Line";
        recCust: Record Customer;
        recCPG: Record "Customer Posting Group";
        CU50054: Codeunit 50054;
}