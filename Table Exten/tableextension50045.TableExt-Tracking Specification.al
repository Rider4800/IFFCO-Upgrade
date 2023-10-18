tableextension 50045 tableextension50045 extends "Tracking Specification"
{
    fields
    {
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

    var
        recItem: Record Item;
}

