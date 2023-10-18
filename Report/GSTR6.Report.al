report 50029 "GSTR 6"
{
    Caption = 'GSTR 6';
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

                MakeExcelBodyCDNR;
                TempExcelBuffer.OnlyCreateBook(CDNRTxt, CDNRTxt, COMPANYNAME, USERID, TRUE);
                TempExcelBuffer.DELETEALL;
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
                        Visible = false;
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
        B2BTxt: Label '3.B2B';
        CDNRTxt: Label '6B CDN';
        GSTINUINTxt: Label 'GSTIN of Supplier';
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
        InvoiceNoRegTxt: Label 'Invoice Number of Reg Receipient';
        BillOfEntryNoTxt: Label 'Bill Of Entry Number';
        BillOfEntryDateTxt: Label 'Bill Of Entry Date';
        BillOfEntryValueTxt: Label 'Bill Of Entry Value';
        GSTAssessableValue: Decimal;
        PurchIntraStateAmount: Decimal;
        PurchInterStateAmount: Decimal;
        ExemptedValue: Decimal;
        FeatureAvlblErr: Label 'This feature will be available in the next release.';
        Status_of_GSTRTxt: Label 'Status of GSTR1/5';
        invoice_StatusTxt: Label 'Invoice Status';
        ActionTxt: Label 'Action';
        Sheet_Validation_ErrorsTxt: Label 'Sheet Validation Errors';
        GST_Portal_Validation_ErrorsTxt: Label ' GST Portal Validation Errors';
        Note_TypeTxt: Label 'Note Type';
        DebitCreditNoteNoTxt: Label 'Debit/Credit Note No.';
        DebitCreditNoteDateTxt: Label 'Debit/Credit Note Date (DD-MM-YYYY)';
        DebitCreditNoteValueTxt: Label 'Debit/Credit Note Value ( Rs )';
        Original_invoice_numberTxt: Label 'Original invoice number';
        Original_invoice_dateTxt: Label 'Original invoice date  (dd-mm-yyyy) ';
        Supply_TypeTxt: Label 'Supply Type';
        Reason_for_issuing_noteTxt: Label 'Reason for issuing note';
        Filing_status_of_GSTR: Label 'Filing status of GSTR1/5';
        Debit_Credit_note_status: Label 'Debit/Credit note status';
        SupplierNameTxt: Label 'Supplier Name';
        recPosPurHead: Record "122";
        DocNoTxt: Label 'Document Number';
        decInvAmt: Decimal;

    [Scope('Internal')]
    procedure MakeExcelHeaderB2B()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplierNameTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DocNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//acxcp211221

        TempExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Supply_TypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//ACX-RK 11082021
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Status_of_GSTRTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(invoice_StatusTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ActionTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Sheet_Validation_ErrorsTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GST_Portal_Validation_ErrorsTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
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
            CALCFIELDS("GSTled Input Service Dist.");
            SETRANGE("GSTled Input Service Dist.", TRUE);//ACX-RK
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            //SETRANGE("Transaction Type","Transaction Type"::Purchase);
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETFILTER("Purchase Invoice Type", '<>%1&<>%2', "Purchase Invoice Type"::"Debit Note", "Purchase Invoice Type"::Supplementary);
            SETFILTER("GST Credit", '<>%1', "GST Credit"::"Non-Availment");
            //SETRANGE("GST Vendor Type","GST Vendor Type"::Registered);
            //SETRANGE(UnApplied,FALSE);
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
                       (GSTPercentage <> "GST %") OR (ITCEligibility <> ITCEligibility1) THEN BEGIN
                        CheckComponentReportView("GST Component Code");
                        ClearVariables;
                        IF State.GET("Location State Code") THEN;
                        IF Vendor.GET("Source No.") THEN; //ACXCP
                        IF GSTComponent.GET("GST Component Code") AND (GSTComponent."Report View" <> GSTComponent."Report View"::CESS) THEN
                            GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF TotalBaseAmount <> 0 THEN BEGIN
                                    TempExcelBuffer.NewRow;
                                    //Vendor GSTIN
                                    TempExcelBuffer.AddColumn(
                                      "Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                    //Supplier Name
                                    TempExcelBuffer.AddColumn(
                                     Vendor.Name, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                    //Posting Date
                                    recPosPurHead.RESET();
                                    recPosPurHead.SETRANGE("No.", "Document No.");
                                    IF recPosPurHead.FINDFIRST THEN;
                                    TempExcelBuffer.AddColumn(
                                      recPosPurHead."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//acxcp211221
                                    TempExcelBuffer.AddColumn(
                                      recPosPurHead."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                    /*
                                    IF "Original Doc. Type" = "Original Doc. Type"::"Transfer Receipt" THEN
                                      TempExcelBuffer.AddColumn("Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Date)
                                    ELSE
                                      TempExcelBuffer.AddColumn(
                                        GetDocumentDate("Transaction No."),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Date);
                                    IF "Reverse Charge" THEN
                                      TempExcelBuffer.AddColumn(
                                        GetInvoiceValue("Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                        FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number)
                                    ELSE
                                      IF "Original Doc. Type" = "Original Doc. Type"::"Transfer Receipt" THEN
                                        TempExcelBuffer.AddColumn(
                                          GetTransferReceiptValue("Original Doc. No."),FALSE,'',FALSE,FALSE,FALSE,'',
                                          TempExcelBuffer."Cell Type"::Number)
                                      ELSE
                                        TempExcelBuffer.AddColumn(
                                          GetInvoiceValue("Transaction No."),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                      */
                                    //Document No.
                                    TempExcelBuffer.AddColumn(
                                      "External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    /*
                                  IF "Reverse Charge" THEN
                                    TempExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text)
                                  ELSE
                                    TempExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                    */
                                    //Invoice Value
                                    //ACXCP211221 +
                                    //TempExcelBuffer.AddColumn(
                                    // decInvAmt,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn((TotalBaseAmount + IGSTAmount + CGSTAmount + SGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);

                                    //ACXCP211221 -

                                    // TempExcelBuffer.AddColumn(
                                    // "Amount to Customer/Vendor",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                    //Place of Supply
                                    TempExcelBuffer.AddColumn(
                                     State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                    //GST Jurisdiction
                                    TempExcelBuffer.AddColumn(
                                     "GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                    //TempExcelBuffer.AddColumn('Regular',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(GSTPer, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(IGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(SGSTAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    /*
                                    TempExcelBuffer.AddColumn(CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(ITCEligibility1,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                    IF ITCEligibility1 = 'Ineligible' THEN
                                      ClearITCValue;
                                    TempExcelBuffer.AddColumn(IGSTAmountITC,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CGSTAmountITC,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(SGSTAmountITC,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(CESSAmountITC,FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                    */
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

    local procedure MakeExcelHeaderCDNR()
    begin
        TempExcelBuffer.NewRow;
        TempExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplierNameTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Note_TypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn(RefundVoucherNoTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DebitCreditNoteNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DebitCreditNoteDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DebitCreditNoteValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn(RefundVoucherDateTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Original_invoice_numberTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Original_invoice_dateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //pExcelBuffer.AddColumn(Supply_TypeTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn(InvVoucherNoTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn(InvVoucherDateTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn(PreGSTTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn(DocumentTypeTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SupplyTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReasonForIssuingNoteTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.AddColumn(RefundVoucherValueTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IntegratedTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CentralTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(StateTaxPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CessPaidTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Filing_status_of_GSTR, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Debit_Credit_note_status, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ActionTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Sheet_Validation_ErrorsTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GST_Portal_Validation_ErrorsTxt, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        /*
        TempExcelBuffer.AddColumn(EligibilityITCTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCIntegratedTaxTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCentralTaxTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCStateTaxTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvailedITCCessTxt,FALSE,'',TRUE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        */

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
            //SETRANGE("Transaction Type","Transaction Type"::Purchase);
            CALCFIELDS("GSTled Input Service Dist.");
            SETRANGE("GSTled Input Service Dist.", TRUE);
            SETFILTER("Document Type", '<>%1', "Document Type"::Invoice);
            //SETFILTER(
            //"GST Vendor Type",'%1|%2|%3',"GST Vendor Type"::Import,"GST Vendor Type"::Registered,"GST Vendor Type"::SEZ);
            //SETRANGE(UnApplied,FALSE);
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
                                        //Buyer Registration No.
                                        TempExcelBuffer.AddColumn(
                                          "Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        //Suplier Name
                                        TempExcelBuffer.AddColumn(Vendor.Name, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//ACXCP_020821
                                                                                                                                                      //Note Type
                                        IF "Original Doc. Type" = "Original Doc. Type"::"Credit Memo" THEN
                                            TempExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text)
                                        ELSE
                                            TempExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        //Vendor Invoice No.
                                        TempExcelBuffer.AddColumn("External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Posting Date
                                        TempExcelBuffer.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Debit/Credit Note Value ( ? )
                                        TempExcelBuffer.AddColumn(ABS("GST Base Amount"), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Original Invoice No.
                                        TempExcelBuffer.AddColumn("Original Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Original Invoice Date
                                        TempExcelBuffer.AddColumn("Original Invoice Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Place of Supply
                                        TempExcelBuffer.AddColumn(State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Supply type
                                        TempExcelBuffer.AddColumn("GST Jurisdiction Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

                                        //Reason for Issuing Note
                                        TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                        /*
                                        TempExcelBuffer.AddColumn(
                                          GetDocumentDate("Transaction No."),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Date);
                                        IF "Document Type" IN ["Document Type"::"Credit Memo","Document Type"::Invoice] THEN BEGIN
                                          TempExcelBuffer.AddColumn(
                                            "Original Invoice No.",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                          TempExcelBuffer.AddColumn(
                                            "Original Invoice Date",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Date);
                                        END;
                                        IF "Document Type" = "Document Type"::Refund THEN BEGIN
                                          TempExcelBuffer.AddColumn(
                                            "Original Adv. Pmt Doc. No.",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                          TempExcelBuffer.AddColumn(
                                            "Original Adv. Pmt Doc. Date",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Date);
                                        END;
                                        IF CheckPreGST("Document Type","Original Invoice No.","Document No.","Original Adv. Pmt Doc. No.") THEN
                                          TempExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text)
                                        ELSE
                                          TempExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                        IF "Document Type" = "Document Type"::"Credit Memo" THEN
                                          TempExcelBuffer.AddColumn('C',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                        IF "Document Type" = "Document Type"::Invoice THEN
                                          TempExcelBuffer.AddColumn('D',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                        IF "Document Type" = "Document Type"::Refund THEN
                                          TempExcelBuffer.AddColumn('R',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn("GST Reason Type",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(
                                          "GST Jurisdiction Type",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                                        IF "Reverse Charge" THEN
                                          IF "Document Type" IN ["Document Type"::"Credit Memo","Document Type"::Refund] THEN
                                            TempExcelBuffer.AddColumn(
                                              GetInvoiceValue("Transaction No.") - GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                              FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number)
                                          ELSE
                                            TempExcelBuffer.AddColumn(
                                              GetInvoiceValue("Transaction No.") + GetCessAmtRevCharge(DetailedGSTLedgerEntry),
                                              FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number)
                                        ELSE
                                          TempExcelBuffer.AddColumn(
                                            GetInvoiceValue("Transaction No."),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                        */

                                        TempExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(
                                          ABS(TotalBaseAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(IGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(SGSTAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CESSAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ITCEligibility1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                        /*
                                        IF ITCEligibility1 = 'Ineligible' THEN
                                          ClearITCValue;
                                        TempExcelBuffer.AddColumn(ABS(IGSTAmountITC),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CGSTAmountITC),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(SGSTAmountITC),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn(ABS(CESSAmountITC),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                                        */
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
                                CGSTAmount += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, FALSE, TotalBaseAmount);
                                CGSTAmountITC += GetITCComponentAmtRevCharge(DetailedGSTLedgerEntry1, TRUE, TotalBaseAmount);
                            END;
                        GSTComponent."Report View"::"SGST / UTGST":
                            IF NOT "Reverse Charge" THEN BEGIN
                                SGSTAmount += "GST Amount";
                                SGSTAmountITC += "GST Amount";
                            END ELSE BEGIN
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

    local procedure GetInvAmt(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        recPurInvH: Record "123";
        GSTAmountValue: Decimal;
    begin
        recPurInvH.RESET;
        recPurInvH.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
        IF recPurInvH.FINDSET THEN
            REPEAT
                GSTAmountValue += (DetailedGSTLedgerEntry."GST Base Amount" + DetailedGSTLedgerEntry."GST Amount");
            UNTIL recPurInvH.NEXT = 0;
        EXIT(GSTAmountValue);
    end;
}

