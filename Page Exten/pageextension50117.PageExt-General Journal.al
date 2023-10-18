pageextension 50117 GeneralJournal extends "General Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("Branch Accounting"; Rec."Branch Accounting")
            {
                ApplicationArea = all;
            }
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = all;
            }

        }
        addafter("External Document No.")
        {
            field("FA Posting Type"; rec."FA Posting Type")
            {
                ApplicationArea = all;
            }
        }
        addbefore(Description)
        {
            field("Finance Branch A/c Code"; rec."Finance Branch A/c Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addbefore("&Line")
        {
            group("&Narration")
            {
                Caption = '&Narration';
                Image = Description;
                /*  action("Line Narration")
                  {
                      Caption = 'Line Narration';
                      Image = LineDescription;
                      RunObject = Page "Gen. Journal Narration"
                      RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                    "Journal Batch Name" = FIELD("Journal Batch Name"),
                                    "Gen. Journal Line No." = FIELD("Line No."),
                                    "Document No." = FIELD("Document No.");
                      ShortCutKey = 'Shift+Ctrl+N';
                  }*/ //16767 Comment due to Runobject Not found
                action("Voucher Narration")
                {
                    Caption = 'Voucher Narration';
                    Image = VoucherDescription;
                    RunObject = Page "Gen. Journal Voucher Narration";
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Document No." = FIELD("Document No."),
                                  "Gen. Journal Line No." = FILTER(0);
                    ShortCutKey = 'Shift+Ctrl+V';
                }
            }
        }
    }

    var
        myInt: Integer;
}