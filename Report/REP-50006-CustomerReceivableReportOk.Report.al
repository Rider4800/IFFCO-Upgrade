report 50006 "Customer Receivable Report-Ok"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Customer No.", "Posting Date");
            RequestFilterFields = "Posting Date", "Customer No.", "Customer Posting Group";

            trigger OnAfterGetRecord()
            begin

                EndDate := 0D;
                txtData[3] := '';
                txtData[3] := FORMAT("Cust. Ledger Entry".GETRANGEMAX("Posting Date"));
                EndDate := "Cust. Ledger Entry".GETRANGEMAX("Posting Date");

                txtData[4] := '';
                txtData[4] := FORMAT(EndDate - "Cust. Ledger Entry"."Due Date");

                EVALUATE(ODByDays, txtData[4]);

                txtData[5] := '';
                IF ODByDays <= 0 THEN BEGIN
                    txtData[5] := Text004;
                END
                ELSE
                    IF (ODByDays > 0) AND (ODByDays <= 120) THEN BEGIN
                        txtData[5] := Text005;
                    END
                    ELSE
                        IF (ODByDays > 121) AND (ODByDays <= 180) THEN BEGIN
                            txtData[5] := Text006;
                        END
                        ELSE
                            IF (ODByDays > 181) AND (ODByDays <= 240) THEN BEGIN
                                txtData[5] := Text007;
                            END
                            ELSE BEGIN
                                txtData[5] := Text008;

                            END;



                FYofInvDate := 0;
                FYofInvDate := DATE2DMY("Cust. Ledger Entry"."Document Date", 3);

                //----------------------Cust Name-----------
                txtData[1] := '';
                txtData[10] := '';
                IF recCustomer.GET("Customer No.") THEN BEGIN
                    CustomerName := recCustomer.Name;
                    CustCity := recCustomer.City;
                END;
                txtData[1] := CustomerName;
                txtData[10] := CustCity;
                //---------------State Name---------------
                txtData[2] := '';
                recDimValue.RESET;
                recDimValue.SETRANGE(Code, "Cust. Ledger Entry"."Global Dimension 1 Code");
                IF recDimValue.FINDFIRST THEN BEGIN
                    txtData[2] := recDimValue.Name;

                END;

                CALCFIELDS("Original Amount", "Cust. Ledger Entry"."Remaining Amount");

                txtData[6] := '';
                txtData[7] := '';
                txtData[8] := '';
                txtData[9] := '';
                CASE "Cust. Ledger Entry"."Document Type" OF
                    "Cust. Ledger Entry"."Document Type"::Invoice:
                        BEGIN
                            IF recSalesInvH.GET("Cust. Ledger Entry"."Document No.") THEN
                                txtData[6] := recSalesInvH."RME Code";
                            txtData[7] := recSalesInvH."TME Code";
                            txtData[8] := recSalesInvH."FA Code";
                            txtData[9] := recSalesInvH."FO Code";
                        END;
                    "Cust. Ledger Entry"."Document Type"::"Credit Memo":
                        BEGIN
                            IF recSalesInvH.GET("Cust. Ledger Entry"."Document No.") THEN
                                txtData[6] := recSalesCM."RME Code";
                            txtData[7] := recSalesCM."TME Code";
                            txtData[8] := recSalesCM."FA Code";
                            txtData[9] := recSalesCM."FO Code";
                        END;

                END;

                //--------------------------location-------------
                txtData[11] := '';
                IF recLoc.GET("Cust. Ledger Entry"."Location Code") THEN BEGIN
                    txtData[11] := recLoc.Name;
                END;



                IF blnExportToExcel THEN
                    MakeExcelDataBody;
                //RK 15Dec21 Begin
                dcAmount := 0;
                recDCLE.RESET;
                recDCLE.SETRANGE("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Entry No.");
                recDCLE.SETRANGE("Posting Date", StartDt, EndDt);
                IF recDCLE.FINDSET THEN
                    REPEAT
                        dcAmount += recDCLE.Amount;
                    UNTIL recDCLE.NEXT = 0;
                //RK End
                IF dcAmount <> 0 THEN BEGIN
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1
                    ExcelBuf.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Customer Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
                    ExcelBuf.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//5
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Document Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//7
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//8a
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//8
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."External Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//9
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//10
                    ExcelBuf.AddColumn("Cust. Ledger Entry"."Original Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11a
                                                                                                                                                 //RK 15Dec21 Begin
                                                                                                                                                 /*
                                                                                                                                                 dcAmount:=0;
                                                                                                                                                 recDCLE.RESET;
                                                                                                                                                 recDCLE.SETRANGE("Cust. Ledger Entry No.","Cust. Ledger Entry"."Entry No.");
                                                                                                                                                 recDCLE.SETRANGE("Posting Date",StartDt,EndDt);
                                                                                                                                                 IF recDCLE.FINDSET THEN
                                                                                                                                                   REPEAT
                                                                                                                                                      dcAmount+=recDCLE.Amount;
                                                                                                                                                   UNTIL recDCLE.NEXT = 0;
                                                                                                                                                 */
                                                                                                                                                 //RK End
                    ExcelBuf.AddColumn(dcAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11b
                                                                                                                   //ExcelBuf.AddColumn("Cust. Ledger Entry"."Remaining Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);//11b
                    ExcelBuf.AddColumn(txtData[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//12
                    ExcelBuf.AddColumn(txtData[4], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//13
                    ExcelBuf.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//14
                    ExcelBuf.AddColumn(FYofInvDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//15
                    ExcelBuf.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
                    ExcelBuf.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//17
                    ExcelBuf.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18
                    ExcelBuf.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19
                    ExcelBuf.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//21
                    ExcelBuf.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//22
                END;

            end;

            trigger OnPreDataItem()
            begin
                // "Cust. Ledger Entry".SETRANGE("Posting Date","Posting Date");
                // "Cust. Ledger Entry"."Date Filter":="Cust. Ledger Entry"."Posting Date";

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('Receivable Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn("Cust. Ledger Entry".GETFILTERS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('VAN No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//1
                ExcelBuf.AddColumn('Party Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//2
                ExcelBuf.AddColumn('Party Type.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//3
                ExcelBuf.AddColumn('State Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//4
                ExcelBuf.AddColumn('Inv.Posting Date ', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//5
                ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//6
                ExcelBuf.AddColumn('Document No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//7
                ExcelBuf.AddColumn('Document Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//8a
                ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//8
                ExcelBuf.AddColumn('External Doc No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//9
                ExcelBuf.AddColumn('Original Inv Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//10
                ExcelBuf.AddColumn('Invoice Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//11a
                ExcelBuf.AddColumn('Outstanding Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//11b
                ExcelBuf.AddColumn('Current Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//12
                ExcelBuf.AddColumn('OD By Days', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//13
                ExcelBuf.AddColumn('Range', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//14
                ExcelBuf.AddColumn('FY of Inv Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//15
                ExcelBuf.AddColumn('RME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//17
                ExcelBuf.AddColumn('TME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//18
                ExcelBuf.AddColumn('FA', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//19
                ExcelBuf.AddColumn('FO', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//20
                ExcelBuf.AddColumn('Customer City', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//21
                ExcelBuf.AddColumn('WH Location', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22

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
            CreateExcelbook; //create excel
    end;

    trigger OnPreReport()
    begin

        blnExportToExcel := TRUE;
        IF blnExportToExcel THEN
            MakeExcelInfo;
        //ACX-RK 18092021 Begin
        StartDt := "Cust. Ledger Entry".GETRANGEMIN("Posting Date");
        EndDt := "Cust. Ledger Entry".GETRANGEMAX("Posting Date");
    end;

    var
        CustomerName: Text;
        EndDate: Date;
        ODByDays: Integer;
        Range: Text;
        FYofInvDate: Integer;
        StartDate: Date;
        CPG: Code[20];
        CustNo: Code[20];
        EndingDate: Date;
        blnExportToExcel: Boolean;
        ExcelBuf: Record 370 temporary;
        txtData: array[254] of Text;
        Text003: Label 'Customer Receipt';
        recCustomer: Record 18;
        recDimValue: Record 349;
        Text004: Label 'Not Due';
        recSalesInvH: Record 112;
        recSalesCM: Record 114;
        CustCity: Text;
        recLoc: Record 14;
        Text005: Label '1 to 120';
        Text006: Label '121 to 180';
        Text007: Label '181 to 240';
        Text008: Label 'above 240';
        recDCLE: Record 379;
        dcAmount: Decimal;
        recDetCustLedEntr: Record 379;
        StartDt: Date;
        EndDt: Date;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;

        MakeExcelDataHeader;
    end;

    procedure MakeExcelDataHeader()
    begin
        IF blnExportToExcel THEN
            MakeExcelDataBody;
    end;

    procedure MakeExcelDataBody()
    var
        y: Integer;
    begin
    end;

    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateNewBook(Text003);
        ExcelBuf.WriteSheet('Customer Receivable Report Ok', COMPANYNAME, USERID);
        ExcelBuf.CloseBook;
        ExcelBuf.OpenExcel;
        ERROR('');
    end;

    procedure InitializeRequest()
    var
        k: Integer;
    begin
    end;
}

