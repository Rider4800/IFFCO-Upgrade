pageextension 50078 pageextension50078 extends "Dimension Values"
{
    layout
    {
        modify("Dimension Code")
        {
            Visible = true;
        }
        addafter("Consolidation Code")
        {
            field("STATE-FIN"; rec."STATE-FIN")
            {
            }
            field("Branch G/L Account"; rec."Branch G/L Account")
            {
            }
            field("Fin Branch Boolean"; rec."Fin Branch Boolean")
            {
            }
            field("FIN LOCATION-EMP"; rec."FIN LOCATION-EMP")
            {
            }
            field("STATE-EMP"; rec."STATE-EMP")
            {
            }
            field("DEPARTMENT-EMP"; rec."DEPARTMENT-EMP")
            {
            }
        }
    }
}

