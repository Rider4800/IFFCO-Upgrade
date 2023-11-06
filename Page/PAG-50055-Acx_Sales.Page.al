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
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Source_Code; SourceCode)
                {
                }
                field(Transaction_Type; TrnType)
                {
                }
                field(No_; SIHNo)
                {
                }
                field(Posting_Date; PostDate)
                {
                }
                field(Document_Date; DocDate)
                {
                }
                field(Order_No; OrderNo)
                {
                }
                field(Order_Date; OrderDate)
                {
                }
                field(Due_Date; DueDate)
                {
                }
                field(Sell_to_Customer_No; SellToCustNo)
                {
                }
                field(Sell_to_Customer_Name; SellToCustName)
                {
                }
                field(Sell_to_Address; SellToCustAddr)
                {
                }
                field(Sell_to_Address2; SellToCustAddr2)
                {
                }
                field(Sell_To_City; SellToCity)
                {
                }
                field(Sell_To_State; StateSellToState)
                {
                }
                field(Bill_To_Customer_No; BillToCustNo)
                {
                }
                field(Bill_To_Name; BillToName)
                {
                }
                field(Bill_To_Address; BillToAddr)
                {
                }
                field(Bill_To_Address2; BillToAddr2)
                {
                }
                field(Bill_To_City; BillToCity)
                {
                }
                field(Country; CountryName)
                {
                }
                field(Ship_To_Code; ShipToCode)
                {
                }
                field(Ship_To_Name; ShipToName)
                {
                }
                field(Ship_To_Address; ShipToAddr)
                {
                }
                field(Ship_To_Address2; ShipToAddr2)
                {
                }
                field(Payment_Terms_Code; PmntTermsCode)
                {
                }
                field(Shipment_Method_Code; ShpmntTermsCode)
                {
                }
                field(External_Document_No; ExtDocNo)
                {
                }
                field(Location_Code; LoCode)
                {
                }
                field(Salesperson_Code; SalesPersonCode)
                {
                }
                field(Customer_Posting_Group; CustPostGrp)
                {
                }
                field(Gen_Bus_Posting_Group; GenBusPostGrp)
                {
                }
                field(GblDim1; GblDim1)
                {
                }
                field(GblDim2; GblDim2)
                {
                }
                field(Applies_To_Doc_Type; '')
                {
                }
                field(Applies_To_Doc_No; '')
                {
                }
                field(Item_No; ItemNo)
                {
                }
                field(GL_Description; GLDesc)
                {
                }
                field(Variant_Code; VariantCode)
                {
                }
                field(Description; Desc)
                {
                }
                field(Description2; Desc2)
                {
                }
                field(Unit_Of_Measure; UOM)
                {
                }
                field(Shipment_Date; ShpmntDate)
                {
                }
                field(Quantity; Qty)
                {
                }
                field(Item_Name; ItemName)
                {
                }
                field(Currency; CurrCode)
                {
                }
                field(Unit_Price; UnitPrice)
                {
                }
                field(Line_Amount; LineAmount)
                {
                }
                field(Line_Discount; LineDiscount)
                {
                }
                field(Line_Discount_Amount; LineDiscountAmount)
                {
                }
                field(Amount; Amout)
                {
                }
                field(Inv_Disc_Amount; InvDiscountAmount)
                {
                }
                field(GST_Jurisdiction; GSTJurisdiction)
                {
                }
                field(GST_Place_Of_Supply; GSTPlaceofSupply)
                {
                }
                field(GST_Group_Type; GSTGrpType)
                {
                }
                field(GST_Group_Code; Rec."GST Group Code")
                {
                }
                field(HSN_SAC_Code; HSNSACCode)
                {
                }
                field(GST_Base_Amount; GSTBaseAmt)
                {
                }
                field(CGSTPer; CGSTPer)
                {
                }
                field(CGST_Amount; CGSTAmt)
                {
                }
                field(SGSTPer; SGSTPer)
                {
                }
                field(SGST_Amount; SGSTAmt)
                {
                }
                field(IGSTPer; IGSTPer)
                {
                }
                field(IGST_Amount; IGSTAmt)
                {
                }
                field(Total_GST_Per; TotGSTPer)
                {
                }
                field(Total_GST_Amount; TotGSTAmt)
                {
                }
                field(TCS_Nature_Of_Collection; TCSNatureofCollection)
                {
                }
                field(TDS_TCS_; TDSTCSAmt)
                {
                }
                field(TDS_TCS_Base_Amount; TDSTCSBaseAmount)
                {
                }
                field(TCS_Amount; TCSAmount)
                {
                }
                field(Amount_To_Customer; AmtToCustomer)
                {
                }
                field(Posting_Group; PostingGrp)
                {
                }
                field(Gen_Prod_Posting_Group; GenProdPostGrp)
                {
                }
                field(Line_No; LineNo)
                {
                }
                field(Item_Category_Code; ItemCatCode)
                {
                }
                field(Product_Group_Code; ProductGrpCode)
                {
                }
                field(Cross_Reference_No; CrossRefNo)
                {
                }
                field(Nature_Of_Supply; NatureOfSupply)
                {
                }
                field(GST_Customer_Type; GSTCustomerType)
                {
                }
                field(Location_GST_Reg_No; LocGSTRegNo)
                {
                }
                field(Location_State_Code; LocStateCode)
                {
                }
                field(Customer_GST_Reg_No; CustGSTRegNo)
                {
                }
            }
        }
    }


    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();

        SILRec.Reset();
        SILRec.SetFilter(Quantity, '<>%1', 0);
        SILRec.SetFilter(Type, '%1|%2|%3', SILRec.Type::"Charge (Item)", SILRec.Type::Item, SILRec.Type::"G/L Account");
        SILRec.SetFilter("No.", '<>%1|<>%2|<>%3|<>%4|<>%5|<>%6|<>%7|<>%8|<>%9|<>%10', '424700020', '424700010', '424700090', '424700110', '424700030', '424700100', '424800020', '427000330', '427000210', '424800080');
        if SILRec.FindFirst() then begin
            repeat
                Rec.Init();
                Rec.TransferFields(SILRec);
                Rec.Insert();
                Rec."Assessee Code" := 'SIL';
                Rec.Modify();
            until SILRec.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        ClearVariables();

        if Rec."Assessee Code" = 'SIL' then begin
            if SIHRec.Get(Rec."Document No.") then begin
                SourceCode := SIHRec."Source Code";
                TrnType := 'Invoice';
                SIHNo := SIHRec."No.";
                PostDate := SIHRec."Posting Date";
                DocDate := SIHRec."Document Date";
                OrderNo := SIHRec."Order No.";
                OrderDate := SIHRec."Order Date";
                DueDate := SIHRec."Due Date";
                SellToCustNo := SIHRec."Sell-to Customer No.";
                SellToCustName := SIHRec."Sell-to Customer Name";
                SellToCustAddr := SIHRec."Sell-to Address";
                SellToCustAddr2 := SIHRec."Sell-to Address 2";
                SellToCity := SIHRec."Sell-to City";
                StateSellToState := SIHRec.State;
                BillToCustNo := SIHRec."Bill-to Customer No.";
                BillToName := SIHRec."Bill-to Name";
                BillToAddr := SIHRec."Bill-to Address";
                BillToAddr2 := SIHRec."Bill-to Address 2";
                BillToCity := SIHRec."Bill-to City";
                if CountryRec.Get(SIHRec."Bill-to Country/Region Code") then
                    CountryName := CountryRec.Name;
                ShipToCode := SIHRec."Ship-to Code";
                ShipToName := SIHRec."Ship-to Name";
                ShipToAddr := SIHRec."Ship-to Address";
                ShipToAddr2 := SIHRec."Ship-to Address 2";
                PmntTermsCode := SIHRec."Payment Terms Code";
                ShpmntTermsCode := SIHRec."Shipment Method Code";
                ExtDocNo := SIHRec."External Document No.";
                LoCode := Rec."Location Code";
                SalesPersonCode := SIHRec."Salesperson Code";
                CustPostGrp := SIHRec."Customer Posting Group";
                GenBusPostGrp := Rec."Gen. Bus. Posting Group";
                GblDim1 := Rec."Shortcut Dimension 1 Code";
                GblDim2 := Rec."Shortcut Dimension 2 Code";
                ItemNo := Rec."No.";
                if GLAccRec.Get(Rec."No.") then begin
                    if GLAccRec.Name = '' then
                        GLDesc := 'Sales - Domestic'
                    else
                        GLDesc := GLAccRec.Name;
                end;
                VariantCode := Rec."Variant Code";
                Desc := Rec.Description;
                if ItemRec.Get(Rec."No.") then begin
                    Desc2 := ItemRec."Description 2";
                    ItemName := ItemRec.Description;
                end;
                UOM := Rec."Unit of Measure";
                ShpmntDate := Rec."Shipment Date";
                Qty := Rec.Quantity;
                CurrCode := SIHRec."Currency Code";

                if SIHRec."Currency Factor" = 0 then
                    UnitPrice := Rec."Unit Price"
                else begin
                    if (Rec."Unit Price" <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        UnitPrice := Rec."Unit Price" / SIHRec."Currency Factor";
                end;

                if SIHRec."Currency Factor" = 0 then
                    LineAmount := Rec."Line Amount"
                else begin
                    if (Rec."Line Amount" <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        LineAmount := Rec."Line Amount" / SIHRec."Currency Factor";
                end;

                LineDiscount := Rec."Line Discount %";

                if SIHRec."Currency Factor" = 0 then
                    LineDiscountAmount := Rec."Line Discount Amount"
                else begin
                    if (Rec."Line Discount Amount" <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        LineDiscountAmount := Rec."Line Discount Amount" / SIHRec."Currency Factor";
                end;

                if SIHRec."Currency Factor" = 0 then
                    Amout := Rec.Amount
                else begin
                    if (Rec.Amount <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        Amout := Rec.Amount / SIHRec."Currency Factor";
                end;

                if SIHRec."Currency Factor" = 0 then
                    InvDiscountAmount := Rec."Inv. Discount Amount"
                else begin
                    if (Rec."Inv. Discount Amount" <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        InvDiscountAmount := Rec."Inv. Discount Amount" / SIHRec."Currency Factor";
                end;

                if Rec."GST Jurisdiction Type" = Rec."GST Jurisdiction Type"::Intrastate then
                    GSTJurisdiction := 'Intrastate'
                else
                    GSTJurisdiction := 'Interstate';

                if Rec."GST Place of Supply" = Rec."GST Place of Supply"::"Bill-to Address" then
                    GSTPlaceofSupply := 'Bill-to Address'
                else begin
                    if Rec."GST Place of Supply" = Rec."GST Place of Supply"::"Ship-to Address" then
                        GSTPlaceofSupply := 'Ship-to Address';
                    if Rec."GST Place of Supply" = Rec."GST Place of Supply"::"Bill-to Address" then
                        GSTPlaceofSupply := 'Location Address';
                end;

                if Rec."GST Group Type" = Rec."GST Group Type"::Goods then
                    GSTGrpType := 'Goods'
                else
                    GSTGrpType := 'Service';

                HSNSACCode := Rec."HSN/SAC Code";

                if SIHRec."Currency Factor" = 0 then
                    GSTBaseAmt := Codunit50200.GetGSTBaseAmtPostedLine(Rec."Document No.", Rec."Line No.")
                else begin
                    if ((Codunit50200.GetGSTBaseAmtPostedLine(Rec."Document No.", Rec."Line No.")) <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        GSTBaseAmt := (Codunit50200.GetGSTBaseAmtPostedLine(Rec."Document No.", Rec."Line No.")) / SIHRec."Currency Factor";
                end;

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

                TotGSTPer := Codunit50200.PurchLineGSTPerc(Rec.RECORDID);
                if SIHRec."Currency Factor" = 0 then
                    TotGSTAmt := Codunit50200.GetTotalGSTAmtPostedLine(Rec."Document No.", Rec."Line No.")
                else begin
                    if ((Codunit50200.GetTotalGSTAmtPostedLine(Rec."Document No.", Rec."Line No.")) <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        TotGSTAmt := (Codunit50200.GetTotalGSTAmtPostedLine(Rec."Document No.", Rec."Line No.")) / SIHRec."Currency Factor";
                end;

                TCSNatureofCollection := Rec."TCS Nature of Collection";
                TDSTCSAmt := Codunit50200.TDSTCSAmt(Rec.RecordId);

                if SIHRec."Currency Factor" = 0 then
                    TDSTCSBaseAmount := Codunit50200.GetTCSBaseAmtLine(Rec.RecordId)
                else begin
                    if ((Codunit50200.GetTCSBaseAmtLine(Rec.RecordId)) <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        TDSTCSBaseAmount := (Codunit50200.GetTCSBaseAmtLine(Rec.RecordId)) / SIHRec."Currency Factor";
                end;

                if SIHRec."Currency Factor" = 0 then
                    TCSAmount := Codunit50200.TDSTCSAmt(Rec.RecordId)
                else begin
                    if ((Codunit50200.TDSTCSAmt(Rec.RecordId)) <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        TCSAmount := (Codunit50200.TDSTCSAmt(Rec.RecordId)) / SIHRec."Currency Factor";
                end;

                if SIHRec."Currency Factor" = 0 then
                    AmtToCustomer := Codunit50200.GetAmttoCustomerPostedLine(Rec."Document No.", Rec."Line No.")
                else begin
                    if ((Codunit50200.GetAmttoCustomerPostedLine(Rec."Document No.", Rec."Line No.")) <> 0) AND (SIHRec."Currency Factor" <> 0) then
                        AmtToCustomer := (Codunit50200.GetAmttoCustomerPostedLine(Rec."Document No.", Rec."Line No.")) / SIHRec."Currency Factor";
                end;

                PostingGrp := Rec."Posting Group";
                GenProdPostGrp := Rec."Gen. Prod. Posting Group";
                LineNo := Rec."Line No.";
                if ItemRec.Get(Rec."No.") then begin
                    if ItemCatRec.Get(ItemRec."Item Category Code") then begin
                        ItemCatCode := ItemCatRec."Parent Category";
                        ProductGrpCode := ItemCatRec.Code;
                    end;
                end;
                CrossRefNo := Rec."Item Reference No.";
                if SIHRec."Nature of Supply" = SIHRec."Nature of Supply"::B2B then
                    NatureOfSupply := 'B2B'
                else
                    NatureOfSupply := 'B2C';

                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::" " then
                    GSTCustomerType := '';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Registered then
                    GSTCustomerType := 'Registered';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Unregistered then
                    GSTCustomerType := 'Unregistered';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Export then
                    GSTCustomerType := 'Export';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::"Deemed Export" then
                    GSTCustomerType := 'Deemed Export';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::Exempted then
                    GSTCustomerType := 'Exempted';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::"SEZ Development" then
                    GSTCustomerType := 'SEZ Development';
                if SIHRec."GST Customer Type" = SIHRec."GST Customer Type"::"SEZ Unit" then
                    GSTCustomerType := 'SEZ Unit';

                LocGSTRegNo := SIHRec."Location GST Reg. No.";
                LocStateCode := SIHRec."Location State Code";
                CustGSTRegNo := SIHRec."Customer GST Reg. No.";

                //if LocationRec.Get()
            end;
        end;
    end;

    procedure ClearVariables()
    begin
        Clear(SourceCode);
        Clear(TrnType);
        Clear(SIHNo);
        PostDate := 0D;
        DocDate := 0D;
        Clear(OrderNo);
        OrderDate := 0D;
        DueDate := 0D;
        Clear(SellToCustNo);
        Clear(SellToCustName);
        Clear(SellToCustAddr);
        Clear(SellToCustAddr2);
        Clear(SellToCity);
        Clear(StateSellToState);
        Clear(BillToCustNo);
        Clear(BillToName);
        Clear(BillToAddr);
        Clear(BillToAddr2);
        Clear(BillToCity);
        Clear(CountryName);
        Clear(ShipToCode);
        Clear(ShipToName);
        Clear(ShipToAddr);
        Clear(ShipToAddr2);
        Clear(PmntTermsCode);
        Clear(ShpmntTermsCode);
        Clear(ExtDocNo);
        Clear(LoCode);
        Clear(SalesPersonCode);
        Clear(CustPostGrp);
        Clear(GenBusPostGrp);
        Clear(GblDim1);
        Clear(GblDim2);
        Clear(ItemNo);
        Clear(GLDesc);
        Clear(VariantCode);
        Clear(Desc);
        Clear(Desc2);
        Clear(UOM);
        ShpmntDate := 0D;
        Qty := 0;
        Clear(ItemName);
        Clear(CurrCode);
        UnitPrice := 0;
        LineDiscountAmount := 0;
        LineAmount := 0;
        InvDiscountAmount := 0;
        Amout := 0;
        LineDiscount := 0;
        Clear(GSTJurisdiction);
        Clear(GSTPlaceofSupply);
        Clear(HSNSACCode);
        GSTBaseAmt := 0;
        Clear(GSTGrpType);
        TotGSTPer := 0;
        TotGSTAmt := 0;
        Clear(TCSNatureofCollection);
        TDSTCSAmt := 0;
        TDSTCSBaseAmount := 0;
        TCSAmount := 0;
        AmtToCustomer := 0;
        Clear(PostingGrp);
        Clear(GenProdPostGrp);
        LineNo := 0;
        Clear(ItemCatCode);
        Clear(ProductGrpCode);
        Clear(LocName);
        Clear(LocationStateCode);
    end;

    var
        SILRec: Record "Sales Invoice Line";
        SIHRec: Record "Sales Invoice Header";
        CountryRec: Record "Country/Region";
        GLAccRec: Record "G/L Account";
        Codunit50200: Codeunit 50200;
        ItemRec: Record Item;
        SourceCode: Code[20];
        TrnType: Text[20];
        SIHNo: Code[20];
        PostDate: Date;
        DocDate: Date;
        OrderNo: Code[20];
        OrderDate: Date;
        DueDate: Date;
        SellToCustNo: Code[20];
        SellToCustName: Text[100];
        SellToCustAddr: Text[100];
        SellToCustAddr2: Text[100];
        SellToCity: Text[50];
        StateSellToState: Code[50];
        BillToCustNo: Code[20];
        BillToName: Text[100];
        BillToAddr: Text[100];
        BillToAddr2: Text[100];
        BillToCity: Text[50];
        CountryName: Text[50];
        ShipToCode: Code[20];
        ShipToName: Text[100];
        ShipToAddr: Text[100];
        ShipToAddr2: Text[100];
        PmntTermsCode: Code[20];
        ShpmntTermsCode: Code[20];
        ExtDocNo: Code[20];
        LoCode: Code[20];
        SalesPersonCode: Code[20];
        CustPostGrp: Code[20];
        GenBusPostGrp: Code[20];
        GblDim1: Code[20];
        GblDim2: Code[20];
        ItemNo: Code[20];
        GLDesc: Text[100];
        VariantCode: Code[20];
        Desc: Text[100];
        Desc2: Text[100];
        UOM: Code[20];
        ShpmntDate: Date;
        Qty: Decimal;
        ItemName: Text[100];
        CurrCode: Code[20];
        UnitPrice: Decimal;
        LineAmount: Decimal;
        LineDiscountAmount: Decimal;
        InvDiscountAmount: Decimal;
        Amout: Decimal;
        LineDiscount: Decimal;
        GSTJurisdiction: Text[20];
        GSTPlaceofSupply: Code[20];
        HSNSACCode: Code[20];
        GSTBaseAmt: Decimal;
        GSTGrpType: Text[20];
        DetailedGSTLedgEntryRec: Record "Detailed GST Ledger Entry";
        CGSTPer: Decimal;
        CGSTAmt: Decimal;
        SGSTPer: Decimal;
        SGSTAmt: Decimal;
        IGSTPer: Decimal;
        IGSTAmt: Decimal;
        TotGSTPer: Decimal;
        TotGSTAmt: Decimal;
        TCSNatureofCollection: Code[10];
        TDSTCSAmt: Decimal;
        TDSTCSBaseAmount: Decimal;
        TCSAmount: Decimal;
        AmtToCustomer: Decimal;
        PostingGrp: Code[20];
        GenProdPostGrp: Code[20];
        LineNo: Integer;
        ItemCatCode: Code[20];
        ProductGrpCode: Code[20];
        CrossRefNo: Code[20];
        NatureOfSupply: Code[20];
        GSTCustomerType: Code[20];
        LocGSTRegNo: Code[20];
        LocStateCode: Code[20];
        CustGSTRegNo: Code[20];
        ItemCatRec: Record "Item Category";
        LocationRec: Record Location;
        LocName: Text[100];
        LocationStateCode: Code[20];
}