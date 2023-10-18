pageextension 50031 pageextension50031 extends "GST Ledger Entry"
{
    layout
    {
        addafter("POS Out Of India")
        {
            field("Input Service Distribution"; Rec."Input Service Distribution")
            {
            }
        }
    }
}

