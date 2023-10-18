tableextension 50017 tableextension50017 extends "TDS Entry"
{
    fields
    {
        //->TEAM-17783
        // modify("TDS Group")
        // {
        //     OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Rent for Plant & Machinery,Rent for Land & Building,Banking Services,Compensation On Immovable Property,PF Accumulated,Payment For Immovable Property,Goods';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 68)".

        // }
        // modify("TDS Section")
        // {
        //     OptionCaption = ' ,194C,194G,194J,194A,194I,194,193,194B,194D,194EE,194F,194H,194K,194L,194BB,194E,195,196A,196B,196C,196D,194IA,194IB,197A1F,194LA,192A,194Q';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Section"(Field 80)".

        // }
        // field(136; "Over & Above Threshold Opening"; Boolean)
        // {
        //     DataClassification = ToBeClassified;
        // }
        //<-TEAM-17783
        field(137; "Calc. Over & Above Threshold"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

