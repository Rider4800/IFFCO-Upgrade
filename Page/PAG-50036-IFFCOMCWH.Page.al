page 50036 "IFFCOMC-WH"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
    }

    actions
    {
        area(reporting)
        {
            action("<Item Balance Report>")
            {
                Caption = 'Item Balance Report';
                Image = "Report";
                //RunObject = Report 50024; //commented because this report was not given in list by IFFCO to TEAM, so to publish this main app, deleted those all other reports, kept copy of them in F Drive, and we commented this.
            }
            group(NewGroup)
            {
                Caption = 'NewGroup';
                action("<E-Invoice (Transfer)>")
                {
                    Caption = 'E-Invoice (Transfer)';
                    Image = ListPage;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page 50006;
                }
                action("<E-Way Bill (Transfer)>")
                {
                    Caption = 'E-Way Bill (Transfer)';
                    Image = ListPage;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page 50007;
                }
                separator("Posted E-Way Bill")
                {
                    Caption = 'Posted E-Way Bill';
                }
                action("<Posted E-WayBill (Sales)>")
                {
                    Caption = 'Posted E-WayBill (Sales)';
                    Image = "Report";
                    RunObject = Page 50038;
                }
                action("<Posted E-WayBill (Transfer)>")
                {
                    Caption = 'Posted E-WayBill (Transfer)';
                    Image = "Report";
                    RunObject = Page 50040;
                }
                separator(Separator)
                {
                    Caption = 'Separator';
                }
            }
        }
        area(embedding)
        {
            action("Purchase Return Orders")
            {
                Caption = 'Purchase Return Orders';
                RunObject = Page 9311;
                RunPageView = WHERE("Document Type" = FILTER('Return Order'));
            }
            action("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
            }
            action("Released Production Orders")
            {
                Caption = 'Released Production Orders';
                RunObject = Page 9326;
            }
            action(PurchaseOrdersReleased)
            {
                Caption = 'Released';
                RunObject = Page 9307;
                RunPageView = WHERE(Status = FILTER(Released));
            }
            action(PurchaseOrdersPartReceived)
            {
                Caption = 'Partially Received';
                RunObject = Page 9307;
                RunPageView = WHERE(Status = FILTER(Released),
                                    "Completely Received" = FILTER(false));
            }
            action("Sales Return Orders")
            {
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page 9304;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Transfer Shipments")
                {
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page 5752;
                }
                action("Posted Sales Shipment")
                {
                    Caption = 'Posted Sales Shipment';
                    RunObject = Page 142;
                }
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page 6652;
                }
                action("Posted Transfer Receipts")
                {
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page 5753;
                }
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page 145;
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page 6662;
                }
            }
        }
        area(creation)
        {
            action("T&ransfer Order")
            {
                Caption = 'T&ransfer Order';
                Image = Document;
                RunObject = Page 5742;
                RunPageMode = Create;
            }
            action("&Purchase Order")
            {
                Caption = '&Purchase Order';
                Image = Document;
                RunObject = Page 56;
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
        }
    }
}

