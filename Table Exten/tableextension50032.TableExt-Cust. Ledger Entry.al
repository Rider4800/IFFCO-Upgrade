tableextension 50032 tableextension50032 extends "Cust. Ledger Entry"
{
    // //acxcp_300622_CampaignCode +
    fields
    {
        //->TEAM-17783
        // modify("TDS Group")
        // {
        //     OptionCaption = ' ,Contractor,Commission,Professional,Interest,Rent,Dividend,Interest on Securities,Lotteries,Insurance Commission,NSS,Mutual fund,Brokerage,Income from Units,Capital Assets,Horse Races,Sports Association,Payable to Non Residents,Income of Mutual Funds,Units,Foreign Currency Bonds,FII from Securities,Others,Goods';

        //     //Unsupported feature: Property Modification (OptionString) on ""TDS Group"(Field 13703)".

        // }
        //<-TEAM-17783
        field(50000; "Scheme Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Campaign No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Campaign;
        }
        field(50002; "Ship-to Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Acxcp_ShipToReport';
        }
    }
    //->Team-17783  commented
    // keys
    // {
    //     key(Key1; "Ship-to Code", "Customer No.")
    //     {
    //     }
    // }
    //<-Team-17783


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 6)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Customer No." := GenJnlLine."Account No.";
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    #4..86
    END;
    "GST Customer Type" := GenJnlLine."GST Customer Type";
    "Location GST Reg. No." := GenJnlLine."Location GST Reg. No.";
    OnAfterCopyCustLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..89
    //acxcp_300622_CampaignCode +
    "Campaign No.":=GenJnlLine."Campaign No."; //ACXCP_30062022 //Campaign code flowed to CLE
    //acxcp_300622_CampaignCode -

    //ACXCP_090822 + //ShiptocodeReport
    "Ship-to Code":=GenJnlLine."Ship-to Code";
    //ACXCP_090822 - //ShiptocodeReport
    OnAfterCopyCustLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
}

