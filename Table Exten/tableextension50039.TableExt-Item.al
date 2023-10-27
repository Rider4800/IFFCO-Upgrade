tableextension 50039 tableextension50039 extends Item
{
    // //ACXCP02 //Creation Date and Time capture
    fields
    {
        //->Team-17783
        modify(Inventory)
        {
            trigger OnAfterValidate()
            begin
                Rec.CALCFIELDS(Inventory);
                recItemUOM.RESET();
                recItemUOM.SETRANGE(Code, Rec."Sales Unit of Measure");
                IF recItemUOM.FINDFIRST THEN BEGIN
                    Rec."Opening Balance Qty. in KG" := recItemUOM."Qty. per Unit of Measure" * Rec.Inventory
                END;
            end;
        }
        //<-Team-17783
        field(50000; "Opening Balance Qty. in KG"; Decimal)
        {
            Caption = 'Opening Balance Qty. in KG';
            Description = 'ACX-RK';
            Editable = false;
            FieldClass = Normal;
        }
        field(50001; "Track Date of Manufacturing"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Manufacturing Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50003; "CIB Registration"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50004; "P2P Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50005; "Opening Balance"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  "Location Code" = FIELD("Location Filter")));
            Description = 'ACXBASE';
            FieldClass = FlowField;
        }
        field(50006; "Closing Balance"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                  "Location Code" = FIELD("Location Filter")));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; Increases; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  Positive = CONST(true),
                                                                  "Location Code" = FIELD("Location Filter")));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; Decreases; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  Positive = CONST(false),
                                                                  "Location Code" = FIELD("Location Filter")));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Opening Filter"; Date)
        {
            Description = 'ACXBASE';
            FieldClass = FlowFilter;
        }
        field(50010; "Technical Name"; Text[200])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50011; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(50012; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'acxcp';
        }
        //->Team-17783  New field Added as MRP price is std field in NAV, so to use in BC, we created it
        field(50013; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //<-Team-17783
    }

    trigger OnAfterInsert()
    begin
        //ACXCP02+
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP02-
    end;

    var
        recItemUOM: Record "Item Unit of Measure";
        OpeningBal_Caption: Text;
}

