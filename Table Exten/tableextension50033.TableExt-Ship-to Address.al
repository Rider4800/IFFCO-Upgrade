tableextension 50033 tableextension50033 extends "Ship-to Address"
{
    // //acxcp02 //current date and time capture
    fields
    {
        field(50000; "Customer Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'acxcp';
        }
        field(50003; Disable; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXVG';
        }
        field(50004; "MAssist Code"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
    }


    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Cust.GET("Customer No.");
    Name := Cust.Name;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    Cust.GET("Customer No.");
    Name := Cust.Name;
    //acxcp02 +
    "Creation DateTime":=CURRENTDATETIME;
    //acxcp02 -
    */
    //end;
}

