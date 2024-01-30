page 50006 "E-Invoice (Transfer)"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50000;
    SourceTableView = WHERE("Transaction Type" = FILTER('Transfer Shipment'),
                            "E-Invoice IRN No" = FILTER(''));

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
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Transfer-from Code';
                    Editable = false;
                }
                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    Editable = false;
                }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    Caption = 'Transfer-from GST Reg. No.';
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
                    Editable = false;
                }
                field("E-Invoice IRN No"; Rec."E-Invoice IRN No")
                {
                    Editable = false;
                }
                field("E-Invoice QR Code"; Rec."E-Invoice QR Code")
                {
                    Editable = false;
                }
                field("E-Invoice PDF"; Rec."E-Invoice PDF")
                {
                    Editable = false;
                }
                field("E-Invoice Cancel Date"; Rec."E-Invoice Cancel Date")
                {
                    Editable = false;
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
                field("QR Code"; Rec."QR Code")
                {
                    ApplicationArea = All;
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
                        CU50014: Codeunit 50014;
                    begin
                        CurrPage.UPDATE;
                        CLEAR(CodeunitEWayBillEInvoice);
                        IF (Rec."E-Invoice IRN No" <> '') AND (Rec."E-Invoice Cancel Date" = '') THEN
                            ERROR('E-Invoice is already generated');
                        Rec.CALCFIELDS("Amount to Customer");
                        txtMessage := 'Do you want to generate E-Invoice IRN No. for Document No. ' + Rec."No." + ', Posting Date ' + FORMAT(Rec."Posting Date") + ', Amount to Transfer ' + FORMAT(Rec."Amount to Transfer");

                        IF CONFIRM(txtMessage) THEN BEGIN
                            TransferShipHdr.RESET;
                            TransferShipHdr.SETRANGE("No.", Rec."No.");
                            IF TransferShipHdr.FINDFIRST THEN
                                CU50014.CreateJsonTransferShipOrder(TransferShipHdr);
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
                        CU50014: Codeunit 50014;
                    begin
                        CurrPage.UPDATE;
                        CLEAR(CodeunitEWayBillEInvoice);
                        Rec.TESTFIELD("E-Invoice IRN No");
                        Rec.TESTFIELD("E-Invoice Cancel Reason");
                        Rec.TESTFIELD("E-Invoice Cancel Remarks");

                        txtMessagecancel := 'Do you want to Cancel the E-Invoice IRN No. ' + Rec."E-Invoice IRN No";

                        IF CONFIRM(txtMessagecancel) THEN
                            CU50014.CanceTransShpmntEInvoice(Rec."No.", Rec."E-Invoice IRN No");

                        CurrPage.UPDATE;
                        CLEAR(CodeunitEWayBillEInvoice);
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
                //         CLEAR(CodeunitEWayBillEInvoice);
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
                //         CLEAR(CodeunitEWayBillEInvoice);

                //         txtMessageDistancepre := 'Do you want to Re-Calculate Distance (KM) for Document No. ' + Rec."No." + ' Current value of Distance (KM) is ' + FORMAT(Rec."Distance (Km)");

                //         // IF Rec."Distance (Km)" <> '' THEN BEGIN
                //         //     IF CONFIRM(txtMessageDistancepre) THEN
                //         //         CodeunitEWayBillEInvoice.InitializeCalculateDistanceTransferShip(Rec."No.");
                //         // END; //17783

                //         txtMessageDistance := 'Do you want to Calculate Distance (KM) for Document No. ' + Rec."No.";

                //         // IF Rec."Distance (Km)" = '' THEN BEGIN
                //         //     IF CONFIRM(txtMessageDistance) THEN
                //         //         CodeunitEWayBillEInvoice.InitializeCalculateDistanceTransferShip(Rec."No.");
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
                //         CLEAR(CodeunitEWayBillEInvoice);
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
                //         Rec.TESTFIELD("E-Way Bill No.");
                //         Rec.TESTFIELD("Reason Code for Cancel");
                //         Rec.TESTFIELD("Reason for Cancel Remarks");

                //         txtMessagecancel := 'Do you want to Cancel the E-Way Bill No. ' + Rec."E-Way Bill No.";

                //         IF CONFIRM(txtMessagecancel) THEN BEGIN
                //             // CodeunitEWayBill.InitializeCancelBillNo(Rec."No.", Rec."E-Way Bill No.")  //17783
                //         END;
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
                }
            }
        }
    }

    var
        CodeunitEWayBillEInvoice: Codeunit 50000;
        txtMessage: Text;
        txtMessageVeh: Text;
        txtMessagecancel: Text;
        txtMessageDistance: Text;
        txtMessageDistancepre: Text;
        HasIncomingDocument: Boolean;
        txtMessageGetEInvoice: Text;
        eInvoice: Codeunit 50002;
        TransferShipHdr: Record 5744;
        CodeunitEWayBill: Codeunit 50001;
}

