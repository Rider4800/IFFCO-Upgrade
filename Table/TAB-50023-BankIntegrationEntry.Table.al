table 50023 "Bank Integration Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'N,C,D,I,H,R';
            OptionMembers = N,C,D,I,H,R;
        }
        field(3; "Beneficiary Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Beneficiary Account Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            Width = 30;
        }
        field(5; "Instrument Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Beneficiary Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Drawee Location"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Print Location"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Bene Address 1"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Bene Address 2"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Bene Address 3"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Bene Address 4"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Bene Address 5"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Instruction Reference Number"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Customer Reference Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Payment details 1"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Payment details 2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Payment details 3"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Payment details 4"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Payment details 5"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Payment details 6"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Payment details 7"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Cheque Number"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Chq / Trn Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "MICR Number"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "IFC Code"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Bene Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Bene Bank Branch Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Beneficiary email id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Created By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Created DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(32; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Closed,Finish';
            OptionMembers = New,Closed,Finish;
        }
        field(33; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50000; "Bank Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Instrument Amount.."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Instrument Amount."; Decimal)
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
}

