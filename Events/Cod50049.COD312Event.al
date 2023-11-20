codeunit 50049 COD312Event
{
    [EventSubscriber(ObjectType::Codeunit, 312, 'OnBeforeSalesLineCheck', '', false, false)]
    local procedure OnBeforeSalesLineCheck(var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    var
        recCustomer: Record Customer;
        decBalance: Decimal;
        SalesHeader: Record 36;
        CustCheckCreditLimit: Page "Check Credit Limit";
        OK: Boolean;
        Text000: Label 'The update has been interrupted to respect the warning.';
        BalanceL: Decimal;
        ParentCustomerL: Record 18;
        FinalBalanceL: Decimal;
    begin
        IsHandled := true;
        //acxcp_300622_CampaignCode +
        decBalance := 0;
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF (SalesHeader."Campaign No." = '') THEN BEGIN //acxcp_230921
            recCustomer.RESET();//km
            recCustomer.SETRANGE("No.", SalesLine."Sell-to Customer No.");
            IF (recCustomer.FINDFIRST) AND (recCustomer."Excludes Credit Limit Allow" = FALSE) THEN BEGIN//km
                IF NOT CustCheckCreditLimit.SalesLineShowWarning(SalesLine) THEN
                    SalesHeader.OnCustomerCreditLimitNotExceeded
                ELSE BEGIN
                    OK := CustCheckCreditLimit.RUNMODAL = ACTION::Yes;
                    CLEAR(CustCheckCreditLimit);
                    IF OK THEN
                        SalesHeader.CustomerCreditLimitExceeded()
                    ELSE
                        ERROR(Text000);
                END;
            END;//km
        END;//acxcp_230921

        IF SalesHeader."Campaign No." <> '' THEN BEGIN
            decBalance := (SalesHeader.CheckCustBalance(SalesLine."Sell-to Customer No.")) + (CheckRunningBalance(SalesLine."Sell-to Customer No."));  //KM
        END;

        IF decBalance > 0 THEN
      //Team 7739 Start-
      BEGIN
            IF SalesHeader."Parent Customer" <> '' THEN BEGIN
                ParentCustomerL.GET(SalesHeader."Parent Customer");
                ParentCustomerL.CALCFIELDS(ParentCustomerL."Balance (LCY)");
                BalanceL := CheckRunningBalanceP(SalesLine);
                FinalBalanceL := ParentCustomerL."Balance (LCY)" + BalanceL;
                IF FinalBalanceL > 0 THEN
                    ERROR('Parent Customer %1 Credit balance is low.', SalesHeader."Parent Customer");
            END ELSE
                //Team 7739 End-
                ERROR('Credit Balance not found');
        END;//Team 7739


        //acxcp_300622_CampaignCode -

    end;

    PROCEDURE CheckRunningBalanceP(SaleslineP: Record 37) RunBalance: Decimal;
    VAR
        SalesLine: Record 37;
        Cu50200: Codeunit 50200;
    BEGIN
        SalesLine.RESET();
        RunBalance := 0;
        SalesLine.SETRANGE("Sell-to Customer No.", SaleslineP."Sell-to Customer No.");
        SalesLine.SETFILTER("Line No.", '<>%1', SaleslineP."Line No.");
        IF SalesLine.FINDFIRST THEN
            REPEAT
                RunBalance += Cu50200.AmttoCustomerSalesLine(SalesLine);
            UNTIL SalesLine.NEXT = 0;
        RunBalance += Cu50200.AmttoCustomerSalesLine(SalesLine);
    END;

    local procedure CheckRunningBalance("CustNO.": Code[20]) RunBalance: Decimal
    var
        SalesLine: Record 37;
        Cu50200: Codeunit 50200;
    begin
        SalesLine.RESET();
        RunBalance := 0;
        SalesLine.SETRANGE("Sell-to Customer No.", "CustNO.");
        IF SalesLine.FINDFIRST THEN
            REPEAT
                MESSAGE(FORMAT(SalesLine.Amount));

                RunBalance += Cu50200.AmttoCustomerSalesLine(SalesLine);
            UNTIL SalesLine.NEXT = 0;

    end;
}
