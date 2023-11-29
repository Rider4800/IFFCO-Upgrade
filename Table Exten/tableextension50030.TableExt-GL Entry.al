tableextension 50030 tableextension50030 extends "G/L Entry"
{
    fields
    {
        field(50000; "Source Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50001; "Branch JV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50002; "Finance Branch A/c Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50005; "Provisional Entries"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP30122021';
        }
        //->Team-17783
        field(50006; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'TEAM17783';
        }
        //<-Team-17783
        //->Team-17783  New field added to save the previous data of External Doc No (Length 50) in this field
        field(50007; "External Document No. New"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Document No. New';
        }
        //<-Team-17783
    }
}

