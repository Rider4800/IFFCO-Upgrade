report 50014 "Customer Ledger Bal Confrm."
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\CustomerLedgerBalConfrm.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; 18)
        {
            DataItemTableView = SORTING("No.")
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
            column(CustomerName; Customer.Name)
            {
            }
            column(Name2_Customer; Customer."Name 2")
            {
            }
            column(Address_Customer; Customer.Address)
            {
            }
            column(Address2_Customer; Customer."Address 2")
            {
            }
            column(City_Customer; Customer.City)
            {
            }
            column(StateCode_Customer; Customer."State Code")
            {
            }
            column(PhoneNo_Customer; Customer."Phone No.")
            {
            }
            column(GSTRNo_Cust; Customer."GST Registration No.")
            {
            }
            column(Contact_Customer; Customer.Contact)
            {
            }
            column(OpeningBalance; decOpeningBalance)
            {
            }
            column(RegisterAddr1; RegisterAddr[1])
            {
            }
            column(RegisterAddr2; RegisterAddr[2])
            {
            }
            column(RegisterAddr3; RegisterAddr[3])
            {
            }
            column(RegisterAddr4; RegisterAddr[4])
            {
            }
            column(RegisterAddr5; RegisterAddr[5])
            {
            }
            column(RegisterAddr6; RegisterAddr[6])
            {
            }
            column(RegisterAddr7; RegisterAddr[7])
            {
            }
            column(RegisterAddr8; RegisterAddr[8])
            {
            }
            column(Reg_LicNo; RegisterAddr[9])
            {
            }
            column(InputDate; FORMAT(dtInputDate))
            {
            }
            column(TME_Name; TMEName)
            {
            }
            column(FA_name; FAname)
            {
            }
            dataitem("Cust. Ledger Entry"; 21)
            {
                CalcFields = "Debit Amount (LCY)", "Credit Amount (LCY)", "Remaining Amt. (LCY)", "Amount (LCY)";
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
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

                RegisterAddr[1] := '';
                RegisterAddr[2] := '';
                RegisterAddr[3] := '';
                RegisterAddr[4] := '';
                RegisterAddr[5] := '';
                RegisterAddr[6] := '';
                RegisterAddr[7] := '';
                RegisterAddr[8] := '';
                RegisterAddr[9] := '';


                recResCntr.RESET;
                recResCntr.SETRANGE(Code, Customer."Responsibility Center");
                IF recResCntr.FINDFIRST THEN BEGIN
                    RegisterAddr[1] := recResCntr."Reg. Company Name";
                    RegisterAddr[2] := recResCntr."Reg. Address1";
                    RegisterAddr[3] := recResCntr."Reg. Address2";
                    RegisterAddr[4] := recResCntr."Reg. City";
                    RegisterAddr[5] := recResCntr."Reg. State Code";
                    RegisterAddr[6] := recResCntr."Reg. Post Code";
                    RegisterAddr[7] := recResCntr."Reg. CIN No.";
                    RegisterAddr[8] := recResCntr."Reg. GST/UIN No.";
                    RegisterAddr[9] := recResCntr."Reg. Lic. No.";
                    //RegisterAddr[9]:=recResCntr.


                END;

                FAname := '';
                // IF cdAccountCode <> '' THEN
                //  Customer.SETRANGE("No.", cdAccountCode);
                //  IF Customer.FINDFIRST THEN  BEGIN
                //IF cdFA<>'' THEN BEGIN
                recDefaultDim.SETFILTER("Table ID", '%1', 18);
                recDefaultDim.SETRANGE("No.", Customer."No.");
                recDefaultDim.SETFILTER("Dimension Code", '%1', 'FA HQ');
                // recDefaultDim.SETFILTER("Dimension Value Code",'%1',cdFA);
                IF recDefaultDim.FINDFIRST THEN BEGIN
                    //FAname:=recDefaultDim."Dimension Value Code";
                    recDimValue.RESET;
                    recDimValue.SETRANGE(Code, recDefaultDim."Dimension Value Code");
                    IF recDimValue.FINDFIRST THEN BEGIN
                        FAname := recDimValue.Name;
                    END;
                END;
                //END;

                TMEName := '';
                // IF cdAccountCode <> '' THEN
                //  Customer.SETRANGE("No.", cdAccountCode);
                //  IF Customer.FINDFIRST THEN  BEGIN
                //IF cdTME<>'' THEN BEGIN
                recDefaultDim.SETFILTER("Table ID", '%1', 18);
                recDefaultDim.SETRANGE("No.", Customer."No.");
                recDefaultDim.SETFILTER("Dimension Code", '%1', 'TME HQ');
                // recDefaultDim.SETFILTER("Dimension Value Code",'%1',cdTME);
                IF recDefaultDim.FINDFIRST THEN BEGIN
                    recDimValue.RESET;
                    recDimValue.SETRANGE(Code, recDefaultDim."Dimension Value Code");
                    IF recDimValue.FINDFIRST THEN BEGIN
                        TMEName := recDimValue.Name;
                    END;
                END;
                //END;


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


                IF cdCustPG <> '' THEN
                    Customer.SETRANGE("Customer Posting Group", cdCustPG);

                //IF cdFA<>'' THEN BEGIN
                recDefaultDim.SETFILTER("Table ID", '%1', 18);
                recDefaultDim.SETRANGE("No.", Customer."No.");
                //END;
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
                    field(cdCustPG; cdCustPG)
                    {
                        Caption = 'Cust. Posting Group';
                        TableRelation = "Customer Posting Group";
                    }
                    field(txtGlobalDim1Filter; txtGlobalDim1Filter)
                    {
                        CaptionClass = '1,2,1';
                        Caption = 'Global Dimension 1 Code';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                    }
                    field(txtGlobalDim2Filter; txtGlobalDim2Filter)
                    {
                        CaptionClass = '1,2,2';
                        Caption = 'Global Dimension 2 Code';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                    }
                    field(dtInputDate; dtInputDate)
                    {
                        Caption = 'Input_Date';
                    }
                    field(cdFA; cdFA)
                    {
                        Caption = 'FA HQ';
                    }
                    field(cdTME; cdTME)
                    {
                        Caption = 'TME HQ';
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
        recDetCustLedgerEntry: Record 379;
        txtDateRange: Text[100];
        recPostedNarration: Record "Posted Narration";
        txtNarration: Text;
        decTotalDebit: Decimal;
        decTotalCredit: Decimal;
        rptVoucher: Report "Posted Voucher";
        dtStartDate: Date;
        dtEndDate: Date;
        txtGlobalDim1Filter: Text;
        txtGlobalDim2Filter: Text;
        blnPrintFooter: Boolean;
        cdAccountCode: Code[20];
        recBankLedgerEntry: Record 271;
        txtChequeNo: Text[20];
        dtCehqueDt: Date;
        txtSaleComnt: Text;
        recSalesComnt: Record 44;
        DocumentNo: Code[20];
        recResCntr: Record 5714;
        RegisterAddr: array[20] of Text;
        dtInputDate: Date;
        FAname: Text;
        TMEName: Text;
        recSalesHierarchy: Record 50014;
        cdCustPG: Code[20];
        cdSalePerson: Code[20];
        recDefaultDim: Record 352;
        cdFA: Code[20];
        cdFO: Code[20];
        cdRME: Code[20];
        cdTME: Code[20];
        recDimValue: Record 349;
}

