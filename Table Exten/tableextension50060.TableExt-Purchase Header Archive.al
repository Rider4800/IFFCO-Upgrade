tableextension 50060 tableextension50060 extends "Purchase Header Archive"
{
    // //ACXCP_210721 //capture creation date time
    fields
    {
        field(50000; "Certificate of Analysis"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK 140421';
        }
        field(50003; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            Editable = false;
        }
    }

    trigger OnBeforeInsert()
    begin
        //ACXCP_210721+
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP_210721-
    end;

}

