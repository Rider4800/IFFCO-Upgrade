codeunit 50021 SalesHeaderTabEvent
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCheckSellToCust', '', false, false)]
    procedure OnAfterCheckSellToCust(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Customer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader."Finance Branch A/c Code" := Customer."Finance Branch A/c Code";//Acx_Anubha
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnSetShipToCustomerAddressFieldsFromShipToAddrOnBeforeValidateShippingAgentFields', '', false, false)]
    procedure OnSetShipToCustomerAddressFieldsFromShipToAddrOnBeforeValidateShippingAgentFields(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; ShipToAddr: Record "Ship-to Address"; var IsHandled: Boolean)
    begin
        SalesHeader."Tax Area Code" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCopyShipToCustomerAddressFieldsFromCustOnBeforeValidateShippingAgentFields', '', false, false)]
    procedure OnCopyShipToCustomerAddressFieldsFromCustOnBeforeValidateShippingAgentFields(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; var IsHandled: Boolean)
    begin
        SalesHeader."Tax Area Code" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateShipToCodeOnBeforeValidateTaxLiable', '', false, false)]
    procedure OnValidateShipToCodeOnBeforeValidateTaxLiable(var SalesHeader: Record "Sales Header"; var xSalesHeader: Record "Sales Header")
    var
        RecShipto: Record "Ship-to Address";
    begin
        //Acxvg
        //recShipTo.RESET;
        RecShipto.RESET;
        RecShipto.SETRANGE(Code, SalesHeader."Ship-to Code");
        IF RecShipto.FINDFIRST THEN BEGIN
            IF RecShipto.Disable = TRUE THEN BEGIN
                ERROR('This Ship to code has been disable');
            END;
        END;
        //Acxvg
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckCreditMaxBeforeInsert', '', false, false)]
    procedure OnBeforeCheckCreditMaxBeforeInsert(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; HideCreditCheckDialogue: Boolean; FilterCustNo: Code[20]; FilterContNo: Code[20])
    var
        Customer: Record Customer;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        Cont: Record Contact;
        ContBusinessRelation: Record "Contact Business Relation";
        SkipCreditCheck: Boolean;
    begin
        IsHandled := true;
        if (FilterCustNo <> '') or (SalesHeader."Sell-to Customer No." <> '') then begin
            if SalesHeader."Sell-to Customer No." <> '' then
                Customer.Get(SalesHeader."Sell-to Customer No.")
            else
                Customer.Get(FilterCustNo);
            if Customer."Bill-to Customer No." <> '' then
                SalesHeader."Bill-to Customer No." := Customer."Bill-to Customer No."
            else
                SalesHeader."Bill-to Customer No." := Customer."No.";
            SkipCreditCheck := SalesHeader.CheckCustCredit(Customer."No.");//KM
            IF (SkipCreditCheck = FALSE) AND ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) THEN
                CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
        end else
            if FilterContNo <> '' then begin
                Cont.Get(FilterContNo);
                if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."Company No.") then begin
                    Customer.Get(ContBusinessRelation."No.");
                    if Customer."Bill-to Customer No." <> '' then
                        SalesHeader."Bill-to Customer No." := Customer."Bill-to Customer No."
                    else
                        SalesHeader."Bill-to Customer No." := Customer."No.";
                    SkipCreditCheck := SalesHeader.CheckCustCredit(Customer."No.");//KM
                    IF (SkipCreditCheck = FALSE) AND ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) THEN
                        CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCopySelltoCustomerAddressFieldsFromCustomerOnBeforeAssignRespCenter', '', false, false)]
    procedure OnCopySelltoCustomerAddressFieldsFromCustomerOnBeforeAssignRespCenter(var SalesHeader: Record "Sales Header"; var SellToCustomer: Record Customer; var IsHandled: Boolean)
    begin
        SalesHeader."Sell-to Customer Name 3" := SellToCustomer."Name 3";//ACX-RK 16062021
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    procedure OnAfterSetFieldsBilltoCustomer(var SalesHeader: Record "Sales Header"; Customer: Record Customer; xSalesHeader: Record "Sales Header"; SkipBillToContact: Boolean; CUrrentFieldNo: Integer)
    begin
        SalesHeader."Bill-to Name 3" := Customer."Name 3";//ACX-RK 16062021
        SalesHeader.VALIDATE("Salesperson Code", Customer."Salesperson Code");//Sales Hierarchy
        SalesHeader.VALIDATE("Scheme Code", Customer."Scheme Code");//Sales Hierarchy
        SalesHeader.UddateSalesHierarchy();//Sales Hierarch
    end;
}