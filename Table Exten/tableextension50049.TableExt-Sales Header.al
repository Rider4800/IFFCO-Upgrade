tableextension 50049 tableextension50049 extends "Sales Header"
{
    // //acxcp_210721 //capture creation date time
    // //Acxcp_270622 //Stop Prompt for Bill to
    // //acxcp_300622_CampaignCode +
    fields
    {
        modify("Salesperson Code")
        {
            TableRelation = "Salesperson/Purchaser" WHERE("Salesperson Type" = CONST(SalesPerson));
            trigger OnAfterValidate()
            begin
                UddateSalesHierarchy//Sales Hierarchy
            end;
        }
        modify("Campaign No.")
        {
            TableRelation = Campaign WHERE("Status Code" = FILTER(<> 'CLOSE'));
            trigger OnBeforeValidate()
            begin
                //acxcp_300622_CampaignCode +
                //acxcp_230921 //campaign super cash customization
                dcCustomerBalance := 0;
                recCust.GET("Sell-to Customer No.");
                recCust.CALCFIELDS("Balance (LCY)");
                dcCustomerBalance := recCust."Balance (LCY)";
                IF dcCustomerBalance >= 0 THEN
                    ERROR('Customer doent have Credit Balance');

                //----------Campaign Code delete check
                IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Campaign No." <> "Campaign No.")
                THEN BEGIN
                    SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SETRANGE("Document No.", "No.");
                    //SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
                    IF NOT SalesLine.ISEMPTY THEN
                        ERROR(Text1002, Rec."No.");
                    //ERROR(Text006,FIELDCAPTION("Sell-to Customer No."));
                    SalesLine.RESET;
                END;
                //acxcp
                CheckOneCredit("Sell-to Customer No.");
                //acxcp_300622_CampaignCode -
            end;

        }

        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate()
            begin
                CheckOneCredit("Sell-to Customer No.");//KM080721
            end;
        }

        modify("Your Reference")
        {
            trigger OnAfterValidate()
            begin
                //acxcp_300622_CampaignCode +
                //acxcp06052022+
                IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                    recSIH.RESET();
                    recSIH.SETRANGE("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    //recSIH.SETRANGE("No.",Rec."Your Reference");
                    IF recSIH.FINDFIRST THEN BEGIN
                        IF recSIH."No." = Rec."Your Reference" THEN BEGIN
                            IF recSIH."Campaign No." <> '' THEN
                                MESSAGE('The Sales Credit Memo is against SuperCash Scheme  -%1', recSIH."No.");
                            recSaleCommentLine.INIT;
                            recSaleCommentLine."Document Type" := Rec."Document Type"::"Credit Memo";
                            recSaleCommentLine."No." := Rec."No.";
                            recSaleCommentLine.Date := Rec."Posting Date";
                            recSaleCommentLine.Comment := 'The Sales Credit Memo is against SuperCash Scheme=' + recSIH."No.";
                            recSaleCommentLine.INSERT;
                            //  ERROR('The Sales Credit Memo is against SuperCash Scheme  -%1',recSIH."No.");
                        END;
                    END;
                END;

                CheckCampaignCode(Rec);
                //acxcp06052022-
                //acxcp_300622_CampaignCode -
            end;
        }

        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                UddateSalesHierarchy//Sales Hierarchy
            end;
        }
        field(50000; "Transporter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE(Transporter = FILTER(true));

            trigger OnValidate()
            begin
                Vend.RESET;
                Vend.SETRANGE("No.", "Transporter Code");
                IF Vend.FIND('-') THEN BEGIN
                    "Transporter Name" := Vend.Name;
                    "Transporter GSTIN" := Vend."GST Registration No.";
                END;
            end;
        }
        field(50001; "Transporter Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Transporter GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50003; "Finance Branch A/c Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('STATE'),
                                                          "Fin Branch Boolean" = FILTER(true));

            trigger OnValidate()
            begin
                TESTFIELD("Branch Accounting");//Acx_anubha
            end;
        }
        field(50004; "Branch Accounting"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50005; "Sell-to Customer Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50006; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";
        }
        field(50007; "Bill-to Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50008; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50009; "Apply Super Cash Scheme"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';

            trigger OnValidate()
            begin
                TESTFIELD("Sell-to Customer No.", '');
            end;
        }
        field(50112; "FO Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('FO'));
        }
        field(50113; "FA Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('FA'));
        }
        field(50114; "TME Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('TME'));
        }
        field(50115; "RME Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('RME'));
        }
        field(50116; "ZMM Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('ZMM'));
        }
        field(50117; "HOD Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('HOD'));
        }
        //12887----->
        field(50118; "Run Statistics"; Boolean)
        {
            Description = '12887 26th oct 23 added to run statistics page mandatory';
        }
        //<--12887
    }
    trigger OnBeforeInsert()
    begin
        EInvoiceMandatoryField;//KM
    end;

    trigger OnAfterInsert()
    begin
        //acxcp_210721 +
        "Creation DateTime" := CURRENTDATETIME;
        //acxcp_210721 -
    end;

    trigger OnBeforeModify()
    begin
        EInvoiceMandatoryField;//KM
    end;

    procedure UddateSalesHierarchy()
    var
        recSalesH: Record "Sales Header";
        recSalesHier: Record "Sales Hierarchy";
    begin
        //RESET();
        //SETRANGE("No.","No.");
        //IF FINDFIRST THEN BEGIN
        recSalesHier.RESET();
        recSalesHier.SETRANGE("FO Code", "Salesperson Code");
        recSalesHier.SETFILTER("End Date", '%1|>=%2', 0D, "Posting Date");
        recSalesHier.SETRANGE("Start Date", 0D, "Posting Date");
        IF recSalesHier.FINDFIRST THEN BEGIN
            "FO Code" := recSalesHier."FO Code";
            "FA Code" := recSalesHier."FA Code"; //acxcp_310821
            "TME Code" := recSalesHier."TME Code"; //acxcp_310821
                                                   // "ZMM Code" := recSalesHier."TME Code"; //acxcp_310821
            "RME Code" := recSalesHier."RME Code";
            "ZMM Code" := recSalesHier."ZMM Code";
            "HOD Code" := recSalesHier."HOD Code";
        END ELSE BEGIN
            "FO Code" := '';
            "TME Code" := '';
            "ZMM Code" := '';
            "RME Code" := '';
            "ZMM Code" := '';
            "HOD Code" := '';
        END;
        //END;
    end;

    procedure CheckCustCredit("CustNo.": Code[20]) SkipCreditCheck: Boolean
    var
        recCustomer: Record Customer;
    begin
        recCustomer.RESET();
        SkipCreditCheck := FALSE;
        recCustomer.SETRANGE("No.", "CustNo.");
        IF recCustomer.FINDFIRST THEN BEGIN
            IF recCustomer."Excludes Credit Limit Allow" = TRUE THEN BEGIN
                MESSAGE('Credit limit can not be check, due to excludes credit limit TRUE in customer card for this customer...');
                SkipCreditCheck := TRUE;
            END;
            IF recCustomer."One Time Credit Pass Allow" = TRUE THEN
                SkipCreditCheck := TRUE;
        END;
    end;

    local procedure CheckOneCredit("CustNo.": Code[20])
    var
        recSalesHeader: Record "Sales Header";
        "Count": Integer;
        recCustomer: Record Customer;
    begin
        /*
        recCustomer.RESET();
        Count:=0;
        recCustomer.SETRANGE("No.","CustNo.");
        recCustomer.SETRANGE("One Time Credit Pass Allow",TRUE);
        IF recCustomer.FINDFIRST THEN BEGIN
          recSalesHeader.RESET();
          recSalesHeader.SETRANGE("Sell-to Customer No.","CustNo.");
          recSalesHeader.SETFILTER("Document Type",'%1..%2', recSalesHeader."Document Type"::Order,
                                    recSalesHeader."Document Type"::Invoice);
          IF recSalesHeader.FINDFIRST THEN BEGIN
            REPEAT
              Count := Count+1;
              UNTIL recSalesHeader.NEXT=0;
            END;
          END;
        IF Count>0 THEN
          ERROR('One time credit pass allowed for this customer, kindly post the pending sales order before creating new sales order...');
        */
        //acxcp_300622_CampaignCode +
        recCustomer.RESET();
        Count := 0;
        recCustomer.SETRANGE("No.", "CustNo.");
        //recCustomer.SETRANGE("One Time Credit Pass Allow",TRUE);
        IF (recCustomer.FINDFIRST) AND ((recCustomer."One Time Credit Pass Allow" = TRUE) OR (Rec."Campaign No." <> '')) THEN BEGIN
            recSalesHeader.RESET();
            recSalesHeader.SETRANGE("Sell-to Customer No.", "CustNo.");
            recSalesHeader.SETFILTER("Document Type", '%1..%2', recSalesHeader."Document Type"::Order,
                                      recSalesHeader."Document Type"::Invoice);
            IF recSalesHeader.FINDFIRST THEN BEGIN
                REPEAT
                    Count := Count + 1;
                UNTIL recSalesHeader.NEXT = 0;
            END;
        END;
        IF (Count > 0) AND (recCustomer."One Time Credit Pass Allow" = TRUE) THEN
            ERROR(Text1000);
        IF (Count > 1) AND (Rec."Campaign No." <> '') THEN //KM_230921
            ERROR(Text1001);
        //acxcp_300622_CampaignCode -

    end;

    local procedure EInvoiceMandatoryField()
    begin
        IF (Rec."Document Type" = Rec."Document Type"::Order) AND (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN
            TESTFIELD("Sell-to Post Code");
            TESTFIELD("Sell-to City");
            IF "Ship-to Code" <> '' THEN BEGIN
                TESTFIELD("Ship-to Post Code");
                TESTFIELD("Ship-to City");
            END;
        END;
    end;

    procedure CheckCustBalance("CustNo.": Code[20]) decBalance: Decimal
    var
        recCustomer: Record Customer;
    begin
        recCustomer.RESET();
        decBalance := 0;
        recCustomer.SETRANGE("No.", "CustNo.");
        IF recCustomer.FINDFIRST THEN BEGIN
            recCustomer.CALCFIELDS("Balance (LCY)");
            decBalance := recCustomer."Balance (LCY)";
        END;
    end;

    local procedure CheckCampaignCode(var recSalesHeader: Record "Sales Header")
    var
        recSIH: Record "Sales Invoice Header";
    begin

        recSIH.RESET;
        recSIH.SETRANGE("Sell-to Customer No.", recSalesHeader."Sell-to Customer No.");
        recSIH.SETFILTER("No.", '=%1', recSalesHeader."Your Reference");
        IF recSIH.FINDFIRST THEN BEGIN
            IF recSalesHeader."Your Reference" = recSIH."No." THEN
                IF recSIH."Campaign No." <> '' THEN
                    ERROR('Already exists');
        END;
    end;

    var
        recCustomer: Record Customer;
        recCust: Record Customer;
        Vend: Record Vendor;
        SkipCreditCheck: Boolean;
        dcCustomerBalance: Decimal;
        decBalance: Decimal;
        recSIH: Record "Sales Invoice Header";
        CustNo: Code[20];
        recSaleCommentLine: Record "Sales Comment Line";
        TextMessage: Text;
        Text1000: Label 'Kindly Check Open Orders, if One Time Credit Check apply for this order.';
        Text1001: Label 'Kindly Check Open Orders, if Campaign to be apply for this order.';
        Text1002: Label 'Sales Line already exists for this document - %1, delete existing Sales Lines before change the Campaign Code.';
        RecShipto: Record "Ship-to Address";
}

