pageextension 50076 pageextension50076 extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Order No."; Rec."Order No.")
            {
            }
            field("Line No."; Rec."Line No.")
            {
            }
        }
        addafter("Shipment Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
            }
        }
    }
}

