report 50015 "Branch transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\Branchtransfer.rdl';
    PreviewMode = PrintLayout;
    // UsageCategory = ReportsAndAnalysis;
    // ApplicationArea = All;

    dataset
    {
        dataitem(Integer; 2000000026)
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 3;
            column(intNO; Integer.Number)
            {
            }
            column(text001; Txt001)
            {
            }
            column(pageint; pageint)
            {
            }
            column(pageint1; pageint1)
            {
            }
            column(pageint2; pageint2)
            {
            }
            column(Counter; Counter)
            {
            }
            dataitem("Transfer Shipment Header"; 5744)
            {
                PrintOnlyIfDetail = false;
                RequestFilterFields = "No.";
                UseTemporary = false;
                column(CompName; recCompInfo.Name)
                {
                }
                column(ContactNo; recCompInfo."Phone No.")
                {
                }
                column(CompEmail; recCompInfo."E-Mail")
                {
                }
                column(FAX; recCompInfo."Fax No.")
                {
                }
                column(HomePage; recCompInfo."Home Page")
                {
                }
                column(Comppan; recCompInfo."P.A.N. No.")
                {
                }
                column(CompCIN; recCompInfo."GST Registration No.")
                {
                }
                column(CompLogo; recCompInfo.Picture)
                {
                }
                column(BankName; recCompInfo."Bank Name")
                {
                }
                column(BankBranch; recCompInfo."Bank Branch No.")
                {
                }
                column(BankAccNo; recCompInfo."Bank Account No.")
                {
                }
                column(CompRegAdd; recCompInfo."Registration Address")
                {
                }
                column(CompRegAdd2; recCompInfo."Registration Address 2")
                {
                }
                column(CompRegAddCity; recCompInfo."Registration City")
                {
                }
                column(CompRegAddPC; recCompInfo."Registration Post code")
                {
                }
                column(CompRegAddState; recCompInfo."Registration State")
                {
                }
                column(CompAdd; recCompInfo.Address)
                {
                }
                column(CompAdd2; recCompInfo."Address 2")
                {
                }
                column(CopmCity; recCompInfo.City)
                {
                }
                column(CompPC; recCompInfo."Post Code")
                {
                }
                column(CompState; recCompInfo."State Code")
                {
                }
                column(TFromName; arrLoc[1])
                {
                }
                column(TFromName2; arrLoc[2])
                {
                }
                column(TFromAdd; arrLoc[3])
                {
                }
                column(TFromAdd2; arrLoc[4])
                {
                }
                column(TFromCity; arrLoc[5])
                {
                }
                column(TFromPC; arrLoc[6])
                {
                }
                column(TFromGSTIN; arrLoc[7])
                {
                }
                column(TFromState; arrLoc[8])
                {
                }
                column(TFromStateID; arrLoc[9])
                {
                }
                column(TFromCountry; arrLoc[10])
                {
                }
                column(TFromPh; arrLoc[11])
                {
                }
                column(TFromEmail; arrLoc[12])
                {
                }
                column(IRN; IRNNo)
                {
                }
                column(AckNo; AcknowledgeNo)
                {
                }
                column(AckDt; AckDateandTime)
                {
                }
                column(QRCode; recEWayBill."QR Code")
                {
                }
                column(EWayBillNo; EWayBillNo)
                {
                }
                column(EWayBillDt; EWayBillDt)
                {
                }
                column(PestLICNo; '')
                {
                }
                column(PestLICUpto; '')
                {
                }
                column(InvoiceNo; "Transfer Shipment Header"."No.")
                {
                }
                column(InvoiceDt; "Transfer Shipment Header"."Posting Date")
                {
                }
                column(DueDtTransfer; '')
                {
                }
                column(VehicelNo; VehivleNo)
                {
                }
                column(GRNo; GRNo)
                {
                }
                column(GRDt; GRDt)
                {
                }
                column(CustPONo; "Transfer Shipment Header"."External Document No.")
                {
                }
                column(TToName; arrLoc2[1])
                {
                }
                column(TToName2; arrLoc2[2])
                {
                }
                column(TToAdd; arrLoc2[3])
                {
                }
                column(TToAdd2; arrLoc2[4])
                {
                }
                column(TToCity; arrLoc2[5])
                {
                }
                column(TToPC; arrLoc2[6])
                {
                }
                column(TToGSTIN; arrLoc2[7])
                {
                }
                column(TToState; arrLoc2[8])
                {
                }
                column(TToStateID; arrLoc2[9])
                {
                }
                column(TToCountry; arrLoc2[10])
                {
                }
                column(TToPh; arrLoc2[11])
                {
                }
                column(TToEmail; arrLoc2[12])
                {
                }
                column(TransporterName; TransporterName)
                {
                }
                dataitem("Transfer Shipment Line"; 5745)
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    column(SrNo; SrNo)
                    {
                    }
                    column(ItemDes; "Transfer Shipment Line".Description)
                    {
                    }
                    column(ItemUOM; "Transfer Shipment Line"."Unit of Measure Code")
                    {
                    }
                    column(ItemDes2; "Transfer Shipment Line"."Description 2")
                    {
                    }
                    column(MfgDt; MfgDt)
                    {
                    }
                    column(ExpiryDt; ExpiryDt)
                    {
                    }
                    column(TotLineQty; TotLineQty)
                    {
                    }
                    column(LotNo; LotNo)
                    {
                    }
                    column(HSN; "Transfer Shipment Line"."HSN/SAC Code")
                    {
                    }
                    column(Qty; "Transfer Shipment Line".Quantity)
                    {
                    }
                    column(Qty2; '')
                    {
                    }
                    column(UnitPrice; "Transfer Shipment Line"."Unit Price")
                    {
                    }
                    //field not found in BC
                    column(MrpPrice; 0)
                    {
                    }
                    //field not found in BC
                    column(Amount; "Transfer Shipment Line".Amount)
                    {
                    }
                    column(LineDiscount; '')
                    {
                    }
                    column(SchemeDate; '')
                    {
                    }
                    column(TotalBaseAmt; TotalBaseAmt)
                    {
                    }
                    column(GSTBaseAmt; GSTBaseAmt)
                    {
                    }
                    column(GST_per; totgstpercentage)
                    {
                    }
                    // column(totgstpercentage; totgstpercentage + '%')
                    // {
                    // }
                    // column(NetAmt; "Transfer Shipment Line".Amount + TotalBaseAmt)
                    // {
                    // }
                    column(NetAmt; netamt)
                    {
                    }
                    column(IGST; IGSTamt)
                    {
                    }
                    column(IGST_Per; IGSTper)
                    {
                    }
                    column(CGST; CGSTamt)
                    {
                    }
                    column(CGST_Per; CGSTper)
                    {
                    }
                    column(SGST; SGSTamt)
                    {
                    }
                    column(SGST_Per; SGSTper)
                    {
                    }
                    column(CGSTTax; CGSTTax)
                    {
                    }
                    column(SGSTTax; SGSTTax)
                    {
                    }
                    column(IGSTTax; IGSTTax)
                    {
                    }
                    column(QtyPer; decQtyper)
                    {
                    }
                    // column(TotalInvvalue; TotalInvvalue)
                    // {
                    // }
                    column(TotalInvvalue; TotalInvvalue)
                    {
                    }
                    column(AmountinWord; UpperCase(NotoWord[1] + ' ' + NotoWord[2]))
                    {
                    }
                    column(TotlQtyBag; TotlQtyBag)
                    {
                    }
                    column(TotalInvvalueRoundOff; TotalInvvalueRoundOff)
                    {
                    }
                    column(RoundOffValue; RoundOffValue)
                    {
                    }
                    column(LineNoS; "Transfer Shipment Line"."Line No.")
                    {
                    }
                    column(DocNo; "Transfer Shipment Line"."Document No.")
                    {
                    }
                    column(GSTGrpCode; GSTGrpCode)
                    {
                    }
                    dataitem("Item Ledger Entry"; 32)
                    {
                        DataItemLink = "Document No." = FIELD("Document No."),
                                       "Document Line No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Entry No.");
                        column(Lot; "Item Ledger Entry"."Lot No.")
                        {
                        }
                        column(LotQty; ABS("Item Ledger Entry".Quantity))
                        {
                        }
                        column(ExpDt; "Item Ledger Entry"."Expiration Date")
                        {
                        }
                        column(Mfg_Dt; dtMfgDate)
                        {
                        }
                        column(BatchMRP; BMRP)
                        {
                        }
                        column(AlternateQty; ABS(AlternateQty))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //Unit of Measure Conversion
                            AlternateQty := 0;
                            recItemUOM.RESET();
                            recItemUOM.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                            IF recItemUOM.FIND('-') THEN
                                IF recItemUOM.Code = 'CTN' THEN BEGIN
                                    AlternateQty := "Item Ledger Entry".Quantity / recItemUOM."Qty. per Unit of Measure";
                                END ELSE
                                    IF recItemUOM.Code = 'BAG' THEN BEGIN
                                        AlternateQty := "Item Ledger Entry".Quantity / recItemUOM."Qty. per Unit of Measure";
                                    END;

                            dtMfgDate := 0D;
                            BMRP := 0;
                            recLotNoInfo.RESET;
                            recLotNoInfo.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                            recLotNoInfo.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                            IF recLotNoInfo.FINDFIRST THEN BEGIN
                                dtMfgDate := recLotNoInfo."MFG Date";
                                BMRP := recLotNoInfo."Batch MRP";
                            END;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //Serial No. for Number of Items
                        SrNo += 1;

                        totgstpercentage := 0;
                        DGLERec.Reset();
                        DGLERec.SetRange("Document No.", "Transfer Shipment Line"."Document No.");
                        DGLERec.SetRange("Document Line No.", "Transfer Shipment Line"."Line No.");
                        DGLERec.SetRange("No.", "Transfer Shipment Line"."Item No.");
                        if DGLERec.FindFirst() then begin
                            totgstpercentage := DGLERec."GST %";
                            netamt := "Transfer Shipment Line".Amount + (("Transfer Shipment Line".Amount) * ((DGLERec."GST %") / 100));
                            GSTGrpCode := DGLERec."GST Group Code";
                            //totinvval1 := totinvval1 + netamt;
                        end;

                        //Batch Details
                        LotNo := '';
                        MfgDt := 0D;
                        ExpiryDt := 0D;
                        MRPPrice := 0;
                        recILE.SETRANGE("Document No.", "Transfer Shipment Line"."Document No.");
                        IF recILE.FINDFIRST THEN BEGIN
                            LotNo := recILE."Lot No.";
                            //    MfgDt := recILE."Manufacturing Date";
                            ExpiryDt := recILE."Expiration Date";
                            //    MRPPrice := recILE."Batch MRP";
                        END;


                        recItemUOM.RESET();
                        recItemUOM.SETRANGE("Item No.", "Transfer Shipment Line"."Item No.");
                        recItemUOM.SETFILTER(Code, '<>%1', "Transfer Shipment Line"."Unit of Measure Code");
                        IF recItemUOM.FIND('-') THEN BEGIN
                            decQtyper := recItemUOM."Qty. per Unit of Measure" * "Transfer Shipment Line".Quantity;
                            TotlQtyBag += "Transfer Shipment Line".Quantity * recItemUOM."Qty. per Unit of Measure";
                        END;

                        //
                        IGSTamt := 0;
                        IGSTper := 0;
                        IgstBaseAmt := 0;
                        recDetGSTLedAntry.RESET();
                        recDetGSTLedAntry.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                        recDetGSTLedAntry.SETFILTER("GST Component Code", 'IGST');
                        recDetGSTLedAntry.SETRANGE("Document Line No.", "Transfer Shipment Line"."Line No.");
                        IF recDetGSTLedAntry.FindFirst() THEN BEGIN
                            IGSTamt := ABS(recDetGSTLedAntry."GST Amount");
                            IGSTper := recDetGSTLedAntry."GST %";
                            IgstBaseAmt := Abs(recDetGSTLedAntry."GST Base Amount");
                            IGSTTax := Abs(recDetGSTLedAntry."GST Base Amount");
                        END;

                        CGSTamt := 0;
                        CGSTper := 0;
                        CgstBaseAmt := 0;
                        recDetGSTLedAntry.RESET();
                        recDetGSTLedAntry.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                        recDetGSTLedAntry.SETFILTER("GST Component Code", 'CGST');
                        recDetGSTLedAntry.SETRANGE("Document Line No.", "Transfer Shipment Line"."Line No.");
                        IF recDetGSTLedAntry.FindFirst() THEN BEGIN
                            CGSTamt := ABS(recDetGSTLedAntry."GST Amount");
                            CGSTper := recDetGSTLedAntry."GST %";
                            CgstBaseAmt := Abs(recDetGSTLedAntry."GST Base Amount");
                            CGSTTax := Abs(recDetGSTLedAntry."GST Base Amount");
                        END;

                        SGSTamt := 0;
                        SGSTper := 0;
                        SgstBaseAmt := 0;
                        recDetGSTLedAntry.RESET();
                        recDetGSTLedAntry.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                        recDetGSTLedAntry.SETFILTER("GST Component Code", 'SGST');
                        recDetGSTLedAntry.SETRANGE("Document Line No.", "Transfer Shipment Line"."Line No.");
                        IF recDetGSTLedAntry.FindFirst() THEN BEGIN
                            SGSTamt := ABS(recDetGSTLedAntry."GST Amount");
                            SGSTper := recDetGSTLedAntry."GST %";
                            SgstBaseAmt := Abs(recDetGSTLedAntry."GST Base Amount");
                            SGSTTax := Abs(recDetGSTLedAntry."GST Base Amount");
                        END;

                        Clear(TotalBaseAmt);
                        Clear(GstBaseAmt);
                        TotalBaseAmt := IgstBaseAmt + CgstBaseAmt + SgstBaseAmt;
                        GstBaseAmt := IGSTamt + CGSTamt + SGSTamt;
                        //

                        //Total Invoic value
                        recTransShipLine.RESET();
                        recTransShipLine.SETRANGE("Document No.", "Transfer Shipment Line"."Document No.");
                        recTransShipLine.SETRANGE("Line No.", "Transfer Shipment Line"."Line No.");
                        recTransShipLine.SetRange("Item No.", "Transfer Shipment Line"."Item No.");
                        IF recTransShipLine.FINDFIRST THEN BEGIN
                            REPEAT
                                //TotalInvvalue += recTransShipLine."Total GST Amount" + recTransShipLine.Amount;
                                TotalInvvalue += GstBaseAmt + recTransShipLine.Amount;
                                TotLineQty += recTransShipLine.Quantity;
                            UNTIL recTransShipLine.NEXT = 0;
                        END;

                        //Round of Calculation
                        TotalInvvalueRoundOff := ROUND(TotalInvvalue, 1);
                        RoundOffValue := TotalInvvalue - TotalInvvalueRoundOff;
                        //repCheck.InitTextVariable();
                        //repCheck.FormatNoText(NotoWord, TotalInvvalue, '');
                        //repCheck.FormatNoText(NotoWord, TotalInvvalue, '');
                        //16767 NotoWord[1] := UpperCase(NotoWord[1])

                    end;


                }
                trigger OnAfterGetRecord()
                var
                    DFLERec1: Record "Detailed GST Ledger Entry";
                begin
                    DFLERec1.RESET();
                    DFLERec1.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                    IF DFLERec1.FINDFIRST THEN BEGIN
                        REPEAT
                            toinvvalueinword := toinvvalueinword + Abs(DFLERec1."GST Base Amount") + Abs(DFLERec1."GST Amount");
                        UNTIL DFLERec1.NEXT = 0;
                    END;
                    repCheck.InitTextVariable();
                    repCheck.FormatNoText(NotoWord, toinvvalueinword, '');

                    //Transfer From Location Details
                    TotalInvvalue := 0;
                    recLoc.RESET();
                    CLEAR(arrLoc);
                    recLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-from Code");
                    IF recLoc.FIND('-') THEN BEGIN
                        arrLoc[1] := recLoc.Name;
                        arrLoc[2] := recLoc."Name 2";
                        arrLoc[3] := recLoc.Address;
                        arrLoc[4] := recLoc."Address 2";
                        arrLoc[5] := recLoc.City;
                        arrLoc[6] := recLoc."Post Code";
                        arrLoc[7] := recLoc."GST Registration No.";
                        arrLoc[11] := recLoc."Phone No.";
                        arrLoc[12] := recLoc."E-Mail";
                        recState.RESET();
                        recState.SETRANGE(Code, recLoc."State Code");
                        IF recState.FIND('-') THEN BEGIN
                            arrLoc[8] := recState.Description;
                            arrLoc[9] := recState."State Code (GST Reg. No.)";
                        END;
                        recCountry.RESET();
                        recCountry.SETRANGE(Code, recLoc."Country/Region Code");
                        IF recCountry.FIND('-') THEN
                            arrLoc[10] := recCountry.Name;
                    END;



                    //Transfer-to Location Details
                    recLoc.RESET();
                    CLEAR(arrLoc2);
                    recLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-to Code");
                    IF recLoc.FIND('-') THEN BEGIN
                        arrLoc2[1] := recLoc.Name;
                        arrLoc2[2] := recLoc."Name 2";
                        arrLoc2[3] := recLoc.Address;
                        arrLoc2[4] := recLoc."Address 2";
                        arrLoc2[5] := recLoc.City;
                        arrLoc2[6] := recLoc."Post Code";
                        arrLoc2[7] := recLoc."GST Registration No.";
                        arrLoc2[11] := recLoc."Phone No.";
                        arrLoc2[12] := recLoc."E-Mail";
                        recState.RESET();
                        recState.SETRANGE(Code, recLoc."State Code");
                        IF recState.FIND('-') THEN BEGIN
                            arrLoc2[8] := recState.Description;
                            arrLoc2[9] := recState."State Code (GST Reg. No.)";
                        END;
                        recCountry.RESET();
                        recCountry.SETRANGE(Code, recLoc."Country/Region Code");
                        IF recCountry.FIND('-') THEN
                            arrLoc2[10] := recCountry.Name;
                    END;

                    //E Way E Invoice Details
                    recEWayBill.RESET();
                    recEWayBill.SETRANGE("No.", "Transfer Shipment Header"."No.");
                    IF recEWayBill.FINDFIRST THEN BEGIN
                        AcknowledgeNo := recEWayBill."E-Invoice Acknowledge No.";
                        AcknowledgeDt := recEWayBill."E-Invoice Acknowledge Date";
                        IRNNo := recEWayBill."E-Invoice IRN No";
                        VehivleNo := recEWayBill."Vehicle No.";
                        GRNo := recEWayBill."LR/RR No.";
                        GRDt := recEWayBill."LR/RR Date";
                        TransporterName := recEWayBill."Transporter Name";
                        EWayBillNo := recEWayBill."E-Way Bill No.";
                        EWayBillDttxt := recEWayBill."E-Way Bill Date";
                        recEWayBill.CALCFIELDS("QR Code");
                    END;
                    //E-Way Bill Date
                    IF EWayBillNo <> '' THEN BEGIN
                        Year := 0;
                        Day := 0;
                        Month := 0;
                        EVALUATE(Year, COPYSTR(EWayBillDttxt, 7, 4));
                        EVALUATE(Month, COPYSTR(EWayBillDttxt, 4, 2));
                        EVALUATE(Day, COPYSTR(EWayBillDttxt, 1, 2));
                        EWayBillDt := DMY2DATE(Day, Month, Year);
                    END;
                    //22/05/2021 11:28:00 AM
                    //E-Invoice Date
                    IF AcknowledgeNo <> '' THEN BEGIN
                        EVALUATE(Year, COPYSTR(AcknowledgeDt, 1, 4));
                        EVALUATE(Month, COPYSTR(AcknowledgeDt, 6, 2));
                        EVALUATE(Day, COPYSTR(AcknowledgeDt, 9, 2));
                        AckDateandTime := DMY2DATE(Day, Month, Year);
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SrNo := 0;
                    TotLineQty := 0;
                    decQtyper := 0;
                    TotlQtyBag := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Counter += 1;
                IF Counter = 1 THEN
                    Txt001 := 'Original For Buyer'
                ELSE
                    IF Counter = 2 THEN
                        Txt001 := 'Duplicate for Transporter'
                    ELSE
                        IF Counter = 3 THEN
                            Txt001 := 'Triplicate for Supplier'
                        ELSE
                            Txt001 := 'Extra Copy';

                IF Counter = 1 THEN
                    pageint += 1
                ELSE
                    IF Counter = 2 THEN
                        pageint1 += 1
                    ELSE
                        IF Counter = 3 THEN
                            pageint2 += 1;

                IF (Counter <> 1) AND (NOT "Duplicate For Transporter") AND (NOT AllCopies)
                  AND (NOT "Triplicate For Assee") AND (NOT "Extra Copy") THEN
                    CurrReport.SKIP;


                IF ("Duplicate For Transporter") AND (Counter <> 2) THEN
                    CurrReport.SKIP;

                IF ("Triplicate For Assee") AND (Counter <> 3) THEN
                    CurrReport.SKIP;

                IF "Extra Copy" AND (Counter < 4) THEN
                    CurrReport.SKIP;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AllCopies; AllCopies)
                    {
                        Caption = 'All Copies';
                        ApplicationArea = all;
                    }
                    field("Duplicate For Transporter"; "Duplicate For Transporter")
                    {
                        Caption = 'Duplicate For Transporter';
                        ApplicationArea = all;
                    }
                    field("Triplicate For Assee"; "Triplicate For Assee")
                    {
                        Caption = 'Triplicate For Assee';
                        ApplicationArea = all;
                    }
                    field("Extra Copy"; "Extra Copy")
                    {
                        Caption = 'Extra Copy';
                        ApplicationArea = all;
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

    trigger OnPreReport()
    begin
        recCompInfo.GET();
        recCompInfo.CALCFIELDS(Picture);
    end;

    procedure GSTper(DocumentNo: Code[20]; DocLineNo: Integer): Decimal
    var
        TotalGSTPer: Decimal;
        DetGstLedEntry: Record "Detailed GST Ledger Entry";
        IGSTPer: Decimal;
        GSTBaseAmt: Decimal;
        SGSTPer: Decimal;
        CGSTPer: Decimal;
    begin
        Clear(IGSTPer);
        Clear(GSTBaseAmt);
        Clear(SGSTPer);
        Clear(CGSTPer);

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'IGST');
        IF DetGstLedEntry.FINDFIRST THEN
            IGSTPer := Abs(DetGstLedEntry."GST %");


        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'SGST');
        IF DetGstLedEntry.FINDFIRST THEN
            //SGSTAmt := abs(DetGstLedEntry."GST Amount");
            SGSTPer := Abs(DetGstLedEntry."GST %");

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN
            //CGSTAmt := abs(DetGstLedEntry."GST Amount");
            CGSTPer := Abs(DetGstLedEntry."GST %");

        Clear(TotalGSTPer);
        TotalGSTPer := IGSTPer + SGSTPer + CGSTPer;
        EXIT(ABS(TotalGSTPer));
    end;

    var
        recCompInfo: Record 79;
        recLoc: Record 14;
        arrLoc: array[12] of Text;
        recState: Record State;
        recCountry: Record 9;
        recEWayBill: Record 50000;
        IRNNo: Text;
        AcknowledgeNo: Code[20];
        AcknowledgeDt: Text;
        VehivleNo: Code[20];
        GRNo: Code[10];
        GRDt: Date;
        arrLoc2: array[12] of Text;
        SrNo: Integer;
        recILE: Record 32;
        LotNo: Code[15];
        MfgDt: Date;
        ExpiryDt: Date;
        MRPPrice: Decimal;
        TransporterName: Text;
        recDetGSTLedAntry: Record "Detailed GST Ledger Entry";
        IGSTamt: Decimal;
        CGSTamt: Decimal;
        SGSTamt: Decimal;
        IGSTper: Decimal;
        CGSTper: Decimal;
        SGSTper: Decimal;
        decQtyper: Decimal;
        recItemUOM: Record 5404;
        //16767 repCheck: Report 1401;
        repCheck: Report "Check Report";
        NotoWord: array[2] of Text;
        TotlQtyBag: Decimal;
        recTransShipLine: Record 5745;
        TotalInvvalue: Decimal;
        TimeFormat: Text;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        Hour: Integer;
        Minute: Integer;
        Sec: Integer;
        text: Text;
        Timee: Time;
        AckDateandTime: Date;
        LRNoLRDt: Text;
        Counter: Integer;
        Txt001: Text;
        AllCopies: Boolean;
        "Duplicate For Transporter": Boolean;
        "Triplicate For Assee": Boolean;
        "Extra Copy": Boolean;
        pageint: Integer;
        pageint1: Integer;
        pageint2: Integer;
        EWayBillNo: Code[15];
        EWayBillDt: Date;
        EWayBillDttxt: Text;
        TotalInvvalueRoundOff: Decimal;
        RoundOffValue: Decimal;
        AlternateQty: Decimal;
        CGSTTax: Decimal;
        SGSTTax: Decimal;
        IGSTTax: Decimal;
        TotLineQty: Decimal;
        dtMfgDate: Date;
        recLotNoInfo: Record 6505;
        decMRP: Decimal;
        BMRP: Decimal;
        recVendor: Record 23;
        IgstBaseAmt: Decimal;
        SgstBaseAmt: Decimal;
        CgstBaseAmt: Decimal;
        TotalBaseAmt: Decimal;
        GstBaseAmt: Decimal;
        totgstpercentage: Decimal;
        DGLERec: Record "Detailed GST Ledger Entry";
        netamt: Decimal;
        totinvval1: Decimal;
        toinvvalueinword: Decimal;
        GSTGrpCode: Code[20];
}