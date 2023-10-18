tableextension 50064 tableextension50064 extends "Responsibility Center"
{
    fields
    {
        field(50000; "Reg. Company Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50001; "Reg. Address1"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50002; "Reg. Address2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50003; "Reg. City"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50004; "Reg. Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50005; "Reg. Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            TableRelation = "Country/Region";
        }
        field(50006; "Reg. Phone"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50007; "Reg. Lic. No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50008; "Reg. CIN No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50009; "Reg. GST/UIN No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50010; "Reg. State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            TableRelation = State;
        }
        field(50011; "Reg. P.A.N. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';

            trigger OnValidate()
            begin
                IF ("Reg. GST/UIN No." <> '') AND ("Reg. P.A.N. No." <> COPYSTR("Reg. GST/UIN No.", 3, 10)) THEN
                    ERROR(SamPANerr);
            end;
        }
    }

    var
        SamPANerr: Label 'From postion 3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.';
}

