report 50065 Upatesalesinvoice
{
    Permissions = TableData 112 = rm,
                  TableData 113 = rm;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");

                trigger OnAfterGetRecord()
                begin
                    "Sales Invoice Line"."Scheme Code" := UpdateSchemecode;
                    "Sales Invoice Line".MODIFY;
                end;

                trigger OnPreDataItem()
                begin
                    /*"Sales Invoice Line".SETRANGE("Sell-to Customer No.",Reccoust);
                    "Sales Invoice Line".SETRANGE("Posting Date",StartDate );
                    */

                end;
            }

            trigger OnAfterGetRecord()
            begin
                Reccoust := "Sales Invoice Header"."Sell-to Customer No.";
                StartDate := "Sales Invoice Header"."Posting Date";
                "Sales Invoice Header"."Scheme Code" := UpdateSchemecode;
                "Sales Invoice Header".MODIFY;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(UpdateSchemecode; UpdateSchemecode)
                {
                    TableRelation = "ACX Schemes"."Scheme Code";
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
        MESSAGE('Ok');
    end;

    var
        UpdateSchemecode: Code[20];
        StartDate: Date;
        Reccoust: Code[30];
}

