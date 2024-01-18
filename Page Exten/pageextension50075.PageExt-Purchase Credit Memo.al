pageextension 50075 pageextension50075 extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Branch Accounting"; Rec."Branch Accounting")
            {
                ApplicationArea = All;
            }
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter(Status; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
}

