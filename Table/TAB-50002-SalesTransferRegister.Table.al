table 50002 "Sales/Transfer Register"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Sales Invoice,Sales Cr. Memo,Transfer Shpt.,Transfer Rcpt.,Purchase Invoice,Purchase Cr. Memo';
            OptionMembers = " ","Sales Invoice","Sales Cr. Memo","Transfer Shpt.","Transfer Rcpt.","Purchase Invoice","Purchase Cr. Memo";
        }
        field(2; "Gen. Journal Template Code"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(3; "Source Document No."; Code[20])
        {
        }
        field(4; "Source Line No."; Integer)
        {
        }
        field(5; "Posting Date"; Date)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(7; "Source Line Description"; Text[50])
        {
        }
        field(8; "Document Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(9; "Document Salesperson Name"; Text[50])
        {
        }
        field(10; "Payment Term Code"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(11; "Freight Payment Type"; Option)
        {
            OptionCaption = ' ,To Pay,Paid,Debit Note/Credit Note/Paid';
            OptionMembers = " ","To Pay",Paid,"Debit Note/Credit Note/Paid";
        }
        field(12; "Shipping Bill No."; Code[20])
        {
        }
        field(13; "B/L No."; Code[20])
        {
        }
        field(14; "B/L Date"; Date)
        {
        }
        field(15; "Transporter Code"; Code[20])
        {
            TableRelation = Vendor."No." WHERE("Vendor Posting Group" = FILTER('TPT'));
        }
        field(16; "Destination Port"; Code[10])
        {
            TableRelation = "Entry/Exit Point";
        }
        field(17; "Challan No."; Code[10])
        {
        }
        field(18; "Supplier's Ref."; Code[10])
        {
        }
        field(19; "Due date"; Date)
        {
        }
        field(21; "Source Type"; Option)
        {
            OptionCaption = ' ,Customer,Vendor,Location';
            OptionMembers = " ",Customer,Vendor,Location;
        }
        field(22; "Source No."; Code[20])
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Source Type" = CONST(Location)) Location.Code;
        }
        field(23; "Source City"; Text[30])
        {
            TableRelation = "Post Code".City;
        }
        field(24; "Source State Code"; Code[10])
        {
            TableRelation = State;
        }
        field(25; "Source Name"; Text[50])
        {
            Editable = false;
        }
        field(26; "Source State Name"; Text[30])
        {
        }
        field(27; "Customer Posting Group"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(28; "CPG Desc"; Text[50])
        {
        }
        field(29; "Customer Price Group"; Code[10])
        {
            TableRelation = "Customer Price Group";
        }
        field(30; "Customer Price Group Name"; Text[50])
        {
        }
        field(31; "Gen. Bus. Posting Group"; Code[10])
        {
        }
        field(32; "GBPG Description"; Text[50])
        {
        }
        field(33; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(34; "Country/Region Name"; Text[50])
        {
        }
        field(35; "Master Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(36; "Master Salesperson Name"; Text[50])
        {
        }
        field(37; "Territory Dimension Code"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('TERR'),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(38; "Territory Dimension Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = CONST('TERR'),
                                                               Code = FIELD("Territory Dimension Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Outward Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(42; "Outward State Code"; Code[10])
        {
            TableRelation = State;
        }
        field(43; "Outward State Name"; Text[30])
        {
        }
        field(44; "Location Type"; Option)
        {
            OptionCaption = ' ,Factory,Branch Office,CSA,C&F,HO,Job Worker';
            OptionMembers = " ",Factory,"Branch Office",CSA,"C&F",HO,"Job Worker";
        }
        field(61; "Fin. Year"; Code[7])
        {
        }
        field(62; Quarter; Code[2])
        {
        }
        field(63; "Month Name"; Code[3])
        {
        }
        field(64; Day; Integer)
        {
        }
        field(65; Month; Integer)
        {
        }
        field(66; Year; Integer)
        {
        }
        field(91; "No."; Code[20])
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(92; "Variant Code"; Code[10])
        {
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(93; "Item Description"; Text[50])
        {
            Editable = false;
        }
        field(94; "Variant Description"; Text[50])
        {
        }
        field(95; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(96; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(97; "Excise Prod. Posting Group"; Code[10])
        {
            //12887 Table is removed TableRelation = "Excise Prod. Posting Group";
        }
        field(98; "Item Print Name"; Text[100])
        {
        }
        field(99; "Item License No."; Text[100])
        {
        }
        field(100; "CIB Registration No."; Text[100])
        {
        }
        field(101; "Packing Type"; Code[20])
        {
        }
        field(102; "Packing Size"; Code[20])
        {
        }
        field(103; "Technical Name"; Text[100])
        {
        }
        field(104; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(105; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(106; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(107; "Unit of Measure"; Code[10])
        {
        }
        field(108; "Item Type"; Option)
        {
            OptionCaption = ' ,FG,WIP,PM,RM,OTHERS';
            OptionMembers = " ",FG,WIP,PM,RM,OTHERS;
        }
        field(109; "GPPG Description"; Text[50])
        {
        }
        field(121; Quantity; Decimal)
        {
        }
        field(122; "Unit Price"; Decimal)
        {
        }
        field(123; Amount; Decimal)
        {
        }
        field(124; "Line Discount Amount"; Decimal)
        {
        }
        field(125; "Line Amount"; Decimal)
        {
        }
        field(126; "Excise Amount"; Decimal)
        {
        }
        field(127; "BED Amount"; Decimal)
        {
        }
        field(128; "ECess Amount"; Decimal)
        {
        }
        field(129; "SHECess Amount"; Decimal)
        {
        }
        field(130; "SAED Amount"; Decimal)
        {
        }
        field(131; "BED %"; Decimal)
        {
        }
        field(132; "ECess %"; Decimal)
        {
        }
        field(133; "SHECess %"; Decimal)
        {
        }
        field(134; "SAED %"; Decimal)
        {
        }
        field(135; "Excise Base Amount"; Decimal)
        {
        }
        field(136; "Assessable Value"; Decimal)
        {
        }
        field(137; "MRP Price"; Decimal)
        {
        }
        field(138; "Abatement %"; Decimal)
        {
        }
        field(139; "Service Tax Base Amount"; Decimal)
        {
        }
        field(140; "Service Tax Amount"; Decimal)
        {
        }
        field(141; "Service Tax eCess Amount"; Decimal)
        {
        }
        field(142; "Service Tax SHECess Amount"; Decimal)
        {
        }
        field(143; "Service Tax %"; Decimal)
        {
        }
        field(144; "Service Tax eCess %"; Decimal)
        {
        }
        field(145; "Service Tax SHECess %"; Decimal)
        {
        }
        field(146; "Service Tax Group"; Code[20])
        {
            //12887 Table is removed  TableRelation = "Service Tax Groups".Code;
        }
        field(147; "Service Tax Registration No."; Code[20])
        {
            //12887 Table is removed TableRelation = "Service Tax Registration Nos.".Code;
        }
        field(148; "TDS Base Amount"; Decimal)
        {
        }
        field(149; "TDS Amount"; Decimal)
        {
        }
        field(150; "eCESS on TDS Amount"; Decimal)
        {
        }
        field(151; "SHE Cess on TDS Amount"; Decimal)
        {
        }
        field(152; "TDS %"; Decimal)
        {
        }
        field(153; "eCESS % on TDS"; Decimal)
        {
        }
        field(154; "SHE Cess % On TDS"; Decimal)
        {
        }
        field(155; "TDS Nature of Deduction"; Code[10])
        {
            //12887 Table is removed TableRelation = "TDS Nature of Deduction";
        }
        field(156; "Tax Base Amount"; Decimal)
        {
        }
        field(157; "CST Amount"; Decimal)
        {
        }
        field(158; "VAT Amount"; Decimal)
        {
        }
        field(159; "Addn. Tax Amount"; Decimal)
        {
        }
        field(160; "Tax Area"; Code[10])
        {
            TableRelation = "Tax Area";
        }
        field(161; "Tax Jurisdiction Code"; Code[10])
        {
            TableRelation = "Tax Jurisdiction";
        }
        field(162; "Tax Type"; Option)
        {
            OptionCaption = ' ,VAT,CST';
            OptionMembers = " ",VAT,CST;
        }
        field(163; "Tax %"; Decimal)
        {
        }
        field(164; "Addn. Tax %"; Decimal)
        {
        }
        field(165; "Form Code"; Code[10])
        {
            //12887 Table is removed TableRelation = "Form Codes";
        }
        field(166; "Form No."; Code[20])
        {
        }
        field(167; "Line Discount %"; Decimal)
        {
        }
        field(168; "Applies-to Doc. Type"; Option)
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(169; "Applies-to Doc. No."; Code[20])
        {

        }
        field(170; "Round Off Amount"; Decimal)
        {
        }
        field(171; "Net Amount"; Decimal)
        {
        }
        field(172; "Tax Amount"; Decimal)
        {
        }
        field(201; "Item Category Code"; Code[10])
        {
            TableRelation = "Item Category".Code;
        }
        field(202; "Item Category Description"; Text[50])
        {
        }
        field(203; "Product Group Code"; Code[10])
        {
            TableRelation = "Item Category".Code WHERE("Parent Category" = field("Item Category Code"));//12887 alternative of product group
            //12887 Table is removed TableRelation = "Product Group".Code WHERE(Item Category Code=FIELD(Item Category Code));
        }
        field(204; "Product Group Description"; Text[50])
        {
        }
        field(205; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(206; "Global Dimension 1 Code"; Code[15])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(207; "Global Dimension 2 Code"; Code[15])
        {
            TableRelation = Dimension;
        }
        field(208; "T.I.N. No."; Code[11])
        {
        }
        field(209; "Trade Discount"; Decimal)
        {
        }
        field(210; "Cash Discount"; Decimal)
        {
        }
        field(211; "Scheme Discount"; Decimal)
        {
        }
        field(212; "OffSeason Discount"; Decimal)
        {
        }
        field(213; Freight; Decimal)
        {
        }
        field(251; "Revenue Account Code"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(252; "Revenue Account Description"; Text[50])
        {
        }
        field(253; "Receivable Account Code"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(254; "Receivable Account Description"; Text[50])
        {
        }
        field(255; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(256; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(257; "Currency Factor"; Decimal)
        {
        }
        field(258; "Actual Tax %"; Decimal)
        {
        }
        field(259; "Order No."; Code[20])
        {
        }
        field(260; "LR/RR No."; Code[20])
        {
            Caption = 'LR/RR No.';
        }
        field(261; "LR/RR Date"; Date)
        {
            Caption = 'LR/RR Date';
        }
        field(262; Insurance; Decimal)
        {
        }
        field(263; "Master Cust. Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(264; "GST Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(265; "HSN/SAC Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(266; "GST Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(267; "CGST %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(268; "SGST %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(269; "IGST %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(270; "Cess %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(271; "Addl. Cess Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(272; "CGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(273; "SGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(274; "IGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(275; "Cess Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(276; "Addl. Cess Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(277; "Total GST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(278; "GST Place of Supply"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(279; "Location Reg. No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(280; "Customer Reg. No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'FAR';
        }
        field(281; "Ship To Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(282; "Ship To Customer Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(283; "TCS Nature of Collection"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(284; "TCS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(285; "Reason Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
            TableRelation = "Reason Code";
        }
        field(286; "Source Line Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP_03012022';
        }
        field(287; "Campaign No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Acxcp_CampaignCode';
        }
        field(50000; "TR Source Document No."; Code[20])
        {
            CalcFormula = Lookup("Purchase/Transfer Register"."Source Document No." WHERE("Source Line No." = FIELD("Source Line No."),
                                                                                           "Order No." = FIELD("Order No.")));
            FieldClass = FlowField;
        }
        field(50001; "TR Receipt Date"; Date)
        {
            CalcFormula = Lookup("Purchase/Transfer Register"."Posting Date" WHERE("Order No." = FIELD("Order No."),
                                                                                    "Source Line No." = FIELD("Source Line No.")));
            FieldClass = FlowField;
        }
        field(50002; "TR T.I.N. No."; Code[11])
        {
            CalcFormula = Lookup("Purchase/Transfer Register"."T.I.N. No." WHERE("Order No." = FIELD("Order No."),
                                                                                  "Source Line No." = FIELD("Source Line No.")));
            FieldClass = FlowField;
        }
        field(50003; "TR Quantity"; Decimal)
        {
            CalcFormula = Lookup("Purchase/Transfer Register".Quantity WHERE("Order No." = FIELD("Order No."),
                                                                              "Source Line No." = FIELD("Source Line No.")));
            FieldClass = FlowField;
        }
        field(50004; "TR Net Amount"; Decimal)
        {
            CalcFormula = Lookup("Purchase/Transfer Register"."Net Amount" WHERE("Order No." = FIELD("Order No."),
                                                                                  "Source Line No." = FIELD("Source Line No.")));
            FieldClass = FlowField;
        }
        field(50005; "External Document No."; Code[50])
        {
        }
        field(50008; "Special Sch. Disc"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXFAR';
        }
        field(50009; "Bulk Disc"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXFAR';
        }
        field(50010; "Truck Load Disc"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "FOC Disc"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "FO Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('FO'));
        }
        field(50013; "FO Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "FA Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('FA'));
        }
        field(50015; "FA Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50016; "TME Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('TME'));
        }
        field(50017; "TME Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50018; "RME Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('RME'));
        }
        field(50019; "RME Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50020; "ZMM Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('ZMM'));
        }
        field(50021; "ZMM Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50022; "HOD Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code WHERE("Designation Code" = CONST('HOD'));
        }
        field(50023; "HOD Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50024; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(50025; "Lot No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50026; "MFG Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50027; "Expiration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Source Document No.", "Source Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

