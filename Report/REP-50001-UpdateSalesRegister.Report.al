report 50001 "Update Sales Register"
{
    // //ACXCP_04102021 /Sales Register Changes

    Permissions = TableData 113 = rm,
                  TableData 115 = rm,
                  TableData 5745 = rm;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Sales Invoice Line"; 113)
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                ORDER(Ascending)
                                WHERE("Exported to Sales Register" = FILTER(false),
                                      "Sell-to Customer No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin

                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;
                InsertSalesInv("Sales Invoice Line");
            end;

            trigger OnPreDataItem()
            begin

                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transferring Sales Data....\\' +
                            '@1@@@@@@@@@@@@@@@@@@@@@@@@@',
                            RemainingStatus);
                TotalRec := COUNT;

                IF NOT blnRunSale THEN
                    CurrReport.BREAK;
            end;
        }
        dataitem("Sales Cr.Memo Line"; 115)
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                ORDER(Ascending)
                                WHERE("Exported to Sales Register" = FILTER(false),
                                      "Sell-to Customer No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin

                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;

                InsertSalesCrMemo("Sales Cr.Memo Line");
            end;

            trigger OnPreDataItem()
            begin
                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transfering Sales Return Data....\\' +
                            '@1@@@@@@@@@@@@@@@@@@@@@@@@@',
                            RemainingStatus);
                TotalRec := COUNT;

                IF NOT blnRunSaleCr THEN
                    CurrReport.BREAK;
            end;
        }
        dataitem("Transfer Shipment Header"; 5744)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin

                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;

                InsertTransShpt("Transfer Shipment Header");
            end;

            trigger OnPreDataItem()
            begin

                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transfering Trf. Shipment Data....\\' +
                            '@1@@@@@@@@@@@@@@@@@@@@@@@@@',
                            RemainingStatus);
                TotalRec := COUNT;

                IF NOT blnRunTransShpt THEN
                    CurrReport.BREAK;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Update Data")
                {
                    field("Update Sales"; blnRunSale)
                    {
                    }
                    field("Update Sales Cr Memo"; blnRunSaleCr)
                    {
                    }
                    field("Update Transfer Shipment"; blnRunTransShpt)
                    {
                    }
                }
                group("Delete Data")
                {
                    field("Regenerate Sales"; blnRegenerateSales)
                    {
                        Editable = true;
                    }
                    field("Regenerate  Sales Cr Memo"; blnRegenerateSalesCr)
                    {
                        Editable = true;
                    }
                    field("Regenerate Transfer Shipment"; blnRegenerateTransShpt)
                    {
                        Editable = true;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin

        blnRunSale := TRUE;
        blnRunSaleCr := TRUE;
        blnRunTransShpt := TRUE;
    end;

    trigger OnPostReport()
    begin
        MESSAGE('Sales register updated successfully');
    end;

    trigger OnPreReport()
    begin
        // "Sales Cr.Memo Line".SETRANGE("Document No.",'SCM/BD/2020/00001');
        IF blnRegenerateSales THEN BEGIN
            SalesRegister.RESET;
            SalesRegister.SETRANGE("Document Type", SalesRegister."Document Type"::"Sales Invoice");
            SalesRegister.DELETEALL;

            lSalesInvLine.RESET;
            lSalesInvLine.MODIFYALL("Exported to Sales Register", FALSE);
        END;

        IF blnRegenerateSalesCr THEN BEGIN
            SalesRegister.RESET;
            SalesRegister.SETRANGE("Document Type", SalesRegister."Document Type"::"Sales Cr. Memo");
            SalesRegister.DELETEALL;

            lSalesCrMemoLine.RESET;
            lSalesCrMemoLine.MODIFYALL("Exported to Sales Register", FALSE);
        END;

        IF blnRegenerateTransShpt THEN BEGIN
            SalesRegister.RESET;
            SalesRegister.SETFILTER("Document Type", '%1|%2', SalesRegister."Document Type"::"Transfer Shpt.",
                                                              SalesRegister."Document Type"::"Transfer Rcpt.");
            SalesRegister.DELETEALL;

            lTransShptLine.RESET;
            lTransShptLine.MODIFYALL("Exported to Sales Register", FALSE);
        END;
    end;

    var
        SalesRegister: Record 50002;
        Cust: Record 18;
        Loc: Record 14;
        Item: Record 27;
        GenJnlTemplate: Record 80;
        blnRegenerateSales: Boolean;
        ItemVariant: Record 5401;
        CPG: Record 92;
        SalesRegister1: Record 50002;
        Loc1: Record 14;
        //16767 DtlTaxEntry: Record 16522;
        AddTaxAmt: Decimal;
        TaxAmt: Decimal;
        TaxPer: Decimal;
        AddTaxPer: Decimal;
        Territory: Record 286;
        Salesperson: Record 13;
        Country: Record 9;
        GBPG: Record 250;
        ICC: Record 5722;
        //16767 PGC: Record 5723;
        Window: Dialog;
        TotalRec: Integer;
        RemainingStatus: Integer;
        RowNo: Integer;
        GLEntry: Record 17;
        TaxAreaLine: Record 319;
        TaxJuris: Record 320;
        GPS: Record 252;
        GLAcc: Record 15;
        blnRegenerateSalesCr: Boolean;
        blnRegenerateTransShpt: Boolean;
        intDay: Integer;
        intMonth: Integer;
        intYear: Integer;
        cdFinYear: Code[7];
        cdMonthName: Code[3];
        cdQuarter: Code[2];
        TaxAreaLine2: Record 319;
        recState: Record State;
        DimValue: Record 349;
        GPPG: Record 251;
        //16767 StrOrderLineDtl: Record 13798;
        FrtAmt: Decimal;
        DiscAmt: Decimal;
        OtherCharges: Decimal;
        NetAmt: Decimal;
        blnRunSale: Boolean;
        blnRunSaleCr: Boolean;
        blnRunTransShpt: Boolean;
        recCustPriceGroup: Record 6;
        decTD: Decimal;
        decSD: Decimal;
        decCD: Decimal;
        decBD: Decimal;
        decFreight: Decimal;
        decOffSeason: Decimal;
        //16767 recPostedStrOrderDetail: Record 13798;
        Loc2: Record 14;
        //16767 recServiceTaxSetup: Record 16472;
        //16767 recExcisePostingSetup: Record 13711;
        lSalesInvLine: Record 113;
        lSalesCrMemoLine: Record 115;
        lTransShptLine: Record 5745;
        decInsurance: Decimal;
        decSSD: Decimal;
        recDtGSTLedg: Record "Detailed GST Ledger Entry";
        decTrLoDisc: Decimal;
        decFOCDisc: Decimal;
        recSalesHier: Record 50014;
        recSalesInvHead: Record 112;
        recSaleCrHead: Record 114;
        recVle: Record 5802;
        recile: Record 32;
        recLotInfo: Record 6505;
        recShipToAddress: Record 222;
        //16767 recPostedStructure: Record 13760;
        recCampaign: Record 5071;


    procedure InsertSalesInv(var lSalesInvLine: Record 113)
    var
        lSalesInvHdr: Record 112;
        AmtToCust: Codeunit 50200;
        TdsEntry: Record "TCS Entry";
    begin
        WITH lSalesInvLine DO BEGIN
            lSalesInvHdr.GET("Document No.");
            Loc.GET("Location Code");
            Cust.GET(lSalesInvHdr."Sell-to Customer No.");
            CPG.GET(lSalesInvHdr."Customer Posting Group");
            IF recCustPriceGroup.GET(lSalesInvHdr."Customer Price Group") THEN;

            IF (Type = Type::"G/L Account") AND ("No." = CPG."Invoice Rounding Account") AND ("Line No." <> 10000) THEN BEGIN
                SalesRegister1.RESET;
                SalesRegister1.SETRANGE("Document Type", SalesRegister1."Document Type"::"Sales Invoice");
                SalesRegister1.SETRANGE("Source Document No.", "Document No.");
                SalesRegister1.FIND('+');
                SalesRegister1."Round Off Amount" := AmtToCust.GetAmttoCustomerPostedLine("Document No.", "Line No."); //16767 "Amount To Customer"
                SalesRegister1."Net Amount" += AmtToCust.GetAmttoCustomerPostedLine("Document No.", "Line No.");//16767 Amount to Customer 
                SalesRegister1.MODIFY;
            END ELSE BEGIN
                SalesRegister.INIT;
                SalesRegister."Document Type" := SalesRegister."Document Type"::"Sales Invoice";
                //SalesRegister."Gen. Journal Template Code" := lSalesInvHdr."Gen. Journal Template Code" ;
                SalesRegister."Source Document No." := "Document No.";
                SalesRegister."Source Line No." := "Line No.";
                SalesRegister."Posting Date" := lSalesInvHdr."Posting Date";
                SalesRegister."Source Line Description" := Description;
                SalesRegister."Source Line Description 2" := "Description 2"; //ACXCP_03012022
                SalesRegister."Document Salesperson Code" := lSalesInvHdr."Salesperson Code";
                SalesRegister."Order No." := lSalesInvHdr."Order No.";
                IF lSalesInvHdr."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(lSalesInvHdr."Salesperson Code") THEN
                        SalesRegister."Document Salesperson Name" := Salesperson.Name;
                END;
                //acxcp_Campaign Code+ //07072022
                IF lSalesInvHdr."Campaign No." <> '' THEN BEGIN
                    recCampaign.RESET;
                    recCampaign.SETRANGE("No.", lSalesInvHdr."Campaign No.");
                    IF recCampaign.FINDFIRST THEN BEGIN
                        SalesRegister."Campaign No." := recCampaign."No.";
                    END;
                END;
                //acxcp_Campaign Code-
                SalesRegister."Payment Term Code" := lSalesInvHdr."Payment Terms Code";
                SalesRegister."Due date" := lSalesInvHdr."Due Date";
                SalesRegister."Source Type" := SalesRegister."Source Type"::Customer;
                SalesRegister."Source No." := lSalesInvHdr."Sell-to Customer No.";
                SalesRegister."Source Name" := Cust.Name;
                SalesRegister."Source City" := Cust.City;
                SalesRegister."LR/RR No." := lSalesInvHdr."LR/RR No.";
                SalesRegister."LR/RR Date" := lSalesInvHdr."LR/RR Date";
                SalesRegister.VALIDATE("Responsibility Center", "Responsibility Center");//KM
                                                                                         //acxcp_041021 + //shipto code,name
                SalesRegister."Ship To Code" := lSalesInvHdr."Ship-to Code";
                IF lSalesInvHdr."Ship-to Code" <> '' THEN
                    recShipToAddress.SETRANGE("Customer No.", "Sell-to Customer No.");
                recShipToAddress.SETRANGE(Code, lSalesInvHdr."Ship-to Code");
                IF recShipToAddress.FINDFIRST THEN BEGIN
                    //SalesRegister."Ship To Code":=lSalesInvHdr."Ship-to Code";
                    SalesRegister."Ship To Customer Name" := recShipToAddress.Name;
                END;
                SalesRegister."Reason Code" := lSalesInvLine."Return Reason Code";
                //acxcp_041021 -

                //acxav - BEGIN
                SalesRegister."External Document No." := lSalesInvHdr."External Document No.";
                //acxav - end

                SalesRegister."Source State Code" := Cust."State Code";
                IF recState.GET(Cust."State Code") THEN BEGIN
                    SalesRegister."Source State Name" := recState.Description;
                END;
                SalesRegister."Customer Posting Group" := lSalesInvHdr."Customer Posting Group";
                SalesRegister."Customer Price Group" := lSalesInvHdr."Customer Price Group";
                SalesRegister."Currency Code" := lSalesInvHdr."Currency Code";
                SalesRegister."Currency Factor" := lSalesInvHdr."Currency Factor";
                SalesRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                SalesRegister."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                GBPG.GET("Gen. Bus. Posting Group");
                SalesRegister."GBPG Description" := GBPG.Description;
                GPPG.GET("Gen. Prod. Posting Group");
                SalesRegister."GPPG Description" := GPPG.Description;
                SalesRegister."Country/Region Code" := Cust."Country/Region Code";
                IF Cust."Country/Region Code" <> '' THEN BEGIN
                    Country.GET(Cust."Country/Region Code");
                    SalesRegister."Country/Region Name" := Country.Name;
                END;
                SalesRegister."Master Salesperson Code" := Cust."Salesperson Code";
                SalesRegister."Master Cust. Posting Group" := Cust."Customer Posting Group";
                IF Cust."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(Cust."Salesperson Code") THEN;
                    SalesRegister."Master Salesperson Name" := Salesperson.Name;
                END;
                SalesRegister."Territory Dimension Name" := DimValue.Name;
                SalesRegister."Outward Location Code" := "Location Code";
                SalesRegister."Outward State Code" := Loc."State Code";
                IF recState.GET(Loc."State Code") THEN BEGIN
                    SalesRegister."Outward State Name" := recState.Description;
                END;

                // Date Treatment Begins

                intDay := DATE2DMY(lSalesInvHdr."Posting Date", 1);
                intMonth := DATE2DMY(lSalesInvHdr."Posting Date", 2);
                intYear := DATE2DMY(lSalesInvHdr."Posting Date", 3);

                CASE intMonth OF
                    1:
                        cdMonthName := 'JAN';
                    2:
                        cdMonthName := 'FEB';
                    3:
                        cdMonthName := 'MAR';
                    4:
                        cdMonthName := 'APR';
                    5:
                        cdMonthName := 'MAY';
                    6:
                        cdMonthName := 'JUN';
                    7:
                        cdMonthName := 'JUL';
                    8:
                        cdMonthName := 'AUG';
                    9:
                        cdMonthName := 'SEP';
                    10:
                        cdMonthName := 'OCT';
                    11:
                        cdMonthName := 'NOV';
                    12:
                        cdMonthName := 'DEC';
                END;

                IF intMonth < 4 THEN BEGIN
                    cdFinYear := FORMAT(intYear - 1) + '-' + FORMAT(intYear - 2000);
                    cdQuarter := 'Q4';
                END
                ELSE
                    IF intMonth < 7 THEN BEGIN
                        cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                        cdQuarter := 'Q1';
                    END
                    ELSE
                        IF intMonth < 10 THEN BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q2';
                        END
                        ELSE BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q3';
                        END;

                SalesRegister."Fin. Year" := cdFinYear;
                SalesRegister.Quarter := cdQuarter;
                SalesRegister."Month Name" := cdMonthName;
                SalesRegister.Year := intYear;
                SalesRegister.Month := intMonth;
                SalesRegister.Day := intDay;

                // Date Treatment Ends

                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    Item.GET("No.");
                    //SalesRegister."Excise Prod. Posting Group" := Item."Excise Prod. Posting Group" ;
                    SalesRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                    SalesRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                    SalesRegister."Item Category Code" := Item."Item Category Code";

                    IF Item."Item Category Code" <> '' THEN BEGIN
                        ICC.GET(Item."Item Category Code");
                        SalesRegister."Item Category Description" := ICC.Description;
                    END;

                    //16767 Start New
                    SalesRegister."Item Category Code" := ICC."Parent Category";
                    ICC.GET(Item."Item Category Code");
                    IF ICC."Parent Category" <> '' THEN BEGIN

                        SalesRegister."Item Category Description" := ICC.Description;
                    END;


                    //16767 end

                    //16767 SalesRegister."Product Group Code" := Item."Product Group Code";
                    SalesRegister."Product Group Code" := Item."Item Category Code";
                    //IF Item."Product Group Code" <> '' THEN BEGIN
                    //  PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                    // SalesRegister."Product Group Description" := PGC.Description ;
                    //END ;far150519

                END;

                SalesRegister.Type := Type;
                SalesRegister."No." := "No.";
                SalesRegister."Variant Code" := "Variant Code";
                SalesRegister."Item Description" := Description;
                SalesRegister."Gross Weight" := Item."Gross Weight";
                SalesRegister."Net Weight" := Item."Net Weight";
                SalesRegister."Units per Parcel" := Item."Units per Parcel";
                SalesRegister."Unit of Measure" := "Unit of Measure Code";
                IF SalesRegister."Variant Code" <> '' THEN BEGIN
                    ItemVariant.GET(SalesRegister."No.", SalesRegister."Variant Code");
                    SalesRegister."Variant Description" := ItemVariant.Description;
                END;

                SalesRegister.Quantity := Quantity;
                SalesRegister."Unit Price" := "Unit Price";
                SalesRegister.Amount := Quantity * "Unit Price";
                SalesRegister."Line Discount Amount" := "Line Discount Amount";
                SalesRegister."Line Amount" := "Line Amount";
                //16767 SalesRegister."Actual Tax %" := lSalesInvLine."Tax %";

                SalesRegister."TCS Nature of Collection" := lSalesInvLine."TCS Nature of Collection"; //ACXCP_04102021
                TdsEntry.Reset();//16767 Start
                TdsEntry.SetRange("Document No.", "Document No.");
                if TdsEntry.FindSet() then begin
                    repeat

                        SalesRegister."TCS Amount" := TdsEntry."TCS Amount"
                    //16767 SalesRegister."TCS Amount" := lSalesInvLine."TDS/TCS Amount";//ACXCP_04102021
                    until TdsEntry.Next() = 0;
                end;
                //16767 end

                /* SalesRegister."Excise Base Amount" := "Excise Base Amount" ;
                 SalesRegister."Excise Amount" := "Excise Amount" ;
                 SalesRegister."BED Amount" := "BED Amount" ;
                 SalesRegister."ECess Amount" := "eCess Amount" ;
                 SalesRegister."SHECess Amount" := "SHE Cess Amount" ;
                 SalesRegister."SAED Amount" := "SAED Amount" ;
                 SalesRegister."Assessable Value":= "Assessable Value";
                 SalesRegister."MRP Price":= "MRP Price" ;
                 SalesRegister."Abatement %":= "Abatement %"; */ //16767 field not found
                /* recExcisePostingSetup.RESET;
                recExcisePostingSetup.SETRANGE("Excise Bus. Posting Group", "Excise Bus. Posting Group");
                recExcisePostingSetup.SETRANGE("Excise Prod. Posting Group", "Excise Prod. Posting Group");
                recExcisePostingSetup.SETFILTER("From Date", '<=%1', "Posting Date");
                IF recExcisePostingSetup.FIND('+') THEN BEGIN
                    SalesRegister."BED %" := recExcisePostingSetup."BED %";
                    SalesRegister."ECess %" := recExcisePostingSetup."eCess %";
                    SalesRegister."SHECess %" := recExcisePostingSetup."SHE Cess %";
                    SalesRegister."SAED %" := recExcisePostingSetup."SAED %";
                END ELSE BEGIN
                    SalesRegister."BED %" := 0;
                    SalesRegister."ECess %" := 0;
                    SalesRegister."SHECess %" := 0;
                    SalesRegister."SAED %" := 0;
                END; */ //16767 Comment due to table not found structure

                //acxcp
                recVle.RESET;
                recVle.SETRANGE("Document No.", "Document No.");
                recVle.SETRANGE("Item No.", "No.");
                recVle.SETRANGE("Document Line No.", "Line No.");
                IF recVle.FINDFIRST THEN BEGIN
                    recile.RESET;
                    recile.SETRANGE("Entry No.", recVle."Item Ledger Entry No.");
                    //   recile.SETRANGE("Item No.",recVle."Item No.");
                    IF recile.FINDFIRST THEN BEGIN
                        SalesRegister."Lot No." := recile."Lot No.";
                        recLotInfo.RESET;
                        recLotInfo.SETRANGE("Lot No.", recile."Lot No.");
                        recLotInfo.SETRANGE("Item No.", recile."Item No.");
                        IF recLotInfo.FINDFIRST THEN BEGIN
                            SalesRegister."MFG Date" := recLotInfo."MFG Date";
                            SalesRegister."Expiration Date" := recLotInfo."Expiration Date";
                        END;
                    END;
                END;
                //acxcp

                /* SalesRegister."Service Tax Base Amount" := "Service Tax Base";
                SalesRegister."Service Tax Amount" := "Service Tax Amount";
                SalesRegister."Service Tax eCess Amount" := "Service Tax eCess Amount";
                SalesRegister."Service Tax SHECess Amount" := "Service Tax SHE Cess Amount";
                SalesRegister."Service Tax Group" := "Service Tax Group";
                SalesRegister."Service Tax Registration No." := "Service Tax Registration No.";
                recServiceTaxSetup.RESET;
                recServiceTaxSetup.SETRANGE(Code, "Service Tax Group");
                recServiceTaxSetup.SETFILTER("From Date", '<=%1', "Posting Date");
                IF recServiceTaxSetup.FIND('-') THEN BEGIN
                    SalesRegister."Service Tax %" := recServiceTaxSetup."Service Tax %";
                    SalesRegister."Service Tax eCess %" := recServiceTaxSetup."eCess %";
                    SalesRegister."Service Tax SHECess %" := recServiceTaxSetup."SHE Cess %";
                END ELSE BEGIN
                    SalesRegister."Service Tax %" := 0;
                    SalesRegister."Service Tax eCess %" := 0;
                    SalesRegister."Service Tax SHECess %" := 0;
                END; */ //16767

                SalesRegister."TDS Base Amount" := 0;
                SalesRegister."TDS Amount" := 0;
                SalesRegister."eCESS on TDS Amount" := 0;
                SalesRegister."SHE Cess on TDS Amount" := 0;
                SalesRegister."TDS Nature of Deduction" := '';
                SalesRegister."TDS %" := 0;
                SalesRegister."eCESS % on TDS" := 0;
                SalesRegister."SHE Cess % On TDS" := 0;

                /*  IF "Tax Base Amount" = 0 THEN
                     SalesRegister."Tax Base Amount" := "Line Amount" + "Excise Amount"
                 ELSE
                     SalesRegister."Tax Base Amount" := "Tax Base Amount";
                 SalesRegister."Tax Amount" := "Tax Amount"; */ //16767 Field not found


                SalesRegister."Tax Group Code" := "Tax Group Code";
                SalesRegister."Tax Area" := "Tax Area Code";

                IF "Tax Area Code" <> '' THEN BEGIN
                    /*
                    FAR 060519
                      TaxAreaLine.RESET ;
                      TaxAreaLine.SETRANGE("Tax Area", "Tax Area Code") ;
                      TaxAreaLine.FIND('-') ;
                      SalesRegister."Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code" ;

                      TaxJuris.GET(TaxAreaLine."Tax Jurisdiction Code") ;
                      SalesRegister."Tax Type" := TaxJuris."Tax Type" ;

                   */
                    AddTaxAmt := 0;
                    TaxAmt := 0;
                    TaxPer := 0;
                    AddTaxPer := 0;
                    /*  IF "Tax Amount" <> 0 THEN BEGIN
                         DtlTaxEntry.RESET;
                         DtlTaxEntry.SETCURRENTKEY("Document No.", "Document Line No.", "Main Component Entry No.",
                                                   "Deferment No.", "Tax Jurisdiction Code", "Entry Type");
                         DtlTaxEntry.SETRANGE("Document No.", "Document No.");
                         DtlTaxEntry.SETRANGE("Document Line No.", "Line No.");
                         IF DtlTaxEntry.FIND('-') THEN
                             REPEAT
                                 TaxAreaLine2.GET(DtlTaxEntry."Tax Area Code", DtlTaxEntry."Tax Jurisdiction Code");
                                 IF TaxAreaLine2."Calculation Order" <= 1 THEN BEGIN
                                     TaxAmt += -(DtlTaxEntry."Tax Amount");
                                     TaxPer := DtlTaxEntry."Tax %";
                                 END ELSE BEGIN
                                     AddTaxAmt += -(DtlTaxEntry."Tax Amount");
                                     AddTaxPer := DtlTaxEntry."Tax %";
                                 END;
                             UNTIL DtlTaxEntry.NEXT = 0;
                     END; */ //16767 Comment due to table not found

                    IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::CST THEN
                        SalesRegister."CST Amount" := TaxAmt
                    ELSE
                        SalesRegister."VAT Amount" := TaxAmt;
                    SalesRegister."Addn. Tax Amount" := AddTaxAmt;
                    SalesRegister."Tax %" := TaxPer;
                    SalesRegister."Addn. Tax %" := AddTaxPer;
                END;
                IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::" " THEN
                    SalesRegister."Tax Type" := SalesRegister."Tax Type"::VAT;
                //16767 SalesRegister."Form Code" := lSalesInvHdr."Form Code";
                //16767 SalesRegister."Form No." := lSalesInvHdr."Form No.";
                SalesRegister."Line Discount %" := "Line Discount %";
                SalesRegister."Applies-to Doc. Type" := lSalesInvHdr."Applies-to Doc. Type";
                SalesRegister."Applies-to Doc. No." := lSalesInvHdr."Applies-to Doc. No.";

                SalesRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                SalesRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //16767 SalesRegister."T.I.N. No." := Cust."T.I.N. No.";
                SalesRegister."No. Series" := lSalesInvHdr."No. Series";

                SalesRegister."Net Amount" := AmtToCust.GetAmttoCustomerPostedLine("Document No.", "Line No.");//16767 "Amount To Customer";


                decFreight := 0;
                decInsurance := 0;
                decTD := 0;
                decCD := 0;
                decSD := 0;
                decSSD := 0;
                decBD := 0;
                decTrLoDisc := 0;
                decFOCDisc := 0;

                decInsurance := 0;
                /* recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'Insurance');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    //   REPEAT
                    decInsurance := recPostedStrOrderDetail.Amount;
                    // UNTIL recPostedStrOrderDetail.NEXT =0;
                END;

                decCD := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'C.DISC');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    //  REPEAT
                    decCD := recPostedStrOrderDetail.Amount;
                    //  UNTIL recPostedStrOrderDetail.NEXT =0;
                END;

                decSD := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'S.DISC');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    REPEAT
                        //           decSD :=recPostedStrOrderDetail.Amount;
                        decSD += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;
                END;

                decTD := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'DEALER DIS');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    //  REPEAT
                    decTD := recPostedStrOrderDetail.Amount;
                    //  UNTIL recPostedStrOrderDetail.NEXT =0;
                END;

                //FAR26122019 BEGIN
                decBD := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'BULK DIS');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    //         REPEAT
                    decBD := recPostedStrOrderDetail.Amount;
                    //         UNTIL recPostedStrOrderDetail.NEXT =0;
                END;

                //FAR26122019 END
                decFreight := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FREIGHT');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    //     REPEAT
                    decFreight := recPostedStrOrderDetail.Amount;
                    //   UNTIL recPostedStrOrderDetail.NEXT =0;
                END;

                //FAR Begin 05092019
                decSSD := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'S.S.DISC');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    REPEAT
                        //           decSSD:=recPostedStrOrderDetail.Amount;
                        decSSD += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;
                END;
                //FAR END 05092019
                decFOCDisc := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FOC DIS');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    // REPEAT
                    decFOCDisc := recPostedStrOrderDetail.Amount;
                    //UNTIL recPostedStrOrderDetail.NEXT =0;
                END;
                decTrLoDisc := 0;
                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'TRK LO DIS');
                IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                    // REPEAT
                    decTrLoDisc := recPostedStrOrderDetail.Amount;
                    // UNTIL recPostedStrOrderDetail.NEXT =0;
                END; */ //16767 Comment due to table not found
                SalesRegister.Freight := ABS(decFreight);
                SalesRegister.Insurance := ABS(decInsurance);
                SalesRegister."Trade Discount" := ABS(decTD);
                SalesRegister."Cash Discount" := ABS(decCD);
                SalesRegister."Scheme Discount" := ABS(decSD);
                SalesRegister."Special Sch. Disc" := ABS(decSSD);
                SalesRegister."Bulk Disc" := ABS(decBD);//FAR261219
                SalesRegister."Truck Load Disc" := ABS(decTrLoDisc);
                SalesRegister."FOC Disc" := ABS(decFOCDisc);

                //FAR BEGIN 03012020
                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'CGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."CGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."CGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");

                END;

                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'SGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."SGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."SGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");

                END;

                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'IGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."IGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."IGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");

                END;

                SalesRegister."Total GST Amount" := ABS(SalesRegister."CGST Amount" + SalesRegister."SGST Amount" + SalesRegister."IGST Amount" +
                SalesRegister."Cess Amount" + SalesRegister."Addl. Cess Amount");

                //FAR END 03012020

                IF ("Gen. Prod. Posting Group" <> '') AND ("Gen. Bus. Posting Group" <> '') THEN BEGIN
                    IF GPS.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN BEGIN
                        SalesRegister."Revenue Account Code" := GPS."Sales Account";
                        IF GLAcc.GET(GPS."Sales Account") THEN
                            SalesRegister."Revenue Account Description" := GLAcc.Name;
                    END;
                END;

                IF (lSalesInvHdr."Customer Posting Group" <> '') THEN BEGIN
                    CPG.GET(lSalesInvHdr."Customer Posting Group");
                    SalesRegister."Receivable Account Code" := CPG."Receivables Account";
                    IF GLAcc.GET(CPG."Receivables Account") THEN
                        SalesRegister."Receivable Account Description" := GLAcc.Name;
                END;
                //Sales Hierarchy
                recSalesInvHead.RESET();
                recSalesInvHead.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF recSalesInvHead.FINDFIRST THEN BEGIN
                    recSalesHier.RESET();
                    recSalesHier.SETRANGE("FO Code", recSalesInvHead."Salesperson Code");
                    recSalesHier.SETFILTER("Start Date", '<=%1', recSalesInvHead."Posting Date");
                    IF recSalesHier.FINDFIRST THEN BEGIN
                        SalesRegister."FO Code" := recSalesHier."FO Code";
                        SalesRegister."FO Name" := recSalesHier."FO Name";
                        SalesRegister."FA Code" := recSalesHier."FA Code";
                        SalesRegister."FA Name" := recSalesHier."FA Name";
                        SalesRegister."TME Code" := recSalesHier."TME Code";
                        SalesRegister."TME Name" := recSalesHier."TME Name";
                        SalesRegister."RME Code" := recSalesHier."RME Code";
                        SalesRegister."RME Name" := recSalesHier."RME Name";
                        SalesRegister."ZMM Code" := recSalesHier."ZMM Code";
                        SalesRegister."ZMM Name" := recSalesHier."ZMM Name";
                        SalesRegister."HOD Code" := recSalesHier."HOD Code";
                        SalesRegister."HOD Name" := recSalesHier."HOD Name";
                    END ELSE BEGIN
                        recSalesHier.RESET();
                        recSalesHier.SETRANGE("FA Code", recSalesInvHead."Salesperson Code");
                        recSalesHier.SETFILTER("Start Date", '<=%1', recSalesInvHead."Posting Date");
                        IF recSalesHier.FINDFIRST THEN BEGIN
                            SalesRegister."FO Code" := recSalesHier."FA Code";
                            SalesRegister."FO Name" := recSalesHier."FA Name";
                            SalesRegister."FA Code" := recSalesHier."FA Code";
                            SalesRegister."FA Name" := recSalesHier."FA Name";
                            SalesRegister."TME Code" := recSalesHier."TME Code";
                            SalesRegister."TME Name" := recSalesHier."TME Name";
                            SalesRegister."RME Code" := recSalesHier."RME Code";
                            SalesRegister."RME Name" := recSalesHier."RME Name";
                            SalesRegister."ZMM Code" := recSalesHier."ZMM Code";
                            SalesRegister."ZMM Name" := recSalesHier."ZMM Name";
                            SalesRegister."HOD Code" := recSalesHier."HOD Code";
                            SalesRegister."HOD Name" := recSalesHier."HOD Name";
                        END;
                    END;
                END;
                //Sales Hierarchy
                SalesRegister.INSERT;
            END;
            "Exported to Sales Register" := TRUE;
            MODIFY;

        END;

    end;


    procedure InsertSalesCrMemo(var lSalesCrMemoLine: Record 115)
    var
        lSalesCrMemoHdr: Record 114;
        lSalesRegister: Record 50002;
        AmtToCust: Codeunit 50200;
        TdsEntry: Record "TCS Entry";
    begin

        WITH lSalesCrMemoLine DO BEGIN
            lSalesCrMemoHdr.GET("Document No.");
            IF Loc.GET("Location Code") THEN;
            Cust.GET("Sell-to Customer No.");
            CPG.GET(lSalesCrMemoHdr."Customer Posting Group");
            IF recCustPriceGroup.GET(lSalesCrMemoHdr."Customer Price Group") THEN;

            IF (Type = Type::"G/L Account") AND ("No." = CPG."Invoice Rounding Account") AND ("Line No." <> 10000) THEN BEGIN
                SalesRegister1.RESET;
                SalesRegister1.SETRANGE("Document Type", SalesRegister1."Document Type"::"Sales Cr. Memo");
                SalesRegister1.SETRANGE("Source Document No.", "Document No.");
                SalesRegister1.FIND('+');
                SalesRegister1."Round Off Amount" := AmtToCust.GetAmttoVendorPostedDoc(lSalesCrMemoLine."Document No.");//16767 "Amount To Customer";
                SalesRegister1."Net Amount" += AmtToCust.GetAmttoVendorPostedDoc(lSalesCrMemoLine."Document No.");//16767 "Amount To Customer";
                SalesRegister1.MODIFY;
            END ELSE BEGIN
                SalesRegister.INIT;
                SalesRegister."Document Type" := SalesRegister."Document Type"::"Sales Cr. Memo";
                //SalesRegister."Gen. Journal Template Code" := lSalesCrMemoHdr."Gen. Journal Template Code" ;
                SalesRegister."Source Document No." := "Document No.";
                SalesRegister."Source Line No." := "Line No.";
                SalesRegister."Posting Date" := "Posting Date";
                SalesRegister."Source Line Description" := Description;
                SalesRegister."Source Line Description 2" := "Description 2"; //ACXCP_03012022
                SalesRegister."Document Salesperson Code" := lSalesCrMemoHdr."Salesperson Code";
                //acxav - BEGIN
                SalesRegister."External Document No." := lSalesCrMemoHdr."External Document No.";
                //acxav - end

                IF lSalesCrMemoHdr."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(lSalesCrMemoHdr."Salesperson Code") THEN;
                    SalesRegister."Document Salesperson Name" := Salesperson.Name;
                END;
                //acxcp_Campaign Code+ //07072022
                IF lSalesCrMemoHdr."Campaign No." <> '' THEN BEGIN
                    recCampaign.RESET;
                    recCampaign.SETRANGE("No.", lSalesCrMemoHdr."Campaign No.");
                    IF recCampaign.FINDFIRST THEN BEGIN
                        SalesRegister."Campaign No." := recCampaign."No.";
                    END;
                END;
                //acxcp_Campaign Code-
                SalesRegister."Payment Term Code" := lSalesCrMemoHdr."Payment Terms Code";
                SalesRegister."Currency Code" := lSalesCrMemoHdr."Currency Code";
                SalesRegister."Currency Factor" := lSalesCrMemoHdr."Currency Factor";
                SalesRegister."Supplier's Ref." := '';
                SalesRegister."Due date" := lSalesCrMemoHdr."Due Date";
                SalesRegister."Source Type" := SalesRegister."Source Type"::Customer;
                SalesRegister."Source No." := "Sell-to Customer No.";
                SalesRegister."Source Name" := Cust.Name;
                SalesRegister."Source City" := Cust.City;
                SalesRegister.VALIDATE("Responsibility Center", "Responsibility Center");//KM

                SalesRegister."Source State Code" := Cust."State Code";
                IF recState.GET(Cust."State Code") THEN BEGIN
                    SalesRegister."Source State Name" := recState.Description;
                END;

                //acxcp_041021 + //shipto code,name
                SalesRegister."Ship To Code" := lSalesCrMemoHdr."Ship-to Code";
                IF lSalesCrMemoHdr."Ship-to Code" <> '' THEN
                    recShipToAddress.SETRANGE("Customer No.", "Sell-to Customer No.");
                recShipToAddress.SETRANGE(Code, lSalesCrMemoHdr."Ship-to Code");
                IF recShipToAddress.FINDFIRST THEN BEGIN
                    //SalesRegister."Ship To Code":=lSalesInvHdr."Ship-to Code";
                    SalesRegister."Ship To Customer Name" := recShipToAddress.Name;
                END;
                SalesRegister."Reason Code" := lSalesCrMemoLine."Return Reason Code";
                //acxcp_041021 -

                SalesRegister."Customer Posting Group" := lSalesCrMemoHdr."Customer Posting Group";
                //      SalesRegister."CPG Desc" := CPG.Description ;
                SalesRegister."Customer Price Group" := lSalesCrMemoHdr."Customer Price Group";
                SalesRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                SalesRegister."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                GBPG.GET("Gen. Bus. Posting Group");
                SalesRegister."GBPG Description" := GBPG.Description;
                GPPG.GET("Gen. Prod. Posting Group");
                SalesRegister."GPPG Description" := GPPG.Description;
                SalesRegister."Country/Region Code" := Cust."Country/Region Code";
                IF Cust."Country/Region Code" <> '' THEN BEGIN
                    Country.GET(Cust."Country/Region Code");
                    SalesRegister."Country/Region Name" := Country.Name;
                END;
                SalesRegister."Master Salesperson Code" := Cust."Salesperson Code";
                SalesRegister."Master Cust. Posting Group" := Cust."Customer Posting Group";
                IF Cust."Salesperson Code" <> '' THEN BEGIN
                    IF Salesperson.GET(Cust."Salesperson Code") THEN;
                    SalesRegister."Master Salesperson Name" := Salesperson.Name;
                END;
                SalesRegister."Territory Dimension Name" := DimValue.Name;
                SalesRegister."Outward Location Code" := "Location Code";
                SalesRegister."Outward State Code" := Loc."State Code";
                IF recState.GET(Loc."State Code") THEN BEGIN
                    SalesRegister."Outward State Name" := recState.Description;
                END;

                // Date Treatment Begins

                intDay := DATE2DMY(lSalesCrMemoHdr."Posting Date", 1);
                intMonth := DATE2DMY(lSalesCrMemoHdr."Posting Date", 2);
                intYear := DATE2DMY(lSalesCrMemoHdr."Posting Date", 3);

                CASE intMonth OF
                    1:
                        cdMonthName := 'JAN';
                    2:
                        cdMonthName := 'FEB';
                    3:
                        cdMonthName := 'MAR';
                    4:
                        cdMonthName := 'APR';
                    5:
                        cdMonthName := 'MAY';
                    6:
                        cdMonthName := 'JUN';
                    7:
                        cdMonthName := 'JUL';
                    8:
                        cdMonthName := 'AUG';
                    9:
                        cdMonthName := 'SEP';
                    10:
                        cdMonthName := 'OCT';
                    11:
                        cdMonthName := 'NOV';
                    12:
                        cdMonthName := 'DEC';
                END;

                IF intMonth < 4 THEN BEGIN
                    cdFinYear := FORMAT(intYear - 1) + '-' + FORMAT(intYear - 2000);
                    cdQuarter := 'Q4';
                END
                ELSE
                    IF intMonth < 7 THEN BEGIN
                        cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                        cdQuarter := 'Q1';
                    END
                    ELSE
                        IF intMonth < 10 THEN BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q2';
                        END
                        ELSE BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q3';
                        END;

                SalesRegister."Fin. Year" := cdFinYear;
                SalesRegister.Quarter := cdQuarter;
                SalesRegister."Month Name" := cdMonthName;
                SalesRegister.Year := intYear;
                SalesRegister.Month := intMonth;
                SalesRegister.Day := intDay;

                // Date Treatment Ends

                SalesRegister.Type := Type;
                SalesRegister."No." := "No.";
                SalesRegister."Variant Code" := "Variant Code";
                SalesRegister."Item Description" := Description;
                // SalesRegister."Gross Weight"  := Item."Gross Weight"; //acxcp_01112021
                SalesRegister."Gross Weight" := lSalesCrMemoLine."Gross Weight";
                // SalesRegister."Net Weight"   := Item."Net Weight";
                SalesRegister."Net Weight" := lSalesCrMemoLine."Net Weight";
                //  SalesRegister."Units per Parcel" := Item."Units per Parcel";
                SalesRegister."Units per Parcel" := lSalesCrMemoLine."Units per Parcel";
                SalesRegister."Unit of Measure" := "Unit of Measure Code";
                IF SalesRegister."Variant Code" <> '' THEN BEGIN
                    ItemVariant.GET(SalesRegister."No.", SalesRegister."Variant Code");
                    SalesRegister."Variant Description" := ItemVariant.Description;
                END;

                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    Item.GET("No.");
                    //16767  SalesRegister."Excise Prod. Posting Group" := Item."Excise Prod. Posting Group";
                    SalesRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                    SalesRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                    SalesRegister."Item Category Code" := Item."Item Category Code";
                    IF Item."Item Category Code" <> '' THEN BEGIN
                        ICC.GET(Item."Item Category Code");
                        SalesRegister."Item Category Description" := ICC.Description;
                    END;

                    //16767 New Code
                    ICC.GET(Item."Item Category Code");
                    SalesRegister."Item Category Code" := ICC."Parent Category";
                    IF ICC."Parent Category" <> '' THEN BEGIN

                        SalesRegister."Item Category Description" := ICC.Description;
                    END;

                    //16767 End



                    //16767  SalesRegister."Product Group Code" := Item."Product Group Code";
                    SalesRegister."Product Group Code" := Item."Item Category Code";
                    //  IF Item."Product Group Code" <> '' THEN BEGIN
                    // PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                    // SalesRegister."Product Group Description" := PGC.Description ;
                    // END ;far150519

                END;
                SalesRegister.Quantity := -Quantity;
                SalesRegister."Unit Price" := -"Unit Price";
                SalesRegister.Amount := -(Quantity * "Unit Price");
                SalesRegister."Line Discount Amount" := -"Line Discount Amount";
                SalesRegister."Line Amount" := -"Line Amount";
                //16767 SalesRegister."Actual Tax %" := "Tax %";

                SalesRegister."TCS Nature of Collection" := "TCS Nature of Collection"; //ACXCP_04102021
                TdsEntry.Reset();//16767 New Code Add
                TdsEntry.SetRange("Document No.", "Document No.");
                if TdsEntry.FindSet() then begin
                    repeat
                        //16767  SalesRegister."TCS Amount" := -"TDS/TCS Amount";//ACXCP_04102021
                        SalesRegister."TCS Amount" := -(TdsEntry."TCS Amount");
                    until TdsEntry.Next() = 0;
                end; //16767 end

                /*  SalesRegister."Excise Base Amount" :=- "Excise Base Amount" ;
                 SalesRegister."Excise Amount" := -"Excise Amount" ;
                 SalesRegister."BED Amount" := -"BED Amount" ;
                 SalesRegister."ECess Amount" := -"eCess Amount" ;
                 SalesRegister."SHECess Amount" := -"SHE Cess Amount" ;
                 SalesRegister."SAED Amount" := -"SAED Amount" ;
                 SalesRegister."Assessable Value":= -"Assessable Value";
                 SalesRegister."MRP Price":= -"MRP Price" ;
                 SalesRegister."Abatement %":= -"Abatement %"; *///16767
                                                                 /*  recExcisePostingSetup.RESET;
                                                                  recExcisePostingSetup.SETRANGE("Excise Bus. Posting Group", "Excise Bus. Posting Group");
                                                                  recExcisePostingSetup.SETRANGE("Excise Prod. Posting Group", "Excise Prod. Posting Group");
                                                                  recExcisePostingSetup.SETFILTER("From Date", '<=%1', "Posting Date");
                                                                  IF recExcisePostingSetup.FIND('+') THEN BEGIN
                                                                      SalesRegister."BED %" := recExcisePostingSetup."BED %";
                                                                      SalesRegister."ECess %" := recExcisePostingSetup."eCess %";
                                                                      SalesRegister."SHECess %" := recExcisePostingSetup."SHE Cess %";
                                                                      SalesRegister."SAED %" := recExcisePostingSetup."SAED %";
                                                                  END ELSE BEGIN
                                                                      SalesRegister."BED %" := 0;
                                                                      SalesRegister."ECess %" := 0;
                                                                      SalesRegister."SHECess %" := 0;
                                                                      SalesRegister."SAED %" := 0;
                                                                  END; */ //16767 Table Not Found

                //acxcp
                recVle.RESET;
                recVle.SETRANGE("Document No.", "Document No.");
                recVle.SETRANGE("Item No.", "No.");
                recVle.SETRANGE("Document Line No.", "Line No.");
                IF recVle.FINDFIRST THEN BEGIN
                    recile.RESET;
                    recile.SETRANGE("Entry No.", recVle."Item Ledger Entry No.");
                    //   recile.SETRANGE("Item No.",recVle."Item No.");
                    IF recile.FINDFIRST THEN BEGIN
                        SalesRegister."Lot No." := recile."Lot No.";
                        recLotInfo.RESET;
                        recLotInfo.SETRANGE("Lot No.", recile."Lot No.");
                        recLotInfo.SETRANGE("Item No.", recile."Item No.");
                        IF recLotInfo.FINDFIRST THEN BEGIN
                            SalesRegister."MFG Date" := recLotInfo."MFG Date";
                            SalesRegister."Expiration Date" := recLotInfo."Expiration Date";
                        END;
                    END;
                END;
                //acxcp


                /*  SalesRegister."Service Tax Base Amount" := -"Service Tax Base";
                 SalesRegister."Service Tax Amount" := -"Service Tax Amount";
                 SalesRegister."Service Tax eCess Amount" := -"Service Tax eCess Amount";
                 SalesRegister."Service Tax SHECess Amount" := -"Service Tax SHE Cess Amount";
                 SalesRegister."Service Tax Group" := "Service Tax Group";
                 SalesRegister."Service Tax Registration No." := "Service Tax Registration No.";
                 recServiceTaxSetup.RESET;
                 recServiceTaxSetup.SETRANGE(Code, "Service Tax Group");
                 recServiceTaxSetup.SETFILTER("From Date", '<=%1', "Posting Date");
                 IF recServiceTaxSetup.FIND('-') THEN BEGIN
                     SalesRegister."Service Tax %" := recServiceTaxSetup."Service Tax %";
                     SalesRegister."Service Tax eCess %" := recServiceTaxSetup."eCess %";
                     SalesRegister."Service Tax SHECess %" := recServiceTaxSetup."SHE Cess %";
                 END ELSE BEGIN
                     SalesRegister."Service Tax %" := 0;
                     SalesRegister."Service Tax eCess %" := 0;
                     SalesRegister."Service Tax SHECess %" := 0;
                 END; */ //16767 Table Not Found



                SalesRegister."TDS Base Amount" := 0;
                SalesRegister."TDS Amount" := 0;
                SalesRegister."eCESS on TDS Amount" := 0;
                SalesRegister."SHE Cess on TDS Amount" := 0;
                SalesRegister."TDS Nature of Deduction" := '';
                SalesRegister."TDS %" := 0;
                SalesRegister."eCESS % on TDS" := 0;
                SalesRegister."SHE Cess % On TDS" := 0;

                /* IF "Tax Base Amount" = 0 THEN
                    SalesRegister."Tax Base Amount" := -("Line Amount" + "Excise Amount")
                ELSE
                    SalesRegister."Tax Base Amount" := -("Tax Base Amount");
                SalesRegister."Tax Amount" := -"Tax Amount"; */ //16767 field not found


                SalesRegister."Tax Group Code" := "Tax Group Code";
                SalesRegister."Tax Area" := "Tax Area Code";

                IF "Tax Area Code" <> '' THEN BEGIN
                    TaxAreaLine.RESET;
                    TaxAreaLine.SETRANGE("Tax Area", "Tax Area Code");
                    TaxAreaLine.FIND('-');
                    SalesRegister."Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";

                    TaxJuris.GET(TaxAreaLine."Tax Jurisdiction Code");
                    //16767 SalesRegister."Tax Type" := TaxJuris."Tax Type";

                    AddTaxAmt := 0;
                    TaxAmt := 0;
                    TaxPer := 0;
                    AddTaxPer := 0;
                    /* IF "Tax Amount" <> 0 THEN BEGIN
                        DtlTaxEntry.RESET;
                        DtlTaxEntry.SETCURRENTKEY("Document No.", "Document Line No.", "Main Component Entry No.",
                                                  "Deferment No.", "Tax Jurisdiction Code", "Entry Type");
                        DtlTaxEntry.SETRANGE("Document No.", "Document No.");
                        DtlTaxEntry.SETRANGE("Document Line No.", "Line No.");
                        IF DtlTaxEntry.FIND('-') THEN
                            REPEAT
                                TaxAreaLine2.GET(DtlTaxEntry."Tax Area Code", DtlTaxEntry."Tax Jurisdiction Code");
                                IF TaxAreaLine2."Calculation Order" <= 1 THEN BEGIN
                                    TaxAmt += -(DtlTaxEntry."Tax Amount");
                                    TaxPer := DtlTaxEntry."Tax %";
                                END ELSE BEGIN
                                    AddTaxAmt += -(DtlTaxEntry."Tax Amount");
                                    AddTaxPer := DtlTaxEntry."Tax %";
                                END;
                            UNTIL DtlTaxEntry.NEXT = 0;
                    END; */ //16767 Table Not Found

                    IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::CST THEN
                        SalesRegister."CST Amount" := TaxAmt
                    ELSE
                        SalesRegister."VAT Amount" := TaxAmt;
                    SalesRegister."Addn. Tax Amount" := AddTaxAmt;
                    SalesRegister."Tax %" := TaxPer;
                    SalesRegister."Addn. Tax %" := AddTaxPer;
                END;
                IF SalesRegister."Tax Type" = SalesRegister."Tax Type"::" " THEN
                    SalesRegister."Tax Type" := SalesRegister."Tax Type"::VAT;
                //16767  SalesRegister."Form Code" := lSalesCrMemoHdr."Form Code";
                //16767  SalesRegister."Form No." := lSalesCrMemoHdr."Form No.";
                SalesRegister."Line Discount %" := "Line Discount %";
                SalesRegister."Applies-to Doc. Type" := lSalesCrMemoHdr."Applies-to Doc. Type";
                SalesRegister."Applies-to Doc. No." := lSalesCrMemoHdr."Applies-to Doc. No.";

                SalesRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                SalesRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //16767 SalesRegister."T.I.N. No." := Cust."T.I.N. No.";
                SalesRegister."No. Series" := lSalesCrMemoHdr."No. Series";

                SalesRegister."Net Amount" := -(AmtToCust.GetAmttoVendorPostedDoc(lSalesCrMemoLine."Document No."));//16767 "Amount To Customer";


                decFreight := 0;
                decInsurance := 0;
                decTD := 0;
                decCD := 0;
                decSD := 0;
                decSSD := 0;


                /*  recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Cr.Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Cr.Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'INSURANCE');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     //         REPEAT //ACX-RK 10042021
                     decInsurance := recPostedStrOrderDetail.Amount;
                 //         UNTIL recPostedStrOrderDetail.NEXT =0; //ACX-RK 10042021


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'C.DISC');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     //         REPEAT //ACX-RK 10042021
                     decCD := recPostedStrOrderDetail.Amount;
                 //         UNTIL recPostedStrOrderDetail.NEXT =0; //ACX-RK 10042021
                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Cr.Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Cr.Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'S.DISC');
                 IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                     REPEAT
                         decSD += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;
                 END;
                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'DEALER DIS');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     //         REPEAT //ACX-RK 10042021
                     decTD := recPostedStrOrderDetail.Amount;
                 //         UNTIL recPostedStrOrderDetail.NEXT =0; //ACX-RK 10042021


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Cr.Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Cr.Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FREIGHT');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     //         REPEAT //ACX-RK 10042021
                     decFreight := recPostedStrOrderDetail.Amount;
                 //         UNTIL recPostedStrOrderDetail.NEXT =0; //ACX-RK 10042021

                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Cr.Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Cr.Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'S.S.DISC');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     //         REPEAT //ACX-RK 10042021
                     decSSD := recPostedStrOrderDetail.Amount;
                 //         UNTIL recPostedStrOrderDetail.NEXT =0; //ACX-RK 10042021

                 //FAR26122019 BEGIN
                 decBD := 0;
                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Cr.Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Cr.Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'BULK DIS');
                 IF recPostedStrOrderDetail.FIND('-') THEN BEGIN
                     //         REPEAT //ACX-RK 10042021
                     decBD := recPostedStrOrderDetail.Amount;
                     //         UNTIL recPostedStrOrderDetail.NEXT =0; //ACX-RK 10042021
                 END; */ //16767 Table Not Found
                         //FAR26122019 END
                SalesRegister.Freight := ABS(decFreight);
                SalesRegister.Insurance := ABS(decInsurance);
                SalesRegister."Trade Discount" := ABS(decTD);
                SalesRegister."Cash Discount" := ABS(decCD);
                SalesRegister."Scheme Discount" := ABS(decSD);
                SalesRegister."Special Sch. Disc" := ABS(decSSD);
                SalesRegister."Bulk Disc" := ABS(decBD);//FAR26122019



                //FAR BEGIN 03012020
                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'CGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."CGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."CGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");
                END;

                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'SGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."SGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."SGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");

                END;

                recDtGSTLedg.RESET();
                recDtGSTLedg.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDtGSTLedg.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                recDtGSTLedg.SETRANGE("GST Component Code", 'IGST');
                IF recDtGSTLedg.FIND('-') THEN BEGIN
                    SalesRegister."IGST %" := ABS(recDtGSTLedg."GST %");
                    SalesRegister."IGST Amount" := -1 * (recDtGSTLedg."GST Amount");
                    SalesRegister."GST Base Amount" := -1 * (recDtGSTLedg."GST Base Amount");
                    SalesRegister."GST Group" := recDtGSTLedg."GST Group Code";
                    SalesRegister."HSN/SAC Code" := recDtGSTLedg."HSN/SAC Code";
                    SalesRegister."Location Reg. No." := recDtGSTLedg."Location  Reg. No.";
                    SalesRegister."Customer Reg. No." := recDtGSTLedg."Buyer/Seller Reg. No.";
                    SalesRegister."GST Place of Supply" := FORMAT(recDtGSTLedg."GST Place of Supply");

                END;



                SalesRegister."Total GST Amount" := ABS(SalesRegister."CGST Amount" + SalesRegister."SGST Amount" + SalesRegister."IGST Amount" +
                SalesRegister."Cess Amount" + SalesRegister."Addl. Cess Amount");

                //FAR END 03012020

                IF ("Gen. Prod. Posting Group" <> '') AND ("Gen. Bus. Posting Group" <> '') THEN BEGIN
                    IF GPS.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN BEGIN
                        SalesRegister."Revenue Account Code" := GPS."Sales Account";
                        IF GLAcc.GET(GPS."Sales Account") THEN
                            SalesRegister."Revenue Account Description" := GLAcc.Name;
                    END;
                END;

                IF (lSalesCrMemoHdr."Customer Posting Group" <> '') THEN BEGIN
                    CPG.GET(lSalesCrMemoHdr."Customer Posting Group");
                    SalesRegister."Receivable Account Code" := CPG."Receivables Account";
                    IF GLAcc.GET(CPG."Receivables Account") THEN
                        SalesRegister."Receivable Account Description" := GLAcc.Name;
                END;
                //Sales Hierarchy
                recSaleCrHead.RESET();
                recSaleCrHead.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
                IF recSaleCrHead.FINDFIRST THEN BEGIN
                    recSalesHier.RESET();
                    recSalesHier.SETRANGE("FO Code", recSaleCrHead."Salesperson Code");
                    IF recSalesHier.FINDFIRST THEN BEGIN
                        SalesRegister."FO Code" := recSalesHier."FO Code";
                        SalesRegister."FO Name" := recSalesHier."FO Name";
                        SalesRegister."FA Code" := recSalesHier."FA Code";
                        SalesRegister."FA Name" := recSalesHier."FA Name";
                        SalesRegister."TME Code" := recSalesHier."TME Code";
                        SalesRegister."TME Name" := recSalesHier."TME Name";
                        SalesRegister."RME Code" := recSalesHier."RME Code";
                        SalesRegister."RME Name" := recSalesHier."RME Name";
                        SalesRegister."ZMM Code" := recSalesHier."ZMM Code";
                        SalesRegister."ZMM Name" := recSalesHier."ZMM Name";
                        SalesRegister."HOD Code" := recSalesHier."HOD Code";
                        SalesRegister."HOD Name" := recSalesHier."HOD Name";
                    END ELSE BEGIN
                        recSalesHier.RESET();
                        recSalesHier.SETRANGE("FA Code", recSalesInvHead."Salesperson Code");
                        recSalesHier.SETFILTER("Start Date", '<=%1', recSalesInvHead."Posting Date");
                        IF recSalesHier.FINDFIRST THEN BEGIN
                            SalesRegister."FO Code" := recSalesHier."FA Code";
                            SalesRegister."FO Name" := recSalesHier."FA Name";
                            SalesRegister."FA Code" := recSalesHier."FA Code";
                            SalesRegister."FA Name" := recSalesHier."FA Name";
                            SalesRegister."TME Code" := recSalesHier."TME Code";
                            SalesRegister."TME Name" := recSalesHier."TME Name";
                            SalesRegister."RME Code" := recSalesHier."RME Code";
                            SalesRegister."RME Name" := recSalesHier."RME Name";
                            SalesRegister."ZMM Code" := recSalesHier."ZMM Code";
                            SalesRegister."ZMM Name" := recSalesHier."ZMM Name";
                            SalesRegister."HOD Code" := recSalesHier."HOD Code";
                            SalesRegister."HOD Name" := recSalesHier."HOD Name";
                        END;
                    END;
                END;
                //Sales Hierarchy
                SalesRegister.INSERT;
            END;
            "Exported to Sales Register" := TRUE;
            MODIFY;

        END;
    end;


    procedure InsertTransShpt(var lTransShptHdr: Record 5744)
    var
        lTransShptLine: Record 5745;
    begin
        NetAmt := 0;
        lTransShptLine.RESET;
        lTransShptLine.SETRANGE("Document No.", lTransShptHdr."No.");
        lTransShptLine.SETFILTER("Item No.", '<>%1', '');
        lTransShptLine.SETRANGE("Exported to Sales Register", FALSE);
        IF lTransShptLine.FIND('-') THEN BEGIN
            REPEAT
                WITH lTransShptLine DO BEGIN

                    Loc.GET("Transfer-from Code");
                    Loc2.GET("Transfer-to Code");
                    SalesRegister.INIT;
                    SalesRegister."Document Type" := SalesRegister."Document Type"::"Transfer Shpt.";
                    //      SalesRegister."Gen. Journal Template Code" := lTransShptHdr."Gen. Journal Template Code" ;
                    SalesRegister."Source Document No." := "Document No.";
                    SalesRegister."Source Line No." := "Line No.";
                    SalesRegister."Posting Date" := lTransShptHdr."Posting Date";
                    SalesRegister."Order No." := lTransShptHdr."Transfer Order No.";
                    SalesRegister."Source Line Description" := Description;
                    SalesRegister."Source Line Description 2" := "Description 2"; //ACXCP_03012022
                    SalesRegister."Source Type" := SalesRegister."Source Type"::Location;
                    SalesRegister."Source No." := Loc2.Code;
                    SalesRegister."Source Name" := Loc2.Name;
                    SalesRegister."Source City" := Loc2.City;
                    SalesRegister."LR/RR No." := lTransShptHdr."LR/RR No.";
                    SalesRegister."LR/RR Date" := lTransShptHdr."LR/RR Date";
                    //acxav - BEGIN
                    SalesRegister."External Document No." := lTransShptHdr."External Document No.";
                    //acxav - end

                    SalesRegister."Source State Code" := Loc2."State Code";
                    SalesRegister."Global Dimension 1 Code" := lTransShptHdr."Shortcut Dimension 1 Code";
                    IF recState.GET(Loc2."State Code") THEN BEGIN
                        SalesRegister."Source State Name" := recState.Description;
                    END;
                    SalesRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                    IF GPPG.GET("Gen. Prod. Posting Group") THEN;
                    SalesRegister."GPPG Description" := GPPG.Description;
                    SalesRegister."Country/Region Code" := Loc2."Country/Region Code";
                    IF Loc2."Country/Region Code" <> '' THEN BEGIN
                        Country.GET(Loc2."Country/Region Code");
                        SalesRegister."Country/Region Name" := Country.Name;
                    END;
                    SalesRegister."Outward Location Code" := Loc.Code;
                    SalesRegister."Outward State Code" := Loc."State Code";
                    IF recState.GET(Loc."State Code") THEN BEGIN
                        SalesRegister."Outward State Name" := recState.Description;
                    END;
                    //      SalesRegister."Location Type" := Loc."Location Type";

                    intDay := DATE2DMY(lTransShptHdr."Posting Date", 1);
                    intMonth := DATE2DMY(lTransShptHdr."Posting Date", 2);
                    intYear := DATE2DMY(lTransShptHdr."Posting Date", 3);

                    CASE intMonth OF
                        1:
                            cdMonthName := 'JAN';
                        2:
                            cdMonthName := 'FEB';
                        3:
                            cdMonthName := 'MAR';
                        4:
                            cdMonthName := 'APR';
                        5:
                            cdMonthName := 'MAY';
                        6:
                            cdMonthName := 'JUN';
                        7:
                            cdMonthName := 'JUL';
                        8:
                            cdMonthName := 'AUG';
                        9:
                            cdMonthName := 'SEP';
                        10:
                            cdMonthName := 'OCT';
                        11:
                            cdMonthName := 'NOV';
                        12:
                            cdMonthName := 'DEC';
                    END;

                    IF intMonth < 4 THEN BEGIN
                        cdFinYear := FORMAT(intYear - 1) + '-' + FORMAT(intYear - 2000);
                        cdQuarter := 'Q4';
                    END
                    ELSE
                        IF intMonth < 7 THEN BEGIN
                            cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                            cdQuarter := 'Q1';
                        END
                        ELSE
                            IF intMonth < 10 THEN BEGIN
                                cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                                cdQuarter := 'Q2';
                            END
                            ELSE BEGIN
                                cdFinYear := FORMAT(intYear) + '-' + FORMAT(intYear - 2000 + 1);
                                cdQuarter := 'Q3';
                            END;

                    SalesRegister."Fin. Year" := cdFinYear;
                    SalesRegister.Quarter := cdQuarter;
                    SalesRegister."Month Name" := cdMonthName;
                    SalesRegister.Year := intYear;
                    SalesRegister.Month := intMonth;
                    SalesRegister.Day := intDay;

                    // Date Treatment Ends

                    SalesRegister."No." := "Item No.";
                    SalesRegister."Variant Code" := "Variant Code";
                    SalesRegister."Item Description" := Description;
                    //acxcp_060722+ //gross weight wrong
                    Item.RESET;
                    Item.SETRANGE("No.", lTransShptLine."Item No.");
                    IF Item.FINDFIRST THEN BEGIN
                        SalesRegister."Gross Weight" := Item."Gross Weight";
                        SalesRegister."Net Weight" := Item."Net Weight";
                        SalesRegister."Units per Parcel" := Item."Units per Parcel";
                        SalesRegister."Unit of Measure" := "Unit of Measure Code";
                    END;
                    //acxcp_060722- //gross weight wrong

                    //      SalesRegister."Gross Weight"  := Item."Gross Weight";
                    //      SalesRegister."Net Weight"   := Item."Net Weight";
                    //      SalesRegister."Units per Parcel" := Item."Units per Parcel";
                    //      SalesRegister."Unit of Measure" := "Unit of Measure Code";
                    IF SalesRegister."Variant Code" <> '' THEN BEGIN
                        ItemVariant.GET(SalesRegister."No.", SalesRegister."Variant Code");
                        SalesRegister."Variant Description" := ItemVariant.Description;
                    END;
                    /*  recExcisePostingSetup.RESET;
                     recExcisePostingSetup.SETRANGE("Excise Bus. Posting Group", "Excise Bus. Posting Group");
                     recExcisePostingSetup.SETRANGE("Excise Prod. Posting Group", "Excise Prod. Posting Group");
                     recExcisePostingSetup.SETFILTER("From Date", '<=%1', lTransShptHdr."Posting Date");
                     IF recExcisePostingSetup.FIND('+') THEN BEGIN
                         SalesRegister."BED %" := recExcisePostingSetup."BED %";
                         SalesRegister."ECess %" := recExcisePostingSetup."eCess %";
                         SalesRegister."SHECess %" := recExcisePostingSetup."SHE Cess %";
                         SalesRegister."SAED %" := recExcisePostingSetup."SAED %";
                     END ELSE BEGIN
                         SalesRegister."BED %" := 0;
                         SalesRegister."ECess %" := 0;
                         SalesRegister."SHECess %" := 0;
                         SalesRegister."SAED %" := 0;
                     END; */ //16767 Table Not Found

                    IF ("Item No." <> '') THEN BEGIN
                        Item.GET("Item No.");
                        //16767 SalesRegister."Excise Prod. Posting Group" := Item."Excise Prod. Posting Group";
                        SalesRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                        SalesRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                        SalesRegister."Item Category Code" := Item."Item Category Code";

                        IF Item."Item Category Code" <> '' THEN BEGIN
                            ICC.GET(Item."Item Category Code");
                            SalesRegister."Item Category Description" := ICC.Description;
                        END;


                        //16767 Start New
                        SalesRegister."Item Category Code" := ICC."Parent Category";
                        ICC.GET(Item."Item Category Code");
                        IF ICC."Parent Category" <> '' THEN BEGIN

                            SalesRegister."Item Category Description" := ICC.Description;
                        END;

                        //16767 End

                        //16767  SalesRegister."Product Group Code" := Item."Product Group Code";
                        SalesRegister."Product Group Code" := Item."Item Category Code";
                        //IF Item."Product Group Code" <> '' THEN BEGIN
                        // PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                        //SalesRegister."Product Group Description" := PGC.Description ;
                        //END ;far150519

                    END;
                    SalesRegister.Quantity := Quantity;
                    SalesRegister."Unit Price" := "Unit Price";
                    SalesRegister.Amount := Quantity * "Unit Price";

                    /*  SalesRegister."Excise Base Amount" := "Excise Base Amount" ;
                     SalesRegister."Excise Amount" := "Excise Amount" ;
                     SalesRegister."BED Amount" := "BED Amount" ;
                     SalesRegister."ECess Amount" := "eCess Amount" ;
                     SalesRegister."SHECess Amount" := "SHE Cess Amount" ;
                     SalesRegister."SAED Amount" := "SAED Amount" ;
                     SalesRegister."Assessable Value":= "Assessable Value";
                     SalesRegister."MRP Price":= "MRP Price" ;
                     SalesRegister."Abatement %":= "Abatement %"; */ //16767

                    //acxcp
                    recile.RESET;
                    recile.SETRANGE("Document No.", "Document No.");
                    recile.SETRANGE("Document Line No.", "Line No.");
                    recile.SETRANGE("Item No.", "Item No.");
                    IF recile.FINDFIRST THEN BEGIN
                        SalesRegister."Lot No." := recile."Lot No.";
                        recLotInfo.RESET;
                        recLotInfo.SETRANGE("Lot No.", recile."Lot No.");
                        recLotInfo.SETRANGE("Item No.", recile."Item No.");
                        IF recLotInfo.FINDFIRST THEN BEGIN
                            SalesRegister."MFG Date" := recLotInfo."MFG Date";
                            SalesRegister."Expiration Date" := recLotInfo."Expiration Date";
                        END;
                    END;
                    //acxcp

                    decFreight := 0;
                    decInsurance := 0;
                    decTD := 0;
                    decCD := 0;
                    decSD := 0;
                    decBD := 0;


                    /* recPostedStrOrderDetail.RESET;
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                    recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'INSURANCE');
                    IF recPostedStrOrderDetail.FIND('-') THEN
                        REPEAT
                            decInsurance := recPostedStrOrderDetail.Amount;
                        UNTIL recPostedStrOrderDetail.NEXT = 0;

                    recPostedStrOrderDetail.RESET;
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                    recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'C.DISC');
                    IF recPostedStrOrderDetail.FIND('-') THEN
                        REPEAT
                            decCD := recPostedStrOrderDetail.Amount;
                        UNTIL recPostedStrOrderDetail.NEXT = 0;
                    recPostedStrOrderDetail.RESET;
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                    recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'S.DISC');
                    IF recPostedStrOrderDetail.FIND('-') THEN
                        REPEAT
                            decSD := recPostedStrOrderDetail.Amount;
                        UNTIL recPostedStrOrderDetail.NEXT = 0;

                    recPostedStrOrderDetail.RESET;
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                    recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'DEALER DIS');
                    IF recPostedStrOrderDetail.FIND('-') THEN
                        REPEAT
                            decTD := recPostedStrOrderDetail.Amount;
                        UNTIL recPostedStrOrderDetail.NEXT = 0;







                    recPostedStrOrderDetail.RESET;
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Sales Invoice Line"."Document No.");
                    recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Sales Invoice Line"."Line No.");
                    recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FREIGHT');
                    IF recPostedStrOrderDetail.FIND('-') THEN
                        REPEAT
                            decFreight := recPostedStrOrderDetail.Amount;
                        UNTIL recPostedStrOrderDetail.NEXT = 0; */ //16767 Table Not Found

                    SalesRegister.Freight := ABS(decFreight);
                    SalesRegister.Insurance := ABS(decInsurance);
                    SalesRegister."Trade Discount" := ABS(decTD);
                    SalesRegister."Cash Discount" := ABS(decCD);
                    SalesRegister."Scheme Discount" := ABS(decSD);

                    SalesRegister."Net Amount" := Amount + /* "Excise Amount" */ +decTD + decCD + decSD + decOffSeason + decFreight; //16767 Field Not found

                    /*IF (lTransShptHdr."Transfer-from Code" <> '') AND (lTransShptHdr."Transfer-to Code" <> '') AND
                                         ("Gen. Prod. Posting Group" <> '') THEN BEGIN
            //           IF TrfActSetup.GET(lTransShptHdr."Transfer-from Code", lTransShptHdr."Transfer-to Code",
            //                     "Gen. Prod. Posting Group") THEN BEGIN
            //              IF TrfActSetup."Transfer Sales A/c" <> '' THEN BEGIN
            //                 SalesRegister."Revenue Account Code" := TrfActSetup."Transfer Sales A/c" ;
            //                 GLAcc.GET(TrfActSetup."Transfer Sales A/c");
                             SalesRegister."Revenue Account Description" := GLAcc.Name;
                             END ;
            //              IF TrfActSetup."Transfer-To Branch A/c" <> '' THEN BEGIN
            //                 SalesRegister."Receivable Account Code" := TrfActSetup."Transfer-To Branch A/c" ;
            //                 GLAcc.GET(TrfActSetup."Transfer-To Branch A/c");
                             SalesRegister."Receivable Account Description" := GLAcc.Name; */
                END;
                //END;
                //        END;
                SalesRegister."Responsibility Center" := Loc."Responsibility Center";//KM
                SalesRegister.INSERT;
                lTransShptLine."Exported to Sales Register" := TRUE;
                lTransShptLine.MODIFY;
            UNTIL lTransShptLine.NEXT = 0;



        END;

    end;
}

