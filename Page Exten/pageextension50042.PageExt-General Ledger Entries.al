pageextension 50042 pageextension50042 extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("ExternalDocumentNo."; Rec."External Document No.")
            {
                Caption = 'External Document No.';
            }
            field("Document Date"; Rec."Document Date")
            {
            }
        }
        addafter("Global Dimension 1 Code")
        {
            field("Branch JV"; Rec."Branch JV")
            {
            }
            //->Team-17783
            field("Location Code"; Rec."Location Code")
            {
            }
            //<-Team-17783  Added this custom field and flow from Gen. Journal Line to GL Entry
        }
        addafter(Quantity)
        {
            field("DebitAmount"; Rec."Debit Amount")
            {
                Caption = 'Debit Amount';
            }
            field("CreditAmount"; Rec."Credit Amount")
            {
                Caption = 'Credit Amount';
            }
        }
        addafter("Reason Code")
        {
            field("Provisional Entries"; Rec."Provisional Entries")
            {
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("Print Voucher")
        {
            action("Print Voucher Posted-ACX")
            {
                Caption = 'Print Voucher Posted-ACX';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    recGLEntry.SETRANGE("Document No.", Rec."Document No.");
                    IF recGLEntry.FINDFIRST THEN
                        REPORT.RUN(50025, TRUE, FALSE, recGLEntry);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin

    end;

    var
        recGLEntry: Record 17;
        s: Record "Gen. Journal Line";
}

