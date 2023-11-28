report 50003 PO
{
    DefaultLayout = RDLC;
    RDLCLayout = './PO.rdlc';
    PreviewMode = PrintLayout;

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
            column(CIN; recCompInfo."GST Registration No.") //16767 "Company Registration  No." replace "GST Registration No."
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
                column(GSTAmt; CU50200.TotalGSTAmtLine("Purchase Line"))//16767 "Purchase Line"."Total GST Amount"
                {
                }
                column(UOM; "Purchase Line"."Unit of Measure Code")
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
                    SGST_Total := 0;
                    recGSTLedgerBuffer.RESET();
                    recGSTLedgerBuffer.SETRANGE("Document No.", "Purchase Header"."No.");
                    recGSTLedgerBuffer.SETRANGE("GST Component Code", 'SGST');
                    IF recGSTLedgerBuffer.FIND('-') THEN BEGIN
                        REPEAT
                            SGST_Total += ABS(recGSTLedgerBuffer."GST Amount");
                        UNTIL recGSTLedgerBuffer.NEXT = 0;
                    END;

                    CGST_Total := 0;
                    recGSTLedgerBuffer.RESET();
                    recGSTLedgerBuffer.SETRANGE("Document No.", "Purchase Header"."No.");
                    recGSTLedgerBuffer.SETRANGE("GST Component Code", 'CGST');
                    IF recGSTLedgerBuffer.FIND('-') THEN BEGIN
                        REPEAT
                            CGST_Total += ABS(recGSTLedgerBuffer."GST Amount");
                        UNTIL recGSTLedgerBuffer.NEXT = 0;
                    END;

                    IGST_Total := 0;
                    recGSTLedgerBuffer.RESET();
                    recGSTLedgerBuffer.SETRANGE("Document No.", "Purchase Header"."No.");
                    recGSTLedgerBuffer.SETRANGE("GST Component Code", 'IGST');
                    IF recGSTLedgerBuffer.FIND('-') THEN BEGIN
                        REPEAT
                            IGST_Total += ABS(recGSTLedgerBuffer."GST Amount");
                        UNTIL recGSTLedgerBuffer.NEXT = 0;
                    END;
                    //Loose per Pack
                    recItem.SETRANGE("No.", "Purchase Line"."No.");
                    IF recItem.FINDFIRST THEN
                        LooseperPack := recItem."Units per Parcel" * "Purchase Line".Quantity;
                    decUnitperparcel := recItem."Units per Parcel"; //acxcp
                    //Total Amount
                    recPurchLine.SETRANGE("Document No.", "Purchase Line"."Document No.");
                    IF recPurchLine.FIND('-') THEN BEGIN
                        REPEAT
                            totAmount += CU50200.AmttoVendorLine(recPurchLine); //16767  recPurchLine."Amount To Vendor"
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
                    repCheck.InitTextVariable();
                    repCheck.FormatNoText(NoToWord, totAmount, '');

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

                //Payment Terms Description
                recPaymnetTerms.SETRANGE(Code, "Purchase Header"."Payment Terms Code");
                IF recPaymnetTerms.FIND('-') THEN
                    PaymentTermDesc := recPaymnetTerms.Description;

                //Vendor Details
                CLEAR(arrVendor);
                recVendor.SETRANGE("No.", "Purchase Header"."Buy-from Vendor No.");
                IF recVendor.FIND('-') THEN BEGIN
                    arrVendor[1] := recVendor."P.A.N. No.";
                    recState.RESET();
                    recState.SETRANGE(Code, recVendor."State Code");
                    IF recState.FIND('-') THEN
                        arrVendor[2] := recState.Description;
                END;

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
        repCheck: Report Check;
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
        CU50200: Codeunit 50200;
}

