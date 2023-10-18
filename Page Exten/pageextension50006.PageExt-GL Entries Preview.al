pageextension 50006 pageextension50006 extends "G/L Entries Preview"
{
    layout
    {
        addafter("Document Type")
        {
            field("Debit Amt"; Rec."Debit Amount")
            {
                Caption = 'Debit Amount';
            }
            field("Credit Amt"; Rec."Credit Amount")
            {
                Caption = 'Cebit Amount';
            }
        }
        addafter(Description)
        {
            field("Branch JV"; Rec."Branch JV")
            {
            }
        }
    }
}

