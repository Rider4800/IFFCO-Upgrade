table 50004 "Bank Statement Upload"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Dr/CR"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Entry Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Value date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Product; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Party Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Party Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Virtual Account Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Locations; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Remitting Bank"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "UTR No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Remitter Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Remitter Account No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Region Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Branch Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Validated,Error,Created,Posted';
            OptionMembers = New,Validated,Error,Created,Posted;
        }
        field(17; "Pre Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Posted Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Error Message"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Uploaded By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Uploaded Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Uploaded Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Modified By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Modified Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Modified By" := USERID;
        "Modified Date" := TODAY;
        "Modified Time" := TIME;
    end;
}

