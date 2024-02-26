page 50000 "E- Way Bill (Sales)"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = TableData 112 = rm;
    SourceTable = "Sales Invoice Header";
    SourceTableView = WHERE("GST Customer Type" = FILTER(Registered | Unregistered),
                            "E-Way Bill No." = FILTER(''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("E-way Bill Part"; Rec."E-way Bill Part")
                {
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    Editable = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    Editable = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Editable = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    Editable = false;
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    Editable = false;
                }
                field("Customer GST Reg. No."; Rec."Customer GST Reg. No.")
                {
                    Editable = false;
                }
                field("Amount to Customer"; CU50200.GetAmttoCustomerPostedDoc(Rec."No."))
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    Editable = false;
                }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    Editable = false;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    Editable = true;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    Editable = false;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    Editable = true;
                }
                field("Distance (Km)"; Rec."Distance (Km)")
                {
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    Editable = false;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
                field("Transporter GSTIN"; Rec."Transporter GSTIN")
                {
                }
                field("E-Way Bill No."; Rec."E-Way Bill No.")
                {
                    Editable = false;
                }
                field("E-Way Bill Date"; Rec."E-Way Bill Date")
                {
                    Editable = false;
                }
                field("E-Way Bill Valid Upto"; Rec."E-Way Bill Valid Upto")
                {
                    Editable = false;
                }
                field("Vehicle Update Date"; Rec."Vehicle Update Date")
                {
                    Editable = false;
                }
                field("Vehicle Valid Upto"; Rec."Vehicle Valid Upto")
                {
                    Editable = false;
                }
                field("Cancel E-Way Bill Date"; Rec."Cancel E-Way Bill Date")
                {
                    Editable = false;
                }
                field("E-Way Bill Status"; Rec."E-Way Bill Status")
                {
                    Editable = false;
                }
                field("Reason Code for Vehicle Update"; Rec."Reason Code for Vehicle Update")
                {
                }
                field("Reason for Vehicle Update"; Rec."Reason for Vehicle Update")
                {
                }
                field("Reason Code for Cancel"; Rec."Reason Code for Cancel")
                {
                }
                field("Reason for Cancel Remarks"; Rec."Reason for Cancel Remarks")
                {
                }
                field("E-Way Bill Report URL"; Rec."E-Way Bill Report URL")
                {
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Visible = false;
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Invoice Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    Visible = false;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Visible = false;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = filter('Posted Invoice'),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    Visible = false;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Visible = false;
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.ShowPostedApprovalEntries(Rec.RecordId);
                    end;
                }
                //->Team-17783
                // action("Credit Cards Transaction Lo&g Entries")
                // {
                //     Caption = 'Credit Cards Transaction Lo&g Entries';
                //     Image = CreditCardLog;
                //     Promoted = true;
                //     PromotedCategory = Category5;
                //     PromotedIsBig = true;
                //     RunObject = Page 829;
                //     RunPageLink = "Document Type" = CONST(Payment),
                //                   "Document No." = FIELD("No."),
                //                   "Customer No." = FIELD("Bill-to Customer No.");
                // } 
                // action("St&ructure")
                // {
                //     Caption = 'St&ructure';
                //     Image = Hierarchy;
                //     RunObject = Page 16308;
                //     RunPageLink = Type = CONST(Sale),
                //                   "No." = FIELD("No."),
                //                   "Structure Code" = FIELD(Structure),
                //                   "Document Line No." = FILTER(0);
                // }
                // action("Third Party Invoices")
                // {
                //     Caption = 'Third Party Invoices';
                //     Image = Invoice;
                //     RunObject = Page 16307;
                //     RunPageLink = Type = CONST(Sale),
                //                   "Invoice No." = FIELD("No.");
                // }
                //<-Team-17783  Commented
            }
            group("E-Way Bill")
            {
                Caption = 'E-Way Bill';
                Image = Administration;
                action("Calculate Distance (KM)")
                {
                    Caption = 'Calculate Distance (KM)';
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Calculate;

                    trigger OnAction()
                    var
                        CU50114: Codeunit 50114;
                    begin
                        IF Rec."Sell-to Post Code" = '' THEN BEGIN
                            ERROR('Sell to Post Code must have value');
                        END;

                        txtMessageDistance := 'Do you want to Calculate Distance (KM) for Document No. ' + Rec."No.";

                        IF Rec."Sell-to Post Code" <> '' THEN BEGIN
                            IF Rec."Distance (Km)" = 0 THEN
                                IF CONFIRM(txtMessageDistance) THEN
                                    CU50114.CalculateDistance(Rec."No.", 1);
                        END;
                    end;
                }
                action("Generate E-Way Bill No.")
                {
                    Caption = 'Generate E-Way Bill No.';
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = GetEntries;

                    trigger OnAction()
                    var
                        CU50114: Codeunit 50114;
                    begin
                        IF (Rec."E-Way Bill No." <> '') AND (Rec."Cancel E-Way Bill Date" = '') THEN
                            ERROR('E-Way Bill is already generated');

                        if Rec."Document Type" = Rec."Document Type"::"Tax Invoice" then
                            Rec.TestField("Transporter GSTIN");

                        //Rec.TESTFIELD("Distance (Km)");   //to be open in production
                        txtMessage := 'Do you want to generate E-Way Bill No. for Document No. ' + Rec."No." + ', Posting Date ' + FORMAT(Rec."Posting Date") + ', Amount to Customer ' + FORMAT(CU50200.GetAmttoCustomerPostedDoc(Rec."No.")); //Team-17783

                        IF CONFIRM(txtMessage) THEN
                            CU50114.GenerateEWayBill(Rec."No.", 1);
                    end;
                }
                action("Update Vehicle No.")
                {
                    Caption = 'Update Vehicle No.';
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = UpdateDescription;

                    trigger OnAction()
                    var
                        CU50114: Codeunit 50114;
                    begin
                        Rec.TESTFIELD("Vehicle No.");
                        Rec.TESTFIELD("Reason Code for Vehicle Update");
                        Rec.TESTFIELD("Reason for Vehicle Update");

                        txtMessageVeh := 'Do you want to update Vehicle No. : New Vehicle No. is ' + Rec."Vehicle No." + ' Old Vehicle No. ' + Rec."Old Vehicle No.";

                        IF CONFIRM(txtMessageVeh) THEN BEGIN
                            IF Rec."Vehicle No." = Rec."Old Vehicle No." THEN
                                ERROR('Update new Vehicle No.')
                            ELSE
                                CU50114.GenerateUpdateVehicleNo(Rec."No.", 1);
                        END;
                    end;
                }
                action("E-Way Bill Print")
                {
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("E-Way Bill Report URL");
                        /*
                        test := COPYSTR(Rec."No.",1,2);
                        test1 := COPYSTR(Rec."No.",4,4);
                        test2 := COPYSTR(Rec."No.",9,5);
                        Doc_No := test+'_'+test1+'_'+test2;
                        
                        //IF EXISTS('C:\Users\HEMANT.THAPA\Downloads\'+Doc_No+'.Pdf') THEN
                          ERASE('C:\Users\HEMANT.THAPA\Downloads\'+Doc_No+'.Pdf');
                        */
                        HYPERLINK(Rec."E-Way Bill Report URL");
                        /*
                        test := '';
                        test1 := '';
                        test2 := '';
                        Doc_No := '';
                        test := COPYSTR(Rec."No.",1,2);
                        test1 := COPYSTR(Rec."No.",4,4);
                        test2 := COPYSTR(Rec."No.",9,5);
                        Doc_No := test+'_'+test1+'_'+test2;
                        HYPERLINK('C:\Users\HEMANT.THAPA\Downloads\'+Doc_No+'.Pdf');
                        */

                    end;
                }
                // action("Update Structure")
                // {
                //     Caption = 'Update Structure';
                //     Promoted = true;
                //     ApplicationArea = All;
                //     PromotedCategory = New;
                //     PromotedIsBig = true;
                //     PromotedOnly = true;
                //     Image = UpdateXML;

                //     trigger OnAction()
                //     var
                //         TransRoute: Record "Transfer Route";
                //     begin
                //         TransRoute.Reset();
                //         if TransRoute.FindFirst() then begin
                //             repeat
                //                 if TransRoute.Structure <> '' then begin
                //                     TransRoute."GST Applicable" := true;
                //                     TransRoute.Modify();
                //                 end;
                //             until TransRoute.Next() = 0;
                //         end;
                //     end;
                // }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Structure)
                {
                    Caption = 'Structure';
                    Image = Hierarchy;

                    trigger OnAction()
                    begin
                        //CurrPage.SalesInvLines.PAGE.ShowStrOrderDetailsPITForm;
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoInvoice)
                {
                    Caption = 'Invoice';
                    Enabled = CRMIsCoupledToRecord;
                    Image = CoupledInvoice;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM account.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CreateInCRM)
                {
                    Caption = 'Create Invoice in Dynamics CRM';
                    Enabled = NOT CRMIsCoupledToRecord;
                    Image = NewInvoice;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        //CRMIntegrationManagement.CreateNewRecordInCRM(Rec.RecordId, FALSE);   //Team-17783    Commented
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print Invoice")
                {
                    Caption = 'Print Invoice';
                    Image = Print;

                    trigger OnAction()
                    begin
                        SalesInvHeader := Rec;
                        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                        SalesInvHeader.PrintRecords(TRUE);
                    end;
                }
                //->Team-17783
                // action("Print Tax Invoice")
                // {
                //     Caption = 'Print Tax Invoice';
                //     Image = PrintVAT;

                //     trigger OnAction()
                //     begin
                //         SalesInvHeader.RESET;
                //         SalesInvHeader.SETRANGE("No.", Rec."No.");
                //         REPORT.RUNMODAL(REPORT::"Tax Invoice", TRUE, TRUE, SalesInvHeader);
                //     end;
                // }
                // action("Print Trading Invoice")
                // {
                //     Caption = 'Print Trading Invoice';
                //     Image = PrintVoucher;

                //     trigger OnAction()
                //     var
                //         TradingInvoiceReport: Report 16555;
                //     begin
                //         CLEAR(TradingInvoiceReport);
                //         SalesInvHeader.RESET;
                //         SalesInvHeader.SETRANGE("No.", Rec."No.");
                //         SalesInvHeader.FINDFIRST;
                //         TradingInvoiceReport.SETTABLEVIEW(SalesInvHeader);
                //         TradingInvoiceReport.SetCustomerNo(SalesInvHeader."Sell-to Customer No.", SalesInvHeader."Ship-to Code");
                //         TradingInvoiceReport.RUNMODAL;
                //     end;
                // }
                // action("Print Excise Invoice")
                // {
                //     Caption = 'Print Excise Invoice';
                //     Image = PrintExcise;

                //     trigger OnAction()
                //     var
                //         RepExciseInvoice: Report 16593;
                //         Text001: Label 'Record not found.';
                //     begin
                //         CLEAR(RepExciseInvoice);
                //         SalesInvHeader.RESET;
                //         SalesInvHeader.SETRANGE("No.", Rec."No.");
                //         IF SalesInvHeader.FINDFIRST THEN BEGIN
                //             RepExciseInvoice.SETTABLEVIEW(SalesInvHeader);
                //             RepExciseInvoice.RUNMODAL;
                //         END ELSE
                //             ERROR(Text001);
                //     end;
                // }
                //<-Team-17783
            }
            action(SendCustom)
            {
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvHeader: Record 112;
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    // Call SendRecords to open sending profile dialog
                    SalesInvHeader.SendRecords;
                end;
            }
            action("&Email")
            {
                Caption = '&Email';
                Image = Email;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.EmailRecords(TRUE);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(ActivityLog)
            {
                Caption = 'Activity Log';
                Image = Log;

                trigger OnAction()
                begin
                    Rec.ShowActivityLog;
                end;
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        IncomingDocument.ShowCard(Rec."No.", Rec."Posting Date");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData 130 = R;
                    Caption = 'Select Incoming Document';
                    Enabled = NOT HasIncomingDocument;
                    Image = SelectLineToApply;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        IncomingDocument: Record 130;
                    begin
                        IncomingDocument.SelectIncomingDocumentForPostedDocument(Rec."No.", Rec."Posting Date", Rec.RecordId);
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = NOT HasIncomingDocument;
                    Image = Attach;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record 133;
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromPostedDocument(Rec."No.", Rec."Posting Date");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //MZH
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FILTERGROUP(0);
        END;
        //MZH
    end;

    var
        SalesInvHeader: Record 112;
        HasIncomingDocument: Boolean;
        DocExchStatusStyle: Text;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        SalesInvLines: Record 113;
        CodeunitEWayBill: Codeunit 50001;
        Dialogbox: Dialog;
        Text0001: Label 'Yes';
        txtMessage: Text;
        txtMessageVeh: Text;
        txtMessagecancel: Text;
        test: Text;
        test1: Text;
        test2: Text;
        Doc_No: Text;
        txtMessageDistance: Text;
        txtMessageDistancepre: Text;
        UserMgt: Codeunit "User Setup Management";
        CU50200: Codeunit 50200;
}

