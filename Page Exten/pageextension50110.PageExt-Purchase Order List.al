pageextension 50110 pageextension50110 extends "Purchase Order List"
{
    layout
    {
        addafter("Purchaser Code")
        {
            field("Creation DateTime"; rec."Creation DateTime")
            {
            }
        }
    }
    actions
    {
        addafter("Prepayment Credi&t Memos")
        {
            action("Purchase Order Status")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page 50014;
                RunPageMode = View;
            }
            action("PO Detail Status")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page 50017;
                RunPageMode = View;
            }
        }
    }
}

