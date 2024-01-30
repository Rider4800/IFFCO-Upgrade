report 50012 "Vendor Ledger-NW"
{
    DefaultLayout = RDLC;
    //  UsageCategory = ReportsAndAnalysis;
    //  ApplicationArea = All;
    RDLCLayout = '.\ReportLayout\VendorLedgerNW.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            column(CompanyName; recCompanyInfo.Name)
            {
            }
            column(DateRange; txtDateRange)
            {
            }
            column(VendorNo; Vendor."No.")
            {
            }
            column(VendorName; Vendor.Name)
            {
            }
            column(OpeningBalance; decOpeningBalance)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                CalcFields = "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amt. (LCY)", "Amount (LCY)";
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending);
                column(PostingDate; "Vendor Ledger Entry"."Posting Date")
                {
                }
                column(DocumentType; "Vendor Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo; "Vendor Ledger Entry"."Document No.")
                {
                }
                column(Description; "Vendor Ledger Entry".Description)
                {
                }
                column(Currency; "Vendor Ledger Entry"."Currency Code")
                {
                }
                column(DebitAmount; "Vendor Ledger Entry"."Debit Amount (LCY)")
                {
                }
                column(CreditAmount; "Vendor Ledger Entry"."Credit Amount (LCY)")
                {
                }
                column(RemainingAmount; "Vendor Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(VendorInvoiceNo; "Vendor Ledger Entry"."External Document No.")
                {
                }
                column(RunninBalance; decRunningBalance)
                {
                }
                column(Narration; txtNarration)
                {
                }
                column(TotalDebit; decTotalDebit)
                {
                }
                column(TotalCredit; decTotalCredit)
                {
                }
                column(PrintFooter; blnPrintFooter)
                {
                }
                column(Cheque_No; txtCheque)
                {
                }
                column(Cheque_Date; FORMAT(dtChequeDt))
                {
                }
                column(txtPurchComnt; txtPurchComnt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += "Vendor Ledger Entry"."Amount (LCY)";
                    blnPrintFooter := TRUE;

                    txtNarration := '';
                    recPostedNarration.RESET;
                    recPostedNarration.SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type");
                    recPostedNarration.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                    recPostedNarration.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");
                    IF recPostedNarration.FIND('-') THEN
                        REPEAT
                            IF txtNarration = '' THEN
                                txtNarration := recPostedNarration.Narration
                            ELSE
                                txtNarration := txtNarration + ' ' + recPostedNarration.Narration;
                        UNTIL recPostedNarration.NEXT = 0;

                    decTotalDebit += "Vendor Ledger Entry"."Debit Amount (LCY)";
                    decTotalCredit += "Vendor Ledger Entry"."Credit Amount (LCY)";


                    recBankLedgerEntry.RESET;
                    recBankLedgerEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                    IF recBankLedgerEntry.FIND('-') THEN BEGIN
                        txtCheque := recBankLedgerEntry."Cheque No.";
                        dtChequeDt := recBankLedgerEntry."Cheque Date";
                    END;

                    //acxcp begin
                    IF DocumentNo <> "Document No." THEN BEGIN
                        DocumentNo := "Document No.";

                        txtPurchComnt := '';
                        recPurchComnt.RESET;
                        recPurchComnt.SETRANGE("Document Type", recPurchComnt."Document Type"::"Posted Invoice");
                        recPurchComnt.SETRANGE("No.", DocumentNo);
                        IF recPurchComnt.FINDSET THEN
                            REPEAT
                                txtPurchComnt += ' ' + recPurchComnt.Comment;
                            UNTIL recPurchComnt.NEXT = 0;


                        //txtSaleComnt:='';
                        recPurchComnt.RESET;
                        recPurchComnt.SETRANGE("Document Type", recPurchComnt."Document Type"::"Posted Credit Memo");
                        recPurchComnt.SETRANGE("No.", DocumentNo);
                        IF recPurchComnt.FINDSET THEN
                            REPEAT
                                txtPurchComnt += ' ' + recPurchComnt.Comment;
                            UNTIL recPurchComnt.NEXT = 0;
                    END;
                    //acxcp end
                end;

                trigger OnPreDataItem()
                begin
                    "Vendor Ledger Entry".SETRANGE("Posting Date", dtStartDate, dtEndDate);
                    IF txtGlobalDim1Filter <> '' THEN
                        "Vendor Ledger Entry".SETRANGE("Global Dimension 1 Code", txtGlobalDim1Filter);
                    IF txtGlobalDim2Filter <> '' THEN
                        "Vendor Ledger Entry".SETRANGE("Global Dimension 2 Code", txtGlobalDim2Filter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF dtStartDate <> 0D THEN
                    txtDateRange := 'Vendor Ledger for the Period from ' + FORMAT(dtStartDate);

                IF txtDateRange = '' THEN BEGIN
                    IF dtEndDate <> 0D THEN
                        txtDateRange := 'Vendor Ledger up to ' + FORMAT(dtEndDate);
                END ELSE BEGIN
                    IF dtEndDate <> 0D THEN
                        txtDateRange := 'Vendor Ledger for the Period from ' + FORMAT(dtStartDate) + ' to ' + FORMAT(dtEndDate);
                END;

                IF txtDateRange = '' THEN
                    txtDateRange := 'Vendor Ledger';

                blnPrintFooter := FALSE;

                decOpeningBalance := 0;
                IF dtStartDate <> 0D THEN BEGIN
                    recDetVendorLedgerEntry.RESET;
                    recDetVendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Currency Code");
                    recDetVendorLedgerEntry.SETRANGE("Entry Type", recDetVendorLedgerEntry."Entry Type"::"Initial Entry");
                    recDetVendorLedgerEntry.SETRANGE("Posting Date", 0D, dtStartDate - 1);
                    IF txtGlobalDim1Filter <> '' THEN
                        recDetVendorLedgerEntry.SETFILTER("Initial Entry Global Dim. 1", txtGlobalDim1Filter);
                    IF txtGlobalDim2Filter <> '' THEN
                        recDetVendorLedgerEntry.SETFILTER("Initial Entry Global Dim. 2", txtGlobalDim2Filter);
                    recDetVendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                    IF recDetVendorLedgerEntry.FIND('-') THEN BEGIN
                        recDetVendorLedgerEntry.CALCSUMS("Amount (LCY)");
                        decOpeningBalance := recDetVendorLedgerEntry."Amount (LCY)";
                    END;
                END;
                decRunningBalance := decOpeningBalance;
                decTotalDebit := 0;
                decTotalCredit := 0;

                IF decOpeningBalance > 0 THEN
                    decTotalDebit := decOpeningBalance
                ELSE
                    decTotalCredit := decOpeningBalance;
                decTotalCredit := ABS(decTotalCredit);
            end;

            trigger OnPreDataItem()
            begin
                recCompanyInfo.GET;
                IF cdAccountCode <> '' THEN
                    Vendor.SETRANGE("No.", cdAccountCode);
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
                    field(cdAccountCode; cdAccountCode)
                    {
                        Caption = 'Vendor Code';
                        TableRelation = Vendor;
                        ApplicationArea = all;
                    }
                    field(dtStartDate; dtStartDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = all;
                    }
                    field(dtEndDate; dtEndDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = all;
                    }
                    field(txtGlobalDim1Filter; txtGlobalDim1Filter)
                    {
                        ApplicationArea = all;
                        CaptionClass = '1,2,1';
                        Caption = 'Global Dimension 1 Code';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                    }
                    field(txtGlobalDim2Filter; txtGlobalDim2Filter)
                    {
                        ApplicationArea = all;
                        CaptionClass = '1,2,2';
                        Caption = 'Global Dimension 2 Code';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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

    var
        recCompanyInfo: Record 79;
        decOpeningBalance: Decimal;
        decRunningBalance: Decimal;
        recDetVendorLedgerEntry: Record 380;
        txtDateRange: Text[100];
        recPostedNarration: Record "Posted Narration";
        txtNarration: Text[1024];
        decTotalDebit: Decimal;
        decTotalCredit: Decimal;
        rptVoucher: Report "Posted Voucher";
        dtStartDate: Date;
        dtEndDate: Date;
        txtGlobalDim1Filter: Text[1024];
        txtGlobalDim2Filter: Text[1024];
        blnPrintFooter: Boolean;
        cdAccountCode: Code[20];
        recBankLedgerEntry: Record 271;
        txtCheque: Text[20];
        dtChequeDt: Date;
        txtPurchComnt: Text;
        recPurchComnt: Record 43;
        DocumentNo: Code[20];
}

