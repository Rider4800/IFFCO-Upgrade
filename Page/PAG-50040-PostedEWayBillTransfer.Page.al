page 50040 "Posted E-Way Bill (Transfer)"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50000;
    SourceTableView = WHERE("Transaction Type" = FILTER('Transfer Shipment'),
                            "E-Way Bill No." = FILTER(<> ''));

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
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Transfer-from Code';
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Transfer-to Name';
                    Editable = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    Caption = 'Transfer-to Address';
                    Editable = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    Caption = 'Transfer-to Address 2';
                    Editable = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    Caption = 'Transfer-to City';
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Caption = 'Transfer-to Post Code';
                    Editable = false;
                }
                field(State; Rec.State)
                {
                    Caption = 'Transfer-to State';
                    Editable = false;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    Editable = false;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    Editable = true;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                }
                field("Transportation Mode"; Rec."Transportation Mode")
                {
                    Editable = true;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    Caption = 'Transfer-from State';
                    Editable = false;
                }
                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    Editable = false;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    Editable = false;
                }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    Caption = 'Transfer-from GST Reg No.';
                    Editable = false;
                }
                field("Customer GST Reg. No."; Rec."Customer GST Reg. No.")
                {
                    Caption = 'Transfer-to GST Reg No.';
                    Editable = false;
                }
                field("Distance (Km)"; Rec."Distance (Km)")
                {
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                    Editable = false;
                }
                field("Transporter GSTIN"; Rec."Transporter GSTIN")
                {
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Transfer-to Country/Region Code';
                    Editable = false;
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
                }
                field("Cancel E-Way Bill Date"; Rec."Cancel E-Way Bill Date")
                {
                    Editable = false;
                }
                field("E-Way Bill Status"; Rec."E-Way Bill Status")
                {
                    Editable = false;
                }
                field("Old Vehicle No."; Rec."Old Vehicle No.")
                {
                }
                field("Reason Code for Cancel"; Rec."Reason Code for Cancel")
                {
                }
                field("Reason for Cancel Remarks"; Rec."Reason for Cancel Remarks")
                {
                }
                field("Reason Code for Vehicle Update"; Rec."Reason Code for Vehicle Update")
                {
                }
                field("Reason for Vehicle Update"; Rec."Reason for Vehicle Update")
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
            group("E-Way Bill")
            {
                Caption = 'E-Way Bill';
                Image = Administration;
                action("E-Way Bill Print")
                {
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("E-Way Bill Report URL");

                        HYPERLINK(Rec."E-Way Bill Report URL");
                    end;
                }
                action("Update Vehicle No.")
                {
                    Promoted = true;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE();

                        Rec.TESTFIELD("Vehicle No.");
                        Rec.TESTFIELD("Reason Code for Vehicle Update");
                        Rec.TESTFIELD("Reason for Vehicle Update");

                        txtMessageVeh := 'Do you want to update Vehicle No. : New Vehicle No. is ' + Rec."Vehicle No." + ' Old Vehicle No. ' + Rec."Old Vehicle No.";

                        IF CONFIRM(txtMessageVeh) THEN BEGIN
                            IF Rec."Vehicle No." = Rec."Old Vehicle No." THEN
                                ERROR('Update new Vehicle No.')
                            // ELSE
                            //     CodeunitEWayBillEInvoice.InitializeUpdateVehicleNoTransferShipment(Rec."No.", Rec."Vehicle No.");    //17783
                        END;
                    end;
                }
                action("Cancel E-Way Bill No.")
                {
                    Promoted = true;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE();

                        Rec.TESTFIELD("E-Way Bill No.");
                        Rec.TESTFIELD("Reason Code for Cancel");
                        Rec.TESTFIELD("Reason for Cancel Remarks");

                        txtMessagecancel := 'Do you want to Cancel the E-Way Bill No. ' + Rec."E-Way Bill No.";

                        IF CONFIRM(txtMessagecancel) THEN BEGIN
                            //CodeunitEWayBillEInvoice.InitializeCancelBillNoTransferShipment(Rec."No.", Rec."E-Way Bill No.")  //17783
                        END;
                    end;
                }
                action("Generate E-Way Bill No.")
                {
                    Promoted = true;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE();

                        Rec.TESTFIELD("Sell-to Post Code");

                        IF (Rec."E-Way Bill No." <> '') AND (Rec."Cancel E-Way Bill Date" = '') THEN
                            ERROR('E-Way Bill is already generated');

                        Rec.TESTFIELD("Distance (Km)");
                        //TESTFIELD("LR/RR No.");
                        //TESTFIELD("LR/RR Date");
                        //TESTFIELD("Transportation Mode");
                        //TESTFIELD("Vehicle No.");
                        //TESTFIELD("Distance (Km)");
                        //TESTFIELD("Mode of Transport");

                        txtMessage := 'Do you want to generate E-Way Bill No. for Document No. ' + Rec."No." + ', Posting Date ' + FORMAT(Rec."Posting Date") + ', Amount to Transfer ' + FORMAT(Rec."Amount to Transfer");

                        IF CONFIRM(txtMessage) THEN BEGIN
                            //CodeunitEWayBillEInvoice.InitializeEwayBillGenerateTransferShipment(Rec."No.")    //17783
                        END;
                    end;
                }
            }
        }
    }

    var
        CodeunitEWayBillEInvoice: Codeunit 50001;
        txtMessage: Text;
        txtMessageVeh: Text;
        txtMessagecancel: Text;
        txtMessageDistance: Text;
        txtMessageDistancepre: Text;
        HasIncomingDocument: Boolean;
}

