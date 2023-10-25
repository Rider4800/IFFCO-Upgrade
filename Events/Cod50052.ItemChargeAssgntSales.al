codeunit 50052 ItemChargeAssgntSales
{
    procedure SuggestAssignmentforAutoShipment(SalesLine2: Record "Sales Line"; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal; Selection: Integer)
    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        ItemChargeAssgntSales2: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        CurrencyCode: Code[10];
        TotalAppliesToDocLineAmount: Decimal;
        RemainingNumOfLines: Integer;
    begin
        SalesHeader.GET(SalesLine2."Document Type", SalesLine2."Document No.");
        IF NOT Currency.GET(SalesLine2."Currency Code") THEN
            Currency.InitRoundingPrecision;
        ItemChargeAssgntSales2.SETRANGE("Document Type", SalesLine2."Document Type");
        ItemChargeAssgntSales2.SETRANGE("Document No.", SalesLine2."Document No.");
        ItemChargeAssgntSales2.SETRANGE("Document Line No.", SalesLine2."Line No.");
        IF ItemChargeAssgntSales2.FIND('-') THEN BEGIN
            IF Selection = 1 THEN BEGIN
                REPEAT
                    IF NOT ItemChargeAssgntSales2.SalesLineInvoiced THEN BEGIN
                        TempItemChargeAssgntSales.INIT;
                        TempItemChargeAssgntSales := ItemChargeAssgntSales2;
                        TempItemChargeAssgntSales.INSERT;
                    END;
                UNTIL ItemChargeAssgntSales2.NEXT = 0;

                IF TempItemChargeAssgntSales.FIND('-') THEN BEGIN
                    RemainingNumOfLines := TempItemChargeAssgntSales.COUNT;
                    REPEAT
                        ItemChargeAssgntSales2.GET(
                          TempItemChargeAssgntSales."Document Type",
                          TempItemChargeAssgntSales."Document No.",
                          TempItemChargeAssgntSales."Document Line No.",
                          TempItemChargeAssgntSales."Line No.");
                        ItemChargeAssgntSales2."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines, 0.00001);
                        ItemChargeAssgntSales2."Amount to Assign" :=
                          ROUND(
                            ItemChargeAssgntSales2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                            Currency."Amount Rounding Precision");
                        TotalQtyToAssign -= ItemChargeAssgntSales2."Qty. to Assign";
                        TotalAmtToAssign -= ItemChargeAssgntSales2."Amount to Assign";
                        RemainingNumOfLines := RemainingNumOfLines - 1;
                        ItemChargeAssgntSales2.MODIFY;
                    UNTIL TempItemChargeAssgntSales.NEXT = 0;
                END;
            END ELSE BEGIN
                REPEAT
                    IF NOT ItemChargeAssgntSales2.SalesLineInvoiced THEN BEGIN
                        TempItemChargeAssgntSales.INIT;
                        TempItemChargeAssgntSales := ItemChargeAssgntSales2;
                        CASE ItemChargeAssgntSales2."Applies-to Doc. Type" OF
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::Quote,
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::Order,
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::Invoice,
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::"Return Order",
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::"Credit Memo":
                                BEGIN
                                    SalesLine.GET(
                                      ItemChargeAssgntSales2."Applies-to Doc. Type",
                                      ItemChargeAssgntSales2."Applies-to Doc. No.",
                                      ItemChargeAssgntSales2."Applies-to Doc. Line No.");
                                    TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                                      ABS(SalesLine."Line Amount");
                                END;
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::"Return Receipt":
                                BEGIN
                                    ReturnRcptLine.GET(
                                      ItemChargeAssgntSales2."Applies-to Doc. No.",
                                      ItemChargeAssgntSales2."Applies-to Doc. Line No.");
                                    CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                                    IF CurrencyCode = SalesHeader."Currency Code" THEN
                                        TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                                          ABS(ReturnRcptLine."Item Charge Base Amount")
                                    ELSE
                                        TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                                          CurrExchRate.ExchangeAmtFCYToFCY(
                                            SalesHeader."Posting Date", CurrencyCode, SalesHeader."Currency Code",
                                            ABS(ReturnRcptLine."Item Charge Base Amount"));
                                END;
                            ItemChargeAssgntSales2."Applies-to Doc. Type"::Shipment:
                                BEGIN
                                    SalesShptLine.GET(
                                      ItemChargeAssgntSales2."Applies-to Doc. No.",
                                      ItemChargeAssgntSales2."Applies-to Doc. Line No.");
                                    CurrencyCode := SalesShptLine.GetCurrencyCode;
                                    IF CurrencyCode = SalesHeader."Currency Code" THEN
                                        TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                                          ABS(SalesShptLine."Item Charge Base Amount")
                                    ELSE
                                        TempItemChargeAssgntSales."Applies-to Doc. Line Amount" :=
                                          CurrExchRate.ExchangeAmtFCYToFCY(
                                            SalesHeader."Posting Date", CurrencyCode, SalesHeader."Currency Code",
                                            ABS(SalesShptLine."Item Charge Base Amount"));
                                END;
                        END;
                        IF TempItemChargeAssgntSales."Applies-to Doc. Line Amount" <> 0 THEN
                            TempItemChargeAssgntSales.INSERT
                        ELSE BEGIN
                            ItemChargeAssgntSales2."Amount to Assign" := 0;
                            ItemChargeAssgntSales2."Qty. to Assign" := 0;
                            ItemChargeAssgntSales2.MODIFY;
                        END;
                        TotalAppliesToDocLineAmount += TempItemChargeAssgntSales."Applies-to Doc. Line Amount";
                    END;
                UNTIL ItemChargeAssgntSales2.NEXT = 0;

                IF TempItemChargeAssgntSales.FIND('-') THEN
                    REPEAT
                        ItemChargeAssgntSales2.GET(
                          TempItemChargeAssgntSales."Document Type",
                          TempItemChargeAssgntSales."Document No.",
                          TempItemChargeAssgntSales."Document Line No.",
                          TempItemChargeAssgntSales."Line No.");
                        IF TotalQtyToAssign <> 0 THEN BEGIN
                            ItemChargeAssgntSales2."Qty. to Assign" :=
                              ROUND(
                                TempItemChargeAssgntSales."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                                0.00001);
                            ItemChargeAssgntSales2."Amount to Assign" :=
                              ROUND(
                                ItemChargeAssgntSales2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                                Currency."Amount Rounding Precision");
                            TotalQtyToAssign -= ItemChargeAssgntSales2."Qty. to Assign";
                            TotalAmtToAssign -= ItemChargeAssgntSales2."Amount to Assign";
                            TotalAppliesToDocLineAmount -= TempItemChargeAssgntSales."Applies-to Doc. Line Amount";
                            ItemChargeAssgntSales2.MODIFY;
                        END;
                    UNTIL TempItemChargeAssgntSales.NEXT = 0;
            END;
            TempItemChargeAssgntSales.DELETEALL;
        END;
    end;
}