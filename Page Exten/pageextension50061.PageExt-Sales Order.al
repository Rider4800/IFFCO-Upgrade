pageextension 50061 pageextension50061 extends "Sales Order"
{
    // //acxcp_300622_CampaignCode
    layout
    {
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                //9509 Start
                CustRecTab.RESET;
                IF CustRecTab.GET(Rec."Bill-to Customer No.") THEN BEGIN
                    Rec."Campaign No." := CustRecTab."Preferred Campaign No.";
                    Rec.MODIFY;
                END;
            end;
        }
        modify("Job Queue Status")
        {
            Visible = false;
        }
        moveafter("Document Date"; "External Document No.")


        addafter("Assigned User ID")
        {
            field("Customer Price Group"; Rec."Customer Price Group")
            {
            }
            field("Customer Disc. Group"; Rec."Customer Disc. Group")
            {
            }
        }
        addafter(Status)
        {
            field("Parent Customer"; Rec."Parent Customer")
            {
            }
        }
        moveafter("Customer Disc. Group"; "Campaign No.")
        addafter("LR/RR Date")
        {
            field("Transporter Code"; Rec."Transporter Code")
            {
            }
            field("Transporter Name"; Rec."Transporter Name")
            {
            }
            field("Transporter GSTIN"; Rec."Transporter GSTIN")
            {
            }
        }
        addafter("Tax Info")
        {
            group("Sales Hierarchy")
            {
                Caption = 'Sales Hierarchy';
                field("FO Code"; Rec."FO Code")
                {
                }
                field("FA Code"; Rec."FA Code")
                {
                }
                field("TME Code"; Rec."TME Code")
                {
                }
                field("RME Code"; Rec."RME Code")
                {
                }
                field("ZMM Code"; Rec."ZMM Code")
                {
                }
                field("HOD Code"; Rec."HOD Code")
                {
                }
            }
        }
        moveafter("Requested Delivery Date"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 1 Code")
    }
    actions
    {
        modify(Post)
        {
            Visible = false;
        }
        //12887---> f7 mandatory
        modify(Statistics)
        {
            trigger OnAfterAction()
            begin
                Rec."Run Statistics" := true;
                Rec.Modify();
            end;
        }
        addafter("Print Confirmation")
        {
            action(GeneralJournalVoucher)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General Journal Voucher';
                Image = Voucher;
                trigger OnAction()
                var
                    FindGenJournalLine: Record 81;
                    InsertGenJournalLine: Record 81;
                    OpenGenJournalLine: Record 81;
                    LineNo: Integer;
                    AmountL: Decimal;
                    ParentCustomerL: Record 18;
                    BalanceL: Decimal;
                    NoSeriesL: Code[20];
                    Cu50200: Codeunit 50200;
                begin
                    IF Rec."Parent Customer" <> '' THEN BEGIN
                        ParentCustomerL.GET(Rec."Parent Customer");
                        ParentCustomerL.CALCFIELDS(ParentCustomerL."Balance (LCY)");

                        CLEAR(AmountL);
                        SalesLine.RESET();
                        SalesLine.SETRANGE("Document No.", Rec."No.");
                        IF SalesLine.FINDFIRST THEN
                            REPEAT
                                AmountL += Cu50200.AmttoCustomerSalesLine(SalesLine);
                            UNTIL SalesLine.NEXT = 0;
                        BalanceL := AmountL + ParentCustomerL."Balance (LCY)";
                        IF BalanceL > 0 THEN
                            ERROR('Credit Balance is not available in Parent Customer %1', Rec."Parent Customer");

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
                            InsertGenJournalLine.VALIDATE(Amount, AmountL);
                            InsertGenJournalLine.INSERT;

                            //fOR CHILD CUSTOMER
                            InsertGenJournalLine.RESET;
                            InsertGenJournalLine.INIT;
                            InsertGenJournalLine.VALIDATE("Journal Template Name", Recgnvno."Journal Template Name");
                            InsertGenJournalLine.VALIDATE("Journal Batch Name", Recgnvno.Name);
                            InsertGenJournalLine.VALIDATE("Line No.", LineNo + 10000);
                            InsertGenJournalLine.VALIDATE("Account Type", InsertGenJournalLine."Account Type"::Customer);
                            InsertGenJournalLine.VALIDATE("Account No.", Rec."Sell-to Customer No.");
                            InsertGenJournalLine.VALIDATE(Amount, -AmountL);
                            InsertGenJournalLine.VALIDATE("Posting No. Series", Recgnvno."Posting No. Series");
                            InsertGenJournalLine.VALIDATE("Posting Date", WORKDATE);
                            InsertGenJournalLine."External Document No." := Rec."No.";
                            InsertGenJournalLine.VALIDATE("Document No.", NoSeriesL);
                            InsertGenJournalLine.VALIDATE("Source Code", 'GENJNL');
                            InsertGenJournalLine.INSERT;
                        END;
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", InsertGenJournalLine);
                    END;
                    //InsertGenJournalLine.MODIFY;
                    // COMMIT;

                    //    OpenGenJournalLine.RESET;
                    //    OpenGenJournalLine.SETRANGE("Journal Batch Name",'JV-SYSTEM');
                    //    OpenGenJournalLine.SETRANGE("Journal Template Name",'JV_AUTO');
                    //    //OpenGenJournalLine.SETRANGE("Document No.",Rec."No.");
                    //      PAGE.RUN(39,OpenGenJournalLine);
                    //  END
                    //    ELSE
                    //      PAGE.RUN(39,FindGenJournalLine);
                END;
            }
        }
        //f7 mandatory<---12887
        addafter(Release)
        {
            action(PostNew)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Ellipsis = true;
                Image = PostOrder;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                AboutTitle = 'Posting the order';
                AboutText = 'Posting will ship or invoice the quantities on the order, or both. **Post** and **Send** can save the order as a file, print it, or attach it to an email, all in one go.';

                trigger OnAction()
                var
                    cuSalePost: Codeunit 50035;
                    Cu50200: Codeunit 50200;
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
                    //SLEEP(1000);

                    //ACXVG
                    IF NOT CONFIRM('Do You Want To Preview Before Post') THEN BEGIN
                        //acxcp_30122022 >>
                        Post(CODEUNIT::"Sales-Post (Yes/No)");
                    END ELSE BEGIN
                        COMMIT();
                        recSaleH.RESET;
                        recSaleH.SETFILTER("No.", Rec."No.");
                        REPORT.RUNMODAL(50067, TRUE, FALSE, recSaleH);
                    END;
                end;
            }
        }
        modify(PreviewPosting)
        {
            trigger OnBeforeAction()
            var
                cuSalePost: Codeunit 50035;
                Cu50200: Codeunit 50200;
            begin
                //acxcp //credit balance check in Campaign Code
                TotalAmt := 0;
                Clear(Cu50200);
                IF Rec."Campaign No." <> '' THEN BEGIN
                    TotalAmt := 0;
                    recSaleL.RESET;
                    recSaleL.SETRANGE("Document No.", Rec."No.");
                    IF recSaleL.FINDFIRST THEN BEGIN
                        REPEAT
                            //TotalAmt+=recSaleL."Amount To Customer"; //acxcp_170123 // Balance check with Credit Limit
                            TotalAmt += (Cu50200.AmttoCustomerSalesLine(recSaleL) + Cu50200.TotalGSTAmtLineSales(recSaleL));//acxcp_170123 // Balance check with Credit Limit
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
                        END
                    END;
                END;
                //acxcp //credit balance check in Campaign Code

                //acxcp_30122022 << //Credit balance check
                if not Rec."Run Statistics" then
                    Error('Please run Statistics page');

                //OpenSalesOrderStatistics;
                cuSalePost.CheckCustBalance(Rec);
            end;
        }

        addafter(AssemblyOrders)
        {
            action("Calculate Scheme")
            {
                ApplicationArea = all;
                Image = CalculateDiscount;
                Promoted = true;

                trigger OnAction()
                begin
                    SchemeCal.SchemeonInvoice(Rec."No.");
                end;
            }
        }
    }
    //->E-Bazaar Customization
    trigger OnAfterGetRecord()
    begin
        //ACXAAK..............
        recCust.RESET();
        recCust.SETRANGE("No.", Rec."Sell-to Customer No.");
        IF recCust.FINDFIRST() THEN
            Rec."Parent Customer" := recCust."Parent Customer";
    end;
    //<-E-Bazaar Customization

    PROCEDURE Post(PostingCodeunitID: Integer);
    BEGIN
        Rec.SendToPosting(PostingCodeunitID);
        IF Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" THEN
            CurrPage.CLOSE;
        CurrPage.UPDATE(FALSE);
    END;

    var
        SchemeCal: Codeunit 50006;
        recCust: Record 18;
        recSaleH: Record 36;
        TotalAmt: Decimal;
        BalAmt: Decimal;
        recSaleL: Record 37;
        AbsBalAmt: Decimal;
        cuSalePost: Codeunit 80;
        recShipTo: Record 222;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        recGenLine: Record 311;
        CreateVoucher: Record 37;
        Recgnline: Record 81;
        Recgnvno: Record 232;
        recnoSeries: Codeunit 396;
        CustRecTab: Record 18;
        SalesLine: Record 37;
}