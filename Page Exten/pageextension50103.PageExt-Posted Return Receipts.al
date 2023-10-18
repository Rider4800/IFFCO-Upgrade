pageextension 50103 pageextension50103 extends "Posted Return Receipts"
{
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('Insertion is not allowed.');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('Deletion is not allowed.');
    end;
}

