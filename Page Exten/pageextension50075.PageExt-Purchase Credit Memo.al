pageextension 50075 pageextension50075 extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Branch Accounting"; Rec."Branch Accounting")
            {
            }
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
        moveafter(Status; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
}

