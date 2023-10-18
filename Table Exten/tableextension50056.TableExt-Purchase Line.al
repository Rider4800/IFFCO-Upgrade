tableextension 50056 tableextension50056 extends "Purchase Line"
{
    fields
    {

        /*12887---> TDS Group field is deleted
          modify("TDS Group")
          {
              OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Rent for Plant & Machinery,Rent for Land & Building,Banking Services,Compensation On Immovable Property,PF Accumulated,Payment For Immovable Property,Goods';

              //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 16363)".

          }
          <----12887*/

        field(50000; "Short Quantity Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Excess/Short Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Certificate of Analysis"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK 140421';
        }
        field(50003; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
    //12887 need to review this---->
    //Unsupported feature: Variable Insertion (Variable: OverAndAboveThresholdAmount) (VariableCollection) on "CalculateTDS(PROCEDURE 1280004)".



    //Unsupported feature: Code Modification on "CalculateTDS(PROCEDURE 1280004)".

    //procedure CalculateTDS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH PurchHeader DO
      IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
        IF HasLineWithTDS THEN
    #4..142
                        "Surcharge %" := TDSSetup."Surcharge %";
                      END ELSE BEGIN
                        TDSGroup.FindOnDate("TDS Group",PurchHeader."Posting Date");
                        IF (PreviousAmount + CurrentPOAmount) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                          "Surcharge Base Amount" := TDSBaseLCY;
                          "Surcharge %" := TDSSetup."Surcharge %";
    #149..212
                        IF TDSGroup."Per Contract Value" <> 0 THEN
                          IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
                            IF PreviousContractAmount <> 0 THEN
                              "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                                CurrentPOContractAmt
                            ELSE
                              "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousBaseAMTWithTDS + CurrentPOAmount;
                            "TDS %" := TDSSetupPercentage;
                            "eCESS % on TDS" := TDSSetup."eCESS %";
                            "SHE Cess % On TDS" := TDSSetup."SHE Cess %";
    #223..283
                        ELSE // New Code Ends here
                          IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
                            IF PreviousTDSAmt = 0 THEN
                              "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS
                            ELSE
                              "TDS Base Amount" := TDSBaseLCY;
                            IF PreviousTDSAmt1 <> 0 THEN
                              "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount;
                            "TDS %" := TDSSetupPercentage;
                            "eCESS % on TDS" := TDSSetup."eCESS %";
                            "SHE Cess % On TDS" := TDSSetup."SHE Cess %";
    #295..326
                            TDSEntry.SETRANGE(Applied,FALSE);
                            TDSEntry.SETRANGE("TDS Adjustment",FALSE);
                            TDSEntry.SETRANGE(Adjusted,FALSE);
                            IF TDSEntry.FIND('-') THEN
                              REPEAT
                                InsertTDSBuf(TDSEntry,PurchHeader."Posting Date",CalculateSurcharge,TRUE);
    #333..535
                        END;
                      END ELSE BEGIN
                        TDSGroup.FindOnDate("TDS Group",PurchHeader."Posting Date");
                        IF PreviousAmount > TDSGroup."TDS Threshold Amount" THEN BEGIN
                          "TDS Base Amount" := "TDS Base Amount";
                          "TDS %" := TDSSetupPercentage;
                          "eCESS % on TDS" := TDSSetup."eCESS %";
                          "SHE Cess % On TDS" := TDSSetup."SHE Cess %";
    #544..806
            PurchLine.MODIFY;
          UNTIL PurchLine.NEXT = 0;
        END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..145
                        //ACX-RK Begin
                        IF TDSSetup."Calc. Over & Above Threshold" THEN
                          OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
                        //ACX-RK End
    #146..215
                              //ACX-RK Begin
                              {
                              "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                                CurrentPOContractAmt
                              }
                              "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                                CurrentPOContractAmt - OverAndAboveThresholdAmount
                              //ACX-RK End
                            ELSE
                              //ACX-RK Begin
                              //"TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousBaseAMTWithTDS + CurrentPOAmount;
                              "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousBaseAMTWithTDS + CurrentPOAmount - OverAndAboveThresholdAmount;
                              //ACX-RK End
    #220..286
                              //ACX-RK Begin
                                //"TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS
                                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS - OverAndAboveThresholdAmount
                              //ACX-RK End
                              ELSE
                              //ACX-RK Begin
                                //"TDS Base Amount" := TDSBaseLCY;
                                "TDS Base Amount" := TDSBaseLCY - TDSGroup."TDS Threshold Amount" - OverAndAboveThresholdAmount;
                              //ACX-RK
                            IF PreviousTDSAmt1 <> 0 THEN
                              //ACX-RK Begin
                                //"TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount;
                                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - OverAndAboveThresholdAmount;
                              //ACX-RK End
    #292..329
                            TDSEntry.SETRANGE("Calc. Over & Above Threshold",FALSE);//ACX-RK
    #330..538
                        //ACX-RK Begin
                        IF TDSSetup."Calc. Over & Above Threshold" THEN
                          OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
                        //ACX-RK
                        IF PreviousAmount > TDSGroup."TDS Threshold Amount" THEN BEGIN
                          //ACX-RK Begin
                          IF "TDS Base Amount" > TDSGroup."TDS Threshold Amount" THEN
                            "TDS Base Amount" := "TDS Base Amount" - OverAndAboveThresholdAmount;
                          //"TDS Base Amount" := "TDS Base Amount";
                        //ACX-RK End
    #541..809
    */
    //end;


    //Unsupported feature: Code Modification on "UpdatePurchLineForGST(PROCEDURE 1500027)".

    //procedure UpdatePurchLineForGST();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF PurchHeader."POS as Vendor State" THEN
      IF NOT (Type = Type::"G/L Account") THEN
        ERROR(TypeErr,Type);
    #4..16
    GetPurchHeader;
    IF (GSTManagement.IsGSTApplicable(PurchHeader.Structure)) AND (PurchHeader."GST Input Service Distribution") THEN BEGIN
      IF Type IN [Type::"Fixed Asset",Type::"Charge (Item)",Type::Item] THEN
        ERROR(ChargeItemErr,Type);
      IF ("GST Group Code" <> '') AND ("GST Group Type" <> "GST Group Type"::Service) THEN
      ERROR(TypeISDErr,Type,FIELDNAME("GST Group Type"),"GST Group Type"::Service);
    END;
    #24..30
      "Bill to-Location(POS)" := PurchHeader."Bill to-Location(POS)"
    ELSE
      "Bill to-Location(POS)" := '' ;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..19
        //ERROR(ChargeItemErr,Type);//ACXCP_200821
    #21..33
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: CreditMemoAmt) (VariableCollection) on "UpdateTDSAdjustmentEntry(PROCEDURE 1500029)".


    //Unsupported feature: Variable Insertion (Variable: recTDSEntry) (VariableCollection) on "UpdateTDSAdjustmentEntry(PROCEDURE 1500029)".



    //Unsupported feature: Code Modification on "UpdateTDSAdjustmentEntry(PROCEDURE 1500029)".

    //procedure UpdateTDSAdjustmentEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH PurchaseLine DO BEGIN
      Vendor.GET("Pay-to Vendor No.");
      TDSEntry.RESET;
    #4..70
        TDSEntry.CALCSUMS("TDS Amount","Surcharge Amount");
        PreviousTDSAmt1 := ABS(TDSEntry."TDS Amount");
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..73

      //ACX-RK TDS Fix Begin 31072021
      recTDSEntry.RESET;
      recTDSEntry.SETRANGE("Party Type",recTDSEntry."Party Type"::Vendor);
      recTDSEntry.SETRANGE("Party Code",Vendor."No.");
      recTDSEntry.SETRANGE("TDS Adjustment",TRUE);
      IF recTDSEntry.FIND('-') THEN BEGIN
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code",Applied);
        TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN
          TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
        ELSE
          TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
        TDSEntry.SETRANGE("Document Type",TDSEntry."Document Type"::Invoice);
        TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
        TDSEntry.SETRANGE("TDS Group","TDS Group");
        TDSEntry.SETRANGE("Assessee Code","Assessee Code");
        IF TDSEntry.FINDFIRST THEN BEGIN
          TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
          InvoiceAmt1 := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
        END;
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code",Applied);
        TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN
          TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
        ELSE
          TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
        TDSEntry.SETRANGE("TDS Adjustment",TRUE);
        TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
        TDSEntry.SETRANGE("TDS Group","TDS Group");
        TDSEntry.SETRANGE("Assessee Code","Assessee Code");
        IF TDSEntry.FINDFIRST THEN BEGIN
          TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
          CreditMemoAmt := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
        END;
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code","Document Type");
        TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN
          TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
        ELSE
          TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
        TDSEntry.SETRANGE("TDS Group","TDS Group");
        TDSEntry.SETRANGE("Assessee Code","Assessee Code");
        TDSEntry.SETRANGE("Document Type",TDSEntry."Document Type"::Payment);
        IF TDSEntry.FINDFIRST THEN BEGIN
          TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
          PaymentAmt1 := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
        END;
        PreviousAmount1 := InvoiceAmt1 - CreditMemoAmt + PaymentAmt1;
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code");
        TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN
          TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
        ELSE
          TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
        TDSEntry.SETRANGE("TDS Group","TDS Group");
        TDSEntry.SETRANGE("Assessee Code","Assessee Code");
        IF TDSEntry.FINDFIRST THEN BEGIN
          TDSEntry.CALCSUMS("TDS Amount","Surcharge Amount");
          PreviousTDSAmt1 := ABS(TDSEntry."TDS Amount");
        END;
      END;
      //ACX-RK End
    END;
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: OverAndAboveThresholdAmount) (VariableCollection) on "CalcBlankTDSAppliedAmt(PROCEDURE 1170000000)".



    //Unsupported feature: Code Modification on "CalcBlankTDSAppliedAmt(PROCEDURE 1170000000)".

    //procedure CalcBlankTDSAppliedAmt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH PurchLine DO BEGIN
      PurchaseHeader.GET("Document Type","Document No.");
      CalcPrevTDSAmounts(PurchLine,AccountingPeriodFilter,PreviousAmount,PreviousBaseAMTWithTDS,PreviousAmount1,
    #4..9
          CalculateSurcharge,AccountingPeriodFilter);
      END ELSE BEGIN
        TDSGroup.FindOnDate("TDS Group",PurchaseHeader."Posting Date");
        IF (PreviousAmount + CurrentPOAmount) > TDSGroup."TDS Threshold Amount" THEN BEGIN
          "TDS Base Amount" := TDSBaseLCY - CurrentPOContractAmt;
          UpdTDSPercnt(PurchLine,PurchaseHeader,TDSSetup);
    #16..19
          IF TDSGroup."Per Contract Value" <> 0 THEN
            IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
              IF PreviousContractAmount <> 0 THEN
                "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                  CurrentPOContractAmt
              ELSE
                "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousBaseAMTWithTDS + CurrentPOAmount;

    #28..84
          ELSE // New Code Ends here
            IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
              IF PreviousTDSAmt = 0 THEN
                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS
              ELSE
                "TDS Base Amount" := TDSBaseLCY;
              IF PreviousTDSAmt1 <> 0 THEN
                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount;
              UpdTDSPercnt(PurchLine,PurchaseHeader,TDSSetup);
              IF NodNocLines1."Surcharge Overlook" THEN BEGIN
                "Surcharge Base Amount" := ABS(PreviousAmount + CurrentPOAmount +
    #96..136
            END;
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
        //ACX-RK Begin
        IF TDSSetup."Calc. Over & Above Threshold" THEN
          OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
        //ACX-RK End
    #13..22
                //ACX-RK Begin
                {
                "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                  CurrentPOContractAmt
                  }
                  "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                  CurrentPOContractAmt - OverAndAboveThresholdAmount
                  //ACX-RK End
    #25..87
                //ACX-RK Begin
                //"TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS
                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS - OverAndAboveThresholdAmount
                //ACX-RK End
              ELSE
              //ACX-RK Begin
                //"TDS Base Amount" := TDSBaseLCY;
                "TDS Base Amount" := TDSBaseLCY - OverAndAboveThresholdAmount;
                //ACX-RK End
              IF PreviousTDSAmt1 <> 0 THEN
                //ACX-RK begin
                //"TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount;
                  "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - OverAndAboveThresholdAmount;
                //ACX-RK End
    #93..139
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: CreditMemoAmt) (VariableCollection) on "CalcPrevTDSAmounts(PROCEDURE 1170000001)".



    //Unsupported feature: Code Modification on "CalcPrevTDSAmounts(PROCEDURE 1170000001)".

    //procedure CalcPrevTDSAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH PurchaseLine DO BEGIN
      Vendor.GET("Pay-to Vendor No.");
      IF (Vendor."P.A.N. No." = '') AND (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") THEN
        ERROR(PANErr,Vendor."No.");
      TDSEntry.RESET;
      TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code",Applied);
      TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
      IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
        TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
      ELSE
        TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
      TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
      TDSEntry.SETRANGE("TDS Group","TDS Group");
      TDSEntry.SETRANGE("Assessee Code","Assessee Code");
      TDSEntry.SETRANGE(Applied,FALSE);
      IF TDSEntry.FINDFIRST THEN BEGIN
        TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
        PreviousAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
      END;
      FilterTDSEntry1(TDSEntry,PurchaseLine,AccountingPeriodFilter);
      TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
      PreviousBaseAMTWithTDS := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");

      TDSEntry.RESET;
      TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code","Document Type");
      TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
      IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
        TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
      ELSE
        TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
      TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
      TDSEntry.SETRANGE("TDS Group","TDS Group");
      TDSEntry.SETRANGE("Assessee Code","Assessee Code");
      TDSEntry.SETRANGE("Document Type",TDSEntry."Document Type"::Invoice);
      IF TDSEntry.FINDFIRST THEN BEGIN
        TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
        InvoiceAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
      END;

      TDSEntry.RESET;
      TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code","Document Type");
      TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
      IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
        TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
      ELSE
        TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
      TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
      TDSEntry.SETRANGE("TDS Group","TDS Group");
      TDSEntry.SETRANGE("Assessee Code","Assessee Code");
      TDSEntry.SETRANGE("Document Type",TDSEntry."Document Type"::Payment);
      IF TDSEntry.FINDFIRST THEN BEGIN
        TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
        PaymentAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
      END;

      PreviousAmount := InvoiceAmount + PaymentAmount;
      UpdateTDSAdjustmentEntry(PurchaseLine,PreviousAmount1,InvoiceAmt1,PaymentAmt1,PreviousTDSAmt1,AccountingPeriodFilter);
      TDSEntry.RESET;
      TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code");
      TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
      IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
        TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
      ELSE
        TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
      TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
      TDSEntry.SETRANGE("TDS Group","TDS Group");
      TDSEntry.SETRANGE("Assessee Code","Assessee Code");
      IF TDSEntry.FINDFIRST THEN BEGIN
        TDSEntry.CALCSUMS("TDS Amount","Surcharge Amount");
        PreviousTDSAmt := ABS(TDSEntry."TDS Amount");
        PreviousSurchargeAmt := ABS(TDSEntry."Surcharge Amount");
      END;
      TDSEntry.RESET;
      TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code",Applied);
      TDSEntry.SETRANGE("Party Type",TDSEntry."Party Type"::Vendor);
      IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
        TDSEntry.SETRANGE("Party Code","Pay-to Vendor No.")
      ELSE
        TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.");
      TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
      TDSEntry.SETRANGE("TDS Group","TDS Group");
      TDSEntry.SETRANGE("Assessee Code","Assessee Code");
      TDSEntry.SETRANGE(Applied,FALSE);
      TDSEntry.SETRANGE("Per Contract",TRUE);
      IF TDSEntry.FINDFIRST THEN BEGIN
        TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
        PreviousContractAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..55
      //ACX-RK Begin
      TDSEntry.RESET;
      TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code","Document Type");
    #60..67
      TDSEntry.SETRANGE("TDS Adjustment",TRUE);
    //  TDSEntry.SETRANGE("Document Type",TDSEntry."Document Type"::"Credit Memo");
      IF TDSEntry.FINDFIRST THEN BEGIN
        TDSEntry.CALCSUMS("Invoice Amount","Service Tax Including eCess");
        CreditMemoAmt := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
      END;
      PreviousAmount := InvoiceAmount + PaymentAmount - CreditMemoAmt;//ACX-RK
    //  PreviousAmount := InvoiceAmount + PaymentAmount;//ACX-RK
      //ACX-RK End
    #57..89
    <-----12887 need to review this*/
    //end;


}

