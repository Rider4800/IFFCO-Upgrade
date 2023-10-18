tableextension 50012 tableextension50012 extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; "Short Quantity Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50001; "Excess/Short Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50002; "Certificate of Analysis"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK 140421';
        }
        field(50003; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Exported to Purch. Register"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACXBase';
        }
    }
}

