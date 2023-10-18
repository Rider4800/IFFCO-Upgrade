codeunit 50032 TransferLineEventTable
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnBeforeGetDefaultBin', '', false, false)]
    local procedure OnBeforeGetDefaultBin(var TransferLine: Record "Transfer Line")
    var
        TranferLineSingInst: Codeunit 50033;
    begin
        Clear(TranferLineSingInst);
        TranferLineSingInst.ClearVariables();
        TranferLineSingInst.SetData(TransferLine."Item No.");
        TransferLine."Item No." := ''; //12887 to skip code of GetDefaultBin funcion and add custom code on event OnAfterGetDefaultBin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterGetDefaultBin', '', false, false)]
    local procedure OnAfterGetDefaultBin(var TransferLine: Record "Transfer Line"; FromLocationCode: Code[10]; ToLocationCode: Code[10])
    var
        TranferLineSingInst: Codeunit 50033;
        ItemNoGlb: Code[20];
    begin
        Clear(TranferLineSingInst);
        TranferLineSingInst.GetData(ItemNoGlb);
        TransferLine."Item No." := ItemNoGlb;

        TransferLine.GetHedearBin;//KM
        IF TransferLine."Transfer-from Bin Code" = '' THEN BEGIN//KM
            IF (FromLocationCode <> '') AND (TransferLine."Item No." <> '') THEN BEGIN
                GetLocation(FromLocationCode);
                IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN BEGIN
                    WMSManagement.GetDefaultBin(TransferLine."Item No.", TransferLine."Variant Code", FromLocationCode, TransferLine."Transfer-from Bin Code");
                    HandleDedicatedBin(FALSE, TransferLine);
                END;
            END;
        END;//KM

        IF TransferLine."Transfer-To Bin Code" = '' THEN BEGIN //KM
            IF (ToLocationCode <> '') AND (TransferLine."Item No." <> '') THEN BEGIN
                GetLocation(ToLocationCode);
                IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN BEGIN
                    WMSManagement.GetDefaultBin(TransferLine."Item No.", TransferLine."Variant Code", ToLocationCode, TransferLine."Transfer-To Bin Code");
                END;
            END;
        END;//KM
    end;

    local procedure HandleDedicatedBin(IssueWarning: Boolean; TransferLine: Record "Transfer Line")
    var
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
    begin
        if not TransferLine.IsInbound() and (TransferLine."Quantity (Base)" <> 0) then
            WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc(TransferLine."Transfer-from Code", TransferLine."Transfer-from Bin Code", IssueWarning);
    end;


    local procedure GetLocation(LocationCode: Code[10])
    begin
        if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;

    var
        Location: Record 14;
        WMSManagement: Codeunit "WMS Management";
}
