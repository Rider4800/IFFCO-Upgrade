tableextension 50041 tableextension50041 extends "Bank Account Ledger Entry"
{
    fields
    {
        //->Team-17783  New field added to save the previous data of External Doc No (Length 50) in this field
        field(50007; "External Document No. New"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Document No. New';
        }
        //<-Team-17783
    }
}

