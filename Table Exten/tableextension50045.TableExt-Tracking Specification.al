tableextension 50045 tableextension50045 extends "Tracking Specification"
{
    fields
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                //KM
                IF NOT recLotInfo.GET(rec."Item No.", rec."Variant Code", rec."Lot No.") THEN BEGIN
                    recLotInfoInsert.INIT;
                    recLotInfoInsert.VALIDATE("Item No.", rec."Item No.");
                    recLotInfoInsert.VALIDATE("Variant Code", rec."Variant Code");
                    recLotInfoInsert.VALIDATE("Lot No.", rec."Lot No.");
                    recLotInfoInsert.INSERT(TRUE);
                END;
                //KM
                UpdateReservEntry;//KM
            end;
        }
        //->Team-17783
        modify("Entry No.")
        {
            trigger OnBeforeValidate()
            begin
                MESSAGE('validation');
            end;
        }
        //<-Team-17783
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

    local procedure CalculateExpirationDate(ManufecturingDate: Date; CalculationValue: DateFormula): Date
    begin
    end;

    local procedure UpdateReservEntry()
    begin
        recReserv.RESET();
        recReserv.SETRANGE("Source ID", rec."Source ID");
        recReserv.SETRANGE("Source Ref. No.", rec."Source Ref. No.");
        recReserv.SETRANGE("Item No.", rec."Item No.");
        IF recReserv.FINDFIRST THEN BEGIN
            REPEAT
                ModifyReservEntry(recReserv."Source ID", recReserv."Source Ref. No.", recReserv."Item No.", recReserv."Lot No.");
            UNTIL recReserv.NEXT = 0;
        END;
        //Rec Validate
        recLotInfo.RESET();
        recLotInfo.SETRANGE("Item No.", rec."Item No.");
        recLotInfo.SETRANGE("Lot No.", rec."Lot No.");
        IF recLotInfo.FINDFIRST THEN BEGIN
            rec."MFG Date" := recLotInfo."MFG Date";
            rec."Batch MRP" := recLotInfo."Batch MRP";
        END;
    end;

    local procedure ModifyReservEntry(SourceID: Code[20]; "SourceRefNo.": Integer; "ItemNo.": Code[20]; "LotNo.": Code[20])
    var
        recReserv1: Record 337;
        recLotInfo1: Record 6505;
    begin
        recReserv1.RESET();
        recReserv1.SETRANGE("Source ID", SourceID);
        recReserv1.SETRANGE("Source Ref. No.", "SourceRefNo.");
        recReserv1.SETRANGE("Item No.", "ItemNo.");
        recReserv1.SETRANGE("Lot No.", "LotNo.");
        IF recReserv1.FINDFIRST THEN BEGIN
            recLotInfo1.RESET();
            recLotInfo1.SETRANGE("Item No.", recReserv1."Item No.");
            recLotInfo1.SETRANGE("Lot No.", recReserv1."Lot No.");
            IF recLotInfo1.FINDFIRST THEN BEGIN
                recReserv1."MFG Date" := recLotInfo1."MFG Date";
                recReserv1."Batch MRP" := recLotInfo1."Batch MRP";
                recReserv1.MODIFY();
            END;
        END;
    end;

    var
        recItem: Record Item;
        recLotInfoInsert: Record 6505;
        recLotInfo: Record 6505;
        recReserv: Record 337;
}

