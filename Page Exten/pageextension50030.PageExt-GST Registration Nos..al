pageextension 50030 pageextension50030 extends "GST Registration Nos."
{
    layout
    {
        addafter("Input Service Distributor")
        {
            field(Username; Rec.Username)
            {
            }
            field(Password; Rec.Password)
            {
            }
            field("Client ID"; Rec."Client ID")
            {
            }
            field("Client Secret"; Rec."Client Secret")
            {
            }
            field("Grant Type"; Rec."Grant Type")
            {
            }
        }
    }
}

