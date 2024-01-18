pageextension 50072 pageextension50072 extends "Purchase Invoice"
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
        addafter("Payment Method Code")
        {
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter(Status; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
}

