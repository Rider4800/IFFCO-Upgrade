tableextension 50087 tableextension50087 extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Bank Integration File Path"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX_CP_BankIntegration';
        }
        field(50001; "Bank Integration File LastNo"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX_CP_BankIntegration';
        }
        field(50002; "Report Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'LK';
        }
        field(50003; "Report Count"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Lk';
        }
        field(50004; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX_LK';
        }
        field(50005; "E-Mail CC"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)';
        }
    }
}

