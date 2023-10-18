tableextension 50042 tableextension50042 extends "Payment Method"
{
    fields
    {
        field(50000; "Payment Method Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'),
                                                          "Fin Branch Boolean" = FILTER(true));
        }
    }
}

