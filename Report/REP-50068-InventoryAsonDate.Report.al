report 50068 "Inventory As on Date"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = '.\ReportLayout\InventoryAsonDate.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; 32)
        {
            DataItemTableView = SORTING("Lot No.", "Location Code")
                                ORDER(Ascending)
                                WHERE(Open = CONST(true));
            RequestFilterFields = "Item No.", "Location Code", "Lot No.";
            column(ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            column(LocationCode; "Item Ledger Entry"."Location Code")
            {
            }
            column(PostingDate; "Item Ledger Entry"."Posting Date")
            {
            }
            column(Quantity; "Item Ledger Entry".Quantity)
            {
            }
            column(lotNo; "Item Ledger Entry"."Lot No.")
            {
            }
            column(CostAmt; "Item Ledger Entry"."Cost Amount (Actual)")
            {
            }
            column(RemQty; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(StateCode; StateCode)
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(MFGDate; MFGDate)
            {
            }
            column(ExpDate; "Item Ledger Entry"."Expiration Date")
            {
            }
            column(AlterConv; AlterConv)
            {
            }
            column(InvenPostGroup; InvenPostGroup)
            {
            }
            column(TextItemName; TextItemName)
            {
            }
            column(UOM; "Item Ledger Entry"."Unit of Measure Code")
            {
            }
            column(AlterUOM; IUOM.Code)
            {
            }
            column(NextExpQty; NextExpQty)
            {
            }
            column(ExpStock; ExpStock)
            {
            }
            column(ExpDays; ExpDays)
            {
            }
            column(NextDate; NextDate)
            {
            }
            column(RemCost; RemCost)
            {
            }
            column(MRPPrice; MRPPrice)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LocationRec.RESET;
                LocationRec.SETRANGE(Code, "Item Ledger Entry"."Location Code");
                IF LocationRec.FINDFIRST THEN BEGIN
                    LocationName := LocationRec.Name;
                    StateCode := LocationRec."State Code";
                END;

                LotInfo.RESET();
                MFGDate := 0D;
                MRPPrice := 0;
                LotInfo.SETRANGE("Item No.", "Item No.");
                LotInfo.SETRANGE("Lot No.", "Lot No.");
                IF LotInfo.FINDFIRST THEN BEGIN
                    MFGDate := LotInfo."MFG Date";
                    MRPPrice := LotInfo."Batch MRP";
                END;

                recItem.RESET();
                InvenPostGroup := '';
                recItem.SETRANGE("No.", "Item No.");
                IF recItem.FINDFIRST THEN BEGIN
                    TextItemName := recItem.Description;
                    InvenPostGroup := recItem."Inventory Posting Group";
                END;
                AlterConv := 0;
                IUOM.RESET();
                IUOM.SETRANGE("Item No.", recItem."No.");
                IUOM.SETFILTER(Code, '<>%1', recItem."Base Unit of Measure");
                IUOM.SETRANGE("Conversion UOM", TRUE);
                IF IUOM.FINDFIRST THEN
                    AlterConv := IUOM."Qty. per Unit of Measure";

                NextExpQty := 0;
                NextDate := 0D;
                NextDate := TODAY + (ExpDays - 1);
                ILE.RESET;
                ILE.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                ILE.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                ILE.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                ILE.SETRANGE(Open, TRUE);
                ILE.SETRANGE("Expiration Date", TODAY, NextDate);
                IF ILE.FINDSET THEN
                    REPEAT
                        NextExpQty := NextExpQty + ILE."Remaining Quantity";
                    UNTIL ILE.NEXT = 0;

                ExpStock := 0;

                ILE1.RESET;
                ILE1.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                ILE1.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                ILE1.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                ILE1.SETRANGE("Expiration Date", TODAY - 36500, TODAY - 1);
                ILE1.SETRANGE(Open, TRUE);
                IF ILE1.FINDSET THEN
                    REPEAT
                        ExpStock := ExpStock + ILE1."Remaining Quantity";
                    UNTIL ILE1.NEXT = 0;


                RemCost := 0;
                ILE2.RESET;
                ILE2.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                ILE2.SETRANGE(Open, TRUE);
                ILE2.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                ILE2.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                ILE2.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                IF ILE2.FINDSET THEN BEGIN
                    REPEAT
                        RemCost := RemCost + ((ILE2."Cost Amount (Actual)" / ILE2.Quantity) * ILE2."Remaining Quantity");
                    UNTIL ILE2.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ExpDays; ExpDays)
                {
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

    trigger OnInitReport()
    begin
        ExpDays := 15;
    end;

    var
        StateCode: Code[10];
        LocationRec: Record 14;
        LocationName: Text[50];
        LotInfo: Record 6505;
        IUOM: Record 5404;
        recItem: Record 27;
        AlterConv: Decimal;
        InvenPostGroup: Code[10];
        TextItemName: Text;
        MFGDate: Date;
        NextExpQty: Decimal;
        ILE: Record 32;
        NextDate: Date;
        ExpStock: Decimal;
        ILE1: Record 32;
        ExpDays: Integer;
        RemCost: Decimal;
        ILE2: Record 32;
        MRPPrice: Decimal;
}

