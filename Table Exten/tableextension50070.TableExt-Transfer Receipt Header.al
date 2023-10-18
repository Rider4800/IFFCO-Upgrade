tableextension 50070 tableextension50070 extends "Transfer Receipt Header"
{
    fields
    {
        field(50000; "Transporter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE(Transporter = FILTER(true));
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
        field(50005; "Transfer-from Bin Code"; Code[20])
        {
            Caption = 'Transfer-from Bin Code';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-from Code"));

            trigger OnValidate()
            var
                recLoc: Record 14;
            begin
                recLoc.GET("Transfer-from Code");
                recLoc.TESTFIELD("Bin Mandatory");
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
                recLoc.GET("Transfer-to Code");
                recLoc.TESTFIELD("Bin Mandatory");
            end;
        }
        field(50007; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Description = 'KM';
            TableRelation = "Responsibility Center";
        }
    }
}

