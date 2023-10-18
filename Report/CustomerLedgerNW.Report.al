report 50011 "Customer Ledger-NW"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerLedgerNW.rdlc';

    dataset
    {
        dataitem(DataItem1000000000; Table18)
        {
            DataItemTableView = SORTING (No.)
                                ORDER(Ascending);
            column(CompanyName; recCompanyInfo.Name)
            {
            }
            column(DateRange; txtDateRange)
            {
            }
            column(CustomerNo; Customer."No.")
            {
            }
            column(CustomerName; CustomerFullName)
            {
            }
            column(OpeningBalance; decOpeningBalance)
            {
            }
            dataitem(DataItem1000000001; Table21)
            {
                CalcFields = Debit Amount (LCY),Credit Amount (LCY),Remaining Amt. (LCY),Amount (LCY);
                DataItemLink = Customer No.=FIELD(No.);
                DataItemTableView = SORTING (Customer No., Posting Date, Currency Code)
                                    ORDER(Ascending);
                column(CustomerCode; "Cust. Ledger Entry"."Customer No.")
                {
                }
                column(PostingDate; "Cust. Ledger Entry"."Posting Date")
                {
                }
                column(DocumentType; "Cust. Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(Description; "Cust. Ledger Entry".Description)
                {
                }
                column(Currency; "Cust. Ledger Entry"."Currency Code")
                {
                }
                column(DebitAmount; "Cust. Ledger Entry"."Debit Amount (LCY)")
                {
                }
                column(CreditAmount; "Cust. Ledger Entry"."Credit Amount (LCY)")
                {
                }
                column(RemainingAmount; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(DueDate; "Cust. Ledger Entry"."Due Date")
                {
                }
                column(CampaignNo; "Cust. Ledger Entry"."Campaign No.")
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
                column(Cheque_No; txtChequeNo)
                {
                }
                column(Cheque_Date; FORMAT(dtCehqueDt))
                {
                }
                column(txtSaleComnt; txtSaleComnt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    decRunningBalance += "Cust. Ledger Entry"."Amount (LCY)";
                    blnPrintFooter := TRUE;

                    txtNarration := '';
                    recPostedNarration.RESET;
                    recPostedNarration.SETRANGE("Document Type", "Cust. Ledger Entry"."Document Type");
                    recPostedNarration.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
                    recPostedNarration.SETRANGE("Posting Date", "Cust. Ledger Entry"."Posting Date");
                    IF recPostedNarration.FIND('-') THEN
                        REPEAT
                            IF txtNarration = '' THEN
                                txtNarration := recPostedNarration.Narration
                            ELSE
                                txtNarration := txtNarration + ' ' + recPostedNarration.Narration;
                        UNTIL recPostedNarration.NEXT = 0;

                    decTotalDebit += "Cust. Ledger Entry"."Debit Amount (LCY)";
                    decTotalCredit += "Cust. Ledger Entry"."Credit Amount (LCY)";

                    recBankLedgerEntry.RESET;
                    recBankLedgerEntry.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
                    IF recBankLedgerEntry.FIND('-') THEN BEGIN
                        txtChequeNo := recBankLedgerEntry."Cheque No.";
                        dtCehqueDt := recBankLedgerEntry."Cheque Date";
                    END;

                    //acxcp begin
                    IF DocumentNo <> "Document No." THEN BEGIN
                        DocumentNo := "Document No.";

                        txtSaleComnt := '';
                        recSalesComnt.RESET;
                        recSalesComnt.SETRANGE("Document Type", recSalesComnt."Document Type"::"Posted Invoice");
                        recSalesComnt.SETRANGE("No.", DocumentNo);
                        IF recSalesComnt.FINDSET THEN
                            REPEAT
                                txtSaleComnt += ' ' + recSalesComnt.Comment;
                            UNTIL recSalesComnt.NEXT = 0;


                        //txtSaleComnt:='';
                        recSalesComnt.RESET;
                        recSalesComnt.SETRANGE("Document Type", recSalesComnt."Document Type"::"Posted Credit Memo");
                        recSalesComnt.SETRANGE("No.", DocumentNo);
                        IF recSalesComnt.FINDSET THEN
                            REPEAT
                                txtSaleComnt += ' ' + recSalesComnt.Comment;
                            UNTIL recSalesComnt.NEXT = 0;
                    END;
                    //acxcp end
                end;

                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".SETRANGE("Posting Date", dtStartDate, dtEndDate);
                    IF txtGlobalDim1Filter <> '' THEN
                        "Cust. Ledger Entry".SETRANGE("Global Dimension 1 Code", txtGlobalDim1Filter);
                    IF txtGlobalDim2Filter <> '' THEN
                        "Cust. Ledger Entry".SETRANGE("Global Dimension 2 Code", txtGlobalDim2Filter);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                IF dtStartDate <> 0D THEN
                    txtDateRange := 'Customer Ledger for the Period from ' + FORMAT(dtStartDate);

                IF txtDateRange = '' THEN BEGIN
                    IF dtEndDate <> 0D THEN
                        txtDateRange := 'Customer Ledger up to ' + FORMAT(dtEndDate);
                END ELSE BEGIN
                    IF dtEndDate <> 0D THEN
                        txtDateRange := 'Customer Ledger for the Period from ' + FORMAT(dtStartDate) + ' to ' + FORMAT(dtEndDate);
                END;

                IF txtDateRange = '' THEN
                    txtDateRange := 'Customer Ledger';

                blnPrintFooter := FALSE;

                //acxcp+ //15092021
                IF cdAccountCode <> '' THEN
                    Customer.SETRANGE("No.", cdAccountCode);
                IF Customer.FINDFIRST THEN BEGIN
                    CustomerFullName := Customer.Name + '' + Customer."Name 2" + '' + Customer."Name 3";
                END;
                //acxcp-

                decOpeningBalance := 0;
                IF dtStartDate <> 0D THEN BEGIN
                    recDetCustLedgerEntry.RESET;
                    recDetCustLedgerEntry.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Currency Code");
                    recDetCustLedgerEntry.SETRANGE("Entry Type", recDetCustLedgerEntry."Entry Type"::"Initial Entry");
                    recDetCustLedgerEntry.SETRANGE("Posting Date", 0D, dtStartDate - 1);
                    IF txtGlobalDim1Filter <> '' THEN
                        recDetCustLedgerEntry.SETFILTER("Initial Entry Global Dim. 1", txtGlobalDim1Filter);
                    IF txtGlobalDim2Filter <> '' THEN
                        recDetCustLedgerEntry.SETFILTER("Initial Entry Global Dim. 2", txtGlobalDim2Filter);
                    recDetCustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
                    IF recDetCustLedgerEntry.FIND('-') THEN BEGIN
                        recDetCustLedgerEntry.CALCSUMS("Amount (LCY)");
                        decOpeningBalance := recDetCustLedgerEntry."Amount (LCY)";
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
                    Customer.SETRANGE("No.", cdAccountCode);
                CustomerFullName := Customer.Name + '' + Customer."Name 2" + '' + Customer."Name 3";
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
                        Caption = 'Customer Code';
                        TableRelation = Customer;
                    }
                    field(dtStartDate; dtStartDate)
                    {
                        Caption = 'From Date';
                    }
                    field(dtEndDate; dtEndDate)
                    {
                        Caption = 'To Date';
                    }
                    field(txtGlobalDim1Filter; txtGlobalDim1Filter)
                    {
                        CaptionClass = '1,2,1';
                        Caption = 'Global Dimension 1 Code';
                        TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                    }
                    field(txtGlobalDim2Filter; txtGlobalDim2Filter)
                    {
                        CaptionClass = '1,2,2';
                        Caption = 'Global Dimension 2 Code';
                        TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
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
        recCompanyInfo: Record "79";
        decOpeningBalance: Decimal;
        decRunningBalance: Decimal;
        recDetCustLedgerEntry: Record "379";
        txtDateRange: Text[100];
        recPostedNarration: Record "16548";
        txtNarration: Text[1024];
        decTotalDebit: Decimal;
        decTotalCredit: Decimal;
        rptVoucher: Report "16567";
        dtStartDate: Date;
        dtEndDate: Date;
        txtGlobalDim1Filter: Text[1024];
        txtGlobalDim2Filter: Text[1024];
        blnPrintFooter: Boolean;
        cdAccountCode: Code[20];
        recBankLedgerEntry: Record "271";
        txtChequeNo: Text[20];
        dtCehqueDt: Date;
        txtSaleComnt: Text;
        recSalesComnt: Record "44";
        DocumentNo: Code[20];
        CustomerFullName: Text;
        recCust: Record "18";
}

