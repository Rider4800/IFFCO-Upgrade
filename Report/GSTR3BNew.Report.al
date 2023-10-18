report 50008 "GSTR-3B New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './GSTR3BNew.rdlc';
    Caption = 'GSTR-3B New';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(DataItem1500700; Table2000000026)
        {
            DataItemTableView = SORTING (Number)
                                ORDER(Ascending)
                                WHERE (Number = FILTER (1));
            column(GSTRLbl; GSTRLbl)
            {
            }
            column(RuleLbl; RuleLbl)
            {
            }
            column(YearLbl; YearLbl)
            {
            }
            column(MonthLbl; MonthLbl)
            {
            }
            column(GSTINLbl; GSTINLbl)
            {
            }
            column(LegalNameLbl; LegalNameLbl)
            {
            }
            column(OutwardSpplyLbl; OutwardSpplyLbl)
            {
            }
            column(NatureofSpplyLbl; NatureofSpplyLbl)
            {
            }
            column(TotTaxableLbl; TotTaxableLbl)
            {
            }
            column(IntegratedLbl; IntegratedLbl)
            {
            }
            column(CentralLbl; CentralLbl)
            {
            }
            column(StateTaxLbl; StateTaxLbl)
            {
            }
            column(CessLbl; CessLbl)
            {
            }
            column(OutwardTaxableSpplyLbl; OutwardTaxableSpplyLbl)
            {
            }
            column(OutwardTaxableSpplyZeroLbl; OutwardTaxableSpplyZeroLbl)
            {
            }
            column(OutwardTaxableSpplyNilLbl; OutwardTaxableSpplyNilLbl)
            {
            }
            column(InwardSpplyLbl; InwardSpplyLbl)
            {
            }
            column(NonGSTOutwardSpplyLbl; NonGSTOutwardSpplyLbl)
            {
            }
            column(UnregCompoLbl; UnregCompoLbl)
            {
            }
            column(PlaceOfSupplyLbl; PlaceOfSupplyLbl)
            {
            }
            column(IntegratedTaxLbl; IntegratedTaxLbl)
            {
            }
            column(EligibleITCLbl; EligibleITCLbl)
            {
            }
            column(NatureOfSuppliesLbl; NatureOfSuppliesLbl)
            {
            }
            column(ITCAvlLbl; ITCAvlLbl)
            {
            }
            column(ImportGoodLbl; ImportGoodLbl)
            {
            }
            column(ImportServiceLbl; ImportServiceLbl)
            {
            }
            column(InwrdReverseLbl; InwrdReverseLbl)
            {
            }
            column(InwrdISDLbl; InwrdISDLbl)
            {
            }
            column(AllITCLbl; AllITCLbl)
            {
            }
            column(ITCReverseLbl; ITCReverseLbl)
            {
            }
            column(RulesLbl; RulesLbl)
            {
            }
            column(OthersLbl; OthersLbl)
            {
            }
            column(NetITCLbl; NetITCLbl)
            {
            }
            column(IneligibleITCLbl; IneligibleITCLbl)
            {
            }
            column(SectionLbl; SectionLbl)
            {
            }
            column(ValuesExemptLbl; ValuesExemptLbl)
            {
            }
            column(InterStateSpplyLbl; InterStateSpplyLbl)
            {
            }
            column(IntraStateLbl; IntraStateLbl)
            {
            }
            column(SupplierCompLbl; SupplierCompLbl)
            {
            }
            column(NonGSTSpply; NonGSTSpplyLbl)
            {
            }
            column(PaymentLbl; PaymentLbl)
            {
            }
            column(DescLbl; DescLbl)
            {
            }
            column(TaxLbl; TaxLbl)
            {
            }
            column(PayableLbl; PayableLbl)
            {
            }
            column(PaidITCLbl; PaidITCLbl)
            {
            }
            column(TaxPaidLbl; TaxPaidLbl)
            {
            }
            column(TDSTCSLbl; TDSTCSLbl)
            {
            }
            column(TaxCessLbl; TaxCessLbl)
            {
            }
            column(CashLbl; CashLbl)
            {
            }
            column(InterestLbl; InterestLbl)
            {
            }
            column(LateFeeLbl; LateFeeLbl)
            {
            }
            column(TDSTCSCrLbl; TDSTCSCrLbl)
            {
            }
            column(DetailsLbl; DetailsLbl)
            {
            }
            column(TDSLbl; TDSLbl)
            {
            }
            column(TCSLbl; TCSLbl)
            {
            }
            column(VerificationLbl; VerificationLbl)
            {
            }
            column(VerifyTxtLbl; VerifyTxtLbl)
            {
            }
            column(PlaceLbl; PlaceLbl)
            {
            }
            column(DateLbl; DateLbl)
            {
            }
            column(Place; Place)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(ResponsibleLbl; AuthorisedPerson)
            {
            }
            column(SignatoryLbl; SignatoryLbl)
            {
            }
            column(GSTIN; GSTIN)
            {
            }
            column(Year; Year)
            {
            }
            column(Month; Month)
            {
            }
            column(LegalName; CompanyInformation.Name + CompanyInformation."Name 2")
            {
            }
            column(GSTINChar1; gstinchar[1])
            {
            }
            column(GSTINChar2; gstinchar[2])
            {
            }
            column(GSTINChar3; gstinchar[3])
            {
            }
            column(GSTINChar4; gstinchar[4])
            {
            }
            column(GSTINChar5; gstinchar[5])
            {
            }
            column(GSTINChar6; gstinchar[6])
            {
            }
            column(GSTINChar7; gstinchar[7])
            {
            }
            column(GSTINChar8; gstinchar[8])
            {
            }
            column(GSTINChar9; gstinchar[9])
            {
            }
            column(GSTINChar10; gstinchar[10])
            {
            }
            column(GSTINChar11; gstinchar[11])
            {
            }
            column(GSTINChar12; gstinchar[12])
            {
            }
            column(GSTINChar13; gstinchar[13])
            {
            }
            column(GSTINChar14; gstinchar[14])
            {
            }
            column(GSTINChar15; gstinchar[15])
            {
            }
            column(OwrdtaxableTotalAmount; -OwrdtaxableTotalAmount)
            {
            }
            column(OwrdtaxableIGSTAmount; -OwrdtaxableIGSTAmount)
            {
            }
            column(OwrdtaxableCGSTAmount; -OwrdtaxableCGSTAmount)
            {
            }
            column(OwrdtaxableSGSTUTGSTAmount; -OwrdtaxableSGSTUTGSTAmount)
            {
            }
            column(OwrdtaxableCESSAmount; -OwrdtaxableCESSAmount)
            {
            }
            column(OwrdZeroTotalAmount; -OwrdZeroTotalAmount)
            {
            }
            column(OwrdZeroIGSTAmount; -OwrdZeroIGSTAmount)
            {
            }
            column(OwrdZeroCGSTAmount; -OwrdZeroCGSTAmount)
            {
            }
            column(OwrdZeroSGSTUTGSTAmount; -OwrdZeroSGSTUTGSTAmount)
            {
            }
            column(OwrdZeroCESSAmount; -OwrdZeroCESSAmount)
            {
            }
            column(OwrdNilTotalAmount; -OwrdNilTotalAmount)
            {
            }
            column(OwrdNilIGSTAmount; -OwrdNilIGSTAmount)
            {
            }
            column(OwrdNilCGSTAmount; -OwrdNilCGSTAmount)
            {
            }
            column(OwrdNilSGSTUTGSTAmount; -OwrdNilSGSTUTGSTAmount)
            {
            }
            column(OwrdNilCESSAmount; -OwrdNilCESSAmount)
            {
            }
            column(InwrdtotalAmount; InwrdtotalAmount)
            {
            }
            column(InwrdIGSTAmount; InwrdIGSTAmount)
            {
            }
            column(InwrdCGSTAmount; InwrdCGSTAmount)
            {
            }
            column(InwrdSGSTUTGSTAmount; InwrdSGSTUTGSTAmount)
            {
            }
            column(InwrdCESSAmount; InwrdCESSAmount)
            {
            }
            column(OwrdNonGSTTotalAmount; OwrdNonGSTTotalAmount)
            {
            }
            column(ImportGoodsIGSTAmount; ImportGoodsIGSTAmount)
            {
            }
            column(ImportGoodsCGSTAmount; ImportGoodsCGSTAmount)
            {
            }
            column(ImportGoodsSGSTUTGSTAmount; ImportGoodsSGSTUTGSTAmount)
            {
            }
            column(ImportGoodsCESSAmount; ImportGoodsCESSAmount)
            {
            }
            column(ImportServiceIGSTAmount; ImportServiceIGSTAmount)
            {
            }
            column(ImportServiceCGSTAmount; ImportServiceCGSTAmount)
            {
            }
            column(ImportServiceSGSTUTGSTAmount; ImportServiceSGSTUTGSTAmount)
            {
            }
            column(ImportServiceCESSAmount; ImportServiceCESSAmount)
            {
            }
            column(InwrdReverseIGSTAmount; InwrdReverseIGSTAmount)
            {
            }
            column(InwrdReverseCGSTAmount; InwrdReverseCGSTAmount)
            {
            }
            column(InwrdReverseSGSTUTGSTAmount; InwrdReverseSGSTUTGSTAmount)
            {
            }
            column(InwrdReverseCESSAmount; InwrdReverseCESSAmount)
            {
            }
            column(AllOtherITCIGSTAmount; AllOtherITCIGSTAmount)
            {
            }
            column(AllOtherITCCGSTAmount; AllOtherITCCGSTAmount)
            {
            }
            column(AllOtherITCSGSTUTGSTAmount; AllOtherITCSGSTUTGSTAmount)
            {
            }
            column(AllOtherITCCESSAmount; AllOtherITCCESSAmount)
            {
            }
            column(IneligibleITCIGSTAmount; IneligibleITCIGSTAmount)
            {
            }
            column(IneligibleITCCGSTAmount; IneligibleITCCGSTAmount)
            {
            }
            column(IneligibleITCSGSTUTGSTAmount; IneligibleITCSGSTUTGSTAmount)
            {
            }
            column(IneligibleITCCESSAmount; IneligibleITCCESSAmount)
            {
            }
            column(InwrdISDIGSTAmount; InwrdISDIGSTAmount)
            {
            }
            column(InwrdISDCGSTAmount; InwrdISDCGSTAmount)
            {
            }
            column(InwrdISDSGSTUTGSTAmount; InwrdISDSGSTUTGSTAmount)
            {
            }
            column(InwrdISDCESSAmount; InwrdISDCESSAmount)
            {
            }
            column(InterStateCompSupplyAmount; InterStateCompSupplyAmount)
            {
            }
            column(IntraStateCompSupplyAmount; IntraStateCompSupplyAmount)
            {
            }
            column(PurchInterStateAmount; PurchInterStateAmount)
            {
            }
            column(PurchIntraStateAmount; PurchIntraStateAmount)
            {
            }
            column(SupplyUnregLbl; SupplyUnregLbl)
            {
            }
            column(SupplyCompLbl; SupplyCompLbl)
            {
            }
            column(SupplyUINLbl; SupplyUINLbl)
            {
            }
            column(OthersIGSTAmount; OthersIGSTAmount)
            {
            }
            column(OthersCGSTAmount; OthersCGSTAmount)
            {
            }
            column(OthersSGSTUTGSTAmount; OthersSGSTUTGSTAmount)
            {
            }
            column(OthersCESSAmount; OthersCESSAmount)
            {
            }
            column(InwrdtotalAmount1; InwrdtotalAmount1)
            {
            }
            column(InwrdIGSTAmount1; InwrdIGSTAmount1)
            {
            }
            column(InwrdCGSTAmount1; InwrdCGSTAmount1)
            {
            }
            column(InwrdSGSTUTGSTAmount1; InwrdSGSTUTGSTAmount1)
            {
            }
            column(InwrdCESSAmount1; InwrdCESSAmount1)
            {
            }
            column(InwrdReverseIGSTAmount1; InwrdReverseIGSTAmount1)
            {
            }
            column(InwrdReverseCGSTAmount1; InwrdReverseCGSTAmount1)
            {
            }
            column(InwrdReverseSGSTUTGSTAmount1; InwrdReverseSGSTUTGSTAmount1)
            {
            }
            column(InwrdReverseCESSAmount1; InwrdReverseCESSAmount1)
            {
            }
            column(ImportServiceIGSTAmount1; ImportServiceIGSTAmount1)
            {
            }
            column(ImportServiceCGSTAmount1; ImportServiceCGSTAmount1)
            {
            }
            column(ImportServiceSGSTUTGSTAmount1; ImportServiceSGSTUTGSTAmount1)
            {
            }
            column(ImportServiceCESSAmount1; ImportServiceCESSAmount1)
            {
            }
            column(TransferShipmentIGSTamt; TransferShipmentIGSTamt)
            {
            }

            trigger OnPreDataItem()
            begin
                FOR i := 1 TO 15 DO
                    IF GSTIN = '' THEN
                        gstinchar[i] := ''
                    ELSE
                        gstinchar[i] := COPYSTR(GSTIN, i, 1);
                IF PeriodDate = 0D THEN
                    ERROR(PeriodDateErr);
                IF AuthorisedPerson = '' THEN
                    ERROR(AuthErr);
                IF Place = '' THEN
                    ERROR(PlaceErr);
                IF PostingDate = 0D THEN
                    ERROR(PostingDateBlankErr);
                Month := DATE2DMY(PeriodDate, 2) - 1;
                Year := FORMAT(DATE2DMY(PeriodDate, 3));
                StartingDate := CALCDATE('<CM-1M+1D>', PeriodDate);
                EndingDate := CALCDATE('<CM>', PeriodDate);
                CompanyInformation.GET;
                CalculateValues;
            end;
        }
        dataitem(SupplyUnreg; Table16419)
        {
            DataItemTableView = WHERE (GST Jurisdiction Type=FILTER(Interstate));
            column(PlaceOfSupplyUnreg;PlaceOfSupplyUnreg)
            {
            }
            column(SupplyBaseAmtUnreg;-SupplyBaseAmtUnreg)
            {
            }
            column(SupplyIGSTAmtUnreg;-SupplyIGSTAmtUnreg)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(PlaceOfSupplyUnreg);
                CLEAR(SupplyBaseAmtUnreg);
                CLEAR(SupplyIGSTAmtUnreg);
                IF NOT ("Component Calc. Type" IN ["Component Calc. Type"::General,
                                                   "Component Calc. Type"::Threshold,
                                                   "Component Calc. Type"::"Cess %"])
                THEN
                  CurrReport.SKIP;
                CheckComponentReportView("GST Component Code");
                IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                   (DocumentNo <> "Document No.") OR (TransactionNo <> "Transaction No.") OR
                   (OriginalDocNo <> "Original Doc. No.") OR (DocumentLineNo <> "Document Line No.") OR
                   (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
                THEN BEGIN
                  SupplyBaseAmtUnreg := GetBaseAmount(SupplyUnreg);
                  IF SupplyBaseAmtUnreg <> 0 THEN BEGIN
                    IF "Shipping Address State Code" <> '' THEN
                      PlaceOfSupplyUnreg := "Shipping Address State Code"
                    ELSE
                      PlaceOfSupplyUnreg := "Buyer/Seller State Code";
                    SupplyIGSTAmtUnreg := GetSupplyGSTAmountRec(SupplyUnreg,CompReportView::IGST);
                  END;
                  EntryType := "Entry Type";
                  DocumentType := "Document Type";
                  DocumentNo := "Document No.";
                  DocumentLineNo := "Document Line No.";
                  OriginalDocNo := "Original Doc. No.";
                  TransactionNo := "Transaction No.";
                  OriginalInvNo := "Original Invoice No.";
                  ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
                END;
            end;

            trigger OnPreDataItem()
            begin
                SETCURRENTKEY("Location  Reg. No.","Source Type","GST Customer Type","Posting Date");
                SETRANGE("Location  Reg. No.",GSTIN);
                SETRANGE("Source Type","Source Type"::Customer);
                SETFILTER("GST Customer Type",'%1',"GST Customer Type"::Unregistered);
                SETRANGE("Posting Date",StartingDate,EndingDate);
                SETCURRENTKEY("Transaction Type","Entry Type","Document Type","Document No.",
                  "Transaction No.","Original Doc. No.","Document Line No.",
                  "Original Invoice No.","Item Charge Assgn. Line No.");
                ClearDocInfo;
            end;
        }
        dataitem(SupplyUIN;Table16419)
        {
            DataItemTableView = WHERE(GST Jurisdiction Type=FILTER(Interstate));
            column(PlaceOfSupplyUIN;PlaceOfSupplyUIN)
            {
            }
            column(SupplyBaseAmtUIN;-SupplyBaseAmtUIN)
            {
            }
            column(SupplyIGSTAmtUIN;-SupplyIGSTAmtUIN)
            {
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record "18";
            begin
                CLEAR(PlaceOfSupplyUIN);
                CLEAR(SupplyBaseAmtUIN);
                CLEAR(SupplyIGSTAmtUIN);
                Customer.GET("Source No.");
                IF Customer."GST Registration Type" <> Customer."GST Registration Type"::UID THEN
                  CurrReport.SKIP;
                IF NOT ("Component Calc. Type" IN ["Component Calc. Type"::General,
                                                   "Component Calc. Type"::Threshold,
                                                   "Component Calc. Type"::"Cess %"])
                THEN
                  CurrReport.SKIP;
                CheckComponentReportView("GST Component Code");
                IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                   (DocumentNo <> "Document No.") OR (TransactionNo <> "Transaction No.") OR
                   (OriginalDocNo <> "Original Doc. No.") OR (DocumentLineNo <> "Document Line No.") OR
                   (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
                THEN BEGIN
                  SupplyBaseAmtUIN := GetBaseAmount(SupplyUIN);
                  IF SupplyBaseAmtUIN <> 0 THEN BEGIN
                    IF "Shipping Address State Code" <> '' THEN
                      PlaceOfSupplyUIN := "Shipping Address State Code"
                    ELSE
                      PlaceOfSupplyUIN := "Buyer/Seller State Code";
                    SupplyIGSTAmtUIN := GetSupplyGSTAmountRec(SupplyUIN,CompReportView::IGST);
                  END;
                  EntryType := "Entry Type";
                  DocumentType := "Document Type";
                  DocumentNo := "Document No.";
                  DocumentLineNo := "Document Line No.";
                  OriginalDocNo := "Original Doc. No.";
                  TransactionNo := "Transaction No.";
                  OriginalInvNo := "Original Invoice No.";
                  ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
                END;
            end;

            trigger OnPreDataItem()
            begin
                SETCURRENTKEY("Location  Reg. No.","Source Type","GST Customer Type","Posting Date");
                SETRANGE("Location  Reg. No.",GSTIN);
                SETRANGE("Source Type","Source Type"::Customer);
                SETFILTER("GST Customer Type",'%1',"GST Customer Type"::Registered);
                SETRANGE("Posting Date",StartingDate,EndingDate);
                SETCURRENTKEY("Transaction Type","Entry Type","Document Type",
                  "Document No.","Transaction No.","Original Doc. No.","Document Line No.",
                  "Original Invoice No.","Item Charge Assgn. Line No.");
                ClearDocInfo;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(GSTIN;GSTIN)
                {
                    Caption = 'GSTIN No.';
                    TableRelation = "GST Registration Nos.";
                }
                field(PeriodDate;PeriodDate)
                {
                    Caption = 'Period Date';
                }
                field(AuthorisedPerson;AuthorisedPerson)
                {
                    Caption = 'Name of the Authorized Person';
                }
                field(Place;Place)
                {
                    Caption = 'Place';
                }
                field(PostingDate;PostingDate)
                {
                    Caption = 'Posting Date';

                    trigger OnValidate()
                    begin
                        IF PeriodDate = 0D THEN
                          ERROR(PeriodDateErr);
                        IF PostingDate <= CALCDATE('<CM>',PeriodDate) THEN
                          ERROR(PostingDateErr,CALCDATE('<CM>',PeriodDate));
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DetailedGSTLedgerEntry: Record "16419";
        PostedGSTLiabilityAdj: Record "16457";
        CompanyInformation: Record "79";
        DetailedCrAdjstmntEntry: Record "16451";
        GSTManagement: Codeunit "16401";
        GSTIN: Code[15];
        PeriodDate: Date;
        AuthorisedPerson: Text[100];
        Place: Text[50];
        PostingDate: Date;
        PeriodDateErr: Label 'Period Date can not be Blank.';
        AuthErr: Label 'Provide a name for the Authorised Person.';
        PlaceErr: Label 'Provide the name of Place.';
        PostingDateBlankErr: Label 'Posting Date can not be Blank.';
        Month: Option January,February,March,April,May,June,July,August,September,October,November,December;
        Year: Code[4];
        StartingDate: Date;
        EndingDate: Date;
        GSTRLbl: Label 'GSTR 3B';
        RuleLbl: Label '[See rule 61(5)]';
        YearLbl: Label 'Year';
        MonthLbl: Label 'Month';
        GSTINLbl: Label 'Gstin';
        LegalNameLbl: Label 'Legal Name of Registered Person';
        OutwardSpplyLbl: Label 'Details of Outward Supplies and inward supplies liable to reverse charge';
        NatureofSpplyLbl: Label 'Nature of Supplies';
        TotTaxableLbl: Label 'Total Taxable Value';
        IntegratedLbl: Label 'Integrated Tax';
        CentralLbl: Label 'Central Tax';
        StateTaxLbl: Label 'State/UT Tax';
        CessLbl: Label 'Cess';
        OutwardTaxableSpplyLbl: Label '(a) Outward taxable supplies (other than zero rated, nil rated and exempted)';
        OutwardTaxableSpplyZeroLbl: Label '(b) Outward taxable supplies (zero rated )';
        OutwardTaxableSpplyNilLbl: Label '(c) Other outward supplies (Nil rated, exempted)';
        InwardSpplyLbl: Label '(d) Inward supplies (liable to reverse charge)';
        NonGSTOutwardSpplyLbl: Label '(e) Non-GST outward supplies';
        UnregCompoLbl: Label 'Of the supplies shown in 3.1 (a) above, details of inter-State supplies made to unregistered persons,    composition taxable persons and UIN holders';
        PlaceOfSupplyLbl: Label 'Place of Supply     (State/UT)';
        IntegratedTaxLbl: Label 'Amount of Integrated Tax';
        EligibleITCLbl: Label 'Eligible ITC';
        NatureOfSuppliesLbl: Label 'Nature of Supplies';
        ITCAvlLbl: Label '(A) ITC Available (whether in full or part)';
        ImportGoodLbl: Label '(1) Import of goods';
        ImportServiceLbl: Label '(2) Import of services';
        InwrdReverseLbl: Label '(3) Inward supplies liable to reverse charge (other    than 1 & 2 above)';
        InwrdISDLbl: Label '(4) Inward supplies from ISD';
        AllITCLbl: Label '(5) All other ITC';
        ITCReverseLbl: Label '(B) ITC Reversed';
        RulesLbl: Label '(1) As per rules 42 & 43 of CGST Rules';
        OthersLbl: Label '(2) Others';
        NetITCLbl: Label '(C) Net ITC Available (A) – (B)';
        IneligibleITCLbl: Label '(D) Ineligible ITC';
        SectionLbl: Label '(1) As per section 17(5)';
        ValuesExemptLbl: Label 'Values of exempt, nil-rated and non-GST inward supplies';
        InterStateSpplyLbl: Label 'Inter-State supplies';
        IntraStateLbl: Label 'Intra-State supplies';
        SupplierCompLbl: Label 'From a supplier under composition scheme, Exempt and Nil    rated supply';
        NonGSTSpplyLbl: Label 'Non GST supply';
        PaymentLbl: Label 'Payment of tax';
        DescLbl: Label 'Description';
        TaxLbl: Label 'Tax';
        PayableLbl: Label 'payable';
        PaidITCLbl: Label 'Paid through ITC';
        TaxPaidLbl: Label 'Tax paid ';
        TDSTCSLbl: Label 'TDS / TCS';
        TaxCessLbl: Label 'Tax / Cess';
        CashLbl: Label 'paid in cash';
        InterestLbl: Label 'Interest';
        LateFeeLbl: Label 'Late Fee';
        TDSTCSCrLbl: Label 'TDS/TCS Credit';
        DetailsLbl: Label 'Details';
        TDSLbl: Label 'TDS';
        TCSLbl: Label 'TCS';
        VerificationLbl: Label 'Verification (by Authorised signatory)';
        VerifyTxtLbl: Label 'I hereby solemnly affirm and declare that the information given herein above is true and correct to the best of my knowledge and belief and nothing has been concealed there from.';
        PlaceLbl: Label 'Place :';
        DateLbl: Label 'Date :';
        SignatoryLbl: Label '(Authorised signatory)';
        PlaceOfSupplyUnreg: Code[10];
        SupplyBaseAmtUnreg: Decimal;
        SupplyIGSTAmtUnreg: Decimal;
        PlaceOfSupplyUIN: Code[10];
        SupplyBaseAmtUIN: Decimal;
        SupplyIGSTAmtUIN: Decimal;
        OwrdtaxableTotalAmount: Decimal;
        OwrdtaxableIGSTAmount: Decimal;
        OwrdtaxableCGSTAmount: Decimal;
        OwrdtaxableSGSTUTGSTAmount: Decimal;
        OwrdtaxableCESSAmount: Decimal;
        OwrdZeroTotalAmount: Decimal;
        OwrdZeroIGSTAmount: Decimal;
        OwrdZeroCGSTAmount: Decimal;
        OwrdZeroSGSTUTGSTAmount: Decimal;
        OwrdZeroCESSAmount: Decimal;
        OwrdNilTotalAmount: Decimal;
        OwrdNilIGSTAmount: Decimal;
        OwrdNilCGSTAmount: Decimal;
        OwrdNilSGSTUTGSTAmount: Decimal;
        OwrdNilCESSAmount: Decimal;
        EntryType: Option "Initial Entry",Application;
        DocumentType: Option " ",Payment,Invoice,"Credit Memo",,,,Refund;
        DocumentNo: Code[20];
        InwrdtotalAmount: Decimal;
        InwrdIGSTAmount: Decimal;
        InwrdCGSTAmount: Decimal;
        InwrdSGSTUTGSTAmount: Decimal;
        InwrdCESSAmount: Decimal;
        InwrdtotalAmount1: Decimal;
        InwrdIGSTAmount1: Decimal;
        InwrdCGSTAmount1: Decimal;
        InwrdSGSTUTGSTAmount1: Decimal;
        InwrdCESSAmount1: Decimal;
        OwrdNonGSTTotalAmount: Decimal;
        CompReportView: Option " ",CGST,"SGST / UTGST",IGST,CESS;
        ImportGoodsIGSTAmount: Decimal;
        ImportGoodsCGSTAmount: Decimal;
        ImportGoodsSGSTUTGSTAmount: Decimal;
        ImportGoodsCESSAmount: Decimal;
        ImportServiceIGSTAmount: Decimal;
        ImportServiceCGSTAmount: Decimal;
        ImportServiceSGSTUTGSTAmount: Decimal;
        ImportServiceCESSAmount: Decimal;
        ImportServiceIGSTAmount1: Decimal;
        ImportServiceCGSTAmount1: Decimal;
        ImportServiceSGSTUTGSTAmount1: Decimal;
        ImportServiceCESSAmount1: Decimal;
        InwrdReverseIGSTAmount: Decimal;
        InwrdReverseCGSTAmount: Decimal;
        InwrdReverseSGSTUTGSTAmount: Decimal;
        InwrdReverseCESSAmount: Decimal;
        InwrdReverseIGSTAmount1: Decimal;
        InwrdReverseCGSTAmount1: Decimal;
        InwrdReverseSGSTUTGSTAmount1: Decimal;
        InwrdReverseCESSAmount1: Decimal;
        AllOtherITCIGSTAmount: Decimal;
        AllOtherITCCGSTAmount: Decimal;
        AllOtherITCSGSTUTGSTAmount: Decimal;
        AllOtherITCCESSAmount: Decimal;
        IneligibleITCIGSTAmount: Decimal;
        IneligibleITCCGSTAmount: Decimal;
        IneligibleITCSGSTUTGSTAmount: Decimal;
        IneligibleITCCESSAmount: Decimal;
        InwrdISDIGSTAmount: Decimal;
        InwrdISDCGSTAmount: Decimal;
        InwrdISDSGSTUTGSTAmount: Decimal;
        InwrdISDCESSAmount: Decimal;
        InterStateCompSupplyAmount: Decimal;
        IntraStateCompSupplyAmount: Decimal;
        PurchInterStateAmount: Decimal;
        PurchIntraStateAmount: Decimal;
        SupplyUnregLbl: Label 'Supplies made to Unregistered Persons';
        SupplyCompLbl: Label 'Supplies made to Composition Persons';
        SupplyUINLbl: Label 'Supplies made to UIN holders';
        OthersIGSTAmount: Decimal;
        OthersCGSTAmount: Decimal;
        OthersSGSTUTGSTAmount: Decimal;
        OthersCESSAmount: Decimal;
        DocumentLineNo: Integer;
        OriginalDocNo: Code[20];
        TransactionNo: Integer;
        PostingDateErr: Label 'Posting Date must be after Period End Date %1.', Comment='%1= period date';
        OriginalInvNo: Code[20];
        ItemChargeAssgnLineNo: Integer;
        Sign: Integer;
        i: Integer;
        gstinchar: array [15] of Text[1];
        recDetGSTLedEntry: Record "16419";
        TransferShipmentIGSTamt: Decimal;

    local procedure GetBaseAmount(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        BaseAmount: Decimal;
    begin
        WITH DetailedGSTLedgerEntry DO BEGIN
          IF "Entry Type" = "Entry Type"::"Initial Entry" THEN
            IF ("Document Type" = "Document Type"::Invoice) OR
               ("Document Type" = "Document Type"::"Credit Memo")
            THEN
              BaseAmount := "GST Base Amount";
          IF "Entry Type" = "Entry Type"::"Initial Entry" THEN
            IF "Document Type" = "Document Type"::Payment THEN
              BaseAmount := "GST Base Amount";
          IF "Entry Type" = "Entry Type"::Application THEN
            BaseAmount := "GST Base Amount";
        END;
        EXIT(BaseAmount);
    end;

    local procedure ClearDocInfo()
    begin
        CLEAR(DocumentType);
        CLEAR(EntryType);
        CLEAR(DocumentNo);
        CLEAR(DocumentLineNo);
        CLEAR(OriginalDocNo);
        CLEAR(TransactionNo);
        CLEAR(OriginalInvNo);
        CLEAR(ItemChargeAssgnLineNo);
    end;

    local procedure CheckComponentReportView(ComponentCode: Code[10])
    var
        GSTComponent: Record "16405";
    begin
        GSTComponent.GET(ComponentCode);
        GSTComponent.TESTFIELD("Report View");
    end;

    local procedure GetSupplyGSTAmountLine(DetailedGSTLedgerEntry: Record "16419";ReportView: Option): Decimal
    var
        GSTComponent: Record "16405";
    begin
        IF GSTComponent.GET(DetailedGSTLedgerEntry."GST Component Code") THEN
          IF GSTComponent."Report View" = ReportView THEN
            EXIT(DetailedGSTLedgerEntry."GST Amount");
    end;

    local procedure GetSupplyGSTAmountISDLine(DetailedGSTDistEntry: Record "16454";ReportView: Option): Decimal
    var
        GSTComponent: Record "16405";
    begin
        IF GSTComponent.GET(DetailedGSTDistEntry."Rcpt. Component Code") THEN
          IF GSTComponent."Report View" = ReportView THEN
            EXIT(DetailedGSTDistEntry."Distribution Amount");
    end;

    local procedure SameStateCode(LocationCode: Code[10];VendorCode: Code[20]): Boolean
    var
        Location: Record "14";
        Vendor: Record "23";
    begin
        Location.GET(LocationCode);
        Vendor.GET(VendorCode);
        IF Location."State Code" = Vendor."State Code" THEN
          EXIT(TRUE);
    end;

    local procedure CalculateValues()
    begin
        OutwardTaxableSupplies;
        OutwardTaxableSuppliesZeroRated;
        OutwardSuppliesNilRated;
        InwardSuppliesReverseCharge;
        InwardSuppliesReverseChargeforGSTAdjustment;
        NonGSTOutwardSupplies;
        ImportGoodsServiceInwardReverse;
        AllAndIneligibleITC;
        InputFromComposition;
        InwardFromISD;
        NonGSTInwardSupply;
    end;

    local procedure GetSupplyGSTAmountRec(DetailedGSTLedgerEntry: Record "16419";ReportView: Option): Decimal
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntryDummy: Record "16419";
        GSTAmount: Decimal;
    begin
        DetailedGSTLedgerEntryDummy.COPYFILTERS(DetailedGSTLedgerEntry);
        DetailedGSTLedgerEntryDummy.SETCURRENTKEY("Entry Type","Document Type","Document No.","Transaction No.",
          "Original Doc. No.","Document Line No.","Original Invoice No.","Item Charge Assgn. Line No.");
        DetailedGSTLedgerEntryDummy.SETRANGE("Entry Type",DetailedGSTLedgerEntry."Entry Type");
        DetailedGSTLedgerEntryDummy.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type");
        DetailedGSTLedgerEntryDummy.SETRANGE("Document No.",DetailedGSTLedgerEntry."Document No.");
        DetailedGSTLedgerEntryDummy.SETRANGE("Transaction No.",DetailedGSTLedgerEntry."Transaction No.");
        DetailedGSTLedgerEntryDummy.SETRANGE("Original Doc. No.",DetailedGSTLedgerEntry."Original Doc. No.");
        DetailedGSTLedgerEntryDummy.SETRANGE("Document Line No.",DetailedGSTLedgerEntry."Document Line No.");
        DetailedGSTLedgerEntryDummy.SETRANGE("Original Invoice No.",DetailedGSTLedgerEntry."Original Invoice No.");
        DetailedGSTLedgerEntryDummy.SETRANGE("Item Charge Assgn. Line No.",DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
        DetailedGSTLedgerEntryDummy.SETFILTER(
          "Component Calc. Type",'%1|%2|%3',DetailedGSTLedgerEntryDummy."Component Calc. Type"::General,
          DetailedGSTLedgerEntryDummy."Component Calc. Type"::Threshold,
          DetailedGSTLedgerEntryDummy."Component Calc. Type"::"Cess %");
        IF DetailedGSTLedgerEntryDummy.FINDSET THEN
          REPEAT
            IF GSTComponent.GET(DetailedGSTLedgerEntryDummy."GST Component Code") THEN
              IF GSTComponent."Report View" = ReportView THEN
                GSTAmount += DetailedGSTLedgerEntryDummy."GST Amount";
          UNTIL DetailedGSTLedgerEntryDummy.NEXT = 0;
        EXIT(GSTAmount);
    end;

    local procedure OutwardTaxableSupplies()
    var
        OtwrdTaxableAmt: Decimal;
    begin
        // Outward taxable supplies (other than zero rated, nil rated and exempted)
        WITH DetailedGSTLedgerEntry DO BEGIN
          ClearDocInfo;
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Transaction Type","Source Type","GST Customer Type",
            "Entry Type","Document Type","Document No.","Component Calc. Type","GST %","GST Exempted Goods");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Transaction Type","Transaction Type"::Sales);
          SETFILTER("GST Customer Type",'%1|%2|%3',"GST Customer Type"::Unregistered,
            "GST Customer Type"::Registered,"GST Customer Type"::" ");
          SETFILTER("Component Calc. Type",'%1|%2|%3',"Component Calc. Type"::General,
            "Component Calc. Type"::Threshold,"Component Calc. Type"::"Cess %");
          SETFILTER("GST %",'<>%1',0);
          SETRANGE("GST Exempted Goods",FALSE);
          SETCURRENTKEY("Transaction Type","Entry Type","Document Type","Document No.",
            "Transaction No.","Original Doc. No.","Document Line No.",
            "Original Invoice No.","Item Charge Assgn. Line No.");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                 (DocumentNo <> "Document No.") OR
                 (TransactionNo <> "Transaction No.") OR (OriginalDocNo <> "Original Doc. No.") OR
                 (DocumentLineNo <> "Document Line No.") OR
                 (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
              THEN BEGIN
                CLEAR(OtwrdTaxableAmt);
                OtwrdTaxableAmt := GetBaseAmount(DetailedGSTLedgerEntry);
                IF OtwrdTaxableAmt <> 0 THEN BEGIN
                  OwrdtaxableTotalAmount += OtwrdTaxableAmt;
                  OwrdtaxableIGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::IGST);
                  OwrdtaxableCGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CGST);
                  OwrdtaxableSGSTUTGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST");
                  OwrdtaxableCESSAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CESS);
                END;
                EntryType := "Entry Type";
                DocumentType := "Document Type";
                DocumentNo := "Document No.";
                DocumentLineNo := "Document Line No.";
                OriginalDocNo := "Original Doc. No.";
                TransactionNo := "Transaction No.";
                OriginalInvNo := "Original Invoice No.";
                ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
              END;
            UNTIL NEXT = 0;
        END;
    end;

    local procedure OutwardTaxableSuppliesZeroRated()
    var
        OwrdZeroAmt: Decimal;
    begin
        // Outward taxable supplies (zero rated )
        WITH DetailedGSTLedgerEntry DO BEGIN
          ClearDocInfo;
          SETFILTER("GST Customer Type",'%1|%2|%3|%4',"GST Customer Type"::Export,
            "GST Customer Type"::"Deemed Export","GST Customer Type"::"SEZ Development",
            "GST Customer Type"::"SEZ Unit");
          SETFILTER("Component Calc. Type",'%1|%2|%3',"Component Calc. Type"::General,
            "Component Calc. Type"::Threshold,"Component Calc. Type"::"Cess %");
          SETRANGE("GST %");
          SETRANGE("GST Exempted Goods");
          SETCURRENTKEY("Transaction Type","Entry Type","Document Type",
            "Document No.","Transaction No.","Original Doc. No.","Document Line No.",
            "Original Invoice No.","Item Charge Assgn. Line No.");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                 (DocumentNo <> "Document No.") OR (TransactionNo <> "Transaction No.") OR
                 (OriginalDocNo <> "Original Doc. No.") OR (DocumentLineNo <> "Document Line No.") OR
                 (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
              THEN BEGIN
                CLEAR(OwrdZeroAmt);
                OwrdZeroAmt := GetBaseAmount(DetailedGSTLedgerEntry);
                IF OwrdZeroAmt <> 0 THEN BEGIN
                  OwrdZeroTotalAmount += OwrdZeroAmt;
                  OwrdZeroIGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::IGST);
                  OwrdZeroCGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CGST);
                  OwrdZeroSGSTUTGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST");
                  OwrdZeroCESSAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CESS);
                END;
                EntryType := "Entry Type";
                DocumentType := "Document Type";
                DocumentNo := "Document No.";
                DocumentLineNo := "Document Line No.";
                OriginalDocNo := "Original Doc. No.";
                TransactionNo := "Transaction No.";
                OriginalInvNo := "Original Invoice No.";
                ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
              END;
            UNTIL NEXT = 0;
        END;
    end;

    local procedure OutwardSuppliesNilRated()
    var
        OwrdNilAmt: Decimal;
    begin
        // Other outward supplies (Nil rated, exempted)
        WITH DetailedGSTLedgerEntry DO BEGIN
          ClearDocInfo;
          SETFILTER("GST Customer Type",'%1|%2|%3',"GST Customer Type"::Unregistered,
            "GST Customer Type"::Registered,"GST Customer Type"::" ");
          SETFILTER("Component Calc. Type",'%1|%2|%3',"Component Calc. Type"::General,
            "Component Calc. Type"::Threshold,"Component Calc. Type"::"Cess %");
          SETFILTER("GST %",'%1',0);
          SETCURRENTKEY("Transaction Type","Entry Type","Document Type",
            "Document No.","Transaction No.","Original Doc. No.","Document Line No.",
            "Original Invoice No.","Item Charge Assgn. Line No.");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                 (DocumentNo <> "Document No.") OR (TransactionNo <> "Transaction No.") OR
                 (OriginalDocNo <> "Original Doc. No.") OR (DocumentLineNo <> "Document Line No.") OR
                 (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
              THEN BEGIN
                CLEAR(OwrdNilAmt);
                OwrdNilAmt := GetBaseAmount(DetailedGSTLedgerEntry);
                IF OwrdNilAmt <> 0 THEN BEGIN
                  OwrdNilTotalAmount += OwrdNilAmt;
                  OwrdNilIGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::IGST);
                  OwrdNilCGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CGST);
                  OwrdNilSGSTUTGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST");
                  OwrdNilCESSAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CESS);
                END;
                EntryType := "Entry Type";
                DocumentType := "Document Type";
                DocumentNo := "Document No.";
                DocumentLineNo := "Document Line No.";
                OriginalDocNo := "Original Doc. No.";
                TransactionNo := "Transaction No.";
                OriginalInvNo := "Original Invoice No.";
                ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
              END;
            UNTIL NEXT = 0;
        END;
    end;

    local procedure InwardSuppliesReverseCharge()
    begin
        // Inward supplies (liable to reverse charge)
        WITH DetailedGSTLedgerEntry DO BEGIN
          ClearDocInfo;
          RESET;
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Transaction Type","Reverse Charge","Liable to Pay",
            "Entry Type","Document Type","Document No.");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Transaction Type","Transaction Type"::Purchase);
          SETRANGE("Reverse Charge",TRUE);
          SETRANGE("Liable to Pay",TRUE);
          SETCURRENTKEY("Transaction Type","Entry Type","Document Type","Document No.",
            "Document Line No.","Transaction No.","Original Doc. No.",
            "Original Invoice No.","Item Charge Assgn. Line No.");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              Sign := 1;
              IF "Entry Type" = "Entry Type"::Application THEN
                IF "GST Group Type" = "GST Group Type"::Service THEN
                  IF NOT "Associated Enterprises" THEN
                    Sign := -1;
              IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                 (DocumentNo <> "Document No.") OR (TransactionNo <> "Transaction No.") OR
                 (OriginalDocNo <> "Original Doc. No.") OR (DocumentLineNo <> "Document Line No.") OR
                 (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
              THEN BEGIN
                InwrdtotalAmount += Sign * "GST Base Amount";
                InwrdIGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::IGST) * Sign;
                InwrdCGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CGST) * Sign;
                InwrdSGSTUTGSTAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST") * Sign;
                InwrdCESSAmount += GetSupplyGSTAmountRec(DetailedGSTLedgerEntry,CompReportView::CESS) * Sign;
              END;
              EntryType := "Entry Type";
              DocumentType := "Document Type";
              DocumentNo := "Document No.";
              DocumentLineNo := "Document Line No.";
              OriginalDocNo := "Original Doc. No.";
              TransactionNo := "Transaction No.";
              OriginalInvNo := "Original Invoice No.";
              ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
            UNTIL NEXT = 0;
        END;
    end;

    local procedure NonGSTOutwardSupplies()
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        Location: Record "14";
    begin
        // Non - GST Outward Supplies
        Sign := 1;
        Location.SETRANGE("GST Registration No.",GSTIN);
        IF Location.FINDSET THEN
          REPEAT
            SalesInvoiceHeader.SETFILTER(Structure,'<>%1','');
            SalesInvoiceHeader.SETFILTER("Location Code",Location.Code);
            SalesInvoiceHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
            IF SalesInvoiceHeader.FINDSET THEN
              REPEAT
                IF NOT GSTManagement.CheckGSTStrucure(SalesInvoiceHeader.Structure) THEN
                  IF NOT CheckGSTChargeStrucure(SalesInvoiceHeader.Structure) THEN BEGIN
                    SalesInvoiceLine.SETRANGE("Document No.",SalesInvoiceHeader."No.");
                    IF SalesInvoiceLine.FINDSET THEN
                      REPEAT
                        OwrdNonGSTTotalAmount += SalesInvoiceLine."Amount Including VAT";
                      UNTIL SalesInvoiceLine.NEXT = 0;
                  END;
              UNTIL SalesInvoiceHeader.NEXT = 0;

            SalesCrMemoHeader.SETFILTER(Structure,'<>%1','');
            SalesCrMemoHeader.SETFILTER("Location Code",Location.Code);
            SalesCrMemoHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
            IF SalesCrMemoHeader.FINDSET THEN
              REPEAT
                IF NOT GSTManagement.CheckGSTStrucure(SalesCrMemoHeader.Structure) THEN
                  IF NOT CheckGSTChargeStrucure(SalesCrMemoHeader.Structure) THEN BEGIN
                    SalesCrMemoLine.SETRANGE("Document No.",SalesCrMemoHeader."No.");
                    IF SalesCrMemoLine.FINDSET THEN
                      REPEAT
                        OwrdNonGSTTotalAmount -= SalesCrMemoLine."Amount Including VAT";
                      UNTIL SalesCrMemoLine.NEXT = 0;
                  END;
              UNTIL SalesCrMemoHeader.NEXT = 0;
          UNTIL Location.NEXT = 0;
    end;

    local procedure ImportGoodsServiceInwardReverse()
    begin
        // Eligible ITC
        // Import of Goods
        WITH DetailedGSTLedgerEntry DO BEGIN
          RESET;
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Transaction Type","Source Type","GST Credit",
            "Credit Availed","GST Vendor Type","GST Group Type");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Transaction Type","Transaction Type"::Purchase);
          SETRANGE("Source Type","Source Type"::Vendor);
          SETRANGE("GST Credit","GST Credit"::Availment);
          SETRANGE("Credit Availed",TRUE);
          SETRANGE("GST Vendor Type","GST Vendor Type"::Import,"GST Vendor Type"::SEZ);
          SETRANGE("GST Group Type","GST Group Type"::Goods);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              ImportGoodsIGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::IGST);
              ImportGoodsCGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CGST);
              ImportGoodsSGSTUTGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST");
              ImportGoodsCESSAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CESS);
            UNTIL NEXT = 0;

          // Import of Services
          SETRANGE("GST Group Type","GST Group Type"::Service);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IF "Entry Type" = "Entry Type"::Application THEN
                IF "Reverse Charge" THEN
                  IF NOT "Associated Enterprises" THEN
                    Sign := -1;
              ImportServiceIGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::IGST) * Sign;
              ImportServiceCGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CGST) * Sign;
              ImportServiceSGSTUTGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST") * Sign;
              ImportServiceCESSAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CESS) * Sign;
            UNTIL NEXT = 0;

          Sign := 1;

          // Inward supplies liable to reverse charge
          SETRANGE("GST Vendor Type","GST Vendor Type"::Registered,"GST Vendor Type"::Unregistered);
          SETRANGE("GST Group Type");
          SETRANGE("Reverse Charge",TRUE);
          IF FINDSET THEN
            REPEAT
              IF "Entry Type" = "Entry Type"::Application THEN
                IF "GST Group Type" = "GST Group Type"::Service THEN
                  Sign := -1;
              CheckComponentReportView("GST Component Code");
              InwrdReverseIGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::IGST) * Sign;
              InwrdReverseCGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CGST) * Sign;
              InwrdReverseSGSTUTGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST") * Sign;
              InwrdReverseCESSAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CESS) * Sign;
            UNTIL NEXT = 0;
          //ACX-RK 17082021 Begin
          recDetGSTLedEntry.RESET();
          recDetGSTLedEntry.SETCURRENTKEY("Location  Reg. No.","Posting Date","Transaction Type","Source Type","GST Credit",
            "Credit Availed","GST Vendor Type","GST Group Type");
          recDetGSTLedEntry.SETRANGE("Location  Reg. No.",GSTIN);
          recDetGSTLedEntry.SETRANGE("Posting Date",StartingDate,EndingDate);
          recDetGSTLedEntry.SETRANGE("Source Type",recDetGSTLedEntry."Source Type"::" ");
          recDetGSTLedEntry.SETRANGE("Transaction Type",recDetGSTLedEntry."Transaction Type"::Purchase);
          recDetGSTLedEntry.SETRANGE("GST Jurisdiction Type",recDetGSTLedEntry."GST Jurisdiction Type"::Interstate);
            IF recDetGSTLedEntry.FINDFIRST THEN BEGIN
              REPEAT
                TransferShipmentIGSTamt += recDetGSTLedEntry."GST Amount";
              UNTIL recDetGSTLedEntry.NEXT = 0;
            END;
          //ACX-RK End
        END;
        Sign := 1;
    end;

    local procedure AllAndIneligibleITC()
    begin
        WITH DetailedGSTLedgerEntry DO BEGIN
          // All other ITC
          RESET;
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Transaction Type","Source Type",
            "Input Service Distribution","Reverse Charge","GST Credit","Credit Availed");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Transaction Type","Transaction Type"::Purchase);
          SETRANGE("Source Type","Source Type"::Vendor);
          SETRANGE("Input Service Distribution",FALSE);
          SETRANGE("Reverse Charge",FALSE);
          SETRANGE("GST Credit","GST Credit"::Availment);
          SETRANGE("Credit Availed",TRUE);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              AllOtherITCIGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::IGST);
              AllOtherITCCGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CGST);
              AllOtherITCSGSTUTGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST");
              AllOtherITCCESSAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CESS);
            UNTIL NEXT = 0;

          // Ineligible ITC  17(5) DGLE
          SETRANGE("Entry Type","Entry Type"::"Initial Entry");
          SETRANGE("Reverse Charge");
          SETRANGE("GST Credit","GST Credit"::"Non-Availment");
          SETRANGE("Credit Availed",FALSE);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IneligibleITCIGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::IGST) ;
              IneligibleITCCGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CGST);
              IneligibleITCSGSTUTGSTAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::"SGST / UTGST") ;
              IneligibleITCCESSAmount += GetSupplyGSTAmountLine(DetailedGSTLedgerEntry,CompReportView::CESS) ;
            UNTIL NEXT = 0;
        END;

        WITH DetailedCrAdjstmntEntry DO BEGIN
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Reverse Charge");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Reverse Charge",TRUE);
          SETFILTER("Credit Adjustment Type",'%1|%2',
            "Credit Adjustment Type"::"Credit Reversal","Credit Adjustment Type"::"Reversal of Availment");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              AllOtherITCIGSTAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::IGST);
              AllOtherITCCGSTAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::CGST);
              AllOtherITCSGSTUTGSTAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::"SGST / UTGST");
              AllOtherITCCESSAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::CESS);
            UNTIL NEXT = 0;
        END;

        WITH DetailedCrAdjstmntEntry DO BEGIN
          RESET;
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Reverse Charge");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Reverse Charge",TRUE);
          SETFILTER("Credit Adjustment Type",'%1|%2',
            "Credit Adjustment Type"::"Credit Availment","Credit Adjustment Type"::"Credit Re-Availment");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              OthersIGSTAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::IGST);
              OthersCGSTAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::CGST);
              OthersSGSTUTGSTAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::"SGST / UTGST");
              OthersCESSAmount += GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry,CompReportView::CESS);
            UNTIL NEXT = 0;
        END;
    end;

    local procedure InputFromComposition()
    begin
        // Values of exempt, nil-rated and non-GST inward supplies
        // From a supplier under composition scheme, Exempt and Nil rated supply
        WITH DetailedGSTLedgerEntry DO BEGIN
          ClearDocInfo;
          RESET;
          SETCURRENTKEY("Location  Reg. No.","Posting Date","Transaction Type","Source Type","Entry Type",
            "Document Type","Document No.","Component Calc. Type","GST %");
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Transaction Type","Transaction Type"::Purchase);
          SETRANGE("Source Type","Source Type"::Vendor);
          SETFILTER("Component Calc. Type",'%1|%2|%3',"Component Calc. Type"::General,
            "Component Calc. Type"::Threshold,"Component Calc. Type"::"Cess %");
          SETRANGE("GST %",0);
          SETCURRENTKEY("Transaction Type","Entry Type","Document Type","Document No.",
            "Transaction No.","Original Doc. No.","Document Line No.",
            "Original Invoice No.","Item Charge Assgn. Line No.");
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IF (EntryType <> "Entry Type") OR (DocumentType <> "Document Type") OR
                 (DocumentNo <> "Document No.") OR (TransactionNo <> "Transaction No.") OR
                 (OriginalDocNo <> "Original Doc. No.") OR (DocumentLineNo <> "Document Line No.") OR
                 (OriginalInvNo <> "Original Invoice No.") OR (ItemChargeAssgnLineNo <> "Item Charge Assgn. Line No.")
              THEN BEGIN
                IF "GST Jurisdiction Type" = "GST Jurisdiction Type"::Interstate THEN
                  InterStateCompSupplyAmount += "GST Base Amount"
                ELSE
                  IF "GST Jurisdiction Type" = "GST Jurisdiction Type"::Intrastate THEN
                    IntraStateCompSupplyAmount += "GST Base Amount";
              END;
              EntryType := "Entry Type";
              DocumentType := "Document Type";
              DocumentNo := "Document No.";
              DocumentLineNo := "Document Line No.";
              OriginalDocNo := "Original Doc. No.";
              TransactionNo := "Transaction No.";
              OriginalInvNo := "Original Invoice No.";
              ItemChargeAssgnLineNo := "Item Charge Assgn. Line No.";
            UNTIL NEXT = 0;
        END;
    end;

    local procedure InwardFromISD()
    var
        DetailedGSTDistEntry: Record "16454";
    begin
        // Inward Supplies from ISD
        WITH DetailedGSTDistEntry DO BEGIN
          SETCURRENTKEY("Rcpt. GST Reg. No.","Posting Date","Rcpt. GST Credit","Credit Availed");
          SETRANGE("Rcpt. GST Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Rcpt. GST Credit","Rcpt. GST Credit"::Availment);
          SETRANGE("Credit Availed",TRUE);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("Rcpt. Component Code");
              InwrdISDIGSTAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::IGST);
              InwrdISDCGSTAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::CGST);
              InwrdISDSGSTUTGSTAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::"SGST / UTGST");
              InwrdISDCESSAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::CESS);
            UNTIL NEXT = 0;

          // Ineligible ITC  17(5) DGDE
          SETRANGE("Rcpt. GST Credit","Rcpt. GST Credit"::"Non-Availment");
          SETRANGE("Credit Availed",FALSE);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("Rcpt. Component Code");
              IneligibleITCIGSTAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::IGST);
              IneligibleITCCGSTAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::CGST);
              IneligibleITCSGSTUTGSTAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::"SGST / UTGST");
              IneligibleITCCESSAmount += GetSupplyGSTAmountISDLine(DetailedGSTDistEntry,CompReportView::CESS);
            UNTIL NEXT = 0;
        END;
    end;

    local procedure NonGSTInwardSupply()
    var
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        PurchCrMemoHdr: Record "124";
        PurchCrMemoLine: Record "125";
        Location: Record "14";
    begin
        // Non-GST supply Purchase
        Location.SETRANGE("GST Registration No.",GSTIN);
        IF Location.FINDSET THEN
          REPEAT
            PurchInvHeader.SETFILTER(Structure,'<>%1','');
            PurchInvHeader.SETFILTER("Location Code",Location.Code);
            PurchInvHeader.SETRANGE("Posting Date",StartingDate,EndingDate);
            IF PurchInvHeader.FINDSET THEN
              REPEAT
                IF NOT GSTManagement.CheckGSTStrucure(PurchInvHeader.Structure) THEN
                  IF NOT CheckGSTChargeStrucure(PurchInvHeader.Structure) THEN BEGIN
                    PurchInvLine.SETRANGE("Document No.",PurchInvHeader."No.");
                    IF PurchInvLine.FINDSET THEN
                      REPEAT
                        IF SameStateCode(PurchInvHeader."Location Code",PurchInvHeader."Buy-from Vendor No.") THEN
                          PurchIntraStateAmount += PurchInvLine."Amount Including VAT"
                        ELSE
                          PurchInterStateAmount += PurchInvLine."Amount Including VAT";
                      UNTIL PurchInvLine.NEXT = 0;
                  END;
              UNTIL PurchInvHeader.NEXT = 0;

            PurchCrMemoHdr.SETFILTER(Structure,'<>%1','');
            PurchCrMemoHdr.SETFILTER("Location Code",Location.Code);
            PurchCrMemoHdr.SETRANGE("Posting Date",StartingDate,EndingDate);
            IF PurchCrMemoHdr.FINDSET THEN
              REPEAT
                IF NOT GSTManagement.CheckGSTStrucure(PurchCrMemoHdr.Structure) THEN
                  IF NOT CheckGSTChargeStrucure(PurchCrMemoHdr.Structure) THEN BEGIN
                    PurchCrMemoLine.SETRANGE("Document No.",PurchCrMemoHdr."No.");
                    IF PurchCrMemoLine.FINDSET THEN
                      REPEAT
                        IF SameStateCode(PurchCrMemoHdr."Location Code",PurchCrMemoHdr."Buy-from Vendor No.") THEN
                          PurchIntraStateAmount -= PurchCrMemoLine."Amount Including VAT"
                        ELSE
                          PurchInterStateAmount -= PurchCrMemoLine."Amount Including VAT";
                      UNTIL PurchCrMemoLine.NEXT = 0;
                  END;
              UNTIL PurchCrMemoHdr.NEXT = 0;
          UNTIL Location.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckGSTChargeStrucure(StructureCode: Code[10]): Boolean
    var
        StructureDetails: Record "13793";
    begin
        WITH StructureDetails DO BEGIN
          SETRANGE(Code,StructureCode);
          SETRANGE(Type,Type::Charges);
          EXIT(NOT ISEMPTY);
        END;
    end;

    local procedure GetSupplyGSTAmountDCrAdjmntLine(DetailedCrAdjstmntEntry: Record "16451";ReportView: Option): Decimal
    var
        GSTComponent: Record "16405";
    begin
        IF GSTComponent.GET(DetailedCrAdjstmntEntry."GST Component Code") THEN
          IF GSTComponent."Report View" = ReportView THEN
            EXIT(DetailedCrAdjstmntEntry."GST Amount");
    end;

    local procedure InwardSuppliesReverseChargeforGSTAdjustment()
    var
        DetailedGSTLedgerEntry: Record "16419";
        DocumentNo: Code[20];
        GSTBaseAmount: Decimal;
        GSTBaseAmount1: Decimal;
        LineNo: Integer;
        LineNo1: Integer;
    begin
        WITH PostedGSTLiabilityAdj DO BEGIN
          ClearDocInfo;
          RESET;
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Liable to Pay",TRUE);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              DetailedGSTLedgerEntry.SETRANGE("Document No.","Document No.");
              DetailedGSTLedgerEntry.SETRANGE("Document Type","Document Type");
              DetailedGSTLedgerEntry.SETRANGE("Transaction Type",DetailedGSTLedgerEntry."Transaction Type"::Purchase);
              IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                  IF "Credit Adjustment Type" = "Credit Adjustment Type"::Generate THEN BEGIN
                    IF (LineNo <> DetailedGSTLedgerEntry."Document Line No.") AND
                       (DocumentNo <> DetailedGSTLedgerEntry."Document No.")
                    THEN
                      GSTBaseAmount := DetailedGSTLedgerEntry."GST Base Amount";
                    LineNo := DetailedGSTLedgerEntry."Document Line No.";
                  END ELSE BEGIN
                    IF (LineNo1 <> DetailedGSTLedgerEntry."Document Line No.") AND
                       (DocumentNo <> DetailedGSTLedgerEntry."Document No.")
                    THEN
                      GSTBaseAmount1 := DetailedGSTLedgerEntry."GST Base Amount";
                    LineNo1 := DetailedGSTLedgerEntry."Document Line No.";
                  END;
                  DocumentNo := DetailedGSTLedgerEntry."Document No.";
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
              InwrdtotalAmount1 := GSTBaseAmount - GSTBaseAmount1;
              InwrdIGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::IGST);
              InwrdCGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::CGST);
              InwrdSGSTUTGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::"SGST / UTGST");
              InwrdCESSAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::CESS);
            UNTIL NEXT = 0;
        END;
        InwardSuppliesReverseChargeforGSTAdjCreditAvail;
    end;

    local procedure InwardSuppliesReverseChargeforGSTAdjCreditAvail()
    begin
        WITH PostedGSTLiabilityAdj DO BEGIN
          ClearDocInfo;
          RESET;
          SETRANGE("Location  Reg. No.",GSTIN);
          SETRANGE("Posting Date",StartingDate,EndingDate);
          SETRANGE("Credit Availed",TRUE);
          IF FINDSET THEN
            REPEAT
              CheckComponentReportView("GST Component Code");
              IF NOT ("GST Vendor Type" IN ["GST Vendor Type"::Import]) THEN BEGIN
                InwrdReverseIGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::IGST);
                InwrdReverseCGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::CGST);
                InwrdReverseSGSTUTGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::"SGST / UTGST");
                InwrdReverseCESSAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::CESS);
              END ELSE BEGIN
                ImportServiceIGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::IGST);
                ImportServiceCGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::CGST);
                ImportServiceSGSTUTGSTAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::"SGST / UTGST");
                ImportServiceCESSAmount1 += GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj,CompReportView::CESS);
              END;
            UNTIL NEXT = 0;
        END;
    end;

    local procedure GetSupplyGSTAmountRecforGSTAdjust(PostedGSTLiabilityAdj: Record "16457";ReportView: Option): Decimal
    var
        GSTComponent: Record "16405";
        GSTAmount: Decimal;
    begin
        IF GSTComponent.GET(PostedGSTLiabilityAdj."GST Component Code") THEN
          IF GSTComponent."Report View" = ReportView THEN
            GSTAmount += PostedGSTLiabilityAdj."GST Amount";
        EXIT(GSTAmount);
    end;
}

