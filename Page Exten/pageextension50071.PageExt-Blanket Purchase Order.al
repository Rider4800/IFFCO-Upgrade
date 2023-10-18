pageextension 50071 pageextension50071 extends "Blanket Purchase Order"
{
    layout
    {
        addafter("Document Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
            }
        }
    }
}

