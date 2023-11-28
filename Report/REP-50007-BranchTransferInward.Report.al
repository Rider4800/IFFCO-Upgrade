report 50007 "Branch Transfer Inward"
{
    DefaultLayout = RDLC;
    RDLCLayout = './BranchTransferInward.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.";
            column(CompState; CompState)
            {
            }
            column(Reg_State; txtCompanyInfo[4])
            {
            }
            column(Company_Country; txtCompanyInfo[5])
            {
            }
            column(CompName; recCompanyInfo.Name)
            {
            }
            column(Reg_Address; recCompanyInfo."Registration Address")
            {
            }
            column(Reg_Address2; recCompanyInfo."Registration Address 2")
            {
            }
            column(Reg_City; recCompanyInfo."Registration City")
            {
            }
            column(Reg_Postcode; recCompanyInfo."Registration Post code")
            {
            }
            column(CIN; recCompInfo."GST Registration No.")
            {
            }
            //->16767    "T.I.N. No." Field not found in Location Table in BC
            // column(CompTIN; recCompInfo."T.I.N. No.")
            // {
            // }
            //->16767
            column(Company_Picture; recCompanyInfo.Picture)
            {
            }
            column(Company_Name; recCompanyInfo.Name)
            {
            }
            column(Company_Phone_No; recCompanyInfo."Phone No.")
            {
            }
            column(Company_CIN; recCompanyInfo."GST Registration No.")
            {
            }
            column(Company_PAN; recCompanyInfo."P.A.N. No.")
            {
            }
            column(Company_GST_No; recCompanyInfo."GST Registration No.")
            {
            }
            column(Company_Email; recCompanyInfo."E-Mail")
            {
            }
            column(Company_Bank_Name; recCompanyInfo."Bank Name")
            {
            }
            column(CompAdd; recCompanyInfo.Address)
            {
            }
            column(CompAdd2; recCompanyInfo."Address 2")
            {
            }
            column(CompCity; recCompanyInfo.City)
            {
            }
            column(CompPC; recCompanyInfo."Post Code")
            {
            }
            column(Website; recCompanyInfo."Home Page")
            {
            }
            column(CompEmail; recCompanyInfo."E-Mail")
            {
            }
            column(FAX; recCompanyInfo."Fax No.")
            {
            }
            column(InvoiceNo; "Transfer Shipment Header"."No.")
            {
            }
            column(CompNamr; recCompInfo.Name)
            {
            }
            column(CompPAN; recCompInfo."P.A.N. No.")
            {
            }
            column(BuyerVATTIN; BuyerTIN)
            {
            }
            column(BuyerCST; BuyerCST)
            {
            }
            column(TFName; "Transfer Shipment Header"."Transfer-from Name")
            {
            }
            column(TFName2; "Transfer Shipment Header"."Transfer-from Name 2")
            {
            }
            column(TFAdd; "Transfer Shipment Header"."Transfer-from Address")
            {
            }
            column(TFAdd2; "Transfer Shipment Header"."Transfer-from Address 2")
            {
            }
            column(TFPosrtCode; "Transfer Shipment Header"."Transfer-from Post Code")
            {
            }
            column(TFCity; "Transfer Shipment Header"."Transfer-from City")
            {
            }
            column(TFState; TFState)
            {
            }
            column(TFStateCode; TFStateCode)
            {
            }
            column(TFGSTIN; TFGSTIN)
            {
            }
            column(InvoiceDt; "Transfer Shipment Header"."Posting Date")
            {
            }
            column(ModeForPay; '')
            {
            }
            column(SuppliyRef; '')
            {
            }
            column(OtherRef; "Transfer Shipment Header"."External Document No.")
            {
            }
            column(Dated; '')
            {
            }
            column(DispDoc; '')
            {
            }
            column(BuyerOrNo; '')
            {
            }
            column(dispThrought; "Transfer Shipment Header"."Transporter Name")
            {
            }
            column(Destination; "Transfer Shipment Header"."Transfer-to Name")
            {
            }
            column(IssueTm; "Transfer Shipment Header"."Time of Removal")
            {
            }
            column(VehicelNo; "Transfer Shipment Header"."Vehicle No.")
            {
            }
            column(DurationofProcess; '')
            {
            }
            column(NatureofProcessing; '')
            {
            }
            column(PartyName; "Transfer Shipment Header"."Transfer-to Name")
            {
            }
            column(PartyAdd; "Transfer Shipment Header"."Transfer-to Address")
            {
            }
            column(PartyAdd2; "Transfer Shipment Header"."Transfer-to Address 2")
            {
            }
            column(PartyPC; "Transfer Shipment Header"."Transfer-to Post Code")
            {
            }
            column(PartyCity; "Transfer Shipment Header"."Transfer-to City")
            {
            }
            column(PartyStateName; PartyStateName)
            {
            }
            column(PartyGSTIN; PartyGSTIN)
            {
            }
            column(PartyStateCode; PartyStateCode)
            {
            }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(SrNo; SrNo)
                {
                }
                column(Item; "Transfer Shipment Line".Description)
                {
                }
                column(Qty; "Transfer Shipment Line".Quantity)
                {
                }
                column(ItemDesc; "Transfer Shipment Line".Description)
                {
                }
                column(UOM; "Transfer Shipment Line"."Unit of Measure Code")
                {
                }
                column(Rate; "Transfer Shipment Line"."Unit Price")
                {
                }
                column(Amount; "Transfer Shipment Line".Amount)
                {
                }
                column(TotalQty; TotalQty)
                {
                }
                column(TotalAmount; TotAmt)
                {
                }
                column(HSN; "Transfer Shipment Line"."HSN/SAC Code")
                {
                }
                column(Amountinword; NotoWord[1])
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Item No." = FIELD("Item No."),
                                   "Location Code" = FIELD("Transfer-from Code"),
                                   "Document Line No." = FIELD("Line No.");
                    DataItemTableView = WHERE("Entry Type" = FILTER(Transfer));
                    column(Ile_ItemNo; "Item Ledger Entry"."Item No.")
                    {
                    }
                    column(Ile_DocNo; "Item Ledger Entry"."Document No.")
                    {
                    }
                    column(Ile_Qty; ABS("Item Ledger Entry".Quantity))
                    {
                    }
                    column(Ile_LotNO; "Item Ledger Entry"."Lot No.")
                    {
                    }
                    dataitem("Value Entry"; "Value Entry")
                    {
                        DataItemLink = "Item Ledger Entry Type" = FIELD("Entry Type"),
                                       "Document No." = FIELD("Document No."),
                                       "Item No." = FIELD("Item No."),
                                       "Location Code" = FIELD("Location Code"),
                                       "Item Ledger Entry No." = FIELD("Entry No."),
                                       "Item Ledger Entry Quantity" = FIELD(Quantity);
                        DataItemTableView = WHERE("Item Ledger Entry Type" = FILTER(Transfer));
                        column(CostPerUnit; ABS("Value Entry"."Cost per Unit"))
                        {
                        }
                        column(CostAmtActual; ABS("Value Entry"."Cost Amount (Actual)"))
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //Serial Number for No. of lines
                        SrNo += 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin


                    //Total Amount and Quantity for Footer
                    recTransShipLine.SETRANGE("Document No.", "Transfer Shipment Line"."Document No.");
                    IF recTransShipLine.FIND('-') THEN BEGIN
                        REPEAT
                            TotalQty += recTransShipLine.Quantity;
                            TotAmt += recTransShipLine.Amount;
                        UNTIL recTransShipLine.NEXT = 0;
                    END;

                    //Amount in Word
                    repCheck.InitTextVariable();
                    repCheck.FormatNoText(NotoWord, TotAmt, '');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                recLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-from Code");
                IF recLoc.FINDFIRST THEN BEGIN
                    recState.SETRANGE(Code, recLoc."State Code");
                    TFGSTIN := recLoc."GST Registration No.";
                    //->16767    "T.I.N. No." & "C.S.T No." Field not found in Location Table in BC
                    // BuyerTIN := recLoc."T.I.N. No.";
                    // BuyerCST := recLoc."C.S.T No.";
                    //<-16767
                    IF recState.FIND('-') THEN BEGIN
                        TFState := recState.Description;
                        TFStateCode := recState."State Code (GST Reg. No.)";
                    END;
                END;

                //Party gstin
                recLoc.RESET();
                recLoc.SETRANGE(Code, "Transfer Shipment Header"."Transfer-to Code");
                IF recLoc.FINDFIRST THEN BEGIN
                    PartyGSTIN := recLoc."GST Registration No.";
                    recState.RESET();
                    recState.SETRANGE(Code, recLoc."State Code");
                    IF recState.FIND('-') THEN BEGIN
                        PartyStateCode := recState."State Code (GST Reg. No.)";
                        PartyStateName := recState.Description;
                    END;
                END;

                //ACXCP_23052022 +
                recState.RESET();
                recState.SETRANGE(Code, recCompanyInfo."Registration State");
                IF recState.FIND('-') THEN
                    txtCompanyInfo[4] := recState.Description;

                recCountry.RESET();
                recCountry.SETRANGE(Code, recCompanyInfo."Country/Region Code");
                IF recCountry.FIND('-') THEN
                    txtCompanyInfo[5] := recCountry.Name;

                //ACXCP_23052022 -
            end;

            trigger OnPreDataItem()
            begin
                //acxcp_23052022 + //added footer information
                recCompanyInfo.GET;
                recCompanyInfo.CALCFIELDS(Picture);
                recState.RESET();
                recState.SETRANGE(Code, recCompanyInfo."State Code");
                IF recState.FINDFIRST THEN
                    CompState := recState.Description;
                //acxcp_23052022 - //added footer information
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
        SrNo := 0;
    end;

    var
        recState: Record State;
        recLoc: Record 14;
        TFState: Text;
        TFStateCode: Code[10];
        PartyGSTIN: Code[15];
        PartyStateName: Text;
        PartyStateCode: Code[3];
        TFGSTIN: Code[15];
        recCompInfo: Record 79;
        SrNo: Integer;
        recTransShipLine: Record 5745;
        TotalQty: Decimal;
        TotAmt: Decimal;
        repCheck: Report Check;
        NotoWord: array[1] of Text;
        BuyerTIN: Code[15];
        BuyerCST: Code[15];
        recCompanyInfo: Record 79;
        txtCompanyInfo: array[10] of Text;
        recCountry: Record 9;
        CompState: Text;
}

