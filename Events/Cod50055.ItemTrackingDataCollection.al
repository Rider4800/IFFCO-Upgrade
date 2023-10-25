codeunit 50055 ItemTrackingDataCollection
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment', '', false, false)]
    local procedure OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment(var TempGlobalEntrySummary: Record "Entry Summary" temporary; var TempReservEntry: Record "Reservation Entry")
    begin
        IF TempReservEntry.Positive THEN BEGIN
            //ACX-RK 13032021 Begin
            TempGlobalEntrySummary."Manufacturing Date" := TempReservEntry."MFG Date";
            TempGlobalEntrySummary."Batch MRP" := TempReservEntry."Batch MRP";
            //ACX-RK End
        end;
    end;
}