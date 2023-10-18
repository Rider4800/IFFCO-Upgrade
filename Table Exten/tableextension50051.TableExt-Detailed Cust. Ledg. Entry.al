tableextension 50051 tableextension50051 extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        /*12887---> TDS Group field is removed
         modify("TDS Group")
         {
             OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Goods';

             //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 13703)".

         }
         <---12887*/
        field(50000; "Scheme Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Acx-KM';
        }
    }
}

