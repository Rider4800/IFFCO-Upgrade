page 50056 item_sales_preplace
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'itemSalesPreplace';
    DelayedInsert = true;
    EntityName = 'item_sales_preplace';
    EntitySetName = 'item_sales_preplace';
    PageType = API;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Posting_Date; Rec."Posting Date")
                {

                }
                field(Source_Document_No_; Rec."Document No.")
                {

                }
                field(Source_No_; Rec."Source No.")
                {

                }
                field(Source_Name; Rec."G/L Account Name")
                {

                }
                field(Item_Description; Rec.Description)
                {

                }
                field(Net_Sales; Rec.Amount - Abs(Rec."Debit Amount") - Abs(Rec."Credit Amount") - Abs(Rec."VAT Amount"))
                {

                }
                field(No_; ItemNum)
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
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220225D, 20220331D);
        SalesTransferReg.SetRange("Document Type", SalesTransferReg."Document Type"::"Sales Invoice");
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("Document No.", SalesTransferReg."Source Document No.");
                Rec.SetRange("Posting Date", SalesTransferReg."Posting Date");
                Rec.SetRange(Description, SalesTransferReg."Item Description");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."Document No." := SalesTransferReg."Source Document No.";
                    Rec."Posting Date" := SalesTransferReg."Posting Date";
                    Rec.Description := SalesTransferReg."Item Description";
                    Rec."G/L Account Name" := SalesTransferReg."Source Name";
                    Rec.Amount := SalesTransferReg.Amount;//Gross_Sales
                    Rec."Debit Amount" := 0;//Sales_Return
                    Rec."Credit Amount" := 0;//Prod_Disc
                    Rec."VAT Amount" := 0;//Trade_Disc
                    Rec."Entry No." += EntryNo;
                    Rec.Insert();
                end else begin
                    Rec.Amount += SalesTransferReg.Amount;
                    Rec.Modify();
                end;
            until SalesTransferReg.Next() = 0;

        SalesTransferReg.Reset();
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220225D, 20220331D);
        SalesTransferReg.SetRange("Document Type", SalesTransferReg."Document Type"::"Sales Cr. Memo");
        SalesTransferReg.SetRange(Type, SalesTransferReg.Type::Item);
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("Document No.", SalesTransferReg."Source Document No.");
                Rec.SetRange("Posting Date", SalesTransferReg."Posting Date");
                Rec.SetRange(Description, SalesTransferReg."Item Description");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."Document No." := SalesTransferReg."Source Document No.";
                    Rec."Posting Date" := SalesTransferReg."Posting Date";
                    Rec.Description := SalesTransferReg."Item Description";
                    Rec."G/L Account Name" := SalesTransferReg."Source Name";
                    Rec.Amount := 0;//Gross_Sales
                    Rec."Debit Amount" := SalesTransferReg.Amount;//Sales_Return
                    Rec."Credit Amount" := 0;//Prod_Disc
                    Rec."VAT Amount" := 0;//Trade_Disc
                    Rec."Entry No." += EntryNo;
                    Rec.Insert();
                end else begin
                    Rec."Debit Amount" += SalesTransferReg.Amount;
                    Rec.Modify();
                end;
            until SalesTransferReg.Next() = 0;

        SalesTransferReg.Reset();
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220225D, 20220331D);
        SalesTransferReg.SetRange("Document Type", SalesTransferReg."Document Type"::"Sales Cr. Memo");
        SalesTransferReg.SetRange(Type, SalesTransferReg.Type::"Charge (Item)");
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("Document No.", SalesTransferReg."Source Document No.");
                Rec.SetRange("Posting Date", SalesTransferReg."Posting Date");
                Rec.SetRange(Description, SalesTransferReg."Source Line Description 2");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."Document No." := SalesTransferReg."Source Document No.";
                    Rec."Posting Date" := SalesTransferReg."Posting Date";
                    Rec.Description := SalesTransferReg."Source Line Description 2";
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
        SalesTransferReg.SetFilter("Posting Date", '>=%1&<=%2', 20220225D, 20220331D);
        SalesTransferReg.SetFilter("Line Discount Amount", '<>%1', 0);
        if SalesTransferReg.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetRange("Source No.", SalesTransferReg."Source No.");
                Rec.SetRange("Document No.", SalesTransferReg."Source Document No.");
                Rec.SetRange("Posting Date", SalesTransferReg."Posting Date");
                Rec.SetRange(Description, SalesTransferReg."Item Description");
                Rec.SetRange("G/L Account Name", SalesTransferReg."Source Name");
                if not Rec.FindFirst() then begin
                    Rec.Init();
                    Rec."Source No." := SalesTransferReg."Source No.";
                    Rec."Document No." := SalesTransferReg."Source Document No.";
                    Rec."Posting Date" := SalesTransferReg."Posting Date";
                    Rec.Description := SalesTransferReg."Item Description";
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

    trigger OnAfterGetRecord()
    begin
        Clear(ItemNum);
        Item.Reset();
        Item.SetRange(Description, Rec.Description);
        if Item.FindFirst() then
            ItemNum := Item."No.";
    end;

    var
        SalesTransferReg: Record "Sales/Transfer Register";
        ItemNum: code[20];
        EntryNo: Integer;
        Item: Record 27;
}
