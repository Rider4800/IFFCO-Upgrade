pageextension 50037 pageextension50037 extends "Bank Payment Voucher"
{
    layout
    {
        addbefore("External Document No.")
        {
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
        addafter("Check Printed")
        {
            field(PayerInformation; Rec."Payer Information")
            {
                Caption = 'Payer Information';
            }
        }
    }
}

