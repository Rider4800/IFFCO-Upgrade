report 50048 "Upload Bank Statement"
{
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("<Control1000000003>")
                {
                    Caption = 'Options';
                    group("Import From")
                    {
                        Caption = 'Import From';
                        field("Excel File Name"; FileName)
                        {

                            trigger OnAssistEdit()
                            var
                                Instr: InStream;
                            begin
                                RequestFile;
                                SheetName := ExcelBuf.SelectSheetsNameStream(Instr);
                            end;
                        }
                        field("Excel Sheet Name"; SheetName)
                        {
                            trigger OnAssistEdit()
                            var
                                Instr: InStream;
                            begin
                                IF ServerFileName = '' THEN
                                    RequestFile;
                                SheetName := ExcelBuf.SelectSheetsNameStream(Instr);
                            end;
                        }
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

    trigger OnPostReport()
    begin
        ExcelBuf.DELETEALL();
        IF GETLASTERRORTEXT = '' THEN BEGIN
            MESSAGE('Import Successfully');
        END;
    end;

    trigger OnPreReport()
    begin
        CLEARLASTERROR();
        ExcelBuf.DELETEALL();
        ReadExcelSheet(ServerFileName, SheetName);
        //InsertGenJourLine;
    end;

    var
        ExcelBuf: Record 370;
        FileMgt: Codeunit 419;
        FileName: Text;
        ServerFileName: Text;
        SheetName: Text;
        DataStartLineNo: Integer;
        TotalRecNo: Integer;
        RecNo: Integer;
        Window: Dialog;
        intNo: Integer;
        TotalCol: Integer;
        oLineNo: Integer;
        X: Integer;
        TotalRow: Integer;
        OpeningBal: Decimal;
        Day: Integer;
        Month: Integer;
        Year: Integer;
        CustomerName: Text;
        NoofDays: Integer;
        ActualinaYear: Integer;
        InterestRate: Decimal;
        InterestPayable: Decimal;
        "TDS%": Decimal;
        TDSAmount: Decimal;
        PrincipalPayable: Decimal;
        NetPayment: Decimal;
        ClosingPrincipal: Decimal;
        InterestpaidRate: Decimal;
        InterestPaidAmt: Decimal;
        RedemptiomPremium: Decimal;
        oPosted: Boolean;
        RoundingDebit: Decimal;
        Roundingcredit: Decimal;
        RoundingBal: Decimal;
        Currency: Record 4;
        UniQueId: Text;
        Debit: Decimal;
        Credit: Decimal;
        txtVoucherType: Text;
        SignedAmount: Decimal;
        PreUniqueId: Text;
        Day1: Integer;
        Month1: Integer;
        Year1: Integer;
        Day2: Integer;
        Month2: Integer;
        Year2: Integer;
        NetProcessigFee: Decimal;
        "Subvention Amount": Decimal;
        "Processing Fee Gross": Decimal;
        Num: Integer;
        recGENJOURLINE: Record 81;
        recgenbatch: Record 232;
        recgentemplate: Record 80;
        recGenjourline2: Record 81;
        InsGenJournalLine: Record 81;
        JournalDocNo: Code[20];
        JournalCount: Integer;
        JournalLineno: Integer;
        RecGLLineBatch: Record 232;
        vendorNum: Code[20];
        num2: Integer;
        eNUm: Code[20];
        gnum: Integer;
        vcodecheck: Code[20];
        Recnarration: Record "Gen. Journal Narration";
        DimSetid: Integer;
        CuDim: Codeunit 408;
        RecDimSetEntry: Record 480;
        DimArr: array[4] of Code[20];
        Flag: Boolean;
        Snumber: Integer;
        TemplateName: Code[20];
        BatchName: Code[20];
        Text001: Label 'Import Excel File';
        Text002: Label 'You must enter a file name.';
        Text003: Label 'Analyzing Data...';
        cone: Text;
        ppo: Text;
        txt1: Text;
        txt2: Text;
        txt3: Text;
        txt4: Text;
        txt5: Text;
        txt6: Text;
        txt7: Text;
        txt8: Text;
        txt9: Text;
        txt10: Text;
        recBankStatement: Record 50004;
        recBSUins: Record 50004;
        dtDate: Date;

    local procedure RequestFile()
    var
        Outstr: OutStream;
        InStr: Instream;
        TempBlbCodeu: Codeunit "Temp Blob";
    begin
        // IF FileName <> '' THEN
        //     ServerFileName := FileMgt.UploadFile(Text001, FileName)
        // ELSE
        //     ServerFileName := FileMgt.UploadFile(Text001, '.xlsx');
        Clear(TempBlbCodeu);
        Clear(InStr);
        TempBlbCodeu.CreateInStream(InStr);

        if FileName = '' then
            FileName := '.xlsx';
        UploadIntoStream('', '', '', FileName, InStr);

        ServerFileName := FileName;
        ValidateServerFileName;
        FileName := FileMgt.GetFileName(ServerFileName);
    end;

    local procedure ValidateServerFileName()
    begin
        IF ServerFileName = '' THEN BEGIN
            FileName := '';
            SheetName := '';
            ERROR(Text002);
        END;
    end;

    procedure ReadExcelSheet(p_FileName: Text[250]; p_SheetName: Text[250])
    var
        oLineNo: Integer;
        otstr: OutStream;
        instrm: InStream;
        BlobCu: Codeunit "Temp Blob";
    begin
        ExcelBuf.LOCKTABLE;
        //ExcelBuf.OpenBook(p_FileName, p_SheetName);
        ExcelBuf.LOCKTABLE;
        BlobCu.CreateInStream(instrm);
        BlobCu.CreateOutStream(otstr);
        ExcelBuf.SaveToStream(otstr, false);
        ExcelBuf.OpenBookStream(instrm, p_SheetName);

        ExcelBuf.ReadSheet;
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalCol := ExcelBuf.COUNT();
        ExcelBuf.RESET();
        IF ExcelBuf.FINDLAST THEN
            TotalRow := ExcelBuf."Row No.";



        FOR X := 2 TO TotalRow DO BEGIN
            recBankStatement.RESET();
            IF recBankStatement.FINDLAST THEN
                Num := recBankStatement."Entry No." + 1
            ELSE
                Num := 1;
            recBSUins.RESET();
            recBSUins.INIT();
            recBSUins."Entry No." := Num;
            recBSUins."Dr/CR" := GetExcelCell(X, 1);
            IF GetExcelCell(X, 2) <> '0' THEN
                EVALUATE(recBSUins."Entry Amount", GetExcelCell(X, 2));
            dtDate := 0D;
            EVALUATE(dtDate, FORMAT(GetExcelCell(X, 3)));
            recBSUins."Value date" := dtDate;
            recBSUins.Product := GetExcelCell(X, 4);
            recBSUins."Party Code" := GetExcelCell(X, 5);
            recBSUins."Party Name" := GetExcelCell(X, 6);
            EVALUATE(recBSUins."Virtual Account Number", GetExcelCell(X, 7));
            recBSUins.Locations := GetExcelCell(X, 8);
            recBSUins."Remitting Bank" := GetExcelCell(X, 9);
            recBSUins."UTR No" := GetExcelCell(X, 10);
            recBSUins."Remitter Name" := GetExcelCell(X, 11);
            recBSUins."Remitter Account No" := GetExcelCell(X, 12);
            recBSUins."Region Name" := GetExcelCell(X, 13);
            recBSUins."Branch Name" := GetExcelCell(X, 14);
            recBSUins.INSERT();
            recBSUins."Uploaded By" := USERID;
            recBSUins."Uploaded Date" := TODAY;
            recBSUins."Uploaded Time" := TIME;
        END;
    end;

    procedure GetExcelCell(p_RowNo: Integer; p_ColumnNo: Integer) Text: Text[250]
    begin
        IF ExcelBuf.GET(p_RowNo, p_ColumnNo) THEN
            EXIT(ExcelBuf."Cell Value as Text");
        EXIT('');
    end;
}

