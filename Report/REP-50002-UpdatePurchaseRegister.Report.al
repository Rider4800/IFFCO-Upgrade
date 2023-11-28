report 50002 "Update Purchase Register"
{
    // acxcp_110322 //code edit due to round off g/l error
    // //acxcp_10012023 //GR No.& Date

    Permissions = TableData 123 = rmd,
                  TableData 125 = rmd;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                WHERE("Exported to Purch. Register" = FILTER(false),
                                      "Buy-from Vendor No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin

                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;

                InsertPurchInv("Purch. Inv. Line");
            end;

            trigger OnPreDataItem()
            begin
                //"Purch. Inv. Line".SETFILTER("Document No.",'<>%1','PI/2020/00273');
                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transferring Purchases Data....\\' +
                            '@1@@@@@@@@@@@@@@@@@@@@@@@@@',
                            RemainingStatus);
                TotalRec := COUNT;

                IF NOT blnRunSale THEN
                    CurrReport.BREAK;
            end;
        }
        dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                WHERE("Exported to Purch. Register" = FILTER(FALSE),
                                      "Buy-from Vendor No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin

                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;

                InsertPurchCrMemo("Purch. Cr. Memo Line");
            end;

            trigger OnPreDataItem()
            begin

                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transfering Purchase Return Data....\\' +
                            '@1@@@@@@@@@@@@@@@@@@@@@@@@@',
                            RemainingStatus);
                TotalRec := COUNT;

                IF NOT blnRunSaleCr THEN
                    CurrReport.BREAK;
            end;
        }
        dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
        {

            trigger OnAfterGetRecord()
            begin

                RowNo += 1;
                RemainingStatus := ROUND((RowNo / TotalRec) * 10000, 1);
                Window.UPDATE;

                InsertTransRcpt("Transfer Receipt Header");
            end;

            trigger OnPreDataItem()
            begin

                RemainingStatus := 0;
                RowNo := 0;
                Window.OPEN('Transfering Trf. Receipt Data....\\' +
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
                    field("Update Purchase"; blnRunSale)
                    {
                    }
                    field("Update Purchase Cr Memo"; blnRunSaleCr)
                    {
                    }
                    field("Update Transfer Receipt"; blnRunTransShpt)
                    {
                    }
                }
                group("Delete Data")
                {
                    field("Regenerate Purchase"; blnRegenerateSales)
                    {
                    }
                    field("Regenerate  Purchase Cr Memo"; blnRegenerateSalesCr)
                    {
                    }
                    field("Regenerate Transfer Receipt"; blnRegenerateTransShpt)
                    {
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
        MESSAGE('Update Completed');
    end;

    trigger OnPreReport()
    begin

        IF blnRegenerateSales THEN BEGIN
            PurchaseRegister.RESET;
            PurchaseRegister.SETRANGE("Document Type", PurchaseRegister."Document Type"::"Purchase Invoice");
            PurchaseRegister.DELETEALL;

            lPurchInvLine.RESET;
            lPurchInvLine.MODIFYALL("Exported to Purch. Register", FALSE);
        END;

        IF blnRegenerateSalesCr THEN BEGIN
            PurchaseRegister.RESET;
            PurchaseRegister.SETRANGE("Document Type", PurchaseRegister."Document Type"::"Purchase Cr. Memo");
            PurchaseRegister.DELETEALL;

            lPurchCrMemoLine.RESET;
            lPurchCrMemoLine.MODIFYALL("Exported to Purch. Register", FALSE);
        END;

        IF blnRegenerateTransShpt THEN BEGIN
            PurchaseRegister.RESET;
            PurchaseRegister.SETFILTER("Document Type", '%1|%2', PurchaseRegister."Document Type"::"Transfer Shpt.",
                                                              PurchaseRegister."Document Type"::"Transfer Rcpt.");
            PurchaseRegister.DELETEALL;

            //   lTransShptLine.RESET ;
            //   lTransShptLine.MODIFYALL("Exported to Purch. Register", FALSE) ;

            lTransRcptHdr.RESET;
            lTransRcptHdr.MODIFYALL("Exported to Purch. Register", FALSE);
        END;
    end;

    var
        PurchaseRegister: Record 50001;
        Vend: Record 23;
        Loc: Record 14;
        Item: Record 27;
        GenJnlTemplate: Record 80;
        blnRegenerateSales: Boolean;
        ItemVariant: Record 5401;
        VPG: Record 93;
        PurchaseRegister1: Record 50001;
        Loc1: Record 14;
        //16767  DtlTaxEntry: Record 16522;
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
        //17144   GLEntry: Record1;
        //17144 TaxAreaLine: Record31;
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
        recState: Record STATE;
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
        decFreight: Decimal;
        decOffSeason: Decimal;
        //16767 recPostedStrOrderDetail: Record 13798;
        Loc2: Record 14;
        //16767recExcisePostingSetup: Record 13711;
        //16767  recServiceTaxSetup: Record 16472;
        decCustom: Decimal;
        lPurchInvLine: Record 123;
        lPurchCrMemoLine: Record 125;
        lTransRcptHdr: Record 5747;
        decEAC: Decimal;
        decEdcess: Decimal;
        decEcessac: Decimal;
        decSugarCess: Decimal;
        decInsurance: Decimal;
        decCharge: Decimal;
        recVendor: Record 23;
        recPurRecipt: Record 121;
        recPO: Record 39;
        recPOH: Record 38;
        recOrAdd: Record 224;
        recDetGSTLedEntry: Record "Detailed GST Ledger Entry";
    //17144  recPostedStrOrdrDtl: Record 13760;


    procedure InsertPurchInv(var lPurchInvLine: Record 123)
    var
        lPurchInvHeader: Record 122;
        AmtToVendor: Codeunit 50200;
        GstBaseAmt: Codeunit 50200;
        TotalGstAmt: Codeunit 50200;
        TdsEntry: Record "TDS Entry";
        IgstPer: Decimal;
        CgstPer: Decimal;
        SgstPer: Decimal;
        GetPer: Decimal;
    begin


        WITH lPurchInvLine DO BEGIN
            lPurchInvHeader.GET("Document No.");
            //IF GenJnlTemplate.GET(lPurchInvHeader."Gen. Journal Template Code") THEN;

            IF Loc.GET("Location Code") THEN;
            //IF Vend.GET("Buy-from Vendor No.") THEN;
            Vend.RESET();
            Vend.SETRANGE("No.", lPurchInvHeader."Buy-from Vendor No.");
            IF Vend.FINDFIRST THEN;
            IF VPG.GET(lPurchInvHeader."Vendor Posting Group") THEN;
            //IF recCustPriceGroup.GET(lPurchInvHeader."Customer Price Group") THEN;
            PurchaseRegister."Source Document No." := "Document No.";
            IF (Type = Type::"G/L Account") AND ("No." = VPG."Invoice Rounding Account") THEN BEGIN
                // IF (Type = Type::"G/L Account") AND ("No." = VPG."Invoice Rounding Account") AND ("Line No."<>10000) THEN BEGIN
                PurchaseRegister1.RESET;
                PurchaseRegister1.SETRANGE("Document Type", PurchaseRegister1."Document Type"::"Purchase Invoice");
                PurchaseRegister1.SETRANGE("Source Document No.", "Document No.");
                PurchaseRegister1.FIND('+');
                IF lPurchInvHeader."Currency Code" <> '' THEN BEGIN
                    //16767 PurchaseRegister1."Round Off Amount" := "Amount To Vendor" / lPurchInvHeader."Currency Factor";
                    //16767    PurchaseRegister1."Net Amount" += "Amount To Vendor" / lPurchInvHeader."Currency Factor";
                    PurchaseRegister1."Round Off Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.") / lPurchInvHeader."Currency Factor";
                    PurchaseRegister1."Net Amount" += AmtToVendor.GetAmttoVendorPostedDoc("Document No.") / lPurchInvHeader."Currency Factor";
                END ELSE BEGIN
                    //16767 PurchaseRegister1."Round Off Amount" := "Amount To Vendor";
                    //16767 PurchaseRegister1."Net Amount" += "Amount To Vendor";
                    PurchaseRegister1."Round Off Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.");
                    PurchaseRegister1."Net Amount" += AmtToVendor.GetAmttoVendorPostedDoc("Document No.");
                END;

                PurchaseRegister1.MODIFY;
            END ELSE BEGIN
                PurchaseRegister.INIT;
                PurchaseRegister."Document Type" := PurchaseRegister."Document Type"::"Purchase Invoice";
                //PurchaseRegister."Gen. Journal Template Code" := lPurchInvHeader."Gen. Journal Template Code" ;
                PurchaseRegister."Currency Code" := lPurchInvHeader."Currency Code";
                PurchaseRegister."Currency Factor" := lPurchInvHeader."Currency Factor";
                //KD-BEGIN 07122020
                IF lPurchInvHeader."Currency Factor" = 0 THEN BEGIN
                    PurchaseRegister."Exchange rate" := lPurchInvHeader."Currency Factor";
                END
                ELSE BEGIN
                    PurchaseRegister."Exchange rate" := 1 / lPurchInvHeader."Currency Factor";
                END;
                //KD-END 07122020

                //acxcp_07092021 +//PO Number update and Supplier Order date (Document Date)

                IF lPurchInvHeader."Order No." <> '' THEN BEGIN
                    PurchaseRegister."Order No." := lPurchInvHeader."Order No.";
                    PurchaseRegister."Supplier Order Date" := lPurchInvHeader."Document Date";
                END
                ELSE BEGIN
                    recPurRecipt.RESET;
                    //16767 recPurRecipt.SETRANGE("Document No.", lPurchInvLine."Receipt Document No.");
                    recPurRecipt.SETRANGE("No.", lPurchInvLine."No.");
                    //16767  recPurRecipt.SETRANGE("Line No.", lPurchInvLine."Receipt Document Line No.");
                    IF recPurRecipt.FINDFIRST THEN BEGIN
                        PurchaseRegister."Order No." := recPurRecipt."Order No.";//order no. //acxcp_16112021 //line added if PO not found in header
                        PurchaseRegister."GR No." := recPurRecipt."Document No.";//acxcp_10012023 //GR No.& Date
                        PurchaseRegister."GR Date" := recPurRecipt."Posting Date";//acxcp_10012023 //GR No.& Date
                        recPO.RESET;
                        recPO.SETRANGE("Document No.", recPurRecipt."Order No.");
                        recPO.SETRANGE("No.", recPurRecipt."No.");
                        recPO.SETRANGE("Line No.", recPurRecipt."Line No.");
                        IF recPO.FINDFIRST THEN BEGIN
                            PurchaseRegister."Order No." := recPO."Document No.";
                            recPOH.RESET;
                            recPOH.SETRANGE("No.", recPO."Document No.");
                            IF recPOH.FINDFIRST THEN BEGIN
                                PurchaseRegister."Supplier Order Date" := recPOH."Document Date";
                            END;
                        END;
                    END;
                END;

                //acxcp_07092021 -
                //acxcp_150921 + //document date of purchase inv header
                PurchaseRegister."Document Date" := lPurchInvHeader."Document Date";

                //acxcp_150921 -

                //      PurchaseRegister."Order No." :=  lPurchInvHeader."Order No.";
                PurchaseRegister."External Document No." := lPurchInvHeader."Vendor Invoice No.";
                //      PurchaseRegister."Source Document No." := "Document No." ;
                PurchaseRegister."Source Line No." := "Line No.";
                PurchaseRegister."Posting Date" := lPurchInvHeader."Posting Date";
                PurchaseRegister."B/L No." := lPurchInvHeader."Bill of Entry No."; //KD
                PurchaseRegister."B/L Date" := lPurchInvHeader."Bill of Entry Date"; //KD
                PurchaseRegister."Source Line Description" := Description;

                PurchaseRegister."Document Salesperson Code" := lPurchInvHeader."Purchaser Code";
                IF lPurchInvHeader."Purchaser Code" <> '' THEN BEGIN
                    IF Salesperson.GET(lPurchInvHeader."Purchaser Code") THEN;
                    PurchaseRegister."Document Salesperson Name" := Salesperson.Name;
                END;

                PurchaseRegister."Payment Term Code" := lPurchInvHeader."Payment Terms Code";
                PurchaseRegister."Due date" := lPurchInvHeader."Due Date";
                PurchaseRegister."Source Type" := PurchaseRegister."Source Type"::Vendor;
                PurchaseRegister."Source No." := "Buy-from Vendor No.";
                PurchaseRegister."Source Name" := Vend.Name;
                PurchaseRegister."Source City" := Vend.City;
                PurchaseRegister."Source State Code" := Vend."State Code";
                //ACX-RK 30092021 Begin
                PurchaseRegister."Supplier Name" := lPurchInvHeader."Buy-from Vendor Name";
                recOrAdd.RESET();
                recOrAdd.SETRANGE(Code, lPurchInvHeader."Order Address Code");
                IF recOrAdd.FINDFIRST THEN
                    PurchaseRegister."Consignee Name" := recOrAdd.Name;
                PurchaseRegister."Supplier GST No" := lPurchInvHeader."Vendor GST Reg. No.";
                PurchaseRegister."Supplier document Date" := lPurchInvHeader."Document Date";
                //ACX-RK End
                IF recState.GET(Vend."State Code") THEN BEGIN
                    PurchaseRegister."Source State Name" := recState.Description;
                END;
                PurchaseRegister."Vendor Posting Group" := lPurchInvHeader."Vendor Posting Group";
                //  PurchaseRegister."CPG Desc" := VPG.Description ;
                //      PurchaseRegister."Customer Price Group"   := lPurchInvHeader."Customer Price Group";
                PurchaseRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                PurchaseRegister."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                IF GBPG.GET("Gen. Bus. Posting Group") THEN;
                PurchaseRegister."GBPG Description" := GBPG.Description;
                IF GPPG.GET("Gen. Prod. Posting Group") THEN;
                PurchaseRegister."GPPG Description" := GPPG.Description;
                PurchaseRegister."Country/Region Code" := Vend."Country/Region Code";
                IF Vend."Country/Region Code" <> '' THEN BEGIN
                    Country.GET(Vend."Country/Region Code");
                    PurchaseRegister."Country/Region Name" := Country.Name;
                END;
                /*
                PurchaseRegister."Master Salesperson Code" :=Vend."Salesperson Code";
                IF Vend."Salesperson Code" <> '' THEN BEGIN
                   IF Salesperson.GET(Vend."Salesperson Code") THEN;
                   PurchaseRegister."Master Salesperson Name" := Salesperson.Name ;
                END ;
                */
                PurchaseRegister."Outward Location Code" := "Location Code";
                PurchaseRegister."Outward State Code" := Loc."State Code";
                IF recState.GET(Loc."State Code") THEN BEGIN
                    PurchaseRegister."Outward State Name" := recState.Description;
                END;
                // PurchaseRegister."Location Type" := Loc."Location Type";

                // Date Treatment Begins

                intDay := DATE2DMY(lPurchInvHeader."Posting Date", 1);
                intMonth := DATE2DMY(lPurchInvHeader."Posting Date", 2);
                intYear := DATE2DMY(lPurchInvHeader."Posting Date", 3);

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

                PurchaseRegister."Fin. Year" := cdFinYear;
                PurchaseRegister.Quarter := cdQuarter;
                PurchaseRegister."Month Name" := cdMonthName;
                PurchaseRegister.Year := intYear;
                PurchaseRegister.Month := intMonth;
                PurchaseRegister.Day := intDay;

                // Date Treatment Ends

                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    Item.GET("No.");
                    //16767    PurchaseRegister."Excise Prod. Posting Group" := Item."Excise Prod. Posting Group";
                    PurchaseRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                    PurchaseRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                    /*  PurchaseRegister."Item Category Code" := Item."Item Category Code";

                   IF Item."Item Category Code" <> '' THEN BEGIN
                       //ICC.GET(Item."Item Category Code") ;
                       PurchaseRegister."Item Category Description" := ICC.Description;
                   END; */ //16767

                    //16767 Start
                    ICC.GET(Item."Item Category Code");
                    PurchaseRegister."Item Category Code" := ICC."Parent Category";

                    IF ICC."Parent Category" <> '' THEN BEGIN
                        //ICC.GET(Item."Item Category Code") ;
                        PurchaseRegister."Item Category Description" := ICC.Description;
                    END;
                    //16767 End


                    /*  PurchaseRegister."Product Group Code" := Item."Product Group Code";
                     IF Item."Product Group Code" <> '' THEN BEGIN
                         //PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                         PurchaseRegister."Product Group Description" := PGC.Description;
                     END; */ //16767 Table Not Found

                    //16767 Start
                    PurchaseRegister."Product Group Code" := Item."Item Category Code";
                    IF Item."Item Category Code" <> '' THEN BEGIN
                        //PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                        PurchaseRegister."Product Group Description" := Item.Description;
                    END;
                    //16767 end

                END;

                PurchaseRegister.Type := Type;
                PurchaseRegister."No." := "No.";
                PurchaseRegister."Variant Code" := "Variant Code";
                PurchaseRegister."Item Description" := Description;
                PurchaseRegister."Gross Weight" := Item."Gross Weight";
                PurchaseRegister."Net Weight" := Item."Net Weight";
                PurchaseRegister."Units per Parcel" := Item."Units per Parcel";
                PurchaseRegister."Unit of Measure" := "Unit of Measure Code";
                IF PurchaseRegister."Variant Code" <> '' THEN BEGIN
                    ItemVariant.GET(PurchaseRegister."No.", PurchaseRegister."Variant Code");
                    PurchaseRegister."Variant Description" := ItemVariant.Description;
                END;

                PurchaseRegister.Quantity := Quantity;
                IF lPurchInvHeader."Currency Code" <> '' THEN BEGIN
                    PurchaseRegister."Line Discount Amount" := "Line Discount Amount" / lPurchInvHeader."Currency Factor";
                    PurchaseRegister."Unit Price" := "Direct Unit Cost" / lPurchInvHeader."Currency Factor";
                    PurchaseRegister.Amount := Quantity * "Direct Unit Cost" / lPurchInvHeader."Currency Factor";
                    PurchaseRegister."Line Amount" := "Line Amount" / lPurchInvHeader."Currency Factor";
                END ELSE BEGIN
                    PurchaseRegister."Line Discount Amount" := "Line Discount Amount";
                    PurchaseRegister."Unit Price" := "Direct Unit Cost";
                    PurchaseRegister.Amount := Quantity * "Direct Unit Cost";
                    PurchaseRegister."Line Amount" := "Line Amount";
                END;

                /* PurchaseRegister."Actual Tax %" := "Tax %";
                PurchaseRegister."Excise Base Amount" := "Excise Base Amount";
                PurchaseRegister."Excise Amount" := "Excise Amount";
                PurchaseRegister."BED Amount" := "BED Amount";
                PurchaseRegister."ECess Amount" := "eCess Amount";
                PurchaseRegister."SHECess Amount" := "SHE Cess Amount";
                PurchaseRegister."SAED Amount" := "SAED Amount";
                PurchaseRegister."Assessable Value" := "Assessable Value"; */ //16767 Field not Found
                PurchaseRegister."Custom Duty" := "Custom Duty Amount";//ACXRaman 031220
                PurchaseRegister."GST Assessable Value" := "GST Assessable Value";//ACXRaman 031220
                                                                                  //16767  PurchaseRegister."GST Base Amount" :="GST Base Amount"; //ACXKD 071220
                                                                                  //16767  PurchaseRegister."Total GST Amount" := "Total GST Amount";//ACXKD 071220 
                PurchaseRegister."GST Base Amount" := GstBaseAmt.GetGSTBaseAmtPostedLine("Document No.", "Line No.");
                PurchaseRegister."Total GST Amount" := TotalGstAmt.GetTotalGSTAmtPostedLine("Document No.", "Line No.");
                /* recExcisePostingSetup.RESET;
                recExcisePostingSetup.SETRANGE("Excise Bus. Posting Group", "Excise Bus. Posting Group");
                recExcisePostingSetup.SETRANGE("Excise Prod. Posting Group", "Excise Prod. Posting Group");
                recExcisePostingSetup.SETFILTER("From Date", '<=%1', lPurchInvHeader."Posting Date");

                IF recExcisePostingSetup.FIND('+') THEN BEGIN
                    PurchaseRegister."BED %" := recExcisePostingSetup."BED %";
                    PurchaseRegister."ECess %" := recExcisePostingSetup."eCess %";
                    PurchaseRegister."SHECess %" := recExcisePostingSetup."SHE Cess %";
                    PurchaseRegister."SAED %" := recExcisePostingSetup."SAED %";
                END ELSE BEGIN
                    PurchaseRegister."BED %" := 0;
                    PurchaseRegister."ECess %" := 0;
                    PurchaseRegister."SHECess %" := 0;
                    PurchaseRegister."SAED %" := 0;
                END; */ //16767 Table Not Found


                /* PurchaseRegister."Service Tax Base Amount" := "Service Tax Base";
                PurchaseRegister."Service Tax Amount" := "Service Tax Amount";
                PurchaseRegister."Service Tax eCess Amount" := "Service Tax eCess Amount";
                PurchaseRegister."Service Tax SHECess Amount" := "Service Tax SHE Cess Amount";
                PurchaseRegister."Service Tax Group" := "Service Tax Group";
                PurchaseRegister."Service Tax Registration No." := "Service Tax Registration No.";

                recServiceTaxSetup.RESET;
                recServiceTaxSetup.SETRANGE(Code, "Service Tax Group");
                recServiceTaxSetup.SETFILTER("From Date", '<=%1', lPurchInvHeader."Posting Date");
                IF recServiceTaxSetup.FIND('-') THEN BEGIN
                    PurchaseRegister."Service Tax %" := recServiceTaxSetup."Service Tax %";
                    PurchaseRegister."Service Tax eCess %" := recServiceTaxSetup."eCess %";
                    PurchaseRegister."Service Tax SHECess %" := recServiceTaxSetup."SHE Cess %";
                END ELSE BEGIN
                    PurchaseRegister."Service Tax %" := 0;
                    PurchaseRegister."Service Tax eCess %" := 0;
                    PurchaseRegister."Service Tax SHECess %" := 0;
                END; */ //16767 Table Not Found


                //16767  PurchaseRegister."TDS Base Amount" := "Tax Base Amount";
                //16767 Start
                TdsEntry.Reset();
                TdsEntry.SetRange("Document No.", "Document No.");
                if TdsEntry.FindSet() then begin
                    repeat
                        PurchaseRegister."TDS Amount" := TdsEntry."TDS Amount";
                        PurchaseRegister."TDS %" := TdsEntry."TDS %";
                        PurchaseRegister."eCESS on TDS Amount" := TdsEntry."eCess Amount";
                        PurchaseRegister."SHE Cess on TDS Amount" := TdsEntry."SHE Cess Amount";
                    //16767 PurchaseRegister."TDS Nature of Deduction" := "TDS Nature of Deduction";
                    until TdsEntry.Next() = 0;

                end;

                /* PurchaseRegister."TDS Amount" := "TDS Amount";
                PurchaseRegister."TDS %" := "TDS %";
                PurchaseRegister."eCESS on TDS Amount" := "eCESS on TDS Amount";
                PurchaseRegister."SHE Cess on TDS Amount" := "SHE Cess on TDS Amount";
                PurchaseRegister."TDS Nature of Deduction" := "TDS Nature of Deduction"; */ //16767 
                                                                                            //ACX-RK 30092021 Begin
                                                                                            //16767  PurchaseRegister."GST Rate" := "GST %";


                //16767 New Code add
                Clear(CgstPer);
                Clear(SgstPer);
                Clear(IgstPer);
                Clear(GetPer);
                recDetGSTLedEntry.RESET();
                recDetGSTLedEntry.SETRANGE("Document No.", "Document No.");
                recDetGSTLedEntry.SETRANGE("Document Line No.", "Line No.");
                IF recDetGSTLedEntry.FindSet() THEN begin
                    repeat
                        IF recDetGSTLedEntry."GST Component Code" = 'IGST' THEN
                            IgstPer := recDetGSTLedEntry."GST %";
                        IF recDetGSTLedEntry."GST Component Code" = 'CGST' THEN
                            CgstPer := recDetGSTLedEntry."GST %";
                        IF recDetGSTLedEntry."GST Component Code" = 'SGST' THEN
                            SgstPer := recDetGSTLedEntry."GST %";
                    until recDetGSTLedEntry.Next() = 0;
                end;
                GetPer := (IgstPer + CgstPer + SgstPer);
                PurchaseRegister."GST Rate" := GetPer;
                //16767 Code End

                //acxcp_16112021 begin
                /* recPostedStrOrdrDtl.RESET;
                recPostedStrOrdrDtl.SETRANGE(Type, recPostedStrOrdrDtl.Type::Purchase);
                recPostedStrOrdrDtl.SETRANGE("No.", lPurchInvHeader."No.");
                recPostedStrOrdrDtl.SETFILTER("Structure Code", '%1', 'GST TCSR');
                recPostedStrOrdrDtl.SETRANGE("Tax/Charge Type", recPostedStrOrdrDtl."Tax/Charge Type"::Charges);
                recPostedStrOrdrDtl.SETFILTER("Tax/Charge Group", '%1', 'TCS-REC');
                recPostedStrOrdrDtl.SETFILTER("Tax/Charge Code", '%1', 'TCS-1');
                IF recPostedStrOrdrDtl.FINDFIRST THEN BEGIN
                    PurchaseRegister."TCS Details Required" := recPostedStrOrdrDtl."Calculation Value";

                END; */ //16767 Table Not Found
                        //acxcp_16112021 end

                //      recPostedStrOrderDetail.RESET();
                //      recPostedStrOrderDetail.SETRANGE("Invoice No.","Document No.");
                //      recPostedStrOrderDetail.SETRANGE("Line No.","Line No.");
                //        IF recPostedStrOrderDetail.FINDFIRST THEN
                //            PurchaseRegister."TCS Details Required" := recPostedStrOrderDetail."Calculation Value";

                recDetGSTLedEntry.RESET();
                recDetGSTLedEntry.SETRANGE("Document No.", "Document No.");
                recDetGSTLedEntry.SETRANGE("Document Line No.", "Line No.");
                recDetGSTLedEntry.SETRANGE("Reverse Charge", FALSE);
                IF recDetGSTLedEntry.FINDFIRST THEN
                    REPEAT
                        IF recDetGSTLedEntry."GST Component Code" = 'IGST' THEN
                            PurchaseRegister."IGST Amount" := recDetGSTLedEntry."GST Amount";
                        IF recDetGSTLedEntry."GST Component Code" = 'CGST' THEN
                            PurchaseRegister."CGST Amount" := recDetGSTLedEntry."GST Amount";
                        IF recDetGSTLedEntry."GST Component Code" = 'SGST' THEN
                            PurchaseRegister."SGST Amount" := recDetGSTLedEntry."GST Amount";
                    UNTIL recDetGSTLedEntry.NEXT = 0;
                //ACX-RK End
                /*  IF "Tax Base Amount" = 0 THEN
                     PurchaseRegister."Tax Base Amount" := "Line Amount" + "Excise Amount"
                 ELSE
                     PurchaseRegister."Tax Base Amount" := "Tax Base Amount";
                 PurchaseRegister."Tax Amount" := "Tax Amount"; */ //16767 field Not Found


                PurchaseRegister."Tax Group Code" := "Tax Group Code";
                PurchaseRegister."Tax Area" := "Tax Area Code";

                IF "Tax Area Code" <> '' THEN BEGIN
                    /*  TaxAreaLine.RESET;
                     TaxAreaLine.SETRANGE("Tax Area", "Tax Area Code");
                     TaxAreaLine.FIND('-');
                     PurchaseRegister."Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";

                     TaxJuris.GET(TaxAreaLine."Tax Jurisdiction Code");
                     PurchaseRegister."Tax Type" := TaxJuris."Tax Type"; */ //16767 field Not Found

                    AddTaxAmt := 0;
                    TaxAmt := 0;
                    TaxPer := 0;
                    AddTaxPer := 0;
                    /*
                     IF "Tax Amount" <> 0 THEN BEGIN
                       DtlTaxEntry.RESET ;
                       DtlTaxEntry.SETCURRENTKEY("Document No.", "Document Line No.", "Main Component Entry No.",
                                                 "Deferment No.", "Tax Jurisdiction Code", "Entry Type") ;
                       DtlTaxEntry.SETRANGE("Document No.", "Document No.") ;
                       DtlTaxEntry.SETRANGE("Document Line No.", "Line No.") ;
                       DtlTaxEntry.FIND('-') ;
                       REPEAT
                          TaxAreaLine2.GET(DtlTaxEntry."Tax Area Code", DtlTaxEntry."Tax Jurisdiction Code") ;
                          IF TaxAreaLine2."Calculation Order" <= 1 THEN BEGIN
                             TaxAmt += (DtlTaxEntry."Tax Amount") ;
                             TaxPer := DtlTaxEntry."Tax %" ;
                          END ELSE BEGIN
                             AddTaxAmt += (DtlTaxEntry."Tax Amount") ;
                             AddTaxPer := DtlTaxEntry."Tax %" ;
                          END ;
                       UNTIL DtlTaxEntry.NEXT = 0 ;
                    END ;
                     */
                    IF PurchaseRegister."Tax Type" = PurchaseRegister."Tax Type"::CST THEN
                        PurchaseRegister."CST Amount" := ABS(TaxAmt)
                    ELSE
                        PurchaseRegister."VAT Amount" := ABS(TaxAmt);
                    PurchaseRegister."Addn. Tax Amount" := ABS(AddTaxAmt);
                    PurchaseRegister."Tax %" := TaxPer;
                    PurchaseRegister."Addn. Tax %" := AddTaxPer;
                END;
                IF PurchaseRegister."Tax Type" = PurchaseRegister."Tax Type"::" " THEN
                    PurchaseRegister."Tax Type" := PurchaseRegister."Tax Type"::VAT;
                //16767 PurchaseRegister."Form Code" := lPurchInvHeader."Form Code";
                //16767 PurchaseRegister."Form No." := lPurchInvHeader."Form No.";
                PurchaseRegister."Line Discount %" := "Line Discount %";
                PurchaseRegister."Applies-to Doc. Type" := lPurchInvHeader."Applies-to Doc. Type";
                PurchaseRegister."Applies-to Doc. No." := lPurchInvHeader."Applies-to Doc. No.";

                PurchaseRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                PurchaseRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //16767 PurchaseRegister."T.I.N. No." := Vend."T.I.N. No.";
                PurchaseRegister."No. Series" := lPurchInvHeader."No. Series";
                IF lPurchInvHeader."Currency Code" <> '' THEN
                    //16767  PurchaseRegister."Net Amount" := "Amount To Vendor" / lPurchInvHeader."Currency Factor"
                    PurchaseRegister."Net Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.") / lPurchInvHeader."Currency Factor"
                ELSE
                    //16767 PurchaseRegister."Net Amount" := "Amount To Vendor";
                    PurchaseRegister."Net Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.");



                decTD := 0;
                decSD := 0;
                decCD := 0;
                decFreight := 0;
                decOffSeason := 0;
                decCustom := 0;
                decEAC := 0;
                decEdcess := 0;
                decEcessac := 0;
                decSugarCess := 0;
                decInsurance := 0;
                decCharge := 0;

                /* recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'TD');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decTD += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;


                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'OFFSEASON');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decOffSeason += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;


                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'SD');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decSD += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;


                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'CD');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decCD += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;


                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FREIGHT');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decFreight += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;

                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER(recPostedStrOrderDetail."Account No.", '%1', '10336000');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decCustom += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;

                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'EXCISEDUTY');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decEAC += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;

                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'EDCESS');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decEdcess += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;


                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'EHREDCESS');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decEcessac += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;

                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'SUGARCESS');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decSugarCess += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;

                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'INSURANCE');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decInsurance += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0;

                recPostedStrOrderDetail.RESET;
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Inv. Line"."Document No.");
                recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Inv. Line"."Line No.");
                recPostedStrOrderDetail.SETFILTER("Tax/Charge Type", 'Charges');
                IF recPostedStrOrderDetail.FIND('-') THEN
                    REPEAT
                        decCharge += recPostedStrOrderDetail.Amount;
                    UNTIL recPostedStrOrderDetail.NEXT = 0; */ //16767 Table Not Found




                PurchaseRegister."Trade Discount" := ABS(decTD);
                PurchaseRegister."Cash Discount" := ABS(decCD);
                PurchaseRegister."Scheme Discount" := ABS(decSD);
                PurchaseRegister."OffSeason Discount" := ABS(decOffSeason);
                PurchaseRegister.Freight := ABS(decFreight);
                // PurchaseRegister."Custom Duty"  := ABS(decCustom);
                PurchaseRegister."Excise Amount Charge" := ABS(decEAC);
                PurchaseRegister."BED Amount Charge" := ABS(decEdcess);
                PurchaseRegister."ECess Amount Charge" := ABS(decEcessac);
                PurchaseRegister."SUGARCESS Charge" := ABS(decSugarCess);
                PurchaseRegister."INSURANCE Charge" := ABS(decInsurance);
                PurchaseRegister."Charge Amount" := ABS(decCharge);



                IF ("Gen. Prod. Posting Group" <> '') AND ("Gen. Bus. Posting Group" <> '') THEN BEGIN
                    IF GPS.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN BEGIN
                        PurchaseRegister."Revenue Account Code" := GPS."Sales Account";
                        IF GLAcc.GET(GPS."Sales Account") THEN
                            PurchaseRegister."Revenue Account Description" := GLAcc.Name;
                    END;
                END;

                IF (lPurchInvHeader."Vendor Posting Group" <> '') THEN BEGIN
                    VPG.GET(lPurchInvHeader."Vendor Posting Group");
                    PurchaseRegister."Payable Account Code" := VPG."Payables Account";
                    IF GLAcc.GET(VPG."Payables Account") THEN
                        PurchaseRegister."Payable Account Description" := GLAcc.Name;
                END;

                PurchaseRegister.INSERT;
            END;
            "Exported to Purch. Register" := TRUE;
            MODIFY;

        END;

    end;


    procedure InsertPurchCrMemo(var lPurchCrMemoLine: Record 125)
    var
        lPurchCrMemoHdr: Record 124;
        lSalesRegister: Record 50001;
        AmtToVendor: Codeunit 50200;
        CgstPer: Decimal;
        IgstPer: Decimal;
        SgstPer: Decimal;
        GetPer: Decimal;
    begin



        WITH lPurchCrMemoLine DO BEGIN
            lPurchCrMemoHdr.GET("Document No.");
            //IF GenJnlTemplate.GET(lPurchCrMemoHdr."Gen. Journal Template Code") THEN;

            IF Loc.GET("Location Code") THEN;
            IF Vend.GET("Buy-from Vendor No.") THEN;
            IF VPG.GET(lPurchCrMemoHdr."Vendor Posting Group") THEN;
            //IF recCustPriceGroup.GET(lPurchCrMemoHdr."Customer Price Group") THEN;

            IF (Type = Type::"G/L Account") AND ("No." = VPG."Invoice Rounding Account") THEN BEGIN
                PurchaseRegister1.RESET;
                PurchaseRegister1.SETRANGE("Document Type", PurchaseRegister1."Document Type"::"Purchase Cr. Memo");
                PurchaseRegister1.SETRANGE("Source Document No.", "Document No.");
                IF PurchaseRegister1.FIND('+') THEN BEGIN //acxcp_110322 //code edit due to round off g/l error
                    IF lPurchCrMemoHdr."Currency Code" <> '' THEN BEGIN
                        //16767 PurchaseRegister1."Round Off Amount" := "Amount To Vendor" / lPurchCrMemoHdr."Currency Factor";
                        //16767  PurchaseRegister1."Net Amount" += "Amount To Vendor" / lPurchCrMemoHdr."Currency Factor";

                        PurchaseRegister1."Round Off Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.") / lPurchCrMemoHdr."Currency Factor";
                        PurchaseRegister1."Net Amount" += AmtToVendor.GetAmttoVendorPostedDoc("Document No.") / lPurchCrMemoHdr."Currency Factor";
                    END ELSE BEGIN
                        //16767  PurchaseRegister1."Round Off Amount" := "Amount To Vendor";
                        //16767  PurchaseRegister1."Net Amount" += "Amount To Vendor";

                        PurchaseRegister1."Round Off Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.");
                        PurchaseRegister1."Net Amount" += AmtToVendor.GetAmttoVendorPostedDoc("Document No.");
                    END;

                    PurchaseRegister1.MODIFY;
                END;
            END ELSE BEGIN
                PurchaseRegister.INIT;
                PurchaseRegister."Document Type" := PurchaseRegister."Document Type"::"Purchase Cr. Memo";
                // PurchaseRegister."Gen. Journal Template Code" := lPurchCrMemoHdr."Gen. Journal Template Code" ;
                PurchaseRegister."Source Document No." := "Document No.";
                PurchaseRegister."Source Line No." := "Line No.";
                PurchaseRegister."Posting Date" := lPurchCrMemoHdr."Posting Date";
                PurchaseRegister."Source Line Description" := Description;

                //PurchaseRegister."Document Salesperson Code" :=lPurchCrMemoHdr."Salesperson Code";
                IF lPurchCrMemoHdr."Purchaser Code" <> '' THEN BEGIN
                    IF Salesperson.GET(lPurchCrMemoHdr."Purchaser Code") THEN;
                    PurchaseRegister."Document Salesperson Name" := Salesperson.Name;
                END;

                PurchaseRegister."Payment Term Code" := lPurchCrMemoHdr."Payment Terms Code";
                //      PurchaseRegister."Freight Payment Type" := lPurchCrMemoHdr."Freight Payment Code";
                PurchaseRegister."Currency Code" := lPurchCrMemoHdr."Currency Code";
                PurchaseRegister."Currency Factor" := lPurchCrMemoHdr."Currency Factor";
                PurchaseRegister."Order No." := lPurchCrMemoHdr."Return Order No.";
                PurchaseRegister."External Document No." := lPurchCrMemoHdr."Vendor Cr. Memo No.";
                PurchaseRegister."Due date" := lPurchCrMemoHdr."Due Date";
                PurchaseRegister."Source Type" := PurchaseRegister."Source Type"::Vendor;
                PurchaseRegister."Source No." := "Buy-from Vendor No.";
                PurchaseRegister."Source Name" := Vend.Name;
                PurchaseRegister."Source City" := Vend.City;
                PurchaseRegister."Source State Code" := Vend."State Code";
                //ACX-RK 30092021 Begin
                PurchaseRegister."Supplier Name" := lPurchCrMemoHdr."Buy-from Vendor Name";
                recOrAdd.RESET();
                recOrAdd.SETRANGE(Code, lPurchCrMemoHdr."Order Address Code");
                IF recOrAdd.FINDFIRST THEN
                    PurchaseRegister."Consignee Name" := recOrAdd.Name;
                PurchaseRegister."Supplier GST No" := lPurchCrMemoHdr."Vendor GST Reg. No.";
                PurchaseRegister."Supplier document Date" := lPurchCrMemoHdr."Document Date";
                //ACX-RK End
                IF recState.GET(Vend."State Code") THEN BEGIN
                    PurchaseRegister."Source State Name" := recState.Description;
                END;
                PurchaseRegister."Vendor Posting Group" := lPurchCrMemoHdr."Vendor Posting Group";
                //     PurchaseRegister."CPG Desc" := VPG.Description ;
                //      PurchaseRegister."Customer Price Group"   := lPurchCrMemoHdr."Customer Price Group";
                PurchaseRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                PurchaseRegister."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                IF GBPG.GET("Gen. Bus. Posting Group") THEN;
                PurchaseRegister."GBPG Description" := GBPG.Description;
                IF GPPG.GET("Gen. Prod. Posting Group") THEN;
                PurchaseRegister."GPPG Description" := GPPG.Description;
                PurchaseRegister."Country/Region Code" := Vend."Country/Region Code";
                IF Vend."Country/Region Code" <> '' THEN BEGIN
                    Country.GET(Vend."Country/Region Code");
                    PurchaseRegister."Country/Region Name" := Country.Name;
                END;
                /*
                PurchaseRegister."Master Salesperson Code" :=Vend."Salesperson Code";
                IF Vend."Salesperson Code" <> '' THEN BEGIN
                   IF Salesperson.GET(Vend."Salesperson Code") THEN;
                   PurchaseRegister."Master Salesperson Name" := Salesperson.Name ;
                END ;
                */
                //      PurchaseRegister."Territory Dimension Code" := Vend."Territory Dimension Code";
                //      IF DimValue.GET('TERR', Vend."Territory Dimension Code") THEN
                //         PurchaseRegister."Territory Dimension Name" := DimValue.Name ;
                PurchaseRegister."Outward Location Code" := "Location Code";
                PurchaseRegister."Outward State Code" := Loc."State Code";
                IF recState.GET(Loc."State Code") THEN BEGIN
                    PurchaseRegister."Outward State Name" := recState.Description;
                END;
                //   PurchaseRegister."Location Type" := Loc."Location Type";

                // Date Treatment Begins

                intDay := DATE2DMY(lPurchCrMemoHdr."Posting Date", 1);
                intMonth := DATE2DMY(lPurchCrMemoHdr."Posting Date", 2);
                intYear := DATE2DMY(lPurchCrMemoHdr."Posting Date", 3);

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

                PurchaseRegister."Fin. Year" := cdFinYear;
                PurchaseRegister.Quarter := cdQuarter;
                PurchaseRegister."Month Name" := cdMonthName;
                PurchaseRegister.Year := intYear;
                PurchaseRegister.Month := intMonth;
                PurchaseRegister.Day := intDay;

                // Date Treatment Ends

                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    Item.GET("No.");
                    //16767  PurchaseRegister."Excise Prod. Posting Group" := Item."Excise Prod. Posting Group";
                    PurchaseRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                    PurchaseRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                    /* PurchaseRegister."Item Category Code" := Item."Item Category Code";
                    IF Item."Item Category Code" <> '' THEN BEGIN
                        // ICC.GET(Item."Item Category Code") ;
                        PurchaseRegister."Item Category Description" := ICC.Description;
                    END; */ //16767 

                    //16767 Start
                    ICC.GET(Item."Item Category Code");
                    PurchaseRegister."Item Category Code" := ICC."Parent Category";
                    IF ICC."Parent Category" <> '' THEN BEGIN
                        // ICC.GET(Item."Item Category Code") ;
                        PurchaseRegister."Item Category Description" := ICC.Description;
                    END;
                    //16767 end


                    /* PurchaseRegister."Product Group Code" := Item."Product Group Code";
                    IF Item."Product Group Code" <> '' THEN BEGIN
                        //PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                        PurchaseRegister."Product Group Description" := PGC.Description;
                    END; */ //16767 

                    //16767 Start
                    PurchaseRegister."Product Group Code" := Item."Item Category Code";
                    IF Item."Item Category Code" <> '' THEN BEGIN
                        //PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                        PurchaseRegister."Product Group Description" := Item.Description;
                    END;
                    //16767 end

                END;

                PurchaseRegister.Type := Type;
                PurchaseRegister."No." := "No.";
                PurchaseRegister."Variant Code" := "Variant Code";
                PurchaseRegister."Item Description" := Description;
                PurchaseRegister."Gross Weight" := Item."Gross Weight";
                PurchaseRegister."Net Weight" := Item."Net Weight";
                PurchaseRegister."Units per Parcel" := Item."Units per Parcel";
                PurchaseRegister."Unit of Measure" := "Unit of Measure Code";

                //PurchaseRegister."Item Type" := Item."Item Type";
                IF PurchaseRegister."Variant Code" <> '' THEN BEGIN
                    ItemVariant.GET(PurchaseRegister."No.", PurchaseRegister."Variant Code");
                    PurchaseRegister."Variant Description" := ItemVariant.Description;
                END;

                PurchaseRegister.Quantity := -Quantity;

                IF lPurchCrMemoHdr."Currency Code" <> '' THEN BEGIN
                    PurchaseRegister."Line Discount Amount" := -"Line Discount Amount" / lPurchCrMemoHdr."Currency Factor";
                    PurchaseRegister."Unit Price" := -"Direct Unit Cost" / lPurchCrMemoHdr."Currency Factor";
                    PurchaseRegister.Amount := -Quantity * "Direct Unit Cost" / lPurchCrMemoHdr."Currency Factor";
                    PurchaseRegister."Line Amount" := -"Line Amount" / lPurchCrMemoHdr."Currency Factor";
                END ELSE BEGIN
                    PurchaseRegister."Line Discount Amount" := -"Line Discount Amount";
                    PurchaseRegister."Unit Price" := -"Direct Unit Cost";
                    PurchaseRegister.Amount := -Quantity * "Direct Unit Cost";
                    PurchaseRegister."Line Amount" := -"Line Amount";
                END;


                /*  PurchaseRegister."Actual Tax %" := "Tax %";
                 PurchaseRegister."Excise Base Amount" := "Excise Base Amount";
                 PurchaseRegister."Excise Amount" := -"Excise Amount";
                 PurchaseRegister."BED Amount" := -"BED Amount";
                 PurchaseRegister."ECess Amount" := -"eCess Amount";
                 PurchaseRegister."SHECess Amount" := -"SHE Cess Amount";
                 PurchaseRegister."SAED Amount" := -"SAED Amount";
                 PurchaseRegister."Assessable Value" := -"Assessable Value"; */ //16767 Field Not Found
                                                                                //      PurchaseRegister."MRP Price":= "MRP Rate" ;
                                                                                //      PurchaseRegister."Abatement %":= "Abatement %";
                                                                                /*  recExcisePostingSetup.RESET;
                                                                                 recExcisePostingSetup.SETRANGE("Excise Bus. Posting Group", "Excise Bus. Posting Group");
                                                                                 recExcisePostingSetup.SETRANGE("Excise Prod. Posting Group", "Excise Prod. Posting Group");
                                                                                 recExcisePostingSetup.SETFILTER("From Date", '<=%1', lPurchCrMemoHdr."Posting Date");


                                                                                 IF recExcisePostingSetup.FIND('+') THEN BEGIN
                                                                                     PurchaseRegister."BED %" := recExcisePostingSetup."BED %";
                                                                                     PurchaseRegister."ECess %" := recExcisePostingSetup."eCess %";
                                                                                     PurchaseRegister."SHECess %" := recExcisePostingSetup."SHE Cess %";
                                                                                     PurchaseRegister."SAED %" := recExcisePostingSetup."SAED %";
                                                                                 END ELSE BEGIN
                                                                                     PurchaseRegister."BED %" := 0;
                                                                                     PurchaseRegister."ECess %" := 0;
                                                                                     PurchaseRegister."SHECess %" := 0;
                                                                                     PurchaseRegister."SAED %" := 0;
                                                                                 END; */ //16767 Table Not Found




                /*  PurchaseRegister."Service Tax Base Amount" := "Service Tax Base";
                 PurchaseRegister."Service Tax Amount" := -"Service Tax Amount";
                 PurchaseRegister."Service Tax eCess Amount" := -"Service Tax eCess Amount";
                 PurchaseRegister."Service Tax SHECess Amount" := -"Service Tax SHE Cess Amount";
                 PurchaseRegister."Service Tax Group" := "Service Tax Group";
                 PurchaseRegister."Service Tax Registration No." := "Service Tax Registration No.";

                 recServiceTaxSetup.RESET;
                 recServiceTaxSetup.SETRANGE(Code, "Service Tax Group");
                 recServiceTaxSetup.SETFILTER("From Date", '<=%1', lPurchCrMemoHdr."Posting Date");
                 IF recServiceTaxSetup.FIND('-') THEN BEGIN
                     PurchaseRegister."Service Tax %" := recServiceTaxSetup."Service Tax %";
                     PurchaseRegister."Service Tax eCess %" := recServiceTaxSetup."eCess %";
                     PurchaseRegister."Service Tax SHECess %" := recServiceTaxSetup."SHE Cess %";
                 END ELSE BEGIN
                     PurchaseRegister."Service Tax %" := 0;
                     PurchaseRegister."Service Tax eCess %" := 0;
                     PurchaseRegister."Service Tax SHECess %" := 0;
                 END; */ //16767 Table Not Found

                //AR//

                //16767   PurchaseRegister."TDS Base Amount" := -"Tax Base Amount";
                //PurchaseRegister."TDS %"  :="TDS %";
                //PurchaseRegister."TDS Amount"   :="TDS Amount";
                //PurchaseRegister."eCESS on TDS Amount" :="eCESS on TDS Amount";
                //PurchaseRegister."SHE Cess on TDS Amount" :="SHE Cess on TDS Amount";
                //PurchaseRegister."TDS Nature of Deduction" :="TDS Nature of Deduction";

                /*  IF "Tax Base Amount" = 0 THEN
                     PurchaseRegister."Tax Base Amount" := -("Line Amount" + "Excise Amount")
                 ELSE
                     PurchaseRegister."Tax Base Amount" := -"Tax Base Amount";
                 PurchaseRegister."Tax Amount" := -"Tax Amount"; */ //16767 field Not Found


                PurchaseRegister."Tax Group Code" := "Tax Group Code";
                PurchaseRegister."Tax Area" := "Tax Area Code";

                IF "Tax Area Code" <> '' THEN BEGIN
                    /* TaxAreaLine.RESET;
                    TaxAreaLine.SETRANGE("Tax Area", "Tax Area Code");
                    TaxAreaLine.FIND('-');
                    PurchaseRegister."Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";

                    TaxJuris.GET(TaxAreaLine."Tax Jurisdiction Code");
                    PurchaseRegister."Tax Type" := TaxJuris."Tax Type";

                    AddTaxAmt := 0;
                    TaxAmt := 0;
                    TaxPer := 0;
                    AddTaxPer := 0;
                    IF "Tax Amount" <> 0 THEN BEGIN
                        DtlTaxEntry.RESET;
                        DtlTaxEntry.SETCURRENTKEY("Document No.", "Document Line No.", "Main Component Entry No.",
                                                  "Deferment No.", "Tax Jurisdiction Code", "Entry Type");
                        DtlTaxEntry.SETRANGE("Document No.", "Document No.");
                        DtlTaxEntry.SETRANGE("Document Line No.", "Line No.");
                        DtlTaxEntry.FIND('-');
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

                    IF PurchaseRegister."Tax Type" = PurchaseRegister."Tax Type"::CST THEN
                        PurchaseRegister."CST Amount" := -ABS(TaxAmt)
                    ELSE
                        PurchaseRegister."VAT Amount" := -ABS(TaxAmt);
                    PurchaseRegister."Addn. Tax Amount" := -ABS(AddTaxAmt);
                    PurchaseRegister."Tax %" := TaxPer;
                    PurchaseRegister."Addn. Tax %" := AddTaxPer;
                END;
                IF PurchaseRegister."Tax Type" = PurchaseRegister."Tax Type"::" " THEN
                    PurchaseRegister."Tax Type" := PurchaseRegister."Tax Type"::VAT;
                //16767 PurchaseRegister."Form Code" := lPurchCrMemoHdr."Form Code";
                //16767 PurchaseRegister."Form No." := lPurchCrMemoHdr."Form No.";
                PurchaseRegister."Line Discount %" := "Line Discount %";
                PurchaseRegister."Applies-to Doc. Type" := lPurchCrMemoHdr."Applies-to Doc. Type";
                PurchaseRegister."Applies-to Doc. No." := lPurchCrMemoHdr."Applies-to Doc. No.";

                PurchaseRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                PurchaseRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //16767 PurchaseRegister."T.I.N. No." := Vend."T.I.N. No.";
                PurchaseRegister."No. Series" := lPurchCrMemoHdr."No. Series";
                IF lPurchCrMemoHdr."Currency Code" <> '' THEN
                    //16767  PurchaseRegister."Net Amount" := "Amount To Vendor" / lPurchCrMemoHdr."Currency Factor"
                    PurchaseRegister."Net Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.") / lPurchCrMemoHdr."Currency Factor"
                ELSE
                    //16767  PurchaseRegister."Net Amount" := "Amount To Vendor";
                    PurchaseRegister."Net Amount" := AmtToVendor.GetAmttoVendorPostedDoc("Document No.");

                //16767  PurchaseRegister."Net Amount" := -"Amount To Vendor";
                PurchaseRegister."Net Amount" := -AmtToVendor.GetAmttoVendorPostedDoc("Document No.");
                //ACX-RK 30092021 Begin
                //16767   PurchaseRegister."GST Rate" := "GST %";

                //16767 Start
                Clear(CgstPer);
                Clear(SgstPer);
                Clear(IgstPer);
                Clear(GetPer);
                recDetGSTLedEntry.RESET();
                recDetGSTLedEntry.SETRANGE("Document No.", "Document No.");
                recDetGSTLedEntry.SETRANGE("Document Line No.", "Line No.");
                IF recDetGSTLedEntry.FindSet() THEN begin
                    repeat
                        IF recDetGSTLedEntry."GST Component Code" = 'IGST' THEN
                            IgstPer := recDetGSTLedEntry."GST %";
                        IF recDetGSTLedEntry."GST Component Code" = 'CGST' THEN
                            CgstPer := recDetGSTLedEntry."GST %";
                        IF recDetGSTLedEntry."GST Component Code" = 'SGST' THEN
                            SgstPer := recDetGSTLedEntry."GST %";
                    until recDetGSTLedEntry.Next() = 0;
                end;
                GetPer := (IgstPer + CgstPer + SgstPer);
                PurchaseRegister."GST Rate" := GetPer;

                //16767 end


                /* recPostedStrOrderDetail.RESET();
                recPostedStrOrderDetail.SETRANGE("Invoice No.", "Document No.");
                recPostedStrOrderDetail.SETRANGE("Line No.", "Line No.");
                IF recPostedStrOrderDetail.FINDFIRST THEN
                    PurchaseRegister."TCS Details Required" := recPostedStrOrderDetail."Calculation Value"; */ //16767 Table Not Found
                recDetGSTLedEntry.RESET();
                recDetGSTLedEntry.SETRANGE("Document No.", "Document No.");
                recDetGSTLedEntry.SETRANGE("Document Line No.", "Line No.");
                recDetGSTLedEntry.SETRANGE("Reverse Charge", FALSE);
                IF recDetGSTLedEntry.FINDFIRST THEN
                    REPEAT
                        IF recDetGSTLedEntry."GST Component Code" = 'IGST' THEN
                            PurchaseRegister."IGST Amount" := recDetGSTLedEntry."GST Amount";
                        IF recDetGSTLedEntry."GST Component Code" = 'CGST' THEN
                            PurchaseRegister."CGST Amount" := recDetGSTLedEntry."GST Amount";
                        IF recDetGSTLedEntry."GST Component Code" = 'SGST' THEN
                            PurchaseRegister."SGST Amount" := recDetGSTLedEntry."GST Amount";
                    UNTIL recDetGSTLedEntry.NEXT = 0;
                //ACX-RK End


                decTD := 0;
                decSD := 0;
                decCD := 0;
                decFreight := 0;
                decOffSeason := 0;
                decEAC := 0;
                decEdcess := 0;
                decEcessac := 0;
                decSugarCess := 0;
                decInsurance := 0;
                decCharge := 0;

                /*  recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'TD');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decTD += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'OFFSEASON');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decOffSeason += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'SD');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decSD += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'CD');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decCD += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FREIGHT');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decFreight += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;

                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'EXCISEDUTY');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decEAC += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;

                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'EDCESS');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decEdcess += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;


                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'EHREDCESS');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decEcessac += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;

                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'SUGARCESS');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decSugarCess += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;

                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'INSURANCE');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decInsurance += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0;

                 recPostedStrOrderDetail.RESET;
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Purch. Cr. Memo Line"."Document No.");
                 recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Purch. Cr. Memo Line"."Line No.");
                 recPostedStrOrderDetail.SETFILTER("Tax/Charge Type", 'Charges');
                 IF recPostedStrOrderDetail.FIND('-') THEN
                     REPEAT
                         decCharge += recPostedStrOrderDetail.Amount;
                     UNTIL recPostedStrOrderDetail.NEXT = 0; */ //16767 Table Not Found



                PurchaseRegister."Trade Discount" := -ABS(decTD);
                PurchaseRegister."Cash Discount" := -ABS(decCD);
                PurchaseRegister."Scheme Discount" := -ABS(decSD);
                PurchaseRegister."OffSeason Discount" := -ABS(decOffSeason);
                PurchaseRegister.Freight := -ABS(decFreight);
                PurchaseRegister."Excise Amount Charge" := -ABS(decEAC);
                PurchaseRegister."BED Amount Charge" := -ABS(decEdcess);
                PurchaseRegister."ECess Amount Charge" := -ABS(decEcessac);
                PurchaseRegister."SUGARCESS Charge" := -ABS(decSugarCess);
                PurchaseRegister."INSURANCE Charge" := -ABS(decInsurance);
                PurchaseRegister."Charge Amount" := -ABS(decCharge);

                IF ("Gen. Prod. Posting Group" <> '') AND ("Gen. Bus. Posting Group" <> '') THEN BEGIN
                    IF GPS.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN BEGIN
                        PurchaseRegister."Revenue Account Code" := GPS."Sales Account";
                        IF GLAcc.GET(GPS."Sales Account") THEN
                            PurchaseRegister."Revenue Account Description" := GLAcc.Name;
                    END;
                END;

                IF (lPurchCrMemoHdr."Vendor Posting Group" <> '') THEN BEGIN
                    VPG.GET(lPurchCrMemoHdr."Vendor Posting Group");
                    PurchaseRegister."Payable Account Code" := VPG."Payables Account";
                    IF GLAcc.GET(VPG."Payables Account") THEN
                        PurchaseRegister."Payable Account Description" := GLAcc.Name;
                END;

                PurchaseRegister.INSERT;
            END;
            "Exported to Purch. Register" := TRUE;
            MODIFY;

        END;

    end;


    procedure InsertTransRcpt(var lTransRcptHdr: Record 5746)
    var
        lTransRcptLine: Record 5747;
        lTransShptHdr: Record 5744;
        lSalesRegister: Record 50001;
        AmtToCust: Codeunit 50200;
    begin

        //GenJnlTemplate.GET(lTransRcptHdr."Gen. Journal Template Code") ;
        NetAmt := 0;
        lTransRcptLine.RESET;
        lTransRcptLine.SETRANGE("Document No.", lTransRcptHdr."No.");
        lTransRcptLine.SETFILTER("Item No.", '<>%1', '');
        lTransRcptLine.SETRANGE("Exported to Purch. Register", FALSE);
        IF lTransRcptLine.FIND('-') THEN BEGIN
            REPEAT
                WITH lTransRcptLine DO BEGIN
                    Loc.GET("Transfer-from Code");
                    Loc2.GET("Transfer-to Code");
                    PurchaseRegister.INIT;
                    PurchaseRegister."Document Type" := PurchaseRegister."Document Type"::"Transfer Rcpt.";
                    //PurchaseRegister."Gen. Journal Template Code" := lTransRcptHdr."Gen. Journal Template Code" ;
                    PurchaseRegister."Source Document No." := "Document No.";
                    PurchaseRegister."Source Line No." := "Line No.";
                    PurchaseRegister."Posting Date" := lTransRcptHdr."Posting Date";
                    PurchaseRegister."Source Line Description" := Description;
                    PurchaseRegister."External Document No." := lTransRcptHdr."External Document No.";
                    PurchaseRegister."Source Type" := PurchaseRegister."Source Type"::Location;
                    PurchaseRegister."Source No." := Loc2.Code;
                    PurchaseRegister."Source Name" := Loc2.Name;
                    PurchaseRegister."Source City" := Loc2.City;
                    PurchaseRegister."Source State Code" := Loc2."State Code";
                    IF recState.GET(Loc2."State Code") THEN BEGIN
                        PurchaseRegister."Source State Name" := recState.Description;
                    END;
                    //    PurchaseRegister."CPG Desc" := VPG.Description ;
                    PurchaseRegister."Customer Price Group Name" := recCustPriceGroup.Description;
                    GPPG.GET("Gen. Prod. Posting Group");
                    PurchaseRegister."GPPG Description" := GPPG.Description;
                    PurchaseRegister."Country/Region Code" := Loc2."Country/Region Code";
                    IF Loc2."Country/Region Code" <> '' THEN BEGIN
                        Country.GET(Loc2."Country/Region Code");
                        PurchaseRegister."Country/Region Name" := Country.Name;
                    END;
                    PurchaseRegister."Outward Location Code" := Loc.Code;
                    PurchaseRegister."Outward State Code" := Loc."State Code";
                    IF recState.GET(Loc."State Code") THEN BEGIN
                        PurchaseRegister."Outward State Name" := recState.Description;
                    END;
                    //  PurchaseRegister."Location Type" := Loc."Location Type";

                    intDay := DATE2DMY(lTransRcptHdr."Posting Date", 1);
                    intMonth := DATE2DMY(lTransRcptHdr."Posting Date", 2);
                    intYear := DATE2DMY(lTransRcptHdr."Posting Date", 3);

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

                    PurchaseRegister."Fin. Year" := cdFinYear;
                    PurchaseRegister.Quarter := cdQuarter;
                    PurchaseRegister."Month Name" := cdMonthName;
                    PurchaseRegister.Year := intYear;
                    PurchaseRegister.Month := intMonth;
                    PurchaseRegister.Day := intDay;

                    // Date Treatment Ends

                    PurchaseRegister."No." := "Item No.";
                    PurchaseRegister."Variant Code" := "Variant Code";
                    PurchaseRegister."Item Description" := Description;
                    PurchaseRegister."Gross Weight" := Item."Gross Weight";
                    PurchaseRegister."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    PurchaseRegister."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";

                    PurchaseRegister."Net Weight" := Item."Net Weight";
                    PurchaseRegister."Units per Parcel" := Item."Units per Parcel";
                    PurchaseRegister."Unit of Measure" := "Unit of Measure Code";
                    PurchaseRegister."Order No." := lTransRcptHdr."Transfer Order No.";
                    IF PurchaseRegister."Variant Code" <> '' THEN BEGIN
                        ItemVariant.GET(PurchaseRegister."No.", PurchaseRegister."Variant Code");
                        PurchaseRegister."Variant Description" := ItemVariant.Description;
                    END;

                    IF ("Item No." <> '') THEN BEGIN
                        Item.GET("Item No.");
                        //16767  PurchaseRegister."Excise Prod. Posting Group" := Item."Excise Prod. Posting Group";
                        PurchaseRegister."Inventory Posting Group" := Item."Inventory Posting Group";
                        PurchaseRegister."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                        /* PurchaseRegister."Item Category Code" := Item."Item Category Code";
                        IF Item."Item Category Code" <> '' THEN BEGIN
                            // ICC.GET(Item."Item Category Code") ;
                            PurchaseRegister."Item Category Description" := ICC.Description;
                        END; */ //16767 

                        //16767 Start
                        ICC.GET(Item."Item Category Code");
                        PurchaseRegister."Item Category Code" := ICC."Parent Category";
                        IF ICC."Parent Category" <> '' THEN BEGIN
                            // ICC.GET(Item."Item Category Code") ;
                            PurchaseRegister."Item Category Description" := ICC.Description;
                        END;

                        //16767 End

                        /*  PurchaseRegister."Product Group Code" := Item."Product Group Code";
                         IF Item."Product Group Code" <> '' THEN BEGIN
                             // PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                             PurchaseRegister."Product Group Description" := PGC.Description;
                         END; */ //16767

                        //16767 Start
                        PurchaseRegister."Product Group Code" := Item."Item Category Code";
                        IF Item."Item Category Code" <> '' THEN BEGIN
                            // PGC.GET(Item."Item Category Code", Item."Product Group Code") ;
                            PurchaseRegister."Product Group Description" := Item.Description;
                        END;

                        //16767 End

                    END;
                    PurchaseRegister.Quantity := Quantity;
                    PurchaseRegister."Unit Price" := "Unit Price";
                    PurchaseRegister.Amount := (Quantity * "Unit Price");

                    /*  PurchaseRegister."Excise Base Amount" := "Excise Base Amount";
                     PurchaseRegister."Excise Amount" := "Excise Amount";
                     PurchaseRegister."BED Amount" := "BED Amount";
                     PurchaseRegister."ECess Amount" := "eCess Amount";
                     PurchaseRegister."SHECess Amount" := "SHE Cess Amount";
                     PurchaseRegister."SAED Amount" := "SAED Amount";
                     PurchaseRegister."Assessable Value" := "Assessable Value";
                     PurchaseRegister."MRP Price" := "MRP Price";
                     PurchaseRegister."Abatement %" := "Abatement %";
                     recExcisePostingSetup.RESET;
                     recExcisePostingSetup.SETRANGE("Excise Bus. Posting Group", "Excise Bus. Posting Group");
                     recExcisePostingSetup.SETRANGE("Excise Prod. Posting Group", "Excise Prod. Posting Group");
                     recExcisePostingSetup.SETFILTER("From Date", '<=%1', lTransRcptHdr."Posting Date");

                     IF recExcisePostingSetup.FIND('+') THEN BEGIN
                         PurchaseRegister."BED %" := recExcisePostingSetup."BED %";
                         PurchaseRegister."ECess %" := recExcisePostingSetup."eCess %";
                         PurchaseRegister."SHECess %" := recExcisePostingSetup."SHE Cess %";
                         PurchaseRegister."SAED %" := recExcisePostingSetup."SAED %";
                     END ELSE BEGIN
                         PurchaseRegister."BED %" := 0;
                         PurchaseRegister."ECess %" := 0;
                         PurchaseRegister."SHECess %" := 0;
                         PurchaseRegister."SAED %" := 0;
                     END; */ //16767 Field and Table Not Found

                    decTD := 0;
                    decSD := 0;
                    decCD := 0;
                    decFreight := 0;
                    decOffSeason := 0;
                    /*  recPostedStrOrderDetail.RESET;
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Document No.");
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Line No.");
                     recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'TD');
                     IF recPostedStrOrderDetail.FIND('-') THEN
                         REPEAT
                             decTD := recPostedStrOrderDetail.Amount;
                         UNTIL recPostedStrOrderDetail.NEXT = 0;


                     recPostedStrOrderDetail.RESET;
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Document No.");
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Line No.");
                     recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'OFFSEASON');
                     IF recPostedStrOrderDetail.FIND('-') THEN
                         REPEAT
                             decOffSeason := recPostedStrOrderDetail.Amount;
                         UNTIL recPostedStrOrderDetail.NEXT = 0;


                     recPostedStrOrderDetail.RESET;
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Document No.");
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Line No.");
                     recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'SD');
                     IF recPostedStrOrderDetail.FIND('-') THEN
                         REPEAT
                             decSD := recPostedStrOrderDetail.Amount;
                         UNTIL recPostedStrOrderDetail.NEXT = 0;


                     recPostedStrOrderDetail.RESET;
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Document No.");
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Line No.");
                     recPostedStrOrderDetail.SETFILTER("Tax/Charge Code", 'CD');
                     IF recPostedStrOrderDetail.FIND('-') THEN
                         REPEAT
                             decCD := recPostedStrOrderDetail.Amount;
                         UNTIL recPostedStrOrderDetail.NEXT = 0;


                     recPostedStrOrderDetail.RESET;
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Invoice No.", "Document No.");
                     recPostedStrOrderDetail.SETRANGE(recPostedStrOrderDetail."Line No.", "Line No.");
                     recPostedStrOrderDetail.SETFILTER("Tax/Charge Group", 'FREIGHT');
                     IF recPostedStrOrderDetail.FIND('-') THEN
                         REPEAT
                             decFreight := recPostedStrOrderDetail.Amount;
                         UNTIL recPostedStrOrderDetail.NEXT = 0; */ //16767 Table Not Found

                    PurchaseRegister."Trade Discount" := decTD;
                    PurchaseRegister."Cash Discount" := decCD;
                    PurchaseRegister."Scheme Discount" := decSD;
                    PurchaseRegister."OffSeason Discount" := decOffSeason;
                    PurchaseRegister.Freight := decFreight;
                    PurchaseRegister."Net Amount" := Amount + /* "Excise Amount" */ +decTD + decCD + decSD + decOffSeason + decFreight;//16767

                    IF (lTransRcptHdr."Transfer-from Code" <> '') AND (lTransRcptHdr."Transfer-to Code" <> '') AND
                                         ("Gen. Prod. Posting Group" <> '') THEN BEGIN
                        //IF TrfActSetup.GET(lTransRcptHdr."Transfer-from Code", lTransRcptHdr."Transfer-to Code",
                        //        "Gen. Prod. Posting Group") THEN BEGIN
                        //IF TrfActSetup."Transfer Sales A/c" <> '' THEN BEGIN
                        //PurchaseRegister."Revenue Account Code" := TrfActSetup."Transfer Sales A/c" ;
                        //GLAcc.GET(TrfActSetup."Transfer Sales A/c");
                        PurchaseRegister."Revenue Account Description" := GLAcc.Name;
                        PurchaseRegister."Payable Account Description" := GLAcc.Name
                    END;
                    //IF TrfActSetup."Transfer-To Branch A/c" <> '' THEN BEGIN
                    //  PurchaseRegister."Payable Account Code" := TrfActSetup."Transfer-To Branch A/c" ;
                    //  GLAcc.GET(TrfActSetup."Transfer-To Branch A/c");
                    ;
                    //END ;



                    PurchaseRegister.INSERT;
                    "Exported to Purch. Register" := TRUE;
                    MODIFY;
                END;
            UNTIL lTransRcptLine.NEXT = 0;



        END;
    end;
}

