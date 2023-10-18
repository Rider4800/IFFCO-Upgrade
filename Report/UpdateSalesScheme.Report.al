report 50103 "Update Sales Scheme"
{
    DefaultLayout = RDLC;
    RDLCLayout = './UpdateSalesScheme.rdlc';

    dataset
    {
        dataitem(DataItem1000000000; Table112)
        {

            trigger OnAfterGetRecord()
            begin
                cuSalePost.UpdateSchemeCode(fromDate, toDate, "Sales Invoice Header");
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
        cuSalePost: Codeunit "80";
}

