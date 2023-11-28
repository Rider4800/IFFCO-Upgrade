report 50049 "Calculate CD"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; 379)
        {
            DataItemTableView = WHERE("Scheme Calculated" = CONST(false),
                                      "Initial Document Type" = CONST(Invoice),
                                      Unapplied = CONST(false));

            trigger OnAfterGetRecord()
            begin
                IF dtPaymentTillDate <> 0D THEN
                    "Detailed Cust. Ledg. Entry".SETFILTER("Posting Date", '<=%1', dtPaymentTillDate);

                IF CustCode <> '' THEN
                    "Detailed Cust. Ledg. Entry".SETFILTER("Customer No.", '%1', CustCode);

                IF CDDiscountGroup <> '' THEN BEGIN
                    recCust.RESET();
                    recCust.SETRANGE("No.", "Detailed Cust. Ledg. Entry"."Customer No.");
                    recCust.SETRANGE("Customer Disc. Group", CDDiscountGroup);
                END;

                IF Warehouse <> '' THEN
                    "Detailed Cust. Ledg. Entry".SETRANGE("Initial Entry Global Dim. 1", Warehouse);

                recCustLedger.RESET();
                recCustLedger.SETRANGE("Entry No.", "Detailed Cust. Ledg. Entry"."Applied Cust. Ledger Entry No.");
                recCustLedger.SETFILTER("Document Type", '<>%1', recCustLedger."Document Type"::Invoice);
                IF CDDiscountGroup <> '' THEN
                    recCustLedger.SETRANGE("Customer No.", recCust."No.");
                IF recCustLedger.FINDFIRST THEN BEGIN
                    InsCalCD.RESET();
                    InsCalCD.SETRANGE("Customer No.", recCustLedger."Customer No.");
                    InsCalCD.SETRANGE("Payment No.", recCustLedger."Document No.");
                    InsCalCD.SETRANGE("Dt. Cust. Led. Entry", "Detailed Cust. Ledg. Entry"."Entry No.");
                    IF NOT (InsCalCD.FINDFIRST) AND (recCustLedger."Document Type" = recCustLedger."Document Type"::Payment) THEN BEGIN
                        InsCalCD.INIT();
                        InsCalCD."Customer No." := recCustLedger."Customer No.";
                        InsCalCD."Payment No." := recCustLedger."Document No.";
                        InsCalCD."Payment Date" := recCustLedger."Posting Date";
                        recCustLedger.CALCFIELDS(Amount);
                        InsCalCD."Payment Amount" := ABS(recCustLedger.Amount);
                        InsCalCD."Dt. Cust. Led. Entry" := "Detailed Cust. Ledg. Entry"."Entry No.";
                        InsCalCD.INSERT(TRUE);
                        recCust.RESET();
                        recCust.SETRANGE("No.", recCustLedger."Customer No.");
                        IF recCust.FINDFIRST THEN BEGIN
                            InsCalCD."Customer Name" := recCust.Name;
                            InsCalCD."Customer Disc. Group" := recCust."Customer Disc. Group";
                            InsCalCD."Customer Posting Group" := recCust."Customer Posting Group";
                            InsCalCD.MODIFY();
                        END;
                        recCustLedger.RESET();
                        recCustLedger.SETRANGE("Entry No.", "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                        recCustLedger.SETRANGE("Customer No.", "Detailed Cust. Ledg. Entry"."Customer No.");
                        //recCustLedger.SETRANGE("Document Type",recCustLedger."Document Type"::Payment);
                        IF (recCustLedger.FINDFIRST) AND (InsCalCD."Payment Date" <= recCustLedger."Due Date") THEN BEGIN
                            InsCalCD."Invoice No." := recCustLedger."Document No.";
                            InsCalCD."Invoice Date" := recCustLedger."Posting Date";
                            InsCalCD."Invoince Due Date" := recCustLedger."Due Date";
                            recCustLedger.CALCFIELDS(Amount);
                            InsCalCD."Invoice Amount" := recCustLedger.Amount;
                            InsCalCD."Adjusted Amount With Tax" := "Detailed Cust. Ledg. Entry".Amount;
                            InsCalCD."Adjusted Amount" := "Detailed Cust. Ledg. Entry".Amount;
                            InsCalCD."State Code" := recCustLedger."Global Dimension 1 Code";
                            InsCalCD."Warehouse code" := recCustLedger."Global Dimension 2 Code";
                            InsCalCD.MODIFY();
                        END ELSE BEGIN
                            InsCalCD."Invoice No." := recCustLedger."Document No.";
                            InsCalCD."Invoice Date" := recCustLedger."Posting Date";
                            InsCalCD."Invoince Due Date" := recCustLedger."Due Date";
                            InsCalCD."State Code" := recCustLedger."Global Dimension 1 Code";
                            InsCalCD."Warehouse code" := recCustLedger."Global Dimension 2 Code";
                            InsCalCD.MODIFY();
                        END;
                        recPostedScheme.RESET();
                        recPostedScheme.SETRANGE("Document No.", recCustLedger."Document No.");
                        IF recPostedScheme.FINDFIRST THEN BEGIN
                            InsCalCD.VALIDATE("Order Priority", recPostedScheme."OrderPriority Scheme");
                            InsCalCD.VALIDATE("Scheme Code", recPostedScheme."Scheme Code");
                            IF recPostedScheme."Tax Charge Code" = 'CD' THEN
                                InsCalCD."Invoice CD Amount" := recPostedScheme."Discount Amount";
                            InsCalCD.MODIFY();
                        END;
                        recSalesInvoiceLine.RESET();
                        recSalesInvoiceLine.SETRANGE("Document No.", InsCalCD."Invoice No.");
                        IF recSalesInvoiceLine.FINDFIRST THEN BEGIN
                            REPEAT
                                InsCalCD."Invoice Amt. Exclud GST" += CU50200.GetAmttoCustomerPostedLine(recSalesInvoiceLine."Document No.", recSalesInvoiceLine."Line No.") - (CU50200.GetTotalGSTAmtPostedLine(recSalesInvoiceLine."Document No.", recSalesInvoiceLine."Line No."));
                                InsCalCD."Taxes & Charges Amount" += CU50200.GetTotalGSTAmtPostedLine(recSalesInvoiceLine."Document No.", recSalesInvoiceLine."Line No.");
                            UNTIL recSalesInvoiceLine.NEXT = 0;
                            InsCalCD.MODIFY();
                        END;

                        IF (InsCalCD."Payment Date" <> 0D) AND (InsCalCD."Invoince Due Date" <> 0D) AND (InsCalCD."Invoice Amount" <> 0) THEN BEGIN
                            IF InsCalCD."Payment Date" - InsCalCD."Invoince Due Date" <= 0 THEN
                                InsCalCD."CD Days" := ABS(InsCalCD."Payment Date" - InsCalCD."Invoince Due Date")
                            ELSE
                                InsCalCD."CD Days" := -(InsCalCD."Payment Date" - InsCalCD."Invoince Due Date");
                        END;
                        //InsCalCD."Rate of CD" := UpdateCDInfo(InsCalCD."Invoice Date",InsCalCD."CD Days",CD); Ps03092021 change logic from due date
                        IF (InsCalCD."Invoince Due Date" <> 0D) AND (InsCalCD."Invoice Amount" <> 0) THEN
                            InsCalCD."Rate of CD" := UpdateCDInfo(InsCalCD."Invoince Due Date", InsCalCD."CD Days", CD); //PS03092021 change logic from due date
                        InsCalCD.Date := WORKDATE;
                        //InsCalCD."CD Calculated On Amount" := InsCalCD."Invoice Amt. Exclud GST" - InsCalCD."Invoice CD Amount";
                        dectaxamt := 0;
                        dectaxamt := CheckTaxAmt(InsCalCD."Invoice No.");
                        IF dectaxamt = 0 THEN BEGIN
                            IF (ABS(InsCalCD."Adjusted Amount") - InsCalCD."Taxes & Charges Amount") <= 0 THEN BEGIN
                                InsCalCD."CD Calculated On Amount" := 0;
                                InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                            END ELSE BEGIN
                                InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - InsCalCD."Taxes & Charges Amount");
                                InsCalCD."Taxes & Charges Amt Adj" := InsCalCD."Taxes & Charges Amount";
                            END;
                        END ELSE BEGIN
                            decBaltax := 0;
                            IF InsCalCD."Taxes & Charges Amount" - dectaxamt >= 0 THEN BEGIN
                                decBaltax := InsCalCD."Taxes & Charges Amount" - dectaxamt;
                                IF (ABS(InsCalCD."Adjusted Amount") - decBaltax) <= 0 THEN BEGIN
                                    InsCalCD."CD Calculated On Amount" := 0;
                                    InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                                END ELSE BEGIN
                                    InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - decBaltax);
                                    InsCalCD."Taxes & Charges Amt Adj" := decBaltax;
                                END;
                            END ELSE
                                InsCalCD."CD Calculated On Amount" := ABS(InsCalCD."Adjusted Amount");
                        END;
                        InsCalCD."CD to be Given" := ROUND(((InsCalCD."CD Calculated On Amount") * InsCalCD."Rate of CD") / 100, 0.01);
                        InsCalCD."CD Amount" := (InsCalCD."CD to be Given" - InsCalCD."Invoice CD Amount");
                        InsCalCD.MODIFY();
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF dtPaymentTillDate = 0D THEN
                    ERROR('Payment till date should not be blank');
            end;
        }
        dataitem(AdvancePayment; 379)
        {
            DataItemTableView = WHERE("Scheme Calculated" = CONST(false),
                                      "Initial Document Type" = CONST(Payment),
                                      Unapplied = CONST(false),
                                      "Applied Cust. Ledger Entry No." = FILTER(<> 0));

            trigger OnAfterGetRecord()
            var
                CustL: Record 21;
            begin
                IF dtPaymentTillDate <> 0D THEN
                    AdvancePayment.SETFILTER("Posting Date", '<=%1', dtPaymentTillDate);

                IF CustCode <> '' THEN
                    AdvancePayment.SETFILTER("Customer No.", '%1', CustCode);

                IF CDDiscountGroup <> '' THEN BEGIN
                    recCust.RESET();
                    recCust.SETRANGE("No.", AdvancePayment."Customer No.");
                    recCust.SETRANGE("Customer Disc. Group", CDDiscountGroup);
                END;

                IF Warehouse <> '' THEN
                    AdvancePayment.SETRANGE("Initial Entry Global Dim. 1", Warehouse);

                recCustLedger.RESET();
                recCustLedger.SETRANGE("Entry No.", AdvancePayment."Applied Cust. Ledger Entry No.");
                recCustLedger.SETFILTER("Document Type", '%1', recCustLedger."Document Type"::Invoice);
                IF CDDiscountGroup <> '' THEN
                    recCustLedger.SETRANGE("Customer No.", recCust."No.");
                IF recCustLedger.FINDFIRST THEN BEGIN
                    CustL.RESET();
                    CustL.SETRANGE("Entry No.", AdvancePayment."Cust. Ledger Entry No.");
                    CustL.SETRANGE("Document Type", CustL."Document Type"::Payment);
                    IF CustL.FINDFIRST THEN BEGIN
                        InsCalCD.RESET();
                        InsCalCD.SETRANGE("Customer No.", CustL."Customer No.");
                        InsCalCD.SETRANGE("Payment No.", CustL."Document No.");
                        InsCalCD.SETRANGE("Dt. Cust. Led. Entry", AdvancePayment."Entry No.");
                        IF NOT InsCalCD.FINDFIRST THEN BEGIN
                            InsCalCD.INIT();
                            InsCalCD."Customer No." := CustL."Customer No.";
                            InsCalCD."Payment No." := CustL."Document No.";
                            InsCalCD."Payment Date" := CustL."Posting Date";
                            CustL.CALCFIELDS(Amount);
                            InsCalCD."Payment Amount" := ABS(CustL.Amount);
                            InsCalCD."Dt. Cust. Led. Entry" := AdvancePayment."Entry No.";
                            InsCalCD.INSERT(TRUE);
                            recCust.RESET();
                            recCust.SETRANGE("No.", CustL."Customer No.");
                            IF recCust.FINDFIRST THEN BEGIN
                                InsCalCD."Customer Name" := recCust.Name;
                                InsCalCD."Customer Disc. Group" := recCust."Customer Disc. Group";
                                InsCalCD."Customer Posting Group" := recCust."Customer Posting Group";
                                InsCalCD.MODIFY();
                            END;
                            recCustLedger.RESET();
                            recCustLedger.SETRANGE("Entry No.", AdvancePayment."Applied Cust. Ledger Entry No.");
                            recCustLedger.SETRANGE("Customer No.", AdvancePayment."Customer No.");
                            //recCustLedger.SETRANGE("Document Type",recCustLedger."Document Type"::Payment);
                            IF (recCustLedger.FINDFIRST) AND (InsCalCD."Payment Date" <= recCustLedger."Due Date") THEN BEGIN
                                InsCalCD."Invoice No." := recCustLedger."Document No.";
                                InsCalCD."Invoice Date" := recCustLedger."Posting Date";
                                InsCalCD."Invoince Due Date" := recCustLedger."Due Date";
                                recCustLedger.CALCFIELDS(Amount);
                                InsCalCD."Invoice Amount" := recCustLedger.Amount;
                                InsCalCD."Adjusted Amount With Tax" := AdvancePayment.Amount;
                                InsCalCD."Adjusted Amount" := AdvancePayment.Amount;
                                InsCalCD."State Code" := recCustLedger."Global Dimension 1 Code";
                                InsCalCD."Warehouse code" := recCustLedger."Global Dimension 2 Code";
                                InsCalCD.MODIFY();
                            END ELSE BEGIN
                                InsCalCD."Invoice No." := recCustLedger."Document No.";
                                InsCalCD."Invoice Date" := recCustLedger."Posting Date";
                                InsCalCD."Invoince Due Date" := recCustLedger."Due Date";
                                InsCalCD."State Code" := recCustLedger."Global Dimension 1 Code";
                                InsCalCD."Warehouse code" := recCustLedger."Global Dimension 2 Code";
                                InsCalCD.MODIFY();
                            END;
                            recPostedScheme.RESET();
                            recPostedScheme.SETRANGE("Document No.", recCustLedger."Document No.");
                            IF recPostedScheme.FINDFIRST THEN BEGIN
                                InsCalCD.VALIDATE("Order Priority", recPostedScheme."OrderPriority Scheme");
                                InsCalCD.VALIDATE("Scheme Code", recPostedScheme."Scheme Code");
                                IF recPostedScheme."Tax Charge Code" = 'CD' THEN
                                    InsCalCD."Invoice CD Amount" := recPostedScheme."Discount Amount";
                                InsCalCD.MODIFY();
                            END;
                            recSalesInvoiceLine.RESET();
                            recSalesInvoiceLine.SETRANGE("Document No.", InsCalCD."Invoice No.");
                            IF recSalesInvoiceLine.FINDFIRST THEN BEGIN
                                REPEAT
                                    InsCalCD."Invoice Amt. Exclud GST" += CU50200.GetAmttoCustomerPostedLine(recSalesInvoiceLine."Document No.", recSalesInvoiceLine."Line No.") - (CU50200.GetTotalGSTAmtPostedLine(recSalesInvoiceLine."Document No.", recSalesInvoiceLine."Line No."));
                                    InsCalCD."Taxes & Charges Amount" += CU50200.GetTotalGSTAmtPostedLine(recSalesInvoiceLine."Document No.", recSalesInvoiceLine."Line No.");
                                UNTIL recSalesInvoiceLine.NEXT = 0;
                                InsCalCD.MODIFY();
                            END;

                            IF (InsCalCD."Payment Date" <> 0D) AND (InsCalCD."Invoince Due Date" <> 0D) AND (InsCalCD."Invoice Amount" <> 0) THEN BEGIN
                                IF InsCalCD."Payment Date" - InsCalCD."Invoince Due Date" <= 0 THEN
                                    InsCalCD."CD Days" := -1
                                ELSE
                                    InsCalCD."CD Days" := ABS(InsCalCD."Payment Date" - InsCalCD."Invoince Due Date");
                            END;
                            //InsCalCD."Rate of CD" := UpdateCDInfo(InsCalCD."Invoice Date",InsCalCD."CD Days",CD); Ps03092021 change logic from due date
                            IF (InsCalCD."Invoince Due Date" <> 0D) AND (InsCalCD."Invoice Amount" <> 0) THEN
                                InsCalCD."Rate of CD" := UpdateCDInfo(InsCalCD."Invoince Due Date", InsCalCD."CD Days", CD); //PS03092021 change logic from due date
                            InsCalCD.Date := WORKDATE;
                            //InsCalCD."CD Calculated On Amount" := InsCalCD."Invoice Amt. Exclud GST" - InsCalCD."Invoice CD Amount";
                            dectaxamt := 0;
                            dectaxamt := CheckTaxAmt(InsCalCD."Invoice No.");
                            IF dectaxamt = 0 THEN BEGIN
                                IF (ABS(InsCalCD."Adjusted Amount") - InsCalCD."Taxes & Charges Amount") <= 0 THEN BEGIN
                                    InsCalCD."CD Calculated On Amount" := 0;
                                    InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                                END ELSE BEGIN
                                    InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - InsCalCD."Taxes & Charges Amount");
                                    InsCalCD."Taxes & Charges Amt Adj" := InsCalCD."Taxes & Charges Amount";
                                END;
                            END ELSE BEGIN
                                decBaltax := 0;
                                IF InsCalCD."Taxes & Charges Amount" - dectaxamt >= 0 THEN BEGIN
                                    decBaltax := InsCalCD."Taxes & Charges Amount" - dectaxamt;
                                    IF (ABS(InsCalCD."Adjusted Amount") - decBaltax) <= 0 THEN BEGIN
                                        InsCalCD."CD Calculated On Amount" := 0;
                                        InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                                    END ELSE BEGIN
                                        InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - decBaltax);
                                        InsCalCD."Taxes & Charges Amt Adj" := decBaltax;
                                    END;
                                END ELSE
                                    InsCalCD."CD Calculated On Amount" := ABS(InsCalCD."Adjusted Amount");
                            END;
                            InsCalCD."CD to be Given" := ROUND(((InsCalCD."CD Calculated On Amount") * InsCalCD."Rate of CD") / 100, 0.01);
                            InsCalCD."CD Amount" := (InsCalCD."CD to be Given" - InsCalCD."Invoice CD Amount");
                            InsCalCD.MODIFY();
                        END;
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF dtPaymentTillDate = 0D THEN
                    ERROR('Payment till date should not be blank');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("CD Discount Group"; CDDiscountGroup)
                {
                    TableRelation = "Customer Discount Group";
                }
                field("Payment Till Date"; dtPaymentTillDate)
                {
                }
                field(Warehouse; Warehouse)
                {
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('STATE'));
                }
                field("Customer No."; CustCode)
                {
                    TableRelation = Customer;
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
        CDDiscountGroup: Code[20];
        dtPaymentTillDate: Date;
        Warehouse: Code[20];
        CustCode: Code[20];
        recCustLedger: Record 21;
        recCust: Record 18;
        InsCalCD: Record 50020;
        dtCustLedEntry: Record 379;
        recSalesInvoiceLine: Record 113;
        recCDSlab: Record 50019;
        DayCal: Integer;
        CD: Decimal;
        recPostedScheme: Record 50018;
        dectaxamt: Decimal;
        decBaltax: Decimal;
        recDimSetEntry: Record 480;
        CU50200: Codeunit 50200;

    local procedure UpdateCDInfo(Date: Date; Days: Integer; "CD%": Decimal) CD: Decimal
    begin
        recCDSlab.RESET();
        CD := 0;
        recCDSlab.SETFILTER("Effective Date", '<=%1', Date);
        recCDSlab.SETRANGE("From Days", Days);
        IF recCDSlab.FINDLAST THEN
            CD := recCDSlab."CD%";
        IF CD = 0 THEN BEGIN
            recCDSlab.SETFILTER("Effective Date", '>=%1', Date);
            recCDSlab.SETRANGE("From Days", Days);
            IF recCDSlab.FINDFIRST THEN
                CD := recCDSlab."CD%"
        END;

        IF CD < 0 THEN
            CD := 0;
    end;

    local procedure CheckTaxAmt("InvoiceNo.": Code[20]) dectaxamt: Decimal
    var
        recCdsummary: Record 50020;
    begin
        recCdsummary.RESET();
        dectaxamt := 0;
        recCdsummary.SETRANGE("Invoice No.", "InvoiceNo.");
        IF recCdsummary.FINDFIRST THEN
            REPEAT
                dectaxamt += recCdsummary."Taxes & Charges Amt Adj";
            UNTIL recCdsummary.NEXT = 0;
    end;
}

