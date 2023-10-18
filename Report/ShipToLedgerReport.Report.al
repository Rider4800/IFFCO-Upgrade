report 50039 "ShipToLedger-Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ShipToLedgerReport.rdlc';

    dataset
    {
        dataitem(DataItem1000000015; Table222)
        {
            column(dcOpBal; dcOpBal)
            {
            }
            column(dcRunningBal; dcRunningBal)
            {
            }
            column(Text001; Text001)
            {
            }
            dataitem(DataItem1000000000; Table21)
            {
                CalcFields = Debit Amount (LCY),Credit Amount (LCY),Remaining Amt. (LCY),Amount (LCY);
                DataItemLink = Customer No.=FIELD(Customer No.),
                               Ship-to Code=FIELD(Code);
                DataItemTableView = SORTING(Campaign No.,Customer No.);
                column(dcRemainingAmt;dcRemainingAmt)
                {
                }
                column(CompName;recCompInfo.Name)
                {
                }
                column(ReportFilters;ReportFilters)
                {
                }
                column(EntryNo;"Cust. Ledger Entry"."Entry No.")
                {
                }
                column(ShipToCode;"Cust. Ledger Entry"."Ship-to Code")
                {
                }
                column(ShipToName;ShipToName)
                {
                }
                column(SellToCustomerNo;"Cust. Ledger Entry"."Sell-to Customer No.")
                {
                }
                column(BilltoName;BilltoName)
                {
                }
                column(DocType;"Cust. Ledger Entry"."Document Type")
                {
                }
                column(DocNO;"Cust. Ledger Entry"."Document No.")
                {
                }
                column(PostingDateCLE;"Cust. Ledger Entry"."Posting Date")
                {
                }
                column(CleDescription;"Cust. Ledger Entry".Description)
                {
                }
                column(DueDate;"Cust. Ledger Entry"."Due Date")
                {
                }
                column(Amount_CustLedgerEntry;"Cust. Ledger Entry".Amount)
                {
                }
                column(AmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Amount (LCY)")
                {
                }
                column(OriginalAmtLCY_CustLedgerEntry;"Cust. Ledger Entry"."Original Amt. (LCY)")
                {
                }
                column(RemainingAmtLCY_CustLedgerEntry;"Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(DebitAmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Credit Amount (LCY)")
                {
                }
                column(Stdate;Stdate)
                {
                }
                column(EndDate;EndDate)
                {
                }
                column(txtNarration;txtNarration)
                {
                }
                column(dcRuningBalAmt;dcRuningBalAmt)
                {
                }
                column(dcDebitAmt;dcDebitAmt)
                {
                }
                column(dcCreditAmt;dcCreditAmt)
                {
                }
                column(dcRemAmt;dcRemAmt)
                {
                }
                dataitem(DataItem1170000002;Table379)
                {
                    DataItemLink = Cust. Ledger Entry No.=FIELD(Entry No.),
                                   Customer No.=FIELD(Customer No.);
                    DataItemTableView = SORTING(Entry No.);
                    column(dcRemCrd;dcRemCrd)
                    {
                    }
                    column(EntryNo_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Entry No.")
                    {
                    }
                    column(EntryType_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Entry Type")
                    {
                    }
                    column(PostingDate_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Posting Date")
                    {
                    }
                    column(DocumentType_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Document Type")
                    {
                    }
                    column(DocumentNo_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Document No.")
                    {
                    }
                    column(AmountLCY_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Amount (LCY)")
                    {
                    }
                    column(TransactionNo_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Transaction No.")
                    {
                    }
                    column(JournalBatchName_DetailedCustLedgEntry;"Detailed Cust. Ledg. Entry"."Journal Batch Name")
                    {
                    }
                    column(DebitAmountLCY_DetailedCustLedgEntry;ABS("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)"))
                    {
                    }
                    column(CreditAmountLCY_DetailedCustLedgEntry;ABS("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)"))
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    //Stdate:="Cust. Ledger Entry".GETRANGEMIN("Posting Date");
                    //EndDate:="Cust. Ledger Entry".GETRANGEMAX("Posting Date");
                    //"Cust. Ledger Entry".SETFILTER("Ship-to Code",'%1',ShipToCode);

                    //dcRuningBalAmt+="Cust. Ledger Entry"."Amount (LCY)";

                    IF Stdate<>0D THEN BEGIN
                      recDCLE.RESET();
                      recDCLE.SETRANGE("Entry Type",recDCLE."Entry Type"::"Initial Entry");
                      recDCLE.SETRANGE("Posting Date",0D, Stdate-1);
                      recDCLE.SETRANGE("Customer No.","Customer No.");
                      IF recDCLE.FIND('-') THEN BEGIN
                        recDCLE.CALCSUMS("Amount (LCY)");
                        dcOpBal:=recDCLE."Amount (LCY)";
                      END;
                    END;

                    "Cust. Ledger Entry".CALCFIELDS("Cust. Ledger Entry"."Amount (LCY)");
                    dcRunningBal+="Cust. Ledger Entry"."Amount (LCY)";


                    //dcRunningBal+="Cust. Ledger Entry"."Amount (LCY)";

                    dcRemainingAmt:=0;
                    IF Stdate<>0D THEN BEGIN
                      recCLE.RESET();
                      recCLE.SETRANGE("Customer No.","Customer No.");
                      recCLE.SETRANGE("Ship-to Code","Ship-to Code");
                      recCLE.SETRANGE("Posting Date",0D,Stdate-1);
                      IF recCLE.FINDSET THEN
                        REPEAT
                          //recCLE.CALCSUMS("Remaining Amt. (LCY)");
                          recCLE.CALCFIELDS("Remaining Amt. (LCY)");
                          dcRemainingAmt+=recCLE."Remaining Amt. (LCY)";
                       UNTIL recCLE.NEXT=0;
                     END;

                    "Cust. Ledger Entry".CALCFIELDS("Amount (LCY)");
                    dcRemAmt+="Cust. Ledger Entry"."Amount (LCY)";



                    dcDebitAmt:=0;
                    IF Stdate<>0D THEN BEGIN
                      recCLE.RESET();
                      recCLE.SETRANGE("Customer No.","Customer No.");
                      recCLE.SETRANGE("Ship-to Code","Ship-to Code");
                      recCLE.SETRANGE("Posting Date",Stdate,EndDate);
                      IF recCLE.FINDFIRST THEN BEGIN
                          recCLE.CALCFIELDS("Debit Amount (LCY)");
                          dcDebitAmt:=recCLE."Debit Amount (LCY)";
                        END;
                    END;

                    dcCreditAmt:=0;
                    IF Stdate<>0D THEN BEGIN
                      recCLE.RESET();
                      recCLE.SETRANGE("Customer No.","Customer No.");
                      recCLE.SETRANGE("Ship-to Code","Ship-to Code");
                      recCLE.SETRANGE("Posting Date",Stdate,EndDate);
                      IF recCLE.FINDFIRST THEN BEGIN
                          recCLE.CALCFIELDS("Credit Amount (LCY)");
                          dcCreditAmt:=recCLE."Credit Amount (LCY)";
                        END;
                    END;

                    dcRuningBalAmt:=0;
                    //dcRuningBalAmt:=dcRuningBalAmt+dcRemAmt+"Cust. Ledger Entry"."Debit Amount (LCY)"-"Cust. Ledger Entry"."Credit Amount (LCY)";
                    dcRuningBalAmt:=dcRuningBalAmt+("Cust. Ledger Entry"."Debit Amount (LCY)"-"Cust. Ledger Entry"."Credit Amount (LCY)");


                    ShipToName:='';
                    recShiptoaddress.SETRANGE(Code,ShipToCode);
                    recShiptoaddress.SETRANGE("Customer No.","Customer No.");
                    IF recShiptoaddress.FINDFIRST THEN BEGIN
                        ShipToName:=recShiptoaddress.Name;
                      END;

                    BilltoName:='';
                    IF "Cust. Ledger Entry"."Ship-to Code"<>'' THEN BEGIN
                    recCustomer.SETRANGE("No.","Cust. Ledger Entry"."Customer No.");
                      IF recCustomer.FINDFIRST THEN BEGIN
                          BilltoName:=recCustomer.Name;
                        END;
                    END;

                    txtNarration := '';
                    recPostedNarration.RESET;
                    recPostedNarration.SETRANGE("Document Type", "Cust. Ledger Entry"."Document Type");
                    recPostedNarration.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
                    recPostedNarration.SETRANGE("Posting Date", "Cust. Ledger Entry"."Posting Date");
                    IF recPostedNarration.FIND('-') THEN REPEAT
                      IF txtNarration = '' THEN
                        txtNarration := recPostedNarration.Narration
                      ELSE
                        txtNarration := txtNarration + ' ' + recPostedNarration.Narration;
                    UNTIL recPostedNarration.NEXT = 0;
                end;

                trigger OnPreDataItem()
                begin
                    recCompInfo.GET();
                    "Cust. Ledger Entry".SETFILTER("Posting Date",'%1..%2',Stdate,EndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                dcOpBal:=0;
                dcRunningBal:=0;
            end;

            trigger OnPreDataItem()
            begin
                "Ship-to Address".SETFILTER(Code,ShipToCode);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ShipToCode;ShipToCode)
                {
                    Caption = 'ShipToCode';
                    TableRelation = "Ship-to Address".Code;
                }
                field(Stdate;Stdate)
                {
                }
                field(EndDate;EndDate)
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

    trigger OnPreReport()
    begin
        ReportFilters:="Cust. Ledger Entry".GETFILTERS;
    end;

    var
        recShiptoaddress: Record "222";
        recCustomer: Record "18";
        ReportFilters: Text[250];
        ShipToCode: Code[10];
        recDCLE: Record "379";
        dcOpBal: Decimal;
        dcRunningBal: Decimal;
        Stdate: Date;
        EndDate: Date;
        recCompInfo: Record "79";
        Text001: Label 'Customer Ledger for the Period from -';
        ShipToName: Text;
        BilltoName: Text;
        txtNarration: Text;
        recPostedNarration: Record "16548";
        dcRemainingAmt: Decimal;
        recCLE: Record "21";
        dcRemAmt: Decimal;
        dcRuningBalAmt: Decimal;
        dcDebitAmt: Decimal;
        dcCreditAmt: Decimal;
        dcRemCrd: Decimal;
}

