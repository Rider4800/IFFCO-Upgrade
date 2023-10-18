pageextension 50070 pageextension50070 extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("Certificate of Analysis"; Rec."Certificate of Analysis")
            {
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Branch Accounting"; Rec."Branch Accounting")
            {
            }
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
        }
        moveafter("Certificate of Analysis"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
    actions
    {
        addafter(PostedPrepaymentCrMemos)
        {
            action("PO-Supplier Copy")
            {
                Image = Purchase;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    recPurchaseHeader.RESET();
                    recPurchaseHeader.SETRANGE("No.", Rec."No.");
                    //recPurchaseHeader.SETRANGE("Posting Date",Rec."Posting Date");
                    IF recPurchaseHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50021, TRUE, TRUE, recPurchaseHeader);
                    END;
                end;
            }
            action("PO-Office Copy")
            {
                Image = Purchasing;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    recPurchaseHeader.RESET();
                    recPurchaseHeader.SETRANGE("No.", Rec."No.");
                    //recPurchaseHeader.SETRANGE("Posting Date",Rec."Posting Date");
                    IF recPurchaseHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50022, TRUE, TRUE, recPurchaseHeader);
                    END;
                end;
            }
        }
    }

    var
        recPurchaseHeader: Record 38;
}

