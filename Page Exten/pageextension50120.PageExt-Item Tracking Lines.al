pageextension 50120 ItemTrackingline extends "Item Tracking Lines"
{
    layout
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                LotNoOnAfterValidate;
                //KM
                IF NOT recLotInfo.GET(rec."Item No.", rec."Variant Code", rec."Lot No.") THEN BEGIN
                    recLotInfoInsert.INIT;
                    recLotInfoInsert.VALIDATE("Item No.", rec."Item No.");
                    recLotInfoInsert.VALIDATE("Variant Code", rec."Variant Code");
                    recLotInfoInsert.VALIDATE("Lot No.", rec."Lot No.");
                    recLotInfoInsert.INSERT(TRUE);
                END;
                //KM
                UpdateReservEntry//KM
            end;

            trigger OnAssistEdit()
            begin
                //KM010721
                IF Rec."Source Type" = 37 THEN BEGIN
                    IF Rec."Lot No." <> '' THEN
                        ERROR('Multi lot selection not allowed against same sales line');
                END;
                //KM010721
            end;
        }
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            var

            begin
                ModifyLot;
            end;
        }
        modify("Appl.-from Item Entry")
        {
            Caption = '<Appl.-from Item Entry>';
        }

        modify(AvailabilitySerialNo)
        {
            Visible = false;
        }
        modify("Serial No.")
        {
            Visible = false;
        }
        modify(AvailabilityLotNo)
        {
            Visible = false;
        }

        addafter("Quantity (Base)")
        {
            field("Batch MRP"; rec."Batch MRP")
            {

                trigger OnValidate()
                begin
                    /*
                    ModifyLot;
                    */
                    //acxcp_240422+ //Check existing Batch MRP
                    IF xRec."Batch MRP" <> 0 THEN
                        IF xRec."Batch MRP" <> Rec."Batch MRP" THEN
                            ERROR('Old Batch MRP is %1 and New Batch MRP is %2 is not matched', xRec."Batch MRP", Rec."Batch MRP")
                        ELSE
                            ModifyLot;
                    //acxcp_240422+ //Check existing Batch MRP

                end;
            }
            field("MFG Date"; rec."MFG Date")
            {

                trigger OnValidate()
                begin
                    ModifyLot;
                end;
            }


        }
    }

    actions
    {

    }
    local procedure UpdateBatchMRPOnSalesLine()
    var
        recSalesHeader: Record 36;
        recSalesLine: Record 37;
        LotNoInfo: Record 6505;
        recItemTrack: Record 337;
        LotMRP: Decimal;
        CheckMRP: Boolean;
        recRecRev: Record 337;
    begin
        recItemTrack.RESET();
        LotMRP := 0;
        CheckMRP := FALSE;
        recItemTrack.SETRANGE("Source ID", rec."Source ID");
        recItemTrack.SETRANGE("Source Ref. No.", rec."Source Ref. No.");
        recItemTrack.SETRANGE("Item No.", rec."Item No.");
        IF recItemTrack.FINDFIRST THEN BEGIN
            REPEAT
                recSalesLine.RESET();
                recSalesLine.SETRANGE("Document No.", recItemTrack."Source ID");
                recSalesLine.SETRANGE("Line No.", recItemTrack."Source Ref. No.");
                recSalesLine.SETRANGE("No.", recItemTrack."Item No.");
                IF recSalesLine.FIND('-') THEN BEGIN
                    LotNoInfo.RESET();
                    LotNoInfo.SETRANGE("Item No.", recItemTrack."Item No.");
                    LotNoInfo.SETRANGE("Lot No.", recItemTrack."Lot No.");
                    IF LotNoInfo.FINDFIRST THEN BEGIN
                        LotNoInfo.TESTFIELD("Batch MRP");
                        /*IF (LotMRP<>0) AND (LotMRP <> LotNoInfo."Batch MRP") THEN BEGIN
                          MESSAGE('Both batch MRP are not matched showing error at the the time of postig order...');
                          CheckMRP:= TRUE;
                        END;*/
                        LotMRP := LotNoInfo."Batch MRP";
                    END;
                END;
            UNTIL recItemTrack.NEXT = 0;
            recSalesLine.ValidateMRPItemTracking := TRUE;
            //12887 field is removed recSalesLine.VALIDATE("MRP Price", LotMRP);
            recSalesLine.MODIFY();
            //acxcp_300622_CampaignCode +
            //acxcp_06062022 + for checking sale price line with campaign code
            recSalesHeader.SETRANGE("No.", recItemTrack."Source ID");
            recSalesHeader.SETFILTER("Campaign No.", '<>%1', '');
            IF recSalesHeader.FINDFIRST THEN BEGIN
                //IF recSalesHeader.SETFILTER("Campaign No.",'<>%1','') THEN BEGIN
                recSalePrice.RESET;
                recSalePrice.SETRANGE("Item No.", Rec."Item No.");
                recSalePrice.SETRANGE("Sales Type", recSalePrice."Sales Type"::Campaign);
                //12887 field is removed recSalePrice.SETFILTER("MRP Price", '%1', LotMRP);
                IF NOT recSalePrice.FINDFIRST THEN
                    //MESSAGE('Batch MRP %1 don''t exists into the Sale Price list',LotMRP);
                    ERROR('Batch MRP %1 don''t exists into the Sale Price list having Sales Type-%2', LotMRP, recSalePrice."Sales Type"::Campaign)
            END

            //END;
            //acxcp_06062022 -
            //acxcp_300622_CampaignCode -
        END;

    end;


    local procedure ModifyLot()
    begin
        IF recLotInfo.GET(rec."Item No.", rec."Variant Code", rec."Lot No.") THEN BEGIN
            recLotInfo.VALIDATE("MFG Date", rec."MFG Date");
            recLotInfo.VALIDATE("Expiration Date", rec."Expiration Date");
            recLotInfo.VALIDATE("Batch MRP", rec."Batch MRP");
            recLotInfo.MODIFY(TRUE);
        END;
    end;

    local procedure UpdateReservEntry()
    begin
        recReserv.RESET();
        recReserv.SETRANGE("Source ID", rec."Source ID");
        recReserv.SETRANGE("Source Ref. No.", rec."Source Ref. No.");
        recReserv.SETRANGE("Item No.", rec."Item No.");
        IF recReserv.FINDFIRST THEN BEGIN
            REPEAT
                ModifyReservEntry(recReserv."Source ID", recReserv."Source Ref. No.", recReserv."Item No.", recReserv."Lot No.");
            UNTIL recReserv.NEXT = 0;
        END;
        //Rec Validate
        recLotInfo.RESET();
        recLotInfo.SETRANGE("Item No.", rec."Item No.");
        recLotInfo.SETRANGE("Lot No.", rec."Lot No.");
        IF recLotInfo.FINDFIRST THEN BEGIN
            rec."MFG Date" := recLotInfo."MFG Date";
            rec."Batch MRP" := recLotInfo."Batch MRP";
        END;
    end;

    local procedure ModifyReservEntry(SourceID: Code[20]; "SourceRefNo.": Integer; "ItemNo.": Code[20]; "LotNo.": Code[20])
    var
        recReserv1: Record 337;
        recLotInfo1: Record 6505;
    begin
        recReserv1.RESET();
        recReserv1.SETRANGE("Source ID", SourceID);
        recReserv1.SETRANGE("Source Ref. No.", "SourceRefNo.");
        recReserv1.SETRANGE("Item No.", "ItemNo.");
        recReserv1.SETRANGE("Lot No.", "LotNo.");
        IF recReserv1.FINDFIRST THEN BEGIN
            recLotInfo1.RESET();
            recLotInfo1.SETRANGE("Item No.", recReserv1."Item No.");
            recLotInfo1.SETRANGE("Lot No.", recReserv1."Lot No.");
            IF recLotInfo1.FINDFIRST THEN BEGIN
                recReserv1."MFG Date" := recLotInfo1."MFG Date";
                recReserv1."Batch MRP" := recLotInfo1."Batch MRP";
                recReserv1.MODIFY();
            END;
        END;
    end;

    local procedure FindReservEntry(SourceID: Code[20]; "SourceRefNo.": Integer; "ItemNo.": Code[20]; "LotNo.": Code[20]; EntryType: Integer)
    var
        recReserv1: Record 337;
        recLotInfo1: Record 6505;
        FindLot: Boolean;
    begin
        FindLot := FALSE;
        recReserv1.RESET();
        recReserv1.SETRANGE("Source ID", SourceID);
        recReserv1.SETRANGE("Source Ref. No.", "SourceRefNo.");
        recReserv1.SETRANGE("Item No.", "ItemNo.");
        recReserv1.SETRANGE("Lot No.", "LotNo.");
        recReserv1.SETRANGE("Source Type", EntryType);
        IF recReserv1.FINDFIRST THEN
            FindLot := TRUE;
        IF Rec."Lot No." <> '' THEN
            FindLot := TRUE;

        IF FindLot = TRUE THEN
            ERROR('Multi lot selection not allowed against same sales line');
    end;



    var
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

    trigger OnOpenPage()
    var
        Count: Integer;
    begin
        UpdateReservEntry;//KM

        IF rec."Source Type" = 37 THEN
            UpdateBatchMRPOnSalesLine;//KM240621

        //acxcp_23052022 + //check expiry date selection in current lot
        IF (rec."Source Type" = 37) AND (rec."Source Subtype" = 1) THEN
            IF (Rec."Expiration Date") <> 0D THEN
                IF Rec."Expiration Date" < TODAY THEN
                    ERROR('The Lot No.-%1 has Expiration Date -  %2 you can not select Expired Lot', Rec."Lot No.", Rec."Expiration Date")
        //acxcp_23052022 -
    end;
}