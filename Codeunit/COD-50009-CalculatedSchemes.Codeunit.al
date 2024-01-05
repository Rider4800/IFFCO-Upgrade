codeunit 50009 CalculatedSchemes
{

    trigger OnRun()
    begin
    end;

    var
        CDDiscountGroup: Code[20];
        Warehouse: Code[20];
        CustCode: Code[20];
        recCust: Record 18;
        InsCalCD: Record 50027;
        dtCustLedEntry: Record 379;
        SIH: Record 112;
        SIL: Record 113;
        recCDSlab: Record 50025;
        DayCal: Integer;
        CD: Decimal;
        recPostedScheme: Record 50018;
        dectaxamt: Decimal;
        decBaltax: Decimal;
        recDimSetEntry: Record 480;
        recDetCustLedger: Record 379;
        SchemeItem: Record 50026;
        SchemeMST: Record 50005;
        AmtExclud: Decimal;
        IntCalCDLine: Record 50027;
        LineNo: Integer;
        DetCustEntry: Integer;
        recCustLedgerInv: Record 21;
        recCustLedgerPay: Record 21;
        IsInsert: Boolean;
        CalEligibility: Record 50029;
        tReturn: Record 50010;

    procedure AfterInvoice(SchemeCode: Code[20]; FromDt: Date; ToDt: Date)
    var
        CurrCustCode: Code[20];
        tReturn: Record 50010;
    begin
        SchemeMST.RESET();
        SchemeMST.SETRANGE("Scheme Code", SchemeCode);
        SchemeMST.SETRANGE("From Date", FromDt);
        SchemeMST.SETRANGE("To Date", ToDt);
        SchemeMST.SETRANGE(Status, SchemeMST.Status::Release);
        SchemeMST.SETFILTER(Blocked, '%1', FALSE);
        IF NOT SchemeMST.FINDFIRST THEN
            EXIT;
        IF (FromDt = 0D) AND (ToDt = 0D) THEN
            ERROR('From Date and To Date not be blank');
        DeleteCalEligibility(FromDt, ToDt);
        //PayInv//////////////////////

        recCustLedgerPay.RESET();
        CurrCustCode := '';
        recCustLedgerPay.SETFILTER("Posting Date", '%1..%2', SchemeMST."Payment From Date", SchemeMST."Payment To Date");
        //recCustLedgerPay.SETFILTER("Scheme Calculated",'%1',FALSE);
        recCustLedgerPay.SETFILTER("Document Type", '%1|%2|%3|%4', recCustLedgerPay."Document Type"::Payment, recCustLedgerPay."Document Type"::Refund,
                                    recCustLedgerPay."Document Type"::" ", recCustLedgerPay."Document Type"::"Credit Memo");
        //AND (recCustLedgerPay."Document Type" = recCustLedgerPay."Document Type"::Payment)

        //030823 ACXVG
        //recCustLedgerPay.SETRANGE("Customer No.",'160002000057');
        //030823 ACXVG
        IF (recCustLedgerPay.FINDFIRST) THEN BEGIN
            REPEAT
                IF CurrCustCode <> recCustLedgerPay."Customer No." THEN
                    CheckSaleQty(SchemeMST."Scheme Code", recCustLedgerPay."Customer No.", FromDt, ToDt);
                GetDetalsPayInv(FromDt, ToDt, recCustLedgerPay."Entry No.", recCustLedgerPay);
                CurrCustCode := recCustLedgerPay."Customer No.";
            UNTIL recCustLedgerPay.NEXT = 0;
        END;
    end;

    local procedure UpdateCDInfo(Date: Date; Days: Integer; "CD%": Decimal; SCCode: Code[20]) CD: Decimal
    begin
        recCDSlab.RESET();
        recCDSlab.SETRANGE("Scheme Code", SCCode);
        IF recCDSlab.FINDFIRST THEN BEGIN
            IF Date < recCDSlab."Effective Date" THEN
                Date := recCDSlab."Effective Date";
        END;
        recCDSlab.RESET();
        CD := 0;
        recCDSlab.SETFILTER("Effective Date", '<=%1', Date);
        recCDSlab.SETRANGE("From Days", Days);
        IF recCDSlab.FINDLAST THEN
            CD := recCDSlab."CD%";
        IF CD = 0 THEN BEGIN
            recCDSlab.SETFILTER("Effective Date", '%1', Date);
            recCDSlab.SETRANGE("From Days", Days);
            IF recCDSlab.FINDFIRST THEN
                CD := recCDSlab."CD%"
        END;

        IF CD < 0 THEN
            CD := 0;
    end;

    local procedure CheckTaxAmt("InvoiceNo.": Code[20]) dectaxamt: Decimal
    var
        recCdsummary: Record 50027;
    begin
        recCdsummary.RESET();
        dectaxamt := 0;
        recCdsummary.SETRANGE("Invoice No.", "InvoiceNo.");
        IF recCdsummary.FINDFIRST THEN
            REPEAT
                dectaxamt += recCdsummary."Taxes & Charges Amt Adj";
            UNTIL recCdsummary.NEXT = 0;
    end;

    local procedure GetSalesInvoiceLine(FromDt: Date; ToDt: Date; SchemeCode: Code[20]; InvoiceNo: Code[20])
    var
        SchemeMST: Record 50005;
        CalScheme: Record 50027;
    begin
        SchemeMST.RESET();
        SchemeMST.SETRANGE("From Date", FromDt);
        SchemeMST.SETRANGE("To Date", ToDt);
        SchemeMST.SETRANGE("Scheme Code", SchemeCode);
        SchemeMST.SETRANGE(Status, SchemeMST.Status::Release);
        IF SchemeMST.FINDFIRST THEN BEGIN
            SIH.RESET();
            //IF SchemeItem."Sales Type" = SchemeItem."Sales Type"::Customer THEN
            //SIH.SETRANGE("Sell-to Customer No.",SchemeItem."Sales Code");
            //IF SchemeItem."Sales Type" = SchemeItem."Sales Type"::"Customer Discount Group" THEN
            //SIH.SETRANGE("Customer Posting Group",SchemeItem."Sales Code");
            SIH.SETRANGE("Scheme Code", SchemeMST."Scheme Code");
            SIH.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."To Date");
            SIH.SETRANGE("No.", InvoiceNo);
            IF SIH.FINDFIRST THEN BEGIN
                CalScheme.RESET();
                CalScheme.SETRANGE("Invoice No.", SIH."No.");
                IF CalScheme.FINDFIRST THEN BEGIN
                    SIL.RESET();
                    SIL.SETRANGE("Document No.", SIH."No.");
                    //SIL.SETRANGE("Product Group Code", SchemeItem.Code);  //17783
                    IF SIL.FINDFIRST THEN BEGIN
                        REPEAT
                            CalScheme."Invoice Amt. Exclud GST" += SIL."Line Amount";
                            //CalScheme."Taxes & Charges Amount" += SIL."Total GST Amount" + SIL."Total TDS/TCS Incl. SHE CESS";    //17783
                            CalScheme.MODIFY(TRUE);
                        UNTIL SIL.NEXT = 0;
                    END;
                    CalScheme."Amount Excluded Item" := AmtExcluded(FromDt, ToDt, SIH."No.", SIH."Scheme Code", CalScheme."Invoice Type", 1);
                    CalScheme."GST Amount Excluded Item" := AmtExcluded(FromDt, ToDt, SIH."No.", SIH."Scheme Code", CalScheme."Invoice Type", 2);
                    IF CalScheme."GST Amount Excluded Item" > 0 THEN
                        CalScheme."Taxes & Charges Amount" := CalScheme."Taxes & Charges Amount" - CalScheme."GST Amount Excluded Item";
                    CalScheme.MODIFY();
                END;
            END;
        END;
    end;

    local procedure AmtExcluded(FromDt: Date; ToDt: Date; InvNo: Code[20]; SCHCode: Code[20]; Type: Option Invoice,"Credit Memo","Return Order"; AmtCalType: Integer) ExcuAmt: Decimal
    var
        recSIL: Record 113;
        recSCL: Record 115;
    begin
        IF Type = Type::Invoice THEN BEGIN
            SchemeItem.RESET();
            SchemeItem.SETRANGE("Scheme Code", SCHCode);
            SchemeItem.SETRANGE("Starting Date", FromDt);
            SchemeItem.SETRANGE("Ending Date", ToDt);
            SchemeItem.SETFILTER(Blocked, '%1', FALSE);
            SchemeItem.SETFILTER(Excluded, '%1', TRUE);
            IF SchemeItem.FINDFIRST THEN BEGIN
                REPEAT
                    recSIL.RESET();
                    IF SchemeItem.Type = SchemeItem.Type::"Product Group" THEN
                        //recSIL.SETRANGE("Product Group Code", SchemeItem.Code);   //17783
                    IF SchemeItem.Type = SchemeItem.Type::Item THEN
                            recSIL.SETRANGE("No.", SchemeItem.Code);
                    recSIL.SETRANGE("Document No.", InvNo);
                    IF recSIL.FINDFIRST THEN BEGIN
                        REPEAT
                            IF AmtCalType = 1 THEN
                                ExcuAmt += recSIL."Line Amount";
                        // IF AmtCalType = 2 THEN
                        //     ExcuAmt += recSIL."Total GST Amount";    //17783
                        UNTIL recSIL.NEXT = 0;
                    END;
                UNTIL SchemeItem.NEXT = 0;
            END;
        END;

        IF Type = Type::"Credit Memo" THEN BEGIN
            SchemeItem.RESET();
            SchemeItem.SETRANGE("Scheme Code", SCHCode);
            SchemeItem.SETRANGE("Starting Date", FromDt);
            SchemeItem.SETRANGE("Ending Date", ToDt);
            SchemeItem.SETFILTER(Blocked, '%1', FALSE);
            SchemeItem.SETFILTER(Excluded, '%1', TRUE);
            IF SchemeItem.FINDFIRST THEN BEGIN
                REPEAT
                    recSCL.RESET();
                    IF SchemeItem.Type = SchemeItem.Type::"Product Group" THEN
                        //recSCL.SETRANGE("Product Group Code", SchemeItem.Code);   //17783
                    IF SchemeItem.Type = SchemeItem.Type::Item THEN
                            recSCL.SETRANGE("No.", SchemeItem.Code);
                    recSCL.SETRANGE("Document No.", InvNo);
                    IF recSCL.FINDFIRST THEN BEGIN
                        REPEAT
                            IF AmtCalType = 1 THEN
                                ExcuAmt += recSCL."Line Amount";
                        // IF AmtCalType = 2 THEN
                        //     ExcuAmt += recSCL."Total GST Amount";    //17783
                        UNTIL recSCL.NEXT = 0;
                    END;
                UNTIL SchemeItem.NEXT = 0;
            END;
        END;
    end;

    local procedure CheckSaleQty(SchemeCode: Code[20]; CustNo: Code[20]; FromDt: Date; ToDt: Date)
    var
        decQtyItem: Decimal;
        decQtyProduct: Decimal;
        ItemUom: Record 5404;
        GLS: Record 98;
        TmpReturn: Record 50010;
    begin
        SchemeItem.RESET();
        decQtyProduct := 0;
        SchemeItem.SETRANGE("Scheme Code", SchemeCode);
        SchemeItem.SETFILTER(Excluded, '%1', FALSE);
        SchemeItem.SETFILTER("Minimum Quantity", '>%1', 0);
        SchemeItem.SETRANGE("Starting Date", FromDt);
        SchemeItem.SETRANGE("Ending Date", ToDt);
        IF SchemeItem.FINDFIRST THEN BEGIN
            REPEAT
                SIH.RESET();
                SIH.SETRANGE("Scheme Code", SchemeItem."Scheme Code");
                SIH.SETFILTER("Posting Date", '%1..%2', FromDt, ToDt);
                SIH.SETRANGE("Sell-to Customer No.", CustNo);
                IF SIH.FINDFIRST THEN BEGIN
                    REPEAT
                        SIL.RESET();
                        SIL.SETRANGE("Document No.", SIH."No.");
                        // IF SchemeItem.Type = SchemeItem.Type::"Product Group" THEN
                        //SIL.SETRANGE("Product Group Code", SchemeItem.Code);  //17783
                        // IF SchemeItem.Type = SchemeItem.Type::Item THEN
                        // SIL.SETRANGE("No.",SchemeItem.Code);
                        IF SIL.FINDFIRST THEN BEGIN
                            REPEAT
                                ItemUom.RESET();
                                ItemUom.SETRANGE("Item No.", SIL."No.");
                                ItemUom.SETRANGE(Code, 'LTR');
                                IF NOT ItemUom.FINDFIRST THEN
                                    ERROR('Item %1 UOM Ltr not find in Item UOM table', SIL."No.");
                                GLS.GET();
                                decQtyProduct += ROUND(SIL.Quantity * ItemUom."Qty. per Unit of Measure", GLS."Inv. Rounding Precision (LCY)");
                            UNTIL SIL.NEXT = 0;
                            //TmpReturn
                            TmpReturn.RESET();
                            TmpReturn.SETFILTER("Posting Date", '%1..%2', FromDt, ToDt);
                            TmpReturn.SETRANGE("Invoice Ref No.", SIL."Document No.");
                            TmpReturn.SETRANGE("Product Group", SchemeItem.Code);
                            IF TmpReturn.FINDFIRST THEN BEGIN
                                REPEAT
                                    decQtyProduct -= ROUND(TmpReturn.Quantity * ItemUom."Qty. per Unit of Measure", GLS."Inv. Rounding Precision (LCY)");
                                UNTIL TmpReturn.NEXT = 0;
                            END;
                            IF decQtyProduct >= SchemeItem."Minimum Quantity" THEN BEGIN
                                CalEligibility.RESET();
                                CalEligibility.SETRANGE("Customer No.", SIH."Sell-to Customer No.");
                                CalEligibility.SETRANGE(Type, SchemeItem.Type);
                                CalEligibility.SETRANGE(Code, SchemeItem.Code);
                                IF NOT CalEligibility.FINDFIRST THEN BEGIN
                                    CalEligibility.INIT();
                                    CalEligibility."Customer No." := SIH."Sell-to Customer No.";
                                    CalEligibility."From Date" := FromDt;
                                    CalEligibility."To Date" := ToDt;
                                    CalEligibility.Type := SchemeItem.Type;
                                    CalEligibility.Code := SchemeItem.Code;
                                    CalEligibility."Calculated Percent" := decQtyProduct;
                                    CalEligibility.INSERT();
                                END;
                            END;
                        END;
                    UNTIL SIH.NEXT = 0;
                END;
            ////////// Less Sales Returns
            /*
            SCH.RESET();
            SCH.SETRANGE("Scheme Code",SchemeItem."Scheme Code");
            SCH.SETFILTER("Posting Date",'%1..%2',FromDt,ToDt);
            SCH.SETRANGE("Sell-to Customer No.",CustNo);
            IF SCH.FINDFIRST THEN BEGIN
              REPEAT
                SCL.RESET();
                SCL.SETRANGE("Document No.",SCL."No.");
                // IF SCLemeItem.Type = SCLemeItem.Type::"Product Group" THEN
                SCL.SETRANGE("Product Group Code",SchemeItem.Code);
                // IF SchemeItem.Type = SchemeItem.Type::Item THEN
                  // SCL.SETRANGE("No.",SchemeItem.Code);
                IF SCL.FINDFIRST THEN BEGIN
                  REPEAT
                    ItemUom.RESET();
                    ItemUom.SETRANGE("Item No.",SCL."No.");
                    ItemUom.SETRANGE(Code,'LTR');
                    IF NOT ItemUom.FINDFIRST THEN
                      ERROR('Item %1 UOM Ltr not find in Item UOM table',SCL."No.");
                    GLS.GET();
                    decQtyProduct-= ROUND(SCL.Quantity * ItemUom."Qty. per Unit of Measure",GLS."Inv. Rounding Precision (LCY)");
                  UNTIL SCL.NEXT=0;
                  IF decQtyProduct >= SchemeItem."Minimum Quantity" THEN BEGIN
                    CalEligibility.RESET();
                    CalEligibility.SETRANGE("Customer No.",SCH."Sell-to Customer No.");
                    CalEligibility.SETRANGE(Type,SchemeItem.Type);
                    CalEligibility.SETRANGE(Code,SchemeItem.Code);
                    CalEligibility.SETRANGE("From Date",FromDt);
                    CalEligibility.SETRANGE("To Date",ToDt);
                    CalEligibility.SETRANGE(Type,SchemeItem.Type);
                    CalEligibility.SETRANGE(Code,SchemeItem.Code);
                    IF CalEligibility.FINDFIRST THEN BEGIN
                      CalEligibility."Calculated Percent":= decQtyProduct;
                      CalEligibility.MODIFY();
                    END;
                  END;
                END;
              UNTIL SCH.NEXT=0;
            END;
            */
            UNTIL SchemeItem.NEXT = 0;
        END;

    end;

    local procedure GetDetalsPayInv(FromDt: Date; ToDt: Date; EntryNo: Integer; recCustLedgerPay: Record 21)
    begin
        recDetCustLedger.RESET();
        recDetCustLedger.SETCURRENTKEY("Application No.", "Entry Type");
        recDetCustLedger.SETRANGE("Applied Cust. Ledger Entry No.", EntryNo);
        //recDetCustLedger.SETFILTER("Applied Cust. Ledger Entry No.",'5484331'); // acxvg
        recDetCustLedger.SETFILTER(Unapplied, '%1', FALSE);
        IF recDetCustLedger.FINDFIRST THEN BEGIN
            REPEAT
                recCustLedgerInv.RESET();
                recCustLedgerInv.SETCURRENTKEY("Entry No.");
                //recCustLedgerInv.SETRANGE("Entry No.",5484331);//ACXVG
                recCustLedgerInv.SETRANGE("Entry No.", recDetCustLedger."Cust. Ledger Entry No.");
                recCustLedgerInv.SETRANGE("Document Type", recCustLedgerInv."Document Type"::Invoice);
                recCustLedgerInv.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."To Date");
                IF recCustLedgerInv.FINDFIRST THEN BEGIN
                    CalEligibility.RESET();
                    CalEligibility.SETRANGE("Customer No.", recCustLedgerInv."Customer No.");
                    CalEligibility.SETRANGE("From Date", FromDt);
                    CalEligibility.SETRANGE("To Date", ToDt);
                    IF CalEligibility.FINDFIRST THEN BEGIN
                        InsCalCD.RESET();
                        InsCalCD.SETRANGE("Customer No.", recCustLedgerPay."Customer No.");
                        InsCalCD.SETRANGE("Payment No.", recCustLedgerPay."Document No.");
                        InsCalCD.SETRANGE("Invoice No.", recCustLedgerInv."Document No.");
                        InsCalCD.SETRANGE("Cust. Led. Entry No.", recCustLedgerInv."Entry No.");
                        // InsCalCD.SETRANGE("Dt. Cust. Led. Entry", recCustLedgerPay."Entry No.");
                        IF NOT InsCalCD.FINDFIRST THEN BEGIN
                            LineNo := 0;
                            IntCalCDLine.RESET();
                            IntCalCDLine.SETRANGE("Scheme Code", SchemeMST."Scheme Code");
                            IF IntCalCDLine.FINDLAST THEN
                                LineNo := IntCalCDLine."Line No." + 10000
                            ELSE
                                LineNo := 10000;
                            InsCalCD.INIT();
                            InsCalCD."Scheme Code" := SchemeMST."Scheme Code";
                            InsCalCD."Customer No." := recCustLedgerPay."Customer No.";
                            IF recCustLedgerPay."Document Type" <> recCustLedgerPay."Document Type"::Payment THEN BEGIN
                                IF recCustLedgerPay."Posting Date" < SchemeMST."From Date" THEN BEGIN
                                    InsCalCD."Payment No." := recCustLedgerPay."Document No.";
                                    InsCalCD."Payment Date" := recCustLedgerPay."Posting Date";
                                    InsCalCD."Line No." := LineNo;
                                    recCustLedgerPay.CALCFIELDS(Amount);
                                    InsCalCD."Payment Amount" := ABS(recCustLedgerPay.Amount);
                                END ELSE BEGIN
                                    InsCalCD."Payment No." := '';
                                    InsCalCD."Payment Date" := 0D;
                                    InsCalCD."Line No." := LineNo;
                                    InsCalCD."Payment Amount" := 0;
                                END;
                            END ELSE BEGIN
                                IF recCustLedgerPay."Document Type" = recCustLedgerPay."Document Type"::Payment THEN BEGIN
                                    InsCalCD."Payment No." := recCustLedgerPay."Document No.";
                                    InsCalCD."Payment Date" := recCustLedgerPay."Posting Date";
                                    InsCalCD."Line No." := LineNo;
                                    recCustLedgerPay.CALCFIELDS(Amount);
                                    InsCalCD."Payment Amount" := ABS(recCustLedgerPay.Amount);
                                END;
                            END;
                            InsCalCD."Cust. Led. Entry No." := recCustLedgerPay."Entry No.";
                            InsCalCD."Invoice No." := recCustLedgerInv."Document No.";
                            InsCalCD."Invoice Date" := recCustLedgerInv."Posting Date";
                            InsCalCD."Invoice Due Date" := recCustLedgerInv."Due Date";
                            recCustLedgerInv.CALCFIELDS(Amount);
                            InsCalCD."Net Invoice Amount" := recCustLedgerInv.Amount;
                            InsCalCD."Adjusted Amount With Tax" := recDetCustLedger.Amount;
                            InsCalCD."Adjusted Amount" := ABS(recDetCustLedger.Amount);
                            InsCalCD."State Code" := recCustLedgerInv."Global Dimension 1 Code";
                            InsCalCD."Warehouse code" := recCustLedgerInv."Global Dimension 2 Code";
                            InsCalCD.INSERT(TRUE);
                            IsInsert := TRUE;
                        END;
                    END;
                END;
                IF IsInsert = TRUE THEN BEGIN
                    recCust.RESET();
                    recCust.SETRANGE("No.", recCustLedgerInv."Customer No.");
                    IF recCust.FINDFIRST THEN BEGIN
                        InsCalCD."Customer Name" := recCust.Name;
                        InsCalCD."Customer Disc. Group" := recCust."Customer Disc. Group";
                        InsCalCD."Customer Posting Group" := recCust."Customer Posting Group";
                        InsCalCD.MODIFY();
                    END;
                    SIH.RESET();
                    SIH.SETRANGE("Scheme Code", SchemeMST."Scheme Code");
                    SIH.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."To Date");
                    SIH.SETRANGE("No.", InsCalCD."Invoice No.");
                    InsCalCD.SETFILTER("Invoice Amt. Exclud GST", '%1', 0);
                    IF SIH.FINDFIRST THEN BEGIN
                        SIL.RESET();
                        SIL.SETRANGE("Document No.", SIH."No.");
                        SIL.SETRANGE(Type, SIL.Type::Item);
                        IF SIL.FINDFIRST THEN BEGIN
                            REPEAT
                                //InsCalCD."Invoice Amount" += SIL."Amount To Customer";    //17783
                                InsCalCD."Invoice Amt. Exclud GST" += SIL."Line Amount";
                                //InsCalCD."Taxes & Charges Amount" += SIL."Total GST Amount" + SIL."Total TDS/TCS Incl. SHE CESS"; //17783
                                InsCalCD.MODIFY(TRUE);
                            UNTIL SIL.NEXT = 0;
                        END;
                        InsCalCD."Invoice Type" := InsCalCD."Invoice Type"::Invoice;
                        InsCalCD."Amount Excluded Item" := AmtExcluded(FromDt, ToDt, SIH."No.", SIH."Scheme Code", InsCalCD."Invoice Type", 1);
                        InsCalCD."GST Amount Excluded Item" := AmtExcluded(FromDt, ToDt, SIH."No.", SIH."Scheme Code", InsCalCD."Invoice Type", 2);
                        IF InsCalCD."GST Amount Excluded Item" > 0 THEN
                            InsCalCD."Taxes & Charges Amount" := InsCalCD."Taxes & Charges Amount" - InsCalCD."GST Amount Excluded Item";
                        InsCalCD.MODIFY();
                    END ELSE
                        InsCalCD."Invoice Amount" := 0;
                    //Return
                    tReturn.RESET();
                    tReturn.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."Payment To Date");
                    tReturn.SETRANGE("Invoice Ref No.", InsCalCD."Invoice No.");
                    IF tReturn.FINDFIRST THEN BEGIN
                        REPEAT
                            InsCalCD."Invoice Amount" -= tReturn."Base Amount";
                            InsCalCD."Invoice Amt. Exclud GST" -= tReturn."Base Amount"
                          UNTIL tReturn.NEXT = 0;
                        InsCalCD.MODIFY;
                    END;
                    tReturn.RESET();
                    tReturn.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."Payment To Date");
                    tReturn.SETRANGE("Credit Note No.", InsCalCD."Payment No.");
                    IF tReturn.FINDFIRST THEN
                        InsCalCD."Invoice Amount" := 0;
                    InsCalCD."Rate of CD" := UpdateCDInfo(InsCalCD."Payment Date", InsCalCD."CD Days", CD, InsCalCD."Scheme Code");
                    InsCalCD."CD Generation Date" := WORKDATE;
                    InsCalCD.MODIFY();
                    dectaxamt := 0;
                    IF InsCalCD."Payment No." <> '' THEN BEGIN

                        dectaxamt := CheckTaxAmt(InsCalCD."Invoice No.");
                        IF dectaxamt = 0 THEN BEGIN
                            IF (ABS(InsCalCD."Adjusted Amount") - (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item")) <= 0 THEN BEGIN
                                InsCalCD."CD Calculated On Amount" := 0;
                                InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                            END ELSE BEGIN
                                InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item"));
                                InsCalCD."Taxes & Charges Amt Adj" := (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item");
                            END;
                            InsCalCD.MODIFY();
                        END ELSE BEGIN
                            decBaltax := 0;
                            IF (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item") - dectaxamt >= 0 THEN BEGIN
                                decBaltax := (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item") - dectaxamt;
                                IF (ABS(InsCalCD."Adjusted Amount") - decBaltax) <= 0 THEN BEGIN
                                    InsCalCD."CD Calculated On Amount" := 0;
                                    InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                                END ELSE BEGIN
                                    InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - decBaltax);
                                    InsCalCD."Taxes & Charges Amt Adj" := decBaltax;
                                END;
                            END ELSE
                                InsCalCD."CD Calculated On Amount" := ABS(InsCalCD."Adjusted Amount");
                            InsCalCD.MODIFY();
                        END;
                        InsCalCD."CD to be Given" := ROUND(((InsCalCD."CD Calculated On Amount") * InsCalCD."Rate of CD") / 100, 0.01);
                        InsCalCD."CD Amount" := (InsCalCD."CD to be Given" - InsCalCD."Invoice CD Amount");
                        InsCalCD.MODIFY();
                    END;
                END;
                IsInsert := FALSE;
            UNTIL recDetCustLedger.NEXT = 0;
        END;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        recDetCustLedger.RESET();
        recDetCustLedger.SETCURRENTKEY("Application No.", "Entry Type");
        recDetCustLedger.SETRANGE("Cust. Ledger Entry No.", EntryNo);
        recDetCustLedger.SETFILTER(Unapplied, '%1', FALSE);
        IF recDetCustLedger.FINDFIRST THEN BEGIN
            REPEAT
                recCustLedgerInv.RESET();
                recCustLedgerInv.SETCURRENTKEY("Entry No.");
                recCustLedgerInv.SETRANGE("Entry No.", recDetCustLedger."Applied Cust. Ledger Entry No.");
                recCustLedgerInv.SETRANGE("Document Type", recCustLedgerInv."Document Type"::Invoice);
                recCustLedgerInv.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."To Date");
                IF recCustLedgerInv.FINDFIRST THEN BEGIN
                    CalEligibility.RESET();
                    CalEligibility.SETRANGE("Customer No.", recCustLedgerInv."Customer No.");
                    CalEligibility.SETRANGE("From Date", FromDt);
                    CalEligibility.SETRANGE("To Date", ToDt);
                    IF CalEligibility.FINDFIRST THEN BEGIN
                        InsCalCD.RESET();
                        InsCalCD.SETRANGE("Customer No.", recCustLedgerPay."Customer No.");
                        InsCalCD.SETRANGE("Payment No.", recCustLedgerPay."Document No.");
                        InsCalCD.SETRANGE("Invoice No.", recCustLedgerInv."Document No.");
                        InsCalCD.SETRANGE("Cust. Led. Entry No.", recCustLedgerInv."Entry No.");
                        // InsCalCD.SETRANGE("Dt. Cust. Led. Entry", recCustLedgerPay."Entry No.");
                        IF NOT InsCalCD.FINDFIRST THEN BEGIN
                            LineNo := 0;
                            IntCalCDLine.RESET();
                            IntCalCDLine.SETRANGE("Scheme Code", SchemeMST."Scheme Code");
                            IF IntCalCDLine.FINDLAST THEN
                                LineNo := IntCalCDLine."Line No." + 10000
                            ELSE
                                LineNo := 10000;
                            InsCalCD.INIT();
                            InsCalCD."Scheme Code" := SchemeMST."Scheme Code";
                            InsCalCD."Customer No." := recCustLedgerPay."Customer No.";
                            IF recCustLedgerPay."Document Type" <> recCustLedgerPay."Document Type"::Payment THEN BEGIN
                                IF recCustLedgerPay."Posting Date" < SchemeMST."From Date" THEN BEGIN
                                    InsCalCD."Payment No." := recCustLedgerPay."Document No.";
                                    InsCalCD."Payment Date" := recCustLedgerPay."Posting Date";
                                    InsCalCD."Line No." := LineNo;
                                    recCustLedgerPay.CALCFIELDS(Amount);
                                    InsCalCD."Payment Amount" := ABS(recCustLedgerPay.Amount);
                                END ELSE BEGIN
                                    InsCalCD."Payment No." := '';
                                    InsCalCD."Payment Date" := 0D;
                                    InsCalCD."Line No." := LineNo;
                                    InsCalCD."Payment Amount" := 0;
                                END;
                            END ELSE BEGIN
                                IF recCustLedgerPay."Document Type" = recCustLedgerPay."Document Type"::Payment THEN BEGIN
                                    InsCalCD."Payment No." := recCustLedgerPay."Document No.";
                                    InsCalCD."Payment Date" := recCustLedgerPay."Posting Date";
                                    InsCalCD."Line No." := LineNo;
                                    recCustLedgerPay.CALCFIELDS(Amount);
                                    InsCalCD."Payment Amount" := ABS(recCustLedgerPay.Amount);
                                END;
                            END;
                            InsCalCD."Cust. Led. Entry No." := recCustLedgerPay."Entry No.";
                            InsCalCD."Invoice No." := recCustLedgerInv."Document No.";
                            InsCalCD."Invoice Date" := recCustLedgerInv."Posting Date";
                            InsCalCD."Invoice Due Date" := recCustLedgerInv."Due Date";
                            recCustLedgerInv.CALCFIELDS(Amount);
                            InsCalCD."Net Invoice Amount" := recCustLedgerInv.Amount;
                            InsCalCD."Adjusted Amount With Tax" := recDetCustLedger.Amount;
                            InsCalCD."Adjusted Amount" := ABS(recDetCustLedger.Amount);
                            InsCalCD."State Code" := recCustLedgerInv."Global Dimension 1 Code";
                            InsCalCD."Warehouse code" := recCustLedgerInv."Global Dimension 2 Code";
                            InsCalCD.INSERT(TRUE);
                            IsInsert := TRUE;
                        END;
                    END;
                END;
                IF IsInsert = TRUE THEN BEGIN
                    recCust.RESET();
                    recCust.SETRANGE("No.", recCustLedgerInv."Customer No.");
                    IF recCust.FINDFIRST THEN BEGIN
                        InsCalCD."Customer Name" := recCust.Name;
                        InsCalCD."Customer Disc. Group" := recCust."Customer Disc. Group";
                        InsCalCD."Customer Posting Group" := recCust."Customer Posting Group";
                        InsCalCD.MODIFY();
                    END;
                    SIH.RESET();
                    SIH.SETRANGE("Scheme Code", SchemeMST."Scheme Code");
                    SIH.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."To Date");
                    SIH.SETRANGE("No.", InsCalCD."Invoice No.");
                    InsCalCD.SETFILTER("Invoice Amt. Exclud GST", '%1', 0);
                    IF SIH.FINDFIRST THEN BEGIN
                        SIL.RESET();
                        SIL.SETRANGE("Document No.", SIH."No.");
                        SIL.SETRANGE(Type, SIL.Type::Item);
                        IF SIL.FINDFIRST THEN BEGIN
                            REPEAT
                                //InsCalCD."Invoice Amount" += SIL."Amount To Customer";    //17783
                                InsCalCD."Invoice Amt. Exclud GST" += SIL."Line Amount";
                                //InsCalCD."Taxes & Charges Amount" += SIL."Total GST Amount" + SIL."Total TDS/TCS Incl. SHE CESS"; //17783
                                InsCalCD.MODIFY(TRUE);
                            UNTIL SIL.NEXT = 0;
                        END;
                        InsCalCD."Invoice Type" := InsCalCD."Invoice Type"::Invoice;
                        InsCalCD."Amount Excluded Item" := AmtExcluded(FromDt, ToDt, SIH."No.", SIH."Scheme Code", InsCalCD."Invoice Type", 1);
                        InsCalCD."GST Amount Excluded Item" := AmtExcluded(FromDt, ToDt, SIH."No.", SIH."Scheme Code", InsCalCD."Invoice Type", 2);
                        IF InsCalCD."GST Amount Excluded Item" > 0 THEN
                            InsCalCD."Taxes & Charges Amount" := InsCalCD."Taxes & Charges Amount" - InsCalCD."GST Amount Excluded Item";
                        InsCalCD.MODIFY();
                    END ELSE
                        InsCalCD."Invoice Amount" := 0;
                    //Return
                    tReturn.RESET();
                    tReturn.SETFILTER("Posting Date", '%1..%2', SchemeMST."From Date", SchemeMST."Payment To Date");
                    tReturn.SETRANGE("Invoice Ref No.", InsCalCD."Invoice No.");
                    IF tReturn.FINDFIRST THEN BEGIN
                        REPEAT
                            InsCalCD."Invoice Amount" -= tReturn."Base Amount";
                            InsCalCD."Invoice Amt. Exclud GST" -= tReturn."Base Amount"
                          UNTIL tReturn.NEXT = 0;
                        InsCalCD.MODIFY;
                    END;

                    tReturn.RESET();
                    tReturn.SETFILTER("Posting Date", '%1..%2', SchemeMST."Payment From Date", SchemeMST."Payment To Date");
                    tReturn.SETRANGE("Credit Note No.", InsCalCD."Payment No.");
                    IF tReturn.FINDFIRST THEN
                        InsCalCD."Invoice Amount" := 0;
                    InsCalCD."Rate of CD" := UpdateCDInfo(InsCalCD."Payment Date", InsCalCD."CD Days", CD, InsCalCD."Scheme Code"); //PS03092021 change logic from due date
                    InsCalCD."CD Generation Date" := WORKDATE;
                    InsCalCD.MODIFY();
                    IF InsCalCD."Payment No." <> '' THEN BEGIN

                        dectaxamt := 0;
                        dectaxamt := CheckTaxAmt(InsCalCD."Invoice No.");
                        IF dectaxamt = 0 THEN BEGIN
                            IF (ABS(InsCalCD."Adjusted Amount") - (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item")) <= 0 THEN BEGIN
                                InsCalCD."CD Calculated On Amount" := 0;
                                InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                            END ELSE BEGIN
                                InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item"));
                                InsCalCD."Taxes & Charges Amt Adj" := (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item");
                            END;
                            InsCalCD.MODIFY();
                        END ELSE BEGIN
                            decBaltax := 0;
                            IF (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item") - dectaxamt >= 0 THEN BEGIN
                                decBaltax := (InsCalCD."Taxes & Charges Amount" + InsCalCD."Amount Excluded Item" + InsCalCD."GST Amount Excluded Item") - dectaxamt;
                                IF (ABS(InsCalCD."Adjusted Amount") - decBaltax) <= 0 THEN BEGIN
                                    InsCalCD."CD Calculated On Amount" := 0;
                                    InsCalCD."Taxes & Charges Amt Adj" := ABS(InsCalCD."Adjusted Amount");
                                END ELSE BEGIN
                                    InsCalCD."CD Calculated On Amount" := (ABS(InsCalCD."Adjusted Amount") - decBaltax);
                                    InsCalCD."Taxes & Charges Amt Adj" := decBaltax;
                                END;
                            END ELSE
                                InsCalCD."CD Calculated On Amount" := ABS(InsCalCD."Adjusted Amount");
                            InsCalCD.MODIFY();
                        END;
                        InsCalCD."CD to be Given" := ROUND(((InsCalCD."CD Calculated On Amount") * InsCalCD."Rate of CD") / 100, 0.01);
                        InsCalCD."CD Amount" := (InsCalCD."CD to be Given" - InsCalCD."Invoice CD Amount");
                        InsCalCD.MODIFY();
                    END;
                END;
                IsInsert := FALSE;
            UNTIL recDetCustLedger.NEXT = 0;
        END;
    end;

    local procedure GLS()
    begin
    end;

    local procedure DeleteCalEligibility(FromDt: Date; ToDt: Date)
    begin
        CalEligibility.RESET();
        CalEligibility.SETRANGE("From Date", FromDt);
        CalEligibility.SETRANGE("To Date", ToDt);
        IF CalEligibility.FINDFIRST THEN
            REPEAT
                CalEligibility.DELETE();
            UNTIL CalEligibility.NEXT = 0;
    end;

    local procedure DeleteSRCN()
    var
        CallSummary: Record 50027;
    begin
        CallSummary.RESET();
        CallSummary.SETFILTER("Payment No.", '%1', '');
        IF CallSummary.FINDFIRST THEN
            REPEAT
                CallSummary.DELETE
              UNTIL CallSummary.NEXT = 0;
    end;

    procedure CreateVoucher(PPScheme: Record 50027)
    var
        recGJL: Record 81;
        LineNo: Integer;
        recGJL1: Record 81;
        DocNo: Code[20];
        cdPostNo: Code[20];
        recGJB: Record 232;
        NoSeries: Codeunit 396;
        "LastDocNo.": Code[20];
        recNoSerLine: Record 309;
        LastDocDate: Date;
        recSchMaster: Record 50005;
        recGJNarration: Record "Gen. Journal Narration";
        recNoSerLine1: Record 309;
    begin
        "LastDocNo." := '';
        LastDocDate := 0D;
        DocNo := '';

        recSchMaster.GET(PPScheme."Scheme Code");
        recSchMaster.TESTFIELD("General Journal Templates");
        recSchMaster.TESTFIELD("General Journal Batches");
        recSchMaster.TESTFIELD("GL Account No.");
        recGJL.RESET();
        recGJL.INIT();
        recGJL.VALIDATE("Journal Template Name", recSchMaster."General Journal Templates");
        recGJL.VALIDATE("Journal Batch Name", recSchMaster."General Journal Batches");

        LineNo := 0;
        recGJL1.RESET();
        recGJL1.SETRANGE("Journal Template Name", recGJL."Journal Template Name");
        recGJL1.SETRANGE("Journal Batch Name", recGJL."Journal Batch Name");
        IF recGJL1.FINDLAST THEN BEGIN
            LineNo := recGJL1."Line No." + 10000;
            DocNo := recGJL1."Document No.";
        END ELSE BEGIN
            LineNo := 10000;
        END;
        recGJL.VALIDATE("Line No.", LineNo);
        cdPostNo := '';
        recGJB.RESET();
        recGJB.SETRANGE("Journal Template Name", recGJL."Journal Template Name");
        recGJB.SETRANGE(Name, recGJL."Journal Batch Name");
        IF recGJB.FIND('-') THEN BEGIN
            DocNo := NoSeries.GetNextNo(recGJB."No. Series", WORKDATE, TRUE);
            cdPostNo := recGJB."Posting No. Series";
        END;
        recGJL.VALIDATE("Document No.", DocNo);
        recGJL.VALIDATE("Document Date", PPScheme."Invoice Date");
        recGJL.VALIDATE("Posting Date", WORKDATE);
        recGJL.VALIDATE("Document Type", recGJL."Document Type"::" ");
        recGJL.VALIDATE("External Document No.", PPScheme."Payment No.");
        recGJL.VALIDATE("Account Type", recGJL."Account Type"::Customer);
        recGJL.VALIDATE("Account No.", PPScheme."Customer No.");
        recGJL.VALIDATE("Account No.");
        recGJL.VALIDATE("Credit Amount", PPScheme."CD to be Given");
        recGJL.VALIDATE("Bal. Account Type", recGJL."Bal. Account Type"::"G/L Account");
        recGJL.VALIDATE("Bal. Account No.", recSchMaster."GL Account No.");
        recGJL.VALIDATE("Posting No. Series", cdPostNo);
        //recGJL.VALIDATE("Source Code",'JOURNALV');
        recGJL.VALIDATE("Source Code", 'GENJNL');
        recGJL."Cal. Scheme Line No." := PPScheme."Line No.";
        recGJL.VALIDATE("Shortcut Dimension 1 Code", PPScheme."State Code");
        recGJL.VALIDATE("Shortcut Dimension 2 Code", PPScheme."Warehouse code");
        recGJL.VALIDATE("Finance Branch A/c Code", 'HR_HO');
        recGJL."PPS Invoice No." := PPScheme."Invoice No.";
        //acxcp+
        CreateNarration(recGJL."Journal Template Name", recGJL."Journal Batch Name", recGJL."Document No.", recGJL."Line No.", PPScheme);
        //acxcp-
        recGJL.INSERT(TRUE);

        UpdateJVPark(recGJL."Cal. Scheme Line No.", recGJL."Document No.", recGJL."External Document No.", recGJL."PPS Invoice No.");
    end;

    local procedure UpdateJVPark("LineNo.": Integer; CNNo: Code[20]; PaymentNo: Code[20]; InvNo: Code[20])
    var
        recCalCD: Record 50027;
    begin
        recCalCD.RESET();
        recCalCD.SETRANGE("Payment No.", PaymentNo);
        recCalCD.SETRANGE("Line No.", "LineNo.");
        recCalCD.SETRANGE("Invoice No.", InvNo);
        IF recCalCD.FINDFIRST THEN BEGIN
            recCalCD."Credit Note No." := CNNo;
            recCalCD.MODIFY();
        END;
    end;

    local procedure CreateNarration(TemplateCode: Code[20]; BatchCode: Code[20]; DocNumber: Code[20]; GenLineNo: Integer; recPPSSummary: Record 50027)
    var
        recGJNarration: Record "Gen. Journal Narration";
        recGJNarr1: Record "Gen. Journal Narration";
        TxtArray: array[20] of Text;
        Text1: Label 'Being CD Given on pre-placement scheme as per the';
        Text2: Label 'PPS policy and based on the working on';
        recGJNarr2: Record "Gen. Journal Narration";
        NarrLineNo: Integer;
        L1: array[5] of Integer;
    begin
        recGJNarration.RESET;
        recGJNarration.SETRANGE("Journal Template Name", TemplateCode);
        recGJNarration.SETRANGE("Journal Batch Name", BatchCode);
        recGJNarration.SETRANGE("Document No.", DocNumber);
        recGJNarration.SETFILTER("Line No.", '<>%1', 0);
        recGJNarration.SETRANGE("Gen. Journal Line No.", 0);
        IF NOT recGJNarration.FINDFIRST THEN BEGIN
            recGJNarr1.INIT;
            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            TxtArray[1] := Text1;
            recGJNarr1.Narration := TxtArray[1];
            recGJNarr1.INSERT(TRUE);

            TxtArray[3] := FORMAT(recPPSSummary.FIELDCAPTION("Invoice No.")) + '-' + FORMAT(recPPSSummary."Invoice No.");
            TxtArray[4] := FORMAT(recPPSSummary.FIELDCAPTION("Invoice Amt. Exclud GST")) + '-' + FORMAT(recPPSSummary."Invoice Amt. Exclud GST");
            TxtArray[5] := FORMAT(recPPSSummary.FIELDCAPTION("Taxes & Charges Amount")) + '-' + FORMAT(recPPSSummary."Taxes & Charges Amount");
            TxtArray[6] := FORMAT(recPPSSummary.FIELDCAPTION("Adjusted Amount")) + '-' + FORMAT(recPPSSummary."Adjusted Amount");
            TxtArray[7] := FORMAT(recPPSSummary.FIELDCAPTION("Taxes & Charges Amt Adj")) + '-' + FORMAT(recPPSSummary."Taxes & Charges Amt Adj");
            TxtArray[8] := FORMAT(recPPSSummary.FIELDCAPTION("CD Calculated On Amount")) + '-' + FORMAT(recPPSSummary."CD Calculated On Amount");
            TxtArray[9] := FORMAT(recPPSSummary.FIELDCAPTION("Payment No.")) + '-' + FORMAT(recPPSSummary."Payment No.");
            TxtArray[10] := FORMAT(recPPSSummary.FIELDCAPTION("Payment Amount")) + '-' + FORMAT(recPPSSummary."Payment Amount");
            TxtArray[11] := FORMAT(recPPSSummary.FIELDCAPTION("Payment Date")) + '-' + FORMAT(recPPSSummary."Payment Date");
            TxtArray[12] := FORMAT(recPPSSummary.FIELDCAPTION("Rate of CD")) + '-' + FORMAT(recPPSSummary."Rate of CD");


            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            TxtArray[2] := Text2;
            recGJNarr1.Narration := TxtArray[2];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[3];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[4];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[5];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[6];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[7];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[8];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[9];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[10];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[11];
            recGJNarr1.INSERT(TRUE);

            recGJNarr1."Journal Template Name" := TemplateCode;
            recGJNarr1."Journal Batch Name" := BatchCode;
            recGJNarr1."Document No." := DocNumber;
            recGJNarr1."Line No." := GetLineNo(DocNumber);
            recGJNarr1.Narration := TxtArray[12];
            recGJNarr1.INSERT(TRUE);
        END;
    end;

    local procedure GetLineNo(DocNo: Code[20]) Num1: Integer
    var
        recNarr4: Record "Gen. Journal Narration";
    begin
        Num1 := 0;
        recNarr4.RESET();
        recNarr4.SETRANGE("Document No.", DocNo);
        IF recNarr4.FINDLAST THEN
            Num1 := recNarr4."Line No." + 10000
        ELSE
            Num1 := 10000;
    end;
}

