report 50017 "Customer-Collection Report"
{
    Caption = 'Customer - Payment Receipt';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                WHERE("Document Type" = FILTER(Payment | Refund));
            RequestFilterFields = "Customer No.", "Posting Date", "Document No.";
            dataitem(DetailedCustLedgEntry1; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Applied Cust. Ledger Entry No." = FIELD("Entry No.");
                DataItemLinkReference = "Cust. Ledger Entry";
                DataItemTableView = SORTING("Applied Cust. Ledger Entry No.", "Entry Type")
                                    WHERE(Unapplied = CONST(false));
                RequestFilterFields = "Posting Date";
                dataitem(CustLedgEntry1; "Cust. Ledger Entry")
                {
                    DataItemLink = "Entry No." = FIELD("Cust. Ledger Entry No.");
                    DataItemLinkReference = DetailedCustLedgEntry1;
                    DataItemTableView = SORTING("Entry No.");

                    trigger OnAfterGetRecord()
                    begin
                        CustLedgEntry1.CALCFIELDS("Original Amount", Amount);

                        IF "Entry No." = "Cust. Ledger Entry"."Entry No." THEN
                            CurrReport.SKIP;

                        ShowAmount := -DetailedCustLedgEntry1.Amount;

                        //AppliedAmount := -DetailedCustLedgEntry1.Amount;
                        AppliedAmount := "Cust. Ledger Entry"."Closed by Amount";

                        RemainingAmount := (RemainingAmount - AppliedAmount);

                        //--------------------------------------------------------

                        ShowAmount := DetailedCustLedgEntry2.Amount;

                        AppliedAmount := DetailedCustLedgEntry2.Amount;

                        RemainingAmount := (RemainingAmount - AppliedAmount);

                        txtData[2] := '';
                        Cust.GET("Customer No.");
                        FormatAddr.Customer(CustAddr, Cust);
                        txtData[2] := Cust.Name;

                        //Acxcp
                        stateName := '';
                        recDimValue.RESET;
                        recDimValue.SETRANGE(Code, "Cust. Ledger Entry"."Global Dimension 1 Code");
                        IF recDimValue.FINDFIRST THEN BEGIN
                            stateName := recDimValue.Name;
                        END;
                        //acxcp
                        /*
                        DetailedCustLedgEntry2.RESET;
                        DetailedCustLedgEntry2.SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type","Posting Date");
                        DetailedCustLedgEntry2.SETRANGE("Cust. Ledger Entry No.","Cust. Ledger Entry"."Entry No.");
                        DetailedCustLedgEntry2.SETFILTER(Unapplied,'%1',FALSE);
                        IF DetailedCustLedgEntry2.FINDFIRST THEN BEGIN
                        
                        
                        END;
                        */
                        //ACXCP
                        txtData[3] := '';
                        txtData[3] := "Cust. Ledger Entry"."Customer Posting Group";
                        txtData[4] := '';
                        txtData[4] := "Cust. Ledger Entry"."Document No.";
                        txtData[5] := '';
                        txtData[5] := FORMAT(DetailedCustLedgEntry1."Posting Date");
                        txtData[6] := '';
                        txtData[6] := FORMAT(CustLedgEntry1."Document No.");
                        txtData[7] := '';
                        txtData[7] := FORMAT(CustLedgEntry1."Due Date");
                        txtData[8] := '';
                        txtData[8] := FORMAT(CustLedgEntry1."External Document No.");
                        txtData[9] := '';
                        txtData[9] := FORMAT(CustLedgEntry1."Posting Date");
                        txtData[10] := '';
                        txtData[10] := FORMAT(CustLedgEntry1.Amount);
                        txtData[11] := '';
                        txtData[11] := FORMAT(CustLedgEntry1."Closed by Amount"); //acx
                        //txtData[11]:=FORMAT(AppliedAmount);
                        txtData[12] := '';
                        txtData[12] := FORMAT(ABS(DetailedCustLedgEntry1.Amount));
                        //txtData[12]:=FORMAT(CustLedgEntry1."Closed by Amount");
                        txtData[13] := '';
                        txtData[13] := FORMAT((CustLedgEntry1."Closed by Amount") - (ABS(DetailedCustLedgEntry1.Amount)));


                        txtData[14] := '';
                        txtData[14] := FORMAT(DetailedCustLedgEntry1."Posting Date");

                        NoofDays := 0;
                        txtData[16] := '';
                        txtData[16] := FORMAT(CustLedgEntry1."Due Date" - DetailedCustLedgEntry1."Posting Date");
                        NoofDays := CustLedgEntry1."Due Date" - DetailedCustLedgEntry1."Posting Date";

                        txtData[15] := '';
                        IF NoofDays >= 0 THEN
                            txtData[15] := FORMAT(TRUE)
                        ELSE
                            txtData[15] := FORMAT(FALSE);



                        txtData[17] := '';
                        txtData[18] := '';
                        txtData[19] := '';
                        txtData[20] := '';
                        CASE CustLedgEntry1."Document Type" OF
                            CustLedgEntry1."Document Type"::Invoice:
                                BEGIN
                                    IF recSalesInvH.GET(CustLedgEntry1."Document No.") THEN
                                        txtData[17] := recSalesInvH."RME Code";
                                    txtData[18] := recSalesInvH."TME Code";
                                    txtData[19] := recSalesInvH."FA Code";
                                    txtData[20] := recSalesInvH."FO Code";
                                END;
                            CustLedgEntry1."Document Type"::"Credit Memo":
                                BEGIN
                                    IF recSalesInvH.GET(CustLedgEntry1."Document No.") THEN
                                        txtData[17] := recSalesCM."RME Code";
                                    txtData[18] := recSalesCM."TME Code";
                                    txtData[19] := recSalesCM."FA Code";
                                    txtData[20] := recSalesCM."FO Code";
                                END;
                        END;

                        txtData[21] := '';
                        IF recCustomer.GET(CustLedgEntry1."Customer No.") THEN
                            txtData[21] := recCustomer.City;

                        //ACXCP


                        ExcelBuf.NewRow;
                        ExcelBuf.AddColumn(stateName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1
                        ExcelBuf.AddColumn("Cust. Ledger Entry"."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
                        ExcelBuf.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
                        ExcelBuf.AddColumn(txtData[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
                        ExcelBuf.AddColumn(txtData[4], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
                        ExcelBuf.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//6
                        ExcelBuf.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//7
                        ExcelBuf.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//8
                        ExcelBuf.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//9
                        ExcelBuf.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//10
                        ExcelBuf.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11
                        ExcelBuf.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//12
                        ExcelBuf.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//13
                        ExcelBuf.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//14
                        ExcelBuf.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//15
                        ExcelBuf.AddColumn(txtData[15], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
                        ExcelBuf.AddColumn(txtData[16], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//17
                        ExcelBuf.AddColumn(txtData[17], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18
                        ExcelBuf.AddColumn(txtData[18], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19
                        ExcelBuf.AddColumn(txtData[19], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
                        ExcelBuf.AddColumn(txtData[20], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//21
                        ExcelBuf.AddColumn(txtData[21], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//22


                        IF blnExportToExcel THEN
                            MakeExcelDataBody;

                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin

                CALCFIELDS("Original Amount");
                RemainingAmount := -"Original Amount";
            end;

            trigger OnPreDataItem()
            begin
                IF blnExportToExcel THEN
                    MakeExcelInfo;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Export to Excel"; blnExportToExcel)
                {
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
        IF blnExportToExcel THEN
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin

        ExcelBuf.DELETEALL;
        blnExportToExcel := TRUE;
    end;

    var
        CompanyInfo: Record 79;
        GLSetup: Record 98;
        Cust: Record 18;
        Currency: Record 4;
        FormatAddr: Codeunit 365;
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        RemainingAmount: Decimal;
        AppliedAmount: Decimal;
        PmtDiscInvCurr: Decimal;
        PmtTolInvCurr: Decimal;
        PmtDiscPmtCurr: Decimal;
        Text003: Label 'Payment Receipt';
        Text004: Label 'Payment Voucher';
        Text006: Label 'Pmt. Disc. Given';
        Text007: Label 'Pmt. Disc. Rcvd.';
        PmtTolPmtCurr: Decimal;
        ShowAmount: Decimal;
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        ReceiptNoCaptionLbl: Label 'Receipt No.';
        CompanyInfoVATRegNoCptnLbl: Label 'GST Reg. No.';
        CustLedgEntry1PostDtCptnLbl: Label 'Posting Date';
        AmountCaptionLbl: Label 'Amount';
        PaymAmtSpecificationCptnLbl: Label 'Payment Amount Specification';
        PmtTolInvCurrCaptionLbl: Label 'Pmt Tol.';
        DocumentDateCaptionLbl: Label 'Document Date';
        CompanyInfoEMailCaptionLbl: Label 'E-Mail';
        CompanyInfoHomePageCptnLbl: Label 'Home Page';
        PaymAmtNotAllocatedCptnLbl: Label 'Payment Amount Not Allocated';
        CustLedgEntryOrgAmtCptnLbl: Label 'Payment Amount';
        ExternalDocumentNoCaptionLbl: Label 'External Document No.';
        "----------------------": Integer;
        recDimValue: Record 349;
        stateName: Text;
        blnExportToExcel: Boolean;
        ExcelBuf: Record 370;
        txtData: array[50] of Text;
        Text002: Label 'Collection Report Customer';
        DetailedCustLedgEntry2: Record 379;
        Description: Text;
        recCLE: Record 21;
        NoofDays: Integer;
        recSalesInvH: Record 112;
        recSalesCM: Record 114;
        CustCity: Integer;
        recCustomer: Record 18;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;

        MakeExcelDataHeader;
    end;

    procedure MakeExcelDataHeader()
    begin

        IF blnExportToExcel THEN
            MakeExcelDataBody;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Collection Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Cust. Ledger Entry".GETFILTERS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('State Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn('Customer No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn('Customer Name.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn('Party Type', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn('Document No. (BR No.) ', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn('Posting Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//6
        ExcelBuf.AddColumn('Document No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//7
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//8
        ExcelBuf.AddColumn('External Doc No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//9
        ExcelBuf.AddColumn('Original Inv Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//10
        ExcelBuf.AddColumn('Original Inv.Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//11
        ExcelBuf.AddColumn('PendingInvAmt before Adj', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//12
        ExcelBuf.AddColumn('Adjusted Amount (Rs.)', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//13
        ExcelBuf.AddColumn('Amount After Adjustment', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//14
        ExcelBuf.AddColumn('Value Date(Bank Receipt Date)', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn('Collection Rec. within due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//17
        ExcelBuf.AddColumn('Collection Receivable Days', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//18
        ExcelBuf.AddColumn('RME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn('TME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn('FA', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//21
        ExcelBuf.AddColumn('FO', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22
        ExcelBuf.AddColumn('City', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22

        IF blnExportToExcel THEN
            MakeExcelDataBody;
    end;

    procedure MakeExcelDataBody()
    var
        y: Integer;
    begin
    end;

    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('','SheetName', 'Collection Report',COMPANYNAME,USERID);
        ExcelBuf.CreateNewBook('SheetName');
        ExcelBuf.WriteSheet('Collection Report', COMPANYNAME, USERID);
        ExcelBuf.CloseBook;
        ExcelBuf.OpenExcel;

        ERROR('');
    end;

    procedure InitializeRequest()
    var
        k: Integer;
    begin
    end;
}

