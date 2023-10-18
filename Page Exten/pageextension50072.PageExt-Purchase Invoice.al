pageextension 50072 pageextension50072 extends "Purchase Invoice"
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
        addafter("Payment Method Code")
        {
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
            }
        }
        moveafter(Status; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
}

