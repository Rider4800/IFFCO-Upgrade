pageextension 50014 pageextension50014 extends "Posted Purchase Receipt"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Purchase Receipt"(Page 136)".

    actions
    {
        addafter("&Navigate")
        {
            action(MRN)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    recPurchaseHeader.RESET();
                    recPurchaseHeader.SETRANGE("No.", Rec."No.");
                    //recPurchaseHeader.SETRANGE("Posting Date",Rec."Posting Date");
                    if recPurchaseHeader.FindFirst() then
                        REPORT.RUN(50013, TRUE, TRUE, recPurchaseHeader);
                end;
            }
        }
    }

    var
        recPurchaseHeader: Record 120;
}

