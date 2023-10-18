pageextension 50063 pageextension50063 extends "Sales Invoice"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 3"; Rec."Sell-to Customer Name 3")
            {
            }
        }
        addafter("Location Code")
        {
            field("Branch Accounting"; Rec."Branch Accounting")
            {
            }
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
            }
            field("Posting No."; Rec."Posting No.")
            {
            }
        }
        addafter("LR/RR Date")
        {
            field("Transporter Code"; Rec."Transporter Code")
            {
            }
            field("Transporter Name"; Rec."Transporter Name")
            {
            }
            field("Transporter GSTIN"; Rec."Transporter GSTIN")
            {
            }
        }
        addafter("Tax Info")
        {
            group("Sales Hierarchy")
            {
                Caption = 'Sales Hierarchy';
                field("FO Code"; Rec."FO Code")
                {
                }
                field("FA Code"; Rec."FA Code")
                {
                }
                field("TME Code"; Rec."TME Code")
                {
                }
                field("RME Code"; Rec."RME Code")
                {
                }
                field("ZMM Code"; Rec."ZMM Code")
                {
                }
                field("HOD Code"; Rec."HOD Code")
                {
                }
            }
        }
        moveafter("Job Queue Status"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 2 Code"; "Location Code")
    }
}

