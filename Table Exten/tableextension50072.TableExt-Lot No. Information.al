tableextension 50072 tableextension50072 extends "Lot No. Information"
{
    // //acxcp_240422+ //Mfg validation and Check existing Batch MRP
    fields
    {
        field(50000; "MFG Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';

            trigger OnValidate()
            begin
                //acxcp_240422+ //Mfg validation
                IF "MFG Date" > TODAY() THEN
                    ERROR('MFG Date should be less then current date');
                //acxcp_240422-
            end;
        }
        field(50001; "Batch MRP"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';

            trigger OnValidate()
            begin
                //acxcp_240422+ //Check existing Batch MRP
                IF xRec."Batch MRP" <> 0 THEN
                    IF xRec."Batch MRP" <> Rec."Batch MRP" THEN
                        ERROR('Old Batch MRP is %1 and New Batch MRP is %2 is not matched', xRec."Batch MRP", Rec."Batch MRP")
                //acxcp_240422-
            end;
        }
        field(50002; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-KM';
        }
        field(50004; "Opening Filter"; Date)
        {
            Description = 'ACXBASE';
            FieldClass = FlowFilter;
        }
        field(50005; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Description = 'ACXBASE';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50006; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Description = 'ACXBASE';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50007; "Opening Balance"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Posting Date" = FIELD("Opening Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Lot No." = FIELD("Lot No.")));
            Description = 'ACXBASE';
            FieldClass = FlowField;
        }
        field(50008; Increases; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  Positive = CONST(true),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Posting Date" = FIELD("Opening Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Lot No." = FIELD("Lot No.")));
            Description = 'ACXBASE';
            FieldClass = FlowField;
        }
        field(50009; Decreases; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                   Positive = CONST(false),
                                                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                   "Posting Date" = FIELD("Opening Filter"),
                                                                   "Location Code" = FIELD("Location Filter"),
                                                                   "Lot No." = FIELD("Lot No.")));
            Description = 'ACXBASE';
            FieldClass = FlowField;
        }
        field(50010; "Closing Balance"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Posting Date" = FIELD("Opening Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Lot No." = FIELD("Lot No.")));
            Description = 'ACXBASE';
            FieldClass = FlowField;
        }
    }
    keys
    {
    }

    var
        recReservationEntry: Record 337;
        recItem: Record 27;
        recTrackingSpecification: Record 336;
}

