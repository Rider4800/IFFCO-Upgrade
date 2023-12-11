table 50050 "Upgrade Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Table ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "",Processed,"Not Processed";
        }
        field(4; "Record Exist"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}