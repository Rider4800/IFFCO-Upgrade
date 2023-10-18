report 50063 UpdateSchemeStatusOnCL
{
    DefaultLayout = RDLC;
    RDLCLayout = './UpdateSchemeStatusOnCL.rdlc';
    Permissions = TableData 21 = rm;

    dataset
    {
        dataitem(DataItem1000000000; Table21)
        {
            DataItemTableView = WHERE (Scheme Calculated=FILTER(No));

            trigger OnAfterGetRecord()
            begin
                CalculatedCD.SETRANGE("Payment No.","Cust. Ledger Entry"."Document No.");
                CalculatedCD.SETFILTER("Posted Credit Note ID",'<>%1','');
                IF CalculatedCD.FINDFIRST THEN BEGIN
                  "Cust. Ledger Entry"."Scheme Calculated" := TRUE;
                  "Cust. Ledger Entry".MODIFY();
                END;
            end;

            trigger OnPreDataItem()
            var
                CalculatedCD: Record "50022";
            begin
                CalculatedCD.RESET
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

    var
        CalculatedCD: Record "50022";
}

