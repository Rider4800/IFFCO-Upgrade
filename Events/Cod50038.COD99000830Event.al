codeunit 50038 COD99000830Event
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeCreateRemainingReservEntry', '', false, false)]
    local procedure OnBeforeCreateRemainingReservEntry(var ReservationEntry: Record "Reservation Entry"; FromReservationEntry: Record "Reservation Entry")
    begin
        //ACX-RK 12032021 Begin
        ReservationEntry."MFG Date" := FromReservationEntry."MFG Date";
        ReservationEntry."Batch MRP" := FromReservationEntry."Batch MRP";
        //ACX-RK End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeCreateRemainingNonSurplusReservEntry', '', false, false)]
    local procedure OnBeforeCreateRemainingNonSurplusReservEntry(var ReservationEntry: Record "Reservation Entry")
    begin
        //ACX-RK 12032021 Begin
        ReservationEntry."MFG Date" := ReservationEntry."MFG Date";
        ReservationEntry."Batch MRP" := ReservationEntry."Batch MRP";
        //ACX-RK End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeSplitReservEntry', '', false, false)]
    local procedure OnBeforeSplitReservEntry(var ReservationEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        //ACX-RK 12032021 Begin
        ReservationEntry."MFG Date" := TempTrackingSpecification."MFG Date";
        ReservationEntry."Batch MRP" := TempTrackingSpecification."Batch MRP";
        //ACX-RK End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnBeforeSplitNonSurplusReservEntry', '', false, false)]
    local procedure OnBeforeSplitNonSurplusReservEntry(var ReservationEntry: Record "Reservation Entry"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        //ACX-RK 12032021 Begin
        ReservationEntry."MFG Date" := TempTrackingSpecification."MFG Date";
        ReservationEntry."Batch MRP" := TempTrackingSpecification."Batch MRP";
        //ACX-RK End
    end;

}
