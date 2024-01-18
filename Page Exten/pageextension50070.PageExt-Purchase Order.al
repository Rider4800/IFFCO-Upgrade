pageextension 50070 pageextension50070 extends "Purchase Order"
{
    layout
    {
        modify("Location Code")
        {
            Editable = VisiblityBool;
            Enabled = VisiblityBool;
        }
        addafter("Assigned User ID")
        {
            field("Certificate of Analysis"; Rec."Certificate of Analysis")
            {
                ApplicationArea = all;
            }
            field("Branch Accounting"; Rec."Branch Accounting")
            {
                ApplicationArea = all;
            }
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Assigned User ID"; "Location Code")
        moveafter("Certificate of Analysis"; "Shortcut Dimension 1 Code")
        //moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
    actions
    {
        addafter(PostedPrepaymentCrMemos)
        {
            action("PO-Supplier Copy")
            {
                ApplicationArea = All;
                PromotedCategory = Report;
                Image = Purchase;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    recPurchaseHeader.RESET();
                    recPurchaseHeader.SETRANGE("No.", Rec."No.");
                    //recPurchaseHeader.SETRANGE("Posting Date",Rec."Posting Date");
                    if recPurchaseHeader.FindFirst() then
                        REPORT.RUN(50021, TRUE, TRUE, recPurchaseHeader);
                end;
            }
            action("PO-Office Copy")
            {
                ApplicationArea = All;
                PromotedCategory = Report;
                Image = Purchasing;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    recPurchaseHeader.RESET();
                    recPurchaseHeader.SETRANGE("No.", Rec."No.");
                    //recPurchaseHeader.SETRANGE("Posting Date",Rec."Posting Date");
                    IF recPurchaseHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50022, TRUE, TRUE, recPurchaseHeader);
                    END;
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if ShipToOptions = ShipToOptions::"Default (Company Address)" then
            VisiblityBool := false
        else
            VisiblityBool := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if ShipToOptions = ShipToOptions::"Default (Company Address)" then
            VisiblityBool := false
        else
            VisiblityBool := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if ShipToOptions = ShipToOptions::"Default (Company Address)" then
            VisiblityBool := false
        else
            VisiblityBool := true;
    end;

    var
        recPurchaseHeader: Record 38;
        VisiblityBool: Boolean;
}

