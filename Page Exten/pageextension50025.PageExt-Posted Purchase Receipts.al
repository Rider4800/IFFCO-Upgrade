pageextension 50025 pageextension50025 extends "Posted Purchase Receipts"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Purchase Receipts"(Page 145)".
    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Purchase Receipts"(Page 145)".

    layout
    {
        addafter("No.")
        {
            field("Order Date"; Rec."Order Date")
            {
            }
            field("Order No."; Rec."Order No.")
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
}

