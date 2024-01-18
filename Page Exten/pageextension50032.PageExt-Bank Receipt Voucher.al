pageextension 50032 pageextension50032 extends "Bank Receipt Voucher"
{
    layout
    {
        moveafter("Document Type"; "Document No.")
        moveafter("Document No."; "Account Type")
        moveafter("Account Type"; "Account No.")
        moveafter("Account No."; Description)
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter(Description; "External Document No.")
        moveafter("External Document No."; Amount)
        addafter(Amount)
        {
            field(DebitAmountNew; Rec."Debit Amount")
            {
                ApplicationArea = All;
            }
            field(CreditAmountNew; Rec."Credit Amount")
            {
                ApplicationArea = All;
            }
        }
        moveafter(CreditAmountNew; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        moveafter("Bal. Account No."; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")

        // addbefore("T.A.N. No.")
        // {
        //     field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        // // moveafter(Amount; "Debit Amount")
        // // movebefore("Bal. Account Type"; "Credit Amount")
        // modify("Debit Amount")
        // {
        //     Visible = true;
        // }
        // modify("Credit Amount")
        // {
        //     Visible = true;
        // }
        addafter("Balance.")
        {
            field(CreditAmount2; Rec."Credit Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("Total Balance.")
        {
            field(TotalCreditAmount; TotalCreditAmount)
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        UpdateDebitCreditAmount(Rec, TotalCreditAmount);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateDebitCreditAmount(Rec, TotalCreditAmount);
    end;

    procedure UpdateDebitCreditAmount(var GenJnlLine: Record "Gen. Journal Line"; var TotalCreditAmount: Decimal)
    var
        GJLRec: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line";
    begin
        TotalCreditAmount := 0;
        TempGenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        TempGenJnlLine.COPYFILTERS(GenJnlLine);
        IF TempGenJnlLine.FINDSET THEN
            REPEAT
                IF TempGenJnlLine."Credit Amount" > 0 THEN
                    TotalCreditAmount += TempGenJnlLine."Credit Amount";

                IF TempGenJnlLine."Bal. Account No." <> '' THEN BEGIN
                    IF TempGenJnlLine."Debit Amount" > 0 THEN
                        TotalCreditAmount += TempGenJnlLine."Debit Amount";
                END;
            UNTIL TempGenJnlLine.NEXT = 0;
    end;

    var
        TotalCreditAmount: Decimal;
}

