tableextension 50001 tableextension50001 extends "Sales Shipment Header"
{
    // //acxcp_210721 //capture creation date time
    fields
    {
        field(50000; "Transporter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE(Transporter = FILTER(true));
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
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('FIN LOC'));
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
    }


    trigger OnAfterInsert()
    begin

        //acxcp_210721 +
        "Creation DateTime" := CURRENTDATETIME;
        //acxcp_210721 -

    end;
}

