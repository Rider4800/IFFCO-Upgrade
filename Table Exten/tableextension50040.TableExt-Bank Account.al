tableextension 50040 tableextension50040 extends "Bank Account"
{
    // //ACXCP //Creation date and Time capture
    fields
    {
        field(50000; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'acxcp';
        }
    }
    trigger OnAfterInsert()
    begin
        //acxcp02 +
        "Creation DateTime" := CURRENTDATETIME;
        //acxcp02 -
    end;
}

