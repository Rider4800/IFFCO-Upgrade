tableextension 50029 tableextension50029 extends "TDS Journal Line"
{
    fields
    {
        // modify("TDS Group")
        // {
        //     OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Goods';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 16359)".

        // }
        field(50000; "Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}

