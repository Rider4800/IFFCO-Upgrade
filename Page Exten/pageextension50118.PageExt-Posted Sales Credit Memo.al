pageextension 50118 PostedSalesCreditMemo extends "Posted Sales Credit Memo"
{

    layout
    {
        modify("E-Inv. Cancelled Date")
        {
            ApplicationArea = All;
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
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //acxcp
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN
                        REPORT.RUN(50005, TRUE, FALSE, SalesCrMemoHeader);
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
                ApplicationArea = All;

                trigger OnAction()
                begin
                    recSalesCrmHdr.RESET();
                    recSalesCrmHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesCrmHdr.FIND('-') THEN
                        REPORT.RUN(50005, TRUE, FALSE, recSalesCrmHdr);
                end;
            }
            // action("E-Invoice SalesCrMemo")
            // {
            //     ApplicationArea = All;
            //     Caption = 'E-Invoice SalesCrMemo';
            //     Ellipsis = true;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = CreateDocument;

            //     trigger OnAction()
            //     var
            //         CU50013: Codeunit 50013;
            //     begin
            //         CU50013.CreateJsonSalesCrMemoOrder(Rec);
            //     end;
            // }
            // action("Cancel E-Invoice SalesCrMemo")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Cancel E-Invoice SalesCrMemo';
            //     Ellipsis = true;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = CreateDocument;

            //     trigger OnAction()
            //     var
            //         CU50013: Codeunit 50013;
            //     begin
            //         CU50013.CanceSalesCrMemoEInvoice(Rec."No.", Rec."IRN Hash");
            //     end;
            // }

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