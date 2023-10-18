codeunit 50034 PurchaseLineTableEvent
{

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnAfterInitHeaderDefaults(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    begin
        PurchLine."Certificate of Analysis" := PurchHeader."Certificate of Analysis";//ACX-RK 160421
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    var
        AllowedSections: Record "Allowed Sections";
    begin
        //AK-01 13082021 START FOR TDS Nature of Deduction UPDATE IN LINE
        AllowedSections.RESET;
        AllowedSections.SETRANGE("Vendor No", PurchHeader."Buy-from Vendor No.");
        AllowedSections.SETFILTER("TDS Section Description", 'GD ON PURC');
        IF AllowedSections.FINDFIRST THEN
            PurchLine.VALIDATE("TDS Section Code", AllowedSections."TDS Section")
        ELSE
            PurchLine."TDS Section Code" := '';
        //AK-01 END
    end;
}
