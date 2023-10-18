report 50052 "IEBL Data Export To Excel-N"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Line"; Table112)
        {
            RequestFilterFields = "No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin

                SalesInvoice("Sales Invoice Line"."No.", "Sales Invoice Line"."Posting Date");
            end;

            trigger OnPreDataItem()
            begin
                IF UserSetup.GET(USERID) THEN BEGIN
                    IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                        "Sales Invoice Line".SETFILTER("Responsibility Center", '%1', UserSetup."Sales Resp. Ctr. Filter");
                END;
                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('Sales Line Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn("Sales Invoice Line".GETFILTERS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('State NAME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//1
                ExcelBuf.AddColumn('Posting Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//2
                ExcelBuf.AddColumn('Document No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//3
                ExcelBuf.AddColumn('STATE CODE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//4
                ExcelBuf.AddColumn('STATE - NAME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//5
                ExcelBuf.AddColumn('Description', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//6
                ExcelBuf.AddColumn('Unit Per Parcel', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//7
                ExcelBuf.AddColumn('QTY_PRINCIPAL_UOM', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//8
                ExcelBuf.AddColumn('UNIT_RATE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//9
                ExcelBuf.AddColumn('Line Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//10
                ExcelBuf.AddColumn('IGST Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//11
                ExcelBuf.AddColumn('UTGST AMOUNT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//12
                ExcelBuf.AddColumn('CGST AMOUNT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//13
                ExcelBuf.AddColumn('SGST AMOUNT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//14
                ExcelBuf.AddColumn('Amount to Customer', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//15
                ExcelBuf.AddColumn('PARTY', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//17
                ExcelBuf.AddColumn('MFGDATE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//18
                ExcelBuf.AddColumn('EXPDATE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//19
                ExcelBuf.AddColumn('Sell to Customer Code', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//20
                ExcelBuf.AddColumn('BATCH', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//21
                ExcelBuf.AddColumn('Line No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22
                ExcelBuf.AddColumn('DISP_DT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//23
                ExcelBuf.AddColumn('DEL_DT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//24
                ExcelBuf.AddColumn('SR', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//25
                ExcelBuf.AddColumn('Ship-To Code', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//26
                ExcelBuf.AddColumn('Sell-to Customer Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//27
                ExcelBuf.AddColumn('MRP Price', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//28
                ExcelBuf.AddColumn('MRP_PER_PACK', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//29
                ExcelBuf.AddColumn('REMARKS', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//30
                ExcelBuf.AddColumn('STATUS', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//31
                ExcelBuf.AddColumn('Quantity', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//32
                ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//33
                IF blnExportToExcel THEN
                    MakeExcelDataBody;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
        IF blnExportToExcel THEN
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        blnExportToExcel := TRUE;

        IF blnExportToExcel THEN
            MakeExcelInfo;
    end;

    var
        blnExportToExcel: Boolean;
        ExcelBuf: Record "370" temporary;
        Text004: ;
        Text014: Label 'Sales Line Report';
        txtData: array[254] of Text[250];
        recstate: Record "13762";
        recDGLE: Record "16419";
        decIGST: Decimal;
        decCGST: Decimal;
        decSGST: Decimal;
        decUTGST: Decimal;
        recile: Record "32";
        Reclot: Record "6505";
        LotNumber: Code[20];
        MFGDate: Date;
        ExpDate: Date;
        recsalesHeader: Record "112";
        SHPTOCODE: Text;
        SellCSTMNa: Text;
        recCustomer: Record "18";
        recShipToAdd: Record "222";
        recvalueentry: Record "5802";
        Data1: Decimal;
        LN: Decimal;
        LN2: Decimal;
        Data3: Decimal;
        TxtCustPostinGrp: Text;
        UserSetup: Record "91";
        "SalesInv.": Query "50000";
        Print: Boolean;
        Text001: Label 'Do you want to print';
        recsalesline: Record "113";

    [Scope('Internal')]
    procedure SalesInvoice(Docn: Code[50]; PostingDate: Date)
    begin

        "SalesInv.".SETRANGE(Document_No, Docn);
        "SalesInv.".OPEN;
        WHILE "SalesInv.".READ DO BEGIN
            //ACXLK...................................................State Des//
            txtData[1] := '';
            txtData[16] := '';
            recstate.RESET;
            recstate.SETRANGE(Code, "SalesInv.".State);
            IF recstate.FINDFIRST THEN BEGIN
                REPEAT
                    txtData[1] := recstate.Description;
                    txtData[16] := recstate.Code;
                UNTIL recstate.NEXT = 0
            END;

            //IGST.............................................................ACX LK//
            txtData[2] := '';
            txtData[3] := '';
            txtData[4] := '';
            txtData[5] := '';
            recDGLE.RESET;
            recDGLE.SETRANGE("Document No.", "SalesInv.".Document_No);
            recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
            recDGLE.SETRANGE(recDGLE."Document Line No.", "SalesInv.".Line_No);
            IF recDGLE.FINDFIRST THEN BEGIN
                REPEAT
                    IF recDGLE."GST Component Code" = 'IGST' THEN BEGIN
                        txtData[2] := FORMAT(ABS(recDGLE."GST Amount"))
                    END ELSE
                        IF recDGLE."GST Component Code" = 'CGST' THEN BEGIN
                            txtData[3] := FORMAT(ABS(recDGLE."GST Amount"));
                        END ELSE
                            IF recDGLE."GST Component Code" = 'SGST' THEN BEGIN
                                txtData[4] := FORMAT(ABS(recDGLE."GST Amount"))
                            END ELSE
                                IF recDGLE."GST Component Code" = 'UTGST' THEN BEGIN
                                    txtData[5] := FORMAT(ABS(recDGLE."GST Amount"))
                                END
                UNTIL recDGLE.NEXT = 0;
            END;

            //Lot No Information................................................................................................//ACX_LK
            LotNumber := '';
            txtData[8] := '';
            txtData[6] := '';
            txtData[7] := '';
            recvalueentry.RESET;
            recvalueentry.SETRANGE("Document No.", "SalesInv.".Document_No);
            recvalueentry.SETRANGE("Item No.", "SalesInv.".No);
            IF recvalueentry.FIND('-') THEN BEGIN
                recile.RESET;
                recile.SETRANGE("Entry No.", recvalueentry."Item Ledger Entry No.");
                recile.SETRANGE("Item No.", recvalueentry."Item No.");
                IF recile.FINDFIRST THEN BEGIN
                    ExpDate := recile."Expiration Date";
                    txtData[8] := FORMAT(ExpDate);
                    LotNumber := recile."Lot No.";
                    txtData[6] := LotNumber;
                    Reclot.RESET;
                    Reclot.SETRANGE("Lot No.", recile."Lot No.");
                    Reclot.SETRANGE("Item No.", recile."Item No.");
                    IF Reclot.FINDFIRST THEN BEGIN
                        MFGDate := Reclot."MFG Date";
                        txtData[7] := FORMAT(MFGDate);

                    END;
                END;
            END;
            //Sales Header......................................................................................................//
            SHPTOCODE := '';
            SellCSTMNa := '';
            txtData[10] := '';
            txtData[9] := '';
            recsalesHeader.RESET;
            recsalesHeader.SETRANGE("No.", "SalesInv.".Document_No);
            IF recsalesHeader.FINDFIRST THEN BEGIN
                REPEAT
                    txtData[10] := recsalesHeader."Ship-to Code";
                    //txtData[10] := SHPTOCODE;
                    txtData[9] := recsalesHeader."Sell-to Customer Name";
                    //txtData[9] := SellCSTMNa;
                UNTIL recsalesHeader.NEXT = 0
            END;
            txtData[11] := '';
            recsalesHeader.RESET;
            recsalesHeader.SETRANGE("No.", "SalesInv.".Document_No);
            IF recsalesHeader.FINDFIRST THEN BEGIN
                IF recsalesHeader."Ship-to Code" <> '' THEN
                    recShipToAdd.RESET;
                recShipToAdd.SETRANGE(recShipToAdd.Code, recsalesHeader."Ship-to Code");
                IF recShipToAdd.FINDFIRST THEN BEGIN
                    IF recShipToAdd.Name <> '' THEN
                        txtData[11] := recShipToAdd.Name;
                END ELSE BEGIN
                    recCustomer.RESET;
                    recCustomer.SETRANGE(recCustomer."No.", recsalesHeader."Sell-to Customer No.");
                    IF recCustomer.FINDFIRST THEN BEGIN
                        IF recCustomer.Name <> '' THEN
                            txtData[11] := recCustomer.Name;
                    END;
                END;
            END;
            IF blnExportToExcel THEN
                MakeExcelDataBody;
            ExcelBuf.NewRow;
            ExcelBuf.AddColumn(txtData[1], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//1
            ExcelBuf.AddColumn("SalesInv.".Posting_Date, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//2
            ExcelBuf.AddColumn("SalesInv.".Document_No, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
            ExcelBuf.AddColumn(txtData[16], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
            ExcelBuf.AddColumn(txtData[1], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
            ExcelBuf.AddColumn("SalesInv.".Description, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6
            ExcelBuf.AddColumn("SalesInv.".Units_per_Parcel, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//7
            ExcelBuf.AddColumn("SalesInv.".No_of_Loose_Pack, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//8
            Data1 := 0;
            IF ("SalesInv.".Unit_Price <> 0) AND ("SalesInv.".Units_per_Parcel <> 0) THEN
                Data1 := "SalesInv.".Unit_Price / "SalesInv.".Units_per_Parcel
            ELSE
                Data1 := 0;
            ExcelBuf.AddColumn(Data1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//9
            ExcelBuf.AddColumn("SalesInv.".Line_Amount, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//10
            ExcelBuf.AddColumn(txtData[2], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11
            ExcelBuf.AddColumn(txtData[5], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//12
            ExcelBuf.AddColumn(txtData[3], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//13
            ExcelBuf.AddColumn(txtData[4], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//14
            ExcelBuf.AddColumn("SalesInv.".Amount_To_Customer, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//15
            ExcelBuf.AddColumn(txtData[11], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
            ExcelBuf.AddColumn(txtData[7], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//17
            ExcelBuf.AddColumn(txtData[8], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//18
            ExcelBuf.AddColumn("SalesInv.".Sell_to_Customer_No, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19
            ExcelBuf.AddColumn(txtData[6], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
            LN := 0;
            IF "SalesInv.".Line_No <> 0 THEN
                LN := "SalesInv.".Line_No / 10000
            ELSE
                LN := 0;
            ExcelBuf.AddColumn(LN, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//21
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//22
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//24
            ExcelBuf.AddColumn(txtData[10], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//25
            ExcelBuf.AddColumn(txtData[9], FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//26
            ExcelBuf.AddColumn("SalesInv.".MRP_Price, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//27
            Data3 := 0;
            IF ("SalesInv.".MRP_Price <> 0) AND ("SalesInv.".Units_per_Parcel <> 0) THEN
                Data3 := "SalesInv.".MRP_Price / "SalesInv.".Units_per_Parcel
            ELSE
                Data3 := 0;
            ExcelBuf.AddColumn(Data3, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//28
            LN2 := 0;
            IF "SalesInv.".Line_No <> 0 THEN
                LN2 := "SalesInv.".Line_No / 10000
            ELSE
                LN2 := 0;
            ExcelBuf.AddColumn(LN2, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//29
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn("SalesInv.".Quantity, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//31

            //acxcp +
            TxtCustPostinGrp := '';
            recsalesHeader.RESET;
            recsalesHeader.SETRANGE("No.", "SalesInv.".Document_No);
            IF recsalesHeader.FINDFIRST THEN BEGIN
                TxtCustPostinGrp := recsalesHeader."Customer Posting Group";
            END;
            ExcelBuf.AddColumn(TxtCustPostinGrp, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//31
                                                                                                                //acxcp -


        END;
    end;

    [Scope('Internal')]
    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(USERID, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    [Scope('Internal')]
    procedure MakeExcelDataHeader()
    begin
        IF blnExportToExcel THEN
            MakeExcelDataBody;
    end;

    [Scope('Internal')]
    procedure MakeExcelDataBody()
    var
        y: Integer;
    begin
    end;

    [Scope('Internal')]
    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('', Text014, Text004, COMPANYNAME, USERID);
        ERROR('');
    end;

    [Scope('Internal')]
    procedure InitializeRequest()
    var
        k: Integer;
    begin
    end;
}

