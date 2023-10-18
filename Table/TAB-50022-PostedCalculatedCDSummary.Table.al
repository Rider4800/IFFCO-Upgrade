table 50022 "Posted Calculated CD Summary"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Order Priority"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Super Cash",Regular,Placement;
        }
        field(4; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Invoince Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Invoice Amt. Exclud GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Taxes & Charges Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Adjusted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Adjusted Amount With Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Invoice CD Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "CD Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Total Eligible CD on Invoice';
        }
        field(14; "CD Calculated On Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Invoice amout without tax+ scheme CD on invoice';
        }
        field(15; "CD Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Rate of CD"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "CD to be Given"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Date; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'CD Genration Date';
        }
        field(19; "Payment No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Posted Credit Note ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Posted Credit Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            DataClassification = ToBeClassified;
        }
        field(25; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(27; "CD Voucher Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Customer Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Credit Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Dt. Cust. Led. Entry"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "State Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'GD1';
        }
        field(33; "Warehouse code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'GD2';
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Payment No.", "Dt. Cust. Led. Entry")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

