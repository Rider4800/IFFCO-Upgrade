pageextension 50102 pageextension50102 extends "Posted Return Receipt"
{
    trigger OnDeleteRecord(): Boolean
    begin
        Error('Deletion is not allowed.');
    end;
}

