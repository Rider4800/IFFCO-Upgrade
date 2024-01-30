report 50062 "AcxCD Scheme Calc Batch Report"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1000000000; 2000000026)
        {
            DataItemTableView = WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin

                CalcScheme.AfterInvoice('', FrDt, ToDt);
                /*
                ValidateCal.RESET();
                ValidateCal.SETRANGE("Scheme Code",ScheCome);
                IF (ValidateCal.FINDFIRST) THEN BEGIN
                  REPEAT
                    IF (ValidateCal."Invoice Amount"<=0) OR (ValidateCal."Payment No."='') OR (ValidateCal."Invoice Amt. Exclud GST"<=0) THEN
                    ValidateCal.DELETE();
                  UNTIL ValidateCal.NEXT=0;
                END;
                */

            end;

            trigger OnPreDataItem()
            begin
                //ToDt:= TODAY;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FrDt; FrDt)
                {
                    Caption = 'From Date';
                }
                field(toDate; ToDt)
                {
                    Caption = 'To Date';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ToDt := TODAY;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        MESSAGE('Sccuess');
    end;

    var
        CalcScheme: Codeunit 50011;
        ToDt: Date;
        ScheCome: Code[20];
        ValidateCal: Record 50020;
        FrDt: Date;
}

