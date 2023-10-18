table 50029 "Check Inv. for Sch.Eligibility"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Item,Product Group,All Item';
            OptionMembers = Item,"Product Group","All Item";
        }
        field(5; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Calculated Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; IsCD; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "From Date", "To Date", "Code", "Calculated Percent")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

