pageextension 50059 pageextension50059 extends "Item Ledger Entries"
{
    layout
    {
        moveafter("Item No."; "Unit of Measure Code")
        modify("Unit of Measure Code")
        {
            Visible = true;
        }
    }
}

