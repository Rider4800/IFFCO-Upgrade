table 50003 "Response Logs"
{
    // //HT (For E-Way Bill and E-Invoice Integration)


    fields
    {
        field(1; "Rec ID"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Document No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Status; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Response Log 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Response Log 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Response Log 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Response Log 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Response Log 5"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Response Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Response Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Called API"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Response Log 6"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Response Log 7"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Response Log 8"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Response Log 9"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Response Log 10"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Response Log 11"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Response Log 12"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Response Log 13"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Response Log 14"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Response Log 15"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Response Log 16"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Rec ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

