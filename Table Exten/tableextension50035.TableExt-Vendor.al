tableextension 50035 tableextension50035 extends Vendor
{
    // //ACXCP02 //Creation Date and Time Capture
    // //ACXCP03 //Created By UserID Capture
    fields
    {
        field(50000; Port; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//HT 24082020 (For E-Way Bill and E-Invoice Integration)';
        }
        field(50001; "Finance Branch A/c Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'),
                                                          "Fin Branch Boolean" = FILTER(true));
        }
        field(50002; "Opening Balance (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Entry Type" = FILTER(<> Application),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Closing Balance (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Entry Type" = FILTER(<> Application),
                                                                                  "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Opening Filter"; Date)
        {
            Description = 'ACXBASE';
            FieldClass = FlowFilter;
        }
        field(50005; "MSME Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_28062021';
        }
        field(50006; "MSME Registration No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_28062021';
        }
        field(50007; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50008; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
    }

    trigger OnInsert()
    begin
        //ACXCP02+
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP02-

        //ACXCP03+
        "Created By" := USERID;
        //ACXCP03-
    end;
}

