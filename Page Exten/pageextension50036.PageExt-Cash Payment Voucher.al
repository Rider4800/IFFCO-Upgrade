pageextension 50036 pageextension50036 extends "Cash Payment Voucher"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
    }
}

