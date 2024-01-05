page 50042 "Posted E-Invoice (SalesReturn)"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Permissions = TableData 112 = rm;
    SourceTable = 50000;
    SourceTableView = WHERE("GST Customer Type" = FILTER(Registered),
                            "Transaction Type" = FILTER('Sales Credit Memo'),
                            "E-Invoice IRN No" = FILTER(<> ''));

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
                field("Amount to Customer"; Rec."Amount to Customer")
                {
                    Editable = false;
                }
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
                    Editable = false;
                }
                field("E-Invoice PDF"; Rec."E-Invoice PDF")
                {
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
        UserMgt: Codeunit 5700;
}

