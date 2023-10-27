pageextension 50061 pageextension50061 extends "Sales Order"
{
    // //acxcp_300622_CampaignCode
    layout
    {


        modify("Opportunity No.")
        {
            Visible = false;
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
        //f7 mandatory<---12887
        addbefore(PostAndNew)
        {
            action(PostNew)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
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
                begin
                    //acxcp_300622_CampaignCode +
                    Clear(Cu50200);
                    TotalAmt := 0;
                    IF Rec."Campaign No." <> '' THEN BEGIN

                        if not Rec."Run Statistics" then
                            Error('Please run Statistics page');
                        TotalAmt := 0;
                        recSaleL.RESET;
                        recSaleL.SETRANGE("Document No.", Rec."No.");
                        IF recSaleL.FINDFIRST THEN BEGIN
                            REPEAT
                                //TotalAmt+=recSaleL."Amount To Customer";//acxcp_170123
                                TotalAmt += (Cu50200.AmttoCustomerSalesLine(recSaleL) + Cu50200.TotalGSTAmtLineSales(recSaleL));//acxcp_170123 added for check amount with gst
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

                    //acxcp_300622 -
                    //acxcp_300622_CampaignCode -

                    //acxcp_30122022 << //Credit balance check

                    if not Rec."Run Statistics" then
                        Error('Please run Statistics page');

                    //OpenSalesOrderStatistics;
                    cuSalePost.CheckCustBalance(Rec);


                    //ACXVG
                    IF NOT CONFIRM('Do You Want To Preview Before Post') THEN BEGIN
                        //acxcp_30122022 >>
                        PostSalesOrder(CODEUNIT::"Sales-Post (Yes/No)", "Navigate After Posting"::"Posted Document");
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
                Image = CalculateDiscount;
                Promoted = true;

                trigger OnAction()
                begin
                    SchemeCal.SchemeonInvoice(Rec."No.");
                end;
            }
        }

    }

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

}

