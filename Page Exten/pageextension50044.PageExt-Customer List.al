pageextension 50044 pageextension50044 extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Name 3"; Rec."Name 3")
            {
                ApplicationArea = All;
            }
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Post Code")
        {
            field("State Code"; Rec."State Code")
            {
                ApplicationArea = All;
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = All;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
            }
        }
        addafter("Phone No.")
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(ApprovalEntries)
        {
            action(Updateblock)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // recCustomer.RESET();
                    // recCustomer.GET(Rec."No.");
                    // IF recCustomer.FINDFIRST THEN BEGIN
                    if recCustomer.get(Rec."No.") then begin
                        REPEAT
                            IF recCustomer."GST Registration No." = '' THEN BEGIN
                                recCustomer.VALIDATE("GST Customer Type", recCustomer."GST Customer Type"::Unregistered);
                                recCustomer.MODIFY();
                            END;
                        UNTIL recCustomer.NEXT = 0;
                    END;
                end;
            }
            // action("Update Ship-to Address")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Image = UpdateUnitCost;
            //     trigger OnAction()
            //     var
            //         STAddr: Record "Ship-to Address";
            //     begin
            //         STAddr.Reset();
            //         if STAddr.FindFirst() then begin
            //             repeat
            //                 if StrLen(STAddr."GST Registration No.") = 15 then begin
            //                     STAddr.Validate("Ship-to GST Customer Type", STAddr."Ship-to GST Customer Type"::Registered);
            //                     STAddr.Modify(true);
            //                 end;
            //             until STAddr.Next() = 0;
            //             Message('Data Updated');
            //         end;
            //     end;
            // }
        }
        addbefore("Item &Tracking Entries")
        {
            action("<Customer Ledger Balance>")
            {
                Caption = 'Customer Ledger Balance';
                Image = LedgerEntries;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50011;
                PromotedCategory = New;
            }
        }
        addafter(ReportCustomerPaymentReceipt)
        {
            action("Report Customer- Ledger Report")
            {
                Caption = 'Customer- Ledger Report-New';
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Report;
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

