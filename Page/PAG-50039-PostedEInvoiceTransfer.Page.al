page 50039 "Posted E-Invoice (Transfer)"
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
                action("E-Invoice QR Code Action")
                {
                    Promoted = true;
                    Caption = 'E-Invoice QR Code';
                    trigger OnAction()
                    begin
                        //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                        HYPERLINK(Rec."E-Invoice QR Code");
                        //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                    end;
                }
                action("E-Invoice PDF Action")
                {
                    Promoted = true;
                    Caption = 'E-Invoice PDF';
                    trigger OnAction()
                    begin
                        //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                        HYPERLINK(Rec."E-Invoice PDF");
                        //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
                    end;
                }
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

