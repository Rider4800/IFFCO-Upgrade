pageextension 50052 pageextension50052 extends "Ship-to Address"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
            field("Name 3"; Rec."Name 3")
            {
                ApplicationArea = All;
            }
        }
        addafter(Consignee)
        {
            field(Disable; Rec.Disable)
            {
                ApplicationArea = All;
            }
        }
    }
}

