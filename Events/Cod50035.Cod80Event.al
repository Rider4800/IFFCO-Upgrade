codeunit 50035 "Cod-80-Event"
{
    procedure CheckCustBalance(RecSaleH: Record "Sales Header") dcCustBal: Decimal
    var
        recCustomer: Record Customer;
        dcBillAmt: Decimal;
        dcAbsCustBal: Decimal;
        dcCustCrBal: Decimal;
        dcCustDrBal: Decimal;
        recSalesLine: Record "Sales Line";
        Cu50200: Codeunit 50200;
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
                            dcBillAmt += (Cu50200.AmttoCustomerSalesLine(recSalesLine) + Cu50200.TotalGSTAmtLineSales(recSalesLine));
                        UNTIL recSalesLine.NEXT = 0;


                    //RecSaleH.CALCFIELDS("Amount to Customer");
                    //dcBillAmt:=RecSaleH."Amount to Customer";

                    //dcCustBal:=dcCustCrBal+recCustomer."Credit Limit (LCY)";
                    //dcCustBal:=dcCustDrBal+recCustomer."Credit Limit (LCY)";

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
    begin
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            //ValidatBatchMRPOnSalesLine(Rec."No.");//KM240621
            ValidatUnitPriceOnSalesLine(SalesHeader."No.", SalesHeader."Posting Date");//KM280621
            CheckSameBatch(SalesHeader);//ACXCP_290722
        END;
        MasterValidation(SalesHeader);//KM
        CheckMultiLot(SalesHeader."No.");//KM
        //acxcp_300622_CampaignCode +
        CheckCampaign(SalesHeader);//acxcp_230921
        //acxcp_300622_CampaignCode -
    end;

    procedure ValidatUnitPriceOnSalesLine("DocNo.": Code[20]; Date: Date)
    var
        recSalesLine: Record "Sales Line";
        recSalesPrice: Record "Sales Price";
    begin
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", "DocNo.");
        recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
        IF recSalesLine.FINDFIRST THEN BEGIN
            REPEAT
                recSalesPrice.RESET();
                recSalesPrice.SETRANGE("Item No.", recSalesLine."No.");
                recSalesPrice.SETFILTER("Ending Date", '%1|>=%2', 0D, Date);
                recSalesPrice.SETRANGE("Starting Date", 0D, Date);
                //recSalesPrice.SETRANGE("MRP Price", recSalesLine."MRP Price");    //Team-17783    Code commented as MRP Price not present in Sales Price Table.
                recSalesPrice.SETRANGE("Unit Price", recSalesLine."Unit Price");
                IF NOT recSalesPrice.FINDFIRST THEN
                    ERROR('As per MRP Sales line unit price%1 not be find with sales price matrix against line No.%2', recSalesLine."Unit Price", recSalesLine."Line No.");
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
        s: Codeunit 80;
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
}
