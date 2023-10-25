pageextension 50067 pageextension50067 extends "Sales Order Subform"
{
    layout
    {
        modify("Invoice Discount Amount")
        {
            Editable = true;
        }
        moveafter("Substitution Available"; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        //12887----> change in table field property Ediatble is handeled here as this is not allowed in table extension
        modify("Qty. to Invoice")
        {
            Editable = false;
        }
        modify("Qty. to Ship")
        {
            Editable = false;
        }
        //12887<---- change in table field property Ediatble is handeled here as this is not allowed in table extension
    }
    actions
    {
        addafter("Select Nonstoc&k Items")
        {
            action("Get Scheme Discount")
            {
                Image = Discount;
                RunObject = Page 50029;
                RunPageLink = "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
        }
    }
}

