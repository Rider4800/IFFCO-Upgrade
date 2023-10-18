table 50006 "ACX Credit Note Schemes"
{

    fields
    {
        field(1; "Credit Not Scheme Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Regular,Schduled,"Super Cash",All;
        }
        field(2; "Security Center Codes"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Advance Scheme"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Credit Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Description; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Exclusive; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "From Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Inventory Location ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(10; "Inentory Site ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Payment From Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Payment To Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Price Group ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Scheme Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Release,Canceled,Blocked,Closed;
        }
        field(17; "To Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Credit Not Scheme Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

