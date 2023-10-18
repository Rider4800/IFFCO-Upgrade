table 50012 "ACX Scheme Sales Line Discount"
{

    fields
    {
        field(1; "Discount Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Order Discount","Invoice Discount";
        }
        field(2; "Sales Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Customer,"Customer Discount Group","All Customer";

            trigger OnValidate()
            begin
                "Sales Code" := '';
                "Sales Description" := '';
            end;
        }
        field(3; "Sales Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST("Customer Discount Group")) "Customer Discount Group";

            trigger OnValidate()
            begin
                IF "Sales Type" = "Sales Type"::Customer THEN BEGIN
                    recCustomer.RESET();
                    recCustomer.SETRANGE("No.", "Sales Code");
                    IF recCustomer.FINDFIRST THEN
                        "Sales Description" := recCustomer.Name;
                END ELSE
                    IF "Sales Type" = "Sales Type"::"Customer Discount Group" THEN BEGIN
                        recCustDisc.RESET();
                        recCustDisc.SETRANGE(Code, "Sales Code");
                        IF recCustDisc.FINDFIRST THEN
                            "Sales Description" := recCustDisc.Description;
                    END;
            end;
        }
        field(4; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Sales Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Item,Item Discount Group,All Item';
            OptionMembers = Item,"Item Discount Group","All Item";

            trigger OnValidate()
            begin
                Code := '';
                "Product Name" := '';
            end;
        }
        field(8; "Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("Item Discount Group")) "Item Discount Group";

            trigger OnValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    recItem.RESET();
                    recItem.SETRANGE("No.", Code);
                    IF recItem.FINDFIRST THEN
                        "Product Name" := recItem.Description;
                END ELSE
                    IF Type = Type::"Item Discount Group" THEN BEGIN
                        recItemDisc.RESET();
                        recItemDisc.SETRANGE(Code, Code);
                        IF recItemDisc.FINDFIRST THEN
                            "Product Name" := recItemDisc.Description;
                    END;
            end;
        }
        field(9; "Product Name"; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Combination Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Code",Group;
        }
        field(11; "Item Combination Group"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Tax Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Scheme Charges"."Tax Code" WHERE("Scheme Code" = FIELD("Scheme Code"));

            trigger OnValidate()
            begin
                recSCHCharge.RESET();
                recSCHCharge.SETRANGE("Scheme Code", "Scheme Code");
                recSCHCharge.SETRANGE("Tax Code", "Tax Charge Code");
                IF recSCHCharge.FINDFIRST THEN BEGIN
                    VALIDATE("Scheme Calculation Type", recSCHCharge."Scheme Calculation Type");
                    "Link to Column" := recSCHCharge."Link To Column";
                END;
            end;
        }
        field(13; "Free Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(14; "Free UOM"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Sales UOM",Discount;
        }
        field(15; "From Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "To Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Line Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Minimum Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "MRP Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Payment Term ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }
        field(21; "Previous From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Pervious To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Scheme Code"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";
        }
        field(25; "Scheme From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Scheme To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Scheme Calculation Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Percentage,"Amount Per Qty.","Fixed Value";
        }
        field(28; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Release,Cancelled,Blocked,Closed;
        }
        field(29; Exclusive; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Tax Charge Group"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Link to Column"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Currency Code"; Code[6])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Discount Type", "Ending Date", "To Days", "From Days", "Scheme Code", "Scheme From Date", "Starting Date", "Sales Type", "Sales Code", Type, "Code", "Item Combination Group", "Tax Charge Code", "Minimum Quantity")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recSCHCharge: Record 50011;
        recCustomer: Record 18;
        recCustDisc: Record 340;
        recItem: Record 27;
        recItemDisc: Record 341;
}

