tableextension 50034 tableextension50034 extends "Order Address"
{
    // //acxcp //creation date and time Capture
    fields
    {
        field(50000; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'acxcp';
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Vend.GET("Vendor No.");
    Name := Vend.Name;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    Vend.GET("Vendor No.");
    Name := Vend.Name;

    //acxcp02 +
    "Creation DateTime":=CURRENTDATETIME;
    //acxcp02 -
    */
    //end;
}

