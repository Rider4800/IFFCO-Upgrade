pageextension 50069 pageextension50069 extends "Sales Invoice Subform"
{
    layout
    {
        moveafter(Description; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Unit of Measure"; "Qty. to Invoice")
        addafter("Qty. to Invoice")
        {
            field("Quantity Invoiced"; Rec."Quantity Invoiced")
            {
            }
        }
    }
}

