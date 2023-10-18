pageextension 50024 pageextension50024 extends "Posted Sales Credit Memos"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Sales Credit Memos"(Page 144)".
    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Credit Memos"(Page 144)".

    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Your Reference"; Rec."Your Reference")
            {
            }
        }
    }
    actions
    {
        addafter(IncomingDoc)
        {
            action("Sales Return Invoice")
            {
                Caption = 'Sales Return Invoice';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //acxcp
                    SalesCrMemoHeader.RESET();
                    SalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN BEGIN
                        REPORT.RUN(50005, TRUE, FALSE, SalesCrMemoHeader);
                    END;

                    //acxcp
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('You are not allowed to insert');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You are not allowed to delete');
    end;

    var
        SalesCrMemoHeader: Record 114;
}

