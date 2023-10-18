tableextension 50061 tableextension50061 extends "Purchase Line Archive"
{
    fields
    {
        /*12887 TDS Group field is removed----> 
        modify("TDS Group")
        {
            OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Others,Dividend,Goods';

            //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 16363)".

        }
        <---12887 TDS Group field is removed */
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

