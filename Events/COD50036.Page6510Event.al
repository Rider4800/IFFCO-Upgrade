codeunit 50036 ItemTrackingLine
{
    trigger OnRun()
    begin

    end;

    //     [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterUpdateExpDateEditable', '', false, false)]
    //     local procedure OnAfterUpdateExpDateEditable(var TrackingSpecification: Record "Tracking Specification"; var ExpirationDateEditable: Boolean; var ItemTrackingCode: Record "Item Tracking Code"; var NewExpirationDateEditable: Boolean; CurrentSignFactor: Integer);
    //     var
    //         LotMFG: Date;
    //         ItemTrackingMgt: Codeunit 6500;
    //         Page6510: Page 6510;
    //     begin
    //         /*12887 Need to be reviewed--->
    //         IF (TrackingSpecification."Lot No." <> '') AND (TrackingSpecification."Source Type" = 37) THEN BEGIN
    //             recSaleLine.RESET;//acxcp090622
    //             recSaleLine.SETRANGE("Document No.", TrackingSpecification."Source ID");//acxcp090622
    //             IF recSaleLine.FINDFIRST THEN BEGIN//acxcp090622
    //                 recCust.RESET;
    //                 recCust.SETRANGE("No.", recSaleLine."Sell-to Customer No.");
    //                 IF recCust.FINDFIRST THEN BEGIN
    //                     recCPG.RESET;
    //                     recCPG.SETRANGE(Code, recCust."Customer Posting Group");
    //                     IF recCPG.FINDFIRST THEN BEGIN
    //                         IF NOT recCPG.ExcludeFIFOExpiry THEN
    //                             IF TrackingSpecification."Expiration Date" > TODAY THEN
    //                                 CheckNearExp(TrackingSpecification."Item No.", TrackingSpecification."Location Code", TrackingSpecification."Expiration Date"); //ACXCP_18052022 //Near Expiry Check uncommented
    //                         IF Expire = TRUE THEN BEGIN //ACXCP_18052022
    //                             TempItemTrackLineInsert.DELETE();//ACXCP_18052022
    //                             TrackingSpecification.DELETE();//ACXCP_18052022
    //                         END;//ACXCP_18052022
    //                     END;//acxcp090622
    //                 END;//acxcp090622
    //             END;//acxcp090622
    //         END;
    //         MRP := ItemTrackingMgt.BatchMRP(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
    //         IF MRP <> 0 THEN
    //             TrackingSpecification."Batch MRP" := TrackingSpecification.MRP;
    //         LotMFG := ItemTrackingMgt.BatchMFG(TrackingSpecification."Item No.", TrackingSpecification."Lot No.");
    //         IF LotMFG <> 0D THEN
    //             TrackingSpecification."MFG Date" := LotMFG;
    //         //KM
    //         //acxcp_01072022 -
    // <---12887*/
    //     end;

    procedure CheckNearExp("ItemNo.": Code[20]; LocationCode: Code[20]; Date: Date)
    var
        ILE: Record 32;
        "Qty.": Decimal;
        "RevQty.": Decimal;
        ILE2: Record 32;
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
        myInt: Integer;
        recSalesPrice: Record 7002;
        Expire: Boolean;
        recLotInfoInsert: Record 6505;
        recLotInfo: Record 6505;
        recReserv: Record 337;
        MRP: Decimal;
        LotMFG: Date;
        recEntrySummary: Record 338;
        recSaleLine: Record 37;
        recCust: Record 18;
        recCPG: Record 92;
        recSalePrice: Record 7002;

}