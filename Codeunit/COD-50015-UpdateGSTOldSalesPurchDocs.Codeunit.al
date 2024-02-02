codeunit 50015 UpdateGSTOldSalesPurchDocs
{
    trigger OnRun()
    var

    begin
        PurchLineRec.Reset();
        //PurchLineRec.SetFilter("Document No.", '%1|%2|%3', 'PO/21-22/00093', 'PO/21-22/00121', 'PO/21-22/00125');
        ProgressWindow.OPEN('Purchase Line  #1#######');
        countvar := 0;
        if PurchLineRec.FindSet() then
            repeat
                xPurchLineRec := PurchLineRec;
                xPurchLineRec."HSN/SAC Code" := '';
                CalculateTax.CallTaxEngineOnPurchaseLine(PurchLineRec, xPurchLineRec);
                countvar += 1;
                ProgressWindow.UPDATE(1, countvar);
            until PurchLineRec.Next() = 0;
        ProgressWindow.Close();

        SalesLineRec.Reset();
        ProgressWindow.OPEN('Sales Line  #1#######');
        countvar := 0;
        if SalesLineRec.FindSet() then
            repeat
                xSalesLineRec := SalesLineRec;
                xSalesLineRec."HSN/SAC Code" := '';
                CalculateTax.CallTaxEngineOnSalesLine(SalesLineRec, xSalesLineRec);
                countvar += 1;
                ProgressWindow.UPDATE(1, countvar);
            until SalesLineRec.Next() = 0;
        ProgressWindow.Close();
        Message('POs & SOs Updated Successfully');
    end;

    var
        PurchLineRec: Record "Purchase Line";
        xPurchLineRec: Record "Purchase Line";
        SalesLineRec: Record "Sales Line";
        xSalesLineRec: Record "Sales Line";
        ProgressWindow: Dialog;
        countvar: Integer;
        CalculateTax: Codeunit "Calculate Tax";
}