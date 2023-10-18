table 50028 "ACX Scheme"
{

    fields
    {
        field(1; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "OrderPriority Scheme"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Super Cash",Regular,Placement;
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
        field(22; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(23; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code WHERE("State Code" = FIELD("State Code"));
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
        fieldgroup(FiledGroup; Description, "OrderPriority Scheme")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Created Date Time" := CURRENTDATETIME;
    end;

    trigger OnModify()
    begin
        "Modified By" := USERID;
        "Modified Date Time" := CURRENTDATETIME;
    end;

    trigger OnRename()
    begin
        "Modified By" := USERID;
        "Modified Date Time" := CURRENTDATETIME;
    end;

    local procedure DateValidation()
    begin
        IF "From Date" < "Scheme Date" THEN
            ERROR('From Date not less then Scheme Date');
        IF ("To Date" <> 0D) AND ("To Date" < "From Date") THEN
            ERROR('To Date not less then From Date');
    end;
}

