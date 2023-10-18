pageextension 50074 pageextension50074 extends "Salesperson/Purchaser Card"
{
    layout
    {
        modify("Job Title")
        {
            Visible = false;
        }

        addafter(Name)
        {
            field("Designation Code"; Rec."Designation Code")
            {
            }
            field("Designation Name"; Rec."Designation Name")
            {
            }
            field("Salesperson Type"; Rec."Salesperson Type")
            {
            }
        }
        moveafter("Salesperson Type"; "Phone No.")
    }
}

