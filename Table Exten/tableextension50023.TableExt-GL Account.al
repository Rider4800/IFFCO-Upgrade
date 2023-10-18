tableextension 50023 tableextension50023 extends "G/L Account"
{
    // //ACXCP02 //Current Date and Time Capture
    fields
    {
        field(50000; "Branch GL"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50001; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'acxcp';
        }
    }

    trigger OnAfterInsert()
    var
        DimMgt: Codeunit DimensionManagement;
        CostAccSetup: Record "Cost Accounting Setup";
        CostAccMgt: Codeunit "Cost Account Mgt";
    begin
        DimMgt.UpdateDefaultDim(DATABASE::"G/L Account", "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

        IF CostAccSetup.GET THEN
            CostAccMgt.UpdateCostTypeFromGLAcc(Rec, xRec, 0);

        //ACXCP02 +
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP02 -
    end;
}

