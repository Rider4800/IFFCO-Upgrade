report 50038 "Update ShiptoCustLedEnt"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\UpdateShiptoCustLedEnt.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry"; 21)
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Invoice));

            trigger OnAfterGetRecord()
            begin
                /*
                IF "Cust. Ledger Entry"."Ship-to Code"<>'' THEN
                 // recCle.SETRANGE("Document No.","Cust. Ledger Entry"."Document No.");
                  recCle.SETRANGE("Document No.",DocNo);
                  IF recCle.FINDFIRST THEN BEGIN
                     recSIH.RESET;
                     recSIH.SETRANGE("No.",recCle."Document No.");
                     //recSIH.SETFILTER("Ship-to Code",'<>%1','');
                     IF recSIH.FINDFIRST THEN BEGIN
                       IF recSIH."Ship-to Code"<>'' THEN BEGIN
                          MESSAGE(recSIH."Ship-to Code",recSIH."No.");
                          "Cust. Ledger Entry"."Ship-to Code":= recSIH."Ship-to Code";
                          "Cust. Ledger Entry".MODIFY;
                        END;
                     END;
                  END;
                
                */
                IF "Cust. Ledger Entry"."Document Type" = "Cust. Ledger Entry"."Document Type"::Invoice THEN BEGIN
                    recCle.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
                    IF recCle.FINDFIRST THEN BEGIN
                        recSIH.SETRANGE("No.", recCle."Document No.");
                        IF recSIH.FINDFIRST THEN BEGIN
                            IF recSIH."Ship-to Code" <> '' THEN BEGIN
                                "Cust. Ledger Entry"."Ship-to Code" := recSIH."Ship-to Code";
                                "Cust. Ledger Entry".MODIFY;
                            END;
                        END;
                    END;
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
        MESSAGE('Updated');
    end;

    var
        recShipTOadd: Record 222;
        recCust: Record 18;
        recSIH: Record 112;
        recCle: Record 21;
        DocNo: Code[20];
        shipto: Code[10];
}

