page 50055 Acx_Sales
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Acx_Sales';
    DelayedInsert = true;
    EntityName = 'Acx_Sales';
    EntitySetName = 'Acx_Sales';
    PageType = API;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(DocType; Doctype)
                {
                }
                field(Day; DayVar)
                {
                }
                field(Month; MonthName)
                {
                }
                field(Year; Year)
                {
                }
                field(Location_Code; Rec."Location Code")
                {
                }
                field(Posting_Date; PostDate)
                {
                }
                field(Document_No; Rec."Document No.")
                {
                }
                field(Vendor_Invoice_No; VendInvNo)
                {
                }
                field(Vendor_Invoice_Date; VendInvDate)
                {
                }
                field(Vendor_No; Rec."Buy-from Vendor No.")
                {
                }
                field(Vendor_Name; VendName)
                {
                }
                field(Line_Type; LineType)
                {
                }
                field(Line_Description; Rec.Description)
                {
                }
                field(Quantity; QtyVar)
                {
                }
                field(UoM; Rec."Unit of Measure Code")
                {
                }
                field(Variant_Code; Rec."Variant Code")
                {
                }
                field(Unit_Price; UnitPrice)
                {
                }
                field(Basic_Amount; BasicAmout)
                {
                }
                field(Line_Discount_Amount; LineDiscountAmount)
                {
                }
                field(Inv_Discount_Amount; InvDiscountAmount)
                {
                }
                field(Line_Amount; LineAmount)
                {
                }
                field(GST_Jurisdiction; GSTJurisdiction)
                {
                }
                field(GST_Credit; GSTCredit)
                {
                }
                field(GST_Group_Code; Rec."GST Group Code")
                {
                }
                // field(GST_Base_Amount; Rec."GST Base Amount")        //field not found
                // {
                // }
                field(GST_Group_Type; GSTGrpType)
                {
                }
                field(HSN_SACCode; Rec."HSN/SAC Code")
                {
                }
                field(Custom_Duty_Amount; Rec."Custom Duty Amount")
                {
                }
                field(GST_Reverse_Charge; GSTReverseCharge)
                {
                }
                field(GST_Assessable_Value; Rec."GST Assessable Value")
                {
                }
                field(GST_Vendor_Type; GSTVendType)
                {
                }
                field(CGSTPercentage; CGSTPer)
                {
                }
                field(CGST_Amount; CGSTAmt)
                {
                }
                field(SGSTPercentage; SGSTPer)
                {
                }
                field(SGST_Amount; SGSTAmt)
                {
                }
                field(IGSTPercentage; IGSTPer)
                {
                }
                field(IGST_Amount; IGSTAmt)
                {
                }
                // field(GST;Rec.GST)                                                       //field not found
                // {
                // }
                field(Total_GST_Amount; TotGSTAmt)
                {
                }
                field(T_A_N_No; TANNo)
                {
                }
                // field(TDS_Nature_of_Deduction; Rec."TDS Nature of Deduction")            //field not found
                // {
                // }
                // field(TDS_Base_Amount; Rec."TDS Base Amount")                            //field not found
                // {
                // }
                // field(TDS; Rec.TDS)                                                      //field not found
                // {
                // }
                // field(TDS_Amount; Rec."TDS Amount")                                      //field not found
                // {
                // }
                field(Freight_OtherCharges; FreightOtherCharges)
                {
                }
                field(Item_Category; ItemCategory)
                {
                }
                field(Product_Type; ProductGroup)
                {
                }
                field(Item_Group; GenProdPostGrpName)
                {
                }
                field(Destination; Destnation)
                {
                }
                field(Vendor_City; VendorCity)
                {
                }
                field(Vendor_State; VendorState)
                {
                }
                field(Vendor_Country; VendorCountry)
                {
                }
                field(Purchaser; SalesPersonPurchaser)
                {
                }
                field("Vendor_GST_Registration_No"; VendGSTRegNo)
                {
                }
                field(Business_Posting_Group; GenBusPostGrpName)
                {
                }
                field(Vendor_Posting_Group; VendPostGrp)
                {
                }
                field(Vendor_PAN_No; VendPANNo)
                {
                }
                field(Location_Address; LocAddress)
                {
                }
                field(Location_City; LocCity)
                {
                }
                field(Location_State; LocState)
                {
                }
                field(Transporter; TransporterBool)
                {
                }
                field(Receipt_No; RcptNo)
                {
                }
                field(Order_No; OrderNo)
                {
                }
                field(Bill_Of_Entry_No; BillOfEntryNo)
                {
                }
                field(Bill_Of_Entry_Date; BillOfEntryDate)
                {
                }
                field(Bill_Of_Entry_Value; BillOfEntryValue)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();

        PurchInvoiceHeaderRec1.Reset();
        if PurchInvoiceHeaderRec1.FindFirst() then begin
            repeat
                PurchInvoiceLineRec.Reset();
                PurchInvoiceLineRec.SetRange("Document No.", PurchInvoiceHeaderRec1."No.");
                PurchInvoiceLineRec.SetFilter(Quantity, '<>%1', 0);
                if PurchInvoiceLineRec.FindFirst() then begin
                    repeat
                        Rec.Init();
                        Rec.TransferFields(PurchInvoiceLineRec);
                        Rec.Insert();
                    until PurchInvoiceLineRec.Next() = 0;
                end;
            until PurchInvoiceHeaderRec1.Next() = 0;
        end;

        PurchCrMemoHeaderRec1.Reset();
        if PurchCrMemoHeaderRec1.FindFirst() then begin
            repeat
                PurchCrMemoLineRec.Reset();
                PurchCrMemoLineRec.SetRange("Document No.", PurchCrMemoHeaderRec1."No.");
                PurchCrMemoLineRec.SetFilter(Quantity, '<>%1', 0);
                if PurchCrMemoLineRec.FindFirst() then begin
                    repeat
                        Rec.Init();
                        Rec.TransferFields(PurchCrMemoLineRec);
                        Rec.Insert();
                        Rec."Subcon. Order No." := PurchCrMemoLineRec."Return Shipment No.";
                        Rec.Modify();
                    until PurchCrMemoLineRec.Next() = 0;
                end;
            until PurchCrMemoHeaderRec1.Next() = 0;
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        ClearVariables();
        CreatePurchaseDocumentTypeLines();
        CreatePurchaseReturnDocumentTypeLines();
    end;

    procedure ClearVariables()
    begin
        Clear(DocType);
        Clear(GenBusPostGrpName);
        Clear(MonthName);
        Year := 0;
        DayVar := 0;
        Clear(TerritoryDimensionCode);
        PointVar := 0;
        QtyVar := 0;
        PostDate := 0D;
        Clear(VendInvNo);
        VendInvDate := 0D;
        Clear(VendName);
        Clear(LineType);
        UnitPrice := 0;
        BasicAmout := 0;
        LineDiscountAmount := 0;
        InvDiscountAmount := 0;
        LineAmount := 0;
        Clear(GSTJurisdiction);
        Clear(GSTCredit);
        Clear(GSTGrpType);
        Clear(GSTReverseCharge);
        Clear(GSTVendType);
        CGSTPer := 0;
        CGSTAmt := 0;
        SGSTPer := 0;
        SGSTAmt := 0;
        IGSTPer := 0;
        IGSTAmt := 0;
        TotGSTAmt := 0;
        Clear(TANNo);
        FreightOtherCharges := 0;
        TotalAmount := 0;
        Clear(ItemCategory);
        Clear(ProductGroup);
        Clear(ItemCatCode);
        Clear(ProdGrpCode);
        Clear(VendorCity);
        Clear(VendorState);
        Clear(VendorCountry);
        Clear(SalesPersonPurchaser);
        Clear(VendGSTRegNo);
        Clear(VendPostGrp);
        Clear(VendPANNo);
        Clear(LocGSTRegNo);
        Clear(LocAddress);
        Clear(LocCity);
        Clear(LocState);
        Clear(TransporterBool);
        Clear(OrderNo);
        Clear(BillOfEntryNo);
        BillOfEntryValue := 0;
        Clear(RcptNo);
    end;

    procedure CreatePurchaseDocumentTypeLines()
    begin
        if PurchInvoiceHeaderRec.Get(Rec."Document No.") then begin
            DocType := 'Purchase';
            RcptNo := Rec."Receipt No.";

            if PurchRcptHdrRec.Get(Rec."Receipt No.") then
                OrderNo := PurchRcptHdrRec."Order No.";

            if LocRec.Get(PurchInvoiceHeaderRec."Location Code") then begin
                TANNo := LocRec."T.A.N. No.";
                LocAddress := LocRec.Address + ' ' + LocRec."Address 2";
                LocCity := LocRec.City;
                if StateRec.Get(LocRec."State Code") then
                    LocState := StateRec.Description;
            end;

            if PurchInvoiceHeaderRec."Currency Factor" = 0 then
                UnitPrice := Rec."Direct Unit Cost"
            else begin
                if (Rec."Direct Unit Cost" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    UnitPrice := Rec."Direct Unit Cost" / PurchInvoiceHeaderRec."Currency Factor";
            end;

            if PurchInvoiceHeaderRec."Currency Factor" = 0 then
                BasicAmout := Rec.Amount
            else begin
                if (Rec.Amount <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    BasicAmout := Rec.Amount / PurchInvoiceHeaderRec."Currency Factor";
            end;

            if PurchInvoiceHeaderRec."Currency Factor" = 0 then
                LineDiscountAmount := Rec."Line Discount Amount"
            else begin
                if (Rec."Line Discount Amount" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    LineDiscountAmount := Rec."Line Discount Amount" / PurchInvoiceHeaderRec."Currency Factor";
            end;

            if PurchInvoiceHeaderRec."Currency Factor" = 0 then
                InvDiscountAmount := Rec."Inv. Discount Amount"
            else begin
                if (Rec."Inv. Discount Amount" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    InvDiscountAmount := Rec."Inv. Discount Amount" / PurchInvoiceHeaderRec."Currency Factor";
            end;

            if PurchInvoiceHeaderRec."Currency Factor" = 0 then
                LineAmount := Rec."Line Amount"
            else begin
                if (Rec."Line Amount" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    LineAmount := Rec."Line Amount" / PurchInvoiceHeaderRec."Currency Factor";
            end;

            if Rec."GST Jurisdiction Type" = Rec."GST Jurisdiction Type"::Intrastate then
                GSTJurisdiction := 'Intrastate'
            else
                GSTJurisdiction := 'Interstate';

            if Rec."GST Credit" = Rec."GST Credit"::" " then
                GSTCredit := 'Availment'
            else
                GSTCredit := 'Non-Availment';

            if Rec."GST Group Type" = Rec."GST Group Type"::Goods then
                GSTGrpType := 'Goods'
            else
                GSTGrpType := 'Service';

            if NOT Rec."GST Reverse Charge" then
                GSTReverseCharge := 'FALSE'
            else
                GSTReverseCharge := 'TRUE';

            // if PurchInvoiceHeaderRec."Currency Factor" = 0 then                      field not found
            //     TotGSTAmt := Rec."Total GST Amount"
            // else begin
            //     if (Rec."Total GST Amount" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
            //         TotGSTAmt := Rec."Total GST Amount" / PurchInvoiceHeaderRec."Currency Factor";
            // end;                                     

            DetailedGSTLedgEntryRec.Reset();
            DetailedGSTLedgEntryRec.SetRange("Document No.", Rec."Document No.");
            DetailedGSTLedgEntryRec.SetRange("Document Line No.", Rec."Line No.");
            DetailedGSTLedgEntryRec.SetRange("GST Component Code", 'CGST');
            if DetailedGSTLedgEntryRec.FindFirst() then begin
                CGSTPer := DetailedGSTLedgEntryRec."GST %";
                CGSTAmt := DetailedGSTLedgEntryRec."GST Amount";
            end;
            DetailedGSTLedgEntryRec.Reset();
            DetailedGSTLedgEntryRec.SetRange("Document No.", Rec."Document No.");
            DetailedGSTLedgEntryRec.SetRange("Document Line No.", Rec."Line No.");
            DetailedGSTLedgEntryRec.SetRange("GST Component Code", 'SGST');
            if DetailedGSTLedgEntryRec.FindFirst() then begin
                SGSTPer := DetailedGSTLedgEntryRec."GST %";
                SGSTAmt := DetailedGSTLedgEntryRec."GST Amount";
            end;
            DetailedGSTLedgEntryRec.Reset();
            DetailedGSTLedgEntryRec.SetRange("Document No.", Rec."Document No.");
            DetailedGSTLedgEntryRec.SetRange("Document Line No.", Rec."Line No.");
            DetailedGSTLedgEntryRec.SetRange("GST Component Code", 'IGST');
            if DetailedGSTLedgEntryRec.FindFirst() then begin
                IGSTPer := DetailedGSTLedgEntryRec."GST %";
                IGSTAmt := DetailedGSTLedgEntryRec."GST Amount";
            end;

            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::" " then
                GSTVendType := '';
            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::Registered then
                GSTVendType := 'Registered';
            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::Composite then
                GSTVendType := 'Composite';
            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::Unregistered then
                GSTVendType := 'Unregistered';
            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::Import then
                GSTVendType := 'Import';
            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::Exempted then
                GSTVendType := 'Exempted';
            if PurchInvoiceHeaderRec."GST Vendor Type" = PurchInvoiceHeaderRec."GST Vendor Type"::SEZ then
                GSTVendType := 'SEZ';

            if Rec.Type = Rec.Type::"G/L Account" then
                LineType := 'G/L Account';
            if Rec.Type = Rec.Type::Item then
                LineType := 'Item';
            if Rec.Type = Rec.Type::Resource then
                LineType := 'Resource';
            if Rec.Type = Rec.Type::"Fixed Asset" then
                LineType := 'Fixed Asset';
            if Rec.Type = Rec.Type::"Charge (Item)" then
                LineType := 'Charge (Item)';

            //->Commented as "Charges to vendor" not found in Purchase invoice Line table"
            /*
            if PurchInvoiceHeaderRec."Currency Factor" = 0 then begin
                FreightOtherCharges := Rec."Charges to Vendor";
                TotalAmount := Rec."Amount to Vendor";
            end else begin
                if (Rec."Charges to Vendor" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    FreightOtherCharges := Rec."Charges to Vendor" / PurchInvoiceHeaderRec."Currency Factor";
                if (Rec."Amount to Vendor" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
                    TotalAmount := Rec."Amount to Vendor" / PurchInvoiceHeaderRec."Currency Factor";
            end;
            */

            if ItemRec.Get(Rec."No.") then begin
                if ItemCatRec.Get(ItemRec."Item Category Code") then begin
                    ItemCatCode := ItemCatRec."Parent Category";
                    ProdGrpCode := ItemCatRec.Code;
                    if ItemCatRec1.GET(ItemCatCode) then
                        ItemCategory := ItemCatRec1.Description;
                    if ItemCatRec1.GET(ProdGrpCode) then
                        ProductGroup := ItemCatRec1.Description;
                end;
                if GenProdPostGrpRec.Get(ItemRec."Gen. Prod. Posting Group") then
                    GenProdPostGrpName := GenProdPostGrpRec.Description;
            end;

            if SPRec.Get(PurchInvoiceHeaderRec."Purchaser Code") then
                SalesPersonPurchaser := SPRec.Name;
            Destnation := PurchInvoiceHeaderRec."Buy-from Address" + ' ' + PurchInvoiceHeaderRec."Buy-from Address 2" + ' ' + PurchInvoiceHeaderRec."Buy-from City";
            LocGSTRegNo := PurchInvoiceHeaderRec."Location GST Reg. No.";
            BillOfEntryNo := PurchInvoiceHeaderRec."Bill of Entry No.";
            BillOfEntryDate := PurchInvoiceHeaderRec."Bill of Entry Date";
            BillOfEntryValue := PurchInvoiceHeaderRec."Bill of Entry Value";

            if (Rec.Type = Rec.Type::Item) OR (Rec.Type = Rec.Type::"Fixed Asset") OR (Rec.Type = Rec.Type::"Charge (Item)") then
                QtyVar := Rec.Quantity
            else
                QtyVar := 0;
            DayVar := DATE2DMY(PurchInvoiceHeaderRec."Posting Date", 1);
            MonthName := FORMAT(PurchInvoiceHeaderRec."Posting Date", 0, '<Month Text>');
            Year := DATE2DMY(PurchInvoiceHeaderRec."Posting Date", 3);
            PostDate := PurchInvoiceHeaderRec."Posting Date";
            VendInvNo := PurchInvoiceHeaderRec."Vendor Invoice No.";
            VendInvDate := PurchInvoiceHeaderRec."Document Date";
            if VendRec.Get(PurchInvoiceHeaderRec."Buy-from Vendor No.") then begin
                VendName := VendRec.Name;
                VendorCity := VendRec.City;
                VendGSTRegNo := VendRec."GST Registration No.";
                VendPostGrp := VendRec."Vendor Posting Group";
                VendPANNo := VendRec."P.A.N. No.";
                if NOT VendRec.Transporter then
                    TransporterBool := 'FALSE'
                else
                    TransporterBool := 'TRUE';
                if StateRec.Get(VendRec."State Code") then
                    VendorState := StateRec.Description;
                if Country.Get(VendRec."Country/Region Code") then
                    VendorCountry := Country.Name;
            end;
        end;
    end;

    procedure CreatePurchaseReturnDocumentTypeLines()
    begin
        if PurchCrMemoHeaderRec.Get(Rec."Document No.") then begin
            DocType := 'Purchase Return';
            RcptNo := Rec."Subcon. Order No.";

            if RetShpmntHdr.Get(Rec."Receipt No.") then
                OrderNo := RetShpmntHdr."Return Order No.";    //Check

            if LocRec.Get(PurchCrMemoHeaderRec."Location Code") then begin
                TANNo := LocRec."T.A.N. No.";
                LocAddress := LocRec.Address + ' ' + LocRec."Address 2";
                LocCity := LocRec.City;
                if StateRec.Get(LocRec."State Code") then
                    LocState := StateRec.Description;
            end;

            if PurchCrMemoHeaderRec."Currency Factor" = 0 then
                UnitPrice := Rec."Direct Unit Cost"
            else begin
                if (Rec."Direct Unit Cost" <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    UnitPrice := Rec."Direct Unit Cost" / PurchCrMemoHeaderRec."Currency Factor";
            end;

            if PurchCrMemoHeaderRec."Currency Factor" = 0 then
                BasicAmout := -Rec.Amount
            else begin
                if (Rec.Amount <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    BasicAmout := -Rec.Amount / PurchCrMemoHeaderRec."Currency Factor";
            end;

            if PurchCrMemoHeaderRec."Currency Factor" = 0 then
                LineDiscountAmount := -Rec."Line Discount Amount"
            else begin
                if (Rec."Line Discount Amount" <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    LineDiscountAmount := -Rec."Line Discount Amount" / PurchCrMemoHeaderRec."Currency Factor";
            end;

            if PurchCrMemoHeaderRec."Currency Factor" = 0 then
                InvDiscountAmount := -Rec."Inv. Discount Amount"
            else begin
                if (Rec."Inv. Discount Amount" <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    InvDiscountAmount := -Rec."Inv. Discount Amount" / PurchCrMemoHeaderRec."Currency Factor";
            end;

            if PurchCrMemoHeaderRec."Currency Factor" = 0 then
                LineAmount := -Rec."Line Amount"
            else begin
                if (Rec."Line Amount" <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    LineAmount := -Rec."Line Amount" / PurchCrMemoHeaderRec."Currency Factor";
            end;

            if Rec."GST Jurisdiction Type" = Rec."GST Jurisdiction Type"::Intrastate then
                GSTJurisdiction := 'Intrastate'
            else
                GSTJurisdiction := 'Interstate';

            if Rec."GST Credit" = Rec."GST Credit"::" " then
                GSTCredit := 'Availment'
            else
                GSTCredit := 'Non-Availment';

            if Rec."GST Group Type" = Rec."GST Group Type"::Goods then
                GSTGrpType := 'Goods'
            else
                GSTGrpType := 'Service';

            if NOT Rec."GST Reverse Charge" then
                GSTReverseCharge := 'FALSE'
            else
                GSTReverseCharge := 'TRUE';

            // if PurchInvoiceHeaderRec."Currency Factor" = 0 then                      field not found
            //     TotGSTAmt := Rec."Total GST Amount"
            // else begin
            //     if (Rec."Total GST Amount" <> 0) AND (PurchInvoiceHeaderRec."Currency Factor" <> 0) then
            //         TotGSTAmt := Rec."Total GST Amount" / PurchInvoiceHeaderRec."Currency Factor";
            // end;                                     

            DetailedGSTLedgEntryRec.Reset();
            DetailedGSTLedgEntryRec.SetRange("Document No.", Rec."Document No.");
            DetailedGSTLedgEntryRec.SetRange("Document Line No.", Rec."Line No.");
            DetailedGSTLedgEntryRec.SetRange("GST Component Code", 'CGST');
            if DetailedGSTLedgEntryRec.FindFirst() then begin
                CGSTPer := DetailedGSTLedgEntryRec."GST %";
                CGSTAmt := DetailedGSTLedgEntryRec."GST Amount";
            end;
            DetailedGSTLedgEntryRec.Reset();
            DetailedGSTLedgEntryRec.SetRange("Document No.", Rec."Document No.");
            DetailedGSTLedgEntryRec.SetRange("Document Line No.", Rec."Line No.");
            DetailedGSTLedgEntryRec.SetRange("GST Component Code", 'SGST');
            if DetailedGSTLedgEntryRec.FindFirst() then begin
                SGSTPer := DetailedGSTLedgEntryRec."GST %";
                SGSTAmt := DetailedGSTLedgEntryRec."GST Amount";
            end;
            DetailedGSTLedgEntryRec.Reset();
            DetailedGSTLedgEntryRec.SetRange("Document No.", Rec."Document No.");
            DetailedGSTLedgEntryRec.SetRange("Document Line No.", Rec."Line No.");
            DetailedGSTLedgEntryRec.SetRange("GST Component Code", 'IGST');
            if DetailedGSTLedgEntryRec.FindFirst() then begin
                IGSTPer := DetailedGSTLedgEntryRec."GST %";
                IGSTAmt := DetailedGSTLedgEntryRec."GST Amount";
            end;

            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::" " then
                GSTVendType := '';
            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::Registered then
                GSTVendType := 'Registered';
            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::Composite then
                GSTVendType := 'Composite';
            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::Unregistered then
                GSTVendType := 'Unregistered';
            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::Import then
                GSTVendType := 'Import';
            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::Exempted then
                GSTVendType := 'Exempted';
            if PurchCrMemoHeaderRec."GST Vendor Type" = PurchCrMemoHeaderRec."GST Vendor Type"::SEZ then
                GSTVendType := 'SEZ';

            if Rec.Type = Rec.Type::"G/L Account" then
                LineType := 'G/L Account';
            if Rec.Type = Rec.Type::Item then
                LineType := 'Item';
            if Rec.Type = Rec.Type::Resource then
                LineType := 'Resource';
            if Rec.Type = Rec.Type::"Fixed Asset" then
                LineType := 'Fixed Asset';
            if Rec.Type = Rec.Type::"Charge (Item)" then
                LineType := 'Charge (Item)';

            //->Commented as "Charges to vendor" not found in Purchase invoice Line table"
            /*
            if PurchCrMemoHeaderRec."Currency Factor" = 0 then begin
                FreightOtherCharges := Rec."Charges to Vendor";
                TotalAmount := Rec."Amount to Vendor";
            end else begin
                if (Rec."Charges to Vendor" <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    FreightOtherCharges := Rec."Charges to Vendor" / PurchCrMemoHeaderRec."Currency Factor";
                if (Rec."Amount to Vendor" <> 0) AND (PurchCrMemoHeaderRec."Currency Factor" <> 0) then
                    TotalAmount := Rec."Amount to Vendor" / PurchCrMemoHeaderRec."Currency Factor";
            end;
            */

            if ItemRec.Get(Rec."No.") then begin
                if ItemCatRec.Get(ItemRec."Item Category Code") then begin
                    ItemCatCode := ItemCatRec."Parent Category";
                    ProdGrpCode := ItemCatRec.Code;
                    if ItemCatRec1.GET(ItemCatCode) then
                        ItemCategory := ItemCatRec1.Description;
                    if ItemCatRec1.GET(ProdGrpCode) then
                        ProductGroup := ItemCatRec1.Description;
                end;
                if GenProdPostGrpRec.Get(ItemRec."Gen. Prod. Posting Group") then
                    GenProdPostGrpName := GenProdPostGrpRec.Description;
            end;

            if SPRec.Get(PurchCrMemoHeaderRec."Purchaser Code") then
                SalesPersonPurchaser := SPRec.Name;
            Destnation := PurchCrMemoHeaderRec."Buy-from Address" + ' ' + PurchCrMemoHeaderRec."Buy-from Address 2" + ' ' + PurchCrMemoHeaderRec."Buy-from City";
            LocGSTRegNo := PurchCrMemoHeaderRec."Location GST Reg. No.";
            BillOfEntryNo := PurchCrMemoHeaderRec."Bill of Entry No.";
            BillOfEntryDate := PurchCrMemoHeaderRec."Bill of Entry Date";
            BillOfEntryValue := PurchCrMemoHeaderRec."Bill of Entry Value";

            if (Rec.Type = Rec.Type::Item) OR (Rec.Type = Rec.Type::"Fixed Asset") OR (Rec.Type = Rec.Type::"Charge (Item)") then
                QtyVar := -Rec.Quantity
            else
                QtyVar := 0;
            DayVar := DATE2DMY(PurchCrMemoHeaderRec."Posting Date", 1);
            MonthName := FORMAT(PurchCrMemoHeaderRec."Posting Date", 0, '<Month Text>');
            Year := DATE2DMY(PurchCrMemoHeaderRec."Posting Date", 3);
            PostDate := PurchCrMemoHeaderRec."Posting Date";
            VendInvNo := PurchCrMemoHeaderRec."Vendor Cr. Memo No.";
            VendInvDate := PurchCrMemoHeaderRec."Document Date";
            if VendRec.Get(PurchCrMemoHeaderRec."Buy-from Vendor No.") then begin
                VendName := VendRec.Name;
                VendorCity := VendRec.City;
                VendGSTRegNo := VendRec."GST Registration No.";
                VendPostGrp := VendRec."Vendor Posting Group";
                VendPANNo := VendRec."P.A.N. No.";
                if NOT VendRec.Transporter then
                    TransporterBool := 'FALSE'
                else
                    TransporterBool := 'TRUE';
                if StateRec.Get(VendRec."State Code") then
                    VendorState := StateRec.Description;
                if Country.Get(VendRec."Country/Region Code") then
                    VendorCountry := Country.Name;
            end;
        end;
    end;

    var
        PurchInvoiceHeaderRec1: Record "Purch. Inv. Header";
        PurchInvoiceHeaderRec: Record "Purch. Inv. Header";
        PurchInvoiceLineRec: Record "Purch. Inv. Line";
        PurchCrMemoHeaderRec: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoHeaderRec1: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLineRec: Record "Purch. Cr. Memo Line";
        DocType: Text[50];
        CustomerRec: Record Customer;
        GenBusPostGrpName: Text[50];
        GenProdPostGrpName: Text[50];
        GenBusPostGrpRec: Record "Gen. Business Posting Group";
        CustomerNo: Code[20];
        MonthName: Text[20];
        Year: Integer;
        DayVar: Integer;
        PostDate: Date;
        TerritoryDimensionCode: Code[20];
        PointVar: Decimal;
        QtyVar: Decimal;
        VendInvNo: Code[20];
        VendInvDate: Date;
        VendRec: Record Vendor;
        VendName: Text[100];
        LineType: Text[30];
        UnitPrice: Decimal;
        BasicAmout: Decimal;
        LineDiscountAmount: Decimal;
        InvDiscountAmount: Decimal;
        LineAmount: Decimal;
        GSTJurisdiction: Text[20];
        GSTCredit: Text[30];
        GSTGrpType: Text[20];
        GSTReverseCharge: Text[10];
        GSTVendType: Text[20];
        CGSTPer: Decimal;
        CGSTAmt: Decimal;
        SGSTPer: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        IGSTAmt: Decimal;
        DetailedGSTLedgEntryRec: Record "Detailed GST Ledger Entry";
        TotGSTAmt: Decimal;
        LocRec: Record Location;
        TANNo: Code[20];
        FreightOtherCharges: Decimal;
        TotalAmount: Decimal;
        ItemCatRec: Record "Item Category";
        ItemCatRec1: Record "Item Category";
        ItemCategory: Text[100];
        ProductGroup: Text[100];
        ItemRec: Record Item;
        ItemCatCode: Code[20];
        ProdGrpCode: Code[20];
        Destnation: Text[200];
        VendorCity: Text[30];
        StateRec: Record State;
        VendorState: Text[50];
        Country: Record "Country/Region";
        VendorCountry: Text[50];
        SPRec: Record "Salesperson/Purchaser";
        SalesPersonPurchaser: Text[50];
        VendGSTRegNo: Code[20];
        GenProdPostGrpRec: Record "Gen. Product Posting Group";
        VendPostGrp: Code[20];
        VendPANNo: Code[20];
        LocGSTRegNo: Code[20];
        LocAddress: Text[150];
        LocCity: Text[30];
        LocState: Text[50];
        TransporterBool: Text[10];
        PurchRcptHdrRec: Record "Purch. Rcpt. Header";
        OrderNo: Code[20];
        BillOfEntryNo: Text[20];
        BillOfEntryDate: Date;
        BillOfEntryValue: Decimal;
        RcptNo: Code[20];
        RetShpmntHdr: Record "Return Shipment Header";
}