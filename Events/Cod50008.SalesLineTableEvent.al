codeunit 50008 SalesLineTableEvent
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateUnitPrice', '', false, false)]
    local procedure OnAfterUpdateUnitPrice(var SalesLine: Record "Sales Line")
    begin
        SalesLine.VALIDATE("Unit Price Incl. of Tax");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnAfterInitHeaderDefaults(var SalesLine: Record "Sales Line")
    var
        recCustomer: Record 18;
    begin
        //KMBEGIN150621-Begin Update Scheme field
        recCustomer.RESET();
        recCustomer.SETRANGE("No.", SalesLine."Sell-to Customer No.");
        IF recCustomer.FINDFIRST THEN
            SalesLine.VALIDATE("Scheme Code", recCustomer."Scheme Code");
        //KMBEGIN150621-END Update Scheme field
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInitOutstandingAmount', '', false, false)]
    local procedure OnBeforeInitOutstandingAmount(xSalesLine: Record "Sales Line")
    var
        SaleLineSingIns: Codeunit 50030;
    begin
        Clear(SaleLineSingIns);
        SaleLineSingIns.ClearVariables();
        SaleLineSingIns.SetData(xSalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnUpdateAmountOnBeforeCheckCreditLimit', '', false, false)]
    local procedure OnUpdateAmountOnBeforeCheckCreditLimit(var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        recSalesHeader: Record 36;
        SkipCreditCheck: Boolean;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        SaleLineSingIns: Codeunit 50030;
        xSaleLineGlb: Record 37;
    begin
        Clear(SaleLineSingIns);
        SaleLineSingIns.GetData(xSaleLineGlb);
        //KM
        IF SalesLine.ValidateMRPItemTracking = TRUE THEN
            CurrentFieldNo := 16537;
        recSalesHeader.RESET();
        recSalesHeader.SETRANGE("No.", SalesLine."Document No.");
        IF recSalesHeader.FINDFIRST THEN
            SkipCreditCheck := recSalesHeader.CheckCustCredit(recSalesHeader."Sell-to Customer No.");//KM
        if (CurrentFieldNo <> 0) AND (SkipCreditCheck = FALSE) AND
                   not ((SalesLine.Type = Type::Item) and (CurrentFieldNo = SalesLine.FieldNo("No.")) and (SalesLine.Quantity <> 0) and
                        (SalesLine."Qty. per Unit of Measure" <> xSaleLineGlb."Qty. per Unit of Measure")) and
                   CheckCreditLimitCondition(SalesLine) and
                   ((SalesLine."Outstanding Amount" + SalesLine."Shipped Not Invoiced") > 0) and
                   (CurrentFieldNo <> SalesLine.FieldNo("Blanket Order No.")) and
                   (CurrentFieldNo <> SalesLine.FieldNo("Blanket Order Line No."))
                then
            CustCheckCreditLimit.SalesLineCheck(SalesLine);
        IF SalesLine.ValidateMRPItemTracking = TRUE THEN
            CurrentFieldNo := 0;
        SalesLine.ValidateMRPItemTracking := FALSE;
        //KM
        IsHandled := true;


    end;


    local procedure CheckCreditLimitCondition(SaleLine: Record 37): Boolean
    var
        RunCheck: Boolean;
    begin
        RunCheck := SaleLine."Document Type".AsInteger() <= SaleLine."Document Type"::Invoice.AsInteger();

        exit(RunCheck);
    end;


}
