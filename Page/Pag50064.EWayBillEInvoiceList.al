page 50064 "E-Way Bill & E-Invoice List"
{
    ApplicationArea = All;
    Caption = 'E-Way Bill & E-Invoice List';
    PageType = List;
    SourceTable = "E-Way Bill & E-Invoice";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cancel E-Way Bill Date"; Rec."Cancel E-Way Bill Date")
                {
                    ToolTip = 'Specifies the value of the Cancel E-Way Bill Date field.';
                }
                field("Customer GST Reg. No."; Rec."Customer GST Reg. No.")
                {
                    ToolTip = 'Specifies the value of the Customer GST Reg. No. field.';
                }
                field("Distance (Km)"; Rec."Distance (Km)")
                {
                    ToolTip = 'Specifies the value of the Distance (Km) field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("E-Invoice Acknowledge Date"; Rec."E-Invoice Acknowledge Date")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Acknowledge Date field.';
                }
                field("E-Invoice Acknowledge No."; Rec."E-Invoice Acknowledge No.")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Acknowledge No. field.';
                }
                field("E-Invoice Cancel Date"; Rec."E-Invoice Cancel Date")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Cancel Date field.';
                }
                field("E-Invoice Cancel Reason"; Rec."E-Invoice Cancel Reason")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Cancel Reason field.';
                }
                field("E-Invoice Cancel Remarks"; Rec."E-Invoice Cancel Remarks")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Cancel Remarks field.';
                }
                field("E-Invoice IRN No"; Rec."E-Invoice IRN No")
                {
                    ToolTip = 'Specifies the value of the E-Invoice IRN No field.';
                }
                field("E-Invoice IRN Status"; Rec."E-Invoice IRN Status")
                {
                    ToolTip = 'Specifies the value of the E-Invoice IRN Status field.';
                }
                field("E-Invoice PDF"; Rec."E-Invoice PDF")
                {
                    ToolTip = 'Specifies the value of the E-Invoice PDF field.';
                }
                field("E-Invoice QR Code"; Rec."E-Invoice QR Code")
                {
                    ToolTip = 'Specifies the value of the E-Invoice QR Code field.';
                }
                field("E-Invoice Status"; Rec."E-Invoice Status")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Status field.';
                }
                field("E-Way Bill Date"; Rec."E-Way Bill Date")
                {
                    ToolTip = 'Specifies the value of the E-Way Bill Date field.';
                }
                field("E-Way Bill No."; Rec."E-Way Bill No.")
                {
                    ToolTip = 'Specifies the value of the E-Way Bill No. field.';
                }
                field("E-Way Bill Report URL"; Rec."E-Way Bill Report URL")
                {
                    ToolTip = 'Specifies the value of the E-Way Bill Report URL field.';
                }
                field("E-Way Bill Status"; Rec."E-Way Bill Status")
                {
                    ToolTip = 'Specifies the value of the E-Way Bill Status field.';
                }
                field("E-Way Bill Valid Upto"; Rec."E-Way Bill Valid Upto")
                {
                    ToolTip = 'Specifies the value of the E-Way Bill Valid Upto field.';
                }
                field("E-way Bill Part"; Rec."E-way Bill Part")
                {
                    ToolTip = 'Specifies the value of the E-way Bill Part field.';
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    ToolTip = 'Specifies the value of the GST Customer Type field.';
                }
                field("GST Vendor Type"; Rec."GST Vendor Type")
                {
                    ToolTip = 'Specifies the value of the GST Vendor Type field.';
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ToolTip = 'Specifies the value of the LR/RR Date field.';
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ToolTip = 'Specifies the value of the LR/RR No. field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Location GST Reg. No."; Rec."Location GST Reg. No.")
                {
                    ToolTip = 'Specifies the value of the Location GST Reg. No. field.';
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    ToolTip = 'Specifies the value of the Location State Code field.';
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    ToolTip = 'Specifies the value of the Mode of Transport field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Old Vehicle No."; Rec."Old Vehicle No.")
                {
                    ToolTip = 'Specifies the value of the Old Vehicle No. field.';
                }
                field("Order Address City"; Rec."Order Address City")
                {
                    ToolTip = 'Specifies the value of the Order Address City field.';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ToolTip = 'Specifies the value of the Order Address Code field.';
                }
                field("Order Address Country Code"; Rec."Order Address Country Code")
                {
                    ToolTip = 'Specifies the value of the Order Address Country/Region Code field.';
                }
                field("Order Address Post Code"; Rec."Order Address Post Code")
                {
                    ToolTip = 'Specifies the value of the Order Address Post Code field.';
                }
                field("Port Code"; Rec."Port Code")
                {
                    ToolTip = 'Specifies the value of the Port Code field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("QR Code"; Rec."QR Code")
                {
                    ToolTip = 'Specifies the value of the QR Code field.';
                }
                field("Reason Code for Cancel"; Rec."Reason Code for Cancel")
                {
                    ToolTip = 'Specifies the value of the Reason Code for Cancel field.';
                }
                field("Reason Code for Vehicle Update"; Rec."Reason Code for Vehicle Update")
                {
                    ToolTip = 'Specifies the value of the Reason Code for Vehicle Update field.';
                }
                field("Reason for Cancel Remarks"; Rec."Reason for Cancel Remarks")
                {
                    ToolTip = 'Specifies the value of the Reason for Cancel Remarks field.';
                }
                field("Reason for Vehicle Update"; Rec."Reason for Vehicle Update")
                {
                    ToolTip = 'Specifies the value of the Reason for Vehicle Update field.';
                }
                field("Rec ID"; Rec."Rec ID")
                {
                    ToolTip = 'Specifies the value of the Rec ID field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ToolTip = 'Specifies the value of the Sell-to Address field.';
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ToolTip = 'Specifies the value of the Sell-to Address 2 field.';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ToolTip = 'Specifies the value of the Sell-to City field.';
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Sell-to Country/Region Code field.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer Name field.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ToolTip = 'Specifies the value of the Sell-to Post Code field.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the value of the Ship-to City field.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.';
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the value of the Transfer-to Code field.';
                }
                field("Transportation Mode"; Rec."Transportation Mode")
                {
                    ToolTip = 'Specifies the value of the Transportation Mode field.';
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                    ToolTip = 'Specifies the value of the Transporter Code field.';
                }
                field("Transporter GSTIN"; Rec."Transporter GSTIN")
                {
                    ToolTip = 'Specifies the value of the Transporter GSTIN field.';
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                    ToolTip = 'Specifies the value of the Transporter Name field.';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                }
                field("Vehicle Update Date"; Rec."Vehicle Update Date")
                {
                    ToolTip = 'Specifies the value of the Vehicle Update Date field.';
                }
                field("Vehicle Valid Upto"; Rec."Vehicle Valid Upto")
                {
                    ToolTip = 'Specifies the value of the Vehicle Valid Upto field.';
                }
                field("Vendor GST Reg. No."; Rec."Vendor GST Reg. No.")
                {
                    ToolTip = 'Specifies the value of the Vendor GST Reg. No. field.';
                }
            }
        }
    }
}
