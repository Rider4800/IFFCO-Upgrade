report 50064 "UpdateSchemeStatusOnCL-CD zero"
{
    Permissions = TableData 21 = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1000000001; Table50020)
        {
            DataItemTableView = WHERE (CD to be Given=CONST(0));

            trigger OnAfterGetRecord()
            begin
                CLE.SETRANGE("Document No.", "ACX Calculated CD Summary"."Payment No.");
                IF CalculatedCDSummary.FINDFIRST THEN BEGIN
                    CLE."Scheme Calculated" := TRUE;
                    CLE.MODIFY();
                END;
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
        MESSAGE('Done');
    end;

    var
        CalculatedCDSummary: Record "50020";
        CLE: Record "21";
}

