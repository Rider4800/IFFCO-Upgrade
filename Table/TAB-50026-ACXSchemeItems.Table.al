table 50026 "ACX Scheme Items"
{

    fields
    {
        field(1; "Scheme Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";

            trigger OnValidate()
            begin
                IF "Scheme Code" <> '' THEN BEGIN
                    recSchemeMstr.SETRANGE("Scheme Code", "Scheme Code");
                    IF recSchemeMstr.FINDFIRST THEN
                        "Starting Date" := recSchemeMstr."From Date";
                    "Ending Date" := recSchemeMstr."To Date";
                END;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Sales Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Customer,Customer Posting Group,All Customer';
            OptionMembers = " ",Customer,"Customer Posting Group","All Customer";

            trigger OnValidate()
            begin
                //"Sales Description":='';
            end;
        }
        field(5; "Sales Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST("Customer Posting Group")) "Customer Posting Group";
        }
        field(6; "Sales Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Item,Product Group,All Item';
            OptionMembers = Item,"Product Group","All Item";

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
            IF (Type = CONST("Product Group")) "Item Category".Code where("Parent Category" = filter(<> ''));//12887 alternative of product group
            // 12887 table is removed IF (Type = CONST("Product Group")) "Product Group".Code;

            trigger OnValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    recItem.RESET();
                    recItem.SETRANGE("No.", Code);
                    IF recItem.FINDFIRST THEN
                        "Product Name" := recItem.Description;
                END ELSE
                    IF Type = Type::"Product Group" THEN BEGIN
                        recProdGroup.RESET();
                        recProdGroup.SETRANGE(Code, Code);
                        IF recProdGroup.FINDFIRST THEN
                            "Product Name" := recProdGroup.Description;
                    END;
            end;
        }
        field(9; "Product Name"; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Minimum Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateMinQty;
            end;
        }
        field(11; "MRP Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Scheme Calculation Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Percentage,"Amount Per Qty.","Fixed Value";
        }
        field(15; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Release,Cancelled,Blocked,Closed;
        }
        field(16; Excluded; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(18; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(19; "Included Under Scheme"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateMinQty;
            end;
        }
    }

    keys
    {
        key(Key1; "Scheme Code", "Code")
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
        recSchemeMstr: Record 50005;
        recProdGroup: Record "Item Category";
        ACXSchemeItems: Record 50026;
        decMinQty: Decimal;

    local procedure UpdateMinQty()
    begin
        decMinQty := 0;
        ACXSchemeItems.RESET;
        ACXSchemeItems.SETRANGE("Scheme Code", Rec."Scheme Code");
        ACXSchemeItems.SETFILTER("Included Under Scheme", '%1', TRUE);
        ACXSchemeItems.SETFILTER("Minimum Quantity", '>%1', 0);
        ACXSchemeItems.SETFILTER(Excluded, '%1', FALSE);
        IF ACXSchemeItems.FINDSET THEN
            decMinQty := ACXSchemeItems."Minimum Quantity";

        ACXSchemeItems.RESET;
        ACXSchemeItems.SETRANGE("Scheme Code", Rec."Scheme Code");
        ACXSchemeItems.SETFILTER("Included Under Scheme", '%1', TRUE);
        ACXSchemeItems.SETFILTER("Minimum Quantity", '>%1', 0);
        ACXSchemeItems.SETFILTER(Excluded, '%1', FALSE);
        IF ACXSchemeItems.FINDSET THEN BEGIN
            REPEAT
                Rec."Minimum Quantity" := decMinQty;
                Rec.MODIFY;
            UNTIL ACXSchemeItems.NEXT = 0;
        END;
    end;
}

