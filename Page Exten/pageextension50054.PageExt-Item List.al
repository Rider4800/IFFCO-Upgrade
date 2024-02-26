pageextension 50054 pageextension50054 extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Rounding Precision"; Rec."Rounding Precision")
            {
                ApplicationArea = All;
            }
        }
        addafter("Created From Nonstock Item")
        {
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
            }
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;
            }
            field("Units per Parcel"; Rec."Units per Parcel")
            {
                ApplicationArea = All;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = All;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
            }
        }
        addafter(Blocked)
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Warehouse Entries")
        {
            action("Item Balance with Lot")
            {
                Caption = 'Item Balance with Lot';
                Image = LedgerEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50012;
                RunPageMode = View;
                ApplicationArea = All;
            }
        }
    }
}

