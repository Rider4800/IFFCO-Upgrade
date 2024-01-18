report 50019 "IEBL Report-NEW"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = WHERE(Type = FILTER(Item),
                                      Quantity = FILTER(<> 0));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            var
                SIHRec: Record "Sales Invoice Header";
            begin
                //ACXLK...................................................State Des//
                SIHRec.Get("Sales Invoice Line"."Document No.");
                txtData[1] := '';
                txtData[16] := '';
                recstate.RESET;
                recstate.SETRANGE(Code, SIHRec.State);
                IF recstate.FINDFIRST THEN BEGIN
                    REPEAT
                        txtData[1] := recstate.Description;
                        txtData[16] := recstate.Code;
                    UNTIL recstate.NEXT = 0
                END;

                //IGST.............................................................ACX LK//
                txtData[2] := '';
                txtData[3] := '';
                txtData[4] := '';
                txtData[5] := '';
                recDGLE.RESET;
                recDGLE.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                recDGLE.SETRANGE(recDGLE."Document Line No.", "Sales Invoice Line"."Line No.");
                IF recDGLE.FINDFIRST THEN BEGIN
                    REPEAT
                        IF recDGLE."GST Component Code" = 'IGST' THEN BEGIN
                            txtData[2] := FORMAT(ABS(recDGLE."GST Amount"))
                        END ELSE
                            IF recDGLE."GST Component Code" = 'CGST' THEN BEGIN
                                txtData[3] := FORMAT(ABS(recDGLE."GST Amount"));
                            END ELSE
                                IF recDGLE."GST Component Code" = 'SGST' THEN BEGIN
                                    txtData[4] := FORMAT(ABS(recDGLE."GST Amount"))
                                END ELSE
                                    IF recDGLE."GST Component Code" = 'UTGST' THEN BEGIN
                                        txtData[5] := FORMAT(ABS(recDGLE."GST Amount"))
                                    END
                    UNTIL recDGLE.NEXT = 0;
                END;

                //Lot No Information................................................................................................//ACX_LK
                LotNumber := '';
                txtData[8] := '';
                txtData[6] := '';
                txtData[7] := '';
                recvalueentry.RESET;
                recvalueentry.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recvalueentry.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                IF recvalueentry.FIND('-') THEN BEGIN
                    recile.RESET;
                    recile.SETRANGE("Entry No.", recvalueentry."Item Ledger Entry No.");
                    recile.SETRANGE("Item No.", recvalueentry."Item No.");
                    IF recile.FINDFIRST THEN BEGIN
                        ExpDate := recile."Expiration Date";
                        txtData[8] := FORMAT(ExpDate);
                        LotNumber := recile."Lot No.";
                        txtData[6] := LotNumber;
                        Reclot.RESET;
                        Reclot.SETRANGE("Lot No.", recile."Lot No.");
                        Reclot.SETRANGE("Item No.", recile."Item No.");
                        IF Reclot.FINDFIRST THEN BEGIN
                            MFGDate := Reclot."MFG Date";
                            txtData[7] := FORMAT(MFGDate);

                        END;
                    END;
                END;
                //Sales Header......................................................................................................//
                SHPTOCODE := '';
                SellCSTMNa := '';
                txtData[10] := '';
                txtData[9] := '';
                recsalesHeader.RESET;
                recsalesHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF recsalesHeader.FINDFIRST THEN BEGIN
                    REPEAT
                        txtData[10] := recsalesHeader."Ship-to Code";
                        //txtData[10] := SHPTOCODE;
                        txtData[9] := recsalesHeader."Sell-to Customer Name";
                    //txtData[9] := SellCSTMNa;
                    UNTIL recsalesHeader.NEXT = 0
                END;
                txtData[11] := '';
                recsalesHeader.RESET;
                recsalesHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF recsalesHeader.FINDFIRST THEN BEGIN
                    IF recsalesHeader."Ship-to Code" <> '' THEN
                        recShipToAdd.RESET;
                    recShipToAdd.SETRANGE(recShipToAdd.Code, recsalesHeader."Ship-to Code");
                    IF recShipToAdd.FINDFIRST THEN BEGIN
                        IF recShipToAdd.Name <> '' THEN
                            txtData[11] := recShipToAdd.Name;
                    END ELSE BEGIN
                        recCustomer.RESET;
                        recCustomer.SETRANGE(recCustomer."No.", recsalesHeader."Sell-to Customer No.");
                        IF recCustomer.FINDFIRST THEN BEGIN
                            IF recCustomer.Name <> '' THEN
                                txtData[11] := recCustomer.Name;
                        END;
                    END;
                END;

                //added due date
                txtData[12] := '';
                recsalesHeader.RESET;
                recsalesHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF recsalesHeader.FINDSET THEN
                    REPEAT
                        txtData[12] := FORMAT(recsalesHeader."Due Date");
                    UNTIL recsalesHeader.NEXT = 0;

                //acxcp_151122 //added round off
                dcRoundOff := 0;
                recSIL.RESET;
                recSIL.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recSIL.SETFILTER("System-Created Entry", '%1', TRUE);
                IF recSIL.FINDFIRST THEN BEGIN
                    //dcRoundOff := recSIL."Amount To Customer";
                    dcRoundOff := CU50200.GetAmttoCustomerPostedLine(recSIL."Document No.", recSIL."Line No.");
                END;

                //added Location State Code and Name
                txtData[13] := '';
                txtData[14] := '';
                recLoc.RESET;
                recLoc.SETRANGE(Code, "Sales Invoice Line"."Location Code");
                IF recLoc.FINDFIRST THEN BEGIN
                    recstate.RESET;
                    recstate.SETRANGE(Code, recLoc."State Code");
                    IF recstate.FINDFIRST THEN BEGIN
                        txtData[13] := recstate.Code;
                        txtData[14] := recstate.Description;
                    END;
                END;

                //acxcp_151122



                IF blExptoExcel THEN
                    MakeExcelDataBody;
            end;

            trigger OnPreDataItem()
            begin
                MakeExcelDataHeader;
            end;
        }
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
        {
            DataItemTableView = WHERE(Type = FILTER(Item),
                                      Quantity = FILTER(<> 0));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            var
                SCrMHRec: Record "Sales Cr.Memo Header";
            begin
                //ACXLK...................................................State Des//
                SCrMHRec.Get("Sales Cr.Memo Line"."Document No.");
                txtData[1] := '';
                txtData[16] := '';
                recstate.RESET;
                recstate.SETRANGE(Code, SCrMHRec.State);
                IF recstate.FINDFIRST THEN BEGIN
                    REPEAT
                        txtData[1] := recstate.Description;
                        txtData[16] := recstate.Code;
                    UNTIL recstate.NEXT = 0
                END;

                //IGST.............................................................ACX LK//
                txtData[2] := '';
                txtData[3] := '';
                txtData[4] := '';
                txtData[5] := '';
                recDGLE.RESET;
                recDGLE.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                recDGLE.SETRANGE(recDGLE."Document Line No.", "Sales Cr.Memo Line"."Line No.");
                IF recDGLE.FINDFIRST THEN BEGIN
                    REPEAT
                        IF recDGLE."GST Component Code" = 'IGST' THEN BEGIN
                            txtData[2] := FORMAT(ABS(recDGLE."GST Amount"))
                        END ELSE
                            IF recDGLE."GST Component Code" = 'CGST' THEN BEGIN
                                txtData[3] := FORMAT(ABS(recDGLE."GST Amount"));
                            END ELSE
                                IF recDGLE."GST Component Code" = 'SGST' THEN BEGIN
                                    txtData[4] := FORMAT(ABS(recDGLE."GST Amount"))
                                END ELSE
                                    IF recDGLE."GST Component Code" = 'UTGST' THEN BEGIN
                                        txtData[5] := FORMAT(ABS(recDGLE."GST Amount"))
                                    END
                    UNTIL recDGLE.NEXT = 0;
                END;

                //Lot No Information................................................................................................//ACX_LK
                LotNumber := '';
                txtData[8] := '';
                txtData[6] := '';
                txtData[7] := '';
                recvalueentry.RESET;
                recvalueentry.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recvalueentry.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
                IF recvalueentry.FIND('-') THEN BEGIN
                    recile.RESET;
                    recile.SETRANGE("Entry No.", recvalueentry."Item Ledger Entry No.");
                    recile.SETRANGE("Item No.", recvalueentry."Item No.");
                    IF recile.FINDFIRST THEN BEGIN
                        ExpDate := recile."Expiration Date";
                        txtData[8] := FORMAT(ExpDate);
                        LotNumber := recile."Lot No.";
                        txtData[6] := LotNumber;
                        Reclot.RESET;
                        Reclot.SETRANGE("Lot No.", recile."Lot No.");
                        Reclot.SETRANGE("Item No.", recile."Item No.");
                        IF Reclot.FINDFIRST THEN BEGIN
                            MFGDate := Reclot."MFG Date";
                            txtData[7] := FORMAT(MFGDate);

                        END;
                    END;
                END;
                //Sales Header......................................................................................................//
                SHPTOCODE := '';
                SellCSTMNa := '';
                txtData[10] := '';
                txtData[9] := '';
                recsalesCrHeader.RESET;
                recsalesCrHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
                IF recsalesCrHeader.FINDFIRST THEN BEGIN
                    REPEAT
                        txtData[10] := recsalesCrHeader."Ship-to Code";
                        //txtData[10] := SHPTOCODE;
                        txtData[9] := recsalesCrHeader."Sell-to Customer Name";
                    //txtData[9] := SellCSTMNa;
                    UNTIL recsalesCrHeader.NEXT = 0
                END;
                txtData[11] := '';
                recsalesCrHeader.RESET;
                recsalesCrHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
                IF recsalesCrHeader.FINDFIRST THEN BEGIN
                    IF recsalesCrHeader."Ship-to Code" <> '' THEN
                        recShipToAdd.RESET;
                    recShipToAdd.SETRANGE(recShipToAdd.Code, recsalesCrHeader."Ship-to Code");
                    IF recShipToAdd.FINDFIRST THEN BEGIN
                        IF recShipToAdd.Name <> '' THEN
                            txtData[11] := recShipToAdd.Name;
                    END ELSE BEGIN
                        recCustomer.RESET;
                        recCustomer.SETRANGE(recCustomer."No.", recsalesCrHeader."Sell-to Customer No.");
                        IF recCustomer.FINDFIRST THEN BEGIN
                            IF recCustomer.Name <> '' THEN
                                txtData[11] := recCustomer.Name;
                        END;
                    END;
                END;

                //added due date
                txtData[12] := '';
                recsalesCrHeader.RESET;
                recsalesCrHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
                IF recsalesCrHeader.FINDSET THEN
                    REPEAT
                        txtData[12] := FORMAT(recsalesCrHeader."Due Date");
                    UNTIL recsalesCrHeader.NEXT = 0;

                //acxcp_151122 //added round off
                dcRoundOff := 0;
                recSCML.RESET;
                recSCML.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                recSCML.SETFILTER("System-Created Entry", '%1', TRUE);
                IF recSCML.FINDFIRST THEN BEGIN
                    dcRoundOff := CU50200.GetAmttoCustomerPostedLine(recSCML."Document No.", recSCML."Line No.");
                END;


                //added Location State Code and Name
                txtData[13] := '';
                txtData[14] := '';
                recLoc.RESET;
                recLoc.SETRANGE(Code, "Sales Cr.Memo Line"."Location Code");
                IF recLoc.FINDFIRST THEN BEGIN
                    recstate.RESET;
                    recstate.SETRANGE(Code, recLoc."State Code");
                    IF recstate.FINDFIRST THEN BEGIN
                        txtData[13] := recstate.Code;
                        txtData[14] := recstate.Description;
                    END;
                END;

                //acxcp_151122
                IF blExptoExcel THEN
                    MakeExcelDataBody2;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        blExptoExcel := TRUE;
    end;

    trigger OnPostReport()
    begin
        IF blExptoExcel THEN
            CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        ExcelBuf.DELETEALL;

        IF blExptoExcel THEN
            MakeExcelInfo;
    end;

    var
        ExcelBuf: Record 370;
        blExptoExcel: Boolean;
        recRefSaleInvLine: RecordRef;
        recRefSalesCrLine: RecordRef;
        UserSetup: Record 91;
        blnExportToExcel: Boolean;
        txtData: array[254] of Text[250];
        recstate: Record State;
        recDGLE: Record "Detailed GST Ledger Entry";
        decIGST: Decimal;
        decCGST: Decimal;
        decSGST: Decimal;
        decUTGST: Decimal;
        recile: Record 32;
        Reclot: Record 6505;
        LotNumber: Code[20];
        MFGDate: Date;
        ExpDate: Date;
        recsalesHeader: Record 112;
        SHPTOCODE: Text;
        SellCSTMNa: Text;
        recCustomer: Record 18;
        recShipToAdd: Record 222;
        recvalueentry: Record 5802;
        Data1: Decimal;
        LN: Decimal;
        LN2: Decimal;
        Data3: Decimal;
        TxtCustPostinGrp: Text;
        Text014: Label 'Sales Line Report';
        recsalesCrHeader: Record 114;
        dcRoundOff: Decimal;
        recSIL: Record 113;
        recSCML: Record 115;
        recLoc: Record 14;
        CU50200: Codeunit 50200;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;
        //MakeExcelDataHeader;
    end;

    procedure MakeExcelDataHeader()
    begin

        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                "Sales Invoice Line".SETFILTER("Responsibility Center", '%1', UserSetup."Sales Resp. Ctr. Filter");
        END;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Line Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Invoice Line".GETFILTERS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1
                                                                                                                           /*
                                                                                                                           ExcelBuf.NewRow;
                                                                                                                           ExcelBuf.AddColumn('Doc No',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                                                                                                                           ExcelBuf.AddColumn('Line No',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                                                                                                                           ExcelBuf.AddColumn('Type',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                                                                                                                           ExcelBuf.AddColumn('Item NO',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
                                                                                                                           ExcelBuf.AddColumn('Qty',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Number);
                                                                                                                           */

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('State NAME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn('Posting Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn('Document No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn('STATE CODE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn('STATE - NAME', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//6
        ExcelBuf.AddColumn('Unit Per Parcel', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//7
        ExcelBuf.AddColumn('QTY_PRINCIPAL_UOM', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//8
        ExcelBuf.AddColumn('UNIT_RATE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//9
        ExcelBuf.AddColumn('Line Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//10
        ExcelBuf.AddColumn('IGST Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//11
        ExcelBuf.AddColumn('UTGST AMOUNT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//12
        ExcelBuf.AddColumn('CGST AMOUNT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//13
        ExcelBuf.AddColumn('SGST AMOUNT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//14
        ExcelBuf.AddColumn('Amount to Customer', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn('PARTY', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//17
        ExcelBuf.AddColumn('MFGDATE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//18
        ExcelBuf.AddColumn('EXPDATE', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn('Sell to Customer Code', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn('BATCH', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//21
        ExcelBuf.AddColumn('Line No.', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//22
        ExcelBuf.AddColumn('DISP_DT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//23
        ExcelBuf.AddColumn('DEL_DT', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//24
        ExcelBuf.AddColumn('SR', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//25
        ExcelBuf.AddColumn('Ship-To Code', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//26
        ExcelBuf.AddColumn('Sell-to Customer Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//27
        ExcelBuf.AddColumn('MRP Price', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//28
        ExcelBuf.AddColumn('MRP_PER_PACK', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//29
        ExcelBuf.AddColumn('REMARKS', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//30
        ExcelBuf.AddColumn('STATUS', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//31
        ExcelBuf.AddColumn('Quantity', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//32
        ExcelBuf.AddColumn('Customer Posting Group', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//33
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//34
        ExcelBuf.AddColumn('Line Discount %', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//36
        ExcelBuf.AddColumn('Line Discount Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//37
        ExcelBuf.AddColumn('Round Off', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//38
        ExcelBuf.AddColumn('Location State Code', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//39
        ExcelBuf.AddColumn('Location State Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//40
        ExcelBuf.AddColumn('Document Type', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//1

    end;

    procedure MakeExcelDataBody()
    begin
        // ExcelBuf.NewRow;
        // ExcelBuf.AddColumn("Sales Invoice Line"."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Sales Invoice Line"."Line No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        // ExcelBuf.AddColumn("Sales Invoice Line".Type,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Sales Invoice Line"."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Sales Invoice Line".Quantity,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        //
        //
        // IF blnExportToExcel THEN
        //  MakeExcelDataBody;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//1
        ExcelBuf.AddColumn("Sales Invoice Line"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//2
        ExcelBuf.AddColumn("Sales Invoice Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn(txtData[16], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn("Sales Invoice Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6
        ExcelBuf.AddColumn("Sales Invoice Line"."Units per Parcel", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//7
        ExcelBuf.AddColumn("Sales Invoice Line"."No. of Loose Pack", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//8
        Data1 := 0;
        IF ("Sales Invoice Line"."Unit Price" <> 0) AND ("Sales Invoice Line"."Units per Parcel" <> 0) THEN
            Data1 := "Sales Invoice Line"."Unit Price" / "Sales Invoice Line"."Units per Parcel"
        ELSE
            Data1 := 0;
        ExcelBuf.AddColumn(Data1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//9
        ExcelBuf.AddColumn("Sales Invoice Line"."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//10
        ExcelBuf.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11
        ExcelBuf.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//12
        ExcelBuf.AddColumn(txtData[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//13
        ExcelBuf.AddColumn(txtData[4], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//14
        ExcelBuf.AddColumn(CU50200.GetAmttoCustomerPostedLine("Sales Invoice Line"."Document No.", "Sales Invoice Line"."Line No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//15
        ExcelBuf.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
        ExcelBuf.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//17
        ExcelBuf.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//18
        ExcelBuf.AddColumn("Sales Invoice Line"."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
        LN := 0;
        IF "Sales Invoice Line"."Line No." <> 0 THEN
            LN := ROUND(("Sales Invoice Line"."Line No." / 100), 1, '<')
        ELSE
            LN := 0;
        ExcelBuf.AddColumn(LN, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//21
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//22
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//24
        ExcelBuf.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//25
        ExcelBuf.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//26
        ExcelBuf.AddColumn("Sales Invoice Line"."MRP Price New", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//27
        Data3 := 0;
        IF ("Sales Invoice Line"."MRP Price New" <> 0) AND ("Sales Invoice Line"."Units per Parcel" <> 0) THEN
            Data3 := "Sales Invoice Line"."MRP Price New" / "Sales Invoice Line"."Units per Parcel"
        ELSE
            Data3 := 0;
        ExcelBuf.AddColumn(Data3, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//28
        LN2 := 0;
        IF "Sales Invoice Line"."Line No." <> 0 THEN
            LN2 := ROUND(("Sales Invoice Line"."Line No." / 100), 1, '<')
        ELSE
            LN2 := 0;
        ExcelBuf.AddColumn(LN2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//29
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Invoice Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//31

        //acxcp +
        TxtCustPostinGrp := '';
        recsalesHeader.RESET;
        recsalesHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
        IF recsalesHeader.FINDFIRST THEN BEGIN
            TxtCustPostinGrp := recsalesHeader."Customer Posting Group";
        END;
        ExcelBuf.AddColumn(TxtCustPostinGrp, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//31
        ExcelBuf.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//34
        ExcelBuf.AddColumn("Sales Invoice Line"."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Invoice Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(dcRoundOff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//1
        //acxcp -
    end;

    procedure MakeExcelDataBody2()
    begin
        // ExcelBuf.NewRow;
        // ExcelBuf.AddColumn("Sales Cr.Memo Line"."Document No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Sales Cr.Memo Line"."Line No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        // ExcelBuf.AddColumn("Sales Cr.Memo Line".Type,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Sales Cr.Memo Line"."No.",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        // ExcelBuf.AddColumn("Sales Cr.Memo Line".Quantity,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//1
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//2
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn(txtData[16], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn(txtData[1], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn("Sales Cr.Memo Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Units per Parcel", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//7
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."No. of Loose Pack", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//8
        Data1 := 0;
        IF ("Sales Cr.Memo Line"."Unit Price" <> 0) AND ("Sales Cr.Memo Line"."Units per Parcel" <> 0) THEN
            Data1 := "Sales Cr.Memo Line"."Unit Price" / "Sales Cr.Memo Line"."Units per Parcel"
        ELSE
            Data1 := 0;
        ExcelBuf.AddColumn(Data1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//9
        ExcelBuf.AddColumn(-("Sales Cr.Memo Line"."Line Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//10
        ExcelBuf.AddColumn(txtData[2], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11
        ExcelBuf.AddColumn(txtData[5], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//12
        ExcelBuf.AddColumn(txtData[3], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//13
        ExcelBuf.AddColumn(txtData[4], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//14
        ExcelBuf.AddColumn(-(CU50200.GetAmttoCustomerPostedLine("Sales Cr.Memo Line"."Document No.", "Sales Cr.Memo Line"."Line No.")), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//15
        ExcelBuf.AddColumn(txtData[11], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
        ExcelBuf.AddColumn(txtData[7], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//17
        ExcelBuf.AddColumn(txtData[8], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//18
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Sell-to Customer No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn(txtData[6], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
        LN := 0;
        IF "Sales Cr.Memo Line"."Line No." <> 0 THEN
            LN := "Sales Cr.Memo Line"."Line No." / 100
        ELSE
            LN := 0;
        ExcelBuf.AddColumn(LN, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//21
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//22
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//24
        ExcelBuf.AddColumn(txtData[10], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//25
        ExcelBuf.AddColumn(txtData[9], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//26
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."MRP Price New", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//27
        Data3 := 0;
        IF ("Sales Cr.Memo Line"."MRP Price New" <> 0) AND ("Sales Cr.Memo Line"."Units per Parcel" <> 0) THEN
            Data3 := "Sales Cr.Memo Line"."MRP Price New" / "Sales Cr.Memo Line"."Units per Parcel"
        ELSE
            Data3 := 0;
        ExcelBuf.AddColumn(Data3, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//28
        LN2 := 0;
        IF "Sales Cr.Memo Line"."Line No." <> 0 THEN
            LN2 := "Sales Cr.Memo Line"."Line No." / 100
        ELSE
            LN2 := 0;
        ExcelBuf.AddColumn(LN2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//29
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Sales Cr.Memo Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//31

        //acxcp +
        TxtCustPostinGrp := '';
        recsalesCrHeader.RESET;
        recsalesCrHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
        IF recsalesCrHeader.FINDFIRST THEN BEGIN
            TxtCustPostinGrp := recsalesCrHeader."Customer Posting Group";
        END;
        ExcelBuf.AddColumn(TxtCustPostinGrp, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//31
        ExcelBuf.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//34
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(dcRoundOff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Credit Memo', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//1

        //acxcp -
    end;

    procedure CreateExcelBook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', 'Sheet1', '', '', USERID);
        ExcelBuf.CreateNewBook('Sheet1');
        ExcelBuf.WriteSheet('', COMPANYNAME, USERID);
        ExcelBuf.CloseBook;
        ExcelBuf.OpenExcel;
        ERROR('');
    end;
}

