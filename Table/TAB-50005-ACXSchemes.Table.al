table 50005 "ACX Schemes"
{

    fields
    {
        field(1; "OrderPriority Scheme"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Super Cash",Regular,Placement;
        }
        field(2; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Scheme Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                DateValidation;
            end;
        }
        field(5; "From Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                DateValidation;
            end;
        }
        field(6; "To Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                DateValidation;
            end;
        }
        field(7; Exclusive; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Credit Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Inventory Location ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(10; "Inventory Site ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Inventory Location ID"));
        }
        field(11; "Payment From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Payment To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Price Group ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Security Center Codes"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Advance Scheme"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Release,Cancled,Blocked,Closed;
        }
        field(17; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Created By"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Created Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Modified By"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Modified Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "General Journal Templates"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(23; "General Journal Batches"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("General Journal Templates"));
        }
        field(24; "GL Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Scheme Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(FiledGroup; "Scheme Code", Description)
        {
        }
    }

    local procedure DateValidation()
    begin
        IF "From Date" < "Scheme Date" THEN
            ERROR('From Date not less then Scheme Date');
        IF ("To Date" <> 0D) AND ("To Date" < "From Date") THEN
            ERROR('To Date not less then From Date');
    end;
}

