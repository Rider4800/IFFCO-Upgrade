pageextension 50054 pageextension50054 extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
            }
        }
        addafter(Description)
        {
            field("Rounding Precision"; Rec."Rounding Precision")
            {
            }
        }
        addafter("Created From Nonstock Item")
        {
            field("Responsibility Center"; Rec."Responsibility Center")
            {
            }
            field(Inventory; Rec.Inventory)
            {
            }
            field("Units per Parcel"; Rec."Units per Parcel")
            {
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
            }
            field("Net Weight"; Rec."Net Weight")
            {
            }
        }
        addafter(Blocked)
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Warehouse Entries")
        {
            action("<Item Balance with Lot>")
            {
                Caption = 'Item Balance with Lot';
                Image = LedgerEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 50012;
                RunPageMode = View;
            }
        }
    }
}

