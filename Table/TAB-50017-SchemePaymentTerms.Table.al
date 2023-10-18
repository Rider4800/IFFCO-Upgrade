table 50017 "Scheme Payment Terms"
{

    fields
    {
        field(1; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Sales Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Customer,"Customer Discount Group","All Customer";

            trigger OnValidate()
            begin
                "Sales Code" := '';
                "Sales Description" := '';
            end;
        }
        field(4; "Sales Code"; Code[40])
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
        field(5; "Sales Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Type; Option)
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
        field(7; "Code"; Code[40])
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
        field(8; "Product Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Fixed Credit Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Credit Payment Term"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }
        field(11; "Fixed Cash Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Release,Cancelled,Blocked,Closed';
            OptionMembers = Open,Release,Cancelled,Blocked,Closed;
        }
        field(13; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "ACX Schemes";
        }
    }

    keys
    {
        key(Key1; "Scheme Code", "Starting Date")
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

