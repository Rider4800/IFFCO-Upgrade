pageextension 50110 pageextension50110 extends "Purchase Order List"
{
    layout
    {
        addafter("Purchaser Code")
        {
            field("Creation DateTime"; rec."Creation DateTime")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
            }
            //->17783
            action("Update Older POs & SOs")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CU50015: Codeunit 50015;
                begin
                    CU50015.Run();
                end;
            }
            action("PO Detail Status")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page 50017;
                RunPageMode = View;
                ApplicationArea = All;
            }
        }
    }
}

