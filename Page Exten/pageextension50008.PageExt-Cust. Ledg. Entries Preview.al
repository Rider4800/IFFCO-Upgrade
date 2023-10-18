pageextension 50008 pageextension50008 extends "Cust. Ledg. Entries Preview"
{
    layout
    {
        addafter("Message to Recipient")
        {
            field("External Doc No."; Rec."External Document No.")
            {
                Caption = 'External Document No.';
            }
        }
    }
}

