page 50014 "PO Status"
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
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Order Date"; recOrderDate)
                {
                }
                field("Vendor Name"; PurchHeader."Pay-to Name")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Type; Rec.Type)
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
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Payment Term"; PurchHeader."Payment Terms Code")
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
}

