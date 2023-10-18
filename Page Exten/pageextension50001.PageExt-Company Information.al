pageextension 50001 pageextension50001 extends "Company Information"
{
    layout
    {
        addafter("User Experience")
        {
            group("Company Registered Adress")
            {
                field("Registration Address"; Rec."Registration Address")
                {
                    Caption = 'Registeration Address';
                }
                field("Registration Address 2"; Rec."Registration Address 2")
                {
                }
                field("Registration City"; Rec."Registration City")
                {
                }
                field("Registration Post code"; Rec."Registration Post code")
                {
                }
                field("Registration State"; Rec."Registration State")
                {
                }
                field("Registration GSTIN"; Rec."Registration GSTIN")
                {
                }
                field("Registration P.A.N."; Rec."Registration P.A.N.")
                {
                }
                field("Registration Email"; Rec."Registration Email")
                {
                }
                field("Registration Phone No."; Rec."Registration Phone No.")
                {
                }
            }
        }
    }
    var
        c: Codeunit 12;
}

