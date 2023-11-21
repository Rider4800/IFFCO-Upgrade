pageextension 50109 pageextension50109 extends "Sales Order List"
{
    // //acxcp_28102022 - //campaign code validation check
    layout
    {
        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify("Sell-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }
        modify("Bill-to Post Code")
        {
            Visible = false;
        }
        modify("Bill-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        modify("Ship-to Post Code")
        {
            Visible = false;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Shipping Advice")
        {
            Visible = false;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify("Job Queue Status")
        {
            Visible = false;
        }
        addafter(Status)
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
            }
        }
        moveafter(Control1; "Document Date")
        moveafter("Document Date"; "Posting Date")
        moveafter("Ship-to Name"; "Salesperson Code")
        moveafter("Salesperson Code"; "Location Code")
        moveafter("Location Code"; Status)
    }
    actions
    {

        modify(Post)
        {
            Visible = false;
        }
        addbefore(PostAndSend)
        {
            action(PostNew)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    Cu50200: Codeunit 50200;
                    cuSalePost: Codeunit 50035;
                    FindGenJournalLine: Record 81;
                    InsertGenJournalLine: Record 81;
                    OpenGenJournalLine: Record 81;
                    LineNo: Integer;
                    AmountL: Decimal;
                    ParentCustomerL: Record 18;
                    BalanceL: Decimal;
                    NoSeriesL: Code[20];
                    CustomerL: Record 18;
                    BalanceCheckL: Decimal;
                    CustDebitAmtBal: Decimal;
                    InsertJournalNara: Record "Gen. Journal Narration";
                    InsertJournalNara1: Record "Gen. Journal Narration";
                    VouNaration: Text;
                    VouNaration1: Text;
                    InsertJournalNara2: Record "Gen. Journal Narration";
                begin
                    //->Ramesh G commented this code in NAV while EBazar modification
                    // //ACXCP_10012023 << //Credit Balance Check

                    // recSaleL.RESET;
                    // recSaleL.SETRANGE("Document No.", Rec."No.");
                    // IF recSaleL.FINDSET THEN
                    //     REPEAT
                    //         recSaleL.CalculateStructures(Rec);
                    //     UNTIL recSaleL.NEXT = 0;

                    // cuSalePost.CheckCustBalance(Rec);

                    // //ACXCP_10012023 << //Credit Balance Check

                    // //acxcp_28102022 - //campaign code validation check
                    // TotalAmt := 0;
                    // IF Rec."Campaign No." <> '' THEN BEGIN
                    //     TotalAmt := 0;
                    //     recSaleL.RESET;
                    //     recSaleL.SETRANGE("Document No.", Rec."No.");
                    //     IF recSaleL.FINDFIRST THEN BEGIN
                    //         REPEAT
                    //             TotalAmt += recSaleL."Amount To Customer";
                    //         UNTIL recSaleL.NEXT = 0;
                    //         BalAmt := 0;
                    //         recCust.RESET;
                    //         recCust.SETRANGE("No.", recSaleL."Sell-to Customer No.");
                    //         IF recCust.FINDFIRST THEN BEGIN
                    //             recCust.CALCFIELDS("Balance (LCY)");
                    //             BalAmt := recCust."Balance (LCY)";
                    //             AbsBalAmt := 0;
                    //             IF BalAmt < 0 THEN
                    //                 AbsBalAmt := ABS(BalAmt);
                    //             IF NOT (AbsBalAmt >= TotalAmt) THEN BEGIN
                    //                 MESSAGE('Customer balance is - %1', FORMAT(ABS(BalAmt)));
                    //                 ERROR('Amount to Customer is lower then Available Credit Balance for Super Cash. Customer Balance= %1 and Invoice Amount -%2', AbsBalAmt, TotalAmt);
                    //             END;
                    //         END;
                    //     END;
                    // END;
                    // //acxcp_28102022 + //campaign code
                    // //ACXVG
                    // IF NOT CONFIRM('Do You Want To Preview Before Post') THEN BEGIN
                    //     //acxcp_30122022 >>
                    //     SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
                    // END ELSE BEGIN
                    //     COMMIT();
                    //     recSaleH.RESET;
                    //     recSaleH.SETFILTER("No.", Rec."No.");
                    //     REPORT.RUNMODAL(50067, TRUE, FALSE, recSaleH);
                    // END;
                    //<-Ramesh G commented this code in NAV while EBazar modification

                    //->Copied code from Sales order (P42) Post Action here as per Ramesh G
                    //acxcp_300622_CampaignCode +
                    Clear(Cu50200);

                    //TM 9509 For Statics Calculation 30-10-2023
                    Rec.OpenSalesOrderStatistics;
                    SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                    //TM 9509 For Statics Calculation 30-10-2023

                    TotalAmt := 0;
                    IF Rec."Campaign No." <> '' THEN BEGIN

                        if not Rec."Run Statistics" then
                            Error('Please run Statistics page');
                        TotalAmt := 0;
                        recSaleL.RESET;
                        recSaleL.SETRANGE("Document No.", Rec."No.");
                        IF recSaleL.FINDFIRST THEN BEGIN
                            REPEAT
                                TotalAmt += Cu50200.AmttoCustomerSalesLine(recSaleL);//acxcp_170123
                                                                                     //TotalAmt += (Cu50200.AmttoCustomerSalesLine(recSaleL) + Cu50200.TotalGSTAmtLineSales(recSaleL));//acxcp_170123 added for check amount with gst
                            UNTIL recSaleL.NEXT = 0;
                            BalAmt := 0;
                            recCust.RESET;
                            recCust.SETRANGE("No.", recSaleL."Sell-to Customer No.");
                            IF recCust.FINDFIRST THEN BEGIN
                                recCust.CALCFIELDS("Balance (LCY)");
                                BalAmt := recCust."Balance (LCY)";
                                //9509 For Debit Balance
                                IF BalAmt > 0 THEN
                                    CustDebitAmtBal := BalAmt
                                ELSE
                                    CustDebitAmtBal := 0;
                                //9509 For Debit Balance
                                AbsBalAmt := 0;
                                IF BalAmt < 0 THEN
                                    //AbsBalAmt := ABS(BalAmt);
                                    AbsBalAmt := BalAmt;
                                //Team 7739 Start-
                                IF Rec."Parent Customer" <> '' THEN BEGIN
                                    ParentCustomerL.GET(Rec."Parent Customer");
                                    ParentCustomerL.CALCFIELDS("Balance (LCY)");
                                    IF ParentCustomerL."Balance (LCY)" < 0 THEN
                                        AbsBalAmt += ParentCustomerL."Balance (LCY)";
                                END;
                                //Team 7739 End -
                                // IF NOT (AbsBalAmt>=TotalAmt) THEN
                                BalanceCheckL := TotalAmt + AbsBalAmt;
                                IF (BalanceCheckL > 0) THEN BEGIN
                                    //IF NOT (AbsBalAmt >= TotalAmt) THEN BEGIN
                                    MESSAGE('Customer balance is  %1', FORMAT(BalAmt));
                                    ERROR('Amount to Customer is lower then Available Credit Balance for Super Cash. Customer Balance= %1 and Invoice Amount %2', AbsBalAmt, TotalAmt);
                                END;
                            END
                        END;
                    END;

                    //acxcp_300622 -
                    //acxcp_300622_CampaignCode -

                    //acxcp_30122022 << //Credit balance check

                    if not Rec."Run Statistics" then
                        Error('Please run Statistics page');

                    //OpenSalesOrderStatistics;
                    cuSalePost.CheckCustBalance(Rec);

                    //Team 7739 Start-
                    IF Rec."Campaign No." <> '' THEN BEGIN
                        IF Rec."Parent Customer" <> '' THEN BEGIN
                            ParentCustomerL.GET(Rec."Parent Customer");
                            ParentCustomerL.CALCFIELDS(ParentCustomerL."Balance (LCY)");

                            CLEAR(AmountL);
                            SalesLine.RESET();
                            SalesLine.SETRANGE("Document No.", Rec."No.");
                            IF SalesLine.FINDFIRST THEN
                                REPEAT
                                    //AmountL += SalesLine."Amount To Customer";
                                    AmountL += Cu50200.AmttoCustomerSalesLine(SalesLine);
                                UNTIL SalesLine.NEXT = 0;
                            CustomerL.GET(Rec."Sell-to Customer No.");
                            CustomerL.CALCFIELDS(CustomerL."Balance (LCY)");
                            IF CustomerL."Balance (LCY)" < 0 THEN
                                AmountL += CustomerL."Balance (LCY)";
                            IF AmountL > 0 THEN
                                BalanceL := AmountL + ParentCustomerL."Balance (LCY)";

                            IF BalanceL > 0 THEN
                                ERROR('Credit Balance is not available in Parent Customer %1', Rec."Parent Customer");
                            IF BalanceL < 0 THEN
                                AmountL := ROUND(AmountL, 1);
                            IF AmountL > 0 THEN     //9509 to skip 0 Value JV
                            BEGIN
                                MESSAGE('AmountL is %1', AmountL);
                                CLEAR(recnoSeries);
                                Recgnvno.RESET();
                                Recgnvno.SETRANGE(Name, 'JV-SYSTEM');
                                Recgnvno.SETRANGE("Journal Template Name", 'JV_AUTO');
                                IF Recgnvno.FINDFIRST THEN BEGIN
                                    NoSeriesL := recnoSeries.GetNextNo(Recgnvno."No. Series", TODAY, FALSE);
                                    InsertGenJournalLine.RESET;
                                    InsertGenJournalLine.SETRANGE("Journal Batch Name", 'JV-SYSTEM');
                                    InsertGenJournalLine.SETRANGE("Journal Template Name", 'JV_AUTO');
                                    InsertGenJournalLine.DELETEALL;
                                    LineNo := 10000;
                                    InsertGenJournalLine.RESET;
                                    InsertGenJournalLine.INIT;
                                    InsertGenJournalLine.VALIDATE("Journal Template Name", Recgnvno."Journal Template Name");
                                    InsertGenJournalLine.VALIDATE("Journal Batch Name", Recgnvno.Name);
                                    InsertGenJournalLine.VALIDATE("Line No.", LineNo);
                                    InsertGenJournalLine.VALIDATE("Account Type", InsertGenJournalLine."Account Type"::Customer);
                                    InsertGenJournalLine.VALIDATE("Account No.", Rec."Parent Customer");
                                    InsertGenJournalLine.VALIDATE("Posting Date", WORKDATE);
                                    InsertGenJournalLine.VALIDATE("Posting No. Series", Recgnvno."Posting No. Series");
                                    InsertGenJournalLine."External Document No." := Rec."No.";
                                    InsertGenJournalLine.VALIDATE("Document No.", NoSeriesL);
                                    InsertGenJournalLine.VALIDATE("Source Code", 'GENJNL');
                                    InsertGenJournalLine.VALIDATE(Amount, AmountL + CustDebitAmtBal);
                                    InsertGenJournalLine.INSERT;

                                    //fOR CHILD CUSTOMER
                                    InsertGenJournalLine.RESET;
                                    InsertGenJournalLine.INIT;
                                    InsertGenJournalLine.VALIDATE("Journal Template Name", Recgnvno."Journal Template Name");
                                    InsertGenJournalLine.VALIDATE("Journal Batch Name", Recgnvno.Name);
                                    InsertGenJournalLine.VALIDATE("Line No.", LineNo + 10000);
                                    InsertGenJournalLine.VALIDATE("Account Type", InsertGenJournalLine."Account Type"::Customer);
                                    InsertGenJournalLine.VALIDATE("Account No.", Rec."Sell-to Customer No.");
                                    InsertGenJournalLine.VALIDATE(Amount, -(AmountL + CustDebitAmtBal));
                                    InsertGenJournalLine.VALIDATE("Posting No. Series", Recgnvno."Posting No. Series");
                                    InsertGenJournalLine.VALIDATE("Posting Date", WORKDATE);
                                    InsertGenJournalLine."External Document No." := Rec."No.";
                                    InsertGenJournalLine.VALIDATE("Document No.", NoSeriesL);
                                    InsertGenJournalLine.VALIDATE("Source Code", 'GENJNL');
                                    InsertGenJournalLine.INSERT;

                                    //For Voucher naration    InsertJournalNara
                                    VouNaration := 'Amount Transfer Agnst Oder No. ' + Rec."No.";
                                    InsertJournalNara.RESET;
                                    InsertJournalNara.INIT;
                                    InsertJournalNara.VALIDATE("Journal Template Name", Recgnvno."Journal Template Name");
                                    InsertJournalNara.VALIDATE("Journal Batch Name", Recgnvno.Name);
                                    InsertJournalNara.VALIDATE("Line No.", 10000);
                                    InsertJournalNara.VALIDATE("Document No.", NoSeriesL);
                                    InsertJournalNara.VALIDATE(Narration, VouNaration);
                                    InsertJournalNara.INSERT;

                                    VouNaration1 := 'To VAN ' + Rec."Bill-to Customer No." + ' FROM ' + Rec."Parent Customer";
                                    InsertJournalNara2.RESET;
                                    InsertJournalNara2.INIT;
                                    InsertJournalNara2.VALIDATE("Journal Template Name", Recgnvno."Journal Template Name");
                                    InsertJournalNara2.VALIDATE("Journal Batch Name", Recgnvno.Name);
                                    InsertJournalNara2.VALIDATE("Line No.", 20000);
                                    InsertJournalNara2.VALIDATE("Document No.", NoSeriesL);
                                    InsertJournalNara2.VALIDATE(Narration, VouNaration1);
                                    InsertJournalNara2.INSERT;


                                    MESSAGE('JV Amount %1', InsertGenJournalLine.Amount);
                                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", InsertGenJournalLine);

                                    IF Rec."Campaign No." <> '' THEN BEGIN
                                        TotalAmt := 0;
                                        recSaleL.RESET;
                                        recSaleL.SETRANGE("Document No.", Rec."No.");
                                        IF recSaleL.FINDFIRST THEN BEGIN
                                            REPEAT
                                                TotalAmt += Cu50200.AmttoCustomerSalesLine(recSaleL);//acxcp_170123
                                                                                                     //TotalAmt+=(recSaleL."Amount To Customer"+recSaleL."Total GST Amount");//acxcp_170123 added for check amount with gst
                                            UNTIL recSaleL.NEXT = 0;
                                            BalAmt := 0;

                                            recCust.RESET;
                                            recCust.SETRANGE("No.", recSaleL."Sell-to Customer No.");
                                            IF recCust.FINDFIRST THEN BEGIN
                                                recCust.CALCFIELDS("Balance (LCY)");
                                                BalAmt := recCust."Balance (LCY)";
                                                AbsBalAmt := 0;
                                                IF BalAmt < 0 THEN
                                                    //AbsBalAmt:=ABS(BalAmt);
                                                    AbsBalAmt := BalAmt;

                                                BalanceCheckL := 0;
                                                BalanceCheckL := TotalAmt + AbsBalAmt;
                                                IF (BalanceCheckL > 0) THEN BEGIN
                                                    ERROR('JV is not posted');
                                                END;
                                            END
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                    //COMMIT;
                    SLEEP(1000);
                    //<-Copied code from Sales order (P42) Post Action here as per Ramesh G

                    //ACXVG
                    IF NOT CONFIRM('Do You Want To Preview Before Post') THEN BEGIN
                        //acxcp_30122022 >>
                        Rec.SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
                    END ELSE BEGIN
                        COMMIT();
                        recSaleH.RESET;
                        recSaleH.SETFILTER("No.", Rec."No.");
                        REPORT.RUNMODAL(50067, TRUE, FALSE, recSaleH);
                    END;
                end;
            }
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            var
                Cu50200: Codeunit 50200;
            begin
                Clear(Cu50200);
                //acxcp_28102022 - //campaign code validation check
                TotalAmt := 0;
                IF Rec."Campaign No." <> '' THEN BEGIN
                    TotalAmt := 0;
                    recSaleL.RESET;
                    recSaleL.SETRANGE("Document No.", Rec."No.");
                    IF recSaleL.FINDFIRST THEN BEGIN
                        REPEAT
                            TotalAmt += Cu50200.AmttoCustomerSalesLine(recSaleL);
                        UNTIL recSaleL.NEXT = 0;
                        BalAmt := 0;
                        recCust.RESET;
                        recCust.SETRANGE("No.", recSaleL."Sell-to Customer No.");
                        IF recCust.FINDFIRST THEN BEGIN
                            recCust.CALCFIELDS("Balance (LCY)");
                            BalAmt := recCust."Balance (LCY)";
                            AbsBalAmt := 0;
                            IF BalAmt < 0 THEN
                                AbsBalAmt := ABS(BalAmt);
                            IF NOT (AbsBalAmt >= TotalAmt) THEN BEGIN
                                MESSAGE('Customer balance is - %1', FORMAT(ABS(BalAmt)));
                                ERROR('Amount to Customer is lower then Available Credit Balance for Super Cash. Customer Balance= %1 and Invoice Amount -%2', AbsBalAmt, TotalAmt);
                            END;
                        END;
                    END;
                END;
                //acxcp_28102022 + //campaign code

            end;
        }
        modify("Preview Posting")
        {
            trigger OnBeforeAction()
            var
                Cu50200: Codeunit 50200;
            begin
                //acxcp_28102022 - //campaign code validation check
                TotalAmt := 0;
                Clear(Cu50200);
                IF Rec."Campaign No." <> '' THEN BEGIN
                    TotalAmt := 0;
                    recSaleL.RESET;
                    recSaleL.SETRANGE("Document No.", Rec."No.");
                    IF recSaleL.FINDFIRST THEN BEGIN
                        REPEAT
                            TotalAmt += Cu50200.AmttoCustomerSalesLine(recSaleL);
                        UNTIL recSaleL.NEXT = 0;
                        BalAmt := 0;
                        recCust.RESET;
                        recCust.SETRANGE("No.", recSaleL."Sell-to Customer No.");
                        IF recCust.FINDFIRST THEN BEGIN
                            recCust.CALCFIELDS("Balance (LCY)");
                            BalAmt := recCust."Balance (LCY)";
                            AbsBalAmt := 0;
                            IF BalAmt < 0 THEN
                                AbsBalAmt := ABS(BalAmt);
                            IF NOT (AbsBalAmt >= TotalAmt) THEN BEGIN
                                MESSAGE('Customer balance is - %1', FORMAT(ABS(BalAmt)));
                                ERROR('Amount to Customer is lower then Available Credit Balance for Super Cash. Customer Balance= %1 and Invoice Amount -%2', AbsBalAmt, TotalAmt);
                            END;
                        END;
                    END;
                END;
                //acxcp_28102022 + //campaign code


            end;
        }
    }

    var
        recCust: Record 18;
        recSaleH: Record 36;
        TotalAmt: Decimal;
        BalAmt: Decimal;
        recSaleL: Record 37;
        AbsBalAmt: Decimal;
        SalesCalcDiscountByType: Codeunit 56;
        SalesLine: Record 37;
        IsRateChangeEnabled: Boolean;
        SchemeCal: Codeunit 50006;
        recShipTo: Record 222;
        recGenLine: Record 311;
        CreateVoucher: Record 37;
        Recgnline: Record 81;
        Recgnvno: Record 232;
        recnoSeries: Codeunit 396;
        CustRecTab: Record 18;
}

