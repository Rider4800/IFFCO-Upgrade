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
    begin
        IsHandled := true;
        //acxcp_300622_CampaignCode +
        decBalance := 0;
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF(SalesHeader."Campaign No." = '') THEN
        BEGIN //acxcp_230921
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
            ERROR('Credit Balance not found');

        //acxcp_300622_CampaignCode -

    end;

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
