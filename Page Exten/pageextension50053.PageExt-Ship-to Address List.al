pageextension 50053 pageextension50053 extends "Ship-to Address List"
{
    layout
    {
        addafter("Location Code")
        {
            field(Disable; Rec.Disable)
            {
            }
        }
    }

    var
        RecShipto: Record 222;
}

