codeunit 50053 COD260Event
{
    [EventSubscriber(ObjectType::Codeunit, 260, 'OnBeforeSendEmail', '', false, false)]
    local procedure OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var PostedDocNo: Code[20])
    var
        SalesInvHdr: Record "Sales Invoice Header";
        recCustomer: Record Customer;
        GLsetup: Record "General Ledger Setup";
    begin
        GLsetup.GET;
        SalesInvHdr.RESET;
        SalesInvHdr.SETRANGE("No.", PostedDocNo);
        IF SalesInvHdr.FINDFIRST THEN BEGIN
            recCustomer.RESET;
            recCustomer.SETRANGE("No.", SalesInvHdr."Sell-to Customer No.");
            IF recCustomer.FINDFIRST THEN BEGIN
                TempEmailItem."Send to" := recCustomer."E-Mail";
                TempEmailItem."Send CC" := GLsetup."E-Mail CC";
            END
            ELSE BEGIN
                TempEmailItem."Send to" := '';
                TempEmailItem."Send CC" := '';
                TempEmailItem."Send BCC" := '';
                CLEAR(TempEmailItem.Body);
            END;
        END;

    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateQuantity', '', false, false)]
    local procedure OnBeforeValidateQuantity(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer; var IsHandled: Boolean)
    var
        ItemRec: Record Item;//pp
        ILERec: Record "Item Ledger Entry";
        ILERemQty: Decimal;
        Text001: Label 'The quantity on inventory is not sufficient to cover the net change in inventory. Do you still want to record the quantity?';
        Text002: Label 'The update has been interrupted to respect the warning.';
        CustRec: Record Customer;
        Text003: Label 'The customer %1 has an credit limit of %2. The update has been interrupted to respect the warning.';
    begin
        ILERemQty := 0;
        ILERec.Reset();
        ILERec.SetRange("Item No.", SalesLine."No.");
        ILERec.SetRange("Location Code", SalesLine."Location Code");
        ILERec.SetRange(Open, true);
        if ILERec.FindFirst() then begin
            repeat
                ILERemQty := ILERemQty + ILERec."Remaining Quantity"
            until ILERec.Next() = 0;
        end;
        if (ILERemQty - SalesLine.Quantity) <= 0 then begin
            if CONFIRM(Text001, TRUE) THEN begin
            end else
                Error(Text002);
        end;
        // if CustRec.Get(SalesLine."Sell-to Customer No.") then begin
        //     if CustRec.GetTotalAmountLCY + (SalesLine.Quantity * SalesLine."Unit Price") > CustRec."Credit Limit (LCY)" then
        //         Error(Text003, CustRec."No.", CustRec."Credit Limit (LCY)");
        // end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeUpdateQuantityFromUOMCode', '', false, false)]
    local procedure OnBeforeUpdateQuantityFromUOMCode(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
}
