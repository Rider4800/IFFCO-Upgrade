pageextension 50117 GeneralJournal extends "General Journal"
{
    layout
    {
        moveafter("Posting Date"; "Document No.")
        moveafter("Document No."; "Account Type")
        moveafter("Account Type"; "Account No.")
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
        moveafter(CreditAmountNew; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; "Gen. Prod. Posting Group")
        moveafter("Gen. Prod. Posting Group"; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        // addafter("Document No.")
        // {
        //     field("Branch Accounting"; Rec."Branch Accounting")
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("Source Code"; Rec."Source Code")
        //     {
        //         ApplicationArea = all;
        //     }

        // }
        // addafter("External Document No.")
        // {
        //     field("FA Posting Type"; rec."FA Posting Type")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        // addbefore(Description)
        // {
        //     field("Finance Branch A/c Code"; rec."Finance Branch A/c Code")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
    }

    actions
    {
        addbefore("&Line")
        {
            group("&Narration")
            {
                Caption = '&Narration';
                Image = Description;
                action("Line Narration")
                {
                    Caption = 'Line Narration';
                    Image = LineDescription;
                    RunObject = Page "Line Narration";
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                    "Journal Batch Name" = FIELD("Journal Batch Name"),
                                    "Gen. Journal Line No." = FIELD("Line No."),
                                    "Document No." = FIELD("Document No.");
                    ShortCutKey = 'Shift+Ctrl+N';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                } //16767 Comment due to Runobject Not found
                action("Voucher Narration")
                {
                    Caption = 'Voucher Narration';
                    Image = VoucherDescription;
                    RunObject = Page "Voucher Narration";
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Document No." = FIELD("Document No."),
                                  "Gen. Journal Line No." = FILTER(0);
                    ShortCutKey = 'Shift+Ctrl+V';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                }
            }
        }
    }

    var
        myInt: Integer;
}