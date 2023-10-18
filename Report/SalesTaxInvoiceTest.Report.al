report 50056 "Sales Tax Invoice-Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SalesTaxInvoiceTest.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(DataItem1170000000; Table2000000026)
        {
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
            dataitem(DataItem1000000000; Table112)
            {
                RequestFilterFields = "No.";
                column(Loc_Address; txtLocation[1])
                {
                }
                column(Loc_Address2; txtLocation[2])
                {
                }
                column(Loc_City; txtLocation[3])
                {
                }
                column(Loc_Postcode; txtLocation[4])
                {
                }
                column(Loc_State; txtLocation[5])
                {
                }
                column(Loc_Country; txtLocation[6])
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
                column(vy; txtCompanyInfo[4])
                {
                }
                column(Company_Country; txtCompanyInfo[5])
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
                column(Reg_Email; recCompanyInfo."Registration Email")
                {
                }
                column(FAX; recCompanyInfo."Fax No.")
                {
                }
                column(Website; recCompanyInfo."Home Page")
                {
                }
                column(CompState; CompState)
                {
                }
                column(Reg_Phone_No; recCompanyInfo."Registration Phone No.")
                {
                }
                column(Company_Picture; recCompanyInfo.Picture)
                {
                }
                column(Company_Name; recCompanyInfo.Name)
                {
                }
                column(Company_Phone_No; recCompanyInfo."Phone No.")
                {
                }
                column(Company_CIN; recCompanyInfo."Company Registration  No.")
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
                column(Company_Bank_Acc_No; "Sales Invoice Header"."Bill-to Customer No.")
                {
                }
                column(QR_Code; recEwayEinvoice."QR Code")
                {
                }
                column(E_Invoice_No; txtEwayEinvoice[1])
                {
                }
                column(Acknowledge_No; txtEwayEinvoice[2])
                {
                }
                column(Acknowledge_Date; AckDate)
                {
                }
                column(Location_GST_No; "Sales Invoice Header"."Location GST Reg. No.")
                {
                }
                column(Document_No; "Sales Invoice Header"."No.")
                {
                }
                column(Posting_Date; "Sales Invoice Header"."Posting Date")
                {
                }
                column(Due_Date; "Sales Invoice Header"."Due Date")
                {
                }
                column(Vehicle_No; "Sales Invoice Header"."Vehicle No.")
                {
                }
                column(LR_No; "Sales Invoice Header"."LR/RR No.")
                {
                }
                column(LR_Date; "Sales Invoice Header"."LR/RR Date")
                {
                }
                column(Transporter_Name; "Sales Invoice Header"."Transporter Name")
                {
                }
                column(E_Way_No; "Sales Invoice Header"."E-Way Bill No.")
                {
                }
                column(E_Way_Date; "Sales Invoice Header"."E-Way Bill Date")
                {
                }
                column(External_Doc_No; "Sales Invoice Header"."External Document No.")
                {
                }
                column(Ship_Name; txtConsignee[1])
                {
                }
                column(Ship_Address; txtConsignee[2])
                {
                }
                column(Ship_Address2; txtConsignee[3])
                {
                }
                column(Ship_City_Delivey_At; txtConsignee[4])
                {
                }
                column(Ship_Postcode; txtConsignee[5])
                {
                }
                column(Ship_Phone_No; txtConsignee[6])
                {
                }
                column(Ship_GST_State; txtConsignee[7])
                {
                }
                column(Ship_GST_No; txtConsignee[8])
                {
                }
                column(Ship_State_Name; txtConsignee[9])
                {
                }
                column(Ship_Country; txtConsignee[10])
                {
                }
                column(Ship_GST_State_Code; txtConsignee[11])
                {
                }
                column(Amount_In_Words_Total; Numbertxt[1])
                {
                }
                column(Bill_to_Name; "Sales Invoice Header"."Bill-to Name")
                {
                }
                column(Bill_to_Address; "Sales Invoice Header"."Bill-to Address")
                {
                }
                column(Bill_to_Address2; "Sales Invoice Header"."Bill-to Address 2")
                {
                }
                column(Bill_to_City; "Sales Invoice Header"."Bill-to City")
                {
                }
                column(Bill_to_Postcode; "Sales Invoice Header"."Bill-to Post Code")
                {
                }
                column(Bill_to_Country; "Sales Invoice Header"."Bill-to Country/Region Code")
                {
                }
                column(Bill_to_Phone_No; txtBillInfo[1])
                {
                }
                column(Bill_State_Name; txtBillInfo[2])
                {
                }
                column(Bill_Country; txtBillInfo[3])
                {
                }
                column(Bill_GST_State_Code; txtBillInfo[4])
                {
                }
                column(Cust_GST_No; "Sales Invoice Header"."Customer GST Reg. No.")
                {
                }
                column(Round_Off; decRoundOff)
                {
                }
                column(TotalAmount; decTotalAmount)
                {
                }
                column(AmounttoCust; decAmounttoCust)
                {
                }
                column(Total_Net_Wt; (decTotalNetWt - dcRoundoffQty))
                {
                }
                column(Curr_Code; txtCurrCode)
                {
                }
                column(InvoiceType; "Sales Invoice Header"."Invoice Type")
                {
                }
                column(Campaign_No; "Sales Invoice Header"."Campaign No.")
                {
                }
                dataitem(DataItem1000000031; Table113)
                {
                    DataItemLink = Document No.=FIELD(No.);
                    DataItemTableView = WHERE (Quantity = FILTER (<> 0));
                    column(LineNo; "Sales Invoice Line"."Line No.")
                    {
                    }
                    column(LineDoc; "Sales Invoice Line"."Document No.")
                    {
                    }
                    column(Sno; Sno)
                    {
                    }
                    column(Item_No; "Sales Invoice Line"."No.")
                    {
                    }
                    column(Description; "Sales Invoice Line".Description + "Sales Invoice Line"."Description 2")
                    {
                    }
                    column(Lot_No; txtLotNo)
                    {
                    }
                    column(HSN; "Sales Invoice Line"."HSN/SAC Code")
                    {
                    }
                    column(Mfg; dtMfg)
                    {
                    }
                    column(Expiry; dtExpiry)
                    {
                    }
                    column(Quantity; "Sales Invoice Line".Quantity)
                    {
                    }
                    column(Qty_KGS_LTR; "Sales Invoice Line".Quantity * decQtyper)
                    {
                    }
                    column(Rate; "Sales Invoice Line"."Unit Price")
                    {
                    }
                    column(MRP; "Sales Invoice Line"."MRP Price")
                    {
                    }
                    column(Amount; "Sales Invoice Line"."Line Amount")
                    {
                    }
                    column(Disc_per; ROUND("Sales Invoice Line"."Line Discount %", 0.01))
                    {
                    }
                    column(GST_Base_Amt; "Sales Invoice Line"."GST Base Amount")
                    {
                    }
                    column(CGST; ABS(decCGST))
                    {
                    }
                    column(SGST; ABS(decSGST))
                    {
                    }
                    column(IGST; ABS(decIGST))
                    {
                    }
                    column(CGST_Per; decCGSTper)
                    {
                    }
                    column(SGST_Per; decSGSTper)
                    {
                    }
                    column(IGST_Per; decIGSTper)
                    {
                    }
                    column(TotalAmt; "Sales Invoice Line"."Amount To Customer")
                    {
                    }
                    column(GST_per; FORMAT(ROUND(decGSTper, 1)))
                    {
                    }
                    column(GST; FORMAT(ROUND("Sales Invoice Line"."GST %", 1)))
                    {
                    }
                    column(Total_Qty; decTotalQty)
                    {
                    }
                    column(AltQty; decAltQty)
                    {
                    }
                    column(NoOfLoosePack; "Sales Invoice Line"."No. of Loose Pack")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Sno += 1;

                        decAltQty := 0;
                        txtLotNo := '';
                        dtExpiry := 0D;
                        dtMfg := 0D;
                        recVE.RESET();
                        recVE.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                        recVE.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                        IF recVE.FIND('-') THEN BEGIN
                            recILE.RESET();
                            recILE.SETRANGE("Entry No.", recVE."Item Ledger Entry No.");
                            IF recILE.FIND('-') THEN BEGIN
                                recLotInfo.RESET();
                                recLotInfo.SETRANGE("Lot No.", recILE."Lot No.");
                                recLotInfo.SETRANGE("Item No.", recILE."Item No.");//acxcp_29072022
                                IF recLotInfo.FIND('-') THEN BEGIN
                                    dtExpiry := recLotInfo."Expiration Date";
                                    dtMfg := recLotInfo."MFG Date";
                                    txtLotNo := recILE."Lot No.";
                                END;
                            END;
                        END;

                        decQtyper := 0;
                        recItemUOM.RESET();
                        recItemUOM.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                        recItemUOM.SETFILTER(Code, '%1', 'CTN');
                        IF recItemUOM.FIND('-') THEN
                            decQtyper := recItemUOM."Qty. per Unit of Measure";

                        decCGST := 0;
                        decCGSTper := 0;
                        recDGLE.RESET();
                        recDGLE.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                        recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                        //recDGLE.SETRANGE("HSN/SAC Code","Sales Invoice Line"."HSN/SAC Code");
                        recDGLE.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                        recDGLE.SETRANGE("GST Component Code", 'CGST');
                        IF recDGLE.FIND('-') THEN BEGIN
                            decGSTper := 0;
                            decCGSTper := recDGLE."GST %";
                            decCGST := recDGLE."GST Amount";
                            decGSTper := recDGLE."GST %";
                        END;

                        decSGST := 0;
                        decSGSTper := 0;
                        recDGLE.RESET();
                        recDGLE.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                        recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                        //recDGLE.SETRANGE("HSN/SAC Code","Sales Invoice Line"."HSN/SAC Code");
                        recDGLE.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                        recDGLE.SETRANGE("GST Component Code", 'SGST');
                        IF recDGLE.FIND('-') THEN BEGIN
                            decGSTper := 0;
                            decSGSTper := recDGLE."GST %";
                            decSGST := recDGLE."GST Amount";
                            decGSTper := recDGLE."GST %";
                        END;

                        decIGST := 0;
                        decIGSTper := 0;
                        recDGLE.RESET();
                        recDGLE.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                        recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                        //recDGLE.SETRANGE("HSN/SAC Code","Sales Invoice Line"."HSN/SAC Code");
                        recDGLE.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                        recDGLE.SETRANGE("GST Component Code", 'IGST');
                        IF recDGLE.FIND('-') THEN BEGIN
                            decGSTper := 0;
                            decIGSTper := recDGLE."GST %";
                            decIGST := recDGLE."GST Amount";
                            decGSTper := recDGLE."GST %";
                        END;
                        //ACX-RK 0507201
                        recItemUOM.RESET();
                        recItemUOM.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                        recItemUOM.SETFILTER(Code, '<>%1', "Sales Invoice Line"."Unit of Measure Code");
                        IF recItemUOM.FIND('-') THEN BEGIN
                            decTotalQty += recItemUOM."Qty. per Unit of Measure" * "Sales Invoice Line".Quantity;
                            decAltQty := recItemUOM."Qty. per Unit of Measure" * "Sales Invoice Line".Quantity; //acxcp_090821
                        END;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    recState.RESET();
                    recState.SETRANGE(Code, recCompanyInfo."Registration State");
                    IF recState.FIND('-') THEN
                        txtCompanyInfo[4] := recState.Description;

                    recCountry.RESET();
                    recCountry.SETRANGE(Code, recCompanyInfo."Country/Region Code");
                    IF recCountry.FIND('-') THEN
                        txtCompanyInfo[5] := recCountry.Name;

                    CLEAR(txtLocation);
                    recLocation.RESET();
                    recLocation.SETRANGE(Code, "Sales Invoice Header"."Location Code");
                    IF recLocation.FIND('-') THEN BEGIN
                        txtLocation[1] := recLocation.Address;
                        txtLocation[2] := recLocation."Address 2";
                        txtLocation[3] := recLocation.City;
                        txtLocation[4] := recLocation."Post Code";
                        recState.RESET();
                        recState.SETRANGE(Code, recLocation."State Code");
                        IF recState.FIND('-') THEN
                            txtLocation[5] := recState.Description;
                        recCountry.RESET();
                        recCountry.SETRANGE(Code, recLocation."Country/Region Code");
                        IF recCountry.FIND('-') THEN
                            txtLocation[6] := recCountry.Name;
                    END;

                    AckDate := 0D;
                    CLEAR(txtEwayEinvoice);
                    recEwayEinvoice.RESET();
                    recEwayEinvoice.SETRANGE("No.", "Sales Invoice Header"."No.");
                    IF recEwayEinvoice.FIND('-') THEN BEGIN
                        recEwayEinvoice.CALCFIELDS("QR Code");
                        txtEwayEinvoice[1] := recEwayEinvoice."E-Invoice IRN No";
                        txtEwayEinvoice[2] := recEwayEinvoice."E-Invoice Acknowledge No.";
                        txtEwayEinvoice[3] := COPYSTR(recEwayEinvoice."E-Invoice Acknowledge Date", 1, 10);

                        IF txtEwayEinvoice[3] <> '' THEN BEGIN
                            Year := 0;
                            Month := 0;
                            Day := 0;
                            EVALUATE(Year, COPYSTR(txtEwayEinvoice[3], 1, 4));
                            EVALUATE(Month, COPYSTR(txtEwayEinvoice[3], 6, 2));
                            EVALUATE(Day, COPYSTR(txtEwayEinvoice[3], 9, 2));
                            AckDate := DMY2DATE(Day, Month, Year);
                        END;

                        txtEwayEinvoice[4] := recEwayEinvoice."Vehicle No.";
                        txtEwayEinvoice[5] := recEwayEinvoice."LR/RR No.";
                        txtEwayEinvoice[6] := FORMAT(recEwayEinvoice."LR/RR Date");
                        txtEwayEinvoice[7] := recEwayEinvoice."Transporter Name";
                        /* recVendor.RESET();
                         recVendor.SETRANGE("No.",recEwayEinvoice."Transporter Code");
                           IF recVendor.FIND('-') THEN
                             txtEwayEinvoice[7] := recVendor.Name;*/
                        txtEwayEinvoice[8] := recEwayEinvoice."E-Way Bill No.";
                        txtEwayEinvoice[9] := FORMAT(recEwayEinvoice."E-Way Bill Date");
                        IF txtEwayEinvoice[9] <> '' THEN BEGIN
                            Year := 0;
                            Month := 0;
                            Day := 0;
                            EVALUATE(Year, COPYSTR(txtEwayEinvoice[9], 1, 4));
                            EVALUATE(Month, COPYSTR(txtEwayEinvoice[9], 6, 2));
                            EVALUATE(Day, COPYSTR(txtEwayEinvoice[9], 9, 2));
                            EWayBillDt := DMY2DATE(Day, Month, Year);
                        END;
                    END;

                    CLEAR(txtBillInfo);
                    recCust.RESET();
                    recCust.SETRANGE("No.", "Sales Invoice Header"."Bill-to Customer No.");
                    IF recCust.FIND('-') THEN BEGIN
                        txtBillInfo[1] := recCust."Phone No.";
                    END;
                    recState.RESET();
                    recState.SETRANGE(Code, "Sales Invoice Header"."GST Bill-to State Code");
                    IF recState.FIND('-') THEN BEGIN
                        txtBillInfo[2] := recState.Description;
                        txtBillInfo[4] := recState."State Code (GST Reg. No.)";
                    END;
                    recCountry.RESET();
                    recCountry.SETRANGE(Code, "Sales Invoice Header"."Bill-to Country/Region Code");
                    IF recCountry.FIND('-') THEN
                        txtBillInfo[3] := recCountry.Name;

                    CLEAR(txtConsignee);
                    IF "Sales Invoice Header"."Ship-to Code" <> '' THEN BEGIN
                        recShiptoAddress.RESET();
                        recShiptoAddress.SETRANGE(Code, "Sales Invoice Header"."Ship-to Code");
                        recShiptoAddress.SETRANGE("Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                        IF recShiptoAddress.FIND('-') THEN BEGIN
                            txtConsignee[1] := recShiptoAddress.Name;
                            txtConsignee[2] := recShiptoAddress.Address;
                            txtConsignee[3] := recShiptoAddress."Address 2";
                            txtConsignee[4] := recShiptoAddress.City;
                            txtConsignee[5] := recShiptoAddress."Post Code";
                            txtConsignee[6] := recShiptoAddress."Phone No."; //Acxcp15122021_Code added - Ship to Phone No.

                            /*
                            recCust.RESET();
                            recCust.SETRANGE("No.",recShiptoAddress."Customer No.");
                              IF recCust.FIND('-') THEN
                                txtConsignee[6] := recCust."Phone No.";
                            *///Acxcp15122021_Code Blocked - Bill to Phone No. in Shipping detial

                            txtConsignee[7] := "Sales Invoice Header"."GST Ship-to State Code";
                            txtConsignee[8] := "Sales Invoice Header"."Ship-to GST Reg. No.";
                            recState.RESET();
                            recState.SETRANGE(Code, recShiptoAddress.State);
                            IF recState.FIND('-') THEN BEGIN
                                txtConsignee[9] := recState.Description;
                                txtConsignee[11] := recState."State Code (GST Reg. No.)";
                            END;
                            recCountry.RESET();
                            recCountry.SETRANGE(Code, recShiptoAddress."Country/Region Code");
                            IF recCountry.FIND('-') THEN
                                txtConsignee[10] := recCountry.Name;
                        END;
                    END
                    ELSE
                        IF "Sales Invoice Header"."Ship-to Code" = '' THEN BEGIN
                            txtConsignee[1] := "Sales Invoice Header"."Bill-to Name";
                            txtConsignee[2] := "Sales Invoice Header"."Bill-to Address";
                            txtConsignee[3] := "Sales Invoice Header"."Bill-to Address 2";
                            txtConsignee[4] := "Sales Invoice Header"."Bill-to City";
                            txtConsignee[5] := "Sales Invoice Header"."Bill-to Post Code";
                            recCust.RESET();
                            recCust.SETRANGE("No.", "Sales Invoice Header"."Bill-to Customer No.");
                            IF recCust.FIND('-') THEN
                                txtConsignee[6] := recCust."Phone No.";
                            txtConsignee[7] := "Sales Invoice Header"."GST Bill-to State Code";
                            txtConsignee[8] := "Sales Invoice Header"."Customer GST Reg. No.";
                            recState.RESET();
                            recState.SETRANGE(Code, "Sales Invoice Header"."GST Bill-to State Code");
                            IF recState.FIND('-') THEN BEGIN
                                txtConsignee[9] := recState.Description;
                                txtConsignee[11] := recState."State Code (GST Reg. No.)";
                            END;
                            recCountry.RESET();
                            recCountry.SETRANGE(Code, "Sales Invoice Header"."Bill-to Country/Region Code");
                            IF recCountry.FIND('-') THEN
                                txtConsignee[10] := recCountry.Name;
                        END;

                    decRoundOff := 0;
                    recSalesCrMemoLine.RESET();
                    recSalesCrMemoLine.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                    recSalesCrMemoLine.SETRANGE("No.", '427000210');
                    IF recSalesCrMemoLine.FIND('-') THEN BEGIN
                        decRoundOff := recSalesCrMemoLine."Line Amount";
                        dcRoundoffQty := recSalesCrMemoLine.Quantity;
                    END;

                    decAmounttoCust := 0;
                    // decTotalQty := 0;
                    decTotalNetWt := 0;
                    recSalesCrMemoLine.RESET();
                    recSalesCrMemoLine.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                    //recSalesCrMemoLine.SETRANGE(Type,recSalesCrMemoLine.Type::Item);//KM
                    recSalesCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
                    IF recSalesCrMemoLine.FIND('-') THEN BEGIN
                        REPEAT
                            decUOMQtyper := 0;
                            recItemUOM.RESET();
                            recItemUOM.SETRANGE("Item No.", recSalesCrMemoLine."No.");
                            recItemUOM.SETFILTER(Code, '%1', 'CTN');
                            IF recItemUOM.FIND('-') THEN
                                decUOMQtyper := recItemUOM."Qty. per Unit of Measure";
                            decTotalAmount += recSalesCrMemoLine."Amount To Customer" + decRoundOff;
                            decAmounttoCust += recSalesCrMemoLine."Amount To Customer";
                            //      decTotalQty += recSalesCrMemoLine.Quantity;
                            decTotalNetWt += recSalesCrMemoLine.Quantity;//km * decUOMQtyper;
                        UNTIL
                          recSalesCrMemoLine.NEXT = 0;
                    END;

                    RecCheck.InitTextVariable;
                    RecCheck.FormatNoText(Numbertxt, (decAmounttoCust + decRoundOff), "Sales Invoice Header"."Currency Code");
                    //RecCheck.FormatNoText(Numbertxt,decTotalAmount,"Sales Invoice Header"."Currency Code");//acxcp //Amount+Roundoff

                    txtCurrCode := '';
                    IF "Sales Invoice Header"."Currency Code" = '' THEN
                        txtCurrCode := 'INR'
                    ELSE
                        txtCurrCode := "Sales Invoice Header"."Currency Code";

                end;

                trigger OnPreDataItem()
                begin
                    Sno := 0;
                    recCompanyInfo.GET;
                    recCompanyInfo.CALCFIELDS(Picture);
                    recState.RESET();
                    recState.SETRANGE(Code, recCompanyInfo.State);
                    IF recState.FINDFIRST THEN
                        CompState := recState.Description;
                    decTotalQty := 0;
                    decTotalAmount := 0;
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
                    }
                    field("Duplicate For Transporter"; "Duplicate For Transporter")
                    {
                        Caption = 'Duplicate For Transporter';
                    }
                    field("Triplicate For Assee"; "Triplicate For Assee")
                    {
                        Caption = 'Triplicate For Assee';
                    }
                    field("Extra Copy"; "Extra Copy")
                    {
                        Caption = 'Extra Copy';
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

    var
        recCompanyInfo: Record "79";
        txtCompanyInfo: array[10] of Text;
        recState: Record "13762";
        recCountry: Record "9";
        recLocation: Record "14";
        txtLocation: array[10] of Text;
        recBankAccount: Record "270";
        recEwayEinvoice: Record "50000";
        txtEwayEinvoice: array[10] of Text;
        recVendor: Record "23";
        recCust: Record "18";
        txtBillInfo: array[5] of Text;
        recShiptoAddress: Record "222";
        txtConsignee: array[15] of Text;
        recSalesCrMemoLine: Record "113";
        decRoundOff: Decimal;
        decTotalAmount: Decimal;
        decAmounttoCust: Decimal;
        RecCheck: Report "1401";
        Numbertxt: array[1] of Text;
        Sno: Integer;
        recVE: Record "5802";
        recILE: Record "32";
        recLotInfo: Record "6505";
        txtLotNo: Text;
        dtExpiry: Date;
        dtMfg: Date;
        recDGLE: Record "16419";
        decCGST: Decimal;
        decSGST: Decimal;
        decIGST: Decimal;
        decCGSTper: Decimal;
        decSGSTper: Decimal;
        decIGSTper: Decimal;
        recItemUOM: Record "5404";
        decQtyper: Decimal;
        decTotalQty: Decimal;
        decTotalNetWt: Decimal;
        decUOMQtyper: Decimal;
        txtCurrCode: Text;
        decGSTper: Decimal;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        AckDate: Date;
        Counter: Integer;
        Txt001: Text;
        AllCopies: Boolean;
        "Duplicate For Transporter": Boolean;
        "Triplicate For Assee": Boolean;
        "Extra Copy": Boolean;
        pageint: Integer;
        pageint1: Integer;
        pageint2: Integer;
        EWayBillDt: Date;
        CompState: Text;
        decAltQty: Decimal;
        dcRoundoffQty: Decimal;
}

