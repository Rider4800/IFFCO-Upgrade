table 50007 "ACX Price Disc. Header"
{

    fields
    {
        field(1; "Sales Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Customer,"Customer Discount Group","All Customer";
        }
        field(2; "Code"; Code[20])
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
                        "Item Name" := recItem.Description;
                END ELSE
                    IF Type = Type::Item THEN BEGIN
                        recItemDisc.RESET();
                        recItemDisc.SETRANGE(Code, Code);
                        IF recItemDisc.FINDFIRST THEN
                            "Item Name" := recItemDisc.Description;
                    END;
            end;
        }
        field(3; "Item Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Sales Code"; Code[20])
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
        field(5; "Sales Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Release,Cancelled,Blocked,Closed;
        }
        field(7; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Item,"Item Discount Group","All Item";
        }
        field(8; "S.No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Sales Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recCustomer: Record 18;
        recCustDisc: Record 340;
        recItem: Record 27;
        recItemDisc: Record 341;
}

