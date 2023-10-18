tableextension 50022 tableextension50022 extends Location
{
    // //ACXCP02 //Creation Date and Time Capture
    fields
    {
        field(50000; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'KM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50001; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'KM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50002; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Description = 'KM';
            TableRelation = "Responsibility Center";
        }
        field(50003; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50004; ShipToAddress; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
        }
        field(50005; "Ship-To Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
        }
        field(50006; "Ship-To Name2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
        }
        field(50007; "Ship-To Address"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
        }
        field(50008; "Ship-To Address2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
        }
        field(50009; "Ship-To City"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCodeRec: Record "Post Code";
            begin
                PostCodeRec.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50010; "Ship-To PostCode"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCodeRec: Record "Post Code";
            begin
                PostcodeRec.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50011; "Ship-To StateCode"; Code[10])
        {
            Caption = 'State Code';
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
            TableRelation = State;

            trigger OnValidate()
            begin
                //TESTFIELD("GST Registration No.",'');
            end;
        }
        field(50012; "Ship-To Country/RegionCode"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            Description = 'ACXCP_16052022';
            TableRelation = "Country/Region";
        }
    }

    trigger OnAfterInsert()
    begin
        //ACXCP02 +
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP02 -
    end;
}

