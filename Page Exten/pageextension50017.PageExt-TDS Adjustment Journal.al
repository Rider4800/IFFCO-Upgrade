pageextension 50017 pageextension50017 extends "TDS Adjustment Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("Location Code"; Rec."Location Code")
            {
            }
        }
        modify("Transaction No")
        {
            trigger OnAfterValidate()
            begin

            end;
        }
    }


    //Unsupported feature: Code Modification on "InitTaxJnlLine(PROCEDURE 1500000)".

    //procedure InitTaxJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TaxJnlBatch.GET("Journal Template Name","Journal Batch Name");
    IF TaxJnlBatch."No. Series" <> '' THEN BEGIN
      CLEAR(NoSeriesMgt);
    #4..112
      TaxJnlLine."Document Type" := TaxJnlLine."Document Type"::" ";
      TaxJnlLine."Bal. TDS/TCS Including SHECESS" := TDS."Bal. TDS Including SHE CESS";
      TaxJnlLine."Work Tax" := TRUE;
      TaxJnlLine.INSERT;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..115
      TaxJnlLine."Invoice Amount" := TDS."Invoice Amount";//ACX-RK
      TaxJnlLine.INSERT;
    END;
    */
    //end;
}

