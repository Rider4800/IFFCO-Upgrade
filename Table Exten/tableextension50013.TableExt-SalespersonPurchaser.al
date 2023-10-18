tableextension 50013 tableextension50013 extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Designation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX_KM';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DESIGNATION'));

            trigger OnValidate()
            begin
                recDimValue.RESET();
                recDimValue.SETRANGE(Code, "Designation Code");
                IF recDimValue.FINDFIRST THEN
                    "Designation Name" := recDimValue.Name
                ELSE
                    "Designation Name" := '';
            end;
        }
        field(50001; "Designation Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX_KM';
            Editable = false;
        }
        field(50002; "Salesperson Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX';
            OptionCaption = ' ,SalesPerson,Purchaser';
            OptionMembers = " ",SalesPerson,Purchaser;
        }
    }

    var
        recDimValue: Record "Dimension Value";
}

