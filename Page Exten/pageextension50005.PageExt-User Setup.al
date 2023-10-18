pageextension 50005 pageextension50005 extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Customer Blocked/Unblocked"; Rec."Customer Blocked/Unblocked")
            {
            }
            field("Excludes Credit Limit Allow"; Rec."Excludes Credit Limit Allow")
            {
            }
            field("One Time Credit Pass Allow"; Rec."One Time Credit Pass Allow")
            {
            }
            field("PPS Access"; Rec."PPS Access")
            {
            }
            field(QtyCheck; Rec.QtyCheck)
            {
            }
            field("WH User"; Rec."WH User")
            {
            }
            field(ExpiryStockMovementAllowed; Rec.ExpiryStockMovementAllowed)
            {
            }
        }
    }
}

