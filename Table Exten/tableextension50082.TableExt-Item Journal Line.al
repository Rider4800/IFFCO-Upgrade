tableextension 50082 tableextension50082 extends "Item Journal Line"
{
    fields
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                //ACX-RK 18032021 Begin
                recItem.RESET();
                recItem.SETRANGE("No.", "Item No.");
                IF recItem.FIND('-') THEN BEGIN
                    recItemUOM.RESET();
                    recItemUOM.SETRANGE("Item No.", recItem."No.");
                    recItemUOM.SETRANGE(Code, recItem."Sales Unit of Measure");
                    IF recItemUOM.FINDFIRST THEN BEGIN
                        "Opening Balance Qty. in KG" := recItemUOM."Qty. per Unit of Measure" * Quantity;
                    END;
                END;
                //ACX-RK End

            end;
        }

        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                //ACX-RK 18032021 Begin
                recItemUOM.RESET();
                recItemUOM.SETRANGE(recItemUOM."Item No.", "Item No.");
                recItemUOM.SETRANGE(Code, "Unit of Measure Code");
                IF recItemUOM.FINDFIRST THEN BEGIN
                    "Opening Balance Qty. in KG" := recItemUOM."Qty. per Unit of Measure" * Quantity;
                END;
                //ACX-RK End

            end;
        }
        field(50000; Narration; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50003; "Opening Balance Qty. in KG"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 3;
            Description = 'ACX-RK';
        }
    }

    var
        recItemUOM: Record 5404;
        recItem: Record 27;
}

