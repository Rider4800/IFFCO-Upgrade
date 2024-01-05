pageextension 50005 pageextension50005 extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Customer Blocked/Unblocked"; Rec."Customer Blocked/Unblocked")
            {
                ApplicationArea = All;
            }
            field("Excludes Credit Limit Allow"; Rec."Excludes Credit Limit Allow")
            {
                ApplicationArea = All;
            }
            field("One Time Credit Pass Allow"; Rec."One Time Credit Pass Allow")
            {
                ApplicationArea = All;
            }
            field("PPS Access"; Rec."PPS Access")
            {
                ApplicationArea = All;
            }
            field(QtyCheck; Rec.QtyCheck)
            {
                ApplicationArea = All;
            }
            field("WH User"; Rec."WH User")
            {
                ApplicationArea = All;
            }
            field(ExpiryStockMovementAllowed; Rec.ExpiryStockMovementAllowed)
            {
                ApplicationArea = All;
            }
        }
    }
}

