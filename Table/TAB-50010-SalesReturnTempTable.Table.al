table 50010 "Sales Return Temp Table"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Credit Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Invoice Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Item Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Product Group"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "GST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Type; Text[30])
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
        key(Key2; "Credit Note No.", "Invoice Ref No.", "Item No.", "Product Group")
        {
        }
    }

    fieldgroups
    {
    }
}

