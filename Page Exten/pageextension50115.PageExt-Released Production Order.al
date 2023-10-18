pageextension 50115 pageextension50115 extends "Released Production Order"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = false;
        }
        moveafter("Due Date"; "Location Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")

    }
}

