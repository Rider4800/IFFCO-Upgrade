tableextension 50010 tableextension50010 extends "Purch. Inv. Line"
{
    fields
    {
        //<-TEAM-17783
        // modify("TDS Group")
        // {
        //     OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Goods';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 16363)".

        // }
        //->TEAM-17783
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

