codeunit 50035 "Cod-80-Event"
{
    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  TableData "TDS Entry" = rim;
    procedure CheckCustBalance(RecSaleH: Record "Sales Header") dcCustBal: Decimal
    var
        recCustomer: Record Customer;
        dcBillAmt: Decimal;
        dcAbsCustBal: Decimal;
        dcCustCrBal: Decimal;
        dcCustDrBal: Decimal;
        recSalesLine: Record "Sales Line";
        Cu50200: Codeunit 50200;
        BillAmt: Decimal;
        a: Codeunit 80;
    begin
        IF RecSaleH."Campaign No." = '' THEN BEGIN
            recCustomer.RESET;
            recCustomer.SETRANGE("No.", RecSaleH."Sell-to Customer No.");
            IF recCustomer.FINDFIRST THEN BEGIN
                IF NOT ((recCustomer."Excludes Credit Limit Allow" = TRUE) OR (recCustomer."One Time Credit Pass Allow" = TRUE)) THEN BEGIN
                    recCustomer.CALCFIELDS("Balance (LCY)");
                    IF recCustomer."Balance (LCY)" < 0 THEN BEGIN
                        dcCustCrBal := ABS(recCustomer."Balance (LCY)");
                        dcCustBal := dcCustCrBal + recCustomer."Credit Limit (LCY)";
                    END ELSE BEGIN
                        dcCustDrBal := -(recCustomer."Balance (LCY)");
                        dcCustBal := dcCustDrBal + recCustomer."Credit Limit (LCY)";
                    END;
                    recSalesLine.RESET;
                    recSalesLine.SETRANGE("Document No.", RecSaleH."No.");
                    IF recSalesLine.FINDSET THEN
                        REPEAT
                            //dcBillAmt += (Cu50200.AmttoCustomerSalesLine(recSalesLine) + Cu50200.TotalGSTAmtLineSales(recSalesLine));
                            dcBillAmt += Cu50200.AmttoCustomerSalesLine(recSalesLine);
                        UNTIL recSalesLine.NEXT = 0;


                    //RecSaleH.CALCFIELDS("Amount to Customer");
                    //dcBillAmt:=RecSaleH."Amount to Customer";

                    //dcCustBal:=dcCustCrBal+recCustomer."Credit Limit (LCY)";
                    //dcCustBal:=dcCustDrBal+recCustomer."Credit Limit (LCY)";

                    BillAmt := ROUND(dcBillAmt, 1);
                    IF dcCustBal < dcBillAmt THEN
                        ERROR('Billing Amount : %1 is greater then Available Balance and Credit Balance : %2', dcBillAmt, dcCustBal)
                    ELSE
                        MESSAGE('CustomerBalance is %1,Bill Amount is %2', dcCustBal, dcBillAmt);
                    EXIT(dcCustBal);
                END;
            END;
        END;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    begin
        GLEntry."Location Code" := GenJournalLine."Location Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnAfterValidatePostingAndDocumentDate(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; ReplacePostingDate: Boolean; ReplaceDocumentDate: Boolean)
    var
        CustRec: Record Customer;
        CPGRec: Record "Customer Posting Group";
    begin
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            //ValidatBatchMRPOnSalesLine(Rec."No.");//KM240621
            ValidatUnitPriceOnSalesLine(SalesHeader."No.", SalesHeader."Posting Date");//KM280621
            CheckSameBatch(SalesHeader);//ACXCP_290722
        END;
        MasterValidation(SalesHeader);//KM
        if CustRec.Get(SalesHeader."Sell-to Customer No.") then begin
            if CPGRec.Get(CustRec."Customer Posting Group") then begin
                if not CPGRec."Multi-Lot Selection Allowed" then
                    CheckMultiLot(SalesHeader."No.");//KM
            end;
        end;
        //acxcp_300622_CampaignCode +
        CheckCampaign(SalesHeader);//acxcp_230921
        //acxcp_300622_CampaignCode -
    end;

    procedure ValidatUnitPriceOnSalesLine("DocNo.": Code[20]; Date: Date)
    var
        recSalesLine: Record "Sales Line";
        //recSalesPrice: Record "Sales Price";
        PriceListLineRec: Record "Price List Line";
    begin
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", "DocNo.");//dp
        recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
        IF recSalesLine.FINDFIRST THEN BEGIN
            REPEAT
                //->17783
                // recSalesPrice.RESET();
                // recSalesPrice.SETRANGE("Item No.", recSalesLine."No.");
                // recSalesPrice.SETFILTER("Ending Date", '%1|>=%2', 0D, Date);
                // recSalesPrice.SETRANGE("Starting Date", 0D, Date);
                // //recSalesPrice.SETRANGE("MRP Price", recSalesLine."MRP Price");    //Team-17783    Code commented as MRP Price not present in Sales Price Table.
                // recSalesPrice.SETRANGE("Unit Price", recSalesLine."Unit Price");
                // IF NOT recSalesPrice.FINDFIRST THEN
                //     ERROR('As per MRP Sales line unit price%1 not be find with sales price matrix against line No.%2', recSalesLine."Unit Price", recSalesLine."Line No.");
                //<-17783
                PriceListLineRec.Reset();
                PriceListLineRec.SetRange("Product No.", recSalesLine."No.");   //pp
                PriceListLineRec.SetFilter("Ending Date", '%1|>=%2', 0D, Date);
                PriceListLineRec.SETRANGE("Starting Date", 0D, Date);
                PriceListLineRec.SETRANGE("MRP Price", recSalesLine."MRP Price New");
                PriceListLineRec.SETRANGE("Unit Price", recSalesLine."Unit Price");
                IF NOT PriceListLineRec.FINDFIRST THEN
                    ERROR('As per MRP Sales line unit price %1 not be find with sales price matrix against line No. %2', recSalesLine."Unit Price", recSalesLine."Line No.");
            UNTIL recSalesLine.NEXT = 0;
        END;
    end;

    procedure CheckCampaign(SalesHeader: Record "Sales Header")
    var
        recSaleHeader: Record "Sales Header";
    begin
        recSaleHeader.RESET;
        recSaleHeader.SETRANGE("No.", SalesHeader."No.");
        recSaleHeader.SETFILTER("Document Type", '%1', SalesHeader."Document Type"::"Credit Memo");
        IF recSaleHeader.FINDFIRST THEN BEGIN
            recSaleHeader.TESTFIELD("Campaign No.", '');
        END;
    end;

    procedure CheckMultiLot("DocNo.": Code[20])
    var
        recResv: Record "Reservation Entry";
        Count: Integer;
        recSalesLine: Record "Sales Line";
        "SameLotNo.": Code[20];
    begin
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", "DocNo.");
        IF recSalesLine.FINDFIRST THEN BEGIN
            REPEAT
                Count := 0;
                recResv.RESET();
                recResv.SETRANGE("Source ID", recSalesLine."Document No.");
                recResv.SETRANGE("Source Ref. No.", recSalesLine."Line No.");
                IF recResv.FINDFIRST THEN BEGIN
                    REPEAT
                        Count += 1;
                    UNTIL recResv.NEXT = 0;
                END;
                IF Count > 1 THEN
                    ERROR('Multi lot selection not allowed against sales line No-%1 and Item No-%2.', recResv."Source Ref. No.", recResv."Item No.");
            UNTIL recSalesLine.NEXT = 0;
        END;
    end;

    procedure CheckSameBatch(SalesHeader: Record "Sales Header")
    var
        recReservationEntry: Record "Reservation Entry";
        recSalesLine: Record "Sales Line";
        LotNumber: Text;
        recRes2: Record "Reservation Entry";
        recSL2: Record "Sales Line";
        SalesHeader1: Record "Sales Header";
    begin
        LotNumber := '';
        SalesHeader1.RESET();
        SalesHeader1.SETRANGE("No.", SalesHeader."No.");
        IF SalesHeader1.FINDFIRST THEN BEGIN
            recSalesLine.RESET();
            recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
            IF recSalesLine.FINDFIRST THEN BEGIN
                recReservationEntry.RESET();
                recReservationEntry.SETFILTER("Source Type", '%1', 37);
                recReservationEntry.SETFILTER("Source Subtype", '%1', 1);
                recReservationEntry.SETRANGE("Source ID", recSalesLine."Document No.");
                //recReservationEntry.SETRANGE("Item No.",recSalesLine."No.");
                IF recReservationEntry.FINDSET THEN
                    REPEAT
                        //LotNumber:='';
                        recSL2.SETRANGE("Document No.", recReservationEntry."Source ID");
                        recSL2.SETRANGE("No.", recReservationEntry."Item No.");
                        IF recSL2.FINDSET THEN
                            REPEAT
                                LotNumber := '';
                                //recRes2.RESET();
                                recRes2.SETRANGE("Source ID", recSL2."Document No.");
                                recRes2.SETRANGE("Item No.", recReservationEntry."Item No.");
                                recRes2.SETRANGE("Lot No.", recReservationEntry."Lot No.");
                                IF recRes2.FINDSET THEN
                                    REPEAT
                                        IF LotNumber <> '' THEN BEGIN
                                            IF LotNumber = recRes2."Lot No." THEN BEGIN
                                                ERROR('The Item No.- %1 \has same Lot Numbers- %2', recRes2."Item No.", recRes2."Lot No.");
                                                //MESSAGE('The Item No.- %1 has same Lot Numbers- %2 ',recReservationEntry."Item No.",recReservationEntry."Lot No.");
                                            END;
                                        END ELSE BEGIN
                                            LotNumber += recRes2."Lot No.";
                                        END;
                                    UNTIL recRes2.NEXT = 0;
                            UNTIL recSL2.NEXT = 0;
                    UNTIL recReservationEntry.NEXT = 0;
                //  MESSAGE(LotNumber);
            END;
        END;
    end;

    procedure MasterValidation(SalesHeader: Record "Sales Header")
    var
        recsalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
    begin
        recsalesHeader.RESET();
        recsalesHeader.SETRANGE("No.", SalesHeader."No.");
        IF recsalesHeader.FINDFIRST THEN BEGIN
            recsalesHeader.TESTFIELD("Salesperson Code");//Sales Hierarchy
                                                         //070721E-Way Bill
            recsalesHeader.TESTFIELD("Sell-to Post Code");
            recsalesHeader.TESTFIELD("Bill-to Post Code");
            recsalesHeader.TESTFIELD("Sell-to City");
            recsalesHeader.TESTFIELD("Bill-to City");
            //recsalesHeader.TESTFIELD(Structure);  //Team-17783    Commented as Structure field is not present in BC in sales header table.
            IF recsalesHeader."Ship-to Code" <> '' THEN BEGIN
                recsalesHeader.TESTFIELD("Ship-to Post Code");
                recsalesHeader.TESTFIELD("Ship-to City");
            END;
            //070721E-Way Bill
        END;
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", recsalesHeader."No.");
        IF (recSalesLine.FINDFIRST) AND (recSalesLine.Type <> recSalesLine.Type::" ") THEN BEGIN
            REPEAT
                recSalesLine.TESTFIELD("Unit of Measure");
                recSalesLine.TESTFIELD("Unit Price");
                recSalesLine.TESTFIELD(Quantity);
            UNTIL recSalesLine.NEXT = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJnlLine."Finance Branch A/c Code" := SalesHeader."Finance Branch A/c Code";//ACX-anu
        //acxcp_30062022 + //Campaign Code flow to Gen jnl Line
        GenJnlLine."Campaign No." := SalesHeader."Campaign No.";
        //acxcp_30062022 -
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnAfterSetApplyToDocNo', '', false, false)]
    local procedure OnAfterSetApplyToDocNo(var GenJournalLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header")
    var
        recdim: Record "Dimension Value";
        recpaymentmethod: Record "Payment Method";
    begin
        if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Refund then begin
            SalesHeader.TESTFIELD("Shortcut Dimension 1 Code");
            IF SalesHeader."Branch Accounting" = TRUE THEN BEGIN
                SalesHeader.TESTFIELD("Finance Branch A/c Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Finance Branch A/c Code");
            END
            ELSE
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
            //HT  24022021+
            recdim.RESET();
            recdim.SETRANGE("Dimension Code", 'STATE');
            recdim.SETRANGE(Code, recpaymentmethod."Payment Method Branch");
            IF recdim.FINDFIRST THEN
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", recdim."STATE-FIN");
            //Acx_Anubha
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; WhseShip: Boolean; InvtPickPutaway: Boolean)
    begin
        //acxcp_300622_CampaignCode +
        SalesShptHeader."Campaign No." := SalesHeader."Campaign No.";//acxcp_300622_CampaignCode +
        //acxcp_300622_CampaignCode -
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; WhseShip: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; InvtPickPutaway: Boolean)
    begin
        SalesInvHeader."Campaign No." := SalesHeader."Campaign No.";//ACXCP_30062022 //Insert Campaign Code to Sale Inv Header
        SalesInvHeader."E-way Bill Part" := SalesInvHeader."E-way Bill Part"::Registered;//RK 05May22
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
    local procedure OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean)
    var
        EwayBillandEinvoice: Record "E-Way Bill & E-Invoice";
        Location: Record Location;
        Cust: Record Customer;
        CustLedgerEntryL: Record 21;
    begin
        //Team 7739 Start-
        CustLedgerEntryL.RESET;
        CustLedgerEntryL.SETRANGE("External Document No.", SalesInvHeader."Order No.");
        IF CustLedgerEntryL.FINDSET THEN
            REPEAT
                CustLedgerEntryL."External Document No." := SalesInvHeader."No.";
                CustLedgerEntryL.MODIFY;
            UNTIL CustLedgerEntryL.NEXT = 0;
        //Team 7739 End-
        //HT
        //ACX-RK 210421 Begin
        EwayBillandEinvoice.INIT;
        EwayBillandEinvoice."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        EwayBillandEinvoice."No." := SalesInvHeader."No.";
        EwayBillandEinvoice."Ship-to Code" := SalesInvHeader."Ship-to Code";
        EwayBillandEinvoice."Posting Date" := SalesInvHeader."Posting Date";
        EwayBillandEinvoice."Location Code" := SalesInvHeader."Location Code";
        EwayBillandEinvoice."Sell-to Customer Name" := SalesInvHeader."Sell-to Customer Name";
        EwayBillandEinvoice."Sell-to Address" := SalesInvHeader."Sell-to Address";
        EwayBillandEinvoice."Sell-to Address 2" := SalesInvHeader."Sell-to Address 2";
        EwayBillandEinvoice."Sell-to City" := SalesInvHeader."Sell-to City";
        EwayBillandEinvoice."Sell-to Post Code" := SalesInvHeader."Sell-to Post Code";
        EwayBillandEinvoice.State := SalesInvHeader.State;
        EwayBillandEinvoice."LR/RR No." := SalesInvHeader."LR/RR No.";
        EwayBillandEinvoice."LR/RR Date" := SalesInvHeader."LR/RR Date";
        EwayBillandEinvoice."Vehicle No." := SalesInvHeader."Vehicle No.";
        EwayBillandEinvoice."Mode of Transport" := SalesInvHeader."Mode of Transport";
        EwayBillandEinvoice."Location State Code" := SalesInvHeader."Location State Code";
        //  EwayBillandEinvoice."Port Code" := SalesInvHeader."Port Code";
        EwayBillandEinvoice."Transporter Code" := SalesInvHeader."Transporter Code";
        EwayBillandEinvoice."E-way Bill Part" := EwayBillandEinvoice."E-way Bill Part"::Registered;//RK 05May22

        IF SalesInvHeader."Vehicle Type" = SalesInvHeader."Vehicle Type"::" " THEN BEGIN
            EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::" ";
        END ELSE
            IF SalesInvHeader."Vehicle Type" = SalesInvHeader."Vehicle Type"::ODC THEN BEGIN
                EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::"over dimensional cargo";
            END ELSE
                IF SalesInvHeader."Vehicle Type" = SalesInvHeader."Vehicle Type"::Regular THEN BEGIN
                    EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::regular;
                END;

        IF SalesInvHeader."Location Code" = '' THEN BEGIN
            EwayBillandEinvoice."Location GST Reg. No." := '';
        END ELSE BEGIN
            Location.GET(SalesInvHeader."Location Code");
            EwayBillandEinvoice."Location GST Reg. No." := Location."GST Registration No.";
        END;

        IF Cust.GET(SalesInvHeader."Sell-to Customer No.") THEN BEGIN
            IF NOT (SalesHeader."GST Customer Type" IN ["GST Customer Type"::Export]) THEN
                EwayBillandEinvoice."Customer GST Reg. No." := Cust."GST Registration No.";
        END;

        EwayBillandEinvoice."Sell-to Country/Region Code" := SalesInvHeader."Sell-to Country/Region Code";
        EwayBillandEinvoice."Ship-to Post Code" := SalesInvHeader."Ship-to Post Code";
        EwayBillandEinvoice."Ship-to Country/Region Code" := SalesInvHeader."Ship-to Country/Region Code";
        EwayBillandEinvoice."Ship-to City" := SalesInvHeader."Ship-to City";
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::" " then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::" ";
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::"Deemed Export" then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::"Deemed Export";
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Exempted then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Exempted;
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Export then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Export;
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Registered then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Registered;
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::"SEZ Development" then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::"SEZ Development";
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::"SEZ Unit" then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::"SEZ Unit";
        if SalesInvHeader."GST Customer Type" = SalesInvHeader."GST Customer Type"::Unregistered then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Unregistered;

        EwayBillandEinvoice."Transaction Type" := 'Sales Invoice';
        EwayBillandEinvoice."Transporter GSTIN" := SalesHeader."Transporter GSTIN";//ACX-RK 220521
        EwayBillandEinvoice.VALIDATE("Responsibility Center", SalesInvHeader."Responsibility Center");//KM
        EwayBillandEinvoice.INSERT;
        //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
        //
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var SalesInvHeader: Record "Sales Invoice Header")
    begin
        //acxcp_300622_CampaignCode +
        SalesCrMemoHeader."Campaign No." := SalesHeader."Campaign No.";
        //acxcp_300622_CampaignCode -
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfterSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        EwayBillandEinvoice: Record "E-Way Bill & E-Invoice";
        Location: Record Location;
        Cust: Record Customer;
    begin
        //ACX-RK 210421 Begin
        EwayBillandEinvoice.INIT;
        EwayBillandEinvoice."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
        EwayBillandEinvoice."No." := SalesCrMemoHeader."No.";
        EwayBillandEinvoice."Ship-to Code" := SalesCrMemoHeader."Ship-to Code";
        EwayBillandEinvoice."Posting Date" := SalesCrMemoHeader."Posting Date";
        EwayBillandEinvoice."Location Code" := SalesCrMemoHeader."Location Code";
        EwayBillandEinvoice."Sell-to Customer Name" := SalesCrMemoHeader."Sell-to Customer Name";
        EwayBillandEinvoice."Sell-to Address" := SalesCrMemoHeader."Sell-to Address";
        EwayBillandEinvoice."Sell-to Address 2" := SalesCrMemoHeader."Sell-to Address 2";
        EwayBillandEinvoice."Sell-to City" := SalesCrMemoHeader."Sell-to City";
        EwayBillandEinvoice."Sell-to Post Code" := SalesCrMemoHeader."Sell-to Post Code";
        EwayBillandEinvoice.State := SalesCrMemoHeader.State;
        //EwayBillandEinvoice."LR/RR No." := SalesCrMemoHeader."LR/RR No.";
        //EwayBillandEinvoice."LR/RR Date" := SalesCrMemoHeader."LR/RR Date";
        EwayBillandEinvoice."Vehicle No." := SalesCrMemoHeader."Vehicle No.";
        //EwayBillandEinvoice."Mode of Transport" := SalesCrMemoHeader."Mode of Transport";
        EwayBillandEinvoice."Location State Code" := SalesCrMemoHeader."Location State Code";
        //  EwayBillandEinvoice."Port Code" := SalesCrMemoHeader."Port Code";
        EwayBillandEinvoice."Transporter Code" := SalesCrMemoHeader."Transporter Code";

        IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::" " THEN BEGIN
            EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::" ";
        END ELSE
            IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::ODC THEN BEGIN
                EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::"over dimensional cargo";
            END ELSE
                IF SalesCrMemoHeader."Vehicle Type" = SalesCrMemoHeader."Vehicle Type"::Regular THEN BEGIN
                    EwayBillandEinvoice."Vehicle Type" := EwayBillandEinvoice."Vehicle Type"::regular;
                END;

        IF SalesCrMemoHeader."Location Code" = '' THEN BEGIN
            EwayBillandEinvoice."Location GST Reg. No." := '';
        END ELSE BEGIN
            Location.GET(SalesCrMemoHeader."Location Code");
            EwayBillandEinvoice."Location GST Reg. No." := Location."GST Registration No.";
        END;

        IF Cust.GET(SalesCrMemoHeader."Sell-to Customer No.") THEN BEGIN
            IF NOT (SalesCrMemoHeader."GST Customer Type" IN ["GST Customer Type"::Export]) THEN
                EwayBillandEinvoice."Customer GST Reg. No." := Cust."GST Registration No.";
        END;

        EwayBillandEinvoice."Sell-to Country/Region Code" := SalesCrMemoHeader."Sell-to Country/Region Code";
        EwayBillandEinvoice."Ship-to Post Code" := SalesCrMemoHeader."Ship-to Post Code";
        EwayBillandEinvoice."Ship-to Country/Region Code" := SalesCrMemoHeader."Ship-to Country/Region Code";
        EwayBillandEinvoice."Ship-to City" := SalesCrMemoHeader."Ship-to City";
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::" " then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::" ";
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::"Deemed Export" then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::"Deemed Export";
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Exempted then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Exempted;
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Export then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Export;
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Registered then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Registered;
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::"SEZ Development" then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::"SEZ Development";
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::"SEZ Unit" then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::"SEZ Unit";
        if SalesCrMemoHeader."GST Customer Type" = SalesCrMemoHeader."GST Customer Type"::Unregistered then
            EwayBillandEinvoice."GST Customer Type" := EwayBillandEinvoice."GST Customer Type"::Unregistered;
        EwayBillandEinvoice."Transaction Type" := 'Sales Credit Memo';
        EwayBillandEinvoice.VALIDATE("Responsibility Center", SalesCrMemoHeader."Responsibility Center");//KM
        EwayBillandEinvoice.INSERT;
        //HT 24082020 (For E-Way Bill and E-Invoice Integration)+
        //
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforeInsertInvoiceLine', '', false, false)]
    local procedure OnPostSalesLineOnBeforeInsertInvoiceLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; SalesInvHeader: Record "Sales Invoice Header"; var ShouldInsertInvoiceLine: Boolean)
    begin
        //KM180621 Scheme
        InsertSchemeonInvoice(SalesHeader."No.", SalesInvHeader."No.");
        //KM180621 Scheme
    end;

    procedure InsertSchemeonInvoice("OrderNo.": Code[20]; "PostInvNo.": Code[20])
    var
        recSalesLinCalc: Record "Sales Line Scheme Calculation";
        InsSalesLineCalc: Record "Posted SalesLine Sch. Cal.";
    begin
        recSalesLinCalc.RESET();
        recSalesLinCalc.SETRANGE("Document No.", "OrderNo.");
        IF recSalesLinCalc.FIND('-') THEN BEGIN
            REPEAT
                InsSalesLineCalc.INIT();
                InsSalesLineCalc."Document No." := "PostInvNo.";
                InsSalesLineCalc."Document Line No." := recSalesLinCalc."Document Line No.";
                InsSalesLineCalc."Tax Charge Code" := recSalesLinCalc."Tax Charge Code";
                InsSalesLineCalc.VALIDATE("Scheme Code", recSalesLinCalc."Scheme Code");
                InsSalesLineCalc."Scheme Date" := recSalesLinCalc."Scheme Date";
                InsSalesLineCalc."Start Date" := recSalesLinCalc."Start Date";
                InsSalesLineCalc."End Date" := recSalesLinCalc."End Date";
                InsSalesLineCalc.VALIDATE("Item No.", recSalesLinCalc."Item No.");
                InsSalesLineCalc."Item Name" := recSalesLinCalc."Item Name";
                InsSalesLineCalc.VALIDATE("Scheme Calculation Type", recSalesLinCalc."Scheme Calculation Type");
                InsSalesLineCalc.VALIDATE(Type, recSalesLinCalc.Type);
                InsSalesLineCalc.VALIDATE(Code, recSalesLinCalc.Code);
                InsSalesLineCalc."Line Discount" := recSalesLinCalc."Line Discount";
                InsSalesLineCalc."Minimum Quantity" := recSalesLinCalc."Minimum Quantity";
                InsSalesLineCalc."Line Quantity" := recSalesLinCalc."Line Quantity";
                InsSalesLineCalc."Line Amount" := recSalesLinCalc."Line Amount";
                InsSalesLineCalc."Discount Amount" := recSalesLinCalc."Discount Amount";
                InsSalesLineCalc.VALIDATE("Free Item Code", recSalesLinCalc."Free Item Code");
                InsSalesLineCalc.VALIDATE("OrderPriority Scheme", recSalesLinCalc."OrderPriority Scheme");
                InsSalesLineCalc.INSERT(TRUE);
            UNTIL recSalesLinCalc.NEXT = 0;
        END;
    end;

    procedure ValidatBatchMRPOnSalesLine("DocNo.": Code[20])
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        LotNoInfo: Record "Lot No. Information";
        recItemTrack: Record "Reservation Entry";
        LotMRP: Decimal;
    begin
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", "DocNo.");
        recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
        IF recSalesLine.FINDFIRST THEN BEGIN
            REPEAT
                recItemTrack.RESET();
                LotMRP := 0;
                recItemTrack.SETRANGE("Source ID", recSalesLine."Document No.");
                recItemTrack.SETRANGE("Source Ref. No.", recSalesLine."Line No.");
                recItemTrack.SETRANGE("Item No.", recSalesLine."No.");
                IF recItemTrack.FINDFIRST THEN BEGIN
                    REPEAT
                        LotNoInfo.RESET();
                        LotNoInfo.SETRANGE("Item No.", recItemTrack."Item No.");
                        LotNoInfo.SETRANGE("Lot No.", recItemTrack."Lot No.");
                        IF LotNoInfo.FINDFIRST THEN BEGIN
                            LotNoInfo.TESTFIELD("Batch MRP");
                            IF (LotMRP <> 0) AND (LotMRP <> LotNoInfo."Batch MRP") THEN
                                ERROR('Both batch MRP are not matched against line No.%1, Item No.%2', recSalesLine."Line No.", recSalesLine."No.");
                            LotMRP := LotNoInfo."Batch MRP";
                        END;
                    UNTIL recItemTrack.NEXT = 0;
                END;
                recSalesLine.TESTFIELD("Unit Price");
            UNTIL recSalesLine.NEXT = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    begin
        RollBackOneTimeCredit(SalesHeader."Sell-to Customer No.")//KM080721
    end;

    procedure RollBackOneTimeCredit("CustNo.": Code[20])
    var
        recCustomer: Record Customer;
    begin
        recCustomer.RESET();
        recCustomer.SETRANGE("No.", "CustNo.");
        IF (recCustomer.FINDFIRST) AND (recCustomer."One Time Credit Pass Allow" = TRUE) THEN BEGIN
            recCustomer."One Time Credit Pass Allow" := FALSE;
            recCustomer.MODIFY();
        END;
    end;

    procedure UpdateSchemeCode(fromDate: Date; toDate: Date; SIH: Record "Sales Invoice Header")
    var
        recSIH: Record "Sales Invoice Header";
        recSIL: Record "Sales Invoice Line";
    begin
        recSIH.RESET;
        recSIH.SETRANGE("No.", SIH."No.");
        recSIH.SETFILTER("Posting Date", '%1..%2', fromDate, toDate);
        IF recSIH.FINDSET THEN
            REPEAT
                SIH."Scheme Code" := 'PFEB25-31MAR';
                SIH.MODIFY;
                recSIL.RESET;
                recSIL.SETRANGE("Document No.", recSIH."No.");
                recSIL.SETFILTER(Type, '%1', recSIL.Type::Item);
                IF recSIL.FINDSET THEN
                    REPEAT
                        recSIL."Scheme Code" := 'PFEB25-31MAR';
                        recSIL.MODIFY;
                    UNTIL recSIL.NEXT = 0;
            UNTIL recSIH.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        recdim: Record "Dimension Value";
        recpaymentmethod: Record "Payment Method";
    begin
        GenJournalLine."Finance Branch A/c Code" := SalesHeader."Finance Branch A/c Code";//ACX-anu
    end;

    [EventSubscriber(ObjectType::Codeunit, 825, 'OnPostBalancingEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostBalancingEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header")
    var
        recdim: Record "Dimension Value";
        recpaymentmethod: Record "Payment Method";
    begin
        SalesHeader.TESTFIELD("Shortcut Dimension 1 Code");
        IF SalesHeader."Branch Accounting" = TRUE THEN BEGIN
            SalesHeader.TESTFIELD("Finance Branch A/c Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Finance Branch A/c Code");
        END
        ELSE
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
        //HT  24022021+
        recdim.RESET();
        recdim.SETRANGE("Dimension Code", 'STATE');
        recdim.SETRANGE(Code, recpaymentmethod."Payment Method Branch");
        IF recdim.FINDFIRST THEN
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", recdim."STATE-FIN");
    END;//Acx_Anubha
}
