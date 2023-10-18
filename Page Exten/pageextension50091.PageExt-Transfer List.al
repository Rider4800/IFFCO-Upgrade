pageextension 50091 pageextension50091 extends "Transfer Orders"
{
    layout
    {
        addfirst(Control1)
        {
            field("Posting Date"; Rec."Posting Date")
            {
            }
        }
    }

    var
        UserMgt: Codeunit 5700;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('Deletion is not allowed.');
    end;

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

