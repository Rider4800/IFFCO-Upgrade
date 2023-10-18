pageextension 50113 pageextension50113 extends "Sales Cr. Memo Subform"
{
    layout
    {
        moveafter("Line Amount"; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Excess/Short Qty."; Rec."Excess/Short Qty.")
            {
            }
        }
    }
}

