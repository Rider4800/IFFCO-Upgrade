report 50048 "Upload Bank Statement"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

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
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                RequestFile;
                            end;
                        }
                        field("Excel Sheet Name"; SheetName)
                        {
                            ApplicationArea = All;
                            trigger OnAssistEdit()
                            begin
                                IF ServerFileName = '' THEN
                                    RequestFile;
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
        ReadExcelSheet(FileName, SheetName);
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
        Instr: InStream;
        Text006: Label 'Import Excel File';

    local procedure RequestFile()
    var
        Outstr: OutStream;
        TempBlbCodeu: Codeunit "Temp Blob";
        Text006: Label 'Import Excel File';
    begin
        Clear(TempBlbCodeu);
        Clear(InStr);
        TempBlbCodeu.CreateInStream(InStr);
        UploadIntoStream(Text006, '', '', ServerFileName, Instr);
        FileName := FileMgt.GetFileName(ServerFileName);
        SheetName := ExcelBuf.SelectSheetsNameStream(Instr);
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
    begin
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBookStream(Instr, p_SheetName);
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

