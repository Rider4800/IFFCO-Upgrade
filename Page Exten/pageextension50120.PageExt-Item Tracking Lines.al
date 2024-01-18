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
    //recSalePrice: Record 7002;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SHRec1: Record "Sales Header";
        CustRec: Record Customer;
        SLRec1: Record "Sales Line";
        Text003: Label 'The customer %1 has an credit limit of %2. The update has been interrupted to respect the warning.';
    begin
        if (Rec."Lot No." <> '') then begin
            SHRec1.Reset();
            SHRec1.SetRange("No.", Rec."Source ID");
            if SHRec1.FindFirst() then begin
                if CustRec.Get(SHRec1."Sell-to Customer No.") then begin
                    SLRec1.Reset();
                    SLRec1.SetRange("Document No.", SHRec1."No.");
                    SLRec1.SetRange("Line No.", Rec."Source Ref. No.");
                    SLRec1.SetRange("No.", Rec."Item No.");
                    if SLRec1.FindFirst() then begin
                        if CustRec.GetTotalAmountLCY + (SLRec1.Quantity * SLRec1."Unit Price") > CustRec."Credit Limit (LCY)" then
                            Error(Text003, CustRec."No.", CustRec."Credit Limit (LCY)");
                    end;
                end;
            end;
        end;
    end;

    trigger OnClosePage()   //pp
    var
        Count: Integer;
        PriceListLine: Record "Price List Line";
        SHRec: Record "Sales Header";
        SHRec1: Record "Sales Header";
        CustRec: Record Customer;
        SLRec1: Record "Sales Line";
        Text003: Label 'The customer %1 has an credit limit of %2. The update has been interrupted to respect the warning.';
    begin
        if (Rec."Lot No." <> '') then begin
            SHRec1.Reset();
            SHRec1.SetRange("No.", Rec."Source ID");
            if SHRec1.FindFirst() then begin
                if CustRec.Get(SHRec1."Sell-to Customer No.") then begin
                    SLRec1.Reset();
                    SLRec1.SetRange("Document No.", SHRec1."No.");
                    SLRec1.SetRange("Line No.", Rec."Source Ref. No.");
                    SLRec1.SetRange("No.", Rec."Item No.");
                    if SLRec1.FindFirst() then begin
                        if CustRec.GetTotalAmountLCY + (SLRec1.Quantity * SLRec1."Unit Price") > CustRec."Credit Limit (LCY)" then
                            Error(Text003, CustRec."No.", CustRec."Credit Limit (LCY)");
                    end;
                end;
            end;
        end;
        UpdateReservEntry;//KM

        if rec."Source Type" = 37 then begin
            //for All Customers
            PriceListLine.Reset();
            PriceListLine.SetRange("Product No.", Rec."Item No.");
            PriceListLine.SetRange("MRP Price", Rec."Batch MRP");
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            SHRec.Reset();
            SHRec.SetRange("No.", Rec."Source ID");
            if SHRec.FindFirst() then begin
                IF SHRec."Document Type" IN [SHRec."Document Type"::Invoice, SHRec."Document Type"::"Credit Memo"] THEN begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Posting Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Posting Date");
                end ELSE begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Order Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Order Date");
                end;
            END;
            PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"All Customers");
            if PriceListLine.FindLast() then
                ModifyUnitPriceProcess(PriceListLine);

            //for Customer
            PriceListLine.Reset();
            PriceListLine.SetRange("Product No.", Rec."Item No.");
            PriceListLine.SetRange("MRP Price", Rec."Batch MRP");
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            SHRec.Reset();
            SHRec.SetRange("No.", Rec."Source ID");
            if SHRec.FindFirst() then begin
                IF SHRec."Document Type" IN [SHRec."Document Type"::Invoice, SHRec."Document Type"::"Credit Memo"] THEN begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Posting Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Posting Date");
                end ELSE begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Order Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Order Date");
                end;
            END;
            PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::Customer);
            if PriceListLine.FindLast() then
                ModifyUnitPriceProcess(PriceListLine);

            //for Customer Price Group
            PriceListLine.Reset();
            PriceListLine.SetRange("Product No.", Rec."Item No.");
            PriceListLine.SetRange("MRP Price", Rec."Batch MRP");
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            SHRec.Reset();
            SHRec.SetRange("No.", Rec."Source ID");
            if SHRec.FindFirst() then begin
                IF SHRec."Document Type" IN [SHRec."Document Type"::Invoice, SHRec."Document Type"::"Credit Memo"] THEN begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Posting Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Posting Date");
                end ELSE begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Order Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Order Date");
                end;
            END;
            PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"Customer Price Group");
            if PriceListLine.FindLast() then
                ModifyUnitPriceProcess(PriceListLine);

            //for campaign
            PriceListLine.Reset();
            PriceListLine.SetRange("Product No.", Rec."Item No.");
            PriceListLine.SetRange("MRP Price", Rec."Batch MRP");
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange(Status, PriceListLine.Status::Active);
            SHRec.Reset();
            SHRec.SetRange("No.", Rec."Source ID");
            if SHRec.FindFirst() then begin
                IF SHRec."Document Type" IN [SHRec."Document Type"::Invoice, SHRec."Document Type"::"Credit Memo"] THEN begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Posting Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Posting Date");
                end ELSE begin
                    PriceListLine.SETFILTER("Ending Date", '%1|>=%2', 0D, SHRec."Order Date");
                    PriceListLine.SETRANGE("Starting Date", 0D, SHRec."Order Date");
                end;
            END;
            if SHRec."Campaign No." <> '' then begin
                PriceListLine.SetRange("Assign-to No.", SHRec."Campaign No.");
                PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::Campaign);
            end;
            if PriceListLine.FindLast() then
                ModifyUnitPriceProcess(PriceListLine);
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

    procedure ModifyUnitPriceProcess(PLLRec: Record "Price List Line")
    var
        PriceListLine1: Record "Price List Line";
        SalesLine: Record "Sales Line";
        recSalesHeader: Record 36;
        LotNoInfo: Record 6505;
        recItemTrack: Record 337;
        LotMRP: Decimal;
        CheckMRP: Boolean;
        recRecRev: Record 337;
        SHRec1: Record "Sales Header";
        CU50056: Codeunit 50056;
        TempTargetCampaignGr: Record "Campaign Target Group";
    begin
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
            if PLLRec."Source Type" = PLLRec."Source Type"::Campaign then begin
                SHRec1.Reset();
                SHRec1.SetRange("No.", Rec."Source ID");
                if SHRec1.FindFirst() then;

                IF CU50056.ActivatedCampaignExists_iffcomc(TempTargetCampaignGr, SHRec1."Campaign No.", SHRec1."Sell-to Customer No.") THEN begin
                    repeat
                        //PriceListLine.SetRange("Assign-to No.", TempTargetCampaignGr."Campaign No.");
                        SalesLine.ValidateMRPItemTracking := TRUE;
                        SalesLine.Validate("MRP Price New", LotMRP);
                        //SalesLine.Validate("MRP Price New", PriceListLine."MRP Price");
                        SalesLine.Validate("Unit Price", PLLRec."Unit Price");
                    until TempTargetCampaignGr.Next() = 0;
                end;
            end else begin
                SalesLine.ValidateMRPItemTracking := TRUE;
                SalesLine.Validate("MRP Price New", LotMRP);
                //SalesLine.Validate("MRP Price New", PriceListLine."MRP Price");
                SalesLine.Validate("Unit Price", PLLRec."Unit Price");
            end;
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
                if not PriceListLine1.FindFirst() then begin
                    //MESSAGE('Batch MRP %1 don''t exists into the Sale Price list',LotMRP);
                    ERROR('Batch MRP %1 don''t exists into the Sale Price list having Sales Type-%2', LotMRP, PriceListLine1."Source Type"::Campaign)
                END

                //END;
                //acxcp_06062022 -
                //acxcp_300622_CampaignCode -
            end;
        end;
    end;
}