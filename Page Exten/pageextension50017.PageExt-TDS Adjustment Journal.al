pageextension 50017 pageextension50017 extends "TDS Adjustment Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("Location Code"; Rec."Location Code")
            {
            }
        }
        //->Team-17783
        modify("Transaction No")
        {
            trigger OnAfterValidate()
            var
                TDSEntry: Record "TDS Entry";
            begin
                if TDSEntry.Get(Rec."TDS Transaction No.") then begin
                    Rec."Invoice Amount" := TDSEntry."Invoice Amount";
                    Rec.Modify();
                end;
            end;

            trigger OnAfterAfterLookup(Selected: RecordRef)
            var
                TDSEntry: Record "TDS Entry";
            begin
                if TDSEntry.Get(Rec."TDS Transaction No.") then begin
                    Rec."Invoice Amount" := TDSEntry."Invoice Amount";
                    Rec.Modify();
                end;
            end;
        }
        //<-Team-17783
    }
}

