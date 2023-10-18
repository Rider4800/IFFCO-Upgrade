tableextension 50062 tableextension50062 extends "Item Unit of Measure"
{
    fields
    {
        field(50000; "Conversion UOM"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckConversion;
            end;
        }
    }

    local procedure CheckConversion()
    begin
        ItemUom.RESET();
        ItemUom.SETRANGE("Item No.", "Item No.");
        ItemUom.SETRANGE("Conversion UOM", TRUE);
        IF ItemUom.FINDFIRST THEN BEGIN
            ItemUom."Conversion UOM" := FALSE;
            ItemUom.MODIFY;
        END;
    end;

    var
        ItemUom: Record 5404;
}

