report 50016 "FSC Data Export To Excel"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                WHERE(Type = FILTER(Item),
                                      Quantity = FILTER(<> 0));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                //16767 Start Code New Add
                CLEAR(vCGSTRate);
                CLEAR(vSGSTRate);
                CLEAR(vIGSTRate);
                DetailGSTEntry.RESET;
                DetailGSTEntry.SETCURRENTKEY("Document No.", "Document Line No.", "GST Component Code");
                DetailGSTEntry.SETRANGE("Document No.", "Document No.");
                DetailGSTEntry.SETRANGE("No.", "No.");
                DetailGSTEntry.SetRange("Document Line No.", "Line No.");
                IF DetailGSTEntry.FINDSET THEN
                    REPEAT
                        IF DetailGSTEntry."GST Component Code" = 'CGST' THEN BEGIN
                            vCGSTRate := DetailGSTEntry."GST %";
                        END;
                        IF DetailGSTEntry."GST Component Code" = 'SGST' THEN BEGIN
                            vSGSTRate := DetailGSTEntry."GST %";
                        END;
                        IF DetailGSTEntry."GST Component Code" = 'IGST' THEN BEGIN
                            vIGSTRate := DetailGSTEntry."GST %";
                        END;

                    UNTIL DetailGSTEntry.NEXT = 0;
                GstPer := vCGSTRate + vSGSTRate + vIGSTRate;
                //16767  New Code End

                intRowNo := intRowNo + 1;
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);//1
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//2
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Shortcut Dimension 2 Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//3
                RecValueEntry.RESET();
                RecValueEntry.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                RecValueEntry.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                IF RecValueEntry.FIND('-') THEN BEGIN
                    ValEntryLedNo := RecValueEntry."Item Ledger Entry No.";
                    recILE.RESET();
                    recILE.SETRANGE("Entry No.", ValEntryLedNo);
                    IF recILE.FIND('-') THEN BEGIN
                        ExcelBuffer.AddColumn(FORMAT(recILE."Lot No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//4
                    END;
                END;
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line".Description), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//5
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."No. of Loose Pack"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//6

                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line".Quantity), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//7
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Line Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//8
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Unit Price"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//9
                IF ("Sales Invoice Line"."Units per Parcel" <> 0) AND ("Sales Invoice Line"."Unit Price" <> 0) THEN
                    ratelossepack := "Sales Invoice Line"."Unit Price" / "Sales Invoice Line"."Units per Parcel"
                ELSE
                    ratelossepack := 0;
                ExcelBuffer.AddColumn(FORMAT(ratelossepack), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//10
                Packvalue := ratelossepack;
                //Packvalue := "Sales Invoice Line"."Unit Price"/"Sales Invoice Line"."Units per Parcel";
                //ExcelBuffer.AddColumn(FORMAT(Packvalue + (Packvalue * "Sales Invoice Line"."GST %") / 100), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//11
                ExcelBuffer.AddColumn(FORMAT(Packvalue + (Packvalue * GSTPer) / 100), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//11

                IF "Sales Invoice Line"."Units per Parcel" <> 0 THEN
                    unitperpiece := "Sales Invoice Line"."MRP Price" / "Sales Invoice Line"."Units per Parcel"
                ELSE
                    unitperpiece := 0;
                ExcelBuffer.AddColumn(FORMAT(unitperpiece), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//12

                ExcelBuffer.AddColumn(FORMAT('Sales'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//13
                RecsalesInvHeader.RESET;
                RecsalesInvHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF RecsalesInvHeader.FINDFIRST THEN BEGIN
                    IF RecsalesInvHeader."Ship-to Code" = '' THEN
                        VarParty := RecsalesInvHeader."Sell-to Customer Name"
                    ELSE
                        VarParty := RecsalesInvHeader."Ship-to Name";
                END;
                ExcelBuffer.AddColumn(FORMAT(VarParty), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //14
                RecsalesInvHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF RecsalesInvHeader.FIND() THEN
                    txtpostinggroup := RecsalesInvHeader."Customer Posting Group";
                ExcelBuffer.AddColumn(FORMAT(txtpostinggroup), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//15
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Shortcut Dimension 1 Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//16
                ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."Sell-to Customer No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//17
                RecsalesInvHeader.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                IF RecsalesInvHeader.FIND() THEN
                    txtshiptocode := RecsalesInvHeader."Ship-to Code";
                ExcelBuffer.AddColumn(FORMAT(txtshiptocode), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //18
                                                                                                                                 /*
                                                                                                                                 recILE.RESET;
                                                                                                                                 recILE.SETRANGE("Source No.","Sales Invoice Line"."Sell-to Customer No.");
                                                                                                                                 recILE.SETRANGE("Document Line No.","Sales Invoice Line"."Line No.");
                                                                                                                                 IF recILE.FINDFIRST THEN BEGIN
                                                                                                                                 recLotInfo.RESET();
                                                                                                                                 recLotInfo.SETRANGE("Item No.",recILE."Item No.");
                                                                                                                                 recLotInfo.SETRANGE("Lot No.",recILE."Lot No.");
                                                                                                                                 IF recLotInfo.FIND('-') THEN BEGIN
                                                                                                                                   ExcelBuffer.AddColumn(FORMAT(recLotInfo."MFG Date" ),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);//19
                                                                                                                                   ExcelBuffer.AddColumn(FORMAT(recLotInfo."Expiration Date"),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);//20
                                                                                                                                   END;
                                                                                                                                 END;
                                                                                                                                 */

                //acxcp //lot no. -mfg and exp code change
                txtLotNumber := '';
                txtExpDate := '';
                //txtLotNo:='';
                txtMfgDate := '';
                recvalueentry1.RESET;
                recvalueentry1.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                recvalueentry1.SETRANGE("Item No.", "Sales Invoice Line"."No.");
                recvalueentry1.SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");//acxcp_281222 // line added
                IF recvalueentry1.FIND('-') THEN BEGIN
                    recILE.RESET;
                    recILE.SETRANGE("Entry No.", recvalueentry1."Item Ledger Entry No.");
                    recILE.SETRANGE("Item No.", recvalueentry1."Item No.");
                    IF recILE.FIND('-') THEN BEGIN
                        REPEAT
                            //txtExpDate:= FORMAT(recILE."Expiration Date");//acxcp_281222 // line commented
                            //ExcelBuffer.AddColumn(txtExpDate,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);//20
                            //txtData[8]:= FORMAT(ExpDate);
                            txtLotNumber := recILE."Lot No.";
                            //txtData[6]:= LotNumber;
                            Reclot.RESET;
                            Reclot.SETRANGE("Item No.", recILE."Item No.");
                            Reclot.SETRANGE("Lot No.", recILE."Lot No.");
                            IF Reclot.FIND('-') THEN BEGIN
                                txtMfgDate := FORMAT(Reclot."MFG Date");
                                txtExpDate := FORMAT(Reclot."Expiration Date");//acxcp_281222 // line added
                                                                               //txtData[7]:= FORMAT(MFGDate);
                                ExcelBuffer.AddColumn(txtMfgDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);//19
                                ExcelBuffer.AddColumn(txtExpDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);//20
                            END;
                            ExcelBuffer.AddColumn(FORMAT("Sales Invoice Line"."No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);//6ACXLK
                        UNTIL recILE.NEXT = 0
                    END;
                END;


                //acxcp
                /*
                //Lot No Information................................................................................................//ACX_LK
                LotNumber :='';
                txtData[8]:='';
                txtData[6]:='';
                txtData[7]:='';
                recvalueentry.RESET;
                recvalueentry.SETRANGE("Document No.","Sales Invoice Line"."Document No.");
                recvalueentry.SETRANGE("Item No.","Sales Invoice Line"."No.");
                IF recvalueentry.FIND('-') THEN BEGIN
                   recile.RESET;
                   recile.SETRANGE("Entry No.",recvalueentry."Item Ledger Entry No.");
                   recile.SETRANGE("Item No.",recvalueentry."Item No.");
                  IF recile.FINDFIRST THEN BEGIN
                     ExpDate := recile."Expiration Date";
                     txtData[8]:= FORMAT(ExpDate);
                     LotNumber :=recile."Lot No.";
                     txtData[6]:= LotNumber;
                      Reclot.RESET;
                      Reclot.SETRANGE("Lot No.",recile."Lot No.");
                      Reclot.SETRANGE("Item No.",recile."Item No.");
                      IF Reclot.FINDFIRST THEN BEGIN
                         MFGDate := Reclot."MFG Date";
                         txtData[7]:= FORMAT(MFGDate);
                    END;
                  END;
                END;
                */

            end;

            trigger OnPreDataItem()
            begin
                IF UserSetup.GET(USERID) THEN BEGIN
                    IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                        "Sales Invoice Line".SETFILTER("Responsibility Center", '%1', UserSetup."Sales Resp. Ctr. Filter");
                END;
                ExcelBuffer.NewRow;

                ExcelBuffer.AddColumn('INVOICE_DT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//1
                ExcelBuffer.AddColumn('INVOICE_NO', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//2
                ExcelBuffer.AddColumn('WAREHOUSE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//3
                ExcelBuffer.AddColumn('BATCH', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//4
                ExcelBuffer.AddColumn('PRODUCT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//5
                ExcelBuffer.AddColumn('NO_OF_LOOSE_PACK', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//6
                ExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//7
                ExcelBuffer.AddColumn('AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//8
                ExcelBuffer.AddColumn('BILLING_RATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//9
                ExcelBuffer.AddColumn('RATE_LOOSE_PACK', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//10
                ExcelBuffer.AddColumn('RATE_LOOSE_PACK_INCL_GST', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//11
                ExcelBuffer.AddColumn('MRP_PER_PIECE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//12
                ExcelBuffer.AddColumn('DATA_TYPE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//13
                ExcelBuffer.AddColumn('PARTY', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//14
                ExcelBuffer.AddColumn('PARTY_TYPE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//15
                ExcelBuffer.AddColumn('BRANCH', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//16
                ExcelBuffer.AddColumn('VAN', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//17
                ExcelBuffer.AddColumn('FSC_CODE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//18
                ExcelBuffer.AddColumn('MFGDATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//19
                ExcelBuffer.AddColumn('EXPIRYDATE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//20
                ExcelBuffer.AddColumn('PRODUCT CODE', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);//4ACXLK
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

    trigger OnPostReport()
    begin
        //ExcelBuffer.CreateBookAndOpenExcel('', 'Sheet 1', 'Report', COMPANYNAME, USERID);
        ExcelBuffer.CreateNewBook('Sheet 1');
        ExcelBuffer.WriteSheet('Report', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook;
        ExcelBuffer.OpenExcel;
    end;

    trigger OnPreReport()
    begin
        intRowNo := 1;
    end;

    var
        intRowNo: Integer;
        ExcelBuffer: Record 370 temporary;
        recILE: Record 32;
        recItemLed: Record 32;
        RecValueEntry: Record 5802;
        ValEntryLedNo: Integer;
        Packvalue: Decimal;
        recLotInfo: Record 6505;
        RecsalesInvHeader: Record 112;
        VarParty: Text;
        txtpostinggroup: Text;
        txtshiptocode: Text;
        unitperpiece: Decimal;
        ratelossepack: Decimal;
        txtExpDate: Text;
        txtMfgDate: Text;
        txtLotNo: Text;
        txtLotNumber: Text;
        recvalueentry1: Record 5802;
        Reclot: Record 6505;
        UserSetup: Record 91;
        vCGSTRate: Decimal;
        vSGSTRate: Decimal;
        vIGSTRate: Decimal;
        DetailGSTEntry: Record "Detailed GST Ledger Entry";
        GstPer: Decimal;
}