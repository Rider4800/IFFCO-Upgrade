report 50066 Updatesalesshipment
{
    Permissions = TableData 110 = rm,
                  TableData 111 = rm;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");

                trigger OnAfterGetRecord()
                begin
                    "Sales Shipment Line"."Scheme Code" := Updateschemecode;
                    "Sales Shipment Line".MODIFY;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Reccustcode := "Sales Shipment Header"."Sell-to Customer No.";
                Postdate := "Sales Shipment Header"."Posting Date";
                "Sales Shipment Header"."Scheme Code" := Updateschemecode;
                "Sales Shipment Header".MODIFY;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Updateschemecode; Updateschemecode)
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
        Updateschemecode: Code[20];
        Reccustcode: Code[20];
        Postdate: Date;
}

