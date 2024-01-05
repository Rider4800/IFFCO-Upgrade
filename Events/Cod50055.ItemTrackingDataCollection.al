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
                                CheckNearExp(TrackingSpecification."Item No.", TrackingSpecification."Location Code", TrackingSpecification."Expiration Date"); //ACXCP_18052022 //Near Expiry Check uncommented
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

    // [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnSelectEntriesOnBeforeResetStatus', '', false, false)]
    // local procedure OnSelectEntriesOnBeforeResetStatus(var TrackingSpecification: Record "Tracking Specification")
    // begin
    //     //KM
    //     IF (TrackingSpecification."Lot No." <> '') AND (TrackingSpecification."Source Type" = 37) THEN BEGIN
    //         recSaleLine.RESET;//acxcp090622
    //         recSaleLine.SETRANGE("Document No.", TrackingSpecification."Source ID");//acxcp090622
    //         IF recSaleLine.FINDFIRST THEN BEGIN//acxcp090622
    //             recCust.RESET;
    //             recCust.SETRANGE("No.", recSaleLine."Sell-to Customer No.");
    //             IF recCust.FINDFIRST THEN BEGIN
    //                 recCPG.RESET;
    //                 recCPG.SETRANGE(Code, recCust."Customer Posting Group");
    //                 IF recCPG.FINDFIRST THEN BEGIN  //team
    //                     IF NOT recCPG.ExcludeFIFOExpiry THEN
    //                         IF TrackingSpecification."Expiration Date" > TODAY THEN
    //                             CheckNearExp(TrackingSpecification."Item No.", TrackingSpecification."Location Code", TrackingSpecification."Expiration Date"); //ACXCP_18052022 //Near Expiry Check uncommented
    //                     IF Expire = TRUE THEN BEGIN //ACXCP_18052022
    //                         //TempItemTrackLineInsert.DELETE();//ACXCP_18052022
    //                         TrackingSpecification.DELETE();//ACXCP_18052022
    //                     END;//ACXCP_18052022
    //                 END;//acxcp090622
    //             END;//acxcp090622
    //         END;//acxcp090622
    //     END;
    //     MRP := CU50054.BatchMRP(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
    //     IF MRP <> 0 THEN
    //         TrackingSpecification."Batch MRP" := MRP;
    //     LotMFG := CU50054.BatchMFG(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
    //     IF LotMFG <> 0D THEN
    //         TrackingSpecification."MFG Date" := LotMFG;
    // end;

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
                                CheckNearExp(TempTrackingSpecification."Item No.", TempTrackingSpecification."Location Code", TempTrackingSpecification."Expiration Date"); //ACXCP_18052022 //Near Expiry Check uncommented
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
                            IF TempTrackingSpecification."Expiration Date" > TODAY THEN
                                CheckNearExp(TempTrackingSpecification."Item No.", TempTrackingSpecification."Location Code", TempTrackingSpecification."Expiration Date"); //ACXCP_18052022 //Near Expiry Check uncommented
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

    procedure CheckNearExp("ItemNo.": Code[20]; LocationCode: Code[20]; Date: Date)
    var
        ILE: Record "Item Ledger Entry";
        "Qty.": Decimal;
        "RevQty.": Decimal;
        ILE2: Record "Item Ledger Entry";
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
                    ILE2.SETRANGE("Location Code", ILE."Location Code");
                    IF ILE2.FINDFIRST THEN
                        "Qty." := ILE2."Remaining Quantity";
                    recReserv.RESET();
                    recReserv.SETRANGE("Item No.", ILE."Item No.");
                    recReserv.SETRANGE("Lot No.", ILE."Lot No.");
                    recReserv.SETRANGE("Location Code", ILE."Location Code");
                    IF recReserv.FINDFIRST THEN BEGIN
                        REPEAT
                            "RevQty." := ABS("RevQty." + recReserv.Quantity)
                        UNTIL recReserv.NEXT = 0;
                    END;
                    //IF "Qty." - "RevQty." >0 THEN BEGIN
                    IF "Qty." - "RevQty." > 0 THEN BEGIN
                        IF ILE."Expiration Date" <= TODAY THEN //acxcp_23052022
                            Expire := FALSE //acxcp_23052022
                        ELSE //acxcp_23052022
                            Expire := TRUE;
                        Error('Wrong Selection, as per near expiration please select %1, Lot...', ILE."Lot No.");
                    END;
                END;
            UNTIL ILE.NEXT = 0;
        END;
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