tableextension 50038 tableextension50038 extends "Vendor Ledger Entry"
{
    fields
    {
        //->Team-17783
        // modify("TDS Group")
        // {
        //     OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Goods';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 13703)".

        // }
        //<-Team-17783
    }

    //Unsupported feature: Code Modification on "CalcAppliedTDSBase(PROCEDURE 1500002)".

    //procedure CalcAppliedTDSBase();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS(Amount);
    IF Amount = 0 THEN
      EXIT(0);
    #4..6
      REPEAT
        IF TDSEntry."TDS Base Amount" = 0 THEN
          TDSBaseAmount += TDSEntry."Work Tax Base Amount"
        ELSE
          TDSBaseAmount += TDSEntry."TDS Base Amount";
      UNTIL TDSEntry.NEXT = 0;

    IF TDSEntry."TDS Line Amount" > TDSBaseAmount THEN
    #15..22
        ApplicationRatio := ABS(AppliedAmount) / TDSBaseAmount;

    EXIT(ROUND(TDSBaseAmount * ApplicationRatio));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
        //ACX-RK Begin
        ELSE BEGIN
          IF TDSEntry."Calc. Over & Above Threshold" THEN BEGIN
            IF TDSEntry."TDS Base Amount" < TDSEntry."Invoice Amount" THEN
              TDSBaseAmount += TDSEntry."Invoice Amount"
        //ACX-RK End
        ELSE
          TDSBaseAmount += TDSEntry."TDS Base Amount";
        //ACX-RK Begin
        END ELSE
            TDSBaseAmount += TDSEntry."TDS Base Amount";
        //ACX-RK End
        END;
    #12..25
    */
    //end;
}

