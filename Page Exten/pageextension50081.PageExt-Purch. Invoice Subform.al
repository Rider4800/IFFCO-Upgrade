pageextension 50081 pageextension50081 extends "Purch. Invoice Subform"
{
    layout
    {
        moveafter("Location Code"; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        addafter("Line Amount")
        {
            field("Salvage Value"; rec."Salvage Value")
            {
            }
        }
        addafter("Line No.")
        {
            field("Short Quantity Remark"; rec."Short Quantity Remark")
            {
            }
        }
    }
}

