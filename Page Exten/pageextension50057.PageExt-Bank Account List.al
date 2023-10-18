pageextension 50057 pageextension50057 extends "Bank Account List"
{
    layout
    {
        addafter("Fax No.")
        {
            field(Balance; Rec.Balance)
            {
            }
        }
        addafter("Search Name")
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
}

