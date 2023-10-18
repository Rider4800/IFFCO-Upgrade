tableextension 50011 tableextension50011 extends "Purch. Cr. Memo Hdr."
{
    // //ACXCP_210721 //capture creation date time
    fields
    {
        field(50000; "Certificate of Analysis"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK 140421';
        }
        field(50001; "Finance Branch A/c Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50003; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            Editable = false;
        }
    }

    trigger OnAfterInsert()
    begin
        //ACXCP_210721+
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP_210721-
    end;
}

