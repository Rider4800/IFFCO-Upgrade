table 50008 "ACX Price Discount Structdure"
{

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //12887 table is removed TableRelation = "Tax/Charge Group".Code;

            trigger OnValidate()
            begin
                /*12887 table is removed ---->
                recTaxcode.RESET();
                recTaxcode.SETRANGE(Code, "Tax Code");
                IF recTaxcode.FINDFIRST THEN BEGIN
                    "Tax Name" := recTaxcode.Description;
                    VALIDATE("Markup Category", recTaxcode."Calculation Type");
                END ELSE
                "Tax Name" := '';
                <----12887 table is removed */
            end;
        }
        field(3; "Tax Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Taxable Basis"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Line Item","Exclusive Line Amt.",MRP;
        }
        field(5; "Derived For"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Price,Sales,Purchase,"Purchase/Sales",NRV,"NRV Value";
        }
        field(6; "Price Inclusive Tax"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Calc Exp."; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "State Wise"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Accural Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Include In Accrual"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Discount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Structure Line Discount"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Markup Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Percentage,"Amount Per Qty","Fixed Value";
        }
        field(15; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Price Disc. Header".Code;
        }
        field(16; "Sales Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Price Disc. Header"."Sales Code";
        }
    }

    keys
    {
        key(Key1; ID, "Tax Code")
        {
            Clustered = true;
        }
        key(Key2; "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(FiledGroup; "Tax Code", "Tax Name")
        {
        }
    }

    var
    //12887 table is removed recTaxcode: Record 13790;
}

