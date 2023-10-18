report 50028 "TDS Register - ACX"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TDSRegisterACX.rdlc';

    dataset
    {
        dataitem(DataItem1000000000; Table2000000026)
        {
            DataItemTableView = SORTING (Number)
                                ORDER(Ascending)
                                WHERE (Number = FILTER (1));
            column(txtPrintDescription; txtPrintDescription)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(Add1; Addr1)
            {
            }
            column(Addr2; Addr2)
            {
            }
            column(TIME; 'Time : ' + FORMAT(TIME))
            {
            }
            column(Date; 'Date : ' + FORMAT(TODAY))
            {
            }
            dataitem(DataItem1000000001; Table13729)
            {
                DataItemTableView = SORTING (Posting Date)
                                    WHERE (Party Type=FILTER(Vendor));
                RequestFilterFields = "Posting Date","TDS Nature of Deduction","TDS Group","Assessee Code";
                column(Posting_Date;FORMAT("Posting Date"))
                {
                }
                column(Party_Code;"Party Code")
                {
                }
                column(Party_Name;VendName)
                {
                }
                column(PANNO;recVendor."P.A.N. No.")
                {
                }
                column(Assessee_Code;"TDS Entry"."Assessee Code")
                {
                }
                column(TDS_Base_Amount;"TDS Base Amount")
                {
                }
                column(TDS_Perc;"TDS %")
                {
                }
                column(TDS_Amount;"TDS Amount")
                {
                }
                column(intCompany;intCompany)
                {
                }
                column(TDS_Group;"TDS Group")
                {
                }
                column(TDS_Section;"TDS Section")
                {
                }
                column(Description;recAssessCode.Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF recVendor.GET("TDS Entry"."Party Code") THEN
                       IF recVendor."Name 2"=',' THEN
                          VendName :=recVendor.Name
                       ELSE
                          VendName :=recVendor.Name+recVendor."Name 2"
                      ELSE
                         VendName :='';


                    IF "TDS Entry"."Assessee Code"  = 'COM' THEN
                       intCompany := '01'
                      ELSE
                        intCompany := '02' ;

                    //recAssessCode.GET(recAssessCode.Code);

                    IF PrintToExcel THEN
                      MakeExcelDataBody;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                txtPrintDescription := 'TDS REGISTER' ;

                IF PrintToExcel THEN
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
                group(Option)
                {
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

    trigger OnInitReport()
    begin
        PrintToExcel := TRUE;
    end;

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
          CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET();
        Addr1:=CompanyInfo.Address+' '+CompanyInfo."Address 2"+' '+CompanyInfo.City;
        Addr2:=CompanyInfo."Phone No.";
        Addr3:=' ';


        IF "TDS Entry".GETFILTER("Posting Date") = '' THEN
           ERROR(Text003);


        dtEndDt := "TDS Entry".GETRANGEMAX("Posting Date");

        DateFilter :="TDS Entry".GETFILTER("Posting Date");
        NODFilter :="TDS Entry".GETFILTER("TDS Nature of Deduction");

        IF PrintToExcel THEN
          MakeExcelInfo;
    end;

    var
        CompanyInfo: Record "79";
        CompanyAddr: array [8] of Text[200];
        FormatAddr: Codeunit "365";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DateFilter: Text[200];
        NODFilter: Text[200];
        recVendor: Record "23";
        VendName: Text[60];
        WorkUnit: Code[20];
        RespCentre: Record "5714";
        Addr1: Text[150];
        Addr2: Text[200];
        Addr3: Text[150];
        Flag: Boolean;
        dtEndDt: Date;
        TotalFor: Label 'Total for ';
        Text002: Label 'TDS Register';
        txtPrintDescription: Text[100];
        intCompany: Text[10];
        recAssessCode: Record "13727";
        Text003: Label 'Please enter the posting date filter.';
        PrintToExcel: Boolean;
        ExcelBuf: Record "370" temporary;
        SetPrintToExcel: Boolean;

    [Scope('Internal')]
    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(TODAY,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    [Scope('Internal')]
    procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Party Code',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Party Name',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P.A.N No.',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Posting Date',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TDS Base Amount',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TDS %',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TDS Amount',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TDS Section',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Deducted Code',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
    end;

    [Scope('Internal')]
    procedure MakeExcelDataBody()
    begin
        IF VendName <> '' THEN BEGIN
           ExcelBuf.NewRow;
           ExcelBuf.AddColumn("TDS Entry"."Party Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn(VendName,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn(recVendor."P.A.N. No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn(FORMAT("TDS Entry"."Posting Date"),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn("TDS Entry"."TDS Base Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn("TDS Entry"."TDS %",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn("TDS Entry"."TDS Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
           ExcelBuf.AddColumn("TDS Entry"."TDS Section",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
           ExcelBuf.AddColumn("TDS Entry"."Assessee Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        END;
    end;

    [Scope('Internal')]
    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text002,Text003,COMPANYNAME,USERID);
        ERROR('');
    end;

    [Scope('Internal')]
    procedure InitializeRequest()
    begin
        PrintToExcel := SetPrintToExcel;
    end;
}

