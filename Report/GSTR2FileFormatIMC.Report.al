report 50027 "GSTR-2 File Format-IMC"
{
    Caption = 'GSTR-2 File Format';
    EnableHyperlinks = false;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem(DataItem1500105; Table2000000026)
        {
            DataItemTableView = SORTING (Number)
                                WHERE (Number = CONST (1));

            trigger OnAfterGetRecord()
            begin
                MakeExcelBodyB2B;
                TempExcelBuffer.OnlyCreateBook(B2BTxt, B2BTxt, COMPANYNAME, USERID, FALSE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyB2BUR;
                TempExcelBuffer.OnlyCreateBook(B2BURTxt, B2BURTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyIMPS;
                TempExcelBuffer.OnlyCreateBook(IMPSTxt, IMPSTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyIMPG;
                TempExcelBuffer.OnlyCreateBook(IMPGTxt, IMPGTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyAT;
                TempExcelBuffer.OnlyCreateBook(ATTxt, ATTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyCDNR;
                TempExcelBuffer.OnlyCreateBook(CDNRTxt, CDNRTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyCDNUR;
                TempExcelBuffer.OnlyCreateBook(CDNURTxt, CDNURTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyEXEMP;
                TempExcelBuffer.OnlyCreateBook(EXEMPTxt, EXEMPTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;

                MakeExcelBodyHSN;
                TempExcelBuffer.OnlyCreateBook(HSNTxt, HSNTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;
                /*CASE FileFormat OF
                  FileFormat::" ":
                    ERROR(FileformatErr);
                  FileFormat::B2B:
                    BEGIN
                      MakeExcelBodyB2B;
                      TempExcelBuffer.OnlyCreateBook(B2BTxt,B2BTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::B2BUR:
                    BEGIN
                      MakeExcelBodyB2BUR;
                      TempExcelBuffer.OnlyCreateBook(B2BURTxt,B2BURTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::IMPS:
                    BEGIN
                      MakeExcelBodyIMPS;
                      TempExcelBuffer.OnlyCreateBook(IMPSTxt,IMPSTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::IMPG:
                    BEGIN
                      MakeExcelBodyIMPG;
                      TempExcelBuffer.OnlyCreateBook(IMPGTxt,IMPGTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::AT:
                    BEGIN
                      MakeExcelBodyAT;
                      TempExcelBuffer.OnlyCreateBook(ATTxt,ATTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::ATADJ:
                    ERROR(FeatureAvlblErr);
                  FileFormat::CDNR:
                    BEGIN
                      MakeExcelBodyCDNR;
                      TempExcelBuffer.OnlyCreateBook(CDNRTxt,CDNRTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::CDNUR:
                    BEGIN
                      MakeExcelBodyCDNUR;
                      TempExcelBuffer.OnlyCreateBook(CDNURTxt,CDNURTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::EXEMP:
                    BEGIN
                      MakeExcelBodyEXEMP;
                      TempExcelBuffer.OnlyCreateBook(EXEMPTxt,EXEMPTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::ITCR:
                    ERROR(FeatureAvlblErr);
                  FileFormat::HSNSUM:
                    BEGIN
                      MakeExcelBodyHSN;
                      TempExcelBuffer.OnlyCreateBook(HSNTxt,HSNTxt,COMPANYNAME,USERID,FALSE);
                    END;
                END;
                */

            end;

            trigger OnPreDataItem()
            begin
                TempExcelBuffer.DELETEALL;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(GSTIN; GSTIN)
                    {
                        Caption = 'GSTIN of the location';
                        TableRelation = "GST Registration Nos.".Code;
                    }
                    field(Date; Date)
                    {
                        Caption = 'Date';

                        trigger OnValidate()
                        begin
                            Month := DATE2DMY(Date, 2);
                            Year := DATE2DMY(Date, 3);
                        end;
                    }
                    field(FileFormat; FileFormat)
                    {
                        Caption = 'File Format';
                    }
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

    trigger OnPostReport()
    begin
        TempExcelBuffer.OnlyOpenExcel;
    end;

    var
        TempExcelBuffer: Record "370" temporary;
        GSTIN: Code[15];
        Date: Date;
        Month: Integer;
        Year: Integer;
        CESSAmount: Decimal;
        B2BTxt: Label 'b2b';
        B2BURTxt: Label 'b2bur';
        CDNRTxt: Label 'cdnr';
        CDNURTxt: Label 'cdnur';
        ATTxt: Label 'at';
        EXEMPTxt: Label 'exemp';
        HSNTxt: Label 'hsn';
        IMPSTxt: Label 'imps';
        IMPGTxt: Label 'impg';
        GSTINUINTxt: Label 'GSTIN of Supplier';
        GSTINSEZTxt: Label 'GSTIN Of SEZ Supplier';
        InvoiceNoTxt: Label 'Invoice Number';
        InvoiceDateTxt: Label 'Invoice Date';
        InvoiceValueTxt: Label 'Invoice Value';
        PlaceOfSupplyTxt: Label 'Place Of Supply';
        ReverseChargeTxt: Label 'Reverse Charge';
        HSNSACofSupplyTxt: Label 'HSN/SAC of Supply';
        TaxableValueTxt: Label 'Taxable Value';
        IGSTAmountTxt: Label 'IGST Amount';
        CGSTAmountTxt: Label 'CGST Amount';
        SGSTAmountTxt: Label 'SGST Amount';
        CESSAmountTxt: Label 'CESS Amount';
        DocumentTypeTxt: Label 'Document Type';
        ReasonForIssuingNoteTxt: Label 'Reason For Issuing document';
        RefundVoucherNoTxt: Label 'Note/Refund Voucher Number';
        RefundVoucherDateTxt: Label 'Note/Refund Voucher Date';
        PortCodeTxt: Label 'Port Code';
        InvVoucherNoTxt: Label 'Invoice/Advance Payment Voucher Number';
        InvVoucherDateTxt: Label 'Invoice/Advance Payment Voucher date';
        InvoiceTypeTxt: Label 'Invoice Type';
        RateTxt: Label 'Rate';
        RefundVoucherValueTxt: Label 'Note/Refund Voucher Value';
        PreGSTTxt: Label 'Pre GST';
        GrossAdvanceRcvdTxt: Label 'Gross Advance Paid';
        TotalBaseAmount: Decimal;
        CESSAmountApp: Decimal;
        TotalBaseAmountApp: Decimal;
        GSTPer: Decimal;
        FileFormat: Option " ",B2B,B2BUR,IMPS,IMPG,CDNR,CDNUR,AT,ATADJ,EXEMP,ITCR,HSNSUM;
        FileformatErr: Label 'You must select GSTR File Format.';
        DescTxt: Label 'Desciption Text';
        TotalQtyTxt: Label 'Total Quantity';
        TotalValTxt: Label 'Total Value';
        UQCTxt: Label 'uqc';
        CompReportView: Option " ",CGST,"SGST / UTGST",IGST,CESS;
        HSNSGSTAmt: Decimal;
        HSNCGSTAmt: Decimal;
        HSNIGSTAmt: Decimal;
        HSNCessAmt: Decimal;
        HSNQty: Decimal;
        GSTBaseAmount: Decimal;
        DescriptionTxt: Label 'Description';
        CompTaxablePersonTxt: Label 'Composition taxable person';
        NilRatedSuppliesTxt: Label 'Nil Rated Supplies';
        ExemptedTxt: Label 'Exempted (other than nil rated/non GST supply)';
        NonGSTSuppliesTxt: Label 'Non-GST supplies';
        IntegratedTaxPaidTxt: Label 'Integrated Tax Paid';
        CentralTaxPaidTxt: Label 'Central Tax Paid';
        StateTaxPaidTxt: Label 'State/UT Tax Paid';
        CessPaidTxt: Label 'Cess Paid';
        EligibilityITCTxt: Label 'Eligibilty for ITC';
        AvailedITCIntegratedTaxTxt: Label 'Availed ITC Integrated Tax';
        AvailedITCCentralTaxTxt: Label 'Availed ITC Central Tax';
        AvailedITCStateTaxTxt: Label 'Availed ITC State/UT Tax';
        AvailedITCCessTxt: Label 'Availed ITC Cess';
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CGSTAmountITC: Decimal;
        SGSTAmountITC: Decimal;
        IGSTAmountITC: Decimal;
        CESSAmountITC: Decimal;
        SupplyTypeTxt: Label 'Supply Type';
        SupplierNameTxt: Label 'Supplier Name';
        InvoiceNoRegTxt: Label 'Invoice Number of Reg Receipient';
        BillOfEntryNoTxt: Label 'Bill Of Entry Number';
        BillOfEntryDateTxt: Label 'Bill Of Entry Date';
        BillOfEntryValueTxt: Label 'Bill Of Entry Value';
        GSTAssessableValue: Decimal;
        PurchIntraStateAmount: Decimal;
        PurchInterStateAmount: Decimal;
        ExemptedValue: Decimal;
        FeatureAvlblErr: Label 'This feature will be available in the next release.';

    [Scope('Internal')]
    procedure MakeExcelHeaderB2B()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplierNameTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//acxcp
        TempExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReverseChargeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CentralTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(StateTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EligibilityITCTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCentralTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCStateTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2B()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        BuyerSellerRegNo: Code[15];
        GSTPercentage: Decimal;
        ITCEligibility: Text[100];
        ITCEligibility1: Text[100];
        Vendor: Record "23";
        recVendor: Record "23";
        recCompInfo: Record "79";
    begin
        MakeExcelHeaderB2B;
        ITCEligibility := '';
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Buyer/Seller Reg. No.", "Document Type", "Document No.", "GST %", "Eligibility for ITC");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETFILTER("Purchase Invoice Type", '<>%1&<>%2', "Purchase Invoice Type"::"Debit Note", "Purchase Invoice Type"::Supplementary);
            SETRANGE("GST Vendor Type", "GST Vendor Type"::Registered);
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");//ACX-RK 08102021
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Capital goods" THEN
                        ITCEligibility1 := 'Capital goods';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Ineligible THEN
                        ITCEligibility1 := 'Ineligible';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Inputs THEN
                        ITCEligibility1 := 'Inputs';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Input Services" THEN
                        ITCEligibility1 := 'Input Services';

                    IF (BuyerSellerRegNo <> "Buyer/Seller Reg. No.") OR (DocumentNo <> "Document No.") OR
                       (GSTPercentage <> "GST %") OR (ITCEligibility <> ITCEligibility1)
                    THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;
                        // IF Vendor.GET("Source No.") THEN; //ACXCP //18102021
                        IF GSTComponent.GET("GST Component Code") AND (GSTComponent."Report View" <> GSTComponent."Report View"::CESS) THEN
                            GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF TotalBaseAmount <> 0 THEN BEGIN
                                    TempExcelBuffer.NewRow;
                                    TempExcelBuffer.AddColumn(
                                      "Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    //acxcp_020821
                                    IF Vendor.GET("Source No.") THEN BEGIN
                                        TempExcelBuffer.AddColumn(
                                          Vendor.Name, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//acxcp
                                    END ELSE BEGIN
                                        recCompInfo.GET;
                                        TempExcelBuffer.AddColumn(
                                        recCompInfo.Name, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//acxcp
                                    END;
                                    //acxcp_020821
                                    TempExcelBuffer.AddColumn(
                                      "External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    IF "Original Doc. Type" = "Original Doc. Type"::"Transfer Receipt" THEN
                                        TempExcelBuffer.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date)
                                    ELSE
                                        TempExcelBuffer.AddColumn(
                                          GetDocumentDate("Transaction No."), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                    IF "Reverse Charge" THEN
                                        TempExcelBuffer.AddColumn(
                                          GetInvoiceValue("Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                          FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
                                    ELSE
                                        IF "Original Doc. Type" = "Original Doc. Type"::"Transfer Receipt" THEN
                                            TempExcelBuffer.AddColumn(
                                              GetTransferReceiptValue("Original Doc. No."), FALSE, '', FALSE, FALSE, FALSE, '',
                                              TempExcelBuffer."Cell Type"::Number)
                                        ELSE
                                            TempExcelBuffer.AddColumn(
                                              GetInvoiceValue("Transaction No."), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE,
                                      FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    IF "Reverse Charge" THEN
                                        TempExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        TempExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn('Regular', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(GSTPer, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(IGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(SGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(ITCEligibility1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    IF ITCEligibility1 = 'Ineligible' THEN
                                        ClearITCValue;
                                    TempExcelBuffer.AddColumn(IGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(SGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                END;
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := "Document No.";
                            GSTPercentage := "GST %";
                            ITCEligibility := ITCEligibility1;
                            BuyerSellerRegNo := "Buyer/Seller Reg. No.";
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderB2BUR()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(SupplierNameTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplyTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CentralTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(StateTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EligibilityITCTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCentralTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCStateTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2BUR()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        Vendor: Record "23";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
        ITCEligibility: Text[100];
        ITCEligibility1: Text[100];
    begin
        MakeExcelHeaderB2BUR;
        ITCEligibility := '';
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Document Type", "Document No.", "GST %", "Eligibility for ITC");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETFILTER("Purchase Invoice Type", '<>%1&<>%2', "Purchase Invoice Type"::"Debit Note", "Purchase Invoice Type"::Supplementary);
            SETRANGE("GST Vendor Type", "GST Vendor Type"::Unregistered);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Capital goods" THEN
                        ITCEligibility1 := 'Capital goods';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Ineligible THEN
                        ITCEligibility1 := 'Ineligible';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Inputs THEN
                        ITCEligibility1 := 'Inputs';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Input Services" THEN
                        ITCEligibility1 := 'Input Services';

                    IF (DocumentNo <> "Document No.") OR (GSTPercentage <> "GST %") OR (ITCEligibility <> ITCEligibility1) THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;
                        IF Vendor.GET("Source No.") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF TotalBaseAmount <> 0 THEN BEGIN
                                    TempExcelBuffer.NewRow;
                                    TempExcelBuffer.AddColumn(Vendor.Name, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(
                                      GetDocumentDate("Transaction No."), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                    TempExcelBuffer.AddColumn(
                                      GetInvoiceValue("Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                      FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                      FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(
                                      "GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(IGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(SGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(ITCEligibility1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    IF ITCEligibility1 = 'Ineligible' THEN
                                        ClearITCValue;
                                    TempExcelBuffer.AddColumn(IGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(SGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                END;
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := "Document No.";
                            GSTPercentage := "GST %";
                            ITCEligibility := ITCEligibility1;
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderIMPS()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(InvoiceNoRegTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplyTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EligibilityITCTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyIMPS()
    var
        DetailedGSTLedgerEntry: Record "16419";
        GSTComponent: Record "16405";
        State: Record "13762";
        GSTPercentage: Decimal;
        DocumentNo: Code[20];
        ITCEligibility: Text[100];
        ITCEligibility1: Text[100];
    begin
        MakeExcelHeaderIMPS;
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Document Type", "Document No.", "GST %", "Eligibility for ITC");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETFILTER("Purchase Invoice Type", '<>%1&<>%2', "Purchase Invoice Type"::"Debit Note", "Purchase Invoice Type"::Supplementary);
            SETFILTER("GST Vendor Type", '%1|%2', "GST Vendor Type"::Import, "GST Vendor Type"::SEZ);
            SETRANGE("GST Group Type", "GST Group Type"::Service);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Capital goods" THEN
                        ITCEligibility1 := 'Capital goods';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Ineligible THEN
                        ITCEligibility1 := 'Ineligible';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Inputs THEN
                        ITCEligibility1 := 'Inputs';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Input Services" THEN
                        ITCEligibility1 := 'Input Services';

                    IF (DocumentNo <> "Document No.") OR (GSTPercentage <> "GST %") OR (ITCEligibility <> ITCEligibility1) THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF TotalBaseAmount <> 0 THEN BEGIN
                                    TempExcelBuffer.NewRow;
                                    TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                    TempExcelBuffer.AddColumn(
                                      GetInvoiceValue("Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                      FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE,
                                      FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(
                                      "GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(IGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(ITCEligibility1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    IF ITCEligibility1 = 'Ineligible' THEN
                                        ClearITCValue;
                                    TempExcelBuffer.AddColumn(IGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                END;
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := "Document No.";
                            GSTPercentage := "GST %";
                            ITCEligibility := ITCEligibility1;
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderIMPG()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(PortCodeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(BillOfEntryNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(BillOfEntryDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(BillOfEntryValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GSTINSEZTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EligibilityITCTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyIMPG()
    var
        DetailedGSTLedgerEntry: Record "16419";
        GSTComponent: Record "16405";
        State: Record "13762";
        PurchInvHeader: Record "122";
        GSTPercentage: Decimal;
        ITCEligibility: Text[100];
        ITCEligibility1: Text[100];
        BillOfEntryNo: Code[20];
        GSTVendType: Text[30];
        GSTVendType1: Text[30];
    begin
        MakeExcelHeaderIMPG;
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Document Type", "Bill of Entry No.", "GST %", "Eligibility for ITC");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETFILTER("Purchase Invoice Type", '<>%1&<>%2', "Purchase Invoice Type"::"Debit Note", "Purchase Invoice Type"::Supplementary);
            SETFILTER("GST Vendor Type", '%1|%2', "GST Vendor Type"::Import, "GST Vendor Type"::SEZ);
            SETRANGE("GST Group Type", "GST Group Type"::Goods);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Capital goods" THEN
                        ITCEligibility1 := 'Capital goods';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Ineligible THEN
                        ITCEligibility1 := 'Ineligible';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Inputs THEN
                        ITCEligibility1 := 'Inputs';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Input Services" THEN
                        ITCEligibility1 := 'Input Services';

                    IF "GST Vendor Type" = "GST Vendor Type"::Import THEN
                        GSTVendType1 := 'Import';
                    IF "GST Vendor Type" = "GST Vendor Type"::SEZ THEN
                        GSTVendType1 := 'SEZ';

                    IF (BillOfEntryNo <> "Bill of Entry No.") OR (GSTVendType <> GSTVendType1) OR (GSTPercentage <> "GST %") OR
                       (ITCEligibility <> ITCEligibility1)
                    THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                TempExcelBuffer.NewRow;
                                PurchInvHeader.GET("Document No.");
                                TempExcelBuffer.AddColumn(
                                  PurchInvHeader."Entry Point", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn("Bill of Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn("Bill of Entry Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                TempExcelBuffer.AddColumn(GSTAssessableValue, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(GSTVendType1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn("Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(IGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(ITCEligibility1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                IF ITCEligibility1 = 'Ineligible' THEN
                                    ClearITCValue;
                                TempExcelBuffer.AddColumn(IGSTAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(CESSAmountITC, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            END;
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            GSTPercentage := "GST %";
                            ITCEligibility := ITCEligibility1;
                            BillOfEntryNo := "Bill of Entry No.";
                            GSTVendType := GSTVendType1;
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderCDNR()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplierNameTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text); //ACXCP_020821
        TempExcelBuffer.AddColumn(RefundVoucherNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RefundVoucherDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvVoucherNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvVoucherDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PreGSTTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReasonForIssuingNoteTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplyTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RefundVoucherValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CentralTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(StateTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EligibilityITCTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCentralTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCStateTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyCDNR()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        BuyerSellerRegNo: Code[15];
        GSTPercentage: Decimal;
        ITCEligibility: Text[100];
        ITCEligibility1: Text[100];
        DocumentType: Text[30];
        DocumentType1: Text[30];
        Vendor: Record "23";
    begin
        MakeExcelHeaderCDNR;
        ITCEligibility := '';
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Buyer/Seller Reg. No.", "Document Type",
              "Document No.", "GST %", "Eligibility for ITC");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETFILTER(
              "Document Type", '%1|%2|%3', "Document Type"::"Credit Memo", "Document Type"::Invoice, "Document Type"::Refund);
            SETFILTER(
              "GST Vendor Type", '%1|%2|%3', "GST Vendor Type"::Import, "GST Vendor Type"::Registered, "GST Vendor Type"::SEZ);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Capital goods" THEN
                        ITCEligibility1 := 'Capital goods';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Ineligible THEN
                        ITCEligibility1 := 'Ineligible';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Inputs THEN
                        ITCEligibility1 := 'Inputs';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Input Services" THEN
                        ITCEligibility1 := 'Input Services';

                    IF "Document Type" = "Document Type"::Invoice THEN
                        DocumentType1 := 'Invoice';
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                        DocumentType1 := 'Credit Memo';
                    IF "Document Type" = "Document Type"::Refund THEN
                        DocumentType1 := 'Refund';

                    IF (BuyerSellerRegNo <> "Buyer/Seller Reg. No.") OR (DocumentType <> DocumentType1) OR (DocumentNo <> "Document No.") OR
                       (GSTPercentage <> "GST %") OR (ITCEligibility <> ITCEligibility1)
                    THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;
                        IF Vendor.GET("Source No.") THEN;//ACXCP_020821
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::Refund]) OR
                                   (("Document Type" = "Document Type"::Invoice) AND
                                    ("Purchase Invoice Type" IN ["Purchase Invoice Type"::"Debit Note",
                                                                 "Purchase Invoice Type"::Supplementary])) OR
                                   ("GST Vendor Type" IN ["GST Vendor Type"::Import, "GST Vendor Type"::SEZ]) AND
                                   ("GST Group Type" = "GST Group Type"::Service)
                                THEN
                                    IF TotalBaseAmount <> 0 THEN BEGIN
                                        TempExcelBuffer.NewRow;
                                        TempExcelBuffer.AddColumn(
                                          "Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(Vendor.Name, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//ACXCP_020821
                                        TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(
                                          GetDocumentDate("Transaction No."), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                        IF "Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::Invoice] THEN BEGIN
                                            TempExcelBuffer.AddColumn(
                                              "Original Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                            TempExcelBuffer.AddColumn(
                                              "Original Invoice Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                        END;
                                        IF "Document Type" = "Document Type"::Refund THEN BEGIN
                                            TempExcelBuffer.AddColumn(
                                              "Original Adv. Pmt Doc. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                            TempExcelBuffer.AddColumn(
                                              "Original Adv. Pmt Doc. Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                                        END;
                                        IF CheckPreGST("Document Type", "Original Invoice No.", "Document No.", "Original Adv. Pmt Doc. No.") THEN
                                            TempExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text)
                                        ELSE
                                            TempExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        IF "Document Type" = "Document Type"::"Credit Memo" THEN
                                            TempExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        IF "Document Type" = "Document Type"::Invoice THEN
                                            TempExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        IF "Document Type" = "Document Type"::Refund THEN
                                            TempExcelBuffer.AddColumn('R', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn("GST Reason Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(
                                          "GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        IF "Reverse Charge" THEN
                                            IF "Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::Refund] THEN
                                                TempExcelBuffer.AddColumn(
                                                  GetInvoiceValue("Transaction No.") - GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                                  FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
                                            ELSE
                                                TempExcelBuffer.AddColumn(
                                                  GetInvoiceValue("Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                                  FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
                                        ELSE
                                            TempExcelBuffer.AddColumn(
                                              GetInvoiceValue("Transaction No."), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(
                                          ABS(TotalBaseAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(IGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(SGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CESSAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ITCEligibility1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        IF ITCEligibility1 = 'Ineligible' THEN
                                            ClearITCValue;
                                        TempExcelBuffer.AddColumn(ABS(IGSTAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CGSTAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(SGSTAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CESSAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    END;
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := "Document No.";
                            BuyerSellerRegNo := "Buyer/Seller Reg. No.";
                            GSTPercentage := "GST %";
                            ITCEligibility := ITCEligibility1;
                            DocumentType := DocumentType1;
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderCDNUR()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(RefundVoucherNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RefundVoucherDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvVoucherNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvVoucherDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PreGSTTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReasonForIssuingNoteTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplyTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RefundVoucherValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CentralTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(StateTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EligibilityITCTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCentralTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCStateTaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyCDNUR()
    var
        DetailedGSTLedgerEntry: Record "16419";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
        ITCEligibility: Text[100];
        ITCEligibility1: Text[100];
        DocumentType: Text[30];
        DocumentType1: Text[30];
    begin
        MakeExcelHeaderCDNUR;
        ITCEligibility := '';
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Document Type", "Document No.", "GST %", "Eligibility for ITC");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETFILTER("Document Type", '%1|%2|%3', "Document Type"::"Credit Memo", "Document Type"::Invoice, "Document Type"::Refund);
            SETRANGE("GST Vendor Type", "GST Vendor Type"::Unregistered);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Capital goods" THEN
                        ITCEligibility1 := 'Capital goods';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Ineligible THEN
                        ITCEligibility1 := 'Ineligible';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::Inputs THEN
                        ITCEligibility1 := 'Inputs';
                    IF "Eligibility for ITC" = "Eligibility for ITC"::"Input Services" THEN
                        ITCEligibility1 := 'Input Services';

                    IF "Document Type" = "Document Type"::Invoice THEN
                        DocumentType1 := 'Invoice';
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                        DocumentType1 := 'Credit Memo';
                    IF "Document Type" = "Document Type"::Refund THEN
                        DocumentType1 := 'Refund';

                    IF (DocumentType <> DocumentType1) OR (DocumentNo <> "Document No.") OR (GSTPercentage <> "GST %") OR
                       (ITCEligibility <> ITCEligibility1)
                    THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::Refund]) OR
                                   (("Document Type" = "Document Type"::Invoice) AND
                                    ("Purchase Invoice Type" IN ["Purchase Invoice Type"::"Debit Note",
                                                                 "Purchase Invoice Type"::Supplementary]))
                                THEN
                                    MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry, ITCEligibility1);
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := "Document No.";
                            GSTPercentage := "GST %";
                            ITCEligibility := ITCEligibility1;
                            DocumentType := DocumentType1;
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry: Record "16419"; ITCEligibility: Text[100])
    begin
        IF TotalBaseAmount <> 0 THEN BEGIN
            TempExcelBuffer.NewRow;
            TempExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(
              GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."), FALSE, '', FALSE, FALSE,
              FALSE, '', TempExcelBuffer."Cell Type"::Text);
            IF (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
                                                           DetailedGSTLedgerEntry."Document Type"::Invoice])
            THEN BEGIN
                TempExcelBuffer.AddColumn(
                  DetailedGSTLedgerEntry."Original Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(
                  DetailedGSTLedgerEntry."Original Invoice Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
            END;
            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN BEGIN
                TempExcelBuffer.AddColumn(
                  DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(
                  DetailedGSTLedgerEntry."Original Adv. Pmt Doc. Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
            END;
            IF CheckPreGST(
                 DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Invoice No.",
                 DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.")
            THEN
                TempExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text)
            ELSE
                TempExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo" THEN
                TempExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice THEN
                TempExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN
                TempExcelBuffer.AddColumn('R', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."GST Reason Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            IF DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
                                                          DetailedGSTLedgerEntry."Document Type"::Refund]
            THEN
                TempExcelBuffer.AddColumn(
                  GetInvoiceValue(DetailedGSTLedgerEntry."Transaction No.") - GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                  FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
            ELSE
                TempExcelBuffer.AddColumn(
                  GetInvoiceValue(DetailedGSTLedgerEntry."Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                  FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(TotalBaseAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(IGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(CGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(SGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(CESSAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ITCEligibility, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            IF ITCEligibility = 'Ineligible' THEN
                ClearITCValue;
            TempExcelBuffer.AddColumn(ABS(IGSTAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(CGSTAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(SGSTAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(ABS(CESSAmountITC), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        END;
    end;

    local procedure MakeExcelHeaderAT()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GrossAdvanceRcvdTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyAT()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        LocationStateCode: Code[10];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderAT;
        UpdateGSTRate;
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY(
              "Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Location State Code", "GST Rate %");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETFILTER("Document Type", '%1', "Document Type"::Payment);
            SETRANGE(Reversed, FALSE);
            SETRANGE("GST on Advance Payment", TRUE);
            SETFILTER("GST Rate %", '<>%1', 0);
            IF FINDSET THEN
                REPEAT
                    IF (LocationStateCode <> "Location State Code") OR (GSTPercentage <> "GST Rate %") THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                GetComponentValueAdvPayment(DetailedGSTLedgerEntry);
                                GetApplicationRemAmt(DetailedGSTLedgerEntry);

                                IF TotalBaseAmount - TotalBaseAmountApp <> 0 THEN BEGIN
                                    TempExcelBuffer.NewRow;
                                    TempExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                      FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(
                                      TotalBaseAmount - TotalBaseAmountApp, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(
                                      CESSAmount - CESSAmountApp, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                END;
                            END;
                    END;
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            LocationStateCode := "Location State Code";
                            GSTPercentage := "GST Rate %"
                        END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderEXEMP()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(DescriptionTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompTaxablePersonTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(NilRatedSuppliesTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ExemptedTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(NonGSTSuppliesTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyEXEMP()
    var
        DetailedGSTLedgerEntry: Record "16419";
        GSTJurisdiction: Text[100];
        GSTJurisdiction1: Text[100];
    begin
        MakeExcelHeaderEXEMP;
        GSTJurisdiction := '';

        IF DetailedGSTExists THEN
            WITH DetailedGSTLedgerEntry DO BEGIN
                SETCURRENTKEY("Location  Reg. No.", "Entry Type", "GST Jurisdiction Type");
                SETRANGE("Location  Reg. No.", GSTIN);
                SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
                SETRANGE("Transaction Type", "Transaction Type"::Purchase);
                SETFILTER("Document Type", '%1|%2', "Document Type"::Invoice, "Document Type"::"Credit Memo");
                SETFILTER("GST Vendor Type", '%1|%2', "GST Vendor Type"::Exempted, "GST Vendor Type"::Composite);
                SETRANGE("GST %", 0);
                IF FINDSET THEN
                    REPEAT
                        ClearVariables;
                        IF "GST Jurisdiction Type" = "GST Jurisdiction Type"::Interstate THEN
                            GSTJurisdiction1 := 'Interstate';
                        IF "GST Jurisdiction Type" = "GST Jurisdiction Type"::Intrastate THEN
                            GSTJurisdiction1 := 'Intrastate';

                        IF GSTJurisdiction <> GSTJurisdiction1 THEN BEGIN
                            NonGSTInwardSupply;
                            TempExcelBuffer.NewRow;
                            TempExcelBuffer.AddColumn("GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(
                              GetCompositionTaxableValue(DetailedGSTLedgerEntry), FALSE, '', FALSE, FALSE,
                              FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(ExemptedValue, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            IF GSTJurisdiction1 = 'Interstate' THEN
                                TempExcelBuffer.AddColumn(PurchInterStateAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
                            ELSE
                                IF GSTJurisdiction1 = 'Intrastate' THEN
                                    TempExcelBuffer.AddColumn(
                                      PurchIntraStateAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        END;
                        GSTJurisdiction := GSTJurisdiction1;
                    UNTIL NEXT = 0;
            END ELSE BEGIN
            ClearVariables;
            NonGSTInwardSupply;
            IF PurchInterStateAmount <> 0 THEN BEGIN
                TempExcelBuffer.NewRow;
                TempExcelBuffer.AddColumn('Interstate', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(PurchInterStateAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
            END;
            IF PurchIntraStateAmount <> 0 THEN BEGIN
                TempExcelBuffer.NewRow;
                TempExcelBuffer.AddColumn('Intrastate', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(0, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(PurchIntraStateAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
            END;
        END;
    end;

    local procedure MakeExcelHeaderHSN()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(HSNSACofSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DescTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(UPPERCASE(UQCTxt), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TotalQtyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TotalValTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyHSN()
    var
        DetailedGSTLedgerEntry: Record "16419";
        UnitOfMeasure: Record "204";
        HsnSac: Record "16411";
        HSNCode: Code[8];
        UOMCode: Code[10];
    begin
        MakeExcelHeaderHSN;
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Transaction Type", "HSN/SAC Code", UOM);
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETFILTER("Document Type", '%1|%2', "Document Type"::Invoice, "Document Type"::"Credit Memo");
            IF FINDSET THEN
                REPEAT
                    IF (HSNCode <> "HSN/SAC Code") OR (UOMCode <> UOM) THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearHSNInfo;
                        GSTBaseAmount += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::IGST, TRUE, FALSE);
                        HSNIGSTAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::IGST, FALSE, FALSE);
                        HSNCGSTAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::CGST, FALSE, FALSE);
                        HSNSGSTAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::"SGST / UTGST", FALSE, FALSE);
                        HSNCessAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::CESS, FALSE, FALSE);
                        HSNQty += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::CESS, FALSE, TRUE);
                        IF GSTBaseAmount <> 0 THEN BEGIN
                            TempExcelBuffer.NewRow;
                            TempExcelBuffer.AddColumn("HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            HsnSac.GET("GST Group Code", "HSN/SAC Code");
                            TempExcelBuffer.AddColumn(HsnSac.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            IF UnitOfMeasure.GET(UOM) THEN;
                            IF UOM <> '' THEN
                                TempExcelBuffer.AddColumn(
                                  UnitOfMeasure."GST Reporting UQC", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text)
                            ELSE
                                TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(HSNQty, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            IF ("GST Vendor Type" IN ["GST Vendor Type"::Import, "GST Vendor Type"::SEZ]) AND
                               ("GST Group Type" = "GST Group Type"::Goods) AND ("Document Type" = "Document Type"::Invoice)
                            THEN
                                TempExcelBuffer.AddColumn(
                                  GetBaseAmountforImportGoods(DetailedGSTLedgerEntry) + HSNIGSTAmt + HSNCGSTAmt + HSNSGSTAmt + HSNCessAmt,
                                  FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number)
                            ELSE
                                TempExcelBuffer.AddColumn(GSTBaseAmount + HSNIGSTAmt + HSNCGSTAmt + HSNSGSTAmt + HSNCessAmt,
                                  FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(GSTBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HSNIGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HSNCGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HSNSGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(HSNCessAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        END;
                    END;
                    HSNCode := "HSN/SAC Code";
                    UOMCode := UOM;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure ClearVariables()
    begin
        GSTPer := 0;
        TotalBaseAmount := 0;
        CGSTAmount := 0;
        SGSTAmount := 0;
        IGSTAmount := 0;
        CESSAmount := 0;
        IGSTAmountITC := 0;
        SGSTAmountITC := 0;
        CGSTAmountITC := 0;
        CESSAmountITC := 0;
        GSTAssessableValue := 0;
        ExemptedValue := 0;
        TotalBaseAmountApp := 0;
        CESSAmountApp := 0;
        PurchIntraStateAmount := 0;
        PurchInterStateAmount := 0;
    end;

    local procedure GetComponentValues(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        OriginalInvNo: Code[20];
        LineNo: Integer;
        ItemChargeLineNo: Integer;
        c: Integer;
        BaseAmt: Decimal;
        TransactionNo: Integer;
        OriginalDocNo: Code[20];
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %", "Eligibility for ITC");
            SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type");
            SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
            SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
            IF FileFormat = FileFormat::IMPG THEN BEGIN
                SETRANGE("Bill of Entry No.", DetailedGSTLedgerEntry."Bill of Entry No.");
                SETRANGE("GST Vendor Type", DetailedGSTLedgerEntry."GST Vendor Type");
            END ELSE
                SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            IF (FileFormat = FileFormat::CDNR) AND
               (DetailedGSTLedgerEntry."GST Vendor Type" IN [DetailedGSTLedgerEntry."GST Vendor Type"::Import,
                                                             DetailedGSTLedgerEntry."GST Vendor Type"::SEZ])
            THEN
                SETRANGE("GST Group Type", "GST Group Type"::Service);
            IF DetailedGSTLedgerEntry."Reverse Charge" AND
               (DetailedGSTLedgerEntry."Entry Type" = DetailedGSTLedgerEntry."Entry Type"::Application)
            THEN
                SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Eligibility for ITC", DetailedGSTLedgerEntry."Eligibility for ITC");
            SETRANGE(UnApplied, FALSE);

            IF FINDSET THEN
                REPEAT
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    GSTComponent.FINDFIRST;
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF (LineNo <> "Document Line No.") OR (OriginalInvNo <> "Original Invoice No.") OR
                           (ItemChargeLineNo <> "Item Charge Assgn. Line No.") OR (TransactionNo <> "Transaction No.") OR
                           (OriginalDocNo <> "Original Doc. No.")
                        THEN BEGIN
                            IF NOT "Reverse Charge" THEN BEGIN
                                TotalBaseAmount += "GST Base Amount";
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1, FALSE);
                                CESSAmountITC += GetCessAmount(DetailedGSTLedgerEntry1, TRUE);
                            END ELSE BEGIN
                                TotalBaseAmount += "GST Base Amount";//acxcp_181021
                                CESSAmount += GetITCCessAmtRevCharge(DetailedGSTLedgerEntry1, FALSE);
                                CESSAmountITC += GetITCCessAmtRevCharge(DetailedGSTLedgerEntry1, TRUE);
                            END;
                            c += 1;
                        END;
                    CASE GSTComponent."Report View" OF
                        GSTComponent."Report View"::CGST:
                            IF NOT "Reverse Charge" THEN BEGIN
                                CGSTAmount += "GST Amount";
                                CGSTAmountITC += "GST Amount";
                            END ELSE BEGIN
                                CGSTAmount += "GST Amount";//acxcp_181021
                                CGSTAmountITC += "GST Amount";//acxcp_181021
                                CGSTAmount += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, FALSE, TotalBaseAmount);
                                CGSTAmountITC += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, TRUE, TotalBaseAmount);
                            END;
                        GSTComponent."Report View"::"SGST / UTGST":
                            IF NOT "Reverse Charge" THEN BEGIN
                                SGSTAmount += "GST Amount";
                                SGSTAmountITC += "GST Amount";
                            END ELSE BEGIN
                                SGSTAmount += "GST Amount";//acxcp_181021
                                SGSTAmountITC += "GST Amount";//acxcp_181021
                                SGSTAmount += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, FALSE, BaseAmt);
                                SGSTAmountITC += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, TRUE, BaseAmt);
                            END;
                        GSTComponent."Report View"::IGST:
                            IF NOT "Reverse Charge" THEN BEGIN
                                IGSTAmount += "GST Amount";
                                IGSTAmountITC += "GST Amount";
                            END ELSE
                                IF FileFormat = FileFormat::IMPS THEN BEGIN
                                    IGSTAmount += GetIGSTComponentAmtRevCharge(DetailedGSTLedgerEntry1, FALSE, TotalBaseAmount);
                                    IGSTAmountITC += GetIGSTComponentAmtRevCharge(DetailedGSTLedgerEntry1, TRUE, TotalBaseAmount);
                                END ELSE BEGIN
                                    IGSTAmount += "GST Amount";//acxcp_181021
                                    IGSTAmountITC += "GST Amount";//acxcp_181021
                                    IGSTAmount += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, FALSE, TotalBaseAmount);
                                    IGSTAmountITC += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, TRUE, TotalBaseAmount);
                                END;
                    END;
                    GSTPer += "GST %";
                    LineNo := "Document Line No.";
                    OriginalInvNo := "Original Invoice No.";
                    ItemChargeLineNo := "Item Charge Assgn. Line No.";
                    TransactionNo := "Transaction No.";
                    OriginalDocNo := "Original Doc. No.";
                UNTIL NEXT = 0;
        END;
        IF c > 1 THEN
            GSTPer := GSTPer / c;
    end;

    local procedure GetApplicationRemAmt(DetailedGSTLedgerEntry: Record "16419")
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntry1: Record "16419";
        DocumentNo: Code[20];
        LineNo: Integer;
        TransactionNo: Integer;
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Entry Type", "Entry Type"::Application);
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETFILTER("Original Doc. No.", '<>%1', '');
            SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            SETRANGE(Reversed, FALSE);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF "GST Jurisdiction Type" = "GST Jurisdiction Type"::Intrastate THEN BEGIN
                                IF (DocumentNo <> "Document No.") OR (LineNo <> "Document Line No.") OR
                                   (TransactionNo <> "Transaction No.")
                                THEN BEGIN
                                    TotalBaseAmountApp += ABS("GST Base Amount");
                                    CESSAmountApp += GetCessAmountApplication(DetailedGSTLedgerEntry1);
                                END;
                                LineNo := "Document Line No.";
                                DocumentNo := "Document No.";
                                TransactionNo := "Transaction No.";
                            END ELSE BEGIN
                                IF (LineNo <> "Document Line No.") OR (TransactionNo <> "Transaction No.") THEN BEGIN
                                    TotalBaseAmountApp += ABS("GST Base Amount");
                                    CESSAmountApp += GetCessAmountApplication(DetailedGSTLedgerEntry1);
                                END;
                                LineNo := "Document Line No.";
                                TransactionNo := "Transaction No.";
                            END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure CheckPreGST(DocType: Option " ",Payment,Invoice,"Credit Memo",,,,Refund; OriginalInvoiceNo: Code[20]; DocumentNo: Code[20]; ApplicationDocNo: Code[20]): Boolean
    var
        DetailedGSTLedgerEntry1: Record "16419";
    begin
        IF DocType = DocType::"Credit Memo" THEN BEGIN
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Invoice);
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", OriginalInvoiceNo);
            IF DetailedGSTLedgerEntry1.FINDFIRST THEN
                EXIT(FALSE);
            EXIT(TRUE);
        END;
        IF DocType = DocType::Invoice THEN BEGIN
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Invoice);
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", DocumentNo);
            IF DetailedGSTLedgerEntry1.FINDFIRST THEN
                EXIT(FALSE);
            EXIT(TRUE);
        END;
        IF DocType = DocType::Refund THEN BEGIN
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Payment);
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", ApplicationDocNo);
            IF DetailedGSTLedgerEntry1.FINDFIRST THEN
                EXIT(FALSE);
            EXIT(TRUE);
        END;
    end;

    local procedure GetComponentValueAdvPayment(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        LineNo: Integer;
        DocumentNo: Code[20];
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type");
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
            SETRANGE(Reversed, FALSE);
            SETRANGE("GST on Advance Payment", TRUE);
            SETRANGE("GST Rate %", DetailedGSTLedgerEntry."GST Rate %");
            IF FINDSET THEN
                REPEAT
                    GSTComponent.SETRANGE(Code, "GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF "GST Jurisdiction Type" = "GST Jurisdiction Type"::Intrastate THEN BEGIN
                                IF (DocumentNo <> "Document No.") OR (LineNo <> "Document Line No.") THEN BEGIN
                                    TotalBaseAmount += ABS("GST Base Amount");
                                    CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1, FALSE);
                                END;
                                GSTPer := "GST Rate %";
                                DocumentNo := "Document No.";
                                LineNo := "Document Line No.";
                            END ELSE BEGIN
                                GSTPer := "GST Rate %";
                                TotalBaseAmount += ABS("GST Base Amount");
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1, FALSE);
                            END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure GetGSTAmountComp(HSNSACCode: Code[8]; UOMCode: Code[10]; ReportView: Option; Base: Boolean; Qty: Boolean): Decimal
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntry: Record "16419";
        DetailedGSTLedgerEntry1: Record "16419";
        GSTAmount: Decimal;
        DocumentNo: Code[20];
        LineNo: Integer;
        OriginalInvoiceNo: Code[20];
        ItemChargesAssgnLineNo: Integer;
        CompDocumentNo: Code[20];
        CompLineNo: Integer;
        DocumentNo1: Code[20];
        CompItemchargeLineNo: Integer;
        CompOriginalInvNo: Code[20];
        Sign: Integer;
    begin
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Posting Date", "Transaction Type", "Document Type",
          "HSN/SAC Code", UOM, "Document No.", "Document Line No.");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Purchase);
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice,
          DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETRANGE("HSN/SAC Code", HSNSACCode);
        DetailedGSTLedgerEntry.SETRANGE(UOM, UOMCode);
        DetailedGSTLedgerEntry.SETRANGE(UnApplied, FALSE);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DocumentNo1 <> DetailedGSTLedgerEntry."Document No." THEN BEGIN
                    DetailedGSTLedgerEntry1.SETCURRENTKEY(
                      "Location  Reg. No.", "Posting Date", "Transaction Type", "Document Type",
                      "HSN/SAC Code", UOM, "Document No.", "Document Line No.");
                    DetailedGSTLedgerEntry1.COPYFILTERS(DetailedGSTLedgerEntry);
                    DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                    DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
                    IF DetailedGSTLedgerEntry."Reverse Charge" AND
                       (DetailedGSTLedgerEntry."GST Group Type" = DetailedGSTLedgerEntry."GST Group Type"::Service) AND
                       (NOT DetailedGSTLedgerEntry."Associated Enterprises")
                    THEN
                        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::Application)
                    ELSE
                        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
                    DetailedGSTLedgerEntry1.SETRANGE("HSN/SAC Code", DetailedGSTLedgerEntry."HSN/SAC Code");
                    DetailedGSTLedgerEntry1.SETRANGE(UOM, DetailedGSTLedgerEntry.UOM);
                    IF DetailedGSTLedgerEntry1.FINDSET THEN
                        REPEAT
                            IF (DetailedGSTLedgerEntry1."Entry Type" = DetailedGSTLedgerEntry1."Entry Type"::Application) OR
                               (DetailedGSTLedgerEntry1."Document Type" = DetailedGSTLedgerEntry1."Document Type"::"Credit Memo")
                            THEN
                                Sign := -1
                            ELSE
                                Sign := 1;
                            IF NOT Base AND NOT Qty THEN
                                IF GSTComponent.GET(DetailedGSTLedgerEntry1."GST Component Code") THEN
                                    IF GSTComponent."Report View" = ReportView THEN
                                        IF (CompDocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                           (CompLineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                           (CompOriginalInvNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                           (CompItemchargeLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                        THEN BEGIN
                                            IF DetailedGSTLedgerEntry1."Entry Type" = DetailedGSTLedgerEntry1."Entry Type"::Application THEN
                                                GSTAmount += Sign * DetailedGSTLedgerEntry1."GST Amount"
                                            ELSE
                                                GSTAmount += DetailedGSTLedgerEntry1."GST Amount";
                                            CompDocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                            CompLineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                            CompOriginalInvNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                            CompItemchargeLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                                        END;
                            IF Base OR Qty THEN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargesAssgnLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    IF Base THEN
                                        IF DetailedGSTLedgerEntry1."Entry Type" = DetailedGSTLedgerEntry1."Entry Type"::Application THEN
                                            GSTAmount += Sign * DetailedGSTLedgerEntry1."GST Base Amount"
                                        ELSE
                                            GSTAmount += DetailedGSTLedgerEntry1."GST Base Amount"
                                    ELSE
                                        IF Qty THEN
                                            GSTAmount += Sign * DetailedGSTLedgerEntry1.Quantity;
                                    DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                    LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                    OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                    ItemChargesAssgnLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                                END;
                        UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
                END;
                DocumentNo1 := DetailedGSTLedgerEntry."Document No.";
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        EXIT(GSTAmount);
    end;

    local procedure ClearHSNInfo()
    begin
        GSTBaseAmount := 0;
        HSNIGSTAmt := 0;
        HSNCGSTAmt := 0;
        HSNSGSTAmt := 0;
        HSNCessAmt := 0;
        HSNQty := 0;
    end;

    local procedure GetCessAmount(DetailedGSTLedgerEntry: Record "16419"; ITC: Boolean): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocCessAmount: Decimal;
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
            IF DetailedGSTLedgerEntry."Item Charge Entry" THEN BEGIN
                SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
                SETRANGE("Original Invoice No.", DetailedGSTLedgerEntry."Original Invoice No.");
            END;
            IF ITC THEN
                SETRANGE("Credit Availed", TRUE);
            IF FINDSET THEN
                REPEAT
                    GSTComponent.GET("GST Component Code");
                    IF GSTComponent."Report View" = GSTComponent."Report View"::CESS THEN
                        DocCessAmount += "GST Amount";
                UNTIL NEXT = 0;
        END;
        EXIT(DocCessAmount);
    end;

    local procedure GetInvoiceValue(TransactionNo: Integer): Decimal
    var
        VendorLedgerEntry: Record "25";
        DetailedGSTLedgerEntry: Record "16419";
        DetailedGSTLedgerEntry1: Record "16419";
    begin
        VendorLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
        IF VendorLedgerEntry.FINDFIRST THEN
            VendorLedgerEntry.CALCFIELDS("Amount (LCY)")
        ELSE BEGIN
            DetailedGSTLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
            IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
                DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
                DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
                IF DetailedGSTLedgerEntry1.FINDFIRST THEN BEGIN
                    VendorLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry1."Transaction No.");
                    IF VendorLedgerEntry.FINDFIRST THEN
                        VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
                END;
            END;
        END;
        EXIT(ABS(VendorLedgerEntry."Amount (LCY)"));
    end;

    local procedure GetTransferReceiptValue(OriginalDocumentNo: Code[20]): Decimal
    var
        DetailedGSTLedgerEntry: Record "16419";
        BaseAmt: Decimal;
        GSTAmt: Decimal;
        LineNo: Integer;
    begin
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETRANGE("Original Doc. Type", "Original Doc. Type"::"Transfer Receipt");
            SETRANGE("Original Doc. No.", OriginalDocumentNo);
            IF FINDSET THEN
                REPEAT
                    IF LineNo <> "Document Line No." THEN
                        BaseAmt += "GST Base Amount";
                    LineNo := "Document Line No.";
                    GSTAmt += "GST Amount";
                UNTIL NEXT = 0;
        END;
        EXIT(BaseAmt + GSTAmt);
    end;

    local procedure GetDocumentDate(TransactionNo: Integer): Date
    var
        VendorLedgerEntry: Record "25";
        DetailedGSTLedgerEntry: Record "16419";
        DetailedGSTLedgerEntry1: Record "16419";
    begin
        VendorLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
        IF VendorLedgerEntry.FINDFIRST THEN
            EXIT(VendorLedgerEntry."Document Date");
        // ELSE BEGIN
        DetailedGSTLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
        IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
            IF DetailedGSTLedgerEntry1.FINDFIRST THEN BEGIN
                VendorLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry1."Transaction No.");
                IF VendorLedgerEntry.FINDFIRST THEN
                    EXIT(VendorLedgerEntry."Document Date")
            END;
        END;
        // END;
    end;

    local procedure CheckComponentReportView(ComponentCode: Code[10])
    var
        GSTComponent: Record "16405";
    begin
        GSTComponent.GET(ComponentCode);
        GSTComponent.TESTFIELD("Report View");
    end;

    local procedure GetCessAmountApplication(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocCessAmount: Decimal;
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Entry Type", "Entry Type"::Application);
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
            SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
            SETRANGE(UnApplied, FALSE);
            SETRANGE(Reversed, FALSE);
            IF FINDSET THEN
                REPEAT
                    GSTComponent.GET("GST Component Code");
                    IF GSTComponent."Report View" = GSTComponent."Report View"::CESS THEN
                        DocCessAmount += ABS("GST Amount");
                UNTIL NEXT = 0;
        END;
        EXIT(DocCessAmount);
    end;

    local procedure GetCompositionTaxableValue(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        CompositionTaxableValue: Decimal;
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
        OriginalInvoiceNo: Code[20];
        ItemChargeAssignmentLineNo: Integer;
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            COPYFILTERS(DetailedGSTLedgerEntry);
            SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type");
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            IF FINDSET THEN
                REPEAT
                    IF (DocumentNo <> "Document No.") OR (DocumentLineNo <> "Document Line No.") OR
                       (OriginalInvoiceNo <> "Original Invoice No.") OR
                       (ItemChargeAssignmentLineNo <> "Item Charge Assgn. Line No.")
                    THEN BEGIN
                        IF "GST Vendor Type" = "GST Vendor Type"::Composite THEN
                            CompositionTaxableValue += "GST Base Amount";
                        IF "GST Vendor Type" = "GST Vendor Type"::Exempted THEN
                            ExemptedValue += "GST Base Amount";
                    END;
                    DocumentNo := "Document No.";
                    DocumentLineNo := "Document Line No.";
                    OriginalInvoiceNo := "Original Invoice No.";
                    ItemChargeAssignmentLineNo := "Item Charge Assgn. Line No.";
                UNTIL NEXT = 0;
        END;
        EXIT(CompositionTaxableValue);
    end;

    local procedure GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry: Record "16419"; CreditAvailed: Boolean; var TotalBaseAmount: Decimal): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        CompAmount: Decimal;
        Sign: Integer;
    begin
        Sign := 1;
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            SETRANGE("GST Component Code", DetailedGSTLedgerEntry."GST Component Code");
            IF (DetailedGSTLedgerEntry."GST Group Type" = DetailedGSTLedgerEntry."GST Group Type"::Goods) OR
               (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::Refund,
                                                           DetailedGSTLedgerEntry."Document Type"::"Credit Memo"])
            THEN
                SETRANGE("Entry Type", "Entry Type"::"Initial Entry")
            ELSE BEGIN
                SETRANGE("Entry Type", "Entry Type"::Application);
                SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                Sign := -1;
            END;
            IF DetailedGSTLedgerEntry."Item Charge Entry" THEN BEGIN
                SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
                SETRANGE("Original Invoice No.", DetailedGSTLedgerEntry."Original Invoice No.");
            END;
            SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
            IF DetailedGSTLedgerEntry."Reverse Charge" AND
               (DetailedGSTLedgerEntry."Entry Type" = DetailedGSTLedgerEntry."Entry Type"::Application)
            THEN BEGIN
                SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                SETRANGE("Original Doc. No.", DetailedGSTLedgerEntry."Original Doc. No.");
            END;
            IF CreditAvailed THEN
                SETRANGE("Credit Availed", TRUE);
            SETRANGE(UnApplied, FALSE);
            IF FINDSET THEN
                REPEAT
                    IF NOT CreditAvailed THEN BEGIN
                        TotalBaseAmount += Sign * "GST Base Amount";
                        GSTAssessableValue += Sign * "GST Assessable Value";
                    END;
                    CompAmount += Sign * "GST Amount";
                UNTIL NEXT = 0;
        END;
        EXIT(CompAmount);
    end;

    local procedure GetITCCessAmtRevCharge(DetailedGSTLedgerEntry: Record "16419"; CreditAvailed: Boolean): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        CompAmount: Decimal;
        Sign: Integer;
    begin
        Sign := 1;
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            IF DetailedGSTLedgerEntry."GST Group Type" = DetailedGSTLedgerEntry."GST Group Type"::Goods THEN
                SETRANGE("Entry Type", "Entry Type"::"Initial Entry")
            ELSE
                IF (DetailedGSTLedgerEntry."GST Vendor Type" = DetailedGSTLedgerEntry."GST Vendor Type"::Import) AND
                   DetailedGSTLedgerEntry."Associated Enterprises" OR
                   (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::Refund,
                                                               DetailedGSTLedgerEntry."Document Type"::"Credit Memo"])
                THEN
                    SETRANGE("Entry Type", "Entry Type"::"Initial Entry")
                ELSE BEGIN
                    Sign := -1;
                    SETRANGE("Entry Type", "Entry Type"::Application);
                    SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                END;
            IF DetailedGSTLedgerEntry."Item Charge Entry" THEN BEGIN
                SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
                SETRANGE("Original Invoice No.", DetailedGSTLedgerEntry."Original Invoice No.");
            END;
            SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
            IF CreditAvailed THEN
                SETRANGE("Credit Availed", TRUE);
            SETRANGE(UnApplied, FALSE);
            IF DetailedGSTLedgerEntry."Reverse Charge" AND
               (DetailedGSTLedgerEntry."Entry Type" = DetailedGSTLedgerEntry."Entry Type"::Application)
            THEN BEGIN
                SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                SETRANGE("Original Doc. No.", DetailedGSTLedgerEntry."Original Doc. No.");
            END;
            IF FINDSET THEN
                REPEAT
                    GSTComponent.GET("GST Component Code");
                    IF GSTComponent."Report View" = GSTComponent."Report View"::CESS THEN
                        CompAmount += Sign * "GST Amount";
                UNTIL NEXT = 0;
        END;
        EXIT(CompAmount);
    end;

    local procedure GetIGSTComponentAmtRevCharge(DetailedGSTLedgerEntry: Record "16419"; CreditAvailed: Boolean; var TotalBaseAmount: Decimal): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        CompAmount: Decimal;
        Sign: Integer;
    begin
        Sign := 1;
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            SETRANGE("GST Component Code", DetailedGSTLedgerEntry."GST Component Code");
            IF (DetailedGSTLedgerEntry."GST Vendor Type" = DetailedGSTLedgerEntry."GST Vendor Type"::Import) AND
               DetailedGSTLedgerEntry."Associated Enterprises"
            THEN
                SETRANGE("Entry Type", "Entry Type"::"Initial Entry")
            ELSE BEGIN
                SETRANGE("Entry Type", "Entry Type"::Application);
                SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                Sign := -1;
            END;
            IF DetailedGSTLedgerEntry."Item Charge Entry" THEN BEGIN
                SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
                SETRANGE("Original Invoice No.", DetailedGSTLedgerEntry."Original Invoice No.");
            END;
            SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
            IF CreditAvailed THEN
                SETRANGE("Credit Availed", TRUE);
            SETRANGE(UnApplied, FALSE);
            IF DetailedGSTLedgerEntry."Reverse Charge" AND
               (DetailedGSTLedgerEntry."Entry Type" = DetailedGSTLedgerEntry."Entry Type"::Application)
            THEN BEGIN
                SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                SETRANGE("Original Doc. No.", DetailedGSTLedgerEntry."Original Doc. No.");
            END;
            IF FINDSET THEN
                REPEAT
                    IF NOT CreditAvailed THEN
                        TotalBaseAmount += Sign * "GST Base Amount";
                    CompAmount += Sign * "GST Amount";
                UNTIL NEXT = 0;
        END;
        EXIT(CompAmount);
    end;

    local procedure GetCessAmtRevCharge(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        CompAmount: Decimal;
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            IF FINDSET THEN
                REPEAT
                    CompAmount += "GST Amount";
                UNTIL NEXT = 0;
        END;
        EXIT(CompAmount);
    end;

    local procedure NonGSTInwardSupply()
    var
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        PurchCrMemoHdr: Record "124";
        PurchCrMemoLine: Record "125";
        Location: Record "14";
        GSTManagement: Codeunit "16401";
    begin
        // Non-GST supply Purchase
        Location.SETRANGE("GST Registration No.", GSTIN);
        IF Location.FINDSET THEN
            REPEAT
                PurchInvHeader.SETFILTER(Structure, '<>%1', '');
                PurchInvHeader.SETRANGE("Location Code", Location.Code);
                PurchInvHeader.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                IF PurchInvHeader.FINDSET THEN
                    REPEAT
                        IF NOT GSTManagement.CheckGSTStrucure(PurchInvHeader.Structure) THEN
                            IF NOT CheckGSTChargeStrucure(PurchInvHeader.Structure) THEN BEGIN
                                PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                                IF PurchInvLine.FINDSET THEN
                                    REPEAT
                                        IF SameStateCode(PurchInvHeader."Location Code", PurchInvHeader."Buy-from Vendor No.") THEN
                                            PurchIntraStateAmount += PurchInvLine."Amount Including VAT"
                                        ELSE
                                            PurchInterStateAmount += PurchInvLine."Amount Including VAT";
                                    UNTIL PurchInvLine.NEXT = 0;
                            END;
                    UNTIL PurchInvHeader.NEXT = 0;

                PurchCrMemoHdr.SETFILTER(Structure, '<>%1', '');
                PurchCrMemoHdr.SETRANGE("Location Code", Location.Code);
                PurchCrMemoHdr.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                IF PurchCrMemoHdr.FINDSET THEN
                    REPEAT
                        IF NOT GSTManagement.CheckGSTStrucure(PurchCrMemoHdr.Structure) THEN
                            IF NOT CheckGSTChargeStrucure(PurchCrMemoHdr.Structure) THEN BEGIN
                                PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHdr."No.");
                                IF PurchCrMemoLine.FINDSET THEN
                                    REPEAT
                                        IF SameStateCode(PurchCrMemoHdr."Location Code", PurchCrMemoHdr."Buy-from Vendor No.") THEN
                                            PurchIntraStateAmount -= PurchCrMemoLine."Amount Including VAT"
                                        ELSE
                                            PurchInterStateAmount -= PurchCrMemoLine."Amount Including VAT";
                                    UNTIL PurchCrMemoLine.NEXT = 0;
                            END;
                    UNTIL PurchCrMemoHdr.NEXT = 0;
            UNTIL Location.NEXT = 0;
    end;

    local procedure SameStateCode(LocationCode: Code[10]; VendorCode: Code[20]): Boolean
    var
        Location: Record "14";
        Vendor: Record "23";
    begin
        IF Location.GET(LocationCode) THEN;
        Vendor.GET(VendorCode);
        IF Location."State Code" = Vendor."State Code" THEN
            EXIT(TRUE);
    end;

    local procedure DetailedGSTExists(): Boolean
    var
        DetailedGSTLedgerEntry: Record "16419";
    begin
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "GST Jurisdiction Type");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETFILTER("Document Type", '%1|%2', "Document Type"::Invoice, "Document Type"::"Credit Memo");
            SETFILTER("GST Vendor Type", '%1|%2', "GST Vendor Type"::Exempted, "GST Vendor Type"::Composite);
            SETRANGE("GST %", 0);
            IF FINDFIRST THEN
                EXIT(TRUE);
        END;
    end;

    local procedure ClearITCValue()
    begin
        IGSTAmountITC := 0;
        CGSTAmountITC := 0;
        SGSTAmountITC := 0;
        CESSAmountITC := 0;
    end;

    local procedure UpdateGSTRate()
    var
        DetailedGSTLedgerEntry: Record "16419";
        DetailedGSTLedgerEntry1: Record "16419";
        DetailedGSTLedgerEntry2: Record "16419";
        GSTComponent: Record "16405";
        GSTPercentage: Decimal;
        LineNo: Integer;
        DocumentNo: Code[20];
    begin
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Document No.", "Document Line No.");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Purchase);
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETFILTER("Document Type", '%1', "Document Type"::Payment);
            SETRANGE(Reversed, FALSE);
            SETRANGE("GST on Advance Payment", TRUE);
            IF FINDSET THEN
                REPEAT
                    IF (DocumentNo <> "Document No.") OR (LineNo <> "Document Line No.") THEN BEGIN
                        GSTPercentage := 0;
                        DetailedGSTLedgerEntry1.SETRANGE("Document No.", "Document No.");
                        DetailedGSTLedgerEntry1.SETRANGE("Document Line No.", "Document Line No.");
                        IF DetailedGSTLedgerEntry1.FINDSET THEN
                            REPEAT
                                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                                IF GSTComponent.FINDFIRST THEN
                                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                        GSTPercentage += DetailedGSTLedgerEntry1."GST %";
                            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;

                        DetailedGSTLedgerEntry2.SETRANGE("Document No.", "Document No.");
                        DetailedGSTLedgerEntry2.SETRANGE("Document Line No.", "Document Line No.");
                        IF DetailedGSTLedgerEntry2.FINDSET THEN
                            REPEAT
                                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry2."GST Component Code");
                                IF GSTComponent.FINDFIRST THEN
                                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                        DetailedGSTLedgerEntry2."GST Rate %" := GSTPercentage;
                                        DetailedGSTLedgerEntry2.MODIFY;
                                    END;
                            UNTIL DetailedGSTLedgerEntry2.NEXT = 0;
                    END;
                    DocumentNo := "Document No.";
                    LineNo := "Document Line No.";
                UNTIL NEXT = 0;
        END;
    end;

    local procedure GetBaseAmountforImportGoods(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        PurchInvLine: Record "123";
        PurchaseLineAmount: Decimal;
    begin
        PurchInvLine.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
        IF PurchInvLine.FINDSET THEN
            REPEAT
                PurchaseLineAmount += PurchInvLine."Line Amount"
            UNTIL PurchInvLine.NEXT = 0;
        EXIT(PurchaseLineAmount);
    end;

    [Scope('Internal')]
    procedure CheckGSTChargeStrucure(StructureCode: Code[10]): Boolean
    var
        StructureDetails: Record "13793";
    begin
        WITH StructureDetails DO BEGIN
            SETRANGE(Code, StructureCode);
            SETRANGE(Type, Type::Charges);
            EXIT(NOT ISEMPTY);
        END;
    end;
}

