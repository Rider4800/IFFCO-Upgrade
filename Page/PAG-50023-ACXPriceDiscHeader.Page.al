page 50023 "ACX Price Disc. Header"
{
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = 50007;

    layout
    {
        area(content)
        {
            field("Sales Type"; Rec."Sales Type")
            {
            }
            field(Type; Rec.Type)
            {
            }
            part(ACXPriceDiscountStructure; 50024)
            {
                SubPageLink = Code = FIELD(Code),
                              "Sales Code" = FIELD("Sales Code");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
    }
}

