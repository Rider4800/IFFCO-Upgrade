tableextension 50046 tableextension50046 extends "Reservation Entry"
{
    fields
    {
        field(50000; "MFG Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Batch MRP"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
    }
    //->Team-17783
    trigger OnBeforeInsert()
    begin
        IF "Source Type" = 37 THEN BEGIN
            recReserv.RESET();
            recReserv.SETRANGE("Source ID", "Source ID");
            recReserv.SETRANGE("Source Ref. No.", "Source Ref. No.");
            IF recReserv.FINDFIRST THEN
                ERROR('Multipal lot selection not allow');
        END;
    end;
    //<-Team-17783

    var
        recReserv: Record "Reservation Entry";
}

