report 50040 "Item Balance As On Date"
{
    // //acxcp_200921 + //Unit Cost Actual
    DefaultLayout = RDLC;
    RDLCLayout = './ItemBalanceAsOnDate.rdlc';


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
            column(ReaminingQty; ILE."Remaining Quantity")
            {
            }
            column(ExpirationStockQty_; ExpirationStockQty)
            {
            }
            column(ExpiredStockAmount_; ExpiredStockAmount)
            {
            }
            column(NextExpiredQty_; NextExpiredQty)
            {
            }
            column(NextExpiredAmount_; NextExpiredAmount)
            {
            }
            column(NextExpired_90_; NextExpired_90)
            {
            }
            column(NextExpiredAmount_90_; NextExpiredAmount_90)
            {
            }

            trigger OnAfterGetRecord()
            var
                ItemledgerEntry: Record "32";
                ItemledgerEntry2: Record "32";
                ItemledgerEntry3: Record "32";
                StartExpireDate: Date;
                EndExpireDate: Date;
            begin
                // Team
                CLEAR(ExpirationStockQty);
                CLEAR(ExpiredStockAmount);

                ItemledgerEntry.RESET;
                IF LocCode <> '' THEN
                    ItemledgerEntry.SETRANGE("Location Code", LocCode);
                IF Item <> '' THEN
                    ItemledgerEntry.SETRANGE("Item No.", Item);
                IF "Item Ledger Entry"."Location Code" <> '' THEN
                    ItemledgerEntry.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                ItemledgerEntry.SETFILTER("Expiration Date", '>%1', TODAY);
                ItemledgerEntry.SETRANGE(Open, TRUE);
                IF "Item Ledger Entry"."Item No." <> '' THEN
                    ItemledgerEntry.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                IF "Item Ledger Entry"."Lot No." <> '' THEN
                    ItemledgerEntry.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                ItemledgerEntry.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                IF ItemledgerEntry.FINDSET THEN
                    REPEAT
                        ExpirationStockQty += ItemledgerEntry."Remaining Quantity";
                        ExpiredStockAmount += ((ItemledgerEntry."Cost Amount (Actual)" * ItemledgerEntry."Remaining Quantity") / ItemledgerEntry.Quantity)
                    UNTIL ItemledgerEntry.NEXT = 0;
                // Team

                // Team
                ItemledgerEntry2.RESET;
                IF LocCode <> '' THEN
                    ItemledgerEntry2.SETRANGE("Location Code", LocCode);
                IF Item <> '' THEN
                    ItemledgerEntry2.SETRANGE("Item No.", Item);
                ItemledgerEntry2.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                ItemledgerEntry2.SETRANGE("Expiration Date", TODAY, TODAY + 14);
                ItemledgerEntry2.SETRANGE(Open, TRUE);
                ItemledgerEntry2.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                ItemledgerEntry2.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                ItemledgerEntry2.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                CLEAR(NextExpiredQty);
                CLEAR(NextExpiredAmount);
                IF ItemledgerEntry2.FINDSET THEN
                    REPEAT
                        NextExpiredQty += ItemledgerEntry2."Remaining Quantity";
                        NextExpiredAmount += ((ItemledgerEntry2."Cost Amount (Actual)" * ItemledgerEntry2."Remaining Quantity") / ItemledgerEntry2.Quantity)
                    UNTIL ItemledgerEntry2.NEXT = 0;
                // Team


                // Team


                StartExpireDate := TODAY + 14;
                EndExpireDate := StartExpireDate + 90;
                ItemledgerEntry3.RESET;
                IF LocCode <> '' THEN
                    ItemledgerEntry3.SETRANGE("Location Code", LocCode);
                IF Item <> '' THEN
                    ItemledgerEntry3.SETRANGE("Item No.", Item);
                ItemledgerEntry3.SETRANGE("Location Code", "Item Ledger Entry"."Location Code");
                ItemledgerEntry3.SETRANGE("Expiration Date", StartExpireDate, EndExpireDate);
                ItemledgerEntry3.SETRANGE(Open, TRUE);
                ItemledgerEntry3.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                ItemledgerEntry3.SETRANGE("Lot No.", "Item Ledger Entry"."Lot No.");
                ItemledgerEntry3.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                CLEAR(NextExpired_90);
                CLEAR(NextExpiredAmount_90);
                IF ItemledgerEntry3.FINDSET THEN
                    REPEAT
                        NextExpired_90 += ItemledgerEntry3."Remaining Quantity";
                        NextExpiredAmount_90 += ((ItemledgerEntry3."Cost Amount (Actual)" * ItemledgerEntry3."Remaining Quantity") / ItemledgerEntry3.Quantity)
                    UNTIL ItemledgerEntry3.NEXT = 0;
                // Team



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
            var
                ItemLedgerEntry: Record "32";
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
        //ACXCP110122 BEGIN
        CUserID := USERID;
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", CUserID);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                IF LocCode <> '' THEN BEGIN
                    Location.RESET;
                    Location.SETRANGE(Code, LocCode);
                    IF Location.FINDFIRST THEN BEGIN
                        IF Location."State Code" <> UserSetup."Sales Resp. Ctr. Filter" THEN
                            ERROR('Selected Location does not match with User Location');
                    END;
                END;
        END;
        //ACXCP110122 END
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
        Location: Record "14";
        ExpirationStockQty: Decimal;
        ExpiredStockAmount: Decimal;
        NextExpiredQty: Decimal;
        NextExpiredAmount: Decimal;
        NextExpired_90: Decimal;
        NextExpiredAmount_90: Decimal;
}

