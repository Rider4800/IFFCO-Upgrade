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

