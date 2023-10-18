codeunit 50003 "Acx Scheme Module Calculation"
{

    trigger OnRun()
    begin
    end;

    var
        LineNo: Integer;
        PaymentNo: Code[10];
        PaymentDate: Date;
        PaymentAmt: Decimal;

    procedure SaleData(recSchemeMaster: Record 50028)
    var
        recSLine: Record 113;
        recSchemesummary: Record 50027;
        recSHeader: Record 112;
        txtCustName: Text;
        recSchemItem: Record 50026;
    begin
        recSLine.SETFILTER("Posting Date", '%1..%2', recSchemeMaster."From Date", recSchemeMaster."To Date");
        recSLine.SETFILTER(Type, '%1', recSLine.Type::Item);
        IF recSLine.FINDSET THEN
            REPEAT
                LineNo := LineNo + 10000;
                recSchemesummary.INIT;
                recSchemesummary.RESET;
                recSchemesummary."Scheme Code" := recSchemeMaster."Scheme Code";
                recSchemesummary."Invoice No." := recSLine."Document No.";
                recSchemesummary."Invoice Date" := recSLine."Posting Date";
                recSchemesummary."Customer No." := recSLine."Sell-to Customer No.";
                recSchemesummary."Line No." := LineNo;
                recSHeader.RESET;
                recSHeader.SETRANGE("No.", recSLine."Document No.");
                IF recSHeader.FINDFIRST THEN BEGIN
                    recSHeader.CALCFIELDS("Amount to Customer");
                    recSchemesummary."Customer Name" := recSHeader."Sell-to Customer Name";
                    recSchemesummary."Invoice Amount" := recSHeader."Amount to Customer";
                    recSchemesummary."Invoice Due Date" := recSHeader."Due Date";
                END;
                recSchemesummary."Taxes & Charges Amount" := recSLine."Total GST Amount";
                recSchemesummary."Invoice Amt. Exclud GST" := (recSLine."Line Amount" - recSLine."Total GST Amount");

                recSchemesummary.INSERT;
            UNTIL recSLine.NEXT = 0;
        MESSAGE('Sales Invoice Data Inserted');

        //payment application with Invoice
    end;

    procedure CustAppliedPayment(CustNo: Record 18)
    var
        recCLE: Record 21;
        recDcle: Record 379;
    begin
        recCLE.RESET;
        recCLE.SETRANGE("Customer No.", CustNo."No.");
        recCLE.SETRANGE("Entry No.", recDcle."Applied Cust. Ledger Entry No.");
        IF recCLE.FINDSET THEN;
    end;
}

