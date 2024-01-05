pageextension 50123 PriceListLine extends "Price List Lines"
{
    layout
    {
        // Add changes to page layout here
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