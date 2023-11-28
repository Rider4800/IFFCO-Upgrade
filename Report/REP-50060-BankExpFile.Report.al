report 50060 BankExpFile
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Integration Entry"; "Bank Integration Entry")
        {
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
        MESSAGE('completed');
    end;

    trigger OnPreReport()
    begin


        recGLSetup.GET();
        suffix := '"';

        FilePrefix := 'IF16';


        DateText := FORMAT(TODAY, 0, '<Day,2><Month,2>') + '.';

        //Report Count Start
        IF recGLSetup."Report Date" <> WORKDATE THEN
            ReportCount := 1
        ELSE
            ReportCount := recGLSetup."Report Count" + 1;

        IF ReportCount <= 9 THEN
            EVALUATE(ReportCounttxt, '00' + FORMAT(ReportCount))
        ELSE
            EVALUATE(ReportCounttxt, '0' + FORMAT(ReportCount));
        //Report Count End



        filepath := recGLSetup."Bank Integration File Path";

        //FileName := FileMgt.ServerTempFileName('CSV');
        /*  //->code commented
        FileName := FileMgt.ServerTempFileName('.CSV');

        OutFile.CREATE(FileName);
        OutFile.CREATEOUTSTREAM(OutS);
        Xmlp.FILENAME(FileName);
        Xmlp.SETDESTINATION(OutS);
        Xmlp.EXPORT;
        OutFile.CLOSE;

        FileMgt.DownloadToFile(FileName, (filepath + FilePrefix) + DateText + ReportCounttxt);
        */
        //17144>>
        Clear(TempBlbCodeunit);
        Clear(OutS);
        Clear(Instr);
        TempBlbCodeunit.CreateInStream(Instr);
        TempBlbCodeunit.CreateOutStream(OutS);
        Xmlp.FILENAME(FileName);
        Xmlp.SETDESTINATION(OutS);
        Xmlp.EXPORT;
        FileName := 'Test.csv';

        DownloadFromStream(Instr, '', '', '', FileName);
        //17144<<

        //
        recGLSetup."Report Date" := WORKDATE;
        recGLSetup."Report Count" := ReportCount;
        recGLSetup.MODIFY;
        //
    end;

    var
        FileMgt: Codeunit 419;
        FileName: Text;
        OutFile: File;
        OutS: OutStream;
        Xmlp: XMLport 50001;
        recGLSetup: Record 98;
        filepath: Text;
        fileLastNo: Integer;
        DateText: Text;
        recBankIntEntry: Record 50001;
        FilePrefix: Text;
        SNO: Integer;
        SNO1: Text;
        Date1: Date;
        Date2: Text;
        Date3: Date;
        recble: Record 271;
        ReportCount: Integer;
        ReportCounttxt: Text;
        recbinentr: Record 50023;
        suffix: Text;
        Instr: InStream;
        TempBlbCodeunit: Codeunit "Temp Blob";
}

