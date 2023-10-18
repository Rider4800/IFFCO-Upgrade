table 50014 "Sales Hierarchy"
{

    fields
    {
        field(1; "FO Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "FO Code");
                IF recSalesPurch.FINDFIRST THEN
                    "FO Name" := recSalesPurch.Name
                ELSE
                    "FO Name" := '';
            end;
        }
        field(2; "FO Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "FA Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('FA'));

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "FA Code");
                IF recSalesPurch.FINDFIRST THEN
                    "FA Name" := recSalesPurch.Name
                ELSE
                    "FA Name" := '';
            end;
        }
        field(4; "FA Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "TME Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('TME'));

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "TME Code");
                IF recSalesPurch.FINDFIRST THEN
                    "TME Name" := recSalesPurch.Name
                ELSE
                    "TME Name" := '';
            end;
        }
        field(6; "TME Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "RME Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('RME'));

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "RME Code");
                IF recSalesPurch.FINDFIRST THEN
                    "RME Name" := recSalesPurch.Name
                ELSE
                    "RME Name" := '';
            end;
        }
        field(8; "RME Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "ZMM Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('ZMM'));

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "ZMM Code");
                IF recSalesPurch.FINDFIRST THEN
                    "ZMM Name" := recSalesPurch.Name
                ELSE
                    "ZMM Name" := '';
            end;
        }
        field(10; "ZMM Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "HOD Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('HOD'));

            trigger OnValidate()
            begin
                recSalesPurch.RESET();
                recSalesPurch.SETRANGE(Code, "HOD Code");
                IF recSalesPurch.FINDFIRST THEN
                    "HOD Name" := recSalesPurch.Name
                ELSE
                    "HOD Name" := '';
            end;
        }
        field(12; "HOD Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "FO Code", "FA Code", "Start Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recSalesPurch: Record 13;
}

