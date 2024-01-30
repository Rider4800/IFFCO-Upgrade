report 50031 "Update Sales Scheme-New"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\UpdateSalesSchemeNew.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; 112)
        {
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                //16767 cuSalePost.UpdateSchemeCode(fromDate, toDate, "Sales Invoice Header");
                cuSalePost1.UpdateSchemeCode(fromDate, toDate, "Sales Invoice Header");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(fromDate; fromDate)
                {
                }
                field(toDate; toDate)
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
        MESSAGE('Sales Header Updated');
    end;

    var
        fromDate: Date;
        toDate: Date;
        cuSalePost: Codeunit 80;
        cuSalePost1: Codeunit 50035;//16767 new var add
}

