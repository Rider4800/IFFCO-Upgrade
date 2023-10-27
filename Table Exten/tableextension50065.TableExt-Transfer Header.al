tableextension 50065 tableextension50065 extends "Transfer Header"
{
    fields
    {
        field(50000; "Transporter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE(Transporter = FILTER(true));

            trigger OnValidate()
            begin
                recVend.RESET();
                recVend.SETRANGE("No.", Rec."Transporter Code");
                IF recVend.FIND('-') THEN BEGIN
                    "Transporter Name" := recVend.Name;
                    "Transporter GSTIN" := recVend."GST Registration No."
                END ELSE
                    "Transporter Name" := '';
            end;
        }
        field(50001; "Transporter Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Port Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Transporter GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50004; "Jobwork PO"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            TableRelation = "Purchase Header"."No.";

            trigger OnValidate()
            begin
                //acxcp
                recTransferHeader.RESET();
                recTransferHeader.SETRANGE("No.", "Jobwork PO");
                IF recTransferHeader.FINDFIRST THEN
                    ERROR('PO No. already been used against Transfer Order No.%1', recTransferHeader."No.");

                recTransShipH.RESET();
                recTransShipH.SETRANGE("Transfer Order No.", "Jobwork PO");
                IF recTransShipH.FINDFIRST THEN
                    ERROR('PO No. already been used against Transfer Shipment No.%1', recTransShipH."No.");
                //acxcp
            end;
        }
        field(50005; "Transfer-from Bin Code"; Code[20])
        {
            Caption = 'Transfer-from Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Transfer-from Code"));

            trigger OnValidate()
            var
                recLoc: Record 14;
            begin
                IF "Transfer-from Bin Code" <> xRec."Transfer-from Bin Code" THEN BEGIN
                    TESTFIELD("Transfer-from Code");
                    IF "Transfer-from Bin Code" <> '' THEN BEGIN
                        GetLocation("Transfer-from Code");
                        Location.TESTFIELD("Bin Mandatory");
                        Location.TESTFIELD("Directed Put-away and Pick", FALSE);
                        GetBin("Transfer-from Code", "Transfer-from Bin Code");
                        TESTFIELD("Transfer-from Code", Bin."Location Code");
                        //HandleDedicatedBin(TRUE);
                    END;
                END;
            end;
        }
        field(50006; "Transfer-To Bin Code"; Code[20])
        {
            Caption = 'Transfer-To Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-to Code"));

            trigger OnValidate()
            var
                recLoc: Record 14;
            begin
                IF "Transfer-To Bin Code" <> xRec."Transfer-To Bin Code" THEN BEGIN
                    TESTFIELD("Transfer-to Code");
                    IF "Transfer-To Bin Code" <> '' THEN BEGIN
                        GetLocation("Transfer-to Code");
                        Location.TESTFIELD("Bin Mandatory");
                        Location.TESTFIELD("Directed Put-away and Pick", FALSE);
                        GetBin("Transfer-to Code", "Transfer-To Bin Code");
                        TESTFIELD("Transfer-to Code", Bin."Location Code");
                    END;
                END;
            end;
        }
        field(50007; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Description = 'KM';
            TableRelation = "Responsibility Center";
        }
        field(50008; ExpiryStockMovementAllowed; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AcxVG';
        }
    }



    trigger OnAfterInsert()
    begin
        //KM
        UserSetup.SETRANGE("User ID", USERID);
        IF UserSetup.FINDFIRST THEN
            VALIDATE("Responsibility Center", UserSetup."Sales Resp. Ctr. Filter");
        //KM
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        IF Location.Code <> LocationCode THEN
            Location.GET(LocationCode);
    end;

    local procedure GetBin(LocationCode: Code[10]; BinCode: Code[20])
    begin
        IF BinCode = '' THEN
            CLEAR(Bin)
        ELSE
            IF Bin.Code <> BinCode THEN
                Bin.GET(LocationCode, BinCode);
    end;

    local procedure HandleDedicatedBin(IssueWarning: Boolean)
    var
        WhseIntegrationMgt: Codeunit 7317;
    begin
        //IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
        //WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Transfer-from Code","Transfer-from Bin Code",IssueWarning);
    end;

    local procedure TransferStructure(FromLoc: Code[20]; ToLoc: Code[20]) tStructure: Code[10]
    var
        recTransferRoute: Record 5742;
    begin
        recTransferRoute.RESET();
        recTransferRoute.SETRANGE("Transfer-from Code", FromLoc);
        recTransferRoute.SETRANGE("Transfer-to Code", ToLoc);
        IF recTransferRoute.FINDFIRST THEN
            tStructure := recTransferRoute.Structure;
    end;

    var
        recVend: Record 23;
        recTransShipH: Record 5744;
        recTransferHeader: Record 5740;
        Location: Record 14;
        Bin: Record 7354;
        UserSetup: Record 91;
        tStructure: Code[10];
        FromState: Code[10];
        ToState: Code[10];
}

