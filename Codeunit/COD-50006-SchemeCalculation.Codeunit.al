codeunit 50006 "Scheme Calculation"
{

    trigger OnRun()
    begin
    end;

    var
        recSchemeSalesLine: Record 50012;
        recSchemeMaster: Record 50005;
        recSalesHeader: Record 36;
        recSalesLine: Record 37;
        recItem: Record 27;
        InsSalesLineCal: Record 50016;
        recSalesLineCal: Record 50016;
        recSchemePayTerm: Record 50017;
        reccustDis: Record 340;
        recCust: Record 18;
        InSalesLine: Record 37;
        texChargeCode: Text[30];

    procedure SchemeonInvoice("DocNo.": Code[20])
    var
        recSalesLine1: Record 37;
    begin
        recSalesHeader.RESET();
        recSalesHeader.SETRANGE("No.", "DocNo.");
        IF recSalesHeader.FINDFIRST THEN BEGIN
            recSalesLine1.RESET();
            recSalesLine1.SETRANGE("Document No.", recSalesHeader."No.");
            IF recSalesLine1.FIND('-') THEN BEGIN
                REPEAT
                    recSchemeMaster.RESET();
                    recSchemeMaster.SETRANGE("Scheme Code", recSalesLine1."Scheme Code");
                    recSchemeMaster.SETRANGE("Inventory Location ID", recSalesLine1."Location Code");
                    recSchemeMaster.SETFILTER("To Date", '%1|>=%2', 0D, recSalesHeader."Posting Date");
                    recSchemeMaster.SETRANGE("From Date", 0D, recSalesHeader."Posting Date");
                    IF recSchemeMaster.FINDFIRST THEN BEGIN
                        //REPEAT
                        recSchemeSalesLine.RESET();
                        recSchemeSalesLine.SETRANGE("Scheme Code", recSchemeMaster."Scheme Code");
                        IF recSchemeSalesLine."Minimum Quantity" <> 0 THEN
                            recSchemeSalesLine.SETFILTER("Minimum Quantity", '<=%1', recSalesLine1.Quantity);
                        recSchemeSalesLine.SETFILTER("Ending Date", '%1|>=%2', 0D, recSalesHeader."Posting Date");
                        recSchemeSalesLine.SETRANGE("Starting Date", 0D, recSalesHeader."Posting Date");
                        IF recSchemeSalesLine.FINDFIRST THEN BEGIN
                            REPEAT
                                recItem.RESET();
                                recItem.SETRANGE("No.", recSalesLine1."No.");
                                recItem.SETRANGE("Item Disc. Group", recSchemeSalesLine.Code);
                                IF recItem.FINDFIRST THEN BEGIN
                                    InsSalesLineCal.RESET();
                                    InsSalesLineCal.INIT();
                                    InsSalesLineCal."Document No." := recSalesLine1."Document No.";
                                    InsSalesLineCal."Document Line No." := recSalesLine1."Line No.";
                                    InsSalesLineCal."Scheme Code" := recSalesLine1."Scheme Code";
                                    InsSalesLineCal."Scheme Date" := recSchemeMaster."Scheme Date";
                                    InsSalesLineCal."Start Date" := recSchemeSalesLine."Scheme From Date";
                                    InsSalesLineCal."End Date" := recSchemeSalesLine."Scheme To Date";
                                    InsSalesLineCal."Item No." := recSalesLine1."No.";
                                    InsSalesLineCal."Item Name" := recSalesLine1.Description;
                                    InsSalesLineCal.VALIDATE("Tax Charge Code", recSchemeSalesLine."Tax Charge Code");
                                    InsSalesLineCal.VALIDATE("Scheme Calculation Type", recSchemeSalesLine."Scheme Calculation Type");
                                    InsSalesLineCal.VALIDATE(Type, recSchemeSalesLine.Type);
                                    InsSalesLineCal.Code := recSchemeSalesLine.Code;
                                    InsSalesLineCal."Line Discount" := recSchemeSalesLine."Line Discount";
                                    InsSalesLineCal."Minimum Quantity" := recSchemeSalesLine."Minimum Quantity";
                                    InsSalesLineCal."Line Quantity" := recSalesLine1.Quantity;
                                    InsSalesLineCal."Line Amount" := recSalesLine1."Line Amount";
                                    InsSalesLineCal.VALIDATE("OrderPriority Scheme", recSchemeMaster."OrderPriority Scheme");
                                    IF recSchemeSalesLine."Scheme Calculation Type" = recSchemeSalesLine."Scheme Calculation Type"::"Fixed Value" THEN
                                        InsSalesLineCal."Discount Amount" := recSchemeSalesLine."Line Discount";
                                    IF recSchemeSalesLine."Scheme Calculation Type" = recSchemeSalesLine."Scheme Calculation Type"::"Amount Per Qty." THEN
                                        InsSalesLineCal."Discount Amount" := ROUND(recSalesLine1.Quantity * recSchemeSalesLine."Line Discount", 0.01);

                                    IF recSchemeSalesLine."Scheme Calculation Type" = recSchemeSalesLine."Scheme Calculation Type"::Percentage THEN
                                        InsSalesLineCal."Discount Amount" := ROUND(recSalesLine1."Line Amount" * recSchemeSalesLine."Line Discount" / 100, 0.01);
                                    IF InsSalesLineCal."Line Amount" - InsSalesLineCal."Discount Amount" < 0 THEN
                                        ERROR('Line amount should not be negative value agaisnt line no.%1...', recSalesLine1."Line No.");
                                    InsSalesLineCal."Free Item Code" := recSchemeSalesLine."Free Item Code";
                                    InsSalesLineCal.INSERT(TRUE);
                                END;
                                IF recSchemeSalesLine."Free Item Code" <> '' THEN
                                    AddFreeItem(recSalesHeader."No.", recSalesHeader."Posting Date");
                            UNTIL recSchemeSalesLine.NEXT = 0;
                        END;
                        UpdateSalesLine(recSalesLine1."Document No.", recSalesLine1."Line No.");
                        // UNTIL recSchemeMaster.NEXT=0;
                    END;
                UNTIL recSalesLine1.NEXT = 0;
            END;
            recSalesHeader.VALIDATE("Payment Terms Code", recSchemeSalesLine."Payment Term ID");
            recSalesHeader.MODIFY();
        END;
    end;

    procedure UpdateSalesLine("DocNo.": Code[20]; LineNo: Integer)
    var
        decTotalDis: Decimal;
    begin
        decTotalDis := 0;
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", "DocNo.");
        recSalesLine.SETRANGE("Line No.", LineNo);
        IF recSalesLine.FINDFIRST THEN BEGIN
            recSalesLineCal.RESET();
            recSalesLineCal.SETRANGE("Document No.", recSalesLine."Document No.");
            recSalesLineCal.SETRANGE("Document Line No.", recSalesLine."Line No.");
            IF recSalesLineCal.FINDFIRST THEN BEGIN
                REPEAT
                    decTotalDis += recSalesLineCal."Discount Amount";
                UNTIL recSalesLineCal.NEXT = 0;
            END;
            IF recSalesLine."Line Amount" - decTotalDis < 0 THEN
                ERROR('Line amount should not be negative value agaisnt line no.%1...', recSalesLine."Line No.");
            recSalesLine.VALIDATE("Line Discount Amount", decTotalDis);
            recSalesLine.MODIFY();
        END;
    end;

    local procedure UpdatePaymentTerm("DocNo.": Code[20])
    begin
        /*recSalesHeader.RESET();
        recSalesHeader.SETRANGE("No.","DocNo.");
        IF recSalesHeader.FINDFIRST THEN BEGIN
          recSchemeSalesLine.RESET();
          recSchemeSalesLine.SETRANGE("Scheme Code",recSalesHeader."Scheme Code");
          recSchemeSalesLine.SETFILTER("Ending Date",'%1>=%2',0D,recSalesHeader."Posting Date");
          recSchemeSalesLine.SETRANGE("Starting Date",0D,recSalesHeader."Posting Date");
          IF recSchemeSalesLine.FINDFIRST THEN BEGIN
            recSalesHeader.VALIDATE("Payment Terms Code",recSchemeSalesLine."Payment Term ID");
            recSalesHeader.MODIFY();
          END;
        END;
        
           recSchemePayTerm.RESET();
          recSchemePayTerm.SETFILTER("Ending Date",'%1>=%2',0D,recSalesHeader."Posting Date");
          recSchemePayTerm.SETRANGE("Starting Date",0D,recSalesHeader."Posting Date");
             IF recSchemePayTerm.FINDFIRST THEN BEGIN
            IF recSchemePayTerm."Sales Type" = recSchemePayTerm."Sales Type"::Customer
              THEN BEGIN
                recSchemePayTerm.SETRANGE("Sales Code",recSalesHeader."Sell-to Customer No.");
                recSalesHeader.VALIDATE("Payment Terms Code",recSchemePayTerm."Credit Payment Term");
           END;
             IF recSchemePayTerm."Sales Type" = recSchemePayTerm."Sales Type"::"All Customer"
               THEN BEGIN
                 recSalesHeader.VALIDATE("Payment Terms Code",recSchemePayTerm."Credit Payment Term");
              END;
                IF recSchemePayTerm."Sales Type" = recSchemePayTerm."Sales Type"::"Customer Discount Group"
                THEN BEGIN
                recCust.RESET();
                recCust.SETRANGE("No.",recSalesHeader."Sell-to Customer No.");
                IF recCust.FINDFIRST THEN BEGIN
                  reccustDis.RESET();
                  reccustDis.SETRANGE(Code,recCust."Customer Disc. Group");
                  IF reccustDis.FINDFIRST THEN BEGIN
                    recSchemePayTerm.SETRANGE("Sales Code",recCust."Customer Disc. Group");
                    IF recSchemePayTerm.FINDFIRST THEN
                    recSalesHeader.VALIDATE("Payment Terms Code",recSchemePayTerm."Credit Payment Term");
                  END;
                END;
              END;
            END;
            recSalesHeader.MODIFY();
         END;
         */

    end;

    local procedure AddFreeItem("DocumentNo.": Code[20]; Date: Date)
    var
        IntLineNo: Integer;
        FreeItem: Code[20];
    begin
        InSalesLine.RESET();
        IntLineNo := 0;
        texChargeCode := '';
        InSalesLine.SETRANGE("Document No.", "DocumentNo.");
        IF InSalesLine.FINDLAST THEN
            IntLineNo := InSalesLine."Line No." + 10000;

        InSalesLine.RESET();
        InSalesLine.SETRANGE("Document No.", "DocumentNo.");
        InSalesLine.SETRANGE("Free Scheme Item", FALSE);
        IF InSalesLine.FIND('-') THEN BEGIN
            REPEAT
                recItem.RESET();
                recItem.SETRANGE("No.", InSalesLine."No.");
                IF recItem.FINDFIRST THEN BEGIN
                    recSalesLineCal.RESET();
                    recSalesLineCal.SETRANGE("Scheme Code", InSalesLine."Scheme Code");
                    recSalesLineCal.SETRANGE("Document No.", InSalesLine."Document No.");
                    recSalesLineCal.SETRANGE("Document Line No.", InSalesLine."Line No.");
                    IF recSalesLineCal.FIND('-') THEN BEGIN
                        REPEAT
                            IF recSalesLineCal.Type = recSalesLineCal.Type::"All Item" THEN BEGIN
                                IF recSalesLineCal.FINDFIRST THEN
                                    FreeItem := recSalesLineCal."Free Item Code";
                            END;
                            IF recSalesLineCal.Type = recSalesLineCal.Type::"Item Discount Group" THEN BEGIN
                                recItem.TESTFIELD("Item Disc. Group");
                                recSalesLineCal.SETRANGE(Code, recItem."Item Disc. Group");
                                IF recSalesLineCal.FINDFIRST THEN
                                    FreeItem := recSalesLineCal."Free Item Code";
                            END;
                            IF recSalesLineCal.Type = recSchemeSalesLine.Type::Item THEN BEGIN
                                recSalesLineCal.SETRANGE(Code, recItem."No.");
                                IF recSalesLineCal.FINDFIRST THEN
                                    FreeItem := recSalesLineCal."Free Item Code";
                            END;
                            InSalesLine.INIT();
                            InSalesLine.VALIDATE("Document Type", InSalesLine."Document Type");
                            InSalesLine.VALIDATE("Document No.", "DocumentNo.");
                            InSalesLine."Line No." := IntLineNo;
                            InSalesLine.INSERT(TRUE);
                            InSalesLine.VALIDATE(Type, InSalesLine.Type::Item);
                            InSalesLine.VALIDATE("Location Code", InSalesLine."Location Code");
                            InSalesLine.VALIDATE("No.", FreeItem);
                            InSalesLine.VALIDATE(Quantity, 1);
                            InSalesLine.VALIDATE("Unit Cost", 0);
                            InSalesLine."Free Scheme Item" := TRUE;
                            InSalesLine.MODIFY();
                            IntLineNo := IntLineNo + 10000;
                        UNTIL recSchemeSalesLine.NEXT = 0;
                    END;
                END;
            UNTIL InSalesLine.NEXT = 0;
        END;
    end;

    procedure InsertPostedCDDetails("DocNo.": Code[20]; "CustNo.": Code[20])
    var
        PInsCalCD: Record 50022;
        CalCd: Record 50020;
    begin
        CalCd.RESET();
        CalCd.SETRANGE("Customer No.", "CustNo.");
        CalCd.SETRANGE("Posted Credit Note ID", "DocNo.");
        IF CalCd.FINDFIRST THEN BEGIN
            PInsCalCD.RESET();
            PInsCalCD.SETRANGE("Customer No.", CalCd."Customer No.");
            PInsCalCD.SETRANGE("Payment No.", CalCd."Payment No.");
            PInsCalCD.SETRANGE("Dt. Cust. Led. Entry", CalCd."Dt. Cust. Led. Entry");
            IF NOT PInsCalCD.FINDFIRST THEN BEGIN
                PInsCalCD.INIT();
                PInsCalCD."Customer No." := CalCd."Customer No.";
                PInsCalCD."Payment No." := CalCd."Payment No.";
                PInsCalCD."Payment Date" := CalCd."Payment Date";
                PInsCalCD."Payment Amount" := CalCd."Payment Amount";
                PInsCalCD."Dt. Cust. Led. Entry" := CalCd."Dt. Cust. Led. Entry";
                PInsCalCD."Customer Name" := CalCd."Customer Name";
                PInsCalCD."Customer Disc. Group" := CalCd."Customer Disc. Group";
                PInsCalCD."Customer Posting Group" := CalCd."Customer Posting Group";
                PInsCalCD."Invoice No." := CalCd."Invoice No.";
                PInsCalCD."Invoice Date" := CalCd."Invoice Date";
                PInsCalCD."Invoince Due Date" := CalCd."Invoince Due Date";
                PInsCalCD."Invoice Amount" := CalCd."Invoice Amount";
                PInsCalCD."Adjusted Amount With Tax" := CalCd."Adjusted Amount With Tax";
                PInsCalCD."Adjusted Amount" := CalCd."Adjusted Amount";
                PInsCalCD.VALIDATE("Order Priority", CalCd."Order Priority");
                PInsCalCD.VALIDATE("Scheme Code", CalCd."Scheme Code");
                PInsCalCD."Invoice CD Amount" := CalCd."Invoice CD Amount";
                PInsCalCD."Invoice Amt. Exclud GST" := CalCd."Invoice Amt. Exclud GST";
                PInsCalCD."Taxes & Charges Amount" := CalCd."Taxes & Charges Amount";
                PInsCalCD."CD Days" := CalCd."CD Days";
                PInsCalCD."Rate of CD" := CalCd."Rate of CD";
                PInsCalCD.Date := CalCd.Date;
                PInsCalCD."CD Calculated On Amount" := CalCd."CD Calculated On Amount";
                PInsCalCD."CD to be Given" := CalCd."CD to be Given";
                PInsCalCD."CD Amount" := CalCd."CD Amount";
                PInsCalCD."State Code" := CalCd."State Code";
                PInsCalCD."Warehouse code" := CalCd."Warehouse code";
                PInsCalCD."Credit Note No." := CalCd."Credit Note No.";
                PInsCalCD."Posted Credit Note ID" := CalCd."Posted Credit Note ID";
                PInsCalCD."Posted Credit Note Date" := CalCd."Posted Credit Note Date";
                PInsCalCD.INSERT();
            END;
        END;
    end;
}

