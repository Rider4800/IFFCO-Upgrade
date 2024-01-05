page 50049 "Generated Scheme Summary"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50027;
    SourceTableView = WHERE("Credit Note No." = filter(<> ''));

    layout
    {
        area(content)
        {
            repeater("Repeater")
            {
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Order Priority"; Rec."Order Priority")
                {
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Invoice Due Date"; Rec."Invoice Due Date")
                {
                }
                field("Net Invoice Amount"; Rec."Net Invoice Amount")
                {
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                }
                field("Invoice Amt. Exclud GST"; Rec."Invoice Amt. Exclud GST")
                {
                }
                field("Taxes & Charges Amount"; Rec."Taxes & Charges Amount")
                {
                }
                field("Amount Excluded Item"; Rec."Amount Excluded Item")
                {
                }
                field("GST Amount Excluded Item"; Rec."GST Amount Excluded Item")
                {
                }
                field("Adjusted Amount"; Rec."Adjusted Amount")
                {
                }
                field("Taxes & Charges Amt Adj"; Rec."Taxes & Charges Amt Adj")
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
                field("CD Generation Date"; Rec."CD Generation Date")
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
                field("Posted Credit Note ID"; Rec."Posted Credit Note ID")
                {
                }
                field("Posted Credit Note Date"; Rec."Posted Credit Note Date")
                {
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                }
                field("CD Voucher Generated"; Rec."CD Voucher Generated")
                {
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                }
                field("Cust. Led. Entry No."; Rec."Cust. Led. Entry No.")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Warehouse code"; Rec."Warehouse code")
                {
                }
                field(IsCalculated; Rec.IsCalculated)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //SETFILTER("Credit Note No.",'<>%1','');
    end;

    var
        recUserSetup: Record 91;
        recVocherCreate: Codeunit 50009;
        recSaleLineNoSeries: Record 309;
        recSchemeSummary: Record 50027;
        recGBatch: Record 232;
        recSchmeMaster: Record 50005;
        "LastUseNo.": Code[20];
        LastUseDate: Date;
}

