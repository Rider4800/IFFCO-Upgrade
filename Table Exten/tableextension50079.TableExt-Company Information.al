tableextension 50079 tableextension50079 extends "Company Information"
{
    // ACXCP_310521 // lenght increase due to Registration No. need 21 char.
    fields
    {
        field(50000; "Registration Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 20052021';
        }
        field(50001; "Registration Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Registration City"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
        field(50003; "Registration Post code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".Code
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".Code WHERE("Country/Region Code" = FIELD("Country/Region Code"));

            trigger OnValidate()
            begin
                recPostCode.SETRANGE(Code, "Registration Post code");
                IF recPostCode.FIND('-') THEN
                    "Registration City" := recPostCode.City;
            end;
        }
        field(50004; "Registration State"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State.Code;
        }
        field(50005; "Registration GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
            TableRelation = "GST Registration Nos." WHERE("State Code" = FIELD("Registration State"));

            trigger OnValidate()
            begin
                TESTFIELD("Registration State");
                IF "Registration GSTIN" <> '' THEN BEGIN
                    recState.GET("Registration State");
                    IF recState."State Code (GST Reg. No.)" <> COPYSTR("Registration GSTIN", 1, 2) THEN
                        ERROR('State Code of GST Registration No. is invalid, please enter ' + recState."State Code (GST Reg. No.)" + ' as fisrt two latter');
                END;
            end;
        }
        field(50006; "Registration P.A.N."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Registration Email"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Registration Phone No."; Code[13])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        recPostCode: Record 225;
        recState: Record State;
}

