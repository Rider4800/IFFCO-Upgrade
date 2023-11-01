page 50057 imc_Party_GP
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'imcPartyGP';
    DelayedInsert = true;
    EntityName = 'imc_Party_GP';
    EntitySetName = 'imc_Party_GP';
    PageType = API;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Source_No_; Rec."Source No.")
                {

                }
                field(Source_Name; Rec."G/L Account Name")
                {

                }
                field(Gross_Sales; Rec.Amount)
                {

                }
                field(Sales_Return; Rec."Debit Amount")
                {

                }
                field(Prod_Disc; Rec."Credit Amount")
                {

                }
                field(Trade_Disc; Rec."VAT Amount")
                {

                }
                field(Net_Sales; Rec.Amount - Abs(Rec."Debit Amount") - Abs(Rec."Credit Amount") - Abs(Rec."VAT Amount"))
                {

                }
                field(COGS; Rec."Add.-Currency Debit Amount")
                {

                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();
        Clear(EntryNo);
        SalesTransferReg.Reset();
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220401D, 20220419D);
        SalesTransferReg.SetRange("Document Type", SalesTransferReg."Document Type"::"Sales Invoice");
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."G/L Account Name" := SalesTransferReg."Source Name";
                    Rec.Amount := SalesTransferReg.Amount;//Gross_Sales
                    Rec."Debit Amount" := 0;//Sales_Return
                    Rec."Credit Amount" := 0;//Prod_Disc
                    Rec."VAT Amount" := 0;//Trade_Disc
                    Item.Reset();
                    Item.SetRange(Description, SalesTransferReg."Item Description");
                    Item.SetFilter("Unit Cost", '<>%1', 0);
                    if Item.FindFirst() then
                        Rec."Add.-Currency Debit Amount" := SalesTransferReg.Quantity * Item."Unit Cost";//COGS
                    Rec."Entry No." += EntryNo;
                    Rec.Insert();
                end else begin
                    Rec.Amount += SalesTransferReg.Amount;
                    Item.Reset();
                    Item.SetRange(Description, SalesTransferReg."Item Description");
                    Item.SetFilter("Unit Cost", '<>%1', 0);
                    if Item.FindFirst() then
                        Rec."Add.-Currency Debit Amount" += SalesTransferReg.Quantity * Item."Unit Cost";//COGS

                    Rec.Modify();
                end;
            until SalesTransferReg.Next() = 0;

        SalesTransferReg.Reset();
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220401D, 20220419D);
        SalesTransferReg.SetRange("Document Type", SalesTransferReg."Document Type"::"Sales Cr. Memo");
        SalesTransferReg.SetRange(Type, SalesTransferReg.Type::Item);
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."G/L Account Name" := SalesTransferReg."Source Name";
                    Rec.Amount := 0;//Gross_Sales
                    Rec."Debit Amount" := SalesTransferReg.Amount;//Sales_Return
                    Rec."Credit Amount" := 0;//Prod_Disc
                    Rec."VAT Amount" := 0;//Trade_Disc
                    Item.Reset();
                    Item.SetRange(Description, SalesTransferReg."Item Description");
                    Item.SetFilter("Unit Cost", '<>%1', 0);
                    if Item.FindFirst() then
                        Rec."Add.-Currency Debit Amount" := -1 * abs(SalesTransferReg.Quantity) * Item."Unit Cost";//COGS
                    Rec."Entry No." += EntryNo;
                    Rec.Insert();
                end else begin
                    Rec."Debit Amount" += SalesTransferReg.Amount;
                    Item.Reset();
                    Item.SetRange(Description, SalesTransferReg."Item Description");
                    Item.SetFilter("Unit Cost", '<>%1', 0);
                    if Item.FindFirst() then
                        Rec."Add.-Currency Debit Amount" += -1 * abs(SalesTransferReg.Quantity) * Item."Unit Cost";//COGS
                    Rec.Modify();
                end;
            until SalesTransferReg.Next() = 0;

        SalesTransferReg.Reset();
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220401D, 20220419D);
        SalesTransferReg.SetRange("Document Type", SalesTransferReg."Document Type"::"Sales Cr. Memo");
        SalesTransferReg.SetRange(Type, SalesTransferReg.Type::"Charge (Item)");
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."G/L Account Name" := SalesTransferReg."Source Name";
                    Rec.Amount := 0;//Gross_Sales
                    Rec."Debit Amount" := 0;//Sales_Return
                    Rec."Credit Amount" := SalesTransferReg.Amount;//Prod_Disc
                    Rec."VAT Amount" := 0;//Trade_Disc
                    Rec."Entry No." += EntryNo;
                    Rec.Insert();
                end else begin
                    Rec."Credit Amount" += SalesTransferReg.Amount;
                    Rec.Modify();
                end;
            until SalesTransferReg.Next() = 0;

        SalesTransferReg.Reset();
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220401D, 20220419D);
        SalesTransferReg.SetFilter("Line Discount Amount", '<>%1', 0);
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."G/L Account Name" := SalesTransferReg."Source Name";
                    Rec.Amount := 0;//Gross_Sales
                    Rec."Debit Amount" := 0;//Sales_Return
                    Rec."Credit Amount" := 0;//Prod_Disc
                    Rec."VAT Amount" := SalesTransferReg."Line Discount Amount";//Trade_Disc
                    Rec."Entry No." += EntryNo;
                    Rec.Insert();
                end else begin
                    Rec."VAT Amount" += SalesTransferReg."Line Discount Amount";
                    Rec.Modify();
                end;
            until SalesTransferReg.Next() = 0;

        Rec.Reset();
    end;

    var
        SalesTransferReg: Record "Sales/Transfer Register";
        ItemNum: code[20];
        EntryNo: Integer;
        Item: Record 27;
}

