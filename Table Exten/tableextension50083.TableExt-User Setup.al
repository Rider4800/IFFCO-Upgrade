tableextension 50083 tableextension50083 extends "User Setup"
{
    fields
    {
        field(50000; "Customer Blocked/Unblocked"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Excludes Credit Limit Allow"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KM';
        }
        field(50002; "One Time Credit Pass Allow"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KM';
        }
        field(50003; "PPS Access"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50004; QtyCheck; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXCP';
        }
        field(50005; "WH User"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXVG';
        }
        field(50006; ExpiryStockMovementAllowed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

