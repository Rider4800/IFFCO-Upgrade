pageextension 50077 pageextension50077 extends "Purchase List"
{
    var
        UserMgt: Codeunit 5700;


    trigger OnOpenPage()
    begin
        //MZH
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FILTERGROUP(0);
        END;
        //MZH
    end;
}

