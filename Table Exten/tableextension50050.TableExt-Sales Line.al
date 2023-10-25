tableextension 50050 tableextension50050 extends "Sales Line"
{
    // //acxcp_300622_CampaignCode +
    // //acxcp_161122 - //Validation check for qty in decimal
    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //for blank BIN Code //acxcp_26062021
                IF Type = Type::Item THEN BEGIN
                    BIN := CheckLocaBIN("Location Code");
                    IF BIN = TRUE THEN
                        VALIDATE("Bin Code", "Sell-to Customer No.");
                END;
                //for blank BIN Code //acxcp_26062021

            end;
        }
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                //acxcp_151122 - //validation check on Qty onValidate
                IF Quantity <> 0 THEN BEGIN
                    IF recUserSetup.GET(USERID) THEN BEGIN
                        IF NOT recUserSetup.QtyCheck THEN BEGIN
                            TESTFIELD(Quantity, ROUND(Quantity, 1));
                        END;
                    END;
                END;
                //acxcp_151122 +

            end;

            trigger OnAfterValidate()
            begin
                //KM010721
                IF "Units per Parcel" <> 0 THEN
                    "No. of Loose Pack" := Quantity * "Units per Parcel";
                //KM010721

            end;
        }

        field(50000; "Excess/Short Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Scheme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ACX Schemes";
        }
        field(50003; "Free Scheme Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "No. of Loose Pack"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; ValidateMRPItemTracking; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //12887---> custom "MRP Price" field is added
        field(50006; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateUnitPrice(FIELDNO("No."));
            end;
        }
        //12887<---custom "MRP Price" field is added
    }



    local procedure CheckLocaBIN(Location: Code[10]) BIN: Boolean
    var
        recLocation: Record 14;
    begin
        recLocation.RESET();
        recLocation.SETRANGE(Code, Location);
        recLocation.SETFILTER("Bin Mandatory", '=%1', TRUE);
        IF recLocation.FINDFIRST THEN
            BIN := TRUE;
    end;

    var
        BIN: Boolean;
        SkipCreditCheck: Boolean;
        recSalesHeader: Record 36;
        recSIH: Record 36;
        recUserSetup: Record 91;
}

