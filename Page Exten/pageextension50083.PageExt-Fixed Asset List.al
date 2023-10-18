pageextension 50083 pageextension50083 extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
        {
            field("Serial No."; rec."Serial No.")
            {
            }
        }
        addafter("Search Description")
        {
            field("Creation DateTime"; rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
}

