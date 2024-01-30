pageextension 50004 pageextension50004 extends "General Ledger Setup"
{
    layout
    {
        addafter("Print VAT specification in LCY")
        {
            field("Bank Code"; Rec."Bank Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bank Code")
        {
            field("E-Mail CC"; Rec."E-Mail CC")
            {
                ApplicationArea = All;
            }
        }
    }
}

