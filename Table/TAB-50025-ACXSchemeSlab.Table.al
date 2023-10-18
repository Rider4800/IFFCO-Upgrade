table 50025 "ACX Scheme Slab"
{

    fields
    {
        field(1; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Sales Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Customer,Customer Posting Group,All Customer';
            OptionMembers = " ",Customer,"Customer Posting Group","All Customer";
        }
        field(6; "Sales Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST("Customer Posting Group")) "Customer Posting Group";
        }
        field(7; "Sales Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "From Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "CD%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Scheme Code", "Effective Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

