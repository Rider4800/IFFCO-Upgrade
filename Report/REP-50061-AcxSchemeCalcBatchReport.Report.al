report 50061 "Acx Scheme Calc Batch Report"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                CalcScheme.AfterInvoice(ScheCome, FromDt, ToDt);

                ValidateCal.RESET();
                ValidateCal.SETRANGE("Scheme Code", ScheCome);
                IF (ValidateCal.FINDFIRST) THEN BEGIN
                    REPEAT
                        IF (ValidateCal."Invoice Amount" <= 0) OR (ValidateCal."Payment No." = '') OR (ValidateCal."Invoice Amt. Exclud GST" <= 0) THEN
                            ValidateCal.DELETE();
                    UNTIL ValidateCal.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SchemeCode; ScheCome)
                {
                    Caption = 'Scheme Code';
                    TableRelation = "ACX Schemes";
                }
                field(fromDate; FromDt)
                {
                }
                field(toDate; ToDt)
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

    trigger OnPostReport()
    begin
        MESSAGE('done');
    end;

    var
        CalcScheme: Codeunit 50009;
        FromDt: Date;
        ToDt: Date;
        ScheCome: Code[20];
        ValidateCal: Record 50027;
}

