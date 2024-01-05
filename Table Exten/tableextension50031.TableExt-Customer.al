tableextension 50031 tableextension50031 extends Customer
{
    // ACXCP01 //For Full Name of Customer
    // acxcp02 //Creation Date and Time
    // acxcp03 //Created By User ID Capture
    fields
    {
        modify("Salesperson Code")
        {
            TableRelation = "Salesperson/Purchaser" WHERE("Salesperson Type" = CONST(SalesPerson));
        }
        field(50000; "Dealership Proposal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Dealership Proposal Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Firm Consititution Certificate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50003; "Firm Const. Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50004; "Signed Blank Cheque"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50005; "Signed Blank Cheq. Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50006; "Security Deposite"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50007; "Security Deposite Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50008; "Banker Varification Cert."; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50009; "Banker Varification Cert. Rem"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50010; "Last 3Yr B/Sheet"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50011; "Last 3Yr B/Sheet Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50012; "GST Cert."; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50013; "GST Cert. Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50014; "Firm PAN"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50015; "Firm PAN Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50016; "KYC Form"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50017; "KYC Form Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50018; "ITR Last 3Yr"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50019; "ITR Last 3Yr Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50020; "Business Policy Signed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50021; "Business Policy Signed Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50022; "Customer Class"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50023; "Blocked/Unblocked Reason"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';

            trigger OnValidate()
            begin
                //ACX-RK 150421 Begin
                tempLineNo := 0;
                IF xRec."Blocked/Unblocked Reason" <> '' THEN BEGIN
                    recCommentLine.INIT();
                    recCommentLineNo.RESET();
                    recCommentLineNo.SETRANGE("No.", Rec."No.");
                    //    recCommentLineNo.SETFILTER("Table Name",'Customer');
                    IF recCommentLineNo.FINDLAST THEN
                        tempLineNo := recCommentLineNo."Line No." + 10000
                    ELSE
                        tempLineNo := 10000;
                    recCommentLine.VALIDATE("Line No.", tempLineNo);
                    recCommentLine.VALIDATE("Table Name", recCommentLine."Table Name"::Customer);
                    recCommentLine.VALIDATE("No.", xRec."No.");
                    recCommentLine.VALIDATE(Comment, xRec."Blocked/Unblocked Reason");
                    recCommentLine.VALIDATE(EditRestrict, TRUE);//This is for make log uneditable
                    recCommentLine.VALIDATE(Date, WORKDATE);
                    recCommentLine.INSERT;
                END;
                //ACX-RK End
            end;
        }
        field(50025; "Req. Letter -Dealership"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50026; "Req. Lette -Dealership Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50027; "Finance Branch A/c Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'),
                                                          "Fin Branch Boolean" = FILTER(true));
        }
        field(50028; "Opening Filter"; Date)
        {
            Description = 'ACXBASE';
            FieldClass = FlowFilter;
        }
        field(50029; "Opening Balance (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Currency Code" = FIELD("Currency Filter"),
                                                                                 "Posting Date" = FIELD("Opening Filter"),
                                                                                 "Entry Type" = FILTER(<> Application)));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50030; "Closing Balance (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Currency Code" = FIELD("Currency Filter"),
                                                                                 "Entry Type" = FILTER(<> Application),
                                                                                 "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Description = 'ACXBASE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50032; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";
        }
        field(50033; "Excludes Credit Limit Allow"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Text001: TextConst ENU = 'User Setup do not exist for User %1';
            begin
                // cdUser := (USERID);
                // recUserSetup.RESET();
                // recUserSetup.SETRANGE("User ID", cdUser);
                // IF recUserSetup.FINDFIRST AND (recUserSetup."Excludes Credit Limit Allow" = FALSE) THEN
                //     ERROR('User have not permission to edit Excludes Credit Limit field...');
                // TESTFIELD("One Time Credit Pass Allow", FALSE);
                if not recUserSetup.Get(USERID) then
                    Error(Text001, USERID)
                else begin
                    if not recUserSetup."Excludes Credit Limit Allow" then
                        ERROR('User have not permission to edit Excludes Credit Limit field...');
                end;
            end;
        }
        field(50034; "One Time Credit Pass Allow"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Text002: TextConst ENU = 'User Setup do not exist for User %1';
            begin
                // cdUser := (USERID);
                // recUserSetup.RESET();
                // recUserSetup.SETRANGE("User ID", cdUser);
                // IF recUserSetup.FINDFIRST AND (recUserSetup."One Time Credit Pass Allow" = FALSE) THEN
                //     ERROR('User have not permission to edit One Time Credit Pass field...');
                // TESTFIELD("Excludes Credit Limit Allow", FALSE);
                if not recUserSetup.Get(USERID) then
                    Error(Text002, USERID)
                else begin
                    if not recUserSetup."One Time Credit Pass Allow" then
                        ERROR('User have not permission to edit One Time Credit Pass field...');
                end;
            end;
        }
        field(50035; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50036; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            Editable = false;
        }
        //->E-Bazaar Customization
        field(50037; "Parent Customer"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Team';
            TableRelation = Customer;
        }
        field(50038; "Preferred Campaign No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Campaign No.', ENN = 'Campaign No.';
            Description = 'Team 9509';
            TableRelation = Campaign."No." WHERE("Status Code" = FILTER(<> 'CLOSE'));
        }
        //<-E-Bazaar Customization
    }

    trigger OnInsert()
    begin
        //ACX-RK 11032021 Begin
        Rec.Blocked := Blocked::All;
        //ACXR-RK End

        //acxcp02 +
        "Creation DateTime" := CURRENTDATETIME;
        //acxcp02 -

        //acxcp03 +
        "Created By" := USERID;
        //acxcp03 -
    end;

    var
        recCommentLine: Record 97;
        recCommentLineNo: Record 97;
        tempLineNo: Integer;
        cdUser: Code[50];
        recUserSetup: Record 91;
}

