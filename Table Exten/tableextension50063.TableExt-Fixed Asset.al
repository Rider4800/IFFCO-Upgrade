tableextension 50063 tableextension50063 extends "Fixed Asset"
{
    // //acxcp02 //creation date and time capture
    fields
    {
        field(50000; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'acxcp';
        }
    }

    trigger OnBeforeInsert()
    begin
        "Creation DateTime" := CURRENTDATETIME;
    end;
}

