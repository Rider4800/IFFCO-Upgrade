report 50055 "Cust Collection Report New"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\CustCollectionReportNew.rdl';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                WHERE("Document Type" = FILTER(Payment | Refund));
            RequestFilterFields = "Customer No.";
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Applied Cust. Ledger Entry No." = FIELD("Entry No.");
                DataItemTableView = SORTING("Applied Cust. Ledger Entry No.", "Entry Type")
                                    WHERE(Unapplied = CONST(false));
            }

            trigger OnPreDataItem()
            begin
                IF blnExportToExcel THEN
                    MakeExcelInfo;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        ExcelBuf.DELETEALL;
        blnExportToExcel := TRUE;
    end;

    var
        blnExportToExcel: Boolean;
        ExcelBuf: Record 370;
        txtData: array[50] of Text;

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

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Collection Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Cust. Ledger Entry".GETFILTERS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('State Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn('Customer No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn('Customer Name.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn('Party Type', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn('Document No. (BR No.) ', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn('Posting Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//6
        ExcelBuf.AddColumn('Document No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//7
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//8
        ExcelBuf.AddColumn('External Doc No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//9
        ExcelBuf.AddColumn('Original Inv Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//10
        ExcelBuf.AddColumn('Original Inv.Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//11
        ExcelBuf.AddColumn('PendingInvAmt before Adj', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//12
        ExcelBuf.AddColumn('Adjusted Amount (Rs.)', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//13
        ExcelBuf.AddColumn('Amount After Adjustment', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//14
        ExcelBuf.AddColumn('Value Date(Bank Receipt Date)', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn('Collection Rec. within due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//17
        ExcelBuf.AddColumn('Collection Receivable Days', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//18
        ExcelBuf.AddColumn('RME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn('TME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn('FA', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//21
        ExcelBuf.AddColumn('FO', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22
        ExcelBuf.AddColumn('City', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22

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
        //ExcelBuf.CreateBookAndOpenExcel('', 'SheetName', 'Collection Report', COMPANYNAME, USERID);   //Commented
        ExcelBuf.CreateNewBook('SheetName');
        ExcelBuf.WriteSheet('Collection Report', COMPANYNAME, USERID);
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

