pageextension 50045 pageextension50045 extends "Customer Ledger Entries"
{
    layout
    {
        addbefore("Posting Date")
        {
            field("EntryNo."; Rec."Entry No.")
            {
                Caption = 'Entry No.';
            }
            field("Closed by Entry No."; Rec."Closed by Entry No.")
            {
            }
            field("Applying Entry"; Rec."Applying Entry")
            {
            }
        }
        addbefore("Document Type")
        {
            field("DocumentDate"; Rec."Document Date")
            {
                Caption = 'Document Date';
            }
        }
        addafter("Customer No.")
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
            }
        }
        addafter(Description)
        {
            field("ExternalDocumentNo."; Rec."External Document No.")
            {
                Caption = 'External Document No.';
            }
            field("Campaign No."; Rec."Campaign No.")
            {
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("Print Voucher")
        {
            action("Ship-To Ledger Report")
            {
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;

                trigger OnAction()
                begin
                    REPORT.RUN(50039, TRUE, FALSE);//acxcp_180722
                end;
            }
        }
    }
}

