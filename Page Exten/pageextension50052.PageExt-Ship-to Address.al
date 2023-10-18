pageextension 50052 pageextension50052 extends "Ship-to Address"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
            }
            field("Name 3"; Rec."Name 3")
            {
            }
        }
        addafter(Consignee)
        {
            field(Disable; Rec.Disable)
            {
            }
        }
    }
}

