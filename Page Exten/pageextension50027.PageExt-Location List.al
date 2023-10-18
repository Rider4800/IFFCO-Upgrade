pageextension 50027 pageextension50027 extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("State Code"; Rec."State Code")
            {
            }
        }
    }

    var
        UserMgt: Codeunit 5700;

    trigger OnOpenPage()
    begin
        //MZH
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FILTERGROUP(0);
        END;
        //MZH
    end;
}

