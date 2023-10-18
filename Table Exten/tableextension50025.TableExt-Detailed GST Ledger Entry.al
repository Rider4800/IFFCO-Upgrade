tableextension 50025 tableextension50025 extends "Detailed GST Ledger Entry"
{
    fields
    {
        field(50000; "GSTled Input Service Dist."; Boolean)
        {
            CalcFormula = Lookup("GST Ledger Entry"."Input Service Distribution" WHERE("Document No." = FIELD("Document No."),
                                                                                        "Transaction No." = FIELD("Transaction No.")));
            FieldClass = FlowField;
        }
    }
}

