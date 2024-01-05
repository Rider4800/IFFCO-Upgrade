page 50043 "Posted ACX Calc. CD Summary"
{
    Caption = 'Calculated CD Summary';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50020;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
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
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER(IsCalculated, '%1', TRUE);
    end;
}

