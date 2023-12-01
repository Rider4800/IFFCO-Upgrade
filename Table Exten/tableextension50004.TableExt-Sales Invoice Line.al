tableextension 50004 tableextension50004 extends "Sales Invoice Line"
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
            Description = 'ACXBASE';
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
        //->Team-17783  New field Added as MRP price is std field in NAV, so to use in BC, we created it
        field(50006; "MRP Price New"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //<-Team-17783
    }
}

