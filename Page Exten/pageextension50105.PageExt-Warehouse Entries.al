pageextension 50105 pageextension50105 extends "Warehouse Entries"
{
    layout
    {
        moveafter("Source Line No."; "Registering Date")
        addafter("Registering Date")
        {
            field("Reference Document"; Rec."Reference Document")
            {
            }
            field("Reference No."; Rec."Reference No.")
            {
            }
        }
        moveafter("Reference No."; "User ID")
    }
}

