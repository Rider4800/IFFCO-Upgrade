tableextension 50043 tableextension50043 extends "No. Series"
{
    fields
    {
        field(50000; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Description = 'Acx-KM';
            TableRelation = "Responsibility Center";
        }
    }
}

