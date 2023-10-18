pageextension 50118 PostedSalesCreditMemo extends "Posted Sales Credit Memo"
{

    layout
    {
        modify("E-Inv. Cancelled Date")
        {
            Editable = false;
        }

    }



    actions
    {
        addbefore(IncomingDocument)
        {
            action("Sales Return Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //acxcp
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN BEGIN
                        REPORT.RUN(50005, TRUE, FALSE, SalesCrMemoHeader);
                    END;

                    //acxcp;
                end;
            }

        }
        addafter(IncomingDocAttachFile)
        {
            action("Tax Invoice")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    recSalesCrmHdr.RESET();
                    recSalesCrmHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesCrmHdr.FIND('-') THEN
                        REPORT.RUN(50005, TRUE, FALSE, recSalesCrmHdr);
                end;
            }

        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        Error('You can not delete the record.');
    end;

    var
        recSalesCrmHdr: Record 114;
        SalesCrMemoHeader: Record 114;
}