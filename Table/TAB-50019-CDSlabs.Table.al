table 50019 "CD Slabs"
{

    fields
    {
        field(1; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
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
        field(4; "Sales Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "From Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "CD%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; SchemeType; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "1";
        }
    }

    keys
    {
        key(Key1; "Effective Date", "Sales Type", "Sales Code", "From Days", "CD%")
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
}

