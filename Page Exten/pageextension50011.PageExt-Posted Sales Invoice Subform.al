pageextension 50011 pageextension50011 extends "Posted Sales Invoice Subform"
{
    layout
    {
        addbefore("Allow Invoice Disc.")
        {
            field("Amount To Customer"; CU50200.GetAmttoCustomerPostedDoc(Rec."No."))
            {
            }
        }
    }
    actions
    {
        addafter(DeferralSchedule)
        {
            action("Get Scheme Discount")
            {
                Image = Discount;
                RunObject = Page 50033;
                RunPageLink = "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
        }
    }
    var
        CU50200: Codeunit 50200;
}

