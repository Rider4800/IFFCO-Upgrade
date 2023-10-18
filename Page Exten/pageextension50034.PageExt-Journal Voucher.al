pageextension 50034 pageextension50034 extends "Journal Voucher"
{
    layout
    {
        addafter("Debit Amount")
        {
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
    }
}

