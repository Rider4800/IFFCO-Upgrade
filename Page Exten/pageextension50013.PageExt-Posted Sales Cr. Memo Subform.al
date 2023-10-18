pageextension 50013 pageextension50013 extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Description2; Rec."Description 2")
            {
                Caption = 'Description 2';
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Excess/Short Qty."; Rec."Excess/Short Qty.")
            {
            }
        }
    }
}

