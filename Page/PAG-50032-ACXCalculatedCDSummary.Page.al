page 50032 "ACX Calculated CD Summary"
{
    Caption = 'Calculated CD Summary';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "ACX Calculated CD Summary";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(IsCalculated; Rec.IsCalculated)
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Invoince Due Date"; Rec."Invoince Due Date")
                {
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Warehouse code"; Rec."Warehouse code")
                {
                }
                field("Taxes & Charges Amt Adj"; Rec."Taxes & Charges Amt Adj")
                {
                }
                field("Invoice Amt. Exclud GST"; Rec."Invoice Amt. Exclud GST")
                {
                }
                field("Taxes & Charges Amount"; Rec."Taxes & Charges Amount")
                {
                }
                field("Adjusted Amount"; Rec."Adjusted Amount")
                {
                }
                field("Invoice CD Amount"; Rec."Invoice CD Amount")
                {
                }
                field("CD Amount"; Rec."CD Amount")
                {
                }
                field("CD Calculated On Amount"; Rec."CD Calculated On Amount")
                {
                }
                field("CD Days"; Rec."CD Days")
                {
                }
                field("Rate of CD"; Rec."Rate of CD")
                {
                }
                field("CD to be Given"; Rec."CD to be Given")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Payment No."; Rec."Payment No.")
                {
                }
                field("Payment Date"; Rec."Payment Date")
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                }
                field("Posted Credit Note ID"; Rec."Posted Credit Note ID")
                {
                }
                field("Posted Credit Note Date"; Rec."Posted Credit Note Date")
                {
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                }
                field(IsReturn; Rec.IsReturn)
                {
                }
                field(PPSKatsu; Rec.PPSKatsu)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("CD Calculate")
            {
                Image = Calculate;
                Promoted = true;
                RunObject = Report 50062;
            }
            action("Create CD Voucher")
            {
                Image = Post;
                Promoted = true;
                //RunObject = Report 50023; //commented because this report was not given in list by IFFCO to TEAM, so to publish this main app, deleted those all other reports, kept copy of them in F Drive, and we commented this.
            }
            action(UpdateCDSummaryLine)
            {
                Image = Archive;

                trigger OnAction()
                begin
                    UpdateIsCalculated;
                end;
            }
            action("Update Scheme Status for Zero CD")
            {
                Image = Apply;
                Promoted = true;
                RunObject = Report 50064;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER(Rec.IsCalculated, '%1', FALSE);
    end;

    var
        recCL: Record "Cust. Ledger Entry";

    local procedure UpdateIsCalculated()
    var
        recAcxCDCalculate: Record 50020;
    begin
        recAcxCDCalculate.RESET;
        recAcxCDCalculate.SETRANGE("CD Amount", 0);
        IF recAcxCDCalculate.FINDSET THEN BEGIN
            REPEAT
                recAcxCDCalculate.IsCalculated := TRUE;
                recAcxCDCalculate.MODIFY;
            UNTIL recAcxCDCalculate.NEXT = 0;
            MESSAGE('CD Summary Lines are Archived Successfully');
        END;
    end;
}

