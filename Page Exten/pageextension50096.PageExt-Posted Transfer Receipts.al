pageextension 50096 pageextension50096 extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("Shipping Agent Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action("<Jobwork Receipt Register>")
            {
                Caption = 'Jobwork Receipt Register';
                Image = ListPage;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50016;
                RunPageMode = View;
            }
        }
    }
}

