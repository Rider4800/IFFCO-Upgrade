table 50000 "E-Way Bill & E-Invoice"
{
    Permissions = TableData 112 = rm,
                  TableData 114 = rm;

    fields
    {
        field(1; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Customer;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(6; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name';
            DataClassification = ToBeClassified;
        }
        field(7; "Sell-to Address"; Text[50])
        {
            Caption = 'Sell-to Address';
            DataClassification = ToBeClassified;
        }
        field(8; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
            DataClassification = ToBeClassified;
        }
        field(9; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11; State; Code[10])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(12; "LR/RR No."; Code[20])
        {
            Caption = 'LR/RR No.';
            DataClassification = ToBeClassified;
        }
        field(13; "LR/RR Date"; Date)
        {
            Caption = 'LR/RR Date';
            DataClassification = ToBeClassified;
        }
        field(14; "Vehicle No."; Code[100])
        {
            Caption = 'Vehicle No.';
            DataClassification = ToBeClassified;
        }
        field(15; "Mode of Transport"; Text[15])
        {
            Caption = 'Mode of Transport';
            DataClassification = ToBeClassified;
        }
        field(16; "Location State Code"; Code[10])
        {
            Caption = 'Location State Code';
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = State;
        }
        field(17; "Amount to Customer"; Decimal)
        {
            AutoFormatType = 1;
            //12887 field is removed CalcFormula = Sum("Sales Invoice Line"."Amount To Customer" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount to Customer';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(18; "Vehicle Type"; Option)
        {
            Caption = 'Vehicle Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,regular,over dimensional cargo';
            OptionMembers = " ",regular,"over dimensional cargo";
        }
        field(19; "Location GST Reg. No."; Code[15])
        {
            Caption = 'Location GST Reg. No.';
            DataClassification = ToBeClassified;
            TableRelation = "GST Registration Nos.";
        }
        field(20; "Customer GST Reg. No."; Code[15])
        {
            Caption = 'Customer GST Reg. No.';
            DataClassification = ToBeClassified;
        }
        field(21; "Distance (Km)"; Text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Transporter Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(23; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(24; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(26; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(29; "E-Way Bill Date"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "E-Way Bill Valid Upto"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Vehicle Update Date"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Vehicle Valid Upto"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Cancel E-Way Bill Date"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "E-Way Bill Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "E-Way Bill No."; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                recSalesInvHdr: Record 112;
                recSalesCrMemoHdr: Record 114;
                recTransferShipHdr: Record 5744;
                recPurchCrMemoHdr: Record 124;
            begin
                //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                IF "Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHdr.RESET();
                    recSalesInvHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHdr.FIND('-') THEN BEGIN
                        recSalesInvHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                        recSalesInvHdr.MODIFY;
                    END;
                END
                ELSE
                    IF "Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                        recSalesCrMemoHdr.RESET();
                        recSalesCrMemoHdr.SETRANGE("No.", Rec."No.");
                        IF recSalesCrMemoHdr.FIND('-') THEN BEGIN
                            recSalesCrMemoHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                            recSalesCrMemoHdr.MODIFY;
                        END;
                        /*
                        END
                          ELSE
                            IF "Transaction Type" = 'Transfer Shipment' THEN BEGIN
                              recTransferShipHdr.RESET();
                              recTransferShipHdr.SETRANGE("No.",Rec."No.");
                                IF recTransferShipHdr.FIND('-') THEN BEGIN
                                  recTransferShipHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                                  recTransferShipHdr.MODIFY;
                                END;
                          */
                    END
                    ELSE
                        IF "Transaction Type" = 'Purchase Credit Memo' THEN BEGIN
                            recPurchCrMemoHdr.RESET();
                            recPurchCrMemoHdr.SETRANGE("No.", Rec."No.");
                            IF recPurchCrMemoHdr.FIND('-') THEN BEGIN
                                recPurchCrMemoHdr."E-Way Bill No." := Rec."E-Way Bill No.";
                                recPurchCrMemoHdr.MODIFY;
                            END;
                        END;
                //HT 24082020 (For E-Way Bill and E-Invoice Integration)+

            end;
        }
        field(36; "Old Vehicle No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Reason Code for Cancel"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Duplicate, Order Cancelled, Data Entry mistake, Others';
            OptionMembers = " ",Duplicate," Order Cancelled"," Data Entry mistake"," Others";

            trigger OnValidate()
            var
                recSalesInvHdr: Record 112;
            begin
                recSalesInvHdr.RESET();
                recSalesInvHdr.SETRANGE(recSalesInvHdr."No.", Rec."No.");
                IF recSalesInvHdr.FIND('-') THEN BEGIN
                    recSalesInvHdr.VALIDATE("Reason Code for Cancel", Rec."Reason Code for Cancel");
                    recSalesInvHdr.MODIFY;
                END;
            end;
        }
        field(38; "Reason for Cancel Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                recSalesInvHdr: Record 112;
            begin
                recSalesInvHdr.RESET();
                recSalesInvHdr.SETRANGE(recSalesInvHdr."No.", Rec."No.");
                IF recSalesInvHdr.FIND('-') THEN BEGIN
                    recSalesInvHdr.VALIDATE("Reason for Cancel Remarks", Rec."Reason for Cancel Remarks");
                    recSalesInvHdr.MODIFY;
                END;
            end;
        }
        field(39; "Reason Code for Vehicle Update"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Due to Break Down, Due to Transhipment, Others, First Time';
            OptionMembers = " ","Due to Break Down"," Due to Transhipment"," Others"," First Time";
        }
        field(40; "Reason for Vehicle Update"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "E-Way Bill Report URL"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "GST Customer Type"; Option)
        {
            Caption = 'GST Customer Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Registered,Unregistered,Export,Deemed Export,Exempted,SEZ Development,SEZ Unit';
            OptionMembers = " ",Registered,Unregistered,Export,"Deemed Export",Exempted,"SEZ Development","SEZ Unit";
        }
        field(43; "E-Invoice IRN No"; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                recSalesInvHdr: Record 112;
                recSalesCrMemoHdr: Record 114;
            begin
                //HT 24082020 (For E-Way Bill and E-Invoice Integration)-
                IF "Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHdr.RESET();
                    recSalesInvHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHdr.FIND('-') THEN BEGIN
                        recSalesInvHdr."IRN Hash" := Rec."E-Invoice IRN No";
                        recSalesInvHdr.MODIFY;
                    END;
                END
                ELSE
                    IF "Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                        recSalesCrMemoHdr.RESET();
                        recSalesCrMemoHdr.SETRANGE("No.", Rec."No.");
                        IF recSalesCrMemoHdr.FIND('-') THEN BEGIN
                            recSalesCrMemoHdr."IRN Hash" := Rec."E-Invoice IRN No";
                            recSalesCrMemoHdr.MODIFY;
                        END;
                    END;
                //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
            end;
        }
        field(44; "E-Invoice IRN Status"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "E-Invoice Cancel Reason"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Wrong entry';
            OptionMembers = " ","Wrong entry";

            trigger OnValidate()
            begin
                // //Capture Cancel Reason
                // recSalesInvHeader.RESET();
                // recSalesInvHeader.SETRANGE("No.",Rec."No.");
                // IF recSalesInvHeader.FINDFIRST THEN BEGIN
                //   recSalesInvHeader."Cancel Reason" := "E-Invoice Cancel Reason";
                //   recSalesInvHeader.MODIFY;
                // END;
            end;
        }
        field(46; "E-Invoice Cancel Remarks"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "E-Invoice Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "E-Invoice Cancel Date"; Text[25])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Extract and create Date and Time from String
                IF "E-Invoice Cancel Date" <> '' THEN BEGIN
                    TimeFormat := 'AM';
                    EVALUATE(Year, COPYSTR("E-Invoice Cancel Date", 1, 4));
                    EVALUATE(Month, COPYSTR("E-Invoice Cancel Date", 6, 2));
                    EVALUATE(Day, COPYSTR("E-Invoice Cancel Date", 9, 2));

                    EVALUATE(Hour, COPYSTR("E-Invoice Cancel Date", 12, 2));
                    EVALUATE(Minute, COPYSTR("E-Invoice Cancel Date", 15, 2));
                    EVALUATE(Sec, COPYSTR("E-Invoice Cancel Date", 18, 2));
                    IF (Hour >= 12) THEN BEGIN
                        Hour := Hour - 12;
                        TimeFormat := 'PM';
                    END;
                    text := FORMAT(Hour) + ':' + FORMAT(Minute) + ':' + FORMAT(Sec) + ' ' + TimeFormat;
                    EVALUATE(Timee, text);
                END ELSE BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."E-Inv. Cancelled Date" := 0DT;
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                //Modify Acknowledgement Date in Sales Invoice Header
                IF "E-Invoice Cancel Date" <> '' THEN BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."E-Inv. Cancelled Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                // For Sales Cr. Memo
                IF "E-Invoice Cancel Date" <> '' THEN BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."E-Inv. Cancelled Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END ELSE BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."E-Inv. Cancelled Date" := 0DT;
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END;
            end;
        }
        field(49; "E-Invoice QR Code"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "E-Invoice PDF"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "E-Invoice Acknowledge No."; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Modify Acknowledgement Date in Sales Invoice Header
                //For Sales Invoice
                IF Rec."Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."Acknowledgement No." := "E-Invoice Acknowledge No.";
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                //For Sales Cr. Memo
                IF Rec."Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."Acknowledgement No." := "E-Invoice Acknowledge No.";
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END;
            end;
        }
        field(52; "E-Invoice Acknowledge Date"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Extract and create Date and Time from String
                TimeFormat := 'AM';
                EVALUATE(Year, COPYSTR("E-Invoice Acknowledge Date", 1, 4));
                EVALUATE(Month, COPYSTR("E-Invoice Acknowledge Date", 6, 2));
                EVALUATE(Day, COPYSTR("E-Invoice Acknowledge Date", 9, 2));
                EVALUATE(Hour, COPYSTR("E-Invoice Acknowledge Date", 12, 2));
                IF Hour >= 12 THEN BEGIN
                    Hour := Hour - 12;
                    TimeFormat := 'PM';
                END;
                EVALUATE(Minute, COPYSTR("E-Invoice Acknowledge Date", 15, 2));
                EVALUATE(Sec, COPYSTR("E-Invoice Acknowledge Date", 18, 2));
                text := FORMAT(Hour) + ':' + FORMAT(Minute) + ':' + FORMAT(Sec) + ' ' + TimeFormat;
                EVALUATE(Timee, text);

                //Modify Acknowledgement Date in Sales Invoice Header
                IF Rec."Transaction Type" = 'Sales Invoice' THEN BEGIN
                    recSalesInvHeader.RESET();
                    recSalesInvHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHeader.FINDFIRST THEN BEGIN
                        recSalesInvHeader."Acknowledgement Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesInvHeader.MODIFY;
                    END;
                END;
                //For Sales Cr. Memo
                IF Rec."Transaction Type" = 'Sales Credit Memo' THEN BEGIN
                    recSalesCrMemoHeader.RESET();
                    recSalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                        recSalesCrMemoHeader."Acknowledgement Date" := CREATEDATETIME(DMY2DATE(Day, Month, Year), Timee);
                        recSalesCrMemoHeader.MODIFY;
                    END;
                END;
            end;
        }
        field(53; "Rec ID"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(54; "Transaction Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Amount to Transfer"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Port Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE(Port = FILTER(true));
        }
        field(57; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Location1: Record 14;
            begin
            end;
        }
        field(58; "Amount to Vendor"; Decimal)
        {
            AutoFormatType = 1;
            //12887 field is removed  CalcFormula = Sum("Purch. Cr. Memo Line"."Amount To Vendor" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount to Vendor';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(59; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            DataClassification = ToBeClassified;
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));

            trigger OnValidate()
            var
                Vendor: Record 23;
            begin
            end;
        }
        field(60; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Buy-from Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(61; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Buy-from Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(62; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(63; "GST Vendor Type"; Option)
        {
            Caption = 'GST Vendor Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Registered,Composite,Unregistered,Import,Exempted,SEZ';
            OptionMembers = " ",Registered,Composite,Unregistered,Import,Exempted,SEZ;

            trigger OnValidate()
            var
                Vendor: Record 23;
            begin
            end;
        }
        field(64; "Vendor GST Reg. No."; Code[15])
        {
            Caption = 'Vendor GST Reg. No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(65; "Order Address Post Code"; Code[20])
        {
            Caption = 'Order Address Post Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(66; "Order Address Country Code"; Code[10])
        {
            Caption = 'Order Address Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(67; "Order Address City"; Text[30])
        {
            Caption = 'Order Address City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(68; "Transportation Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Road,Rail,Air,Ship';
            OptionMembers = " ",Road,Rail,Air,Ship;
        }
        field(70; "Transfer-to Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(71; "QR Code"; BLOB)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(72; "Transporter GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(73; "Transporter Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50000; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Description = 'Acx-KM';
            TableRelation = "Responsibility Center";
        }
        field(50001; "E-way Bill Part"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'RK 29Apr22';
            OptionCaption = ' ,Registered,UnRegistered';
            OptionMembers = " ",Registered,UnRegistered;
        }
        field(50002; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXVG';
            OptionCaption = 'Tax Invoice,Bill of Supply,Delivery Challan';
            OptionMembers = "Tax Invoice","Bill of Supply","Delivery Challan";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record 225;
        recSalesInvHeader: Record 112;
        Day: Integer;
        Month: Integer;
        Year: Integer;
        Timee: Time;
        Minute: Integer;
        Sec: Integer;
        Hour: Integer;
        TimeCalc: Integer;
        TimeFormat: Text;
        text: Text;
        recSalesCrMemoHeader: Record 114;
}

