report 50005 "Sales Return Tax Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\SalesReturnTaxInvoice.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Integer; Integer)
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
            dataitem("Sales Cr.Memo Header"; 114)
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
                column(ShiptocodeText; ShiptocodeText)
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
                column(CompState; CompState)
                {
                }
                column(Reg_State; txtCompanyInfo[4])
                {
                }
                column(Company_Country; txtCompanyInfo[5])
                {
                }
                column(Reg_Email; recCompanyInfo."Registration Email")
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
                column(Company_CIN; recCompanyInfo."GST Registration No.")//16767 "Company Registration  No." replace GST Registration No."
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
                column(Company_Bank_Acc_No; "Sales Cr.Memo Header"."Bill-to Customer No.")
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
                column(Location_GST_No; "Sales Cr.Memo Header"."Location GST Reg. No.")
                {
                }
                column(Document_No; "Sales Cr.Memo Header"."No.")
                {
                }
                column(Posting_Date; "Sales Cr.Memo Header"."Posting Date")
                {
                }
                column(Due_Date; "Sales Cr.Memo Header"."Due Date")
                {
                }
                column(Vehicle_No; txtEwayEinvoice[4])
                {
                }
                column(LR_No; txtEwayEinvoice[5])
                {
                }
                column(LR_Date; txtEwayEinvoice[6])
                {
                }
                column(Transporter_Name; txtEwayEinvoice[7])
                {
                }
                column(E_Way_No; txtEwayEinvoice[8])
                {
                }
                column(E_Way_Date; txtEwayEinvoice[9])
                {
                }
                column(External_Doc_No; "Sales Cr.Memo Header"."External Document No.")
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
                column(Ship_Name2; txtConsignee[12])
                {
                }
                column(ship_Name3; txtConsignee[13])
                {
                }
                column(Amount_In_Words_Total; Numbertxt[1])
                {
                }
                column(Bill_to_Name; "Sales Cr.Memo Header"."Bill-to Name")
                {
                }
                column(Bill_to_Address; "Sales Cr.Memo Header"."Bill-to Address")
                {
                }
                column(Bill_to_Address2; "Sales Cr.Memo Header"."Bill-to Address 2")
                {
                }
                column(Bill_to_City; "Sales Cr.Memo Header"."Bill-to City")
                {
                }
                column(Bill_to_Postcode; "Sales Cr.Memo Header"."Bill-to Post Code")
                {
                }
                column(Bill_to_Country; "Sales Cr.Memo Header"."Bill-to Country/Region Code")
                {
                }
                column(BillToName2; BillToName2)
                {
                }
                column(BillToName3; BillToName3)
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
                column(Cust_GST_No; "Sales Cr.Memo Header"."Customer GST Reg. No.")
                {
                }
                column(Round_Off; decRoundOff)
                {
                }
                column(TotalAmount; decTotalAmount)
                {
                }
                column(GrandlAmount; decAmounttoCust)
                {
                }
                column(Total_Qty; decTotalQty)
                {
                }
                column(Total_Net_Wt; decTotalNetWt)
                {
                }
                column(Curr_Code; txtCurrCode)
                {
                }
                column(TotalQty1; decTotalQty1)
                {
                }
                column(Document_date; "Sales Cr.Memo Header"."Document Date")
                {
                }
                dataitem("Sales Cr.Memo Line"; 115)
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = WHERE(Quantity = FILTER(<> 0),
                                              "No." = FILTER(<> 427000210));
                    column(Sno; Sno)
                    {
                    }
                    column(Item_No; "Sales Cr.Memo Line"."No.")
                    {
                    }
                    column(Description; "Sales Cr.Memo Line".Description + '-' + "Sales Cr.Memo Line"."Description 2")
                    {
                    }
                    column(Lot_No; txtLotNo)
                    {
                    }
                    column(HSN; "Sales Cr.Memo Line"."HSN/SAC Code")
                    {
                    }
                    column(Mfg; dtMfg)
                    {
                    }
                    column(Expiry; dtExpiry)
                    {
                    }
                    column(Quantity; "Sales Cr.Memo Line".Quantity)
                    {
                    }
                    column(Qty_KGS_LTR; "Sales Cr.Memo Line".Quantity * decQtyper)
                    {
                    }
                    column(Rate; "Sales Cr.Memo Line"."Unit Price")
                    {
                    }
                    column(MRP; "Sales Cr.Memo Line"."MRP Price New")
                    {
                    }
                    column(Amount; "Sales Cr.Memo Line"."Line Amount")
                    {
                    }
                    column(Disc_per; ROUND("Sales Cr.Memo Line"."Line Discount %", 0.01))
                    {
                    }
                    column(GST_Base_Amt; GstBaseAmt) //16767 "Sales Cr.Memo Line"."GST Base Amount"
                    {
                    }
                    column(CGST; decCGST)
                    {
                    }
                    column(SGST; decSGST)
                    {
                    }
                    column(IGST; decIGST)
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
                    column(TotalAmt; AmtToCust.GetAmttoCustomerPostedLine("Document No.", "Line No.")) //16767 "Sales Cr.Memo Line"."Amount To Customer"
                    {
                    }
                    column(GST_per; FORMAT(ROUND(decGSTper, 1)))
                    {
                    }
                    column(GST; FORMAT(ROUND(GstPer, 1))) //16767 "Sales Cr.Memo Line"."GST %"
                    {
                    }
                    column(LineNo; "Sales Cr.Memo Line"."Line No.")
                    {
                    }
                    column(decQtyper; decQtyper)
                    {
                    }
                    column(Mfg1; dtMfg)
                    {
                    }
                    column(Expdt; dtExpiry)
                    {
                    }
                    column(TotQtyKGLtr; TotQtyKGLtr)
                    {
                    }
                    column(LotQty; decCGST)
                    {
                    }
                    column(BatchMRP; BillToName2)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Sno := Sno + 1;



                        // decQtyper := 0;
                        // recItemUOM.RESET();
                        // recItemUOM.SETRANGE("Item No.","Sales Cr.Memo Line"."No.");
                        // recItemUOM.SETFILTER(Code,'%1','CTN');
                        //  IF recItemUOM.FIND('-') THEN
                        //    decQtyper := recItemUOM."Qty. per Unit of Measure";
                        //ACX-RK 14062021 Begin
                        decQtyper := 0;
                        recItemUOM.RESET();
                        recItemUOM.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
                        recItemUOM.SETFILTER(Code, '%1', 'KGS');
                        IF recItemUOM.FIND('-') THEN BEGIN
                            decQtyper := recItemUOM."Qty. per Unit of Measure" * "Sales Cr.Memo Line".Quantity;
                            TotQtyKGLtr += recItemUOM."Qty. per Unit of Measure" * "Sales Cr.Memo Line".Quantity;
                        END;
                        recItemUOM.RESET();
                        recItemUOM.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
                        recItemUOM.SETFILTER(Code, '%1', 'LTR');
                        IF recItemUOM.FIND('-') THEN BEGIN
                            decQtyper := recItemUOM."Qty. per Unit of Measure" * "Sales Cr.Memo Line".Quantity;
                            TotQtyKGLtr += recItemUOM."Qty. per Unit of Measure" * "Sales Cr.Memo Line".Quantity;
                        END;
                        //End

                        GstPer := 0;
                        GstBaseAmt := 0;
                        CgstPer := 0;
                        CgstBaseAmt := 0;
                        decCGST := 0;
                        decCGSTper := 0;
                        recDGLE.RESET();
                        recDGLE.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                        recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                        //recDGLE.SETRANGE("HSN/SAC Code","Sales Cr.Memo Line"."HSN/SAC Code");
                        recDGLE.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                        recDGLE.SETRANGE("GST Component Code", 'CGST');
                        IF recDGLE.FIND('-') THEN BEGIN
                            REPEAT

                                decGSTper := 0;
                                decCGSTper := recDGLE."GST %";
                                decCGST += recDGLE."GST Amount";
                                decGSTper := recDGLE."GST %";
                                CgstPer := Abs(recDGLE."GST %");//16767 
                                CgstBaseAmt := Abs(recDGLE."GST Base Amount")//16767
                            UNTIL recDGLE.NEXT = 0;
                        END;
                        SgstPer := 0;
                        SgstBaseAmt := 0;
                        decSGST := 0;
                        decSGSTper := 0;
                        recDGLE.RESET();
                        recDGLE.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                        recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                        //recDGLE.SETRANGE("HSN/SAC Code","Sales Cr.Memo Line"."HSN/SAC Code");
                        recDGLE.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                        recDGLE.SETRANGE("GST Component Code", 'SGST');
                        IF recDGLE.FIND('-') THEN BEGIN
                            REPEAT
                                decGSTper := 0;
                                decSGSTper := recDGLE."GST %";
                                decSGST += recDGLE."GST Amount";
                                decGSTper := recDGLE."GST %";
                                SgstPer := Abs(recDGLE."GST %");//16767 
                                SgstBaseAmt := Abs(recDGLE."GST Base Amount")//16767
                            UNTIL recDGLE.NEXT = 0;
                        END;
                        IgstPer := 0;
                        IgstBaseAmt := 0;
                        decIGST := 0;
                        decIGSTper := 0;
                        recDGLE.RESET();
                        recDGLE.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                        recDGLE.SETRANGE("Entry Type", recDGLE."Entry Type"::"Initial Entry");
                        //recDGLE.SETRANGE("HSN/SAC Code","Sales Cr.Memo Line"."HSN/SAC Code");
                        recDGLE.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                        recDGLE.SETRANGE("GST Component Code", 'IGST');
                        IF recDGLE.FINDSET THEN BEGIN
                            REPEAT
                                decGSTper := 0;
                                decIGSTper := recDGLE."GST %";
                                decIGST += recDGLE."GST Amount";
                                decGSTper := recDGLE."GST %";
                                IgstPer := Abs(recDGLE."GST %");//16767 
                                IgstBaseAmt := Abs(recDGLE."GST Base Amount")//16767
                            UNTIL recDGLE.NEXT = 0;
                            GstBaseAmt := (IgstBaseAmt + SgstBaseAmt);//1676
                            GstPer := (IgstPer + CgstPer + SgstPer);//16767
                        END;

                        //acxcp190821
                        recItemUOM.RESET();
                        recItemUOM.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
                        recItemUOM.SETFILTER(Code, '<>%1', "Sales Cr.Memo Line"."Unit of Measure Code");
                        IF recItemUOM.FIND('-') THEN BEGIN
                            decTotalQty1 += recItemUOM."Qty. per Unit of Measure" * "Sales Cr.Memo Line".Quantity;
                            //decAltQty:=recItemUOM."Qty. per Unit of Measure" * "Sales Cr.Memo Line".Quantity; //acxcp_190821
                        END;
                        //acxcp190
                        txtLotNo := '';
                        dtExpiry := 0D;
                        dtMfg := 0D;
                        recVE.RESET();
                        recVE.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
                        recVE.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                        IF recVE.FIND('-') THEN BEGIN
                            REPEAT
                                recILE.RESET();
                                recILE.SETRANGE("Entry No.", recVE."Item Ledger Entry No.");
                                IF recILE.FINDSET THEN BEGIN
                                    txtLotNo := recILE."Lot No.";
                                    recLotInfo.RESET;
                                    recLotInfo.SETRANGE("Lot No.", recILE."Lot No.");
                                    recLotInfo.SETRANGE("Item No.", recILE."Item No.");
                                    IF recLotInfo.FINDFIRST THEN BEGIN
                                        dtMfg := recLotInfo."MFG Date";
                                        dtExpiry := recLotInfo."Expiration Date";

                                    END;

                                END;
                            UNTIL recVE.NEXT = 0;
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
                    recLocation.SETRANGE(Code, "Sales Cr.Memo Header"."Location Code");
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
                    recEwayEinvoice.SETRANGE("No.", "Sales Cr.Memo Header"."No.");
                    IF recEwayEinvoice.FIND('-') THEN BEGIN
                        recEwayEinvoice.CALCFIELDS("QR Code");
                        txtEwayEinvoice[1] := recEwayEinvoice."E-Invoice IRN No";
                        txtEwayEinvoice[2] := recEwayEinvoice."E-Invoice Acknowledge No.";
                        txtEwayEinvoice[3] := COPYSTR(recEwayEinvoice."E-Invoice Acknowledge Date", 1, 10);

                        IF txtEwayEinvoice[3] <> '' THEN BEGIN
                            EVALUATE(Year, COPYSTR(txtEwayEinvoice[3], 1, 4));
                            EVALUATE(Month, COPYSTR(txtEwayEinvoice[3], 6, 2));
                            EVALUATE(Day, COPYSTR(txtEwayEinvoice[3], 9, 2));
                            AckDate := DMY2DATE(Day, Month, Year);
                        END;

                        txtEwayEinvoice[4] := recEwayEinvoice."Vehicle No.";
                        txtEwayEinvoice[5] := recEwayEinvoice."LR/RR No.";
                        txtEwayEinvoice[6] := FORMAT(recEwayEinvoice."LR/RR Date");
                        recVendor.RESET();
                        recVendor.SETRANGE("No.", recEwayEinvoice."Transporter Code");
                        IF recVendor.FIND('-') THEN
                            txtEwayEinvoice[7] := recVendor.Name;
                        txtEwayEinvoice[8] := recEwayEinvoice."E-Way Bill No.";
                        txtEwayEinvoice[9] := FORMAT(recEwayEinvoice."E-Way Bill Date");
                    END;

                    CLEAR(txtBillInfo);
                    recCust.RESET();
                    recCust.SETRANGE("No.", "Sales Cr.Memo Header"."Bill-to Customer No.");
                    IF recCust.FIND('-') THEN BEGIN
                        txtBillInfo[1] := recCust."Phone No.";
                    END;
                    recState.RESET();
                    recState.SETRANGE(Code, "Sales Cr.Memo Header"."GST Bill-to State Code");
                    IF recState.FIND('-') THEN BEGIN
                        txtBillInfo[2] := recState.Description;
                        txtBillInfo[4] := recState."State Code (GST Reg. No.)";
                    END;
                    recCountry.RESET();
                    recCountry.SETRANGE(Code, "Sales Cr.Memo Header"."Bill-to Country/Region Code");
                    IF recCountry.FIND('-') THEN
                        txtBillInfo[3] := recCountry.Name;

                    CLEAR(txtConsignee);
                    IF "Sales Cr.Memo Header"."Ship-to Code" <> '' THEN BEGIN
                        recShiptoAddress.RESET();
                        recShiptoAddress.SETRANGE(Code, "Sales Cr.Memo Header"."Ship-to Code");
                        recShiptoAddress.SETRANGE("Customer No.", "Sales Cr.Memo Header"."Sell-to Customer No.");
                        IF recShiptoAddress.FIND('-') THEN BEGIN
                            txtConsignee[1] := recShiptoAddress.Name;
                            IF recShiptoAddress."Name 2" <> '' THEN
                                txtConsignee[12] := ' ,' + recShiptoAddress."Name 2";
                            IF recShiptoAddress."Name 3" <> '' THEN
                                txtConsignee[13] := ' ,' + recShiptoAddress."Name 3";
                            txtConsignee[2] := recShiptoAddress.Address;
                            txtConsignee[3] := recShiptoAddress."Address 2";
                            txtConsignee[4] := recShiptoAddress.City;
                            txtConsignee[5] := recShiptoAddress."Post Code";
                            recCust.RESET();
                            recCust.SETRANGE("No.", recShiptoAddress."Customer No.");
                            IF recCust.FIND('-') THEN
                                txtConsignee[6] := recCust."Phone No.";
                            txtConsignee[7] := "Sales Cr.Memo Header"."GST Ship-to State Code";
                            txtConsignee[8] := "Sales Cr.Memo Header"."Ship-to GST Reg. No.";
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
                        IF "Sales Cr.Memo Header"."Ship-to Code" = '' THEN BEGIN
                            txtConsignee[1] := "Sales Cr.Memo Header"."Bill-to Name";
                            IF "Sales Cr.Memo Header"."Bill-to Name 2" <> '' THEN
                                txtConsignee[12] := ', ' + "Sales Cr.Memo Header"."Bill-to Name 2";
                            IF "Sales Cr.Memo Header"."Bill-to Name 3" <> '' THEN
                                txtConsignee[13] := ', ' + "Sales Cr.Memo Header"."Bill-to Name 3";
                            txtConsignee[2] := "Sales Cr.Memo Header"."Bill-to Address";
                            txtConsignee[3] := "Sales Cr.Memo Header"."Bill-to Address 2";
                            txtConsignee[4] := "Sales Cr.Memo Header"."Bill-to City";
                            txtConsignee[5] := "Sales Cr.Memo Header"."Bill-to Post Code";
                            recCust.RESET();
                            recCust.SETRANGE("No.", "Sales Cr.Memo Header"."Bill-to Customer No.");
                            IF recCust.FIND('-') THEN
                                txtConsignee[6] := recCust."Phone No.";
                            txtConsignee[7] := "Sales Cr.Memo Header"."GST Bill-to State Code";
                            txtConsignee[8] := "Sales Cr.Memo Header"."Customer GST Reg. No.";
                            recState.RESET();
                            recState.SETRANGE(Code, "Sales Cr.Memo Header"."GST Bill-to State Code");
                            IF recState.FIND('-') THEN BEGIN
                                txtConsignee[9] := recState.Description;
                                txtConsignee[11] := recState."State Code (GST Reg. No.)";
                            END;
                            recCountry.RESET();
                            recCountry.SETRANGE(Code, "Sales Cr.Memo Header"."Bill-to Country/Region Code");
                            IF recCountry.FIND('-') THEN
                                txtConsignee[10] := recCountry.Name;
                        END;

                    decRoundOff := 0;
                    recSalesCrMemoLine.RESET();
                    recSalesCrMemoLine.SETRANGE("Document No.", "Sales Cr.Memo Header"."No.");
                    recSalesCrMemoLine.SETRANGE("No.", '427000210');
                    IF recSalesCrMemoLine.FIND('-') THEN BEGIN
                        decRoundOff := recSalesCrMemoLine."Line Amount";
                    END;

                    decTotalAmount := 0;
                    decAmounttoCust := 0;
                    decTotalQty := 0;
                    decTotalNetWt := 0;
                    recSalesCrMemoLine.RESET();
                    recSalesCrMemoLine.SETRANGE("Document No.", "Sales Cr.Memo Header"."No.");
                    recSalesCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
                    recSalesCrMemoLine.SETFILTER("No.", '<>%1', '427000210');//ACXCP_190821
                    IF recSalesCrMemoLine.FIND('-') THEN BEGIN
                        REPEAT
                            decUOMQtyper := 0;
                            recItemUOM.RESET();
                            recItemUOM.SETRANGE("Item No.", recSalesCrMemoLine."No.");
                            recItemUOM.SETFILTER(Code, '%1', 'CTN');
                            IF recItemUOM.FIND('-') THEN
                                decUOMQtyper := recItemUOM."Qty. per Unit of Measure";
                            decTotalAmount += AmtToCust.GetAmttoCustomerPostedLine(recSalesCrMemoLine."Document No.", recSalesCrMemoLine."Line No.") + decRoundOff; //16767 recSalesCrMemoLine."Amount To Customer"
                            decAmounttoCust += AmtToCust.GetAmttoCustomerPostedLine(recSalesCrMemoLine."Document No.", recSalesCrMemoLine."Line No."); //16767 recSalesCrMemoLine."Amount To Customer"
                            decTotalQty += recSalesCrMemoLine.Quantity;
                            decTotalNetWt += recSalesCrMemoLine.Quantity * decUOMQtyper;
                        UNTIL
                          recSalesCrMemoLine.NEXT = 0;
                    END;

                    RecCheck.InitTextVariable;
                    RecCheck.FormatNoText(Numbertxt, (decAmounttoCust + decRoundOff), "Sales Cr.Memo Header"."Currency Code");

                    txtCurrCode := '';
                    IF "Sales Cr.Memo Header"."Currency Code" = '' THEN
                        txtCurrCode := 'INR'
                    ELSE
                        txtCurrCode := "Sales Cr.Memo Header"."Currency Code";
                    //If Ship to code is not blank then
                    IF "Sales Cr.Memo Header"."Ship-to Code" <> '' THEN
                        ShiptocodeText := '- ' + "Sales Cr.Memo Header"."Ship-to Code";
                    IF "Sales Cr.Memo Header"."Bill-to Name 2" <> '' THEN
                        BillToName2 := ', ' + "Sales Cr.Memo Header"."Bill-to Name 2";
                    IF "Sales Cr.Memo Header"."Bill-to Name 3" <> '' THEN
                        BillToName3 := ', ' + "Sales Cr.Memo Header"."Bill-to Name 3";
                end;

                trigger OnPreDataItem()
                begin
                    recCompanyInfo.GET;
                    recCompanyInfo.CALCFIELDS(Picture);
                    recState.RESET();
                    //16767 recState.SETRANGE(Code, recCompanyInfo.State);
                    recState.SETRANGE(Code, recCompanyInfo."State Code");
                    IF recState.FINDFIRST THEN
                        CompState := recState.Description;
                    Sno := 0;
                    decTotalQty1 := 0; //acxcp190821
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
        GstPer: Decimal;
        IgstPer: Decimal;
        CgstPer: Decimal;
        SgstPer: Decimal;
        GstBaseAmt: Decimal;
        IgstBaseAmt: Decimal;
        SgstBaseAmt: Decimal;
        CgstBaseAmt: Decimal;

        AmtToCust: Codeunit 50200;
        recCompanyInfo: Record 79;
        txtCompanyInfo: array[10] of Text;
        recState: Record State;
        recCountry: Record 9;
        recLocation: Record 14;
        txtLocation: array[10] of Text;
        recBankAccount: Record 270;
        recEwayEinvoice: Record 50000;
        txtEwayEinvoice: array[10] of Text;
        recVendor: Record 23;
        recCust: Record 18;
        txtBillInfo: array[5] of Text;
        recShiptoAddress: Record 222;
        txtConsignee: array[15] of Text;
        recSalesCrMemoLine: Record 115;
        decRoundOff: Decimal;
        decTotalAmount: Decimal;
        decAmounttoCust: Decimal;
        RecCheck: Report 1401;
        Numbertxt: array[1] of Text;
        Sno: Integer;
        recVE: Record 5802;
        recILE: Record 32;
        recLotInfo: Record 6505;
        txtLotNo: Text;
        dtExpiry: Date;
        dtMfg: Date;
        recDGLE: Record "Detailed GST Ledger Entry";
        decCGST: Decimal;
        decSGST: Decimal;
        decIGST: Decimal;
        decCGSTper: Decimal;
        decSGSTper: Decimal;
        decIGSTper: Decimal;
        recItemUOM: Record 5404;
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
        BillToName2: Text;
        BillToName3: Text;
        CompState: Text;
        ShiptocodeText: Text;
        TotQtyKGLtr: Decimal;
        decTotalQty1: Decimal;
}