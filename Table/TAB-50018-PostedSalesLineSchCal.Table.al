table 50018 "Posted SalesLine Sch. Cal."
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Scheme Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Item Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Tax Charge Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Scheme Calculation Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Percentage,Amount Per Qty,Fixed Value';
            OptionMembers = Percentage,"Amount Per Qty","Fixed Value";
        }
        field(11; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Item,Item Discount Group,All Item';
            OptionMembers = Item,"Item Discount Group","All Item";
        }
        field(12; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Line Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Line Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Free Item Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(19; "OrderPriority Scheme"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Super Cash",Regular,Placement;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Line No.", "Tax Charge Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

