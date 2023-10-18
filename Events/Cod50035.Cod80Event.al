codeunit 50035 "Cod-80-Event"
{
    procedure CheckCustBalance(RecSaleH: Record "Sales Header") dcCustBal: Decimal
    var
        recCustomer: Record Customer;
        dcBillAmt: Decimal;
        dcAbsCustBal: Decimal;
        dcCustCrBal: Decimal;
        dcCustDrBal: Decimal;
        recSalesLine: Record "Sales Line";
        Cu50200: Codeunit 50200;
    begin
        IF RecSaleH."Campaign No." = '' THEN BEGIN
            recCustomer.RESET;
            recCustomer.SETRANGE("No.", RecSaleH."Sell-to Customer No.");
            IF recCustomer.FINDFIRST THEN BEGIN
                IF NOT ((recCustomer."Excludes Credit Limit Allow" = TRUE) OR (recCustomer."One Time Credit Pass Allow" = TRUE)) THEN BEGIN
                    recCustomer.CALCFIELDS("Balance (LCY)");
                    IF recCustomer."Balance (LCY)" < 0 THEN BEGIN
                        dcCustCrBal := ABS(recCustomer."Balance (LCY)");
                        dcCustBal := dcCustCrBal + recCustomer."Credit Limit (LCY)";
                    END ELSE BEGIN
                        dcCustDrBal := -(recCustomer."Balance (LCY)");
                        dcCustBal := dcCustDrBal + recCustomer."Credit Limit (LCY)";
                    END;
                    recSalesLine.RESET;
                    recSalesLine.SETRANGE("Document No.", RecSaleH."No.");
                    IF recSalesLine.FINDSET THEN
                        REPEAT
                            dcBillAmt += (Cu50200.AmttoCustomerSalesLine(recSalesLine) + Cu50200.TotalGSTAmtLineSales(recSalesLine));
                        UNTIL recSalesLine.NEXT = 0;


                    //RecSaleH.CALCFIELDS("Amount to Customer");
                    //dcBillAmt:=RecSaleH."Amount to Customer";

                    //dcCustBal:=dcCustCrBal+recCustomer."Credit Limit (LCY)";
                    //dcCustBal:=dcCustDrBal+recCustomer."Credit Limit (LCY)";

                    IF dcCustBal < dcBillAmt THEN
                        ERROR('Billing Amount : %1 is greater then Available Balance and Credit Balance : %2', dcBillAmt, dcCustBal)
                    ELSE
                        MESSAGE('CustomerBalance is %1,Bill Amount is %2', dcCustBal, dcBillAmt);
                    EXIT(dcCustBal);
                END;
            END;
        END;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    begin
        GLEntry."Location Code" := GenJournalLine."Location Code";
    end;
}
