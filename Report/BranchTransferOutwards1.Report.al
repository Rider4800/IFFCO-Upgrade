report 50106 "Branch Transfer Outwards1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './BranchTransferOutwards1.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(DataItem1000000000; Table5744)
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
            column(CIN; recCompInfo."Company Registration  No.")
            {
            }
            column(CompStateName; CompState)
            {
            }
            column(CompStateCode; CompStateCode)
            {
            }
            column(RegdAdd1; recCompInfo."Registration Address")
            {
            }
            column(RegdAdd2; recCompInfo."Registration Address 2")
            {
            }
            column(RegdCity; recCompInfo."Registration City")
            {
            }
            column(RegdPC; recCompInfo."Registration Post code")
            {
            }
            column(CompGSTIN; recCompInfo."GST Registration No.")
            {
            }
            column(AcHolder; recCompInfo."Bank Name")
            {
            }
            column(AccNo; recCompInfo."Bank Account No.")
            {
            }
            column(Bank; recCompInfo."Bank Branch No.")
            {
            }
            column(CompPAN; recCompInfo."P.A.N. No.")
            {
            }
            column(WarehouseAdd; "Transfer Shipment Header"."Transfer-from Address")
            {
            }
            column(WarehouseAdd2; "Transfer Shipment Header"."Transfer-from Address 2")
            {
            }
            column(WarehousePC; "Transfer Shipment Header"."Transfer-from Post Code")
            {
            }
            column(WarehouseCity; "Transfer Shipment Header"."Transfer-from City")
            {
            }
            column(WarehouseName; "Transfer Shipment Header"."Transfer-from Name")
            {
            }
            column(WarehouseName2; "Transfer Shipment Header"."Transfer-from Name 2")
            {
            }
            column(WareHouseMob; WareHouseMob)
            {
            }
            column(Invoiceno; "Transfer Shipment Header"."No.")
            {
            }
            column(PosDate; "Transfer Shipment Header"."Posting Date")
            {
            }
            column(PONo; '')
            {
            }
            column(PODate; '')
            {
            }
            column(PaymentTerms; '')
            {
            }
            column(PaymentDueDate; '')
            {
            }
            column(DispatchThrough; "Transfer Shipment Header"."Transporter Name")
            {
            }
            column(Destination; "Transfer Shipment Header"."Transfer-to Name")
            {
            }
            column(LRRRNo; "Transfer Shipment Header"."LR/RR No.")
            {
            }
            column(VehicleNo; "Transfer Shipment Header"."Vehicle No.")
            {
            }
            column(buyerName; "Transfer Shipment Header"."Transfer-to Name")
            {
            }
            column(buyerName2; "Transfer Shipment Header"."Transfer-to Name 2")
            {
            }
            column(buyerAdd; "Transfer Shipment Header"."Transfer-to Address")
            {
            }
            column(buyerAdd2; "Transfer Shipment Header"."Transfer-to Address 2")
            {
            }
            column(buyerPC; "Transfer Shipment Header"."Transfer-to Post Code")
            {
            }
            column(buyerCity; "Transfer Shipment Header"."Transfer-to City")
            {
            }
            column(BuyerGSTIN; arrBuyer[1])
            {
            }
            column(BuyerStateName; arrBuyer[2])
            {
            }
            column(BuyerStateCode; arrBuyer[3])
            {
            }
            column(IGSTamt; IGSTamt)
            {
            }
            column(IGSTper; IGSTper)
            {
            }
            column(CGSTamt; CGSTamt)
            {
            }
            column(CGSTper; CGSTper)
            {
            }
            column(SGSTamt; SGSTamt)
            {
            }
            column(SGSTper; SGSTper)
            {
            }
            dataitem(DataItem1000000038; Table5745)
            {
                DataItemLink = Document No.=FIELD(No.);
                column(ItemNo; "Transfer Shipment Line"."Item No.")
                {
                }
                column(Qty; "Transfer Shipment Line".Quantity)
                {
                }
                column(ItemName; "Transfer Shipment Line".Description)
                {
                }
                column(ItemNam2; "Transfer Shipment Line"."Description 2")
                {
                }
                column(GSTper; "Transfer Shipment Line"."GST %")
                {
                }
                column(LineGST; "Transfer Shipment Line"."Total GST Amount")
                {
                }
                column(HSN; "Transfer Shipment Line"."HSN/SAC Code")
                {
                }
                column(LoosePack; LoosePack)
                {
                }
                column(perCartonWt; perCartonWt)
                {
                }
                column(BatchNo; BatchNo)
                {
                }
                column(ManufecturingDt; ManufecturingDt)
                {
                }
                column(Expiration; Expiration)
                {
                }
                column(MRP; BatchMRP)
                {
                }
                column(RateperUnit; "Transfer Shipment Line"."Unit Price")
                {
                }
                column(Amount; "Transfer Shipment Line".Amount)
                {
                }
                column(SrNo; SrNo)
                {
                }
                column(AmountinWord; NotoText[1])
                {
                }
                column(TotAmount; TotAmount)
                {
                }
                column(TotalQty; totQty)
                {
                }
                column(totItemAmount; totItemAmount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SrNo += 1;

                    //Item Loose Pack
                    recItem.SETRANGE("No.", "Transfer Shipment Line"."Item No.");
                    IF recItem.FIND('-') THEN BEGIN
                        LoosePack := recItem."Units per Parcel" * "Transfer Shipment Line".Quantity;
                        ;
                        perCartonWt := recItem."Gross Weight" * "Transfer Shipment Line".Quantity;
                    END;

                    //ManufecturingDt Expirtion Date Batch No
                    recItemLedEntry.SETRANGE("Document No.", "Transfer Shipment Line"."Document No.");
                    recItemLedEntry.SETRANGE("Item No.", "Transfer Shipment Line"."Item No.");
                    IF recItemLedEntry.FIND('-') THEN BEGIN
                        BatchNo := recItemLedEntry."Lot No.";
                        //    ManufecturingDt := recItemLedEntry."Manufecturing Date";
                        Expiration := recItemLedEntry."Expiration Date";
                        //    BatchMRP := recItemLedEntry."Batch MRP";
                    END;

                    //Total Amount
                    recTransShipLine.RESET();
                    recTransShipLine.SETRANGE("Document No.", "Transfer Shipment Line"."Document No.");
                    IF recTransShipLine.FIND('-') THEN BEGIN
                        REPEAT
                            TotAmount += recTransShipLine."Total GST Amount" + recTransShipLine.Amount;
                            totQty += recTransShipLine.Quantity;
                            totItemAmount += recTransShipLine.Amount;
                        UNTIL recTransShipLine.NEXT = 0;
                    END;

                    //Amount in word
                    repCheck.InitTextVariable();
                    repCheck.FormatNoText(NotoText, TotAmount, '');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //Warehouse Mob No.
                recLoc.RESET();
                recLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-from Code");
                IF recLoc.FINDFIRST THEN
                    WareHouseMob := recLoc."Phone No.";

                //Buyer State Name State Code and GSTIN
                CLEAR(arrBuyer);
                recLoc.RESET();
                recLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-to Code");
                IF recLoc.FIND('-') THEN BEGIN
                    arrBuyer[1] := recLoc."GST Registration No.";
                    recState.RESET();
                    recState.SETRANGE(Code, recLoc."State Code");
                    IF recState.FIND('-') THEN BEGIN
                        arrBuyer[1] := recState.Description;
                        arrBuyer[2] := recState."State Code (GST Reg. No.)";
                    END;
                END;

                //GST Calculation
                IGSTamt := 0;
                IGSTper := 0;
                recDetGSTLedAntry.RESET();
                recDetGSTLedAntry.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                recDetGSTLedAntry.SETFILTER("GST Component Code", 'IGST');
                IF recDetGSTLedAntry.FIND('-') THEN BEGIN
                    IGSTamt := recDetGSTLedAntry."GST Amount";
                    IGSTper := recDetGSTLedAntry."GST %";
                END;

                CGSTamt := 0;
                CGSTper := 0;
                recDetGSTLedAntry.RESET();
                recDetGSTLedAntry.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                recDetGSTLedAntry.SETFILTER("GST Component Code", 'CGST');
                IF recDetGSTLedAntry.FIND('-') THEN BEGIN
                    CGSTamt := recDetGSTLedAntry."GST Amount";
                    CGSTper := recDetGSTLedAntry."GST %";
                END;

                SGSTamt := 0;
                SGSTper := 0;
                recDetGSTLedAntry.RESET();
                recDetGSTLedAntry.SETRANGE("Document No.", "Transfer Shipment Header"."No.");
                recDetGSTLedAntry.SETFILTER("GST Component Code", 'SGST');
                IF recDetGSTLedAntry.FIND('-') THEN BEGIN
                    SGSTamt := recDetGSTLedAntry."GST Amount";
                    SGSTper := recDetGSTLedAntry."GST %";
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
        recState.RESET();
        recState.SETRANGE(Code, recCompInfo.State);
        IF recState.FIND('-') THEN BEGIN
            CompState := recState.Description;
            CompStateCode := recState."State Code (GST Reg. No.)";
        END;
        SrNo := 0;
    end;

    var
        recCompInfo: Record "79";
        recState: Record "13762";
        CompState: Text;
        CompStateCode: Code[2];
        recLoc: Record "14";
        WareHouseMob: Code[13];
        arrBuyer: array[5] of Text;
        SrNo: Integer;
        recItem: Record "27";
        LoosePack: Decimal;
        perCartonWt: Decimal;
        recItemLedEntry: Record "32";
        BatchNo: Code[15];
        ManufecturingDt: Date;
        Expiration: Date;
        recTransShipLine: Record "5745";
        TotAmount: Decimal;
        NotoText: array[1] of Text;
        repCheck: Report "1401";
        totQty: Decimal;
        recDetGSTLedAntry: Record "16419";
        IGSTamt: Decimal;
        CGSTamt: Decimal;
        SGSTamt: Decimal;
        IGSTper: Decimal;
        CGSTper: Decimal;
        SGSTper: Decimal;
        totItemAmount: Decimal;
        BatchMRP: Decimal;
}

