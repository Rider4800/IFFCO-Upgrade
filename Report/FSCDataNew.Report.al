report 50032 "FSC Data New"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1000000000; Table113)
        {
            DataItemTableView = WHERE (Type = FILTER (Item),
                                      Quantity = FILTER (<> 0));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                IF blExptoExcel THEN
                    MakeExcelDataBody;
            end;

            trigger OnPreDataItem()
            begin
                MakeExcelDataHeader;
            end;
        }
        dataitem(DataItem1000000001; Table115)
        {
            DataItemTableView = WHERE (Type = FILTER (Item),
                                      Quantity = FILTER (<> 0));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                IF blExptoExcel THEN
                    MakeExcelDataBody2;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        blExptoExcel := TRUE;
    end;

    trigger OnPostReport()
    begin
        IF blExptoExcel THEN
            CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        ExcelBuf.DELETEALL;

        IF blExptoExcel THEN
            MakeExcelInfo;
    end;

    var
        ExcelBuf: Record "370";
        blExptoExcel: Boolean;
        recRefSaleInvLine: RecordRef;
        recRefSalesCrLine: RecordRef;
        blnExportToExcel: Boolean;
        txtData: array[254] of Text[250];
        recstate: Record "13762";
        recDGLE: Record "16419";
        decIGST: Decimal;
        decCGST: Decimal;
        decSGST: Decimal;
        decUTGST: Decimal;
        LotNumber: Code[20];
        MFGDate: Date;
        ExpDate: Date;
        recsalesHeader: Record "112";
        SHPTOCODE: Text;
        SellCSTMNa: Text;
        recCustomer: Record "18";
        recShipToAdd: Record "222";
        Data1: Decimal;
        LN: Decimal;
        LN2: Decimal;
        Data3: Decimal;
        TxtCustPostinGrp: Text;
        Text004: ;
        Text014: Label 'Sales Line Report';
        recsalesCrHeader: Record "114";
        dcRoundOff: Decimal;
        recSIL: Record "113";
        recSCML: Record "115";
        recLoc: Record "14";
        "-----///-----------------": Text;
        intRowNo: Integer;
        ExcelBuffer: Record "370" temporary;
        recILE: Record "32";
        recItemLed: Record "32";
        RecValueEntry: Record "5802";
        ValEntryLedNo: Integer;
        Packvalue: Decimal;
        recLotInfo: Record "6505";
        RecsalesInvHeader: Record "112";
        RecsalesCrMemoHeader: Record "114";
        VarParty: Text;
        txtpostinggroup: Text;
        txtshiptocode: Text;
        unitperpiece: Decimal;
        ratelossepack: Decimal;
        txtExpDate: Text;
        txtMfgDate: Text;
        txtLotNo: Text;
        txtLotNumber: Text;
        recvalueentry1: Record "5802";
        Reclot: Record "6505";
        UserSetup: Record "91";

    [Scope('Internal')]
    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(USERID, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;
        //MakeExcelDataHeader;
    end;

    [Scope('Internal')]
    procedure MakeExcelDataHeader()
    begin

        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                "Sales Invoice Line".SETFILTER("Responsibility Center", '%1', UserSetup."Sales Resp. Ctr. Filter");
        END;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Sales Line Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Invoice Line".GETFILTERS, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('INVOICE_DT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//1
        ExcelBuf.AddColumn('INVOICE_NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn('WAREHOUSE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        ExcelBuf.AddColumn('BATCH', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
        ExcelBuf.AddColumn('PRODUCT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn('NO_OF_LOOSE_PACK', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//6
        ExcelBuf.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//7
        ExcelBuf.AddColumn('AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//8
        ExcelBuf.AddColumn('BILLING_RATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//9
        ExcelBuf.AddColumn('RATE_LOOSE_PACK', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//10
        ExcelBuf.AddColumn('RATE_LOOSE_PACK_INCL_GST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//11
        ExcelBuf.AddColumn('MRP_PER_PIECE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//12
        ExcelBuf.AddColumn('DATA_TYPE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//13
        ExcelBuf.AddColumn('PARTY', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//14
        ExcelBuf.AddColumn('PARTY_TYPE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn('BRANCH', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
        ExcelBuf.AddColumn('VAN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//17
        ExcelBuf.AddColumn('FSC_CODE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//18
        ExcelBuf.AddColumn('MFGDATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//19
        ExcelBuf.AddColumn('EXPIRYDATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//20
        ExcelBuf.AddColumn('PRODUCT CODE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4ACXLK
        //acxcp << added new columns
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//34
        ExcelBuf.AddColumn('Line Discount %', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//36
        ExcelBuf.AddColumn('Line Discount Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//37
        ExcelBuf.AddColumn('Round Off', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//38
        ExcelBuf.AddColumn('Location State Code', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//39
        ExcelBuf.AddColumn('Location State Name', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);//40
        ExcelBuf.AddColumn('DOCUMENT TYPE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//22
        //acxcp >>
    end;

    [Scope('Internal')]
    procedure MakeExcelDataBody()
    begin
        // IF blnExportToExcel THEN
        //  MakeExcelDataBody;

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//1
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Shortcut Dimension 2 Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3
        RecValueEntry.RESET();
        RecValueEntry.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
        RecValueEntry.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
        IF RecValueEntry.FIND('-') THEN BEGIN
            ValEntryLedNo := RecValueEntry."Item Ledger Entry No.";
            recILE.RESET();
            recILE.SETRANGE("Entry No.", ValEntryLedNo);
            IF recILE.FIND('-') THEN BEGIN
                ExcelBuf.AddColumn(FORMAT(recILE."Lot No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
            END;
        END;

        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line".Description), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."No. of Loose Pack"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//6
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line".Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//7
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Line Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//8
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//9

        IF ("Sales Invoice Line"."Units per Parcel" <> 0) AND ("Sales Invoice Line"."Unit Price" <> 0) THEN
            ratelossepack := "Sales Invoice Line"."Unit Price" / "Sales Invoice Line"."Units per Parcel"
        ELSE
            ratelossepack := 0;

        ExcelBuf.AddColumn(FORMAT(ratelossepack), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//10
        Packvalue := ratelossepack;
        //Packvalue := "Sales Invoice Line"."Unit Price"/"Sales Invoice Line"."Units per Parcel";

        ExcelBuf.AddColumn(FORMAT(Packvalue + (Packvalue * "Sales Invoice Line"."GST %") / 100), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11

        IF "Sales Invoice Line"."Units per Parcel" <> 0 THEN
            unitperpiece := "Sales Invoice Line"."MRP Price" / "Sales Invoice Line"."Units per Parcel"
        ELSE
            unitperpiece := 0;

        ExcelBuf.AddColumn(FORMAT(unitperpiece), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//12

        ExcelBuf.AddColumn(FORMAT('Sales'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//13
        RecsalesInvHeader.RESET;
        RecsalesInvHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
        IF RecsalesInvHeader.FINDFIRST THEN BEGIN
            IF RecsalesInvHeader."Ship-to Code" = '' THEN
                VarParty := RecsalesInvHeader."Sell-to Customer Name"
            ELSE
                VarParty := RecsalesInvHeader."Ship-to Name";
        END;
        ExcelBuf.AddColumn(FORMAT(VarParty), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //14

        RecsalesInvHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
        IF RecsalesInvHeader.FIND() THEN
            txtpostinggroup := RecsalesInvHeader."Customer Posting Group";

        ExcelBuf.AddColumn(FORMAT(txtpostinggroup), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Shortcut Dimension 1 Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
        ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."Sell-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//17

        RecsalesInvHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
        IF RecsalesInvHeader.FIND() THEN
            txtshiptocode := RecsalesInvHeader."Ship-to Code";

        ExcelBuf.AddColumn(FORMAT(txtshiptocode), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //18

        //acxcp //lot no. -mfg and exp code change
        txtLotNumber := '';
        txtExpDate := '';
        //txtLotNo:='';
        txtMfgDate := '';
        recvalueentry1.RESET;
        recvalueentry1.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
        recvalueentry1.SETRANGE("Item No.", "Sales Invoice Line"."No.");
        recvalueentry1.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");//acxcp_28022022
        IF recvalueentry1.FIND('-') THEN BEGIN
            recILE.RESET;
            recILE.SETRANGE("Entry No.", recvalueentry1."Item Ledger Entry No.");
            recILE.SETRANGE("Item No.", recvalueentry1."Item No.");
            IF recILE.FIND('-') THEN BEGIN
                REPEAT
                    txtExpDate := FORMAT(recILE."Expiration Date");
                    //ExcelBuf.AddColumn(txtExpDate,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);//20
                    //txtData[8]:= FORMAT(ExpDate);
                    txtLotNumber := recILE."Lot No.";
                    //txtData[6]:= LotNumber;
                    Reclot.RESET;
                    Reclot.SETRANGE("Lot No.", recILE."Lot No.");
                    Reclot.SETRANGE("Item No.", recILE."Item No.");
                    IF Reclot.FIND('-') THEN BEGIN
                        txtMfgDate := FORMAT(Reclot."MFG Date");
                        //txtData[7]:= FORMAT(MFGDate);
                        ExcelBuf.AddColumn(txtMfgDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//19
                    END;
                    ExcelBuf.AddColumn(txtExpDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//20
                    ExcelBuf.AddColumn(FORMAT("Sales Invoice Line"."No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//6ACXLK
                UNTIL recILE.NEXT = 0
            END;
        END;

        //added due date
        txtData[12] := '';
        recsalesHeader.RESET;
        recsalesHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
        IF recsalesHeader.FINDSET THEN
            REPEAT
                txtData[12] := FORMAT(recsalesHeader."Due Date");
            UNTIL recsalesHeader.NEXT = 0;

        //acxcp_151122 //added round off
        dcRoundOff := 0;
        recSIL.RESET;
        recSIL.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
        recSIL.SETFILTER("System-Created Entry", '%1', TRUE);
        IF recSIL.FINDFIRST THEN BEGIN
            dcRoundOff := recSIL."Amount To Customer";
        END;

        //added Location State Code and Name
        txtData[13] := '';
        txtData[14] := '';
        recLoc.RESET;
        recLoc.SETRANGE(Code, "Sales Invoice Line"."Location Code");
        IF recLoc.FINDFIRST THEN BEGIN
            recstate.RESET;
            recstate.SETRANGE(Code, recLoc."State Code");
            IF recstate.FINDFIRST THEN BEGIN
                txtData[13] := recstate.Code;
                txtData[14] := recstate.Description;
            END;
        END;

        //acxcp_151122

        ExcelBuf.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//22
        ExcelBuf.AddColumn(ROUND("Sales Invoice Line"."Line Discount %", 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
        ExcelBuf.AddColumn("Sales Invoice Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//24
        ExcelBuf.AddColumn(dcRoundOff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//25
        ExcelBuf.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//26
        ExcelBuf.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//27
        ExcelBuf.AddColumn('Invoice', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//28



        //acxcp -
    end;

    [Scope('Internal')]
    procedure MakeExcelDataBody2()
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//1
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//2
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Shortcut Dimension 2 Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//3

        ValEntryLedNo := 0;
        RecValueEntry.RESET();
        RecValueEntry.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        RecValueEntry.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");
        IF RecValueEntry.FIND('-') THEN BEGIN
            ValEntryLedNo := RecValueEntry."Item Ledger Entry No.";
            recILE.RESET();
            recILE.SETRANGE("Entry No.", ValEntryLedNo);
            IF recILE.FIND('-') THEN BEGIN
                ExcelBuf.AddColumn(FORMAT(recILE."Lot No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//4
            END;
        END;

        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line".Description), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//5
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."No. of Loose Pack"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//6
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line".Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//7
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Line Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//8
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//9

        IF ("Sales Cr.Memo Line"."Units per Parcel" <> 0) AND ("Sales Cr.Memo Line"."Unit Price" <> 0) THEN
            ratelossepack := "Sales Cr.Memo Line"."Unit Price" / "Sales Cr.Memo Line"."Units per Parcel"
        ELSE
            ratelossepack := 0;

        ExcelBuf.AddColumn(FORMAT(ratelossepack), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//10
        Packvalue := ratelossepack;
        //Packvalue := "Sales Invoice Line"."Unit Price"/"Sales Invoice Line"."Units per Parcel";

        ExcelBuf.AddColumn(FORMAT(Packvalue + (Packvalue * "Sales Cr.Memo Line"."GST %") / 100), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//11

        IF "Sales Cr.Memo Line"."Units per Parcel" <> 0 THEN
            unitperpiece := "Sales Cr.Memo Line"."MRP Price" / "Sales Cr.Memo Line"."Units per Parcel"
        ELSE
            unitperpiece := 0;

        ExcelBuf.AddColumn(FORMAT(unitperpiece), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//12

        ExcelBuf.AddColumn(FORMAT('Sales'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//13

        RecsalesCrMemoHeader.RESET;
        RecsalesCrMemoHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
        IF RecsalesCrMemoHeader.FINDFIRST THEN BEGIN
            IF RecsalesCrMemoHeader."Ship-to Code" = '' THEN
                VarParty := RecsalesCrMemoHeader."Sell-to Customer Name"
            ELSE
                VarParty := RecsalesCrMemoHeader."Ship-to Name";
        END;
        ExcelBuf.AddColumn(FORMAT(VarParty), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //14

        RecsalesCrMemoHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
        IF RecsalesCrMemoHeader.FIND() THEN
            txtpostinggroup := RecsalesCrMemoHeader."Customer Posting Group";

        ExcelBuf.AddColumn(FORMAT(txtpostinggroup), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//15
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Shortcut Dimension 1 Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//16
        ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."Sell-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//17

        RecsalesCrMemoHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
        IF RecsalesCrMemoHeader.FIND() THEN
            txtshiptocode := RecsalesCrMemoHeader."Ship-to Code";

        ExcelBuf.AddColumn(FORMAT(txtshiptocode), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text); //18

        //acxcp //lot no. -mfg and exp code change
        txtLotNumber := '';
        txtExpDate := '';
        //txtLotNo:='';
        txtMfgDate := '';
        recvalueentry1.RESET;
        recvalueentry1.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        recvalueentry1.SETRANGE("Item No.", "Sales Cr.Memo Line"."No.");
        recvalueentry1.SETRANGE("Document Line No.", "Sales Cr.Memo Line"."Line No.");//acxcp_28122022
        IF recvalueentry1.FIND('-') THEN BEGIN
            recILE.RESET;
            recILE.SETRANGE("Entry No.", recvalueentry1."Item Ledger Entry No.");
            recILE.SETRANGE("Item No.", recvalueentry1."Item No.");
            IF recILE.FIND('-') THEN BEGIN
                REPEAT
                    txtExpDate := FORMAT(recILE."Expiration Date");
                    //ExcelBuf.AddColumn(txtExpDate,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);//20
                    //txtData[8]:= FORMAT(ExpDate);
                    txtLotNumber := recILE."Lot No.";
                    //txtData[6]:= LotNumber;
                    Reclot.RESET;
                    Reclot.SETRANGE("Lot No.", recILE."Lot No.");
                    Reclot.SETRANGE("Item No.", recILE."Item No.");
                    IF Reclot.FIND('-') THEN BEGIN
                        txtMfgDate := FORMAT(Reclot."MFG Date");
                        //txtData[7]:= FORMAT(MFGDate);
                        ExcelBuf.AddColumn(txtMfgDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//19
                    END;
                    ExcelBuf.AddColumn(txtExpDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);//20
                    ExcelBuf.AddColumn(FORMAT("Sales Cr.Memo Line"."No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//6ACXLK
                UNTIL recILE.NEXT = 0
            END;
        END;


        //added due date
        txtData[12] := '';
        RecsalesCrMemoHeader.RESET;
        RecsalesCrMemoHeader.SETRANGE("No.", "Sales Cr.Memo Line"."Document No.");
        IF RecsalesCrMemoHeader.FINDSET THEN
            REPEAT
                txtData[12] := FORMAT(RecsalesCrMemoHeader."Due Date");
            UNTIL RecsalesCrMemoHeader.NEXT = 0;

        //acxcp_151122 //added round off
        dcRoundOff := 0;
        recSCML.RESET;
        recSCML.SETRANGE("Document No.", "Sales Cr.Memo Line"."Document No.");
        recSCML.SETFILTER("System-Created Entry", '%1', TRUE);
        IF recSCML.FINDFIRST THEN BEGIN
            dcRoundOff := recSCML."Amount To Customer";
        END;

        //added Location State Code and Name
        txtData[13] := '';
        txtData[14] := '';
        recLoc.RESET;
        recLoc.SETRANGE(Code, "Sales Cr.Memo Line"."Location Code");
        IF recLoc.FINDFIRST THEN BEGIN
            recstate.RESET;
            recstate.SETRANGE(Code, recLoc."State Code");
            IF recstate.FINDFIRST THEN BEGIN
                txtData[13] := recstate.Code;
                txtData[14] := recstate.Description;
            END;
        END;

        //acxcp_151122

        ExcelBuf.AddColumn(txtData[12], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//22
        ExcelBuf.AddColumn(ROUND("Sales Cr.Memo Line"."Line Discount %", 0.01, '='), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//23
        ExcelBuf.AddColumn("Sales Cr.Memo Line"."Line Discount Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);//24
        ExcelBuf.AddColumn(dcRoundOff, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//25
        ExcelBuf.AddColumn(txtData[13], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//26
        ExcelBuf.AddColumn(txtData[14], FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//27
        ExcelBuf.AddColumn('Credit Memo', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);//28


        //acxcp -
    end;

    [Scope('Internal')]
    procedure CreateExcelBook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('', 'Sheet1', '', '', USERID);
        ERROR('');
    end;
}

