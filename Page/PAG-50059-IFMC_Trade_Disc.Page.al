page 50059 IFMC_Trade_Disc
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'IFMC_Trade_Disc';
    DelayedInsert = true;
    EntityName = 'IFMC_Trade_Disc';
    EntitySetName = 'IFMC_Trade_Disc';
    PageType = API;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Transaction_Type; TrnType)
                {
                }
                field(G_L_Description; GLDesc)
                {
                }
                field(Line_No; LineNo)
                {
                }
                field(Document_No; DocNo)
                {
                }
                field(Order_No; OrderNo)
                {
                }
                field(Order_Date; OrderDate)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        GLAccRec: Record "G/L Account";
    begin
        Clear(Rec);
        Rec.DeleteAll();

        GLRec.Reset();
        GLRec.SetRange("G/L Account No.", '424700080');
        if GLRec.FindFirst() then begin
            repeat
                SCrMLRec.Reset();
                SCrMLRec.SetRange("Document No.", GLRec."Document No.");
                SCrMLRec.Setfilter("Line Discount %", '<>%1', 0);
                if SCrMLRec.FindFirst() then begin
                    GLAccRec.Get(GLRec."G/L Account No.");
                    SCrMHRec.Get(GLRec."Document No.");
                    LocationRec.Get(GLRec."Location Code");
                    ItemRec.Get(SCrMLRec."No.");
                    DGSTLedEntryRec.reset();
                    DGSTLedEntryRec.setrange("Document No.", SCrMLRec."Document No.");
                    DGSTLedEntryRec.setrange("Document Line No.", SCrMLRec."Line No.");
                    DGSTLedEntryRec.setrange("GST Component Code", 'IGST');
                    if DGSTLedEntryRec.FindFirst() then;
                    Rec.Reset();
                    Rec.SetRange("G/L Account Name", GLAccRec.Name);
                    Rec.Setrange("G/L Account No.", GLRec."G/L Account No.");
                    Rec.Setrange("Dimension Changes Count", SCrMLRec."Line No.");
                    Rec.Setrange("Document No.", GLRec."Document No.");
                    Rec.Setrange("Posting Date", GLRec."Posting Date");
                    Rec.Setrange("External Document No.", GLRec."External Document No.");
                    Rec.Setrange("Source No.", GLRec."Source No.");
                    Rec.Setrange("Location Code", GLRec."Location Code");
                    Rec.Setrange(Comment, LocationRec.Name);
                    Rec.SetRange("Reason Code", LocationRec."State Code");
                    Rec.SetRange("IC Partner Code", SCrMLRec."Item Category Code");
                    Rec.SetRange("Gen. Prod. Posting Group", SCrMLRec."Gen. Prod. Posting Group");
                    Rec.Setrange("VAT Prod. Posting Group", SCrMLRec."Posting Group");
                    Rec.Setrange("VAT Bus. Posting Group", ItemRec."Item Category Code");       //ProductGroupCode
                    Rec.SetRange("Document Type", GLRec."Document Type");
                    Rec.SetRange("Prod. Order No.", SCrMLRec."No.");
                    Rec.SetRange(Description, SCrMHRec."Sell-to Customer Name");
                    Rec.SetRange("Tax Group Code", SCrMHRec."Customer Posting Group");
                    Rec.SetRange(Amount, SCrMLRec.Amount);
                    Rec.SetRange("VAT Amount", SCrMLRec."Line Discount %");
                    Rec.SetRange("Non-Deductible VAT Amount", SCrMLRec."Inv. Discount Amount");
                    Rec.Setrange("Non-Deductible VAT Amount ACY", SCrMLRec."Line Discount Amount");
                    Rec.SetRange("Business Unit Code", SCrMLRec.Description);
                    Rec.SetRange(Quantity, SCrMLRec."Unit Cost");
                    Rec.SetRange("Source Branch", SCrMHRec."Payment Terms Code");
                    Rec.SetRange("Gen. Posting Type", SCrMLRec."GST Group Type");
                    Rec.setrange("Bal. Account Type", SCrMLRec."GST Jurisdiction Type");
                    Rec.SetRange("Source Type", SCrMHRec."GST Customer Type");
                    Rec.SetRange("Additional-Currency Amount", Codunit50200.GetGSTBaseAmtPostedLine(SCrMLRec."Document No.", SCrMLRec."Line No."));
                    Rec.Setrange("Add.-Currency Debit Amount", DGSTLedEntryRec."GST Amount");
                    Rec.Setrange("Add.-Currency Credit Amount", DGSTLedEntryRec."GST %");
                    Rec.SetRange("Debit Amount", SCrMLRec.Quantity);
                    if not Rec.FindFirst() then begin
                        Rec.Init();
                        Rec.TransferFields(GLRec);
                        Rec."G/L Account Name" := GLAccRec.Name;
                        Rec."G/L Account No." := GLRec."G/L Account No.";
                        Rec."Dimension Changes Count" := SCrMLRec."Line No.";
                        Rec."Document No." := GLRec."Document No.";
                        Rec."Posting Date" := GLRec."Posting Date";
                        Rec."External Document No." := GLRec."External Document No.";
                        Rec."Source No." := GLRec."Source No.";
                        Rec."Location Code" := GLRec."Location Code";
                        Rec.Comment := LocationRec.Name;
                        Rec."Reason Code" := LocationRec."State Code";
                        Rec."IC Partner Code" := SCrMLRec."Item Category Code";
                        Rec."Gen. Prod. Posting Group" := SCrMLRec."Gen. Prod. Posting Group";
                        Rec."VAT Prod. Posting Group" := SCrMLRec."Posting Group";
                        Rec."VAT Bus. Posting Group" := ItemRec."Item Category Code";       //ProductGroupCode
                        Rec."Document Type" := GLRec."Document Type";
                        Rec."Prod. Order No." := SCrMLRec."No.";
                        Rec.Description := SCrMHRec."Sell-to Customer Name";
                        Rec."Tax Group Code" := SCrMHRec."Customer Posting Group";
                        Rec.Amount := SCrMLRec.Amount;
                        Rec."VAT Amount" := SCrMLRec."Line Discount %";
                        Rec."Non-Deductible VAT Amount" := SCrMLRec."Inv. Discount Amount";
                        Rec."Non-Deductible VAT Amount ACY" := SCrMLRec."Line Discount Amount";
                        Rec."Business Unit Code" := SCrMLRec.Description;
                        Rec."Source Branch" := SCrMHRec."Payment Terms Code";
                        Rec."Gen. Posting Type" := SCrMLRec."GST Group Type";
                        Rec."User ID" := Format(SCrMLRec."GST Jurisdiction Type");
                        Rec."Source Type" := SCrMHRec."GST Customer Type";
                        Rec."Additional-Currency Amount" := Codunit50200.GetGSTBaseAmtPostedLine(SCrMLRec."Document No.", SCrMLRec."Line No.");
                        Rec."Add.-Currency Debit Amount" := DGSTLedEntryRec."GST Amount";
                        Rec."Add.-Currency Credit Amount" := DGSTLedEntryRec."GST %";
                        Rec."Debit Amount" := SCrMLRec.Quantity;
                        Rec.Quantity := SCrMLRec."Unit Cost";    //UnitCost
                        Rec.Amount := -1 * (SCrMLRec.Amount); //Amount
                        Rec."Non-Deductible VAT Amount" := -1 * (SCrMLRec."Inv. Discount Amount");    //InvDiscAmt
                        Rec."Non-Deductible VAT Amount ACY" := -1 * (SCrMLRec."Line Discount Amount");    //LineDiscAmt
                        Rec."Add.-Currency Debit Amount" := DGSTLedEntryRec."GST Amount";   //GSTAmt
                        Rec."Debit Amount" := SCrMLRec.Quantity;   //Qty
                        Rec."Credit Amount" := GLRec.Amount;    //GLAmt
                        Rec."Finance Branch A/c Code" := 'SCrML';
                        Rec.Insert();
                    end else begin
                        Rec.Quantity := Rec.Quantity + SCrMLRec."Unit Cost";    //UnitCost
                        Rec.Amount := -1 * (Rec.Amount + SCrMLRec.Amount); //Amount
                        Rec."Non-Deductible VAT Amount" := -1 * (Rec."Non-Deductible VAT Amount" + SCrMLRec."Inv. Discount Amount");    //InvDiscAmt
                        Rec."Non-Deductible VAT Amount ACY" := -1 * (Rec."Non-Deductible VAT Amount ACY" + SCrMLRec."Line Discount Amount");    //LineDiscAmt
                        Rec."Add.-Currency Debit Amount" := Rec."Add.-Currency Debit Amount" + DGSTLedEntryRec."GST Amount";   //GSTAmt
                        Rec."Credit Amount" := Rec."Credit Amount" + GLRec.Amount;  //GLAmt
                        Rec."Debit Amount" := Rec."Debit Amount" + SCrMLRec.Quantity;   //Qty
                        Rec.Modify();
                    end;
                end;
            until GlRec.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        ClearVariables();
        CalculateGLEntries();
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
        Clear(SalespersonPurchName);
        DayVar := 0;
        Clear(MonthVar);
        YearVar := 0;
        Clear(FinancialYear);
        Clear(Quarter);
        Clear(AppliesToDocType);
        Clear(AppliesToDocNo);
        Clear(NameVar);
        clear(DocNo);
        Clear(SourceNo);
        Clear(DocType);
        UnitCost := 0;
        GLAmount := 0;
    end;

    procedure CalculateGLEntries()
    begin
        if Rec."Finance Branch A/c Code" = 'SCrML' then begin
            TrnType := 'Credit Note';
            NameVar := Rec."G/L Account Name";
            LineNo := Rec."Dimension Changes Count";
            DocNo := Rec."Document No.";
            OrderNo := '';
            OrderDate := 0D;
            PostDate := Rec."Posting Date";
            ExtDocNo := Rec."External Document No.";
            SourceNo := Rec."Source No.";
            PmntTermsCode := Rec."Source Branch";
            LoCode := Rec."Location Code";
            LocName := Rec.Comment;
            LocStateCode := Rec."Reason Code";
            ItemCatCode := Rec."IC Partner Code";
            GenProdPostGrp := Rec."Gen. Prod. Posting Group";
            PostingGrp := Rec."VAT Prod. Posting Group";
            ProductGrpCode := Rec."VAT Bus. Posting Group";
            DocType := Format(Rec."Document Type");
            ItemNo := Rec."Prod. Order No.";
            Desc := Rec."Business Unit Code";
            SellToCustName := Rec.Description;
            CustPostGrp := Rec."Tax Group Code";
            UnitCost := Rec.Quantity;
            LineAmount := Rec.Amount;
            LineDiscountAmount := Rec."VAT Amount";
            InvDiscountAmount := Rec."Non-Deductible VAT Amount";
            LineDiscountAmount := Rec."Non-Deductible VAT Amount ACY";
            GSTBaseAmt := Rec."Additional-Currency Amount";
            GSTGrpType := Format(Rec."Gen. Posting Type");
            GLAmount := Rec."Credit Amount";
            TotGSTPer := Rec."Add.-Currency Credit Amount";
            TotGSTAmt := Rec."Add.-Currency Debit Amount";
            Qty := Rec."Debit Amount";

            if Rec."User ID" = 'Intrastate' then
                GSTJurisdiction := 'Intrastate';
            if Rec."User ID" = 'Interstate' then
                GSTJurisdiction := 'Interstate';

            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::" " then
                GSTCustomerType := '';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::Registered then
                GSTCustomerType := 'Registered';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::Unregistered then
                GSTCustomerType := 'Unregistered';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::Export then
                GSTCustomerType := 'Export';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::"Deemed Export" then
                GSTCustomerType := 'Deemed Export';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::Exempted then
                GSTCustomerType := 'Exempted';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::"SEZ Development" then
                GSTCustomerType := 'SEZ Development';
            if SCrMHRec."GST Customer Type" = SCrMHRec."GST Customer Type"::"SEZ Unit" then
                GSTCustomerType := 'SEZ Unit';

        end;
    end;

    var
        SILRec: Record "Sales Invoice Line";
        SCrMLRec: Record "Sales Cr.Memo Line";
        SIHRec: Record "Sales Invoice Header";
        SCrMHRec: Record "Sales Cr.Memo Header";
        GLRec: Record "G/L Entry";
        GLEntryRec: Record "G/L Entry";
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
        SalespersonPurchRec: Record "Salesperson/Purchaser";
        SalespersonPurchName: Text[100];
        DayVar: Integer;
        MonthVar: Text[20];
        YearVar: Integer;
        FinancialYear: Code[20];
        Quarter: Code[20];
        AppliesToDocType: Code[20];
        AppliesToDocNo: Code[20];
        linenum: Integer;
        CLERec: Record "Cust. Ledger Entry";
        DGSTLedEntryRec: Record "Detailed GST Ledger Entry";
        NameVar: Text[30];
        DocNo: Code[20];
        SourceNo: Code[20];
        DocType: Code[20];
        UnitCost: Decimal;
        GLAmount: Decimal;
}