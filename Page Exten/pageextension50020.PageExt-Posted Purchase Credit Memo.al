pageextension 50020 pageextension50020 extends "Posted Purchase Credit Memo"
{
    actions
    {
        addafter(Approvals)
        {
            action("Posted Pur Cr.Memo Report")
            {
                Caption = 'Posted Pur Cr.Memo Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PurchCrMemoHeader.RESET;
                    PurchCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF PurchCrMemoHeader.FINDFIRST THEN BEGIN
                        REPORT.RUN(50058, TRUE, FALSE, PurchCrMemoHeader);
                    END;
                end;
            }
        }
    }
    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
}

