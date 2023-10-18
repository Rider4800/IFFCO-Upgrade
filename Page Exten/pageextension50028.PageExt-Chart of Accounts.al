pageextension 50028 pageextension50028 extends "Chart of Accounts"
{
    layout
    {
        //Unsupported feature: Property Modification (SourceExpr) on "Control 10".
        //->Team-17783
        addafter("Direct Posting")
        {
            field(Indentation; Rec.Indentation)
            {
                trigger OnLookup(var Text: Text): Boolean
                var
                    GLaccList: Page "G/L Account List";
                begin
                    GLaccList.LookupMode(true);
                    if not (GLaccList.RunModal() = ACTION::LookupOK) then
                        exit(false);

                    Text := GLaccList.GetSelectionFilter();
                    exit(true);
                end;
            }
        }
        //<-Team-17783
        addafter("No.")
        {
            field("No2"; Rec."No. 2")
            {
                Caption = 'No. 2';
            }
        }
        addafter("Account Type")
        {
            field(Totalling; Rec.Totaling)
            {
                Caption = 'Totaling';
            }
        }
    }
}

