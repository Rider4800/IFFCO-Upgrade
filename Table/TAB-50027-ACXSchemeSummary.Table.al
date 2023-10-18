table 50027 "ACX Scheme Summary"
{

    fields
    {
        field(1; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(3; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Order Priority"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Super Cash",Regular,Placement;
        }
        field(6; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Invoice Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Invoice Amt. Exclud GST"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Taxes & Charges Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Adjusted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Adjusted Amount With Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Invoice CD Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "CD Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Total Eligible CD on Invoice';
        }
        field(16; "CD Calculated On Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Invoice amout without tax+ scheme CD on invoice';
        }
        field(17; "CD Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Rate of CD"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "CD to be Given"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;
        }
        field(20; "CD Generation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'CD Genration Date';
        }
        field(21; "Payment No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Posted Credit Note ID"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Credit Note No.");
            end;
        }
        field(25; "Posted Credit Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
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
        field(30; "Cust. Led. Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Taxes & Charges Amt Adj"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Tax Adj Amt for payment';
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
        field(34; IsCalculated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Amount Excluded Item"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Amount Excl. Item Adj"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Invoice Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Credit Memo,Return Order';
            OptionMembers = Invoice,"Credit Memo","Return Order";
        }
        field(39; "GST Amount Excluded Item"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Net Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(41; Blocked; Enum CustomerBlockedFieldEnum)
        {
            CalcFormula = Lookup(Customer.Blocked WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Scheme Code", "Payment No.", "Customer No.", "Invoice No.", "Cust. Led. Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Credit Note No.", '');
        //TESTFIELD("Payment Date",'');
    end;
}

