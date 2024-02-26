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

    // [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckCreditMaxBeforeInsert', '', false, false)]
    // procedure OnBeforeCheckCreditMaxBeforeInsert(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; HideCreditCheckDialogue: Boolean; FilterCustNo: Code[20]; FilterContNo: Code[20])
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckCreditLimitIfLineNotInsertedYet', '', false, false)]
    procedure OnBeforeCheckCreditLimitIfLineNotInsertedYet(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        Cont: Record Contact;
        ContBusinessRelation: Record "Contact Business Relation";
        SkipCreditCheck: Boolean;
        CheckCreditLimit: Page "Check Credit Limit";
        OK: Boolean;
        Text000: Label 'The update has been interrupted to respect the warning.';
    begin

        // IsHandled := true;
        // if (FilterCustNo <> '') or (SalesHeader."Sell-to Customer No." <> '') then begin
        //     if SalesHeader."Sell-to Customer No." <> '' then
        //         Customer.Get(SalesHeader."Sell-to Customer No.")
        //     else
        //         Customer.Get(FilterCustNo);
        //     if Customer."Bill-to Customer No." <> '' then
        //         SalesHeader."Bill-to Customer No." := Customer."Bill-to Customer No."
        //     else
        //         SalesHeader."Bill-to Customer No." := Customer."No.";
        //     SkipCreditCheck := SalesHeader.CheckCustCredit(Customer."No.");//KM
        //     IF (SkipCreditCheck = FALSE) AND ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) THEN begin
        //         //CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
        //         // IF NOT CheckCreditLimit.SalesHeaderShowWarning(SalesHeader) THEN
        //         //     SalesHeader.OnCustomerCreditLimitNotExceeded
        //         // ELSE BEGIN
        //         //CreditLimitExceeded := TRUE;
        //         OK := CheckCreditLimit.RUNMODAL = ACTION::Yes;
        //         CLEAR(CheckCreditLimit);
        //         IF not OK THEN
        //             ERROR(Text000);
        //         //END;
        //     end;
        // end else
        //     if FilterContNo <> '' then begin
        //         Cont.Get(FilterContNo);
        //         if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."Company No.") then begin
        //             Customer.Get(ContBusinessRelation."No.");
        //             if Customer."Bill-to Customer No." <> '' then
        //                 SalesHeader."Bill-to Customer No." := Customer."Bill-to Customer No."
        //             else
        //                 SalesHeader."Bill-to Customer No." := Customer."No.";
        //             SkipCreditCheck := SalesHeader.CheckCustCredit(Customer."No.");//KM
        //             IF (SkipCreditCheck = FALSE) AND ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) THEN
        //                 CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
        //         end;
        //     end;
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

    //->E-Bazaar Customization
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress', '', false, false)]
    procedure OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress(var SalesHeader: Record "Sales Header"; Customer: Record Customer)
    begin
        SalesHeader."Parent Customer" := Customer."Parent Customer";//acxvg
        SalesHeader."Campaign No." := Customer."Preferred Campaign No.";//9509 03112023
    end;
    //<-E-Bazaar Customization

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeTestStatusOpen', '', false, false)]
    procedure OnBeforeTestStatusOpen(xSalesHeader: Record "Sales Header"; var SalesHeader: Record "Sales Header"; CallingFieldNo: Integer; sender: Record "Sales Header")
    var
        CLERec: Record "Cust. Ledger Entry";
        Text001: Label 'The customer %1 has an overdue balance of %2.';
        Text002: Label 'The customer %1 has an credit limit of %2.';
        CLEOverdueAmt: Decimal;
        CustRec: Record Customer;
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo" then begin
            if CustRec.Get(SalesHeader."Sell-to Customer No.") then begin
                if (CustRec."One Time Credit Pass Allow" = false) and (CustRec."Excludes Credit Limit Allow" = false) then begin
                    CLEOverdueAmt := 0;
                    CLERec.Reset();
                    CLERec.SetCurrentKey("Document Type", "Customer No.", Open, "Due Date");
                    CLERec.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                    CLERec.SetRange(Open, true);
                    CLERec.SetFilter("Due Date", '<%1', Today);
                    if CLERec.FindFirst() then begin
                        repeat
                            CLERec.CalcFields("Remaining Amount");
                            CLEOverdueAmt := CLEOverdueAmt + CLERec."Remaining Amount"
                        until CLERec.Next() = 0;
                        if CLEOverdueAmt > 0 then
                            Error(Text001, CLERec."Customer No.", CLEOverdueAmt);
                    end;

                    CustRec.CalcFields("Balance (LCY)");
                    if CustRec."Balance (LCY)" > CustRec."Credit Limit (LCY)" then
                        Error(Text002, CustRec."No.", CustRec."Credit Limit (LCY)");
                end;
            end;
        end;
    end;
}