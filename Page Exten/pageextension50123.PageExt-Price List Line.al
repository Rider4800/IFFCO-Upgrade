pageextension 50123 PriceListLine extends "Price List Lines"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Asset Type")
        {
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
            }
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
            }
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = All;
            }
            field("Ending Date"; Rec."Ending Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Allow Line Disc.")
        {
            field("Line Disc %"; Rec."Line Discount %")
            {
                ApplicationArea = All;
            }
            field("Price Includes VAT"; Rec."Price Includes VAT")
            {
                ApplicationArea = All;
            }
            field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit Price")
        {
            field("MRP Price"; Rec."MRP Price")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}