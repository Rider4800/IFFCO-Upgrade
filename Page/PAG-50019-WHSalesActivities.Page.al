page 50019 "WH Sales Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = 9053;

    layout
    {
        area(content)
        {
            cuegroup("Open Sales Order List")
            {
                Caption = 'Open Sales Order List';
                field("Sales Orders - Open"; Rec."Sales Orders - Open")
                {
                    DrillDownPageID = "Sales Order List";
                }

                actions
                {
                    action("New Sales Order")
                    {
                        Caption = 'New Sales Order';
                        RunObject = Page 42;
                        RunPageMode = Create;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord()
    var
        DocExchServiceSetup: Record 1275;
    begin
        CalculateCueFieldValues;
        ShowDocumentsPendingDodExchService := FALSE;
        IF DocExchServiceSetup.GET THEN
            ShowDocumentsPendingDodExchService := DocExchServiceSetup.Enabled;
    end;

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

        Rec.SetRespCenterFilter;
        Rec.SETRANGE("Date Filter", 0D, WORKDATE - 1);
        Rec.SETFILTER("Date Filter2", '>=%1', WORKDATE);
    end;

    var
        CueSetup: Codeunit 9701;
        ShowDocumentsPendingDodExchService: Boolean;

    local procedure CalculateCueFieldValues()
    begin
        IF Rec.FIELDACTIVE("Average Days Delayed") THEN
            Rec."Average Days Delayed" := Rec.CalculateAverageDaysDelayed;

        IF Rec.FIELDACTIVE("Ready to Ship") THEN
            Rec."Ready to Ship" := Rec.CountOrders(Rec.FIELDNO("Ready to Ship"));

        IF Rec.FIELDACTIVE("Partially Shipped") THEN
            Rec."Partially Shipped" := Rec.CountOrders(Rec.FIELDNO("Partially Shipped"));

        IF Rec.FIELDACTIVE(Delayed) THEN
            Rec.Delayed := Rec.CountOrders(Rec.FIELDNO(Delayed));
    end;
}

