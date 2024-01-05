page 50017 "PO Detail Status"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    RefreshOnActivate = true;
    ShowFilter = true;
    SourceTable = 39;
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Vendor Name"; PurchHeader."Pay-to Name")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                }
                field("GST Base Amount"; Cu50200.LineGSTBaseAmt(Rec))
                {
                }
                field("GST %"; Cu50200.PurchLineGSTPerc(Rec.RecordId))
                {
                }
                field("Total GST Amount"; Cu50200.TotalGSTAmtLine(Rec))
                {
                }
                field("Amount To Vendor"; Cu50200.AmttoVendorLine(Rec))
                {
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recOrderDate := 0D;
        PurchHeader.RESET();
        PurchHeader.SETRANGE("No.", Rec."Document No.");
        IF PurchHeader.FINDFIRST THEN
            recOrderDate := PurchHeader."Order Date";
    end;

    var
        PurchHeader: Record 38;
        recOrderDate: Date;
        Cu50200: Codeunit 50200;
}

