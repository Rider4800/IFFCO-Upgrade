page 50018 "BOOK KEEPER EDIT"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control001)
            {
                part(WHSalesActivities; 50019)
                {
                    ShowFilter = false;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Posted Transfer Receipts")
            {
                Caption = 'Posted Transfer Receipts';
                RunObject = Page "Posted Transfer Receipts";
            }
        }
        area(embedding)
        {
            ToolTip = 'Collect and make payments, prepare statements, and manage reminders.';
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Orders";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View posted invoices and credit memos, and analyze G/L registers.';
                action("Posted Sales Shipments")
                {
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
            }
        }
        area(creation)
        {
            group(Control002)
            {
            }
            action("<Page Customer Balance>")
            {
                Caption = 'Customer Balance';
                Image = CustomerLedger;
                RunObject = Page 50011;
            }
            action("<Item Balance Report>")
            {
                Caption = 'Item Balance Report';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Report 50024;
            }
            action("<Customer Detail Ledger>")
            {
                Caption = 'Customer Detail Ledger';
                Image = "Report";
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Report 104;
            }
            action("Sales_Transfer Register")
            {
                Caption = 'Sales_Transfer Register';
                Image = "Report";
                RunObject = Page 50001;
            }
            action("<Page E-Invoice (Sales)>")
            {
                Caption = 'E-&Invoice (Sales)';
                Image = ListPage;
                RunObject = Page 50003;
            }
            action("<E-Way Bill (Sales)>")
            {
                Caption = 'E-Way Bill (Sales)';
                Image = ListPage;
                RunObject = Page 50000;
            }
            action("<E-Way Bill (Transfer)>")
            {
                Caption = 'E-Way Bill (Transfer)';
                Image = ListPage;
                RunObject = Page 50007;
            }
            action("<E-Invoice (Sales Return)>")
            {
                Caption = 'E-Invoice (Sales Return)';
                Image = ListPage;
                RunObject = Page 50005;
            }
            group("History E-Inv & E-Waybill")
            {
                Caption = 'History E-Inv & E-Waybill';
            }
            separator("History E-Inv and Eway")
            {
                Caption = 'History E-Inv and Eway';
            }
            action("<Posted E-Invoice(Sales)>")
            {
                Caption = 'Posted E-Invoice(Sales)';
                Image = "Report";
                RunObject = Page 50037;
            }
            action("<Posted E-Way Bill (Sales)>")
            {
                Caption = 'Posted E-Way Bill (Sales)';
                Image = "Report";
                RunObject = Page 50038;
            }
            action("<Posted E-Way Bill (Transfer)>")
            {
                Caption = 'Posted E-Way Bill (Transfer)';
                Image = "Report";
                // Promoted = true;
                // PromotedIsBig = true;
                RunObject = Page 50040;
            }
        }
        area(processing)
        {
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page 344;
            }
            group(Reports)
            {
                Caption = 'Reports';
                action("<Report Aged Acct>")
                {
                    Caption = 'Report Aged Acct';
                    Image = "Report";
                    RunObject = Report 120;
                }
                action("<Report FSC Data>")
                {
                    Caption = 'FSC Data';
                    Image = "Report";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report 50016;
                }
                action("<Report IEBL Data >")
                {
                    Caption = 'IEBL Data';
                    Image = "Report";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category6;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report 50018;
                }
                action("<Customer Ledger>")
                {
                    Caption = 'Customer Ledger';
                    Image = "Report";
                    RunObject = Report 50011;
                }
                separator(NewSection)
                {
                    Caption = 'NewSection';
                    IsHeader = true;
                }
                action("Aged Acct Rece")
                {
                    Caption = 'Aged Acct Rece';
                    Image = "Report";
                    RunObject = Report 120;
                }
                action("<Report Customer Item Sales>")
                {
                    Caption = 'Customer Item Sales';
                    Image = "Report";
                    RunObject = Report 113;
                }
            }
            group("Posted Document")
            {
                Caption = 'Posted Document';
            }
        }
    }
}

