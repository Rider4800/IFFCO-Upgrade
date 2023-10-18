tableextension 50008 tableextension50008 extends "Purch. Rcpt. Line"
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
    }
}

