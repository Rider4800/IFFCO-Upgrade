page 50009 "Inward sheet"
{
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 123;
    SourceTableView = WHERE(Type = FILTER(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Document Type"; Rec."Source Document Type")
                {
                    Caption = 'Document Type';
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Invoice No.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Party Name"; recPurchaseInvHeader."Pay-to Name")
                {
                    Lookup = false;
                }
                field("Vendor Invoice No."; recPurchaseInvHeader."Vendor Invoice No.")
                {
                    Caption = 'Supplier Invoice No.';
                }
                field("Document Date"; recPurchaseInvHeader."Document Date")
                {
                    Caption = 'Supplier Invoice Date';
                }
                field("Due Date"; recPurchaseInvHeader."Due Date")
                {
                }
                field("Vendor State"; recPurchaseInvHeader."Location State Code")
                {
                }
                field("Buy-From GST Registration No"; Rec."Buy-From GST Registration No")
                {
                    Caption = 'Vendor GSTIN';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location (Company)';
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                    Caption = 'Material Code';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Material Name';
                }
                field(Lot; Lot)
                {
                    Caption = 'Lot No.';
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Qty';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Caption = 'UOM';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Caption = 'Price';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Line Amount';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    Caption = 'Discount %';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Caption = 'Discount Amount';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    Caption = 'HSN/SAC';
                }
                field("GST %"; CU50200.PurchLineGSTPerc(Rec.RecordId))
                {
                    Caption = 'GST %';
                }
                field("GST Base Amount"; CU50200.GetGSTBaseAmtPostedLine(Rec."Document No.", Rec."Line No."))
                {
                    Caption = 'GST Base Amount';
                }
                field("Total GST Amount"; CU50200.GetTotalGSTAmtPostedLine(Rec."Document No.", Rec."Line No."))
                {
                    Caption = 'GST Value';
                }
                field("Amount To Vendor"; CU50200.GetAmttoVendorPostedLine(Rec."Document No.", Rec."Line No."))
                {
                    Caption = 'Amount to Vendor';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        recPurchaseInvHeader.SETRANGE("No.", Rec."Document No.");
        IF recPurchaseInvHeader.FINDFIRST THEN
            recValueEntry.SETRANGE("Document No.", Rec."Document No.");
        recValueEntry.SETRANGE("Document Line No.", Rec."Line No.");
        IF recValueEntry.FINDFIRST THEN BEGIN
            recItemLedEntry.SETRANGE("Entry No.", recValueEntry."Item Ledger Entry No.");
            IF recItemLedEntry.FINDFIRST THEN
                Lot := recItemLedEntry."Lot No.";
        END;
    end;

    var
        recPurchaseInvHeader: Record 122;
        recValueEntry: Record 5802;
        recItemLedEntry: Record 32;
        Lot: Code[20];
        CU50200: Codeunit 50200;
}

