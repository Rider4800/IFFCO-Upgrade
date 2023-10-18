pageextension 50064 pageextension50064 extends "Sales Credit Memo"
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
        moveafter("Finance Branch A/c Code"; "Reason Code")
        moveafter("Job Queue Status"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
}

