tableextension 50067 tableextension50067 extends "Transfer Route"
{
    fields
    {
        field(50000; Structure; Code[10])
        {
            DataClassification = ToBeClassified;
            //12887 table is removed TableRelation = "Structure Header";
        }
        field(50001; "GST Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

