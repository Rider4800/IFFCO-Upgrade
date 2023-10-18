tableextension 50078 tableextension50078 extends Bin
{
    fields
    {
        field(50000; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE("No." = FIELD(Code));
        }
    }
}

