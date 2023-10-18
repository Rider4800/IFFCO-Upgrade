table 50009 "ACX Credit Note SC Code Master"
{

    fields
    {
        field(1; Description; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Price Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

