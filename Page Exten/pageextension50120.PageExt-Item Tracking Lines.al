pageextension 50120 ItemTrackingline extends "Item Tracking Lines"
{
    layout
    {
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin
                ModifyLot;
            end;
        }
        modify("Appl.-from Item Entry")
        {
            Caption = 'Appl.-from Item Entry';
        }

        modify(AvailabilitySerialNo)
        {
            Visible = true;
        }
        modify("Serial No.")
        {
            Visible = false;
        }
        modify(AvailabilityLotNo)
        {
            Visible = false;
        }
        modify("Qty. to Invoice (Base)")
        {
            Visible = true;
        }

        addafter("Quantity (Base)")
        {
            field("Batch MRP"; rec."Batch MRP")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
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

    trigger OnClosePage()   //pp
    var
        Count: Integer;
        PriceListLine: Record "Price List Line";
        PriceListLine1: Record "Price List Line";
        SalesLine: Record "Sales Line";
        recSalesHeader: Record 36;
        LotNoInfo: Record 6505;
        recItemTrack: Record 337;
        LotMRP: Decimal;
        CheckMRP: Boolean;
        recRecRev: Record 337;
    begin
        UpdateReservEntry;//KM

        // IF rec."Source Type" = 37 THEN
        //     UpdateBatchMRPOnSalesLine;//KM240621

        if rec."Source Type" = 37 then begin
            PriceListLine.Reset();
            PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"All Customers");
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange("Product No.", Rec."Item No.");
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            PriceListLine.SetRange("MRP Price", Rec."Batch MRP");
            if PriceListLine.FindFirst() then begin
                recItemTrack.Reset();
                recItemTrack.SETRANGE("Source ID", Rec."Source ID");
                recItemTrack.SETRANGE("Source Ref. No.", Rec."Source Ref. No.");
                recItemTrack.SETRANGE("Item No.", Rec."Item No.");
                IF recItemTrack.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                        SalesLine.SetRange("Document No.", Rec."Source ID");
                        SalesLine.SetRange("Line No.", Rec."Source Ref. No.");
                        SalesLine.SetRange("No.", Rec."Item No.");
                        if SalesLine.FindFirst() then begin
                            LotNoInfo.RESET();
                            LotNoInfo.SETRANGE("Item No.", recItemTrack."Item No.");
                            LotNoInfo.SETRANGE("Lot No.", recItemTrack."Lot No.");
                            IF LotNoInfo.FINDFIRST THEN begin
                                LotNoInfo.TESTFIELD("Batch MRP");
                                LotMRP := LotNoInfo."Batch MRP";
                            end;
                        end;
                    UNTIL recItemTrack.NEXT = 0;
                    SalesLine.ValidateMRPItemTracking := TRUE;
                    SalesLine.Validate("Unit Price", PriceListLine."Unit Price");
                    SalesLine.Modify();

                    //acxcp_300622_CampaignCode +
                    //acxcp_06062022 + for checking sale price line with campaign code
                    recSalesHeader.Reset();
                    recSalesHeader.SETRANGE("No.", recItemTrack."Source ID");
                    recSalesHeader.SETFILTER("Campaign No.", '<>%1', '');
                    IF recSalesHeader.FINDFIRST THEN BEGIN
                        //IF recSalesHeader.SETFILTER("Campaign No.",'<>%1','') THEN BEGIN  
                        PriceListLine1.Reset();
                        PriceListLine1.SetRange("Product No.", Rec."Item No.");
                        PriceListLine1.SetRange("Source Type", PriceListLine1."Source Type"::Campaign);
                        PriceListLine1.SetRange("MRP Price", LotMRP);
                        if PriceListLine1.FindFirst() then begin
                            //MESSAGE('Batch MRP %1 don''t exists into the Sale Price list',LotMRP);
                            ERROR('Batch MRP %1 don''t exists into the Sale Price list having Sales Type-%2', LotMRP, PriceListLine1."Source Type"::Campaign)
                        END

                        //END;
                        //acxcp_06062022 -
                        //acxcp_300622_CampaignCode -
                    end;
                end;
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        //acxcp_23052022 + //check expiry date selection in current lot
        IF (rec."Source Type" = 37) AND (rec."Source Subtype" = 1) THEN
            IF (Rec."Expiration Date") <> 0D THEN
                IF Rec."Expiration Date" < TODAY THEN
                    ERROR('The Lot No.-%1 has Expiration Date -  %2 you can not select Expired Lot', Rec."Lot No.", Rec."Expiration Date")
        //acxcp_23052022 -
    end;
}