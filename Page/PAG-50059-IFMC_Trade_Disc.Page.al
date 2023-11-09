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
                field(Source_Code; SourceCode)
                {
                }
                field(Transaction_Type; TrnType)
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
                    Rec.Reset();
                    //Rec.SetRange();
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
    end;

    procedure CalculateGLEntries()
    begin

    end;

    var
        SILRec: Record "Sales Invoice Line";
        SCrMLRec: Record "Sales Cr.Memo Line";
        SIHRec: Record "Sales Invoice Header";
        SCrMHRec: Record "Sales Cr.Memo Header";
        GLRec: Record "G/L Entry";
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
}