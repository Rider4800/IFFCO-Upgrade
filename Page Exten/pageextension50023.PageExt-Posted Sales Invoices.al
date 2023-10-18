pageextension 50023 pageextension50023 extends "Posted Sales Invoices"
{
    // //acxcp_26052021 // Button for Sales Report

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Sales Invoices"(Page 143)".
    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Invoices"(Page 143)".

    layout
    {
        addbefore("No.")
        {
            field("E-Mail Sent"; Rec."E-Mail Sent")
            {
                Editable = false;
            }
        }
        addafter("Currency Code")
        {
            field("Posting Description"; Rec."Posting Description")
            {
            }
        }
        addafter("Amount Including VAT")
        {
            field("Campaign No."; Rec."Campaign No.")
            {
            }
        }
        addafter("Sell-to Contact")
        {
            field("Scheme Code"; Rec."Scheme Code")
            {
            }
        }
    }
    actions
    {
        addafter(ActivityLog)
        {
            action("Tax Invoice")
            {
                Caption = 'Tax Invoice';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvHeader: Record 112;
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    //SalesInvHeader.EmailRecords(TRUE);
                    //SalesInvHeader.EmailRecordsAcxiom(TRUE);  //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+

                    //acxcp_26052021 // Button for Sales Report
                    RecSIH.RESET();
                    RecSIH.SETRANGE("No.", Rec."No.");
                    IF RecSIH.FINDFIRST THEN BEGIN
                        REPORT.RUN(50004, TRUE, FALSE, RecSIH);
                    END;

                    //acxcp_26052021
                end;
            }
            action("Tax Invoice Consolidate")
            {
                Caption = 'Tax Invoice Consolidate';
            }
            action(AllInvoice)
            {
                Caption = 'AllInvoice';
                Image = Sales;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //acxcp_26052021 // Button for All consolidated Sales Report
                    RecSIH.RESET();
                    RecSIH.SETRANGE("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    IF RecSIH.FINDFIRST THEN BEGIN
                        REPORT.RUN(50034, TRUE, FALSE, RecSIH);
                    END;

                    //acxcp_26052021
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
        RecSIH: Record 112;
}

