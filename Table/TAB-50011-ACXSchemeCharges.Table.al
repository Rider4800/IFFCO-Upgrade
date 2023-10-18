table 50011 "ACX Scheme Charges"
{

    fields
    {
        field(1; "Scheme Code"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";
        }
        field(2; "Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Price Discount Structdure"."Tax Code";

            trigger OnValidate()
            begin
                recTaxCharge.RESET();
                recTaxCharge.SETRANGE("Tax Code", "Tax Code");
                IF recTaxCharge.FINDFIRST THEN BEGIN
                    VALIDATE("Scheme Calculation Type", recTaxCharge."Markup Category");
                    "Link To Column" := recTaxCharge.ID
                END;
            end;
        }
        field(3; "Scheme Calculation Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Percentage,"Amount Per Qty","Fixed Value";
        }
        field(4; "Link To Column"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created By"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Created Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Modified By"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Modified Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Scheme Code", "Tax Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Created Date Time" := CURRENTDATETIME;
    end;

    trigger OnModify()
    begin
        "Modified By" := USERID;
        "Modified Date Time" := CURRENTDATETIME;
    end;

    var
        recTaxCharge: Record 50008;
}

