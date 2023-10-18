pageextension 50033 pageextension50033 extends "Contra Voucher"
{
    layout
    {
        addafter("VAT Bus. Posting Group")
        {
            field("LocationCode"; Rec."Location Code")
            {
                Caption = 'Location Code';
            }
        }
        addafter("Bal. Account Type")
        {
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
    }
}

