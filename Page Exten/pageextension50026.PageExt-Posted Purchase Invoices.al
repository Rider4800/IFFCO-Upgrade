pageextension 50026 pageextension50026 extends "Posted Purchase Invoices"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Purchase Invoices"(Page 146)".
    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Purchase Invoices"(Page 146)".

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('You are not allowed to insert');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You are not allowed to delete');
    end;
}

