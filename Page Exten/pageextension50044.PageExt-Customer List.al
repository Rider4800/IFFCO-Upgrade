pageextension 50044 pageextension50044 extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Name 3"; Rec."Name 3")
            {
            }
            field("Our Account No."; Rec."Our Account No.")
            {
            }
        }
        addafter("Post Code")
        {
            field("State Code"; Rec."State Code")
            {
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
            }
            field(Balance; Rec.Balance)
            {
            }
        }
        addafter("Phone No.")
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
            field("Created By"; Rec."Created By")
            {
            }
        }
    }
    actions
    {
        addafter(ApprovalEntries)
        {
            action(Updateblock)
            {

                trigger OnAction()
                begin
                    recCustomer.RESET();
                    recCustomer.GET(Rec."No.");
                    IF recCustomer.FINDFIRST THEN BEGIN
                        REPEAT
                            IF recCustomer."GST Registration No." = '' THEN BEGIN
                                recCustomer.VALIDATE("GST Customer Type", recCustomer."GST Customer Type"::Unregistered);
                                recCustomer.MODIFY();
                            END;
                        UNTIL recCustomer.NEXT = 0;
                    END;
                end;
            }
        }
        addbefore("Item &Tracking Entries")
        {
            action("<Customer Ledger Balance>")
            {
                Caption = 'Customer Ledger Balance';
                Image = LedgerEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50011;
            }
        }
        addafter(ReportCustomerPaymentReceipt)
        {
            action("Report Customer- Ledger Report")
            {
                Caption = 'Customer- Ledger Report-New';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50011;
            }
        }
    }

    var
        UserMgt: Codeunit 5700;
        recCustomer: Record 18;

    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    //MZH
    IF UserMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;
    //MZH
    */
    //end;
}

