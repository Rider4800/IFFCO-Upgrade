pageextension 50038 pageextension50038 extends "Cash Receipt Voucher"
{
    layout
    {
        addafter("T.A.N. No.")
        {
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
    }
}

