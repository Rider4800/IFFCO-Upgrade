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
                begin
                    //acxcp_28102022 - //campaign code validation check
                    Clear(Cu50200);
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
                    //ACXVG
                    IF NOT CONFIRM('Do You Want To Preview Before Post') THEN BEGIN
                        //acxcp_30122022 >>
                        PostDocument(CODEUNIT::"Sales-Post (Yes/No)");
                    END ELSE BEGIN
                        COMMIT();
                        recSaleH.RESET;
                        recSaleH.SETFILTER("No.", Rec."No.");
                        REPORT.RUNMODAL(50067, TRUE, FALSE, recSaleH);
                    END;

                end;
            }
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
        cuSalePost: Codeunit 80;
}

