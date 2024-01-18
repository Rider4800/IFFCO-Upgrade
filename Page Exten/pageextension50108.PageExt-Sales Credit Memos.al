pageextension 50108 pageextension50108 extends "Sales Credit Memos"
{
    layout
    {
        // moveafter("Bill-to Customer No."; Amount)
        // addafter(Amount)
        // {
        //     field("Amount to Customer"; Cu50200.AmttoCustomer(Rec))//12887 "Amount to Customer" field is removed
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        // addafter("Salesperson Code")
        // {
        //     field("Reason Code"; Rec."Reason Code")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
    }
    actions
    {
        addafter("Remove From Job Queue")
        {
            action("Upload Item Charge Assig. Sale")
            {
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = All;
                RunObject = Report 50009;
            }
        }
    }
    var
        Cu50200: Codeunit 50200;
}

