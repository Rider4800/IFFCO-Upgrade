page 50062 "Basic Reports"
{
    ApplicationArea = All;
    Caption = 'Basic Reports';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
    }

    actions
    {
        area(Processing)
        {
            action("Sales\Transfer Register")
            {
                RunObject = page 50001;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Purchase\Transfer Register")
            {
                RunObject = page 50002;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("FSC Data Export To Excel")
            {
                RunObject = report 50016;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Customer Ledger-NW")
            {
                RunObject = report 50011;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Vendor Ledger-NW")
            {
                RunObject = report 50012;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("IEBL Report-NEW")
            {
                RunObject = report 50019;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Posted Sales Shipment Lines")
            {
                RunObject = page "Posted Sales Shipment Lines";
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Aged Accounts Receivable")
            {
                RunObject = report "Aged Accounts Receivable";
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("GSTR-1 File Format-IMC")
            {
                RunObject = report 50026;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("GSTR-2 File Format-IMC")
            {
                RunObject = report 50027;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("TDS Register - ACX")
            {
                RunObject = report 50028;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("GSTR-3B New")
            {
                RunObject = report 50008;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Customer Receivable Report-Ok")
            {
                RunObject = report 50006;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Customer Ledger Bal Confrm.")
            {
                RunObject = report 50014;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Customer-Collection Report")
            {
                RunObject = report 50017;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Posted Purchase Receipts")
            {
                RunObject = page "Posted Purchase Receipts";
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
            action("Posted Purchase Lines")
            {
                RunObject = page "Posted Purch. Invoice Subform";
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;
                PromotedCategory = Report;
            }
        }
    }
}
