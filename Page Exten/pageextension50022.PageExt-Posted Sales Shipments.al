pageextension 50022 pageextension50022 extends "Posted Sales Shipments"
{
    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Sales Shipments"(Page 142)".
    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Shipments"(Page 142)".

    layout
    {
        addafter("Sell-to Post Code")
        {
            field("Order Date"; Rec."Order Date")
            {
            }
            field("Posting Description"; Rec."Posting Description")
            {
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('You are not allowed to insert');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You are not allowed to delete');
    end;

    var
        UserMgt: Codeunit 5700;
}

