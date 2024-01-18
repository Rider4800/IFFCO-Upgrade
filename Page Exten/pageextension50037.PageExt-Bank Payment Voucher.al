pageextension 50037 pageextension50037 extends "Bank Payment Voucher"
{
    layout
    {
        moveafter("Account No."; Description)
        moveafter(Description; Amount)
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
        moveafter("Bal. Account No."; "Location State Code")
        moveafter("Location State Code"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 2 Code")
        // addafter(Description)
        // {
        //     field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        // modify("Debit Amount")
        // {
        //     Visible = true;
        // }
        // modify("Credit Amount")
        // {
        //     Visible = true;
        // }
        // // moveafter(Amount; "Debit Amount")
        // // movebefore("Amount (LCY)"; "Credit Amount")
        // addafter("Check Printed")
        // {
        //     field(PayerInformation; Rec."Payer Information")
        //     {
        //         Caption = 'Payer Information';
        //     }
        // }
    }
}

