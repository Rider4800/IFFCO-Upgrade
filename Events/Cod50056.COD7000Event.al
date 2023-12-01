codeunit 50056 COD7000Event
{
    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeFindSalesPrice', '', false, false)]
    local procedure OnBeforeFindSalesPrice(var FromSalesPrice: Record "Sales Price")
    begin
        FromSalesPrice.SetRange("MRP Price New", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeActivatedCampaignExists', '', false, false)]
    local procedure OnBeforeActivatedCampaignExists(CampaignNo: Code[20]; ContNo: Code[20]; CustNo: Code[20]; var IsHandled: Boolean; var ToCampaignTargetGr: Record "Campaign Target Group")
    begin
        IsHandled := true;
        ActivatedCampaignExists_iffcomc(ToCampaignTargetGr, CampaignNo, CustNo)
    end;

    local procedure ActivatedCampaignExists_iffcomc(VAR ToCampaignTargetGr: Record "Campaign Target Group"; CampaignNo: Code[20]; CustNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
    begin
        //WITH FromCampaignTargetGr DO BEGIN
        ToCampaignTargetGr.RESET;
        ToCampaignTargetGr.DELETEALL;

        IF CampaignNo <> '' THEN BEGIN
            ToCampaignTargetGr."Campaign No." := CampaignNo;
            ToCampaignTargetGr.INSERT;
        END;


        EXIT(ToCampaignTargetGr.FINDFIRST);
        // END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeSalesLinePriceExists', '', false, false)]
    local procedure OnBeforeSalesLinePriceExists(Currency: Record Currency; CurrencyFactor: Decimal; Qty: Decimal; QtyPerUOM: Decimal; ShowAll: Boolean; StartingDate: Date; var InHandled: Boolean; var SalesHeader: Record "Sales Header";
    var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary)
    begin
        /*FindSalesPrice(
                    TempSalesPrice, "Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                    "Customer Price Group", SalesHeader."Campaign No.", "No.", "Variant Code", "Unit of Measure Code", //acxcp_300622_CampaignCode
                    SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll); //MZH
    */
    end;
}
