pageextension 50041 pageextension50041 extends "G/L Account List"
{
    layout
    {
        addafter(Name)
        {
            field("No.2"; Rec."No. 2")
            {
                Caption = 'No. 2';
            }
        }
        addafter("Direct Posting")
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
}

