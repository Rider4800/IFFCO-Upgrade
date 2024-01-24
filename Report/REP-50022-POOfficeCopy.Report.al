report 50022 "PO-OfficeCopy"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\POOfficeCopy.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(CompName; recCompInfo.Name)
            {
            }
            column(CompAdd; recCompInfo.Address)
            {
            }
            column(CompAdd2; recCompInfo."Address 2")
            {
            }
            column(CompCity; recCompInfo.City)
            {
            }
            column(CompPC; recCompInfo."Post Code")
            {
            }
            column(CompEmail; recCompInfo."E-Mail")
            {
            }
            column(CompPh; recCompInfo."Phone No.")
            {
            }
            column(CompLogo; recCompInfo.Picture)
            {
            }
            column(CIN; recCompInfo."GST Registration No.")
            {
            }
            column(Caption; Caption)
            {
            }
            column(LocName; arrLocatoin[1])
            {
            }
            column(LocAdd; arrLocatoin[2])
            {
            }
            column(LocAdd2; arrLocatoin[3])
            {
            }
            column(LocCity; arrLocatoin[4])
            {
            }
            column(LocStateName; arrLocatoin[5])
            {
            }
            column(LocPostCode; arrLocatoin[6])
            {
            }
            column(LocGSTIN; arrLocatoin[7])
            {
            }
            column(LocCIN; arrLocatoin[8])
            {
            }
            column(LocPAN; arrLocatoin[9])
            {
            }
            column(LocStateCode; arrLocatoin[10])
            {
            }
            column(LocName2; arrLocatoin[11])
            {
            }
            column(ShipToLocName; arrShipToLoc[1])
            {
            }
            column(ShipToLocAddress; arrShipToLoc[2])
            {
            }
            column(ShipToLocAdd2; arrShipToLoc[3])
            {
            }
            column(ShipToLocCity; arrShipToLoc[4])
            {
            }
            column(ShipToLocPostCode; arrShipToLoc[5])
            {
            }
            column(ShipToLocState; arrShipToLoc[6])
            {
            }
            column(DocumentDt; "Purchase Header"."No.")
            {
            }
            column(PostinDt; "Purchase Header"."Posting Date")
            {
            }
            column(Orderdt; "Purchase Header"."Order Date")
            {
            }
            column(DocuDt; "Purchase Header"."Document Date")
            {
            }
            column(PaymentTerms; PaymentTermDesc)
            {
            }
            column(VendorNo; "Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(VendorName; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(VendAdd; "Purchase Header"."Buy-from Address")
            {
            }
            column(VendAdd2; "Purchase Header"."Buy-from Address 2")
            {
            }
            column(VendState; arrVendor[2])
            {
            }
            column(VendPAN; arrVendor[1])
            {
            }
            column(VendorGST; GSTN)
            {
            }
            column(VendCity; "Purchase Header"."Buy-from City")
            {
            }
            column(Comment_Header; Comment_Header)
            {
            }
            column(RevisionNo; RevisionNo)
            {
            }
            column(RevisionDt; RevisionDt)
            {
            }
            column(ShipMethCode; "Purchase Header"."Shipment Method Code")
            {
            }
            column(MRPCtntext; MRPCtntext)
            {
            }
            column(MRPpacktext; MRPpacktext)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(SrNo; Srno)
                {
                }
                column(ItemNo; "Purchase Line"."No.")
                {
                }
                column(ItemName; "Purchase Line".Description)
                {
                }
                column(ItemName2; "Purchase Line"."Description 2")
                {
                }
                column(HSNCode; "Purchase Line"."HSN/SAC Code")
                {
                }
                column(Qty; "Purchase Line".Quantity)
                {
                }
                column(Price; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(Amount; "Purchase Line"."Line Amount")
                {
                }
                column(GSTAmt; CU50200.TotalGSTAmtLine("Purchase Line")) //16767"Purchase Line"."Total GST Amount"
                {
                }
                column(UOM; "Purchase Line"."Unit of Measure Code")
                {
                }
                column(GstPercentage; GstPer("Purchase Line")) //16767 "Purchase Line"."GST %"
                {
                }
                column(TotalGSTAmount; CU50200.TotalGSTAmtLine("Purchase Line")) //16767 "Purchase Line"."Total GST Amount"
                {
                }
                column(LineDiscount; "Purchase Line"."Line Discount %")
                {
                }
                column(IGST; IGST_Total)
                {
                }
                column(CGST; CGST_Total)
                {
                }
                column(SGST; SGST_Total)
                {
                }
                column(LooseperPack; LooseperPack)
                {
                }
                column(AmountToWord; NoToWord[1])
                {
                }
                column(totAmount; totAmount)
                {
                }
                column(totQty; totQty)
                {
                }
                column(LineQty; LineQty)
                {
                }
                column(PurchUOMQty; PurchUOMQty)
                {
                }
                column(MRPPrice_PurchaseLine; "Purchase Line"."MRP Price")
                {
                }
                column(MRP_PerPack; decMRP_Pack)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Srno += 1;
                    if Srno = 1 then begin
                        PLRec.Reset();
                        PLRec.SetRange("Document No.", "Purchase Line"."Document No.");
                        if PLRec.findset() then
                            repeat
                                SGST_Total := SGST_Total + CU50200.PurchLineSGST(PLRec);
                                CGST_Total := CGST_Total + CU50200.PurchLineCGST(PLRec);
                                IGST_Total := IGST_Total + CU50200.PurchLineIGST(PLRec);
                            until PLRec.Next() = 0;
                    end;
                    // SGST_Total := 0;
                    // recGSTLedgerBuffer.RESET();
                    // recGSTLedgerBuffer.SETRANGE("Document No.", "Purchase Header"."No.");
                    // recGSTLedgerBuffer.SETRANGE("GST Component Code", 'SGST');
                    // IF recGSTLedgerBuffer.FIND('-') THEN BEGIN
                    //     REPEAT
                    //         SGST_Total += ABS(recGSTLedgerBuffer."GST Amount");
                    //     UNTIL recGSTLedgerBuffer.NEXT = 0;
                    // END;

                    // CGST_Total := 0;
                    // recGSTLedgerBuffer.RESET();
                    // recGSTLedgerBuffer.SETRANGE("Document No.", "Purchase Header"."No.");
                    // recGSTLedgerBuffer.SETRANGE("GST Component Code", 'CGST');
                    // IF recGSTLedgerBuffer.FIND('-') THEN BEGIN
                    //     REPEAT
                    //         CGST_Total += ABS(recGSTLedgerBuffer."GST Amount");
                    //     UNTIL recGSTLedgerBuffer.NEXT = 0;
                    // END;

                    // IGST_Total := 0;
                    // recGSTLedgerBuffer.RESET();
                    // recGSTLedgerBuffer.SETRANGE("Document No.", "Purchase Header"."No.");
                    // recGSTLedgerBuffer.SETRANGE("GST Component Code", 'IGST');
                    // IF recGSTLedgerBuffer.FIND('-') THEN BEGIN
                    //     REPEAT
                    //         IGST_Total += ABS(recGSTLedgerBuffer."GST Amount");
                    //     UNTIL recGSTLedgerBuffer.NEXT = 0;
                    // END;
                    //Loose per Pack
                    recItem.SETRANGE("No.", "Purchase Line"."No.");
                    IF recItem.FINDFIRST THEN
                        LooseperPack := recItem."Units per Parcel" * "Purchase Line".Quantity;
                    decUnitperparcel := recItem."Units per Parcel"; //acxcp
                    //Total Amount
                    recPurchLine.SETRANGE("Document No.", "Purchase Line"."Document No.");
                    IF recPurchLine.FIND('-') THEN BEGIN
                        REPEAT
                            //16767  totAmount += recPurchLine."Amount To Vendor";
                            totAmount += CU50200.AmttoVendorLine(recPurchLine);
                            totQty += recPurchLine.Quantity;
                        UNTIL recPurchLine.NEXT = 0;
                    END;

                    //acxcp
                    recItem.SETRANGE("No.", "Purchase Line"."No.");
                    IF recItem.FINDFIRST THEN
                        IF "Purchase Line"."MRP Price" <> 0 THEN BEGIN
                            IF recItem."Units per Parcel" <> 0 THEN BEGIN
                                decMRP_Pack := "Purchase Line"."MRP Price" / recItem."Units per Parcel"
                            END;
                        END;

                    //acxcp

                    //Amount in word
                    InitTextVariable();
                    FormatNoText(NoToWord, totAmount, '');

                    IF "Purchase Header"."Vendor Posting Group" = 'FG SUPP' THEN
                        LineQty := "Purchase Line".Quantity;
                    //Unit of Measure Conversion
                    PurchUOMQty := 0;
                    recIUOM.SETRANGE("Item No.", "Purchase Line"."No.");
                    recIUOM.SETRANGE(Code, "Purchase Line"."Unit of Measure Code");
                    IF recIUOM.FIND('-') THEN
                        //     IF recIUOM.Code = 'CTN' THEN BEGIN
                        PurchUOMQty := "Purchase Line".Quantity * recIUOM."Qty. per Unit of Measure";
                    //     END ELSE IF recIUOM.Code = 'BAG' THEN BEGIN
                    //       PurchUOMQty := "Purchase Line".Quantity * recIUOM."Qty. per Unit of Measure";
                    //    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GSTN := '';
                IF "Purchase Header"."Order Address Code" <> '' THEN
                    GSTN := "Purchase Header"."Order Address GST Reg. No."
                ELSE
                    GSTN := "Purchase Header"."Vendor GST Reg. No.";



                //Location Details
                CLEAR(arrLocatoin);
                recLocation.SETRANGE(Code, "Purchase Header"."Location Code");
                IF recLocation.FIND('-') THEN BEGIN
                    arrLocatoin[1] := recLocation.Name;
                    arrLocatoin[2] := recLocation.Address;
                    arrLocatoin[3] := recLocation."Address 2";
                    arrLocatoin[4] := recLocation.City;
                    recState.SETRANGE(Code, recLocation."State Code");
                    IF recState.FIND('-') THEN BEGIN
                        arrLocatoin[5] := recState.Description;
                        arrLocatoin[10] := recState."State Code (GST Reg. No.)";
                    END;
                    arrLocatoin[6] := recLocation."Post Code";
                    arrLocatoin[7] := recLocation."GST Registration No.";
                    arrLocatoin[8] := '';
                    arrLocatoin[9] := COPYSTR(recLocation."GST Registration No.", 3, 10);
                    arrLocatoin[11] := recLocation."Name 2";
                END;
                //ACXCP_16052022 + //ShiptoAddress Detail for PO Report

                CLEAR(arrShipToLoc);
                recLoc.RESET;
                recLoc.SETRANGE(Code, "Purchase Header"."Location Code");
                IF recLoc.FINDFIRST THEN BEGIN
                    IF recLoc.ShipToAddress THEN BEGIN
                        arrShipToLoc[1] := recLoc."Ship-To Name";
                        arrShipToLoc[2] := recLoc."Ship-To Address";
                        arrShipToLoc[3] := recLoc."Ship-To Address2";
                        arrShipToLoc[4] := recLoc."Ship-To City";
                        arrShipToLoc[5] := recLoc."Ship-To PostCode";
                        recState.RESET;
                        recState.SETRANGE(Code, recLoc."Ship-To StateCode");
                        IF recState.FINDFIRST THEN
                            arrShipToLoc[6] := recState.Description;
                    END ELSE BEGIN
                        arrShipToLoc[1] := recLoc.Name;
                        arrShipToLoc[2] := recLoc.Address;
                        arrShipToLoc[3] := recLoc."Address 2";
                        arrShipToLoc[4] := recLoc.City;
                        arrShipToLoc[5] := recLoc."Post Code";
                        recState.RESET;
                        recState.SETRANGE(Code, recLoc."State Code");
                        IF recState.FINDFIRST THEN
                            arrShipToLoc[6] := recState.Description;
                    END;
                END;

                //ACXCP_16052022 -
                //Payment Terms Description
                recPaymnetTerms.SETRANGE(Code, "Purchase Header"."Payment Terms Code");
                IF recPaymnetTerms.FIND('-') THEN
                    PaymentTermDesc := recPaymnetTerms.Description;

                //Vendor Details
                /*
                CLEAR(arrVendor);
                recVendor.SETRANGE("No.","Purchase Header"."Buy-from Vendor No.");
                  IF recVendor.FIND('-') THEN BEGIN
                    arrVendor[1] := recVendor."P.A.N. No.";
                    recState.RESET();
                    recState.SETRANGE(Code,recVendor."State Code");
                     IF recState.FIND('-') THEN
                        arrVendor[2] := recState.Description;
                  END;
                */
                //acxcp_300622 + State detail as per order address code
                CLEAR(arrVendor);
                recVendor.SETRANGE("No.", "Purchase Header"."Buy-from Vendor No.");
                IF recVendor.FIND('-') THEN BEGIN
                    arrVendor[1] := recVendor."P.A.N. No.";
                    IF "Purchase Header"."Order Address Code" = '' THEN BEGIN
                        recState.RESET();
                        recState.SETRANGE(Code, recVendor."State Code");
                        IF recState.FIND('-') THEN
                            arrVendor[2] := recState.Description;
                    END ELSE BEGIN
                        recOrderAddress.SETRANGE(Code, "Purchase Header"."Order Address Code");
                        IF recOrderAddress.FINDFIRST THEN BEGIN
                            recState.RESET;
                            recState.SETRANGE(Code, recOrderAddress.State);
                            IF recState.FINDFIRST THEN
                                arrVendor[2] := recState.Description;
                        END;
                    END;
                END;
                //acxcp_300622 -
                //Header Commemt
                Comment_Header := '';
                recPurchComment.SETRANGE("No.", "Purchase Header"."No.");
                recPurchComment.SETRANGE("Document Line No.", 0);
                IF recPurchComment.FINDSET THEN
                    REPEAT
                        Comment_Header += recPurchComment.Comment;
                    UNTIL recPurchComment.NEXT = 0;


                //Revision No. and Revision Date
                recPurchHeaderArchive.SETRANGE("No.", "Purchase Header"."No.");
                recPurchHeaderArchive.SETFILTER("Document Type", 'Order');
                // IF recPurchHeaderArchive.FIND ('-') THEN BEGIN //Commented due to shown first line
                IF recPurchHeaderArchive.FINDLAST THEN BEGIN //acxcp_01112021 added for show last line of the archieve detail
                    RevisionNo := recPurchHeaderArchive."Version No.";
                    RevisionDt := recPurchHeaderArchive."Date Archived";
                END;
                //ACX-RK 180621 Begin
                // NosText := COPYSTR("Purchase Header"."No.",4,2);
                //  IF NosText = 'FG' THEN
                //     Caption := 'Qty in KG/Ltr';
                IF "Purchase Header"."Vendor Posting Group" = 'FG SUPP' THEN
                    Caption := 'Qty in KG/Ltr'
                ELSE
                    Caption := '-';
                IF ("Purchase Header"."Vendor Posting Group" = 'RM SUPP') OR ("Purchase Header"."Vendor Posting Group" = 'RM_PM SUPP') THEN BEGIN
                    MRPpacktext := '-';
                    MRPCtntext := '-';
                END
                ELSE BEGIN
                    MRPpacktext := 'MRP/Pack';
                    MRPCtntext := 'MRP/Carton';
                END;

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

    trigger OnPreReport()
    begin
        recCompInfo.GET();
        recCompInfo.CALCFIELDS(Picture);
        Srno := 0;
    end;

    local procedure GstPer(T39: Record 39): Decimal
    var
        igst: Decimal;
        igstTotal: Decimal;
        sgst: Decimal;
        GSTper3: Decimal;
        cgst: Decimal;
        GSTper1: Decimal;
        GSTper2: Decimal;
        cgstTOTAL: Decimal;
        ReccPurchaseLine: Record "Purchase Line";
        TotalAmt: Decimal;
        GSTSetup: Record "GST Setup";
        ComponentName: Text;
        TaxTransactionValue: Record "Tax Transaction Value";
        sgstTOTAL: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
    begin
        Clear(igst);
        Clear(sgst);
        Clear(cgst);
        Clear(TotalAmt);
        Clear(TDSAmt);

        GSTSetup.Get();

        if T39.Type <> T39.Type::" " then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", T39.RecordId);
            // TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                ComponentName := 'SGST';
                                GSTper3 := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                ComponentName := 'CGST';
                                GSTper2 := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                ComponentName := 'IGST';
                                GSTper1 := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;


        exit(GSTper1 + GSTper2 + GSTper3);
    end;

    var
        GSTN: Code[250];
        recCompInfo: Record 79;
        recLocation: Record 14;
        recState: Record State;
        arrLocatoin: array[11] of Text;
        recPaymnetTerms: Record 3;
        PaymentTermDesc: Text;
        recVendor: Record 23;
        arrVendor: array[5] of Text;
        Srno: Integer;
        IGST_Total: Decimal;
        CGST_Total: Decimal;
        SGST_Total: Decimal;
        CGSTper: Decimal;
        IGSTper: Decimal;
        SGSTper: Decimal;
        recGSTLedgerBuffer: Record "Detailed GST Entry Buffer";
        recPurchComment: Record 43;
        Comment_Header: Text;
        recItem: Record 27;
        LooseperPack: Decimal;
        repCheck: Report "Posted Voucher";
        NoToWord: array[1] of Text;
        totAmount: Decimal;
        recPurchLine: Record 39;
        recPurchHeaderArchive: Record 5109;
        RevisionNo: Integer;
        RevisionDt: Date;
        totQty: Decimal;
        NosText: Text;
        Caption: Text;
        PurchUOMQty: Decimal;
        recIUOM: Record 5404;
        LineQty: Decimal;
        MRPpacktext: Text;
        MRPCtntext: Text;
        decUnitperparcel: Decimal;
        decMRP_Pack: Decimal;
        arrShipToLoc: array[20] of Text;
        recLoc: Record 14;
        recOrderAddress: Record 224;
        CU50200: Codeunit 50200;
        OneLbl: Label 'ONE';
        TwoLbl: Label 'TWO';
        ThreeLbl: Label 'THREE';
        FourLbl: Label 'FOUR';
        FiveLbl: Label 'FIVE';
        SixLbl: Label 'SIX';
        SevenLbl: Label 'SEVEN';
        EightLbl: Label 'EIGHT';
        NineLbl: Label 'NINE';
        TenLbl: Label 'TEN';
        ElevenLbl: Label 'ELEVEN';
        TwelveLbl: Label 'TWELVE';
        ThirteenLbl: Label 'THIRTEEN';
        FourteenLbl: Label 'FOURTEEN';
        FifteenLbl: Label 'FIFTEEN';
        SixteenLbl: Label 'SIXTEEN';
        SeventeenLbl: Label 'SEVENTEEN';
        EighteenLbl: Label 'EIGHTEEN';
        NinteenLbl: Label 'NINETEEN';
        TwentyLbl: Label 'TWENTY';
        ThirtyLbl: Label 'THIRTY';
        FortyLbl: Label 'FORTY';
        FiftyLbl: Label 'FIFTY';
        SixtyLbl: Label 'SIXTY';
        SeventyLbl: Label 'SEVENTY';
        EightyLbl: Label 'EIGHTY';
        NinetyLbl: Label 'NINETY';
        ThousandLbl: Label 'THOUSAND';
        LakhLbl: Label 'LAKH';
        CroreLbl: Label 'CRORE';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        PLRec: Record "Purchase Line";

    procedure FormatNoText(var NoText: array[2] of Text[800]; No: Decimal; CurrencyCode: Code[10])
    var
        CurrRec: Record Currency;
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        TensDec: Integer;
        OnesDec: Integer;
        ZeroLbl: Label 'ZERO';
        HundreadLbl: Label 'HUNDRED';
        AndLbl: Label 'AND';
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroLbl)
        else
            for Exponent := 4 DOWNTO 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No DIV (Power(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No DIV Power(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                end;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundreadLbl);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

        if CurrencyCode <> '' then begin
            CurrRec.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ');
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, AndLbl);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroLbl);
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + ' ONLY')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(
        var NoText: array[2] of Text[800];
        var NoTextIndex: Integer;
        var PrintExponent: Boolean;
        AddText: Text[30])
    begin
        PrintExponent := true;
        NoText[NoTextIndex] := CopyStr(DelChr(NoText[NoTextIndex] + ' ' + AddText, '<'), 1, 200);
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := OneLbl;
        OnesText[2] := TwoLbl;
        OnesText[3] := ThreeLbl;
        OnesText[4] := FourLbl;
        OnesText[5] := FiveLbl;
        OnesText[6] := SixLbl;
        OnesText[7] := SevenLbl;
        OnesText[8] := EightLbl;
        OnesText[9] := NineLbl;
        OnesText[10] := TenLbl;
        OnesText[11] := ElevenLbl;
        OnesText[12] := TwelveLbl;
        OnesText[13] := ThirteenLbl;
        OnesText[14] := FourteenLbl;
        OnesText[15] := FifteenLbl;
        OnesText[16] := SixteenLbl;
        OnesText[17] := SeventeenLbl;
        OnesText[18] := EighteenLbl;
        OnesText[19] := NinteenLbl;
        TensText[1] := '';
        TensText[2] := TwentyLbl;
        TensText[3] := ThirtyLbl;
        TensText[4] := FortyLbl;
        TensText[5] := FiftyLbl;
        TensText[6] := SixtyLbl;
        TensText[7] := SeventyLbl;
        TensText[8] := EightyLbl;
        TensText[9] := NinetyLbl;
        ExponentText[1] := '';
        ExponentText[2] := ThousandLbl;
        ExponentText[3] := LakhLbl;
        ExponentText[4] := CroreLbl;
    end;
}

