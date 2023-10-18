pageextension 50082 pageextension50082 extends "Fixed Asset Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; rec."Description 2")
            {
            }
        }
        addafter("Add. Depr. Applicable")
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
}

