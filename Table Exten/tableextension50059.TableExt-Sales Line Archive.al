tableextension 50059 tableextension50059 extends "Sales Line Archive"
{
    fields
    {
        field(50000; "Excess/Short Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";
        }
        field(50003; "Free Scheme Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "No. of Loose Pack"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}

