report 50058 PurCreditMemoReport
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\PurCreditMemoReport.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            //CalcFields = "Amount to Vendor";
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Posting Date";
            column(LocationCode_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Location Code")
            {
            }
            column(BuyfromVendorNo; "Purch. Cr. Memo Hdr."."Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName; "Purch. Cr. Memo Hdr."."Buy-from Vendor Name")
            {
            }
            column(BuyfromVendorName2; "Purch. Cr. Memo Hdr."."Buy-from Vendor Name 2")
            {
            }
            column(BuyfromAddress; "Purch. Cr. Memo Hdr."."Buy-from Address")
            {
            }
            column(BuyfromAddress2; "Purch. Cr. Memo Hdr."."Buy-from Address 2")
            {
            }
            column(BuyfromCity; "Purch. Cr. Memo Hdr."."Buy-from City")
            {
            }
            column(BuyfromContact; "Purch. Cr. Memo Hdr."."Buy-from Contact")
            {
            }
            column(BuyfromPostCode; "Purch. Cr. Memo Hdr."."Buy-from Post Code")
            {
            }
            column(BuyFrmCountryName; BuyFrmCountryName)
            {
            }
            column(BuyFromStateName; BuyFromStateName)
            {
            }
            column(No_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."No.")
            {
            }
            column(PostingDateHdr; "Purch. Cr. Memo Hdr."."Posting Date")
            {
            }
            column(BuyVenGSTNo; txtVenGSTDtl[1])
            {
            }
            column(BuyVenPANNo; txtVenGSTDtl[2])
            {
            }
            column(CompPAN; CompanyInfo."P.A.N. No.")
            {
            }
            column(CompLogo; CompanyInfo.Picture)
            {
            }
            column(CompName; CompanyInfo.Name)
            {
            }
            column(CompName2; CompanyInfo."Name 2")
            {
            }
            column(CompAdd1; CompanyInfo.Address)
            {
            }
            column(CompAdd2; CompanyInfo."Address 2")
            {
            }
            column(CompCity; CompanyInfo.City)
            {
            }
            column(CompPostCode; CompanyInfo."Post Code")
            {
            }
            column(CompStateCode; txtCmpInfo[1])
            {
            }
            column(CompCountryRegion; txtCmpInfo[2])
            {
            }
            column(CompPhone; CompanyInfo."Phone No." + ' ' + CompanyInfo."Phone No. 2")
            {
            }
            column(CompEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompWebsite; CompanyInfo."Home Page")
            {
            }
            column(CINNo; CompanyInfo."Registration No.")
            {
            }
            column(CompBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompBranch; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompBankAcctNo; CompanyInfo."Bank Account No.")
            {
            }
            column(RegAdd1; CompanyInfo."Registration Address")
            {
            }
            column(RegAdd2; CompanyInfo."Registration Address 2")
            {
            }
            column(RegCity; CompanyInfo."Registration City")
            {
            }
            column(RegPostCode; CompanyInfo."Registration Post code")
            {
            }
            column(RegStateName; CompanyInfo."Registration State")
            {
            }
            column(RegGSTIN; CompanyInfo."Registration GSTIN")
            {
            }
            column(RegPAN; CompanyInfo."Registration P.A.N.")
            {
            }
            column(RegEmail; CompanyInfo."Registration Email")
            {
            }
            column(RegPhone; CompanyInfo."Registration Phone No.")
            {
            }
            column(LocName; txtLocAdd[1])
            {
            }
            column(LocAdd1; txtLocAdd[2])
            {
            }
            column(LocAdd2; txtLocAdd[3])
            {
            }
            column(LocCity; txtLocAdd[4])
            {
            }
            column(LocPostCode; txtLocAdd[5])
            {
            }
            column(LocGSTNo; txtLocAdd[6])
            {
            }
            column(LocPhoneNo; txtLocAdd[7])
            {
            }
            column(LocStateName; txtLocAdd[8])
            {
            }
            column(LocCountryName; txtLocAdd[9])
            {
            }
            column(ShiptoCode; "Purch. Cr. Memo Hdr."."Ship-to Code")
            {
            }
            column(ShiptoName; "Purch. Cr. Memo Hdr."."Ship-to Name")
            {
            }
            column(ShiptoName2; "Purch. Cr. Memo Hdr."."Ship-to Name 2")
            {
            }
            column(ShiptoAddress; "Purch. Cr. Memo Hdr."."Ship-to Address")
            {
            }
            column(ShiptoAddress2; "Purch. Cr. Memo Hdr."."Ship-to Address 2")
            {
            }
            column(ShiptoCity; "Purch. Cr. Memo Hdr."."Ship-to City")
            {
            }
            column(ShiptoPostCode; "Purch. Cr. Memo Hdr."."Ship-to Post Code")
            {
            }
            column(ShiptoCountryRegionCode; "Purch. Cr. Memo Hdr."."Ship-to Country/Region Code")
            {
            }
            column(ShiptoContact; "Purch. Cr. Memo Hdr."."Ship-to Contact")
            {
            }
            column(VendorCrMemoNo; "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.")
            {
            }
            column(txtComment; txtComment)
            {
            }
            column(decRoundOff; decRoundOff)
            {
            }
            column(AmounttoVendorHdr; Codeunit50200.AmttoVendorPurchCrMemoHdr("Purch. Cr. Memo Hdr."))
            {
            }
            column(Amount_In_Words_Total; UpperCase(Numbertxt[1] + ' ' + Numbertxt[2])) //16767
            {
            }
            column(CGST; ABS(dcCGST))
            {
            }
            column(SGST; ABS(dcSGST))
            {
            }
            column(IGST; ABS(dcIGST))
            {
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    WHERE("System-Created Entry" = FILTER(false));
                column(UnitofMeasure_PurchCrMemoLine; "Purch. Cr. Memo Line"."Unit of Measure")
                {
                }
                column(BuyfromVendorNo_PurchCrMemoLine; "Purch. Cr. Memo Line"."Buy-from Vendor No.")
                {
                }
                column(DocumentNo_PurchCrMemoLine; "Purch. Cr. Memo Line"."Document No.")
                {
                }
                column(Type_PurchCrMemoLine; "Purch. Cr. Memo Line".Type)
                {
                }
                column(No_PurchCrMemoLine; "Purch. Cr. Memo Line"."No.")
                {
                }
                column(Description_PurchCrMemoLine; "Purch. Cr. Memo Line".Description)
                {
                }
                column(Uom_PurchCrMemoLine; "Purch. Cr. Memo Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchCrMemoLine; "Purch. Cr. Memo Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchCrMemoLine; "Purch. Cr. Memo Line"."Direct Unit Cost")
                {
                }
                column(Amount_PurchCrMemoLine; "Purch. Cr. Memo Line".Amount)
                {
                }
                column(LineAmount; "Purch. Cr. Memo Line"."Line Amount")
                {
                }
                column(HSNSACCode; "Purch. Cr. Memo Line"."HSN/SAC Code")
                {
                }
                column(GSTBaseAmount; Codeunit50200.GetGSTBaseAmtPostedLine("Purch. Cr. Memo Line"."Document No.", "Purch. Cr. Memo Line"."Line No."))
                {
                }
                column(AmountToVendor; Codeunit50200.GetAmttoVendorPostedLine("Purch. Cr. Memo Line"."Document No.", "Purch. Cr. Memo Line"."Line No."))
                {
                }
                column(GSTPercentage; GSTper("Purch. Cr. Memo Line"."Document No.", "Purch. Cr. Memo Line"."Line No."))
                {
                }
                column(LotNo; LotNo)
                {
                }
                column(Mfg; Mfg)
                {
                }
                column(Exp; Exp)
                {
                }
                column(dcNoofLoosPack; dcNoofLoosPack)
                {
                }
                column(LineNumber; "Purch. Cr. Memo Line"."Line No.")
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Item No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Document Type", "Document Line No.");
                    column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
                    {
                    }
                    column(IleQty; ABS("Item Ledger Entry".Quantity))
                    {
                    }
                    column(dcLineAmt; ABS(dcLineAmt))
                    {
                    }
                    column(LineGst; (ABS(dcLineAmt) * (GSTper("Purch. Cr. Memo Line"."Document No.", "Purch. Cr. Memo Line"."Line No."))) / 100)
                    {
                    }
                    column(LineAmtwithGST; ABS(dcLineAmt) + ((ABS(dcLineAmt) * (GSTper("Purch. Cr. Memo Line"."Document No.", "Purch. Cr. Memo Line"."Line No."))) / 100))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        recVLE.RESET;
                        recVLE.SETRANGE("Item Ledger Entry No.", "Entry No.");
                        IF recVLE.FINDFIRST THEN BEGIN
                            dcLineAmt := recVLE."Cost Amount (Actual)";
                        END;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    LotNo := '';
                    Mfg := 0D;
                    Exp := 0D;
                    recILE.RESET;
                    recILE.SETRANGE("Document No.", "Purch. Cr. Memo Line"."Document No.");
                    recILE.SETRANGE("Item No.", "Purch. Cr. Memo Line"."No.");
                    IF recILE.FINDFIRST THEN BEGIN
                        recLotInfo.RESET;
                        recLotInfo.SETRANGE("Item No.", recILE."Item No.");
                        recLotInfo.SETRANGE("Lot No.", recILE."Lot No.");
                        IF recLotInfo.FINDFIRST THEN BEGIN
                            LotNo := recLotInfo."Lot No.";
                            Mfg := recLotInfo."MFG Date";
                            Exp := recLotInfo."Expiration Date";
                        END;
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(txtCompInfo);
                recState.RESET;
                recState.SETRANGE(Code, CompanyInfo."State Code");
                IF recState.FINDFIRST THEN BEGIN
                    txtCmpInfo[1] := recState.Description;
                END;
                recCountry.RESET;
                recCountry.SETRANGE(Code, CompanyInfo."Country/Region Code");
                IF recCountry.FINDFIRST THEN BEGIN
                    txtCmpInfo[2] := recCountry.Name;
                END;



                CLEAR(txtLocAdd);
                recLoc.RESET;
                IF recLoc.GET("Purch. Cr. Memo Hdr."."Location Code") THEN BEGIN
                    txtLocAdd[1] := recLoc."Name 2";
                    txtLocAdd[2] := recLoc.Address;
                    txtLocAdd[3] := recLoc."Address 2";
                    txtLocAdd[4] := recLoc.City;
                    txtLocAdd[5] := recLoc."Post Code";
                    txtLocAdd[6] := recLoc."GST Registration No.";
                    txtLocAdd[7] := recLoc."Phone No.";

                    recState.RESET;
                    recState.SETRANGE(Code, recLoc."State Code");
                    IF recState.FINDFIRST THEN BEGIN
                        txtLocAdd[8] := recState.Description;
                    END;
                    recCountry.RESET;
                    recCountry.SETRANGE(Code, recLoc."Country/Region Code");
                    IF recCountry.FINDFIRST THEN BEGIN
                        txtLocAdd[9] := recCountry.Name;
                    END;
                END;

                CLEAR(txtVenGSTDtl);
                BuyFromStateName := '';
                BuyFrmCountryName := '';
                recVendor.RESET;
                IF recVendor.GET("Purch. Cr. Memo Hdr."."Buy-from Vendor No.") THEN BEGIN
                    recState.RESET;
                    recState.SETRANGE(Code, recVendor."State Code");
                    IF recState.FINDFIRST THEN BEGIN
                        BuyFromStateName := recState.Description;
                    END;
                    recCountry.RESET;
                    recCountry.SETRANGE(Code, recVendor."Country/Region Code");
                    IF recCountry.FINDFIRST THEN BEGIN
                        BuyFrmCountryName := recCountry.Name;
                    END;
                    txtVenGSTDtl[1] := recVendor."GST Registration No.";
                    txtVenGSTDtl[2] := recVendor."P.A.N. No.";

                END;

                txtComment := '';
                recPComLine.SETFILTER("Document Type", '%1', recPComLine."Document Type"::"Posted Credit Memo");
                recPComLine.SETRANGE("No.", "Purch. Cr. Memo Hdr."."No.");
                IF recPComLine.FINDFIRST THEN BEGIN
                    txtComment := recPComLine.Comment;

                END;


                //roundoff
                recPCML.RESET;
                recPCML.SETRANGE("Document No.", "Purch. Cr. Memo Hdr."."No.");
                recPCML.SETRANGE("System-Created Entry", TRUE);
                IF recPCML.FINDFIRST THEN BEGIN
                    decRoundOff := recPCML.Amount;
                END;

                RecCheck.InitTextVariable;
                RecCheck.FormatNoText(Numbertxt, (Codeunit50200.AmttoVendorPurchCrMemoHdr("Purch. Cr. Memo Hdr.") + decRoundOff), "Purch. Cr. Memo Hdr."."Currency Code");
                //RecCheck.FormatNoText(Numbertxt,decTotalAmount,"Sales Invoice Header"."Currency Code");//acxcp //Amount+Roundoff


                // GST Detail Component Wise
                dcCGST := 0;
                dcSGST := 0;
                dcIGST := 0;

                recDGLE.RESET;
                recDGLE.SETRANGE("Document No.", "Purch. Cr. Memo Hdr."."No.");
                recDGLE.SETFILTER(Type, '%1', recDGLE.Type::Item);
                //recDGLE.SETRANGE("No.","Purch. Cr. Memo Line"."No.");
                IF recDGLE.FINDSET THEN
                    REPEAT
                        CASE recDGLE."GST Component Code" OF
                            'CGST':
                                BEGIN
                                    dcCGST += recDGLE."GST Amount";
                                END;
                            'SGST':
                                BEGIN
                                    dcSGST += recDGLE."GST Amount";
                                END;
                            'IGST':
                                BEGIN
                                    dcIGST += recDGLE."GST Amount";
                                END;
                        END;
                    UNTIL recDGLE.NEXT = 0;

                // GST Detail Component Wise
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
        CompanyInfo.GET();
        CompanyInfo.CALCFIELDS(Picture);
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
            SGSTPer := Abs(DetGstLedEntry."GST %");

        DetGstLedEntry.RESET();
        DetGstLedEntry.SETRANGE("Document No.", DocumentNo);
        DetGstLedEntry.SetRange("Document Line No.", DocLineNo);
        DetGstLedEntry.SETRANGE("GST Component Code", 'CGST');
        IF DetGstLedEntry.FINDFIRST THEN
            CGSTPer := Abs(DetGstLedEntry."GST %");

        Clear(TotalGSTPer);
        TotalGSTPer := IGSTPer + SGSTPer + CGSTPer;
        EXIT(ABS(TotalGSTPer));
    end;

    var
        Codeunit50200: Codeunit 50200;
        GLSetup: array[10] of Record 98;
        CompanyInfo: Record 79;
        recLoc: Record 14;
        txtLocAdd: array[15] of Text;
        recState: Record State;
        recCountry: Record 9;
        txtCompInfo: array[10] of Text;
        BuyFromStateName: Text;
        recVendor: Record 23;
        BuyFrmCountryName: Text;
        txtVenGSTDtl: array[10] of Text;
        TxtShipTo: array[10] of Text;
        recILE: Record 32;
        recLotInfo: Record 6505;
        LotNo: Code[30];
        Mfg: Date;
        Exp: Date;
        dcNoofLoosPack: Decimal;
        recPComLine: Record 43;
        txtComment: Text;
        recVLE: Record 5802;
        dcLineAmt: Decimal;
        decRoundOff: Decimal;
        recPCML: Record 125;
        //RecCheck: Report "Posted Voucher";
        RecCheck: Report "Check Report";
        Numbertxt: array[2] of Text;
        txtCmpInfo: array[10] of Text;
        recDGLE: Record "Detailed GST Ledger Entry";
        dcCGST: Decimal;
        dcSGST: Decimal;
        dcIGST: Decimal;
}

