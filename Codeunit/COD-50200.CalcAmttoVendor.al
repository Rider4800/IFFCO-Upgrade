codeunit 50200 CalcAmttoVendor
{
    Permissions = tabledata 122 = RIMD;
    procedure ImportExcel()
    begin
        SelectFile();
    end;

    procedure SelectFile()
    begin
        UploadIntoStream('Please choose the excel file.', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            ExcelBuffer.GetSheetsNameListFromStream(IStream, NameValueBufferOut);
        end else
            Error('No excel sheet found!');

        //Import Data Start
        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        NameValueBufferOut.Reset();
        if NameValueBufferOut.FindSet() then begin
            repeat
                Clear(SheetName);
                SheetName := NameValueBufferOut.Value;
                ExcelBuffer.OpenBookStream(IStream, SheetName);
                ExcelBuffer.ReadSheet();

                MaxRowNo := 0;
                ExcelBuffer.Reset();
                if ExcelBuffer.FindLast() then
                    MaxRowNo := ExcelBuffer."Row No.";

                RowNo := 0;
                ColNo := 0;

                if SheetName = 'Sales Price' then begin
                    ImportData();
                end;

            until NameValueBufferOut.Next() = 0;
            Message('Data is successfully Imported');
        end;
        //Import Data End
    end;

    procedure ImportData()
    begin
        For RowNo := 4 TO MaxRowNo Do begin
            //->17783 move data from NAV 2016 sales price excel to BC Cloud Sales price table
            // Rec7001.Init();
            // Rec7001."Item No." := GetValueAtCell(RowNo, 1);
            // Evaluate(salestype, GetValueAtCell(RowNo, 2));
            // Rec7001."Sales Type" := salestype;
            // Rec7001."Sales Code" := GetValueAtCell(RowNo, 3);
            // Evaluate(startdate, GetValueAtCell(RowNo, 4));
            // Rec7001."Starting Date" := startdate;
            // Rec7001."Currency Code" := GetValueAtCell(RowNo, 5);
            // Rec7001."Variant Code" := GetValueAtCell(RowNo, 6);
            // Rec7001."Unit of Measure Code" := GetValueAtCell(RowNo, 7);
            // Evaluate(minqty, GetValueAtCell(RowNo, 8));
            // Rec7001."Minimum Quantity" := minqty;
            // Evaluate(mrppricenew, GetValueAtCell(RowNo, 9));
            // Rec7001."MRP Price New" := mrppricenew;
            // Evaluate(unitprice, GetValueAtCell(RowNo, 10));
            // Rec7001."Unit Price" := unitprice;
            // Evaluate(PIVAT, GetValueAtCell(RowNo, 11));
            // Rec7001."Price Includes VAT" := PIVAT;
            // Evaluate(allowinvdisc, GetValueAtCell(RowNo, 12));
            // Rec7001."Allow Invoice Disc." := allowinvdisc;
            // Rec7001."VAT Bus. Posting Gr. (Price)" := GetValueAtCell(RowNo, 13);
            // Evaluate(Endingdate, GetValueAtCell(RowNo, 14));
            // Rec7001."Ending Date" := Endingdate;
            // Evaluate(allowlinedisc, GetValueAtCell(RowNo, 15));
            // Rec7001."Allow Line Disc." := allowlinedisc;
            // Rec7001.Insert();
            //<-17783   move data from NAV 2016 sales price excel to BC Cloud Sales price table

            //->17783   move data from BC Cloud Sales price table to BC Cloud Price list line table
            Rec7002.reset();
            if Rec7002.FindFirst() then begin
                repeat
                    Rec7001.Init();
                    Rec7001."Price List Code" := 'S00001';

                    Rec7001New.reset();
                    if not Rec7001New.findlast() then
                        LineNo1 := 1
                    else
                        LineNo1 := Rec7001New."Line No." + 1;

                    Rec7001."Line No." := lineno1;
                    Rec7001."Product No." := Rec7002."Item No.";
                    Rec7001."Assign-to No." := Rec7002."Sales Code";
                    Rec7001."Currency Code" := Rec7002."Currency Code";
                    Rec7001."Starting Date" := Rec7002."Starting Date";
                    Rec7001."Unit Price" := Rec7002."Unit Price";
                    Rec7001."Price Includes VAT" := Rec7002."Price Includes VAT";
                    Rec7001."Allow Invoice Disc." := true;
                    Evaluate(salestype, Format(Rec7002."Sales Type"));
                    Rec7001."Source Type" := salestype;
                    Rec7001."Ending Date" := Rec7002."Ending Date";
                    Rec7001."Unit of Measure Code" := Rec7002."Unit of Measure Code";
                    Rec7001."Allow Line Disc." := true;
                    Rec7001."MRP Price" := Rec7002."MRP Price New";
                    Rec7001.Insert();
                until Rec7002.next() = 0;
            end;
            //<-17783   move data from BC Cloud Sales price table to BC Cloud Price list line table
        end;
        // if PCrMHRec.Get(GetValueAtCell(RowNo, 1)) then begin
        //     Evaluate(PCrMHRec."Certificate of Analysis", GetValueAtCell(RowNo, 2));
        //     Evaluate(PCrMHRec."Finance Branch A/c Code", GetValueAtCell(RowNo, 3));
        //     Evaluate(PCrMHRec."Creation DateTime", GetValueAtCell(RowNo, 4));
        //     PCrMHRec.Modify();
        // end;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        ExcelBuffer.Reset();
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        FromFile: Text;
        IStream: InStream;
        FileName: Text;
        FileMgt: Codeunit "File Management";
        NameValueBufferOut: Record "Name/Value Buffer" temporary;
        SheetName: Text;
        MaxRowNo: Integer;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        DCLERec: Record "Detailed Cust. Ledg. Entry";
        PIHRec: Record "Purch. Inv. Header";

        PCrMHRec: Record "Purch. Cr. Memo Hdr.";
        Rec7001: Record 7001;
        Rec7002: Record 7002;
        salestype: Option "Customer","Customer Price Group","All Customers","Campaign";
        startdate: Date;
        minqty: Decimal;
        mrppricenew: Decimal;
        unitprice: Decimal;
        PIVAT: Boolean;
        allowinvdisc: Boolean;
        Endingdate: Date;
        allowlinedisc: Boolean;
        LineNo1: Integer;
        Rec7001New: record 7001;

    procedure AmttoVendor(T38: Record 38): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        GSTSetup.Get();
        TDSSetup.Get();
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);
        ReccPurchaseLine.Reset();
        ReccPurchaseLine.SetRange("Document Type", T38."Document Type");
        ReccPurchaseLine.SetRange("Document No.", T38."No.");
        if ReccPurchaseLine.FindSet() then
            repeat
                TotalAmt += ReccPurchaseLine."Line Amount";


                if ReccPurchaseLine.Type <> ReccPurchaseLine.Type::" " then begin
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccPurchaseLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat

                            case TaxTransactionValue."Value ID" of
                                6:
                                    begin
                                        ComponentName := 'SGST';
                                        sgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper3 := TaxTransactionValue.Percent;
                                    end;
                                2:
                                    begin
                                        ComponentName := 'CGST';
                                        cgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper2 := TaxTransactionValue.Percent;
                                    end;
                                3:
                                    begin
                                        ComponentName := 'IGST';
                                        igst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper1 := TaxTransactionValue.Percent;
                                    end;
                            end;
                        until TaxTransactionValue.Next() = 0;
                    cgstTOTAL += cgst;
                    sgstTOTAL += sgst;
                    igstTotal += igst;

                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccPurchaseLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            TDSAmt += TaxTransactionValue.Amount;
                        until TaxTransactionValue.Next() = 0;
                end;
            until ReccPurchaseLine.Next() = 0;
        exit((TotalAmt + igst + sgst + cgst) - TDSAmt);
    end;


    procedure TDSTCSAmt(RecordIDVar: RecordId): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
        TCSSetup: Record "TCS Setup";
    begin
        Clear(TDSAmt);
        TDSSetup.Get();
        TCSSetup.get();
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", RecordIDVar);
        TaxTransactionValue.Setfilter("Tax Type", '%1|%2', TDSSetup."Tax Type", TCSSetup."Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Value ID", 1);
        //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then
            repeat
                TDSAmt += TaxTransactionValue.Amount;
            until TaxTransactionValue.Next() = 0;


        exit(TDSAmt);
    end;

    procedure AmttoCustomer(T36: Record 36): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccSalesLine: Record "Sales Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TCSSetup: Record "TCS Setup";
        TDSAmt: Decimal;
    begin
        GSTSetup.Get();
        TCSSetup.Get();
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);
        ReccSalesLine.Reset();
        ReccSalesLine.SetRange("Document Type", T36."Document Type");
        ReccSalesLine.SetRange("Document No.", T36."No.");
        if ReccSalesLine.FindSet() then
            repeat
                TotalAmt += ReccSalesLine."Line Amount";


                if ReccSalesLine.Type <> ReccSalesLine.Type::" " then begin
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccSalesLine.RecordId);
                    //   TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat

                            case TaxTransactionValue."Value ID" of
                                6:
                                    begin
                                        ComponentName := 'SGST';
                                        sgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper3 := TaxTransactionValue.Percent;
                                    end;
                                2:
                                    begin
                                        ComponentName := 'CGST';
                                        cgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper2 := TaxTransactionValue.Percent;
                                    end;
                                3:
                                    begin
                                        ComponentName := 'IGST';
                                        igst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper1 := TaxTransactionValue.Percent;
                                    end;
                            end;
                        until TaxTransactionValue.Next() = 0;
                    cgstTOTAL += cgst;
                    sgstTOTAL += sgst;
                    igstTotal += igst;

                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccSalesLine.RecordId);
                    //   TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            TDSAmt += TaxTransactionValue.Amount;
                        until TaxTransactionValue.Next() = 0;
                end;
            until ReccSalesLine.Next() = 0;
        exit((TotalAmt + igst + sgst + cgst) + TDSAmt);
    end;

    procedure AmttoCustomerSalesLine(T37: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccSalesLine: Record "Sales Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TCSSetup: Record "TCS Setup";
        TDSAmt: Decimal;
    begin
        GSTSetup.Get();
        TCSSetup.Get();
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        TotalAmt := T37."Line Amount";
        if T37.Type <> T37.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T37.RecordId);
            //   TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat

                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                ComponentName := 'SGST';
                                sgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper3 := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                ComponentName := 'CGST';
                                cgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper2 := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                ComponentName := 'IGST';
                                igst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper1 := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
            cgstTOTAL += cgst;
            sgstTOTAL += sgst;
            igstTotal += igst;

            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T37.RecordId);
            //   TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    TDSAmt += TaxTransactionValue.Amount;
                until TaxTransactionValue.Next() = 0;
        end;

        exit((TotalAmt + igst + sgst + cgst) + TDSAmt);
    end;

    procedure GetTCSBaseAmt(SalesCreditMemoLine: Record "Sales Cr.Memo Line"): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
    begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", SalesCreditMemoLine.RecordId);
        // TaxTransactionValue.SetRange("Tax Type", 'TCS');
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Value ID", 7);
        if TaxTransactionValue.FindFirst() then
            exit(TaxTransactionValue.Amount)
        else
            exit(0);

    end;

    procedure GetTCSBaseAmtLine(Recordidpara: RecordId): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
    begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", Recordidpara);
        // TaxTransactionValue.SetRange("Tax Type", 'TCS');
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Value ID", 7);
        if TaxTransactionValue.FindFirst() then
            exit(TaxTransactionValue.Amount)
        else
            exit(0);

    end;


    procedure AmttoVendorPurchCrMemoHdr(T124: Record 124): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseCrMemoLine: Record "Purch. Cr. Memo Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        GSTSetup.Get();
        TDSSetup.Get();
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);
        ReccPurchaseCrMemoLine.Reset();
        ReccPurchaseCrMemoLine.SetRange("Document No.", T124."No.");
        if ReccPurchaseCrMemoLine.FindSet() then
            repeat
                TotalAmt += ReccPurchaseCrMemoLine."Line Amount";


                if ReccPurchaseCrMemoLine.Type <> ReccPurchaseCrMemoLine.Type::" " then begin
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccPurchaseCrMemoLine.RecordId);
                    //   TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat

                            case TaxTransactionValue."Value ID" of
                                6:
                                    begin
                                        ComponentName := 'SGST';
                                        sgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper3 := TaxTransactionValue.Percent;
                                    end;
                                2:
                                    begin
                                        ComponentName := 'CGST';
                                        cgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper2 := TaxTransactionValue.Percent;
                                    end;
                                3:
                                    begin
                                        ComponentName := 'IGST';
                                        igst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper1 := TaxTransactionValue.Percent;
                                    end;
                            end;
                        until TaxTransactionValue.Next() = 0;

                    if ReccPurchaseCrMemoLine."GST Reverse Charge" then begin
                        cgst := 0;
                        sgst := 0;
                        igst := 0;
                    end;
                    cgstTOTAL += cgst;
                    sgstTOTAL += sgst;
                    igstTotal += igst;

                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccPurchaseCrMemoLine.RecordId);
                    //   TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            TDSAmt += TaxTransactionValue.Amount;
                        until TaxTransactionValue.Next() = 0;
                end;
            until ReccPurchaseCrMemoLine.Next() = 0;
        exit((TotalAmt + igst + sgst + cgst) - TDSAmt);
    end;


    procedure AmttoVendorPurchInvHdr(T122: Record 122): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseInvLine: Record 123;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        GSTSetup.Get();
        TDSSetup.Get();
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);
        ReccPurchaseInvLine.Reset();
        ReccPurchaseInvLine.SetRange("Document No.", T122."No.");
        if ReccPurchaseInvLine.FindSet() then
            repeat
                TotalAmt += ReccPurchaseInvLine."Line Amount";


                if ReccPurchaseInvLine.Type <> ReccPurchaseInvLine.Type::" " then begin
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccPurchaseInvLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat

                            case TaxTransactionValue."Value ID" of
                                6:
                                    begin
                                        ComponentName := 'SGST';
                                        sgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper3 := TaxTransactionValue.Percent;
                                    end;
                                2:
                                    begin
                                        ComponentName := 'CGST';
                                        cgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper2 := TaxTransactionValue.Percent;
                                    end;
                                3:
                                    begin
                                        ComponentName := 'IGST';
                                        igst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                        GSTper1 := TaxTransactionValue.Percent;
                                    end;
                            end;
                        until TaxTransactionValue.Next() = 0;
                    if ReccPurchaseInvLine."GST Reverse Charge" then begin
                        cgst := 0;
                        sgst := 0;
                        igst := 0;
                    end;
                    cgstTOTAL += cgst;
                    sgstTOTAL += sgst;
                    igstTotal += igst;

                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", ReccPurchaseInvLine.RecordId);
                    //   TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            TDSAmt += TaxTransactionValue.Amount;
                        until TaxTransactionValue.Next() = 0;
                end;
            until ReccPurchaseInvLine.Next() = 0;

        exit((TotalAmt + igst + sgst + cgst) - TDSAmt);
    end;

    procedure TransferLineIGSTPerc(T39: Record "Transfer Line"): Decimal
    var
        igst: Decimal;
        GSTper3: Decimal;
        ReccPurchaseLine: Record "Transfer Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);


        GSTSetup.Get();
        TDSSetup.Get();
        //if T39.Type <> T39.Type::" " then begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
        //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        TaxTransactionValue.SetRange("Value ID", 3);
        if TaxTransactionValue.FindFirst() then begin
            ComponentName := 'IGST';
            igst := TaxTransactionValue.Percent;
            //end;

        end;

        exit(igst);
    end;

    procedure PurchLineIGST(T39: Record 39): Decimal
    var
        igst: Decimal;
        GSTper3: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);


        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 3);
            if TaxTransactionValue.FindFirst() then begin
                ComponentName := 'IGST';
                igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
            end;

        end;

        exit(igst);
    end;

    procedure PurchLineIGSTPerc(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 3);
            if TaxTransactionValue.FindFirst() then
                GSTper3 := TaxTransactionValue.Percent;

        end;

        exit(GSTper3);
    end;

    procedure PostedLineIGST(RecordIdPAra: RecordId): Decimal
    var
        igst: Decimal;
        GSTper3: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);


        GSTSetup.Get();
        TDSSetup.Get();
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", RecordIdPAra);
        // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        TaxTransactionValue.SetRange("Value ID", 3);
        if TaxTransactionValue.FindFirst() then begin
            ComponentName := 'IGST';
            igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
        end;

        exit(igst);
    end;

    procedure PostedLineIGSTPerc(RecordIDPara: RecordId): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", RecordIDPara);
        //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        TaxTransactionValue.SetRange("Value ID", 3);
        if TaxTransactionValue.FindFirst() then
            GSTper3 := TaxTransactionValue.Percent;



        exit(GSTper3);
    end;


    procedure PurchLineCGST(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 2);
            if TaxTransactionValue.FindFirst() then begin
                ComponentName := 'CGST';
                cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
            end;
        end;

        exit(cgst);
    end;

    procedure PurchLineCGSTPerc(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 2);
            if TaxTransactionValue.FindFirst() then
                GSTper3 := TaxTransactionValue.Percent;

        end;

        exit(GSTper3);
    end;


    procedure PurchLineSGST(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 6);
            if TaxTransactionValue.FindFirst() then begin
                ComponentName := 'SGST';
                sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
            end;
        end;

        exit(sgst);
    end;

    procedure PurchLineSGSTPerc(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 6);
            if TaxTransactionValue.FindFirst() then
                GSTper3 := TaxTransactionValue.Percent;

        end;

        exit(GSTper3);
    end;

    procedure SalesLineIGST(T39: Record 37): Decimal
    var
        igst: Decimal;
        GSTper3: Decimal;
        ReccPurchaseLine: Record 37;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);


        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 3);
            if TaxTransactionValue.FindFirst() then begin
                ComponentName := 'IGST';
                igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
            end;

        end;

        exit(igst);
    end;

    procedure SalesLineIGSTPerc(T39: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record 37;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 3);
            if TaxTransactionValue.FindFirst() then
                GSTper3 := TaxTransactionValue.Percent;

        end;

        exit(GSTper3);
    end;

    procedure SalesLineCGST(T39: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record 37;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 2);
            if TaxTransactionValue.FindFirst() then begin
                ComponentName := 'CGST';
                cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
            end;
        end;

        exit(cgst);
    end;

    procedure SalesLineCGSTPerc(T39: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record 37;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 2);
            if TaxTransactionValue.FindFirst() then
                GSTper3 := TaxTransactionValue.Percent;

        end;

        exit(GSTper3);
    end;


    procedure SalesPurchLineSGST(T39: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record 37;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 6);
            if TaxTransactionValue.FindFirst() then begin
                ComponentName := 'SGST';
                sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
            end;
        end;

        exit(sgst);
    end;

    procedure SalesLineSGSTPerc(T39: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record 37;
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            TaxTransactionValue.SetRange("Value ID", 6);
            if TaxTransactionValue.FindFirst() then
                GSTper3 := TaxTransactionValue.Percent;

        end;

        exit(GSTper3);
    end;

    procedure AmttoVendorLine(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        TDSSetup.Get();
        if T39.Type <> T39.Type::" " then begin
            TotalAmt := T39."Line Amount";
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                ComponentName := 'SGST';
                                sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper3 := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                ComponentName := 'CGST';
                                cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper2 := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                ComponentName := 'IGST';
                                igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper1 := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;

            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindFirst() then
                TDSAmt := TaxTransactionValue.Amount;

        end;


        exit((TotalAmt + igst + sgst + cgst) - TDSAmt);
    end;

    procedure PurchLineGSTPerc(RecordIdVar: RecordId): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(GSTper1);
        Clear(GSTper2);
        Clear(GSTper3);

        GSTSetup.Get();
        TDSSetup.Get();
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", RecordIdVar);
        //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then
            repeat
                case TaxTransactionValue."Value ID" of
                    6:
                        begin
                            GSTper3 := TaxTransactionValue.Percent;
                        end;
                    2:
                        begin
                            GSTper2 := TaxTransactionValue.Percent;
                        end;
                    3:
                        begin
                            GSTper1 := TaxTransactionValue.Percent;
                        end;
                end;
            until TaxTransactionValue.Next() = 0;

        exit(GSTper1 + GSTper2 + GSTper3);
    end;

    procedure TotalGSTAmtLine(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();

        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                ComponentName := 'SGST';
                                sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper3 := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                ComponentName := 'CGST';
                                cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper2 := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                ComponentName := 'IGST';
                                igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper1 := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;


        exit(igst + sgst + cgst);
    end;

    procedure TotalGSTAmtTransferLine(T39: Record "Transfer Line"): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Transfer Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();

        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
        // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then
            repeat
                case TaxTransactionValue."Value ID" of
                    6:
                        begin
                            ComponentName := 'SGST';
                            sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                            GSTper3 := TaxTransactionValue.Percent;
                        end;
                    2:
                        begin
                            ComponentName := 'CGST';
                            cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                            GSTper2 := TaxTransactionValue.Percent;
                        end;
                    3:
                        begin
                            ComponentName := 'IGST';
                            igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                            GSTper1 := TaxTransactionValue.Percent;
                        end;
                end;
            until TaxTransactionValue.Next() = 0;

        exit(igst + sgst + cgst);
    end;

    procedure TotalGSTAmtLinePurchLineArhc(T39: Record "Purchase Line Archive"): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();

        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                ComponentName := 'SGST';
                                sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper3 := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                ComponentName := 'CGST';
                                cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper2 := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                ComponentName := 'IGST';
                                igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper1 := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;


        exit(igst + sgst + cgst);
    end;


    procedure TotalGSTAmtLineSales(T37: Record 37): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();

        if T37.Type <> T37.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T37.RecordId);
            //TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                ComponentName := 'SGST';
                                sgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper3 := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                ComponentName := 'CGST';
                                cgst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper2 := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                ComponentName := 'IGST';
                                igst := abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                GSTper1 := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;


        exit(igst + sgst + cgst);
    end;

    procedure TotalGSTAmtLineSalesHead(T36: Record 36): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
        T37: Record 37;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();
        T37.Reset();
        T37.SetRange("Document Type", T36."Document Type");
        T37.SetRange("Document No.", T36."No.");
        T37.SetFilter(Type, '<>%1', T37.Type::" ");
        if T37.FindSet() then begin
            repeat
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetRange("Tax Record ID", T37.RecordId);
                //  TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                if TaxTransactionValue.FindSet() then
                    repeat
                        case TaxTransactionValue."Value ID" of
                            6:
                                begin
                                    ComponentName := 'SGST';

                                    sgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                    GSTper3 := TaxTransactionValue.Percent;
                                end;
                            2:
                                begin
                                    ComponentName := 'CGST';
                                    cgst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                    GSTper2 := TaxTransactionValue.Percent;
                                end;
                            3:
                                begin
                                    ComponentName := 'IGST';
                                    igst += abs(Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName)));
                                    GSTper1 := TaxTransactionValue.Percent;
                                end;
                        end;
                    until TaxTransactionValue.Next() = 0;
            until T37.Next() = 0;
        end;
        exit(igst + sgst + cgst);
    end;



    procedure TotalGSTAmtDoc(DocNo: Code[20]): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(GSTBaseAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocNo);
        // DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            DetGstLedEntry.CalcSums("GST Amount");
            IGSTAmt := abs(DetGstLedEntry."GST Amount");
        end;



        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocNo);
        //DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            DetGstLedEntry.CalcSums("GST Amount");
            SGSTAmt := abs(DetGstLedEntry."GST Amount");
        end;


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocNo);
        //DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            DetGstLedEntry.CalcSums("GST Amount");
            CGSTAmt := abs(DetGstLedEntry."GST Amount");
        end;


        Clear(TotalAmt);
        TotalAmt := IGSTAmt + SGSTAmt + CGSTAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure LineGSTBaseAmt(T39: Record 39): Decimal
    var
        GSTSetup: Record "GST Setup";
        TaxTransactionValue: Record "Tax Transaction Value";

    begin
        GSTSetup.Get();

        if T39.Type <> T39.Type::" " then begin

            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            //  TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 10);
            if TaxTransactionValue.FindFirst() then
                exit(TaxTransactionValue.Amount);
        end;
    end;

    procedure GetGSTBaseAmtLine(recordIDPara: RecordId): Decimal
    var
        GSTSetup: Record "GST Setup";
        TaxTransactionValue: Record "Tax Transaction Value";

    begin
        GSTSetup.Get();

        //if T39.Type <> T39.Type::" " then begin

        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", recordIDPara);
        //  TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Value ID", 10);
        if TaxTransactionValue.FindFirst() then
            exit(TaxTransactionValue.Amount);
        //end;
    end;

    procedure GetGSTBaseAmtPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        GSTBaseAmt: Decimal;
    begin
        Clear(GSTBaseAmt);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FindFirst() THEN begin
            DetGstLedEntry.CalcSums("GST Base Amount");
            GSTBaseAmt := Abs(DetGstLedEntry."GST Base Amount");
        end;

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FindFirst() THEN begin
            DetGstLedEntry.CalcSums("GST Base Amount");
            GSTBaseAmt := Abs(DetGstLedEntry."GST Base Amount");
        end;

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FindFirst() THEN begin
            DetGstLedEntry.CalcSums("GST Base Amount");
            GSTBaseAmt := Abs(DetGstLedEntry."GST Base Amount");
        end;
        EXIT(GSTBaseAmt);
    end;

    procedure GetIGSTAmtPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(GSTBaseAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN
            IGSTAmt := abs(DetGstLedEntry."GST Amount");

        EXIT(ABS(IGSTAmt));
    end;

    procedure GetCGSTAmtPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(GSTBaseAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN
            CGSTAmt := abs(DetGstLedEntry."GST Amount");

        Clear(TotalAmt);
        TotalAmt := IGSTAmt + SGSTAmt + CGSTAmt;
        EXIT(ABS(CGSTAmt));
    end;

    procedure GetSGSTAmtPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
    begin

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN
            SGSTAmt := abs(DetGstLedEntry."GST Amount");
        EXIT(ABS(SGSTAmt));
    end;

    procedure GetTotalGSTAmtPostedLineWithReversCharge(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(GSTBaseAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        DetGstLedEntry.SetRange("Reverse Charge", false);
        IF DetGstLedEntry.FINDFIRST THEN
            IGSTAmt := abs(DetGstLedEntry."GST Amount");


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        DetGstLedEntry.SetRange("Reverse Charge", false);
        IF DetGstLedEntry.FINDFIRST THEN
            SGSTAmt := abs(DetGstLedEntry."GST Amount");

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        DetGstLedEntry.SetRange("Reverse Charge", false);
        IF DetGstLedEntry.FINDFIRST THEN
            CGSTAmt := abs(DetGstLedEntry."GST Amount");

        Clear(TotalAmt);
        TotalAmt := IGSTAmt + SGSTAmt + CGSTAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure GetTotalGSTAmtPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(GSTBaseAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SetCurrentKey("Document No.", "HSN/SAC Code");
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FindSet() THEN begin
            DetGstLedEntry.CalcSums("GST Amount");
            IGSTAmt := abs(DetGstLedEntry."GST Amount");

        end;


        DetGstLedEntry.RESET();
        DetGstLedEntry.SetCurrentKey("Document No.", "HSN/SAC Code");
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FindSet() THEN begin
            DetGstLedEntry.CalcSums("GST Amount");
            SGSTAmt := abs(DetGstLedEntry."GST Amount");
        end;


        DetGstLedEntry.RESET();
        DetGstLedEntry.SetCurrentKey("Document No.", "HSN/SAC Code");
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FindSet() THEN begin
            DetGstLedEntry.CalcSums("GST Amount");
            CGSTAmt := abs(DetGstLedEntry."GST Amount");
        end;


        Clear(TotalAmt);
        TotalAmt := IGSTAmt + SGSTAmt + CGSTAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure GetGSTPerPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
    begin
        Clear(IGSTPer);
        Clear(CGSTPer);
        Clear(SGSTPer);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        IF DetGstLedEntry.FindFirst() THEN begin
            repeat
                IF DetGstLedEntry."GST Component Code" = 'IGST' then
                    IGSTPer := abs(DetGstLedEntry."GST %");
                IF DetGstLedEntry."GST Component Code" = 'SGST' then
                    SGSTPer := abs(DetGstLedEntry."GST %");
                IF DetGstLedEntry."GST Component Code" = 'CGST' then
                    CGSTPer := abs(DetGstLedEntry."GST %");
            until DetGstLedEntry.Next() = 0;
        end;

        EXIT(ABS(IGSTPer + SGSTPer + CGSTPer));
    end;

    procedure GetAmttoCustomerPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdSalesInv: Record 113;
        PstdSalesCrMemoLine: Record 115;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        LineAmt: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        TCSSetup: Record "TCS Setup";
        TDSAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(LineAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);
        Clear(TDSAmt);
        TCSSetup.Get();
        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            IGSTAmt := abs(DetGstLedEntry."GST Amount");
            //GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;



        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN
            SGSTAmt := abs(DetGstLedEntry."GST Amount");

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            CGSTAmt := abs(DetGstLedEntry."GST Amount");
            // GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;

        if PstdSalesCrMemoLine.Get(DocumentNo, DocLineNo) then begin
            if PstdSalesCrMemoLine.Type <> PstdSalesCrMemoLine.Type::" " then
                LineAmt := PstdSalesCrMemoLine."Line Amount";
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PstdSalesCrMemoLine.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindFirst() then
                TDSAmt := TaxTransactionValue.Amount;
        end;

        if PstdSalesInv.Get(DocumentNo, DocLineNo) then begin
            if PstdSalesInv.Type <> PstdSalesInv.Type::" " then
                LineAmt := PstdSalesInv."Line Amount";
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PstdSalesInv.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindFirst() then
                TDSAmt := TaxTransactionValue.Amount;
        end;

        Clear(TotalAmt);
        TotalAmt := (LineAmt + IGSTAmt + SGSTAmt + CGSTAmt) + TDSAmt;
        EXIT(ABS(TotalAmt));
    end;


    procedure GetAmttoVendorPostedLine(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        PstdPurchInv: Record 123;
        PstdPurchCrMemoLine: Record 125;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        LineAmt: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(LineAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);
        Clear(TDSAmt);
        TDSSetup.Get();
        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            IGSTAmt := abs(DetGstLedEntry."GST Amount");
            //GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;



        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN
            SGSTAmt := abs(DetGstLedEntry."GST Amount");

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            CGSTAmt := abs(DetGstLedEntry."GST Amount");
            // GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;

        if PstdPurchCrMemoLine.Get(DocumentNo, DocLineNo) then begin
            if PstdPurchCrMemoLine.Type <> PstdPurchCrMemoLine.Type::" " then
                LineAmt := PstdPurchCrMemoLine."Line Amount";
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PstdPurchCrMemoLine.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindFirst() then
                TDSAmt := TaxTransactionValue.Amount;
        end;

        if PstdPurchInv.Get(DocumentNo, DocLineNo) then begin
            if PstdPurchInv.Type <> PstdPurchInv.Type::" " then
                LineAmt := PstdPurchInv."Line Amount";
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PstdPurchInv.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindFirst() then
                TDSAmt := TaxTransactionValue.Amount;
        end;

        Clear(TotalAmt);
        TotalAmt := (LineAmt + IGSTAmt + SGSTAmt + CGSTAmt) - TDSAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure GetLineTDSAmt(PurchLine: Record 39): Decimal
    var

        TaxTransactionValue: Record "Tax Transaction Value";
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        TDSSetup.Get();
        Clear(TDSAmt);
        if PurchLine.Type <> PurchLine.Type::" " then begin

            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchLine.RecordId);
            //   TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetRange("Value ID", 1);
            //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindFirst() then
                TDSAmt := TaxTransactionValue.Amount;
        end;

        EXIT(ABS(TDSAmt));
    end;


    procedure GetAmttoVendorPostedDoc(DocumentNo: Code[20]): Decimal
    var
        PIH: Record 122;
        PCMH: Record 124;
        PstdPurchInv: Record 123;
        PstdPurchCrMemoLine: Record 125;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        LineAmt: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(LineAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);
        Clear(TDSAmt);
        TDSSetup.Get();
        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            repeat
                IGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;

            //GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;



        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN
            repeat
                SGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            repeat
                CGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;

            // GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;

        if PCMH.Get(DocumentNo) then begin
            PstdPurchCrMemoLine.reset;
            PstdPurchCrMemoLine.SetRange("Document No.", DocumentNo);
            PstdPurchCrMemoLine.SetFilter(Type, '<>%1', PstdPurchCrMemoLine.Type::" ");
            if PstdPurchCrMemoLine.FindSet() then
                repeat
                    LineAmt += PstdPurchCrMemoLine."Line Amount";
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", PstdPurchCrMemoLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then
                        TDSAmt += TaxTransactionValue.Amount;
                until PstdPurchCrMemoLine.next = 0;
        end;

        if PIH.Get(DocumentNo) then begin
            PstdPurchInv.Reset();
            PstdPurchInv.SetRange("Document No.", DocumentNo);
            PstdPurchInv.SetFilter(Type, '<>%1', PstdPurchInv.Type::" ");
            if PstdPurchInv.FindSet() then
                repeat
                    LineAmt += PstdPurchInv."Line Amount";
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", PstdPurchInv.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then
                        TDSAmt += TaxTransactionValue.Amount;
                until PstdPurchInv.Next() = 0;
        end;

        Clear(TotalAmt);
        TotalAmt := (LineAmt + IGSTAmt + SGSTAmt + CGSTAmt) - TDSAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure GetAmttoCustomerPostedDoc(DocumentNo: Code[20]): Decimal
    var
        SIH: Record 112;
        SCMH: Record 114;
        SalInvLine: Record 113;
        SalesCrMemoLine: Record 115;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        LineAmt: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        TCSSetup: Record "TCS Setup";
        TDSAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(LineAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);
        Clear(TDSAmt);
        TCSSetup.Get();
        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            repeat
                IGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;

            //GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;



        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN
            repeat
                SGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN begin
            repeat
                CGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;

            // GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;

        if SCMH.Get(DocumentNo) then begin
            SalesCrMemoLine.reset;
            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
            SalesCrMemoLine.SetFilter(Type, '<>%1', SalesCrMemoLine.Type::" ");
            if SalesCrMemoLine.FindSet() then
                repeat
                    LineAmt += SalesCrMemoLine."Line Amount";
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", SalesCrMemoLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then
                        TDSAmt += TaxTransactionValue.Amount;
                until SalesCrMemoLine.next = 0;
        end;

        if SIH.Get(DocumentNo) then begin
            SalInvLine.Reset();
            SalInvLine.SetRange("Document No.", DocumentNo);
            SalInvLine.SetFilter(Type, '<>%1', SalInvLine.Type::" ");
            if SalInvLine.FindSet() then
                repeat
                    LineAmt += SalInvLine."Line Amount";
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", SalInvLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then
                        TDSAmt += TaxTransactionValue.Amount;
                until SalInvLine.Next() = 0;
        end;

        Clear(TotalAmt);
        TotalAmt := (LineAmt + IGSTAmt + SGSTAmt + CGSTAmt) + TDSAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure GetAmttoCustomerPostedDocwithreversechargefilter(DocumentNo: Code[20]): Decimal
    var
        SIH: Record 112;
        SCMH: Record 114;
        SalInvLine: Record 113;
        SalesCrMemoLine: Record 115;
        TotalAmt: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        GSTBaseAmt: Decimal;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        LineAmt: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        TCSSetup: Record "TCS Setup";
        TDSAmt: Decimal;
    begin
        Clear(IGSTAmt);
        Clear(LineAmt);
        Clear(SGSTAmt);
        Clear(CGSTAmt);
        Clear(TDSAmt);
        TCSSetup.Get();
        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        DetGstLedEntry.SetRange("Reverse Charge", false);
        IF DetGstLedEntry.FINDFIRST THEN begin
            repeat
                IGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;

            //GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;



        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        DetGstLedEntry.SetRange("Reverse Charge", false);
        IF DetGstLedEntry.FINDFIRST THEN
            repeat
                SGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        DetGstLedEntry.SetRange("Reverse Charge", false);
        IF DetGstLedEntry.FINDFIRST THEN begin
            repeat
                CGSTAmt += abs(DetGstLedEntry."GST Amount");
            until DetGstLedEntry.next = 0;

            // GSTBaseAmt := abs(DetGstLedEntry."GST Base Amount");
        end;

        if SCMH.Get(DocumentNo) then begin
            SalesCrMemoLine.reset;
            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
            SalesCrMemoLine.SetFilter(Type, '<>%1', SalesCrMemoLine.Type::" ");
            if SalesCrMemoLine.FindSet() then
                repeat
                    LineAmt += SalesCrMemoLine."Line Amount";
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", SalesCrMemoLine.RecordId);
                    //  TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then
                        TDSAmt += TaxTransactionValue.Amount;
                until SalesCrMemoLine.next = 0;
        end;

        if SIH.Get(DocumentNo) then begin
            SalInvLine.Reset();
            SalInvLine.SetRange("Document No.", DocumentNo);
            SalInvLine.SetFilter(Type, '<>%1', SalInvLine.Type::" ");
            if SalInvLine.FindSet() then
                repeat
                    LineAmt += SalInvLine."Line Amount";
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", SalInvLine.RecordId);
                    // TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 1);
                    //TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then
                        TDSAmt += TaxTransactionValue.Amount;
                until SalInvLine.Next() = 0;
        end;

        Clear(TotalAmt);
        TotalAmt := (LineAmt + IGSTAmt + SGSTAmt + CGSTAmt) + TDSAmt;
        EXIT(ABS(TotalAmt));
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup1: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup1.Get() then
            exit;
        GSTSetup1.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup1."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    procedure GetIGSTAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 3);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;

    procedure GetCGSTAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 2);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;

    procedure GetSGSTAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 6);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;
}
