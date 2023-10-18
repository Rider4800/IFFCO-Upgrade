report 50054 "Item Balance2"
{
    // //acxcp_200921 + //Unit Cost Actual
    DefaultLayout = RDLC;
    RDLCLayout = './ItemBalance2.rdlc';


    dataset
    {
        dataitem(DataItem1000000000; Table32)
        {
            DataItemTableView = SORTING (Item No., Entry Type, Posting Date, Location Code)
                                ORDER(Descending);
            RequestFilterFields = "Location Code", "Posting Date";
            column(CompanyName; recCompInfo.Name)
            {
            }
            column(LocationName; texLocation)
            {
            }
            column(StateCode; "Item Ledger Entry"."Global Dimension 1 Code")
            {
            }
            column(PostingDate; "Item Ledger Entry"."Posting Date")
            {
            }
            column(ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            column(ItemName; TextItemName)
            {
            }
            column(UOM; "Item Ledger Entry"."Unit of Measure Code")
            {
            }
            column(LotNo; "Item Ledger Entry"."Lot No.")
            {
            }
            column(Qty; "Item Ledger Entry".Quantity)
            {
            }
            column(EntryNoILE; "Item Ledger Entry"."Entry No.")
            {
            }
            column(CostAmountActual; CostAmtActual)
            {
            }
            column(LocationCode; recLocation.Code)
            {
            }
            column(TillDate; TillDate)
            {
            }
            column(InvPostGroup; InvenPostGroup)
            {
            }
            column(UnitCost; recItem."Unit Cost")
            {
            }
            column(AlterConv; AlterConv)
            {
            }
            column(AlterUOM; IUOM.Code)
            {
            }
            column(ExpDate; "Item Ledger Entry"."Expiration Date")
            {
            }
            column(MFGDate; MFGDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                texLocation := '';
                recCompInfo.GET();
                recLocation.RESET();
                recLocation.SETRANGE(Code, "Item Ledger Entry"."Location Code");
                IF recLocation.FINDFIRST THEN
                    texLocation := recLocation.Name;

                IF ("Item Ledger Entry"."Location Code" <> CdLocation) AND (recRespobility = TRUE) THEN
                    ERROR('Only single location selection allow');
                /*IF ("ItemNo." <> "Item Ledger Entry"."Item No.") AND (LotIno <> "Item Ledger Entry"."Lot No.") THEN
                  BalanceQty:=0;
                MFGDate:=0D;
                TextItemName:='';
                ILE.RESET();
                ILE.SETCURRENTKEY("Item No.","Location Code","Lot No.");
                ILE.SETFILTER("Remaining Quantity",'>=%1',0);
                ILE.SETRANGE("Location Code","Location Code");
                ILE.SETRANGE("Item No.","Item No.");
                ILE.SETRANGE("Lot No.","Lot No.");
                IF ILE.FINDFIRST THEN BEGIN
                  REPEAT
                    BalanceQty +=  ILE."Remaining Quantity";
                  UNTIL ILE.NEXT=0;
                END;
                */

                //acxcp_200921 + //Unit Cost Actual
                CostAmtActual := 0;
                recValueEntry.RESET;
                recValueEntry.SETRANGE("Posting Date", StartDt, EndDt);
                recValueEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                IF LocCode <> '' THEN
                    recValueEntry.SETRANGE("Location Code", LocCode);
                IF Item <> '' THEN
                    recValueEntry.SETRANGE("Item No.", Item);
                IF recValueEntry.FINDSET THEN
                    REPEAT
                        CostAmtActual += recValueEntry."Cost Amount (Actual)";
                    UNTIL recValueEntry.NEXT = 0;
                //acxcp_200921 -

                LotInfo.RESET();
                MFGDate := 0D;
                LotInfo.SETRANGE("Item No.", "Item No.");
                LotInfo.SETRANGE("Lot No.", "Lot No.");
                IF LotInfo.FINDFIRST THEN
                    MFGDate := LotInfo."MFG Date";

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

            end;

            trigger OnPreDataItem()
            begin
                recRespobility := FALSE;
                IF "Item Ledger Entry".FINDLAST THEN
                    TillDate := "Item Ledger Entry"."Posting Date";
                CdLocation := "Item Ledger Entry"."Location Code";

                CUserID := USERID;
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", CUserID);
                IF (UserSetup.FINDFIRST) AND (UserSetup."Sales Resp. Ctr. Filter" <> '') THEN
                    recRespobility := TRUE;

                "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)");  //acxcp_090821
                //recValueEntry.CALCFIELDS("Cost Amount (Actual)");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        "ItemNo." := '';
        LotIno := '';
        BalanceQty := 0;
        texLocation := '';
        TillDate := 0D;
        CdLocation := '';
        StartDt := "Item Ledger Entry".GETRANGEMIN("Posting Date");
        EndDt := "Item Ledger Entry".GETRANGEMAX("Posting Date");
        Item := "Item Ledger Entry".GETFILTER("Item No.");
        LocCode := "Item Ledger Entry".GETFILTER("Location Code");
    end;

    var
        ILE: Record "32";
        LotInfo: Record "6505";
        TillDate: Date;
        texLocation: Text[50];
        BalanceQty: Decimal;
        MFGDate: Date;
        recItem: Record "27";
        TextItemName: Text[50];
        recCompInfo: Record "79";
        recLocation: Record "14";
        "ItemNo.": Code[20];
        LotIno: Code[20];
        CdLocation: Code[20];
        UserSetup: Record "91";
        recRespobility: Boolean;
        CUserID: Code[50];
        InvenPostGroup: Code[20];
        IUOM: Record "5404";
        AlterConv: Decimal;
        recValueEntry: Record "5802";
        CostAmtActual: Decimal;
        StartDt: Date;
        EndDt: Date;
        Item: Code[20];
        LocCode: Code[20];
}

