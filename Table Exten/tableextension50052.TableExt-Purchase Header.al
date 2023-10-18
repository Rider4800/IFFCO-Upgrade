tableextension 50052 tableextension50052 extends "Purchase Header"
{
    // //ACXCP_210721 //capture creation date time
    fields
    {
        /*12887----> event not found for this
                //Unsupported feature: Code Modification on ""Invoice Type"(Field 16611).OnValidate".

                //trigger OnValidate()
                //Parameters and return type have not been exported.
                //>>>> ORIGINAL CODE:
                //begin
                /*
                IF "Invoice Type" = "Invoice Type"::"Non-GST" THEN
                  IF GSTManagement.IsGSTApplicable(Structure) THEN
                    ERROR(NonGSTInvTypeErr);
                IF "Invoice Type" = "Invoice Type"::"Self Invoice" THEN
                  IF NOT ("GST Vendor Type" = "GST Vendor Type"::Unregistered) AND NOT CheckReverseChargeGSTRegistered THEN
                    ERROR(SelfInvoiceTypeErr);
                CheckReverseChargeGSTRegistered;
                  InitRecordGST;
                IF "Invoice Type" = "Invoice Type"::Supplementary THEN
                  SetSupplementaryInLine("Document Type","No.",TRUE)
                ELSE
                  SetSupplementaryInLine("Document Type","No.",FALSE);

                IF "Reference Invoice No." <> '' THEN
                  IF NOT ("Invoice Type" IN ["Invoice Type"::"Debit Note","Invoice Type"::Supplementary]) THEN
                    ERROR(ReferenceNoErr);
                */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..6
        //CheckReverseChargeGSTRegistered;//acxcp_10122021 //base code bypass Invoice Type validation
          //InitRecordGST;//acxcp_10122021 //base code bypass Invoice Type validation

        //acxcp_10122021 begin //code added
        IF NOT ("Invoice Type"="Invoice Type"::"Debit Note") THEN BEGIN
            CheckReverseChargeGSTRegistered;
            InitRecordGST;
        END;
        //acxcp_10122021 end

        #9..16
        <-----12887 event not found for this*/
        //end;

        field(50000; "Certificate of Analysis"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK 140421';
        }
        field(50001; "Finance Branch A/c Code"; Code[20])
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
        field(50002; "Branch Accounting"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//Acx_Anubha';
        }
        field(50003; "Creation DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            Editable = false;
        }
    }


    trigger OnAfterInsert()
    begin
        //ACXCP_210721+
        "Creation DateTime" := CURRENTDATETIME;
        //ACXCP_210721-

    end;
}

