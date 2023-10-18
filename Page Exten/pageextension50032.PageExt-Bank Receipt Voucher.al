pageextension 50032 pageextension50032 extends "Bank Receipt Voucher"
{
    layout
    {
        addbefore("T.A.N. No.")
        {
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
    }
}

