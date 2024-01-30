page 50003 "E-Invoice (Sales)"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = TableData 112 = rm;
    SourceTable = 50000;
    SourceTableView = WHERE("GST Customer Type" = FILTER(Registered),
                            "Transaction Type" = FILTER('Sales Invoice'), "E-Invoice IRN No" = FILTER(''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = false;
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
                field(State; Rec.State)
                {
                    Editable = false;
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    Editable = false;
                }
                // field("Amount to Customer"; Rec."Amount to Customer")
                // {
                //     Editable = false;
                // }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    Editable = false;
                }
                field("Customer GST Reg. No."; Rec."Customer GST Reg. No.")
                {
                    Editable = false;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                }
                field("Distance (Km)"; Rec."Distance (Km)")
                {
                    Editable = false;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                }
                field("Port Code"; Rec."Port Code")
                {
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    Editable = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    Editable = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    Editable = false;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    Editable = false;
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    Editable = false;
                }
                field("E-Invoice IRN Status"; Rec."E-Invoice IRN Status")
                {
                    Editable = false;
                }
                field("E-Invoice Acknowledge No."; Rec."E-Invoice Acknowledge No.")
                {
                    Editable = false;
                }
                field("E-Invoice Acknowledge Date"; Rec."E-Invoice Acknowledge Date")
                {
                    Editable = true;
                }
                field("E-Invoice IRN No"; Rec."E-Invoice IRN No")
                {
                    Editable = false;
                }
                field("E-Invoice QR Code"; Rec."E-Invoice QR Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Invoice PDF"; Rec."E-Invoice PDF")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("E-Invoice Cancel Date"; Rec."E-Invoice Cancel Date")
                {
                    Editable = true;
                }
                field("E-Invoice Cancel Reason"; Rec."E-Invoice Cancel Reason")
                {
                }
                field("E-Invoice Cancel Remarks"; Rec."E-Invoice Cancel Remarks")
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
                field("E-Invoice Status"; Rec."E-Invoice Status")
                {
                    Editable = false;
                }
                field("Reason Code for Cancel"; Rec."Reason Code for Cancel")
                {
                }
                field("Reason for Cancel Remarks"; Rec."Reason for Cancel Remarks")
                {
                }
                field("E-Way Bill Status"; Rec."E-Way Bill Status")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E-Invoice")
            {
                Caption = 'E-Invoice';
                Image = Administration;
                action("Generate E-Invoice")
                {
                    Caption = 'Generate E-Invoice';
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        CU50012: Codeunit 50012;
                        CU50200: Codeunit 50200;
                        decAmount2Cust: Decimal;
                    begin
                        CurrPage.UPDATE;
                        IF (Rec."E-Invoice IRN No" <> '') AND (Rec."E-Invoice Cancel Date" = '') THEN
                            ERROR('E-Invoice is already generated');
                        decAmount2Cust := 0;
                        decAmount2Cust := CU50200.GetAmttoCustomerPostedDoc(Rec."No."); //Team-17783    Added
                        txtMessage := 'Do you want to generate E-Invoice IRN No. for Document No. ' + Rec."No." + ', Posting Date ' + FORMAT(Rec."Posting Date") + ', Amount to Customer ' + FORMAT(decAmount2Cust);

                        IF CONFIRM(txtMessage) THEN BEGIN
                            SalesInvHeader.RESET;
                            SalesInvHeader.SETRANGE("No.", Rec."No.");
                            IF SalesInvHeader.FINDFIRST THEN
                                CU50012.CreateJsonSalesInvoiceOrder(SalesInvHeader);
                        END;
                        CurrPage.UPDATE;
                        CLEAR(CodeunitEWayBillEInvoice);
                    end;
                }
                action("Cancel E-Invoice")
                {
                    Caption = 'Cancel E-Invoice';
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Cancel;

                    trigger OnAction()
                    var
                        CU50012: Codeunit 50012;
                    begin
                        CurrPage.UPDATE;
                        Rec.TESTFIELD("E-Invoice IRN No");
                        Rec.TESTFIELD("E-Invoice Cancel Reason");
                        Rec.TESTFIELD("E-Invoice Cancel Remarks");
                        txtMessagecancel := 'Do you want to Cancel the E-Invoice IRN No. ' + Rec."E-Invoice IRN No";

                        IF CONFIRM(txtMessagecancel) THEN
                            CU50012.CanceSalesInvEInvoice(Rec."No.", Rec."E-Invoice IRN No");
                        CurrPage.UPDATE;
                    end;
                }
                // action("Get          E-Invoice")
                // {
                //     Caption = 'Get  E-Invoice';
                //     Promoted = true;

                //     trigger OnAction()
                //     var
                //         txtGetIRNNo: Text;
                //     begin
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                //         CurrPage.UPDATE;

                //         Rec.TESTFIELD("Location GST Reg. No.");
                //         Rec.TESTFIELD("E-Invoice IRN No");

                //         txtGetIRNNo := 'Do you want to Get E-Invoice IRN No. for Document No. ' + Rec."No.";

                //         IF CONFIRM(txtGetIRNNo) THEN BEGIN
                //             //CodeunitEWayBillEInvoice.InitializeGetEInvoive(Rec."No.", Rec."E-Invoice IRN No");    //17783
                //         END;

                //         CurrPage.UPDATE;
                //         CLEAR(CodeunitEWayBillEInvoice);
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                //     end;
                // }
                // action("Calculate Distance (KM)")
                // {
                //     Caption = 'Calculate Distance (KM)';
                //     Promoted = true;

                //     trigger OnAction()
                //     begin
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                //         CurrPage.UPDATE();

                //         IF Rec."GST Customer Type" IN [Rec."GST Customer Type"::Export, Rec."GST Customer Type"::"SEZ Development", Rec."GST Customer Type"::"SEZ Unit"] THEN BEGIN
                //             Rec.TESTFIELD("Port Code");
                //         END;

                //         IF Rec."GST Customer Type" IN [Rec."GST Customer Type"::" ", Rec."GST Customer Type"::"Deemed Export", Rec."GST Customer Type"::Exempted, Rec."GST Customer Type"::Registered, Rec."GST Customer Type"::Unregistered] THEN BEGIN
                //             IF Rec."Ship-to Code" = '' THEN
                //                 Rec.TESTFIELD("Sell-to Post Code")
                //             ELSE
                //                 Rec.TESTFIELD("Ship-to Post Code");
                //         END;

                //         txtMessageDistancepre := 'Do you want to Re-Calculate Distance (KM) for Document No. ' + Rec."No." + ' Current value of Distance (KM) is ' + FORMAT(Rec."Distance (Km)");

                //         // IF Rec."Distance (Km)" <> '' THEN BEGIN
                //         //     IF CONFIRM(txtMessageDistancepre) THEN
                //         //         CodeunitEWayBillEInvoice.InitializeCalculateDistance(Rec."No.");
                //         // END; //17783

                //         txtMessageDistance := 'Do you want to Calculate Distance (KM) for Document No. ' + Rec."No.";

                //         // IF Rec."Distance (Km)" = '' THEN BEGIN
                //         //     IF CONFIRM(txtMessageDistance) THEN
                //         //         CodeunitEWayBillEInvoice.InitializeCalculateDistance(Rec."No.");
                //         // END; //17783

                //         CurrPage.UPDATE;
                //         CLEAR(CodeunitEWayBillEInvoice);
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                //     end;
                // }
                // action("Generate E-Way Bill By IRN")
                // {
                //     Caption = 'Generate E-Way Bill By IRN';
                //     Promoted = true;

                //     trigger OnAction()
                //     var
                //         txtGenerateEwayBillByIrn: Text;
                //     begin
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                //         CurrPage.UPDATE;

                //         Rec.TESTFIELD("Transporter Code");
                //         Rec.TESTFIELD("Location GST Reg. No.");
                //         Rec.TESTFIELD("Distance (Km)");
                //         Rec.TESTFIELD("Vehicle No.");

                //         IF Rec."E-Invoice IRN Status" <> 'ACT' THEN
                //             ERROR('E-Invoice IRN Status must be Active (ACT)');

                //         txtGenerateEwayBillByIrn := 'Do you want to Generate E-Way Bill By Irn No. ' + Rec."E-Invoice IRN No";

                //         IF CONFIRM(txtGenerateEwayBillByIrn) THEN BEGIN
                //             //CodeunitEWayBillEInvoice.InitializeGenerateEwayBillByIRN(Rec."No.", Rec."E-Invoice IRN No");  //17783
                //         END;

                //         CurrPage.UPDATE;
                //         CLEAR(CodeunitEWayBillEInvoice);
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                //     end;
                // }
                // action("Cancel E-Way Bill No.")
                // {
                //     Promoted = true;

                //     trigger OnAction()
                //     begin
                //         // TESTFIELD("E-Way Bill No.");
                //         // TESTFIELD("Reason Code for Cancel");
                //         // TESTFIELD("Reason for Cancel Remarks");
                //         //
                //         // txtMessagecancel :=  'Do you want to Cancel the E-Way Bill No. ' + Rec."E-Way Bill No.";
                //         //
                //         // IF CONFIRM(txtMessagecancel) THEN BEGIN
                //         //  CodeunitEWayBill.InitializeCancelBillNo(Rec."No.",Rec."E-Way Bill No.")
                //         // END;
                //     end;
                // }
                // action("EInvoice QR Code")
                // {
                //     Caption = 'E-Invoice QR Code';
                //     Promoted = true;

                //     trigger OnAction()
                //     begin
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                //         HYPERLINK(Rec."E-Invoice QR Code");
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                //     end;
                // }
                // action("EInvoice PDF")
                // {
                //     Caption = 'E-Invoice PDF';
                //     Promoted = true;

                //     trigger OnAction()
                //     begin
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                //         HYPERLINK(Rec."E-Invoice PDF");
                //         //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                //     end;
                // }
                // action("Response Logs")
                // {
                //     Promoted = true;
                //     RunObject = Page "Response Logs";
                //     RunPageLink = "Document No." = FIELD("No.");
                // }
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
        CodeunitEWayBillEInvoice: Codeunit 50000;
        txtMessage: Text;
        txtMessageVeh: Text;
        txtMessagecancel: Text;
        txtMessageDistance: Text;
        txtMessageDistancepre: Text;
        HasIncomingDocument: Boolean;
        txtMessageGetEInvoice: Text;
        eInvoice: Codeunit 50000;
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        CodeunitEWayBill: Codeunit 50001;
        UserMgt: Codeunit "User Setup Management";
}

