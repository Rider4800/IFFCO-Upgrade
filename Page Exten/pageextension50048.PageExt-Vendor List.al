pageextension 50048 pageextension50048 extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = All;
            }
            field("State Code"; Rec."State Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Post Code")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
            }
        }
        addafter("Privacy Blocked")
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action(UpdateVendor)
            {

                trigger OnAction()
                var
                    recVendor: Record 23;
                begin
                    /*
                    recVendor.RESET();
                    recVendor.SETRANGE("No.","No.");
                    IF recVendor.FINDFIRST THEN BEGIN
                      REPEAT
                        recVendor.VALIDATE("Finance Branch A/c Code",'HR_HO');
                        recVendor.MODIFY();
                        UNTIL recVendor.NEXT=0;
                      END;
                    */

                end;
            }
        }
        addafter("Item &Tracking Entries")
        {
            action("Vendor Ledger Balance")
            {
                Image = LedgerBook;
                Promoted = true;
                RunObject = Page 50010;
                ApplicationArea = All;
                PromotedIsBig = true;
                PromotedCategory = New;
            }
        }
        addafter("Vendor - Detail Trial Balance")
        {
            action("<Vendor - Ledger Report New>")
            {
                Caption = 'Vendor - Ledger Report New';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50012;
                ApplicationArea = All;
            }
        }
    }

    var
        UserMgt: Codeunit 5700;

    trigger OnOpenPage()
    begin
        //MZH
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FILTERGROUP(0);
        END;
        //MZH
    end;
}

