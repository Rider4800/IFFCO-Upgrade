tableextension 50003 tableextension50003 extends "Sales Invoice Header"
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
        field(50090; "E-way Bill Part"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'RK 29Apr22';
            OptionCaption = ' ,Registered,UnRegistered';
            OptionMembers = " ",Registered,UnRegistered;
        }
        field(50100; "Reason for Cancel Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50101; "Reason Code for Cancel"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
            OptionCaption = ' ,Duplicate, Order Cancelled, Data Entry mistake, Others';
            OptionMembers = " ",Duplicate," Order Cancelled"," Data Entry mistake"," Others";
        }
        field(50102; "E-Way Bill Date"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50103; "E-Way Bill Valid Upto"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50104; "Vehicle Update Date"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50105; "Vehicle Valid Upto"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50106; "E-Way Bill Report URL"; Text[200])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50107; "Cancel E-Way Bill Date"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50108; "Old Vehicle No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50109; "Reason Code for Vehicle Update"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
            OptionCaption = ' ,Due to Break Down, Due to Transhipment, Others, First Time';
            OptionMembers = " ","Due to Break Down"," Due to Transhipment"," Others"," First Time";
        }
        field(50110; "Reason for Vehicle Update"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
        }
        field(50111; "E-Way Bill Status"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '//HT 11092019 (For E-Way Integration)';
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
        field(50118; "E-Mail Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)';
        }
        field(50119; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXVG';
            OptionCaption = 'Tax Invoice,Bill of Supply,Delivery Challan';
            OptionMembers = "Tax Invoice","Bill of Supply","Delivery Challan";
        }
    }


    trigger OnBeforeInsert()
    begin

        TESTFIELD("Ship-to City");
        //acxcp_210721 +
        "Creation DateTime" := CURRENTDATETIME;
        //acxcp_210721 -

    end;

    procedure EmailRecordsAcxiom(ShowRequestForm: Boolean)
    var
        TempDocumentSendingProfile: Record 60 temporary;
        ReportDistributionManagement: Codeunit 452;
    begin
        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)-

        TempDocumentSendingProfile.INIT;

        IF ShowRequestForm THEN
            TempDocumentSendingProfile."E-Mail" := TempDocumentSendingProfile."E-Mail"::"Yes (Prompt for Settings)"
        ELSE
            TempDocumentSendingProfile."E-Mail" := TempDocumentSendingProfile."E-Mail"::"Yes (Use Default Settings)";

        TempDocumentSendingProfile."E-Mail Attachment" := TempDocumentSendingProfile."E-Mail Attachment"::PDF;

        TempDocumentSendingProfile.INSERT;

        //ReportDistributionManagement.SendDocumentReportAcxiom(TempDocumentSendingProfile, Rec);

        //HT 20092022 (CR-IFFCO-MC-0034 Email-Tax Invoice with Validation : Ticket id-IFFCOMC-0172)+
    end;

    var
        Vend: Record Vendor;
}

