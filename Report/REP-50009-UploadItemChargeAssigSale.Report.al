report 50009 "Upload Item Charge Assig. Sale"
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

                            trigger OnAssistEdit()
                            var
                                RecFileManagement: Codeunit "File Management";
                                Outstr: OutStream;
                                Instr: InStream;
                                TemBlb: Codeunit "Temp Blob";
                            begin
                                TemBlb.CreateInStream(Instr);
                                TemBlb.CreateOutStream(Outstr);
                                ExcelBuf.SaveToStream(Outstr, false);
                                RequestFile;
                                // FileName := RecFileManagement.GetFileName(ServerFileName);
                                SheetName := ExcelBuf.SelectSheetsNameStream(Instr);
                                // SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                            end;
                        }
                        field("Excel Sheet Name"; SheetName)
                        {

                            trigger OnAssistEdit()
                            var
                                Outstr: OutStream;
                                Instr: InStream;
                                TemBlb: Codeunit "Temp Blob";
                            begin
                                TemBlb.CreateInStream(Instr);
                                TemBlb.CreateOutStream(Outstr);
                                ExcelBuf.SaveToStream(Outstr, false);
                                IF ServerFileName = '' THEN
                                    RequestFile;
                                //16767 SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                                SheetName := ExcelBuf.SelectSheetsNameStream(Instr)
                            end;
                        }
                        field("Customer No."; cdLOc)
                        {
                            Enabled = true;
                            TableRelation = Customer."No.";
                            Visible = false;
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
        ReadExcelSheet(ServerFileName, SheetName);
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
        Text001: Label 'Import Excel File';
        Text002: Label 'You must enter a file name.';
        Text003: Label 'Analyzing Data...';
        dtDate: Date;
        recRcptReg: Record 50015;
        recInsRcptReg: Record 50015;
        recPH: Record 38;
        recWallmart: Record 50014;
        LineNo: Integer;
        dcQty: Decimal;
        dcUpDateQty: Decimal;
        cdLOc: Code[20];
        recItemChargeAss: Record 5809;
        cuNoSeries: Codeunit 396;
        DocNo: Code[20];
        recSalesReceivable: Record 311;
        cdCust: Code[20];
        EnryNO: Integer;
        recItem: Record 27;
        AssignItemChargeSales: Codeunit 5807;
        SalesLine2: Record 37;
        AssignableQty: Decimal;
        AssignableAmount: Decimal;
        DocLineNo: Integer;
        RemAmountToAssign: Decimal;
        RemQtyToAssign: Decimal;
        UnitCost: Decimal;
        TotalQtyToAssign: Decimal;
        TotalAmountToAssign: Decimal;
        DocumentNo: Code[30];
        recILE: Record 32;
        recVLE: Record 5802;
        txtInvoiceNo: Text;
        dtInvoiceDate: Date;
        SalesLine: Record 37;
        ApplDocLineNo: Integer;
        Doc_Line_No: Integer;

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
        // ValidateServerFileName;
        // FileName := FileMgt.GetFileName(ServerFileName);
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

        FOR X := 1 TO TotalRow DO BEGIN
            recItemChargeAss.RESET();
            recItemChargeAss.SETRANGE("Document No.", GetExcelCell(X, 1));
            IF recItemChargeAss.FINDSET THEN
                recItemChargeAss.DELETEALL;
        END;

        FOR X := 1 TO TotalRow DO BEGIN
            EnryNO := 0;
            recItemChargeAss.RESET();
            recItemChargeAss.SETRANGE("Document No.", GetExcelCell(X, 1));
            IF recItemChargeAss.FINDLAST THEN
                EnryNO := recItemChargeAss."Line No." + 10000
            ELSE
                EnryNO := recItemChargeAss."Line No." + 10000;

            recItemChargeAss.RESET();
            recItemChargeAss.INIT();
            recItemChargeAss."Document Type" := recItemChargeAss."Document Type"::"Credit Memo";
            IF GetExcelCell(X, 1) <> '' THEN BEGIN
                recItemChargeAss."Document No." := GetExcelCell(X, 1);
                DocumentNo := GetExcelCell(X, 1);
            END;
            IF GetExcelCell(X, 2) <> '' THEN BEGIN
                EVALUATE(recItemChargeAss."Document Line No.", GetExcelCell(X, 2));
                EVALUATE(DocLineNo, GetExcelCell(X, 2));
            END;
            recItemChargeAss."Line No." := EnryNO;
            recItemChargeAss.VALIDATE("Applies-to Doc. Type", recItemChargeAss."Applies-to Doc. Type"::Shipment);
            IF GetExcelCell(X, 3) <> '' THEN
                EVALUATE(recItemChargeAss."Applies-to Doc. No.", GetExcelCell(X, 3));
            IF GetExcelCell(X, 4) <> '' THEN
                EVALUATE(recItemChargeAss."Applies-to Doc. Line No.", GetExcelCell(X, 4));
            IF GetExcelCell(X, 5) <> '' THEN
                recItemChargeAss.VALIDATE("Item No.", GetExcelCell(X, 5));
            recItem.RESET();
            recItem.SETRANGE("No.", GetExcelCell(X, 5));
            IF recItem.FINDFIRST THEN BEGIN
                recItemChargeAss.Description := recItem.Description;
                //recItemChargeAss."Item UOM" := recItem."Base Unit of Measure";
            END;
            SalesLine.RESET();
            SalesLine.SETRANGE("Document No.", DocumentNo);
            SalesLine.SETRANGE("Line No.", DocLineNo);
            IF SalesLine.FINDFIRST THEN BEGIN
                recItemChargeAss."Unit Cost" := UpdateUnitCost;
                recItemChargeAss."Item Charge No." := SalesLine."No.";
            END;
            txtInvoiceNo := '';
            dtInvoiceDate := 0D;
            recILE.RESET();
            recILE.SETRANGE("Document No.", GetExcelCell(X, 3));
            IF recILE.FIND('-') THEN BEGIN
                recVLE.RESET();
                recVLE.SETRANGE("Item Ledger Entry No.", recILE."Entry No.");
                IF recVLE.FIND('-') THEN BEGIN
                    // recItemChargeAss."Invoice Doc. No." := recVLE."Document No.";
                    // recItemChargeAss."Invoice Doc. Date" := recVLE."Posting Date";
                END;
            END;
            recItemChargeAss.INSERT();
            SalesLine2.RESET();
            SalesLine2.SETRANGE("Document No.", DocumentNo);
            SalesLine2.SETRANGE("Line No.", DocLineNo);
            IF SalesLine2.FINDFIRST THEN BEGIN
                UpdateQtyAssgnt(SalesLine2);
                //AssignItemChargeSales.SuggestAssignmentforAutoShipment(SalesLine2, AssignableQty, AssignableAmount, 1);
                AssignItemChargeSales.SuggestAssignment(SalesLine2, AssignableQty, AssignableAmount);
            END;
        END;
    end;

    procedure GetExcelCell(p_RowNo: Integer; p_ColumnNo: Integer) Text: Text[250]
    begin
        IF ExcelBuf.GET(p_RowNo, p_ColumnNo) THEN
            EXIT(ExcelBuf."Cell Value as Text");
        EXIT('');
    end;

    local procedure UpdateQtyAssgnt(SalesLine: Record 37)
    var
        ItemChargeAssgntSales: Record 5809;
    begin
        SalesLine2.CALCFIELDS("Qty. to Assign", "Qty. Assigned");
        AssignableAmount := SalesLine2."Line Amount";
        AssignableQty := SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced" - SalesLine2."Qty. Assigned";
        IF AssignableQty <> 0 THEN
            UnitCost := SalesLine2."Line Amount" / AssignableQty
        ELSE
            UnitCost := 0;
        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
        ItemChargeAssgntSales.SETRANGE("Document Type", SalesLine."Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.", SalesLine."Document No.");
        ItemChargeAssgntSales.SETRANGE("Document Line No.", DocLineNo);
        ItemChargeAssgntSales.CALCSUMS("Qty. to Assign", "Amount to Assign");
        TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
        TotalAmountToAssign := ItemChargeAssgntSales."Amount to Assign";
        RemQtyToAssign := AssignableQty - TotalQtyToAssign;
        RemAmountToAssign := SalesLine2."Line Amount" - TotalAmountToAssign;
    end;

    local procedure UpdateUnitCost(): Decimal
    var
        ItemChargeAssgntSales: Record 5809;
    begin
        SalesLine.CALCFIELDS("Qty. to Assign", "Qty. Assigned");
        AssignableQty := SalesLine."Qty. to Invoice" + SalesLine."Quantity Invoiced" - SalesLine."Qty. Assigned";
        IF AssignableQty <> 0 THEN
            UnitCost := SalesLine."Line Amount" / AssignableQty
        ELSE
            UnitCost := 0;
        EXIT(UnitCost);
    end;

    procedure Initialize(NewSalesLine: Record 37; NewLineAmt: Decimal)
    begin
        SalesLine2 := NewSalesLine;
        AssignableAmount := NewLineAmt;
    end;
}

