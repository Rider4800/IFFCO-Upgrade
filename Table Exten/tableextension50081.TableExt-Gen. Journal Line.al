tableextension 50081 tableextension50081 extends "Gen. Journal Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""External Document No."(Field 77)".

        /*12887 field is removed ---->
        modify("TDS Group")
        {
            OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Rent for Plant & Machinery,Rent for Land & Building,Banking Services,Compensation On Immovable Property,PF Accumulated,Payment For Immovable Property,Goods';

            //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 16359)".

        }
        <----12887 field is removed */


        field(50000; "Finance Branch A/c Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'),
                                                          "Fin Branch Boolean" = FILTER(true));

            trigger OnValidate()
            begin
                //HT 24022021-
                IF "Finance Branch A/c Code" <> '' THEN
                    "Branch Accounting" := TRUE
                ELSE
                    "Branch Accounting" := FALSE;
                //HT 24022021+

                FinanceTDSBranchCode := "Finance Branch A/c Code";//Acx_ANubha
            end;
        }
        field(50001; FinanceTDSBranchCode; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50002; "Branch Accounting"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50003; "Cal. Scheme Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '//SchemeKM';
        }
        field(50004; "Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50005; "Provisional Entries"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP30122021';
        }
        field(50006; "PPS Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //->Team-17783  New field added to save the previous data of External Doc No (Length 50) in this field
        field(50007; "External Document No. New"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Document No. New';
        }
        //<-Team-17783
    }

    trigger OnAfterDelete()
    begin
        DeleteSchemeVoucher(Rec."Cal. Scheme Line No.", Rec."Document No.");//KMSCHEME 290621
    end;

    //12887 ----->  need to handle CalculateTDS, CalculateTCS and CalcTDSWoThresholdOverlookWOApp function changes in use case
    //Unsupported feature: Variable Insertion (Variable: CreditAmount) (VariableCollection) on "CalculateTDS(PROCEDURE 1280001)".



    //Unsupported feature: Code Modification on "CalculateTDS(PROCEDURE 1280001)".

    //procedure CalculateTDS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Posting AND ("Party Type" = "Party Type"::Vendor) AND ("Applies-to Doc. No." <> '') THEN BEGIN
      FindAppliesToVendorLedgEntry(VendorLedgerEntry);
      IF VendorLedgerEntry.HasServiceTax THEN
    #4..45

    InvoiceAmount := GetInvoiceAmtTDS(AccountingPeriodFilter);
    PaymentAmount := GetPaymentAmtTDS(AccountingPeriodFilter);
    PreviousAmount := PaymentAmount + InvoiceAmount;

    IF NOT Posting THEN
      PreviousJnlAmt := CalculateJnlPreviousAmt
    #53..171
          CalculateFinalTDSAmounts
      END;
    CalculateWorkTaxTDS(GenJnlLineWithPoTAmount);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..48
    CreditAmo;unt := GetReturnAmtTDS(AccountingPeriodFilter);//ACX-RK

    //PreviousAmount := PaymentAmount + InvoiceAmount;//ACX-RK
    PreviousAmount := PaymentAmount + InvoiceAmount - CreditAmount;//ACX-RK
    #50..174
    */
    //end;


    //Unsupported feature: Code Modification on "InsertTDSBuf(PROCEDURE 1280006)".

    //procedure InsertTDSBuf();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH TDSEntry DO BEGIN
      TDSBuf[1].INIT;
      TDSBuf[1]."TDS Nature of Deduction" := "TDS Nature of Deduction";
    #4..7
        // TDSBuf[1]."TDS Base Amount" := "Invoice Amount" + "Service Tax Including eCess";
        // IF TDSEntry."Per Contract" THEN
        // TDSBuf[1]."Contract TDS Ded. Base Amount" := "Invoice Amount" + "Service Tax Including eCess";
        TDSBuf[1]."TDS Base Amount" := "Invoice Amount";
        IF "Per Contract" THEN
          TDSBuf[1]."Contract TDS Ded. Base Amount" := "Invoice Amount";
    #14..57
      END;
      UpdTDSBuffer;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..10
        //ACX-RK 31072021 TDS Fix Begin
        IF "TDS Adjustment" = TRUE THEN
          TDSBuf[1]."TDS Base Amount" := -"Invoice Amount"
        ELSE
    //ACX-RK End 31072021
    #11..60
    */
    //end;


    //Unsupported feature: Code Modification on "CalculateTCS(PROCEDURE 1500005)".

    //procedure CalculateTCS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "GST in Journal" AND ("TCS Nature of Collection" = '') THEN
      GSTApplicationManagement.CheckSalesJournalOnlineValidation(Rec);

    #4..115
                    "Surcharge Amount" := 0;
                    "TDS/TCS Amount" := 0;
                    "TDS/TCS Amt Incl Surcharge" := 0;
                  END;
          END;
        IF Amount <> 0 THEN
          PopulateTCSAmountNotZero(TCSAmount);
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..118
                    MESSAGE('%1',"TDS/TCS Base Amount" );//Acx_Anubha
    #119..124
    */
    //end;


    //Unsupported feature: Variable Insertion (Variable: OverAndAboveThresholdAmount) (VariableCollection) on "CalcTDSWoThresholdOverlookWOApp(PROCEDURE 1505105)".



    //Unsupported feature: Code Modification on "CalcTDSWoThresholdOverlookWOApp(PROCEDURE 1505105)".

    //procedure CalcTDSWoThresholdOverlookWOApp();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (PreviousJnlAmt > TDSGroup."TDS Threshold Amount") AND NOT Posting THEN BEGIN
      "TDS/TCS Base Amount" := TDSBaseLCY;
      "TDS/TCS %" := TDSSetup."TDS %";
      "eCESS %" := TDSSetup."eCESS %";
      "SHE Cess % on TDS/TCS" := TDSSetup."SHE Cess %";
      IF NODLines."Surcharge Overlook" THEN BEGIN
    #7..70
      ELSE
        IF Posting THEN
          IF (PreviousAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
            "TDS/TCS Base Amount" := PreviousAmount + TDSBaseLCY;
            "TDS/TCS %" := TDSSetupPercentage;
            "eCESS %" := TDSSetup."eCESS %";
            "SHE Cess % on TDS/TCS" := TDSSetup."SHE Cess %";
    #78..103
        ELSE
          IF NOT Posting THEN
            IF (PreviousAmount + TDSBaseLCY + PreviousJnlAmt) > TDSGroup."TDS Threshold Amount" THEN BEGIN
              "TDS/TCS Base Amount" := PreviousAmount + TDSBaseLCY + PreviousJnlAmt - PreviousJnlTDSCalculated;
              "TDS/TCS %" := TDSSetup."TDS %";
              "eCESS %" := TDSSetup."eCESS %";
              "SHE Cess % on TDS/TCS" := TDSSetup."SHE Cess %";
              IF NODLines."Surcharge Overlook" THEN BEGIN
    #112..123
                    "Surcharge %" := 0;
                END;
              END;
              InsertJnlTDSBuf(PreviousJnlAmt + TDSBaseLCY - PreviousJnlTDSCalculated);
              InsertEntriesToTDSBuffer(AccountingPeriodFilter,TRUE);
            END ELSE BEGIN
              "TDS/TCS Base Amount" := TDSBaseLCY;
              "TDS/TCS %" := 0;
              "eCESS %" := 0;
              "SHE Cess % on TDS/TCS" := 0;
            END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF (PreviousJnlAmt > TDSGroup."TDS Threshold Amount") AND NOT Posting THEN BEGIN
      //ACX-RK Begin
      {
      "TDS/TCS Base Amount" := TDSBaseLCY;
      "TDS/TCS %" := TDSSetup."TDS %";
      }
      IF TDSSetup."Calc. Over & Above Threshold" THEN
        OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
      "TDS/TCS Base Amount" := TDSBaseLCY - OverAndAboveThresholdAmount;
      "TDS/TCS %" := TDSSetupPercentage;
    //ACX-RK End
    #4..73
            //ACX-RK begin
            //"TDS/TCS Base Amount" := PreviousAmount + TDSBaseLCY;
            IF TDSSetup."Calc. Over & Above Threshold" THEN
              OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
            "TDS/TCS Base Amount" := PreviousAmount + TDSBaseLCY - OverAndAboveThresholdAmount;
            //ACX-RK End
    #75..106
              //ACX-RK BEgin
              {
                "TDS/TCS Base Amount" := PreviousAmount + TDSBaseLCY + PreviousJnlAmt - PreviousJnlTDSCalculated;
                "TDS/TCS %" := TDSSetup."TDS %";
                }
                IF TDSSetup."Calc. Over & Above Threshold" THEN
                  OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
                "TDS/TCS Base Amount" := PreviousAmount + TDSBaseLCY + PreviousJnlAmt - PreviousJnlTDSCalculated - OverAndAboveThresholdAmount;
                "TDS/TCS %" := TDSSetupPercentage;
                //ACX-RK End
    #109..126
              //ACX-RK Begin
              //InsertJnlTDSBuf(PreviousJnlAmt + TDSBaseLCY - PreviousJnlTDSCalculated);
              InsertJnlTDSBuf(PreviousJnlAmt + TDSBaseLCY - PreviousJnlTDSCalculated - OverAndAboveThresholdAmount);
              //ACX-RK End
    #128..134
    */
    //end;
    //<---- 12887need to handle CalculateTDS, CalculateTCS and CalcTDSWoThresholdOverlookWOApp function changes in use case*/
    local procedure DeleteSchemeVoucher("LineNo.": Integer; "DocNo.": Code[20])
    var
        recCalCD: Record 50020;
        recCalCDPPC: Record 50027;
    begin
        recCalCD.RESET();
        recCalCD.SETRANGE("Line No.", "LineNo.");
        recCalCD.SETRANGE("Credit Note No.", "DocNo.");
        IF recCalCD.FINDFIRST THEN BEGIN
            recCalCD."Credit Note No." := '';
            recCalCD.MODIFY();
        END;
        //////////////////
        recCalCDPPC.RESET();
        recCalCDPPC.SETRANGE("Line No.", "LineNo.");
        recCalCDPPC.SETRANGE("Credit Note No.", "DocNo.");
        recCalCDPPC.SETRANGE("Invoice No.", "PPS Invoice No.");
        IF recCalCDPPC.FINDFIRST THEN BEGIN
            recCalCDPPC."Credit Note No." := '';
            recCalCDPPC.MODIFY();
        END;
    end;

    /*12887 need to handle CalculateTDS, CalculateTCS, CalcTDSWoThresholdOverlookWOApp and GetReturnAmtTDS function changes in use case --->
        local procedure GetReturnAmtTDS(AccountingPeriodFilter: Text[30]): Decimal
        var
            Vendor: Record 23;
            ReturnAmount: Decimal;
            TDSEntry: Record "TDS Entry";
        begin
            IF "Party Type" = "Party Type"::Vendor THEN
                Vendor.GET("Party Code");
            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "TDS Group", "Assessee Code", "Document Type");
            TDSEntry.SETRANGE("Party Type", "Party Type");
            IF ("Party Type" = "Party Type"::Vendor) AND (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") THEN
                TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.")
            ELSE
                TDSEntry.SETRANGE("Party Code", "Party Code");
            TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
            TDSEntry.SETRANGE("TDS Group", "TDS Group");
            TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
            TDSEntry.SETRANGE("TDS Adjustment", TRUE);
            IF TDSEntry.FIND('-') THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
                ReturnAmount := ABS(TDSEntry."Invoice Amount");
            END;
            EXIT(ReturnAmount);
        end;
       <---- 12887 need to handle CalculateTDS, CalculateTCS, CalcTDSWoThresholdOverlookWOApp and GetReturnAmtTDS function changes in use case*/
}

