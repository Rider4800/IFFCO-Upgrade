table 50013 "Employee Geography Matrix"
{

    fields
    {
        field(1; "Employee Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "Employee Code");
                IF recSalesPurch.FINDFIRST THEN BEGIN
                    "Employee Name" := recSalesPurch.Name;
                    "E-Mail" := recSalesPurch."E-Mail";
                    "Desgination Code" := recSalesPurch."Designation Code";
                    "Desgination Name" := recSalesPurch."Designation Name";
                    "State Code" := recSalesPurch."Global Dimension 1 Code";
                    recDimValue.RESET();
                    recDimValue.SETRANGE(Code, recSalesPurch."Global Dimension 1 Code");
                    IF recDimValue.FINDFIRST THEN
                        "State Description" := recDimValue.Name;
                END ELSE BEGIN
                    "Employee Name" := '';
                    "E-Mail" := '';
                    "Desgination Code" := '';
                    "Desgination Name" := '';
                    "State Code" := '';
                    "State Description" := '';
                END;
            end;
        }
        field(2; "Employee Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "E-Mail"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Desgination Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Desgination Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Zone Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Zone".Code;

            trigger OnValidate()
            begin
                recZone.RESET();
                recZone.SETRANGE(Code, "Zone Code");
                IF recZone.FINDFIRST THEN
                    "Zone Description" := recZone.Description
                ELSE
                    "Zone Description" := '';
            end;
        }
        field(7; "Zone Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "State Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('STATE'));

            trigger OnValidate()
            begin
                recDimValue.RESET();
                recDimValue.SETRANGE(Code, "State Code");
                IF recDimValue.FINDFIRST THEN
                    "State Description" := recDimValue.Name
                ELSE
                    "State Description" := '';
            end;
        }
        field(9; "State Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Region Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('REGION'));

            trigger OnValidate()
            begin
                recDimValue.RESET();
                recDimValue.SETRANGE(Code, "Region Code");
                IF recDimValue.FINDFIRST THEN
                    "Region Description" := recDimValue.Name
                ELSE
                    "Region Description" := ''
            end;
        }
        field(11; "Region Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Area Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('AREA'));

            trigger OnValidate()
            begin
                recDimValue.RESET();
                recDimValue.SETRANGE(Code, "Area Code");
                IF recDimValue.FINDFIRST THEN
                    "Area Description" := recDimValue.Name
                ELSE
                    "Area Description" := ''
            end;
        }
        field(13; "Area Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "State Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recSalesPurch: Record 13;
        recDimValue: Record 349;
        recZone: Record 5957;
}

