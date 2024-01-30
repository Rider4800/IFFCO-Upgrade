page 50063 "EInvoice & EWayBill"
{
    ApplicationArea = All;
    Caption = 'E-Invoice & E-WayBill';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
    }

    actions
    {
        area(Processing)
        {
            action("E-Invoicing Sales")
            {
                Caption = 'E-Invoicing Sales';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = SalesInvoice;
                PromotedCategory = Process;
                RunObject = Page "E-Invoice (Sales)";
            }
            action("E-Invoicing Sales Return")
            {
                Caption = 'E-Invoicing Sales Return';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = SalesCreditMemo;
                PromotedCategory = Process;
                RunObject = Page "E-Invoice (Sales Return)";
            }
            action("E-Invoicing Transfer")
            {
                Caption = 'E-Invoicing Transfer';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = ReturnShipment;
                PromotedCategory = Process;
                RunObject = Page "E-Invoice (Transfer)";
            }
            action("E-WayBill Sales")
            {
                Caption = 'E-WayBill Sales';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = TransferReceipt;
                PromotedCategory = Process;
                RunObject = Page "E- Way Bill (Sales)";
            }
            action("E-WayBill Transfer")
            {
                Caption = 'E-WayBill Transfer';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = ExportShipment;
                PromotedCategory = Process;
                RunObject = Page "E-Way Bill (Transfer)";
            }
        }
    }
}
