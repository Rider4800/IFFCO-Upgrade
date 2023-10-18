tableextension 50048 tableextension50048 extends "Dimension Value"
{
    fields
    {
        field(50000; "STATE-FIN"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'));
        }
        field(50001; "Branch G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "G/L Account"."No.";
        }
        field(50002; "Fin Branch Boolean"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50003; "FIN LOCATION-EMP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('FIN LOC'));
        }
        field(50004; "STATE-EMP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'));
        }
        field(50005; "DEPARTMENT-EMP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('CANT. DEPTT'));
        }
    }
}

