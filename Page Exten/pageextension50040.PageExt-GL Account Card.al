pageextension 50040 pageextension50040 extends "G/L Account Card"
{
    layout
    {
        addafter("No.")
        {
            field("No.2"; Rec."No. 2")
            {
                Caption = 'No. 2';
            }
        }
        addafter("Omit Default Descr. in Jnl.")
        {
            field("Branch GL"; Rec."Branch GL")
            {
            }
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
}

