pageextension 50003 pageextension50003 extends "Customer Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field(ExcludeFIFOExpiry; Rec.ExcludeFIFOExpiry)
            {
                ApplicationArea = All;
            }
            field("Multi-Lot Selection Allowed"; Rec."Multi-Lot Selection Allowed")
            {
                ApplicationArea = All;
            }
        }
    }
}

