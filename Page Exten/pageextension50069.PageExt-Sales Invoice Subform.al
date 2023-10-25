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
        //12887----> change in table field property Ediatble is handeled here as this is not allowed in table extension
        modify("Qty. to Invoice")
        {
            Editable = false;
        }

        //12887<---- change in table field property Ediatble is handeled here as this is not allowed in table extension
    }
}

