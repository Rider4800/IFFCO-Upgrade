tableextension 50006 tableextension50006 extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000; "Excess/Short Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Exported to Sales Register"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXBase';
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

