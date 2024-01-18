pageextension 50064 pageextension50064 extends "Sales Credit Memo"
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
        movebefore(Status; "Reason Code")
        moveafter("Job Queue Status"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
}

