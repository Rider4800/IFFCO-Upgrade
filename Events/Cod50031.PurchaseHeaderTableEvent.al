codeunit 50031 PurchaseHeaderTableEvent
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    begin
        PurchaseHeader."Finance Branch A/c Code" := Vendor."Finance Branch A/c Code";//Acx_Anubha
    end;
}
