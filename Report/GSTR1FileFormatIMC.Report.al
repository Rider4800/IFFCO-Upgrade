report 50026 "GSTR-1 File Format-IMC"
{
    Caption = 'GSTR-1 File Format';
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
                ExcelBuffer.OnlyCreateBook(B2BTxt, B2BTxt, COMPANYNAME, USERID, FALSE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyB2BA;
                ExcelBuffer.OnlyCreateBook(B2BATxt, B2BATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyB2CL;
                ExcelBuffer.OnlyCreateBook(B2CLTxt, B2CLTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyB2cla;
                ExcelBuffer.OnlyCreateBook(B2CLATxt, B2CLATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyB2CS;
                ExcelBuffer.OnlyCreateBook(B2CSTxt, B2CSTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyB2csa;
                ExcelBuffer.OnlyCreateBook(B2CSATxt, B2CSATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyCDNR;
                ExcelBuffer.OnlyCreateBook(CDNRTxt, CDNRTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodycdnra;
                ExcelBuffer.OnlyCreateBook(CDNRATxt, CDNRATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyCDNUR;
                ExcelBuffer.OnlyCreateBook(CDNURTxt, CDNURTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyCDnura;
                ExcelBuffer.OnlyCreateBook(CDNURATxt, CDNURATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyEXP;
                ExcelBuffer.OnlyCreateBook(EXPTxt, EXPTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyexpa;
                ExcelBuffer.OnlyCreateBook(EXPATxt, EXPATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyAT;
                ExcelBuffer.OnlyCreateBook(ATTxt, ATTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyATA;
                ExcelBuffer.OnlyCreateBook(ATATxt, ATATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyATADJ;
                ExcelBuffer.OnlyCreateBook(ATADJTxt, ATADJTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyAtadja;
                ExcelBuffer.OnlyCreateBook(ATADJATxt, ATADJATxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyEXEMP;
                ExcelBuffer.OnlyCreateBook(EXEMPTxt, EXEMPTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;
                /*
                MakeExcelBodycdnurc;
                ExcelBuffer.OnlyCreateBook(CDNURCTxt,CDNURCTxt,COMPANYNAME,USERID,TRUE);
                ExcelBuffer.DELETEALL;
                */

                MakeExcelBodyHSN;
                ExcelBuffer.OnlyCreateBook(HSNTxt, HSNTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                MakeExcelBodyDocs;
                ExcelBuffer.OnlyCreateBook(DocsTxt, DocsTxt, COMPANYNAME, USERID, TRUE);
                ExcelBuffer.DELETEALL;

                /*
                CASE FileFormat OF
                  FileFormat::" ":
                    ERROR(FileformatErr);
                  FileFormat::B2B:
                    BEGIN
                      MakeExcelBodyB2B;
                      ExcelBuffer.OnlyCreateBook(B2BTxt,B2BTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::B2CL:
                    BEGIN
                      MakeExcelBodyB2CL;
                      ExcelBuffer.OnlyCreateBook(B2CLTxt,B2CLTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::B2CS:
                    BEGIN
                      MakeExcelBodyB2CS;
                      ExcelBuffer.OnlyCreateBook(B2CSTxt,B2CSTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::AT:
                    BEGIN
                      MakeExcelBodyAT;
                      ExcelBuffer.OnlyCreateBook(ATTxt,ATTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::ATADJ:
                    BEGIN
                      MakeExcelBodyATADJ;
                      ExcelBuffer.OnlyCreateBook(ATADJTxt,ATADJTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::CDNR:
                    BEGIN
                      MakeExcelBodyCDNR;
                      ExcelBuffer.OnlyCreateBook(CDNRTxt,CDNRTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::CDNUR:
                    BEGIN
                      MakeExcelBodyCDNUR;
                      ExcelBuffer.OnlyCreateBook(CDNURTxt,CDNURTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::EXP:
                    BEGIN
                      MakeExcelBodyEXP;
                      ExcelBuffer.OnlyCreateBook(EXPTxt,EXPTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::HSN:
                    BEGIN
                      MakeExcelBodyHSN;
                      ExcelBuffer.OnlyCreateBook(HSNTxt,HSNTxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::ATA:
                    BEGIN
                      MakeExcelBodyATA;
                      ExcelBuffer.OnlyCreateBook(ATATxt,ATATxt,COMPANYNAME,USERID,FALSE);
                    END;
                  FileFormat::EXEMP:
                    BEGIN
                      MakeExcelBodyEXEMP;
                      ExcelBuffer.OnlyCreateBook(EXEMPTxt,EXEMPTxt,COMPANYNAME,USERID,FALSE);
                    END;
                END;
                */

            end;

            trigger OnPreDataItem()
            begin
                ExcelBuffer.DELETEALL;
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
        ExcelBuffer.OnlyOpenExcel;
    end;

    var
        ExcelBuffer: Record "370" temporary;
        TempDetailedGSTLedgerEntry: Record "16419" temporary;
        Customer: Record "18";
        GSTIN: Code[15];
        Date: Date;
        Month: Integer;
        Year: Integer;
        CESSAmount: Decimal;
        B2BTxt: Label 'b2b';
        B2BATxt: Label 'b2ba';
        B2CLTxt: Label 'b2cl';
        DocsTxt: Label 'Docs';
        B2CLATxt: Label 'B2cla';
        B2CSTxt: Label 'b2cs';
        B2CSATxt: Label 'B2csa';
        CDNRTxt: Label 'cdnr';
        CDNRATxt: Label 'cdnra';
        ATADJATxt: Label 'Atadja';
        EXPATxt: Label 'Expa';
        CDNURTxt: Label 'cdnur';
        CDNURCTxt: Label 'Cdnurc';
        CDNURATxt: Label 'Cdnura';
        ATTxt: Label 'at';
        ATADJTxt: Label 'atadj';
        EXPTxt: Label 'exp';
        HSNTxt: Label 'hsn';
        ATATxt: Label 'ata';
        EXEMPTxt: Label 'exemp';
        GSTINUINTxt: Label 'GSTIN/UIN of Recipient';
        InvoiceNoTxt: Label 'Invoice Number';
        InvoiceDateTxt: Label 'Invoice Date';
        InvoiceValueTxt: Label 'Invoice Value';
        PlaceOfSupplyTxt: Label 'Place Of Supply';
        ReverseChargeTxt: Label 'Reverse Charge';
        ECommGSTINTxt: Label 'E-Commerce GSTIN';
        HSNSACofSupplyTxt: Label 'HSN/SAC of Supply';
        TaxableValueTxt: Label 'Taxable Value';
        IGSTAmountTxt: Label 'IGST Amount';
        CGSTAmountTxt: Label 'CGST Amount';
        SGSTAmountTxt: Label 'SGST Amount';
        CESSAmountTxt: Label 'CESS Amount';
        TypeTxt: Label 'Type';
        DocumentTypeTxt: Label 'Document Type';
        DebitNoteNoTxt: Label 'Note/Refund Voucher Number';
        DebitNoteDateTxt: Label 'Note/Refund Voucher Date';
        OtherECommTxt: Label 'oe';
        ExportTypeTxt: Label 'Export Type';
        PortCodeTxt: Label 'Port Code';
        ShipBillNoTxt: Label 'Shipping Bill Number';
        ShipBillDateTxt: Label 'Shipping Bill Date';
        WOPAYTxt: Label 'wopay';
        WPAYTxt: Label 'wpay';
        OriginalInvNoTxt: Label 'Invoice/Advance Receipt Number';
        OriginalInvDateTxt: Label 'Invoice/Advance Receipt date';
        InvoiceTypeTxt: Label 'Invoice Type';
        RateTxt: Label 'Rate';
        RegularTxt: Label 'Regular';
        EXPWOPayTxt: Label 'expwop';
        EXPWPayTxt: Label 'expwp';
        DeemedExportTxt: Label 'Deemed Export';
        RefundVoucherValueTxt: Label 'Note/Refund Voucher Value';
        PreGSTTxt: Label 'Pre GST';
        URTypeTxt: Label 'UR Type';
        GrossAdvanceRcvdTxt: Label 'Gross Advance Received';
        TotalBaseAmount: Decimal;
        TotalGSTAmount: Decimal;
        CESSAmountApp: Decimal;
        TotalBaseAmountApp: Decimal;
        GSTPer: Decimal;
        GSTPerAmend: Decimal;
        FileFormat: Option " ",B2B,B2CL,B2CS,EXP,CDNUR,CDNR,ATADJ,AT,ATA,HSN,EXEMP;
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
        SEZWOPayTxt: Label 'SEZ Without Pay';
        SEZWPayTxt: Label 'SEZ With Pay';
        FinancialYearTxt: Label 'Financial Year';
        OriginalMonthTxt: Label 'Original Month';
        OriginalPlaceOfSupplyTxt: Label 'Original Place of Supply';
        TotalBaseAmtAmendment: Decimal;
        CESSAmountAmendment: Decimal;
        CESSAmountRefund: Decimal;
        TotalBaseAmountRefund: Decimal;
        ReceiverTxt: Label 'Receiver Name';
        TaxTxt: Label 'Applicable % of Tax Rate';
        DespTxt: Label 'Desciption';
        NilTxt: Label 'Nil Rated Supplies';
        ExmpTxt: Label 'Exempted(other than nil rated/non GST supply)';
        NonGSTxt: Label 'Non-GST Supplies';
        InterRegTxt: Label 'Inter-State supplies to registered persons';
        IntraRegTxt: Label 'Intra-State supplies to registered persons';
        InterUnRegTxt: Label 'Inter-State supplies to unregistered persons';
        IntraUnRegTxt: Label 'Intra-State supplies to unregistered persons';
        InterRegAmount: Decimal;
        IntraRegAmount: Decimal;
        InterUnRegAmount: Decimal;
        IntraUnRegAmount: Decimal;
        InterExmpRegAmount: Decimal;
        IntraExmpRegAmount: Decimal;
        InterExmpUnRegAmount: Decimal;
        IntraExmpUnRegAmount: Decimal;
        InterNonGSTRegAmount: Decimal;
        IntraNonGSTRegAmount: Decimal;
        InterNonGSTUnRegAmount: Decimal;
        IntraNonGSTUnRegAmount: Decimal;

    [Scope('Internal')]
    procedure MakeExcelHeaderB2B()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ReceiverTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ReverseChargeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ECommGSTINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2B()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
        recCompInfo: Record "79";
    begin
        MakeExcelHeaderB2B;
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type", '%1', DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        //DetailedGSTLedgerEntry.SETFILTER("Sales Invoice Type",'<>%1',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note");
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type", '<>%1|<>%2', DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DetailedGSTLedgerEntry."Sales Invoice Type" <> DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note" THEN BEGIN
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
                        IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                           DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                           DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                           DetailedGSTLedgerEntry."GST Customer Type"::Registered])
                        THEN BEGIN
                            CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                            ClearVariables;
                            IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                            GetComponentValues(DetailedGSTLedgerEntry);

                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Location  Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN BEGIN
                                        ExcelBuffer.AddColumn(
                                          Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    END ELSE BEGIN
                                        //acxcp_020821
                                        recCompInfo.GET;
                                        //  ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);

                                        ExcelBuffer.AddColumn(recCompInfo.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                        //acxcp_020821
                                    END;
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                                    THEN BEGIN
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                        ExcelBuffer.AddColumn(
                                          GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                                          FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    END ELSE BEGIN
                                        ExcelBuffer.AddColumn(
                                          GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."), FALSE, '', FALSE, FALSE,
                                          FALSE, '', ExcelBuffer."Cell Type"::Date);
                                        IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                                            ExcelBuffer.AddColumn(
                                              GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                                              FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                        ELSE
                                            ExcelBuffer.AddColumn(
                                              GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type"),
                                              FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    END;
                                    ExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE,
                                      FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                                        ExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceType(DetailedGSTLedgerEntry), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.", FALSE, '', FALSE, FALSE,
                                      FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                        END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderB2CL()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ECommGSTINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2CL()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        CustLedgerEntry: Record "21";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderB2CL;
        DetailedGSTLedgerEntry.SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type", '%1', DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
        DetailedGSTLedgerEntry.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                    CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                    ClearVariables;
                    IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                    GetComponentValues(DetailedGSTLedgerEntry);

                    CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                    IF CustLedgerEntry.FINDFIRST THEN
                        CustLedgerEntry.CALCFIELDS("Amount (LCY)");

                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF CustLedgerEntry."Amount (LCY)" >= 250000 THEN BEGIN
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                ELSE
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type"),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(
                                  State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                  FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.", FALSE, '',
                                  FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            END;
                END;
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        GSTPercentage := DetailedGSTLedgerEntry."GST %";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderB2CS()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(TypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ECommGSTINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2CS()
    var
        DetailedGSTLedgerEntry: Record "16419";
        CustLedgerEntry: Record "21";
        GSTComponent: Record "16405";
        State: Record "13762";
        BuyerSellerStateCode: Code[10];
        GSTPercentage: Decimal;
        ECommCode: Code[15];
    begin
        MakeExcelHeaderB2CS;
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Buyer/Seller State Code", "GST %", "e-Comm. Operator GST Reg. No.");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETFILTER(
         "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
        DetailedGSTLedgerEntry.SETRANGE("GST Customer Type", DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF (BuyerSellerStateCode <> DetailedGSTLedgerEntry."Buyer/Seller State Code") OR
                   (GSTPercentage <> DetailedGSTLedgerEntry."GST %") OR
                   (ECommCode <> DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.")
                THEN BEGIN
                    CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                    ClearVariables;
                    GetGSTPlaceWiseValues2(DetailedGSTLedgerEntry);
                    IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;

                    CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                    IF CustLedgerEntry.FINDFIRST THEN
                        CustLedgerEntry.CALCFIELDS("Amount (LCY)");

                    IF ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice) OR (DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo")) AND
                       (((DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate) AND
                         (CustLedgerEntry."Amount (LCY)" <= 250000)) OR
                        (DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate))
                    THEN BEGIN
                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                ExcelBuffer.NewRow;
                                IF DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No." <> '' THEN
                                    ExcelBuffer.AddColumn('E', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    ExcelBuffer.AddColumn(UPPERCASE(OtherECommTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  State."State Code (GST Reg. No.)" + '-' + State.Description,
                                  FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.", FALSE, '',
                                  FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            END;
                    END;
                END;
                IF ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice) OR (DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo")) THEN BEGIN
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            BuyerSellerStateCode := DetailedGSTLedgerEntry."Buyer/Seller State Code";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                            ECommCode := DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.";
                        END;
                END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderCDNR()
    begin
        // ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ReceiverTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(OriginalInvNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(OriginalInvDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DebitNoteNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DebitNoteDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RefundVoucherValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PreGSTTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyCDNR()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        ReferenceInvoiceNo: Record "16470";
        CustLedgerEntry: Record "21";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
        PostingDate: Date;
    begin
        MakeExcelHeaderCDNR;
        DetailedGSTLedgerEntry.SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2|%3', DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
          DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::Refund);
        DetailedGSTLedgerEntry.SETFILTER(
          "GST Customer Type", '%1|%2|%3|%4', DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
          DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
          DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
          DetailedGSTLedgerEntry."GST Customer Type"::Registered);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                    CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                    ClearVariables;
                    IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                    GetComponentValues(DetailedGSTLedgerEntry);

                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF (DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo") OR
                               ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund) AND
                                (NOT DetailedGSTLedgerEntry."Adv. Pmt. Adjustment")) OR
                               ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice) AND
                                (DetailedGSTLedgerEntry."Sales Invoice Type" IN [DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
                                                                                 DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary]))
                            THEN BEGIN
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                                    ExcelBuffer.AddColumn(
                                      Customer.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                IF (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
                                                                               DetailedGSTLedgerEntry."Document Type"::Invoice])
                                THEN BEGIN
                                    ReferenceInvoiceNo.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
                                    ReferenceInvoiceNo.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
                                    IF ReferenceInvoiceNo.FINDFIRST THEN BEGIN
                                        CustLedgerEntry.SETRANGE("Document No.", ReferenceInvoiceNo."Reference Invoice Nos.");
                                        IF CustLedgerEntry.FINDFIRST THEN
                                            PostingDate := CustLedgerEntry."Posting Date";
                                        ExcelBuffer.AddColumn(
                                          ReferenceInvoiceNo."Reference Invoice Nos.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(
                                          PostingDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    END ELSE BEGIN
                                        CustLedgerEntry.SETRANGE("Document No.", ReferenceInvoiceNo."Reference Invoice Nos.");
                                        IF CustLedgerEntry.FINDFIRST THEN
                                            PostingDate := CustLedgerEntry."Posting Date";
                                        ExcelBuffer.AddColumn(
                                          'NA', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(
                                          0D, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    END;
                                END;
                                IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN BEGIN
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.", FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Original Adv. Pmt Doc. Date", FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                END;
                                //
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo" THEN
                                    ExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice THEN
                                        ExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN
                                            ExcelBuffer.AddColumn('R', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                  FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                IF DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::Invoice,
                                                                              DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]
                                THEN
                                    IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                                        ExcelBuffer.AddColumn(
                                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                                          FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                    ELSE
                                        ExcelBuffer.AddColumn(
                                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type"),
                                          FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                ELSE
                                    ExcelBuffer.AddColumn(
                                      TotalBaseAmount + TotalGSTAmount + CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                IF CheckPreGST(
                                     DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Invoice No.",
                                     DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.")
                                THEN
                                    ExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    ExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            END;
                END;
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        GSTPercentage := DetailedGSTLedgerEntry."GST %";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderCDNUR()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(URTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DebitNoteNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DebitNoteDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(OriginalInvNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(OriginalInvDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RefundVoucherValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PreGSTTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyCDNUR()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        CustLedgerEntry: Record "21";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
        UnRegCustomer: Boolean;
        ExportCustomer: Boolean;
    begin
        MakeExcelHeaderCDNUR;
        DetailedGSTLedgerEntry.SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2|%3', DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
          DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::Refund);
        DetailedGSTLedgerEntry.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate);
        DetailedGSTLedgerEntry.SETFILTER(
          "GST Customer Type", '%1|%2', DetailedGSTLedgerEntry."GST Customer Type"::Export,
          DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                UnRegCustomer := FALSE;
                ExportCustomer := FALSE;
                IF NOT (DetailedGSTLedgerEntry."GST Without Payment of Duty" OR DetailedGSTLedgerEntry."GST Exempted Goods") THEN BEGIN
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        CustLedgerEntry.RESET;
                        CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                        IF CustLedgerEntry.FINDFIRST THEN
                            CustLedgerEntry.CALCFIELDS("Amount (LCY)");

                        IF ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Unregistered) AND
                            (ABS(CustLedgerEntry."Amount (LCY)") >= 250000) AND
                            ((DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]) OR
                             (DetailedGSTLedgerEntry."Sales Invoice Type" IN [DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
                                                                              DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary])))
                        THEN
                            UnRegCustomer := TRUE;

                        IF ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Export) AND
                            ((DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]) OR
                             (DetailedGSTLedgerEntry."Sales Invoice Type" IN [DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
                                                                              DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary])))
                        THEN
                            ExportCustomer := TRUE;

                        IF ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund) AND
                            (NOT DetailedGSTLedgerEntry."Adv. Pmt. Adjustment")) OR ExportCustomer OR UnRegCustomer
                        THEN BEGIN
                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                    MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry, State);
                        END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                END ELSE BEGIN
                    IF DocumentNo <> DetailedGSTLedgerEntry."Document No." THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        CustLedgerEntry.RESET;
                        CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                        IF CustLedgerEntry.FINDFIRST THEN
                            CustLedgerEntry.CALCFIELDS("Amount (LCY)");

                        IF ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Unregistered) AND
                            (ABS(CustLedgerEntry."Amount (LCY)") >= 250000) AND
                            ((DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]) OR
                             (DetailedGSTLedgerEntry."Sales Invoice Type" IN [DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
                                                                              DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary])))
                        THEN
                            UnRegCustomer := TRUE;

                        IF ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Export) AND
                            ((DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]) OR
                             (DetailedGSTLedgerEntry."Sales Invoice Type" IN [DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
                                                                              DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary])))
                        THEN
                            ExportCustomer := TRUE;

                        IF ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund) AND
                            (NOT DetailedGSTLedgerEntry."Adv. Pmt. Adjustment")) OR ExportCustomer OR UnRegCustomer
                        THEN BEGIN
                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                    MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry, State);
                        END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry: Record "16419"; State: Record "13762")
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(
          GetURType(DetailedGSTLedgerEntry), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(
          DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(
          DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo" THEN
            ExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        ELSE
            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice THEN
                ExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            ELSE
                IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN
                    ExcelBuffer.AddColumn('R', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(
          DetailedGSTLedgerEntry."Original Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(
          DetailedGSTLedgerEntry."Original Invoice Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(
          State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
          FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        IF DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
                                                      DetailedGSTLedgerEntry."Document Type"::Invoice]
        THEN
            IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                ExcelBuffer.AddColumn(
                  GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                  FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
            ELSE
                ExcelBuffer.AddColumn(
                  GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type"),
                  FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
        ELSE
            ExcelBuffer.AddColumn(
              TotalBaseAmount + TotalGSTAmount + CESSAmount,
              FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        IF CheckPreGST(
             DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Invoice No.",
             DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.")
        THEN
            ExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
        ELSE
            ExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelHeaderAT()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrossAdvanceRcvdTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyAT()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        BuyerSellerStateCode: Code[10];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderAT;
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETFILTER("Document Type", '%1', DetailedGSTLedgerEntry."Document Type"::Payment);
        DetailedGSTLedgerEntry.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry.SETRANGE("GST on Advance Payment", TRUE);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF (BuyerSellerStateCode <> DetailedGSTLedgerEntry."Buyer/Seller State Code") OR
                   (GSTPercentage <> DetailedGSTLedgerEntry."GST %")
                THEN BEGIN
                    CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                    ClearVariables;
                    IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;

                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            GetComponentValueAdvPaymentAdjustment(DetailedGSTLedgerEntry, State);
                END;
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                        BuyerSellerStateCode := DetailedGSTLedgerEntry."Buyer/Seller State Code";
                        GSTPercentage := DetailedGSTLedgerEntry."GST %";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderATADJ()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrossAdvanceRcvdTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyATADJ()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        BuyerSellerStateCode: Code[10];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderATADJ;
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::Application);
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE(UnApplied, FALSE);
        DetailedGSTLedgerEntry.SETRANGE(Reversed, FALSE);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF CheckATADJ(DetailedGSTLedgerEntry."Original Doc. No.") THEN
                    IF (BuyerSellerStateCode <> DetailedGSTLedgerEntry."Buyer/Seller State Code") OR
                       (GSTPercentage <> DetailedGSTLedgerEntry."GST %")
                    THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;

                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                GetComponentValueAdvPaymentATADJ(DetailedGSTLedgerEntry);

                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(
                                  State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE,
                                  FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(
                                  TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            END;
                    END;
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                        BuyerSellerStateCode := DetailedGSTLedgerEntry."Buyer/Seller State Code";
                        GSTPercentage := DetailedGSTLedgerEntry."GST %";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderEXP()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(ExportTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PortCodeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ShipBillNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ShipBillDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyEXP()
    var
        DetailedGSTLedgerEntry: Record "16419";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderEXP;
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETFILTER("GST Customer Type", '%1', DetailedGSTLedgerEntry."GST Customer Type"::Export);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF NOT (DetailedGSTLedgerEntry."GST Without Payment of Duty" OR DetailedGSTLedgerEntry."GST Exempted Goods") THEN BEGIN
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                ExcelBuffer.NewRow;
                                IF GetGSTPaymentOfDuty(DetailedGSTLedgerEntry."Document No.") THEN
                                    ExcelBuffer.AddColumn(UPPERCASE(WOPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    ExcelBuffer.AddColumn(UPPERCASE(WPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                ELSE
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type"),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(
                                  GetExitPoint(DetailedGSTLedgerEntry."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Bill Of Export No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Bill Of Export Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                END ELSE BEGIN
                    IF DocumentNo <> DetailedGSTLedgerEntry."Document No." THEN BEGIN
                        ClearVariables;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                ExcelBuffer.NewRow;
                                IF GetGSTPaymentOfDuty(DetailedGSTLedgerEntry."Document No.") THEN
                                    ExcelBuffer.AddColumn(UPPERCASE(WOPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                ELSE
                                    ExcelBuffer.AddColumn(UPPERCASE(WPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                ELSE
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type"),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(
                                  GetExitPoint(DetailedGSTLedgerEntry."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Bill Of Export No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  DetailedGSTLedgerEntry."Bill Of Export Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure MakeExcelHeaderHSN()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(HSNSACofSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(DescTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(UPPERCASE(UQCTxt), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TotalQtyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TotalValTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(IGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyHSN()
    var
        DetailedGSTLedgerEntry: Record "16419";
        UnitofMeasure: Record "204";
        HsnSac: Record "16411";
        HSNCode: Code[8];
        UOMCode: Code[10];
    begin
        MakeExcelHeaderHSN;
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Entry Type", "Transaction Type",
              "HSN/SAC Code", UOM, "Document No.", "Document Line No.", "Original Invoice No.",
              "Item Charge Assgn. Line No.");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETRANGE("Transaction Type", "Transaction Type"::Sales);
            SETFILTER(
              "Document Type", '%1|%2', "Document Type"::Invoice, "Document Type"::"Credit Memo");
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
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn("HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        HsnSac.GET("GST Group Code", "HSN/SAC Code");
                        ExcelBuffer.AddColumn(HsnSac.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        IF UnitofMeasure.GET(UOM) THEN;
                        ExcelBuffer.AddColumn(UnitofMeasure."GST Reporting UQC", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(-HSNQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(-(GSTBaseAmount + HSNIGSTAmt + HSNCGSTAmt + HSNSGSTAmt + HSNCessAmt),
                          FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(-GSTBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(-HSNIGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(-HSNCGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(-HSNSGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(-HSNCessAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    END;
                    HSNCode := "HSN/SAC Code";
                    UOMCode := UOM;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure MakeExcelHeaderATA()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(FinancialYearTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(OriginalMonthTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(OriginalPlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GrossAdvanceRcvdTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyATA()
    var
        DetailedGSTLedgerEntry: Record "16419";
        GSTComponent: Record "16405";
        State: Record "13762";
        BuyerSellerStateCode: Code[10];
        GSTPercentage: Decimal;
        MonthATA: Integer;
        MonthATA1: Integer;
        YearATA: Integer;
        YearATA1: Integer;
    begin
        MakeExcelHeaderATA;
        MonthATA := 0;
        YearATA := 0;
        CLEAR(TempDetailedGSTLedgerEntry);
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETCURRENTKEY("Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
            SETRANGE("Location  Reg. No.", GSTIN);
            SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Transaction Type", "Transaction Type"::Sales);
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETRANGE("Document Type", "Document Type"::Payment);
            SETRANGE(Reversed, FALSE);
            SETRANGE("GST on Advance Payment", TRUE);
            SETRANGE("Adv. Pmt. Adjustment", TRUE);
            IF FINDSET THEN
                REPEAT
                    IF "Posting Date" > "Original Adv. Pmt Doc. Date" THEN BEGIN
                        MonthATA1 := DATE2DMY("Original Adv. Pmt Doc. Date", 2);
                        YearATA1 := DATE2DMY("Original Adv. Pmt Doc. Date", 3);
                        IF (MonthATA <> MonthATA1) OR (YearATA <> YearATA1) OR (BuyerSellerStateCode <> "Buyer/Seller State Code") OR
                           (GSTPercentage <> "GST %")
                        THEN BEGIN
                            CheckComponentReportView("GST Component Code");
                            ClearVariables;
                            IF State.GET("Buyer/Seller State Code") THEN;

                            GSTComponent.SETRANGE(Code, "GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                    // Get Advance Payment Details
                                    GetAdvPaymentValueATA(DetailedGSTLedgerEntry, State);
                                    // Get Amendment Details
                                    IF NOT CheckSameGSTPerAmendment(DetailedGSTLedgerEntry, MonthATA1, YearATA1) THEN BEGIN
                                        TotalBaseAmtAmendment := 0;
                                        CESSAmountAmendment := 0;
                                        GetAmendedValueAdvPaymentATA(DetailedGSTLedgerEntry, MonthATA1, YearATA1);
                                        IF TotalBaseAmtAmendment <> 0 THEN BEGIN
                                            ExcelBuffer.NewRow;
                                            ExcelBuffer.AddColumn(
                                              GetFinancialYear("Original Adv. Pmt Doc. Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(GetMonthValue(MonthATA1), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(
                                              State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                              FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                            ExcelBuffer.AddColumn(GSTPerAmend, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                            ExcelBuffer.AddColumn(TotalBaseAmtAmendment, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                            ExcelBuffer.AddColumn(CESSAmountAmendment, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                        END;
                                    END;
                                END;
                        END;
                        GSTComponent.SETRANGE(Code, "GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                MonthATA := MonthATA1;
                                YearATA := YearATA1;
                                BuyerSellerStateCode := "Buyer/Seller State Code";
                                GSTPercentage := "GST %";
                            END;
                    END;
                UNTIL NEXT = 0;
        END;
    end;

    local procedure ClearVariables()
    begin
        TotalBaseAmount := 0;
        TotalBaseAmountApp := 0;
        TotalBaseAmtAmendment := 0;
        TotalBaseAmountRefund := 0;
        TotalGSTAmount := 0;
        CESSAmount := 0;
        CESSAmountApp := 0;
        CESSAmountAmendment := 0;
        CESSAmountRefund := 0;
        TotalBaseAmountRefund := 0;
        GSTPer := 0;
        GSTPerAmend := 0;
    end;

    local procedure GetComponentValues(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        OriginalInvoiceNo: Code[20];
        LineNo: Integer;
        ItemChargeLineNo: Integer;
        c: Integer;
    begin
        DetailedGSTLedgerEntry1.SETCURRENTKEY("Entry Type", "Document No.", "GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                           DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                        THEN BEGIN
                            IF (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                               (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                               (ItemChargeLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                            THEN BEGIN
                                TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                c += 1;
                            END;
                            GSTPer += DetailedGSTLedgerEntry1."GST %";
                            TotalGSTAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                            OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                            ItemChargeLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                        END ELSE BEGIN
                            IF (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                               (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                               (ItemChargeLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                            THEN BEGIN
                                TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                            END;
                            GSTPer := DetailedGSTLedgerEntry1."GST %";
                            TotalGSTAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                            OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                            ItemChargeLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                        END
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        IF c > 1 THEN
            GSTPer := GSTPer / c;
    end;

    [Scope('Internal')]
    procedure GetBaseAmount(DetailedGSTLedgerEntry: Record "16419") BaseAmount: Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        LineNo: Integer;
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            RESET;
            SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
            SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
            SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            IF FINDSET THEN
                REPEAT
                    IF LineNo <> "Document Line No." THEN
                        BaseAmount += ABS("GST Base Amount");
                    LineNo := "Document Line No.";
                UNTIL NEXT = 0;
        END;
        EXIT(BaseAmount);
    end;

    [Scope('Internal')]
    procedure GetGSTAmount(DetailedGSTLedgerEntry: Record "16419") GSTAmount: Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            RESET;
            SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
            SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
            SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
            SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            IF FINDSET THEN
                REPEAT
                    GSTAmount += ABS("GST Amount");
                UNTIL NEXT = 0;
        END;
        EXIT(GSTAmount);
    end;

    local procedure GetExitPoint(DocumentNo: Code[20]): Code[10]
    var
        SalesInvoiceHeader: Record "112";
    begin
        IF SalesInvoiceHeader.GET(DocumentNo) THEN;
        EXIT(SalesInvoiceHeader."Exit Point");
    end;

    local procedure GetApplicationRemAmt(DetailedGSTLedgerEntry: Record "16419")
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntry1: Record "16419";
        DetailedGSTLedgerEntry2: Record "16419";
        DetailedGSTLedgerEntry3: Record "16419";
        DocumentNo: Code[20];
        DocumentNo1: Code[20];
        LineNo: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::Application);
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", FALSE);
        DetailedGSTLedgerEntry1.SETRANGE(UnApplied, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                           DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                        THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                               (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                            THEN
                                TotalBaseAmountApp += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                            DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                        END ELSE BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                               (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                            THEN
                                TotalBaseAmountApp += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                        END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;

        GSTComponent.RESET;
        GSTComponent.SETRANGE("Report View", GSTComponent."Report View"::CESS);
        IF GSTComponent.FINDSET THEN
            REPEAT
                DetailedGSTLedgerEntry.SETCURRENTKEY(
                  "Location  Reg. No.", "Posting Date", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
                DetailedGSTLedgerEntry2.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
                DetailedGSTLedgerEntry2.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                DetailedGSTLedgerEntry2.SETRANGE("Entry Type", DetailedGSTLedgerEntry2."Entry Type"::Application);
                DetailedGSTLedgerEntry2.SETRANGE("Transaction Type", DetailedGSTLedgerEntry2."Transaction Type"::Sales);
                DetailedGSTLedgerEntry2.SETRANGE("Document Type", DetailedGSTLedgerEntry2."Document Type"::Invoice);
                DetailedGSTLedgerEntry2.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
                DetailedGSTLedgerEntry2.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type");
                DetailedGSTLedgerEntry2.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
                DetailedGSTLedgerEntry2.SETFILTER("GST Component Code", '<>%1', GSTComponent.Code);
                DetailedGSTLedgerEntry2.SETRANGE(Reversed, FALSE);
                DetailedGSTLedgerEntry2.SETRANGE(UnApplied, FALSE);
                IF DetailedGSTLedgerEntry2.FINDSET THEN
                    REPEAT
                        IF DocumentNo1 <> DetailedGSTLedgerEntry2."Application Doc. No" THEN BEGIN
                            DetailedGSTLedgerEntry3.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry2."Location  Reg. No.");
                            DetailedGSTLedgerEntry3.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                            DetailedGSTLedgerEntry3.SETRANGE("Transaction Type", DetailedGSTLedgerEntry3."Transaction Type"::Sales);
                            DetailedGSTLedgerEntry3.SETRANGE("Entry Type", DetailedGSTLedgerEntry2."Entry Type"::Application);
                            DetailedGSTLedgerEntry3.SETRANGE("Application Doc. No", DetailedGSTLedgerEntry2."Application Doc. No");
                            DetailedGSTLedgerEntry3.SETRANGE(Reversed, FALSE);
                            DetailedGSTLedgerEntry3.SETRANGE(UnApplied, FALSE);
                            DetailedGSTLedgerEntry3.SETRANGE("GST Component Code", GSTComponent.Code);
                            IF DetailedGSTLedgerEntry3.FINDSET THEN
                                REPEAT
                                    CESSAmountApp += ABS(DetailedGSTLedgerEntry3."GST Amount");
                                UNTIL DetailedGSTLedgerEntry3.NEXT = 0;
                        END;
                        IF CESSAmountApp <> 0 THEN
                            DocumentNo1 := DetailedGSTLedgerEntry2."Application Doc. No";
                    UNTIL DetailedGSTLedgerEntry2.NEXT = 0;
            UNTIL GSTComponent.NEXT = 0;
    end;

    local procedure GetInvoiceType(DetailedGSTLedgerEntry: Record "16419"): Text[50]
    begin
        CASE DetailedGSTLedgerEntry."GST Customer Type" OF
            DetailedGSTLedgerEntry."GST Customer Type"::Registered:
                EXIT(RegularTxt);
            DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development", DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit":
                BEGIN
                    IF DetailedGSTLedgerEntry."GST Without Payment of Duty" THEN
                        EXIT(SEZWOPayTxt);
                    EXIT(SEZWPayTxt);
                END;
            DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export":
                EXIT(DeemedExportTxt);
        END;
        IF DetailedGSTLedgerEntry."GST Vendor Type" = DetailedGSTLedgerEntry."GST Vendor Type"::Registered THEN
            EXIT(RegularTxt);
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

    local procedure GetURType(DetailedGSTLedgerEntry: Record "16419"): Text[50]
    begin
        CASE DetailedGSTLedgerEntry."GST Customer Type" OF
            DetailedGSTLedgerEntry."GST Customer Type"::Unregistered:
                EXIT(B2CLTxt);
            DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
            DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
            DetailedGSTLedgerEntry."GST Customer Type"::Export,
            DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export":
                BEGIN
                    IF DetailedGSTLedgerEntry."GST Without Payment of Duty" THEN
                        EXIT(UPPERCASE(EXPWOPayTxt));
                    EXIT(UPPERCASE(EXPWPayTxt));
                END;
        END;
    end;

    local procedure GetGSTPlaceWiseValues(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        LineNo: Integer;
        c: Integer;
        DocumentNo: Code[20];
        OriginalInvoiceNo: Code[20];
        ItemChargeAssgntLineNo: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry1.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
        DetailedGSTLedgerEntry1.SETRANGE("GST Customer Type", DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
        DetailedGSTLedgerEntry1.SETRANGE("e-Comm. Operator GST Reg. No.", DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                IF ((DetailedGSTLedgerEntry1."GST Jurisdiction Type" = DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Interstate) AND
                    (GetInvoiceValue(DetailedGSTLedgerEntry1."Document No.", DetailedGSTLedgerEntry1."Document Type") <= 250000) OR
                    (GetInvoiceValueFinCharge(DetailedGSTLedgerEntry1."Document No.") <= 250000)) OR
                   (DetailedGSTLedgerEntry1."GST Jurisdiction Type" = DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate)
                THEN BEGIN
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                               DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                            THEN BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargeAssgntLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    IF DetailedGSTLedgerEntry1."Document Type" = DetailedGSTLedgerEntry1."Document Type"::Invoice THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                    END ELSE BEGIN
                                        TotalBaseAmount -= DetailedGSTLedgerEntry1."GST Base Amount";
                                        CESSAmount -= GetCessAmount(DetailedGSTLedgerEntry1);
                                    END;
                                    c += 1;
                                END;
                                GSTPer += DetailedGSTLedgerEntry1."GST %";
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                ItemChargeAssgntLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                            END ELSE BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargeAssgntLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    GSTPer := DetailedGSTLedgerEntry1."GST %";
                                    IF DetailedGSTLedgerEntry1."Document Type" = DetailedGSTLedgerEntry1."Document Type"::Invoice THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                    END ELSE BEGIN
                                        TotalBaseAmount -= DetailedGSTLedgerEntry1."GST Base Amount";
                                        CESSAmount -= GetCessAmount(DetailedGSTLedgerEntry1);
                                    END;
                                END;
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                ItemChargeAssgntLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                            END;
                END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        IF c > 1 THEN
            GSTPer := GSTPer / c;
    end;

    local procedure GetComponentValueAdvPayment(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        LineNo: Integer;
        DocumentNo: Code[20];
        c: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST on Advance Payment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                           DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                        THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                               (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                            THEN BEGIN
                                TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                c += 1;
                            END;
                            GSTPer += DetailedGSTLedgerEntry1."GST %";
                            DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                        END ELSE BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                               (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                            THEN BEGIN
                                GSTPer := DetailedGSTLedgerEntry1."GST %";
                                TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                            END;
                            DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                        END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        IF c > 1 THEN
            GSTPer := GSTPer / c;
    end;

    local procedure GetGSTAmountComp(HSNSACCode: Code[8]; UOMCode: Code[10]; ReportView: Option; Base: Boolean; Qty: Boolean): Decimal
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntry: Record "16419";
        GSTAmount: Decimal;
        DocumentNo: Code[20];
        LineNo: Integer;
        OriginalInvoiceNo: Code[20];
        ItemChargesAssgnLineNo: Integer;
    begin
        DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.", "Posting Date", "Entry Type", "Transaction Type", "Document Type",
          "HSN/SAC Code", UOM, "Document No.", "Document Line No.");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETRANGE("HSN/SAC Code", HSNSACCode);
        DetailedGSTLedgerEntry.SETRANGE(UOM, UOMCode);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF NOT Base AND NOT Qty THEN BEGIN
                    IF GSTComponent.GET(DetailedGSTLedgerEntry."GST Component Code") THEN
                        IF GSTComponent."Report View" = ReportView THEN
                            GSTAmount += DetailedGSTLedgerEntry."GST Amount"
                END ELSE
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                       (LineNo <> DetailedGSTLedgerEntry."Document Line No.") OR
                       (OriginalInvoiceNo <> DetailedGSTLedgerEntry."Original Invoice No.") OR
                       (ItemChargesAssgnLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                    THEN BEGIN
                        IF Base THEN
                            GSTAmount += DetailedGSTLedgerEntry."GST Base Amount"
                        ELSE
                            IF Qty THEN
                                GSTAmount += DetailedGSTLedgerEntry.Quantity;
                    END;
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                LineNo := DetailedGSTLedgerEntry."Document Line No.";
                OriginalInvoiceNo := DetailedGSTLedgerEntry."Original Invoice No.";
                ItemChargesAssgnLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        EXIT(GSTAmount);
    end;

    local procedure ClearHSNInfo()
    begin
        CLEAR(GSTBaseAmount);
        CLEAR(HSNIGSTAmt);
        CLEAR(HSNCGSTAmt);
        CLEAR(HSNSGSTAmt);
        CLEAR(HSNCessAmt);
        CLEAR(HSNQty);
    end;

    local procedure GetCessAmount(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocCessAmount: Decimal;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
        DetailedGSTLedgerEntry1.SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
        IF DetailedGSTLedgerEntry."Item Charge Entry" THEN BEGIN
            DetailedGSTLedgerEntry1.SETRANGE("Original Invoice No.", DetailedGSTLedgerEntry."Original Invoice No.");
            DetailedGSTLedgerEntry1.SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
        END;
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.GET(DetailedGSTLedgerEntry1."GST Component Code");
                IF (GSTComponent."Report View" = GSTComponent."Report View"::CESS) AND (GSTComponent."Exclude from Reports" = FALSE) THEN
                    DocCessAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        EXIT(DocCessAmount);
    end;

    local procedure GetInvoiceValue(DocumentNo: Code[20]; DocumentType: Option " ",Payment,Invoice,"Credit Memo",,,,Refund): Decimal
    var
        CustLedgerEntry: Record "21";
    begin
        CustLedgerEntry.SETRANGE("Document Type", DocumentType);
        CustLedgerEntry.SETRANGE("Document No.", DocumentNo);
        IF CustLedgerEntry.FINDFIRST THEN
            CustLedgerEntry.CALCFIELDS("Amount (LCY)");
        EXIT(ABS(CustLedgerEntry."Amount (LCY)"));
    end;

    local procedure GetGSTPaymentOfDuty(DocumentNo: Code[20]): Boolean
    var
        DetailedGSTLedgerEntry: Record "16419";
    begin
        DetailedGSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
        IF DetailedGSTLedgerEntry.FINDFIRST THEN
            EXIT(DetailedGSTLedgerEntry."GST Without Payment of Duty");
    end;

    local procedure CheckComponentReportView(ComponentCode: Code[10])
    var
        GSTComponent: Record "16405";
    begin
        GSTComponent.GET(ComponentCode);
        GSTComponent.TESTFIELD("Report View");
    end;

    local procedure CheckATADJ(ApplicationDocNo: Code[20]): Boolean
    var
        DetailedGSTLedgerEntry: Record "16419";
    begin
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Payment);
        DetailedGSTLedgerEntry.SETRANGE("Document No.", ApplicationDocNo);
        DetailedGSTLedgerEntry.SETFILTER("Posting Date", '<%1', DMY2DATE(1, Month, Year));
        IF DetailedGSTLedgerEntry.FINDFIRST THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    local procedure GetComponentValueAdvPaymentATADJ(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        OriginalInvoiceNo: Code[20];
        LineNo: Integer;
        ItemChargeAssignemtLineNo: Integer;
        c: Integer;
    begin
        DetailedGSTLedgerEntry1.SETCURRENTKEY("Document No.", "Document Line No.", "Item Charge Assgn. Line No.");
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::Application);
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Invoice);
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE(UnApplied, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                IF CheckATADJ(DetailedGSTLedgerEntry1."Original Doc. No.") THEN BEGIN
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                               DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                            THEN BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargeAssignemtLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                    CESSAmount += GetCessAmountApplication(DetailedGSTLedgerEntry1);
                                    c += 1;
                                END;
                                GSTPer += DetailedGSTLedgerEntry1."GST %";
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                ItemChargeAssignemtLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                            END ELSE BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargeAssignemtLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    GSTPer := DetailedGSTLedgerEntry1."GST %";
                                    TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                    CESSAmount += GetCessAmountApplication(DetailedGSTLedgerEntry1);
                                END;
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                ItemChargeAssignemtLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                            END;
                END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        IF c > 1 THEN
            GSTPer := GSTPer / c;
    end;

    local procedure GetCessAmountApplication(DetailedGSTLedgerEntry: Record "16419"): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocCessAmount: Decimal;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::Application);
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Invoice);
        DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
        DetailedGSTLedgerEntry1.SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
        DetailedGSTLedgerEntry1.SETRANGE("Item Charge Assgn. Line No.", DetailedGSTLedgerEntry."Item Charge Assgn. Line No.");
        DetailedGSTLedgerEntry1.SETRANGE(UnApplied, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.GET(DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent."Report View" = GSTComponent."Report View"::CESS THEN
                    IF CheckATADJ(DetailedGSTLedgerEntry1."Original Doc. No.") THEN
                        DocCessAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        EXIT(DocCessAmount);
    end;

    local procedure GetDocumentDate(TransactionNo: Integer): Date
    var
        CustLedgerEntry: Record "21";
        DetailedGSTLedgerEntry: Record "16419";
        DetailedGSTLedgerEntry1: Record "16419";
    begin
        CustLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
        IF CustLedgerEntry.FINDFIRST THEN
            EXIT(CustLedgerEntry."Document Date");
        // ELSE BEGIN
        DetailedGSTLedgerEntry.SETRANGE("Transaction No.", TransactionNo);
        IF DetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
            IF DetailedGSTLedgerEntry1.FINDFIRST THEN BEGIN
                CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry1."Transaction No.");
                IF CustLedgerEntry.FINDFIRST THEN
                    EXIT(CustLedgerEntry."Document Date")
            END;
        END;
        // END;
    end;

    local procedure GetTransferShipmentValue(OriginalDocumentNo: Code[20]): Decimal
    var
        DetailedGSTLedgerEntry: Record "16419";
        BaseAmt: Decimal;
        GSTAmt: Decimal;
        LineNo: Integer;
    begin
        WITH DetailedGSTLedgerEntry DO BEGIN
            SETRANGE("Original Doc. Type", "Original Doc. Type"::"Transfer Shipment");
            SETRANGE("Original Doc. No.", OriginalDocumentNo);
            IF FINDSET THEN
                REPEAT
                    IF LineNo <> "Document Line No." THEN
                        BaseAmt += ABS("GST Base Amount");
                    LineNo := "Document Line No.";
                    GSTAmt += ABS("GST Amount");
                UNTIL NEXT = 0;
        END;
        EXIT(BaseAmt + GSTAmt);
    end;

    local procedure GetAmendedValueAdvPaymentATA(DetailedGSTLedgerEntry: Record "16419"; MonthATA: Integer; YearATA: Integer)
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        LineNo: Integer;
        DocumentNo: Code[20];
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, MonthATA, YearATA), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST on Advance Payment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE(
          "Original Adv. Pmt Doc. Date", DMY2DATE(1, MonthATA, YearATA), CALCDATE('<1M - 1D>', DMY2DATE(1, MonthATA, YearATA)));
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                           (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                        THEN BEGIN
                            TotalBaseAmtAmendment += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            CESSAmountAmendment += GetCessAmountAdjEntries(DetailedGSTLedgerEntry1, TRUE);
                        END;
                        DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                        LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                        IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                           DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                        THEN
                            GSTPerAmend := DetailedGSTLedgerEntry1."GST %" * 2
                        ELSE
                            GSTPerAmend := DetailedGSTLedgerEntry1."GST %";
                    END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
    end;

    local procedure GetFinancialYear(OriginalAdvPmtDate: Date): Text[20]
    var
        GSTAccountingPeriod: Record "16401";
    begin
        GSTAccountingPeriod.SETFILTER("Starting Date", '<=%1', OriginalAdvPmtDate);
        GSTAccountingPeriod.SETFILTER("Ending Date", '>=%1', OriginalAdvPmtDate);
        IF GSTAccountingPeriod.FINDFIRST THEN
            EXIT(FORMAT(DATE2DMY(GSTAccountingPeriod."Starting Date", 3)) +
              '-' + COPYSTR(FORMAT(DATE2DMY(GSTAccountingPeriod."Ending Date", 3)), 3, 2));
    end;

    local procedure GetMonthValue(MonthATA: Integer): Text[20]
    begin
        IF MonthATA = 1 THEN
            EXIT('Jan');
        IF MonthATA = 2 THEN
            EXIT('Feb');
        IF MonthATA = 3 THEN
            EXIT('Mar');
        IF MonthATA = 4 THEN
            EXIT('Apr');
        IF MonthATA = 5 THEN
            EXIT('May');
        IF MonthATA = 6 THEN
            EXIT('Jun');
        IF MonthATA = 7 THEN
            EXIT('Jul');
        IF MonthATA = 8 THEN
            EXIT('Aug');
        IF MonthATA = 9 THEN
            EXIT('Sep');
        IF MonthATA = 10 THEN
            EXIT('Oct');
        IF MonthATA = 11 THEN
            EXIT('Nov');
        IF MonthATA = 12 THEN
            EXIT('Dec');
    end;

    local procedure GetRefundAmtATA(DetailedGSTLedgerEntry: Record "16419"; MonthATA: Integer; YearATA: Integer)
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntry1: Record "16419";
        DocumentNo: Code[20];
        LineNo: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, MonthATA, YearATA), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Refund);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                           (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                        THEN BEGIN
                            TotalBaseAmountRefund += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            CESSAmountRefund += GetCessAmountAdjEntries(DetailedGSTLedgerEntry1, FALSE);
                        END;
                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
    end;

    local procedure GetAdvPaymentValueATA(DetailedGSTLedgerEntry: Record "16419"; State: Record "13762")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        DetailedGSTLedgerEntry2: Record "16419";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
        MonthAmend: Integer;
        YearAmend: Integer;
        LineNo: Integer;
        AdjustedTotalBase: Decimal;
        AdjustedTotalCess: Decimal;
    begin
        MonthAmend := DATE2DMY(DetailedGSTLedgerEntry."Original Adv. Pmt Doc. Date", 2);
        YearAmend := DATE2DMY(DetailedGSTLedgerEntry."Original Adv. Pmt Doc. Date", 3);
        DetailedGSTLedgerEntry1.SETCURRENTKEY(
          "Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        DetailedGSTLedgerEntry1.SETRANGE(
          "Posting Date", DMY2DATE(1, MonthAmend, YearAmend), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Payment);
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST on Advance Payment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                IF GSTPercentage <> DetailedGSTLedgerEntry1."GST %" THEN BEGIN
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            ClearATAVariables;
                            DetailedGSTLedgerEntry2.COPYFILTERS(DetailedGSTLedgerEntry1);
                            DetailedGSTLedgerEntry2.SETRANGE("GST %", DetailedGSTLedgerEntry1."GST %");
                            IF DetailedGSTLedgerEntry2.FINDSET THEN
                                REPEAT
                                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry2."GST Component Code");
                                    IF GSTComponent.FINDFIRST THEN
                                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                            IF (DocumentNo <> DetailedGSTLedgerEntry2."Document No.") OR
                                               (LineNo <> DetailedGSTLedgerEntry2."Document Line No.")
                                            THEN BEGIN
                                                TotalBaseAmount += ABS(DetailedGSTLedgerEntry2."GST Base Amount");
                                                CESSAmount += GetCessAmountAdjEntries(DetailedGSTLedgerEntry2, FALSE);
                                            END;
                                            IF DetailedGSTLedgerEntry2."GST Jurisdiction Type" =
                                               DetailedGSTLedgerEntry2."GST Jurisdiction Type"::Intrastate
                                            THEN
                                                GSTPer := DetailedGSTLedgerEntry2."GST %" * 2
                                            ELSE
                                                GSTPer := DetailedGSTLedgerEntry2."GST %";
                                            DocumentNo := DetailedGSTLedgerEntry2."Document No.";
                                            LineNo := DetailedGSTLedgerEntry2."Document Line No.";
                                        END;
                                UNTIL DetailedGSTLedgerEntry2.NEXT = 0;

                            // to skip duplicate excel entries for similar GST%
                            TempDetailedGSTLedgerEntry.SETFILTER("GST %", '%1', DetailedGSTLedgerEntry1."GST %");
                            TempDetailedGSTLedgerEntry.SETFILTER("Buyer/Seller State Code", '%1', DetailedGSTLedgerEntry1."Buyer/Seller State Code");
                            TempDetailedGSTLedgerEntry.SETFILTER(
                              "Posting Date", '%1..%2', DMY2DATE(1, MonthAmend, YearAmend), CALCDATE('<1M - 1D>', DMY2DATE(1, MonthAmend, YearAmend)));
                            IF NOT TempDetailedGSTLedgerEntry.FINDFIRST THEN BEGIN
                                TempDetailedGSTLedgerEntry.RESET;
                                TempDetailedGSTLedgerEntry.INIT;
                                IF TempDetailedGSTLedgerEntry.FINDLAST THEN
                                    TempDetailedGSTLedgerEntry."Entry No." += 1
                                ELSE
                                    TempDetailedGSTLedgerEntry."Entry No." := 1;
                                TempDetailedGSTLedgerEntry."Posting Date" := DetailedGSTLedgerEntry1."Posting Date";
                                TempDetailedGSTLedgerEntry."Buyer/Seller State Code" := DetailedGSTLedgerEntry1."Buyer/Seller State Code";
                                TempDetailedGSTLedgerEntry."GST %" := DetailedGSTLedgerEntry1."GST %";
                                TempDetailedGSTLedgerEntry.INSERT;

                                GetRefundAmtATA(DetailedGSTLedgerEntry1, MonthAmend, YearAmend);
                                GetApplicationRemAmtForATA(DetailedGSTLedgerEntry1, MonthAmend, YearAmend);
                                GetAmendedValueAdvPaymentATA(DetailedGSTLedgerEntry1, MonthAmend, YearAmend);

                                AdjustedTotalBase := TotalBaseAmount - TotalBaseAmountApp - (TotalBaseAmountRefund - TotalBaseAmtAmendment);
                                AdjustedTotalCess := CESSAmount - CESSAmountApp - (CESSAmountRefund - CESSAmountAmendment);
                            END;

                            IF AdjustedTotalBase <> 0 THEN BEGIN
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(
                                  GetFinancialYear(
                                    DetailedGSTLedgerEntry1."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GetMonthValue(MonthAmend), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(
                                  State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                  FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AdjustedTotalBase, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AdjustedTotalCess, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            END;
                        END;
                END;
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        GSTPercentage := DetailedGSTLedgerEntry1."GST %";
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
    end;

    local procedure GetApplicationRemAmtForATA(DetailedGSTLedgerEntry: Record "16419"; MonthAmend: Integer; YearAmend: Integer)
    var
        GSTComponent: Record "16405";
        DetailedGSTLedgerEntry1: Record "16419";
        DetailedGSTLedgerEntry2: Record "16419";
        DetailedGSTLedgerEntry3: Record "16419";
        DocumentNo: Code[20];
        DocumentNo1: Code[20];
        LineNo: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE(
          "Posting Date", DMY2DATE(1, MonthAmend, YearAmend), CALCDATE('<1M - 1D>', DMY2DATE(1, MonthAmend, YearAmend)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::Application);
        DetailedGSTLedgerEntry1.SETRANGE("Original Doc. Type", DetailedGSTLedgerEntry1."Original Doc. Type"::Payment);
        DetailedGSTLedgerEntry1.SETRANGE("Original Doc. No.", DetailedGSTLedgerEntry."Document No.");
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", FALSE);
        DetailedGSTLedgerEntry1.SETRANGE(UnApplied, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                           DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                        THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                               (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                            THEN
                                TotalBaseAmountApp += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                            DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                        END ELSE BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                               (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                            THEN
                                TotalBaseAmountApp += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                            LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                        END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;

        GSTComponent.RESET;
        GSTComponent.SETRANGE("Report View", GSTComponent."Report View"::CESS);
        IF GSTComponent.FINDSET THEN
            REPEAT
                DetailedGSTLedgerEntry.SETCURRENTKEY(
                  "Location  Reg. No.", "Posting Date", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
                DetailedGSTLedgerEntry2.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
                DetailedGSTLedgerEntry2.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                DetailedGSTLedgerEntry2.SETRANGE("Entry Type", DetailedGSTLedgerEntry2."Entry Type"::Application);
                DetailedGSTLedgerEntry2.SETRANGE("Transaction Type", DetailedGSTLedgerEntry2."Transaction Type"::Sales);
                DetailedGSTLedgerEntry2.SETRANGE("Document Type", DetailedGSTLedgerEntry2."Document Type"::Invoice);
                DetailedGSTLedgerEntry2.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
                DetailedGSTLedgerEntry2.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type");
                DetailedGSTLedgerEntry2.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
                DetailedGSTLedgerEntry2.SETFILTER("GST Component Code", '<>%1', GSTComponent.Code);
                DetailedGSTLedgerEntry2.SETRANGE(Reversed, FALSE);
                DetailedGSTLedgerEntry2.SETRANGE(UnApplied, FALSE);
                IF DetailedGSTLedgerEntry2.FINDSET THEN
                    REPEAT
                        IF DocumentNo1 <> DetailedGSTLedgerEntry2."Application Doc. No" THEN BEGIN
                            DetailedGSTLedgerEntry3.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry2."Location  Reg. No.");
                            DetailedGSTLedgerEntry3.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                            DetailedGSTLedgerEntry3.SETRANGE("Transaction Type", DetailedGSTLedgerEntry3."Transaction Type"::Sales);
                            DetailedGSTLedgerEntry3.SETRANGE("Entry Type", DetailedGSTLedgerEntry2."Entry Type"::Application);
                            DetailedGSTLedgerEntry3.SETRANGE("Application Doc. No", DetailedGSTLedgerEntry2."Application Doc. No");
                            DetailedGSTLedgerEntry3.SETRANGE(Reversed, FALSE);
                            DetailedGSTLedgerEntry3.SETRANGE(UnApplied, FALSE);
                            DetailedGSTLedgerEntry3.SETRANGE("GST Component Code", GSTComponent.Code);
                            IF DetailedGSTLedgerEntry3.FINDSET THEN
                                REPEAT
                                    CESSAmountApp += ABS(DetailedGSTLedgerEntry3."GST Amount");
                                UNTIL DetailedGSTLedgerEntry3.NEXT = 0;
                        END;
                        IF CESSAmountApp <> 0 THEN
                            DocumentNo1 := DetailedGSTLedgerEntry2."Application Doc. No";
                    UNTIL DetailedGSTLedgerEntry2.NEXT = 0;
            UNTIL GSTComponent.NEXT = 0;
    end;

    local procedure CheckSameGSTPerAmendment(DetailedGSTLedgerEntry: Record "16419"; MonthATA: Integer; YearATA: Integer): Boolean
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
    begin
        WITH DetailedGSTLedgerEntry1 DO BEGIN
            SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
            SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
            SETRANGE("Transaction Type", "Transaction Type"::Sales);
            SETRANGE("Document Type", "Document Type"::Payment);
            SETRANGE("GST on Advance Payment", TRUE);
            SETRANGE("Adv. Pmt. Adjustment", FALSE);
            SETRANGE("Posting Date", DMY2DATE(1, MonthATA, YearATA), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
            SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            IF FINDFIRST THEN
                IF GSTComponent.GET("GST Component Code") THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        EXIT(TRUE);
            EXIT(FALSE);
        END;
    end;

    local procedure GetCessAmountAdjEntries(DetailedGSTLedgerEntry: Record "16419"; AmendmentEntries: Boolean): Decimal
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocCessAmount: Decimal;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
        DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
        DetailedGSTLedgerEntry1.SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
        IF AmendmentEntries THEN
            DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", TRUE);
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.GET(DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent."Report View" = GSTComponent."Report View"::CESS THEN
                    DocCessAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        EXIT(DocCessAmount);
    end;

    local procedure ClearATAVariables()
    begin
        TotalBaseAmount := 0;
        TotalBaseAmountApp := 0;
        TotalBaseAmountRefund := 0;
        TotalBaseAmtAmendment := 0;
        CESSAmount := 0;
        CESSAmountApp := 0;
        CESSAmountRefund := 0;
        CESSAmountAmendment := 0;
    end;

    local procedure GetComponentValueAdvPaymentAdjustment(DetailedGSTLedgerEntry: Record "16419"; State: Record "13762")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        DetailedGSTLedgerEntry2: Record "16419";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        LineNo: Integer;
        GSTPercentage: Decimal;
        AdjustedTotalBase: Decimal;
        AdjustedTotalCess: Decimal;
    begin
        DetailedGSTLedgerEntry1.SETCURRENTKEY(
          "Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Payment);
        DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
        DetailedGSTLedgerEntry1.SETRANGE("GST on Advance Payment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                IF GSTPercentage <> DetailedGSTLedgerEntry1."GST %" THEN BEGIN
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            TotalBaseAmtAmendment := 0;
                            CESSAmountAmendment := 0;
                            DetailedGSTLedgerEntry2.COPYFILTERS(DetailedGSTLedgerEntry1);
                            DetailedGSTLedgerEntry2.SETRANGE("GST %", DetailedGSTLedgerEntry1."GST %");
                            DetailedGSTLedgerEntry2.SETRANGE("Adv. Pmt. Adjustment", TRUE);
                            DetailedGSTLedgerEntry2.SETRANGE(
                              "Original Adv. Pmt Doc. Date", DMY2DATE(1, Month, Year),
                              CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                            IF DetailedGSTLedgerEntry2.FINDSET THEN
                                REPEAT
                                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry2."GST Component Code");
                                    IF GSTComponent.FINDFIRST THEN
                                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                            IF (DocumentNo <> DetailedGSTLedgerEntry2."Document No.") OR
                                               (LineNo <> DetailedGSTLedgerEntry2."Document Line No.")
                                            THEN BEGIN
                                                TotalBaseAmtAmendment += ABS(DetailedGSTLedgerEntry2."GST Base Amount");
                                                CESSAmountAmendment += GetCessAmountAdjEntries(DetailedGSTLedgerEntry2, TRUE);
                                            END;
                                            DocumentNo := DetailedGSTLedgerEntry2."Document No.";
                                            LineNo := DetailedGSTLedgerEntry2."Document Line No.";
                                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                                               DetailedGSTLedgerEntry2."GST Jurisdiction Type"::Intrastate
                                            THEN
                                                GSTPer := DetailedGSTLedgerEntry2."GST %" * 2
                                            ELSE
                                                GSTPer := DetailedGSTLedgerEntry2."GST %";
                                        END;
                                UNTIL DetailedGSTLedgerEntry2.NEXT = 0;

                            GetComponentValueAdvPayment(DetailedGSTLedgerEntry1);
                            GetApplicationRemAmt(DetailedGSTLedgerEntry1);
                            GetAmendedRefundAmountAT(DetailedGSTLedgerEntry1);

                            AdjustedTotalBase := TotalBaseAmount - TotalBaseAmountApp - TotalBaseAmountRefund + TotalBaseAmtAmendment;
                            AdjustedTotalCess := CESSAmount - CESSAmountApp - CESSAmountRefund + CESSAmountAmendment;

                            IF AdjustedTotalBase <> 0 THEN BEGIN
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(
                                  State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                  FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AdjustedTotalBase, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(AdjustedTotalCess, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            END;
                        END;
                END;
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        GSTPercentage := DetailedGSTLedgerEntry."GST %";
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
    end;

    local procedure GetAmendedRefundAmountAT(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        LineNo: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry1."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Refund);
        DetailedGSTLedgerEntry1.SETRANGE("Adv. Pmt. Adjustment", TRUE);
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                        IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                           (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                        THEN BEGIN
                            TotalBaseAmountRefund += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                            CESSAmountRefund += GetCessAmountAdjEntries(DetailedGSTLedgerEntry1, FALSE);
                        END;
                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
    end;

    local procedure GetInvoiceValueFinCharge(DocumentNo: Code[20]): Decimal
    var
        CustLedgerEntry: Record "21";
    begin
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::"Finance Charge Memo");
        CustLedgerEntry.SETRANGE("Document No.", DocumentNo);
        IF CustLedgerEntry.FINDFIRST THEN
            CustLedgerEntry.CALCFIELDS("Amount (LCY)");
        EXIT(ABS(CustLedgerEntry."Amount (LCY)"));
    end;

    local procedure MakeExcelHeaderEXEMP()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(DespTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(NilTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ExmpTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(NonGSTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyEXEMP()
    begin
        MakeExcelHeaderEXEMP;
        GetInterAndIntraRegAmount;
        GetInterAndIntraUnRegAmount;
        GetExmpInterAndIntraRegAmount;
        GetExmpInterAndIntraUnRegAmount;
        GetNonGSTInterAndIntraRegAmount;
        GetNonGSTInterAndIntraUnregAmount;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(InterRegTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ABS(InterRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ABS(InterExmpRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(InterNonGSTRegAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(IntraRegTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ABS(IntraRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ABS(IntraExmpRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IntraNonGSTRegAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(InterUnRegTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ABS(InterUnRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ABS(InterExmpUnRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(InterNonGSTUnRegAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(IntraUnRegTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ABS(IntraUnRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ABS(IntraExmpUnRegAmount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IntraNonGSTUnRegAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure GetInterAndIntraRegAmount()
    var
        DetailedGSTLedgerEntry: Record "16419";
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
        ItemChargeAssignLineNo: Integer;
    begin
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("GST Without Payment of Duty", FALSE);
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETFILTER(
          "GST Customer Type", '%1|%2|%3|%4', DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
          DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
          DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
          DetailedGSTLedgerEntry."GST Customer Type"::Registered);
        DetailedGSTLedgerEntry.SETRANGE("GST Exempted Goods", FALSE);
        DetailedGSTLedgerEntry.SETFILTER("GST %", '=%1', 0);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate THEN BEGIN
                    IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                        THEN
                            InterRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    END ELSE
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                        THEN
                            InterRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                    ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                END ELSE
                    IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                            THEN
                                IntraRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        END ELSE
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                            THEN
                                IntraRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                        ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure GetInterAndIntraUnRegAmount()
    var
        DetailedGSTLedgerEntry: Record "16419";
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
        ItemChargeAssignLineNo: Integer;
    begin
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETFILTER(
          "GST Customer Type", '%1|%2', DetailedGSTLedgerEntry."GST Customer Type"::Unregistered,
          DetailedGSTLedgerEntry."GST Customer Type"::Export);
        DetailedGSTLedgerEntry.SETRANGE("GST Exempted Goods", FALSE);
        DetailedGSTLedgerEntry.SETFILTER("GST %", '=%1', 0);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate THEN BEGIN
                    IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                        THEN
                            InterUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    END ELSE
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                        THEN
                            InterUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                    ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                END ELSE
                    IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                            THEN
                                IntraUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        END ELSE
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                            THEN
                                IntraUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                        ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure GetExmpInterAndIntraRegAmount()
    var
        DetailedGSTLedgerEntry: Record "16419";
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
        ItemChargeAssignLineNo: Integer;
    begin
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("GST Customer Type", DetailedGSTLedgerEntry."GST Customer Type"::Exempted);
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate THEN BEGIN
                    IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                        THEN
                            InterExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    END ELSE
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                        THEN
                            InterExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                    ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                END ELSE
                    IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                            THEN
                                IntraExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        END ELSE
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                            THEN
                                IntraExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                        ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        CLEAR(DocumentNo);
        CLEAR(DocumentLineNo);
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETFILTER(
          "GST Customer Type", '%1|%2|%3|%4', DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
          DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
          DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
          DetailedGSTLedgerEntry."GST Customer Type"::Registered);
        DetailedGSTLedgerEntry.SETRANGE("GST Exempted Goods", TRUE);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate THEN BEGIN
                    IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                        THEN
                            InterExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    END ELSE
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                        THEN
                            InterExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                    ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                END ELSE
                    IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                            THEN
                                IntraExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        END ELSE
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                            THEN
                                IntraExmpRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                        ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure GetExmpInterAndIntraUnRegAmount()
    var
        DetailedGSTLedgerEntry: Record "16419";
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
        ItemChargeAssignLineNo: Integer;
    begin
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETFILTER(
          "GST Customer Type", '%1|%2',
          DetailedGSTLedgerEntry."GST Customer Type"::Unregistered, DetailedGSTLedgerEntry."GST Customer Type"::Export);
        DetailedGSTLedgerEntry.SETRANGE("GST Exempted Goods", TRUE);
        IF DetailedGSTLedgerEntry.FINDSET THEN
            REPEAT
                IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate THEN BEGIN
                    IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                        THEN
                            InterExmpUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    END ELSE
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                        THEN
                            InterExmpUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                    DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                    ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                END ELSE
                    IF DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        IF DetailedGSTLedgerEntry."Item Charge Entry" = FALSE THEN BEGIN
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (DocumentLineNo <> DetailedGSTLedgerEntry."Document Line No.")
                            THEN
                                IntraExmpUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        END ELSE
                            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                               (ItemChargeAssignLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                            THEN
                                IntraExmpUnRegAmount += DetailedGSTLedgerEntry."GST Base Amount";
                        DocumentNo := DetailedGSTLedgerEntry."Document No.";
                        DocumentLineNo := DetailedGSTLedgerEntry."Document Line No.";
                        ItemChargeAssignLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                    END;
            UNTIL DetailedGSTLedgerEntry.NEXT = 0;
    end;

    local procedure GetNonGSTInterAndIntraRegAmount()
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        Location: Record "14";
        GSTManagement: Codeunit "16401";
    begin
        Location.SETRANGE("GST Registration No.", GSTIN);
        IF Location.FINDSET THEN
            REPEAT
                SalesInvoiceHeader.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                SalesInvoiceHeader.SETRANGE("Location Code", Location.Code);
                SalesInvoiceHeader.SETFILTER("GST Customer Type", '%1|%2|%3|%4', SalesInvoiceHeader."GST Customer Type"::"Deemed Export",
                  SalesInvoiceHeader."GST Customer Type"::"SEZ Development",
                  SalesInvoiceHeader."GST Customer Type"::"SEZ Unit",
                  SalesInvoiceHeader."GST Customer Type"::Registered);
                SalesInvoiceHeader.SETFILTER(Structure, '<>%1', '');
                IF SalesInvoiceHeader.FINDSET THEN
                    REPEAT
                        IF NOT GSTManagement.CheckGSTStrucure(SalesInvoiceHeader.Structure) THEN
                            IF NOT CheckGSTChargeStrucure(SalesInvoiceHeader.Structure) THEN
                                IF Location."State Code" <> SalesInvoiceHeader."GST Bill-to State Code" THEN BEGIN
                                    SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                                    IF SalesInvoiceLine.FINDSET THEN
                                        REPEAT
                                            InterNonGSTRegAmount += SalesInvoiceLine."Amount To Customer";
                                        UNTIL SalesInvoiceLine.NEXT = 0;
                                END ELSE
                                    IF Location."State Code" = SalesInvoiceHeader."GST Bill-to State Code" THEN BEGIN
                                        SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                                        IF SalesInvoiceLine.FINDSET THEN
                                            REPEAT
                                                IntraNonGSTRegAmount += SalesInvoiceLine."Amount To Customer";
                                            UNTIL SalesInvoiceLine.NEXT = 0;
                                    END;
                    UNTIL SalesInvoiceHeader.NEXT = 0;

                SalesCrMemoHeader.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                SalesCrMemoHeader.SETRANGE("Location Code", Location.Code);
                SalesCrMemoHeader.SETFILTER("GST Customer Type", '%1|%2|%3|%4', SalesCrMemoHeader."GST Customer Type"::"Deemed Export",
                  SalesCrMemoHeader."GST Customer Type"::"SEZ Development",
                  SalesCrMemoHeader."GST Customer Type"::"SEZ Unit",
                  SalesCrMemoHeader."GST Customer Type"::Registered);
                SalesCrMemoHeader.SETFILTER(Structure, '<>%1', '');
                IF SalesCrMemoHeader.FINDSET THEN
                    REPEAT
                        IF NOT GSTManagement.CheckGSTStrucure(SalesCrMemoHeader.Structure) THEN
                            IF NOT CheckGSTChargeStrucure(SalesCrMemoHeader.Structure) THEN
                                IF Location."State Code" <> SalesCrMemoHeader."GST Bill-to State Code" THEN BEGIN
                                    SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                                    IF SalesCrMemoLine.FINDSET THEN
                                        REPEAT
                                            InterNonGSTRegAmount -= SalesCrMemoLine."Amount To Customer";
                                        UNTIL SalesCrMemoLine.NEXT = 0;
                                END ELSE
                                    IF Location."State Code" = SalesCrMemoHeader."GST Bill-to State Code" THEN BEGIN
                                        SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                                        IF SalesCrMemoLine.FINDSET THEN
                                            REPEAT
                                                IntraNonGSTRegAmount -= SalesCrMemoLine."Amount To Customer";
                                            UNTIL SalesCrMemoLine.NEXT = 0;
                                    END;
                    UNTIL SalesCrMemoHeader.NEXT = 0;
            UNTIL Location.NEXT = 0;
    end;

    local procedure GetNonGSTInterAndIntraUnregAmount()
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        Location: Record "14";
        GSTManagement: Codeunit "16401";
    begin
        Location.SETRANGE("GST Registration No.", GSTIN);
        IF Location.FINDSET THEN
            REPEAT
                SalesInvoiceHeader.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                SalesInvoiceHeader.SETRANGE("Location Code", Location.Code);
                SalesInvoiceHeader.SETFILTER("GST Customer Type", '%1|%2|%3', SalesInvoiceHeader."GST Customer Type"::" ",
                  SalesInvoiceHeader."GST Customer Type"::Unregistered,
                  SalesInvoiceHeader."GST Customer Type"::Export);
                SalesInvoiceHeader.SETFILTER(Structure, '<>%1', '');
                IF SalesInvoiceHeader.FINDSET THEN
                    REPEAT
                        IF NOT GSTManagement.CheckGSTStrucure(SalesInvoiceHeader.Structure) THEN
                            IF NOT CheckGSTChargeStrucure(SalesInvoiceHeader.Structure) THEN
                                IF Location."State Code" <> SalesInvoiceHeader."GST Bill-to State Code" THEN BEGIN
                                    SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                                    IF SalesInvoiceLine.FINDSET THEN
                                        REPEAT
                                            InterNonGSTUnRegAmount += SalesInvoiceLine."Amount To Customer";
                                        UNTIL SalesInvoiceLine.NEXT = 0;
                                END ELSE
                                    IF Location."State Code" = SalesInvoiceHeader."GST Bill-to State Code" THEN BEGIN
                                        SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                                        IF SalesInvoiceLine.FINDSET THEN
                                            REPEAT
                                                IntraNonGSTUnRegAmount += SalesInvoiceLine."Amount To Customer";
                                            UNTIL SalesInvoiceLine.NEXT = 0;
                                    END;
                    UNTIL SalesInvoiceHeader.NEXT = 0;

                SalesCrMemoHeader.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                SalesCrMemoHeader.SETRANGE("Location Code", Location.Code);
                SalesCrMemoHeader.SETFILTER("GST Customer Type", '%1|%2|%3', SalesCrMemoHeader."GST Customer Type"::" ",
                  SalesCrMemoHeader."GST Customer Type"::Unregistered,
                  SalesCrMemoHeader."GST Customer Type"::Export);
                SalesCrMemoHeader.SETFILTER(Structure, '<>%1', '');
                IF SalesCrMemoHeader.FINDSET THEN
                    REPEAT
                        IF NOT GSTManagement.CheckGSTStrucure(SalesCrMemoHeader.Structure) THEN
                            IF NOT CheckGSTChargeStrucure(SalesCrMemoHeader.Structure) THEN
                                IF Location."State Code" <> SalesCrMemoHeader."GST Bill-to State Code" THEN BEGIN
                                    SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                                    IF SalesCrMemoLine.FINDSET THEN
                                        REPEAT
                                            InterNonGSTUnRegAmount -= SalesCrMemoLine."Amount To Customer";
                                        UNTIL SalesCrMemoLine.NEXT = 0;
                                END ELSE
                                    IF Location."State Code" = SalesCrMemoHeader."GST Bill-to State Code" THEN BEGIN
                                        SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                                        IF SalesCrMemoLine.FINDSET THEN
                                            REPEAT
                                                IntraNonGSTUnRegAmount -= SalesCrMemoLine."Amount To Customer";
                                            UNTIL SalesCrMemoLine.NEXT = 0;
                                    END;
                    UNTIL SalesCrMemoHeader.NEXT = 0;
            UNTIL Location.NEXT = 0;
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

    [Scope('Internal')]
    procedure MakeExcelHeaderB2BA()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Summery For B2BA', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Detail', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Help', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('No. of Reciepients', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('No. of Invoices', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Detail', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ReceiverTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Place of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Reverse Charge', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('E-commerce GSTIN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2BA()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderB2BA;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeaderB2cla()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Summery For B2CLA', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HELP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('No. of Invoices', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Original Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Place of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('E-Commerce GSTIN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sale from Bonded WH', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2cla()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderB2cla;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeaderB2csa()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Summery for B2CSA', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HELP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Note Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Financial Year', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Place of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('E-Commerce GSTIN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyB2csa()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderB2csa;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeadercdnra()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HELP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Note Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('GSTIN/UIN of Recipient', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Receiver Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Note/REfund Voucher Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Note/REfund Voucher Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice/Advance Receipt Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice/Advance Receipt Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Note/Refund Voucher Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Note/Refund Voucher Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supply Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Note/Refund Voucher Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Pre GST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodycdnra()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeadercdnra;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeadercdnurc()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HELP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Note Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('UR Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Note/Refund Voucher Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Note/Refund Voucher Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice/Advance Receipt Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice/Advance Receipt Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Place of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Note/Refund Voucher Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Pre GST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodycdnurc()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeadercdnurc;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeaderCDnura()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HELP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Note Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('UR Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Note/Refund Voucher Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Note/Refund Voucher Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice/Advance Receipt Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice/Advance Receipt Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Value/Refund Voucher Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Value/Refund Voucher Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Document Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Supply Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Note/Refund Voucher Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Pre GST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyCDnura()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderCDnura;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeaderexpa()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('HELP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('No. of Shipping Bill', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Export Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Invoice Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Invoice Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Port Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipping Bill Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Shipping Bill Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Taxable Value', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyexpa()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderexpa;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeaderAtadja()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Summery For Amendment of Adjustment Advances', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Revised Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Help', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);



        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Advance Adjusted', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Cess', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);


        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Financial Year', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Month', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Original Place Of Supply', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Applicable % of Tax Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Rate', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Gross Advance Adjusted', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cess Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyAtadja()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderAtadja;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    [Scope('Internal')]
    procedure MakeExcelHeaderDocs()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Summery of Document issued  during the tax period (13)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Help', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);


        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total cancelled', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Nature of Document', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sr. No. From', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sr. No. To', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Number', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cancelled', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBodyDocs()
    var
        DetailedGSTLedgerEntry: Record "16419";
        State: Record "13762";
        GSTComponent: Record "16405";
        DocumentNo: Code[20];
        GSTPercentage: Decimal;
    begin
        MakeExcelHeaderDocs;
        /*DetailedGSTLedgerEntry.SETCURRENTKEY(
          "Location  Reg. No.","Posting Date","Entry Type","Document Type","Document No.","GST %");
        DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.",GSTIN);
        DetailedGSTLedgerEntry.SETRANGE("Posting Date",DMY2DATE(1,Month,Year),CALCDATE('<1M - 1D>',DMY2DATE(1,Month,Year)));
        DetailedGSTLedgerEntry.SETFILTER("Entry Type",'%1',DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SETRANGE("Document Type",DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SETRANGE("Nature of Supply",DetailedGSTLedgerEntry."Nature of Supply"::B2B);
        DetailedGSTLedgerEntry.SETFILTER(
          "Sales Invoice Type",'<>%1|<>%2',DetailedGSTLedgerEntry."Sales Invoice Type"::"Debit Note",
          DetailedGSTLedgerEntry."Sales Invoice Type"::Supplementary);
        IF DetailedGSTLedgerEntry.FINDSET THEN
          REPEAT
            IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
              IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit",
                                                                 DetailedGSTLedgerEntry."GST Customer Type"::Registered])
              THEN BEGIN
                CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                ClearVariables;
                IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                GetComponentValues(DetailedGSTLedgerEntry);
        
                GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
                IF GSTComponent.FINDFIRST THEN
                  IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                    ExcelBuffer.NewRow;
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Location  Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Buyer/Seller Reg. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF Customer.GET(DetailedGSTLedgerEntry."Source No.") THEN
                      ExcelBuffer.AddColumn(
                        Customer.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Original Doc. Type" =
                       DetailedGSTLedgerEntry."Original Doc. Type"::"Transfer Shipment"
                    THEN BEGIN
                      ExcelBuffer.AddColumn(
                        DetailedGSTLedgerEntry."Posting Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
                      ExcelBuffer.AddColumn(
                        GetTransferShipmentValue(DetailedGSTLedgerEntry."Original Doc. No."),
                        FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                      ExcelBuffer.AddColumn(
                        GetDocumentDate(DetailedGSTLedgerEntry."Transaction No."),FALSE,'',FALSE,FALSE,
                        FALSE,'',ExcelBuffer."Cell Type"::Date);
                      IF DetailedGSTLedgerEntry."Finance Charge Memo" THEN
                        ExcelBuffer.AddColumn(
                          GetInvoiceValueFinCharge(DetailedGSTLedgerEntry."Document No."),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number)
                      ELSE
                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.",DetailedGSTLedgerEntry."Document Type"),
                          FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    END;
                    ExcelBuffer.AddColumn(
                      State."State Code (GST Reg. No.)" + '-' + State.Description,FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                      ExcelBuffer.AddColumn('Y',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text)
                    ELSE
                      ExcelBuffer.AddColumn('N',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      GetInvoiceType(DetailedGSTLedgerEntry),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(
                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.",FALSE,'',FALSE,FALSE,
                      FALSE,'',ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(GSTPer,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(TotalBaseAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(
                      CESSAmount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
                  END;
              END;
            GSTComponent.SETRANGE(Code,DetailedGSTLedgerEntry."GST Component Code");
            IF GSTComponent.FINDFIRST THEN
              IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                GSTPercentage := DetailedGSTLedgerEntry."GST %";
              END;
          UNTIL DetailedGSTLedgerEntry.NEXT = 0;
          */

    end;

    local procedure GetGSTPlaceWiseValues2(DetailedGSTLedgerEntry: Record "16419")
    var
        DetailedGSTLedgerEntry1: Record "16419";
        GSTComponent: Record "16405";
        LineNo: Integer;
        c: Integer;
        DocumentNo: Code[20];
        OriginalInvoiceNo: Code[20];
        ItemChargeAssgntLineNo: Integer;
    begin
        DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
        DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry1.SETFILTER(
          "Document Type", '%1|%2', DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry1.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
        DetailedGSTLedgerEntry1.SETRANGE("GST Customer Type", DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
        DetailedGSTLedgerEntry1.SETRANGE("e-Comm. Operator GST Reg. No.", DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.");
        DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
        DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
        IF DetailedGSTLedgerEntry1.FINDSET THEN
            REPEAT
                IF ((DetailedGSTLedgerEntry1."GST Jurisdiction Type" = DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Interstate) AND
                    (GetInvoiceValue(DetailedGSTLedgerEntry1."Document No.", DetailedGSTLedgerEntry1."Document Type") <= 250000) OR
                    (GetInvoiceValueFinCharge(DetailedGSTLedgerEntry1."Document No.") <= 250000)) OR
                   (DetailedGSTLedgerEntry1."GST Jurisdiction Type" = DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate)
                THEN BEGIN
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                               DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                            THEN BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargeAssgntLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    IF DetailedGSTLedgerEntry1."Document Type" = DetailedGSTLedgerEntry1."Document Type"::Invoice THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                    END ELSE BEGIN
                                        TotalBaseAmount -= DetailedGSTLedgerEntry1."GST Base Amount";
                                        CESSAmount -= GetCessAmount(DetailedGSTLedgerEntry1);
                                    END;
                                    c += 1;
                                END;
                                GSTPer += DetailedGSTLedgerEntry1."GST %";
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                ItemChargeAssgntLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                            END ELSE BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                   (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                   (ItemChargeAssgntLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                THEN BEGIN
                                    GSTPer := DetailedGSTLedgerEntry1."GST %";
                                    IF DetailedGSTLedgerEntry1."Document Type" = DetailedGSTLedgerEntry1."Document Type"::Invoice THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                    END ELSE BEGIN
                                        TotalBaseAmount -= DetailedGSTLedgerEntry1."GST Base Amount";
                                        CESSAmount -= GetCessAmount(DetailedGSTLedgerEntry1);
                                    END;
                                END;
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                ItemChargeAssgntLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                            END;
                END;
            UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
        IF c > 1 THEN
            GSTPer := GSTPer / c;
    end;
}

