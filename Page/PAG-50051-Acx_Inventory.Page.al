page 50051 Acx_Inventory
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Acx_Inventory';
    DelayedInsert = true;
    EntityName = 'Acx_Inventory';
    EntitySetName = 'Acx_Inventory';
    PageType = API;
    SourceTable = "Value Entry";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Entry_No; EntryNo)
                {
                }
                field(Item_No; Rec."Item No.")
                {
                }
                field(Item_Description; ItemDesc)
                {
                }
                field(ItemTechnicalName; ItemTechnicalName)
                {
                }
                field(Unit_of_Measure_Code; UOMCode)
                {
                }
                field(Posting_Date; Rec."Posting Date")
                {
                }
                field(Entry_Type; EntryType)
                {
                }
                field(Source_Type; SourceType)
                {
                }
                field(Source_No; Rec."Source No.")
                {
                }
                field(Document_No; Rec."Document No.")
                {
                }
                field(Location_Code; Rec."Location Code")
                {
                }
                field(Location_Name; LocName)
                {
                }
                field(Quantity; Rec."Item Ledger Entry Quantity")
                {
                }
                field(Remaining_Quantity; RemainingQty)
                {
                }
                field(Dim1; Rec."Global Dimension 1 Code")
                {
                }
                field(Dim2; Rec."Global Dimension 2 Code")
                {
                }
                field(External_Document_No; Rec."External Document No.")
                {
                }
                field(DocType; DocType)
                {
                }
                field(Document_Line_No; Rec."Document Line No.")
                {
                }
                field(Order_Type; OrderType)
                {
                }
                field(Order_Line_No; Rec."Order Line No.")
                {
                }
                field(Reason_Code; Rec."Reason Code")
                {
                }
                field(Return_Reason_Code; Rec."Return Reason Code")
                {
                }
                field(Lot_No; LotNo)
                {
                }
                field(MFG_Date; MFGDate)
                {
                }
                field(Expiration_Date; ExpDate)
                {
                }
                field(Batch_MRP; BatchMRP)
                {
                }
                field(Cost_Amount_Actual; Rec."Cost Amount (Actual)")
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ClearVariables();

        if ILERec.Get(Rec."Item Ledger Entry No.") then begin
            EntryNo := ILERec."Entry No.";
            UOMCode := ILERec."Unit of Measure Code";
            ItemCatCode := ILERec."Item Category Code";
            EntryType := Format(ILERec."Entry Type");
            SourceType := Format(ILERec."Source Type");
            RemainingQty := ILERec."Remaining Quantity";
            ExpDate := ILERec."Expiration Date";
            LotNo := ILERec."Lot No.";

            LotNoInfoRec.Reset();
            LotNoInfoRec.SetRange("Lot No.", ILERec."Lot No.");
            LotNoInfoRec.SetRange("Item No.", ILERec."Item No.");
            if LotNoInfoRec.FindFirst() then begin
                MFGDate := LotNoInfoRec."MFG Date";
                BatchMRP := LotNoInfoRec."Batch MRP";
            end;

            if ILERec."Document Type" = ILERec."Document Type"::" " then
                DocType := '';
            if ILERec."Document Type" = ILERec."Document Type"::"Sales Shipment" then
                DocType := 'Sales Shipment';
            if ILERec."Document Type" = ILERec."Document Type"::"Sales Invoice" then
                DocType := 'Sales Invoice';
            if ILERec."Document Type" = ILERec."Document Type"::"Sales Return Receipt" then
                DocType := 'Sales Return Receipt';
            if ILERec."Document Type" = ILERec."Document Type"::"Sales Credit Memo" then
                DocType := 'Sales Credit Memo';
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Receipt" then
                DocType := 'Purchase Receipt';
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Invoice" then
                DocType := 'Purchase Invoice';
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Return Shipment" then
                DocType := 'Purchase Return Shipment';
            if ILERec."Document Type" = ILERec."Document Type"::"Purchase Credit Memo" then
                DocType := 'Purchase Credit Memo';
            if ILERec."Document Type" = ILERec."Document Type"::"Transfer Shipment" then
                DocType := 'Transfer Shipment';
            if ILERec."Document Type" = ILERec."Document Type"::"Transfer Receipt" then
                DocType := 'Transfer Receipt';
            if ILERec."Document Type" = ILERec."Document Type"::"Service Shipment" then
                DocType := 'Service Shipment';
            if ILERec."Document Type" = ILERec."Document Type"::"Service Invoice" then
                DocType := 'Service Invoice';
            if ILERec."Document Type" = ILERec."Document Type"::"Service Credit Memo" then
                DocType := 'Service Credit Memo';

            if ILERec."Order Type" = ILERec."Order Type"::" " then
                OrderType := '';
            if ILERec."Order Type" = ILERec."Order Type"::Production then
                OrderType := 'Production';
            if ILERec."Order Type" = ILERec."Order Type"::Transfer then
                OrderType := 'Transfer';
            if ILERec."Order Type" = ILERec."Order Type"::Service then
                OrderType := 'Service';
            if ILERec."Order Type" = ILERec."Order Type"::Assembly then
                OrderType := 'Assembly';
        end;

        if ItemRec.Get(Rec."Item No.") then begin
            ItemDesc := ItemRec.Description;
            ItemTechnicalName := ItemRec."Technical Name";
            IPG := ItemRec."Inventory Posting Group";
            GPPG := ItemRec."Gen. Prod. Posting Group";
        end;

        if LocationRec.Get(Rec."Location Code") then
            LocName := LocationRec.Name;
    end;

    procedure ClearVariables()
    begin
        EntryNo := 0;
        Clear(ItemDesc);
        Clear(ItemTechnicalName);
        Clear(UOMCode);
        Clear(IPG);
        Clear(GPPG);
        Clear(ItemCatCode);
        Clear(ProdGrpCode);
        Clear(EntryType);
        Clear(SourceType);
        Clear(LocName);
        RemainingQty := 0;
        Clear(DocType);
        Clear(OrderType);
        Clear(LotNo);
        MFGDate := 0D;
        ExpDate := 0D;
        BatchMRP := 0;
    end;

    var
        ILERec: Record "Item Ledger Entry";
        ItemRec: Record Item;
        LocationRec: Record Location;
        LotNoInfoRec: Record "Lot No. Information";
        EntryNo: Integer;
        ItemDesc: Text[50];
        ItemTechnicalName: Text[50];
        UOMCode: Code[20];
        IPG: Code[20];
        GPPG: Code[20];
        ItemCatCode: Code[20];
        ProdGrpCode: Code[20];
        EntryType: Text[50];
        SourceType: Text[50];
        LocName: Text[50];
        RemainingQty: Decimal;
        DocType: Text[50];
        OrderType: Text[50];
        LotNo: Code[50];
        MFGDate: Date;
        ExpDate: Date;
        BatchMRP: Decimal;
}