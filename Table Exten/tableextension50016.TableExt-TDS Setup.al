tableextension 50016 tableextension50016 extends "TDS Setup"
{
    fields
    {
        //->TEAM-17783
        // modify("TDS Group")
        // {
        //     OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Rent for Plant & Machinery,Rent for Land & Building,Banking Services,Compensation On Immovable Property,PF Accumulated,Payment For Immovable Property,Goods';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 20)".

        // }
        //<-TEAM-17783
        field(27; "Calc. Over & Above Threshold"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

