pageextension 50053 pageextension50053 extends "Ship-to Address List"
{
    layout
    {
        addafter("Location Code")
        {
            field(Disable; Rec.Disable)
            {
                ApplicationArea = All;
            }
            field("MAssist Code"; Rec."MAssist Code")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        RecShipto: Record 222;
}

