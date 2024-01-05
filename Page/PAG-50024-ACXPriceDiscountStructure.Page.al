page 50024 "ACX Price Discount Structure"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50008;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                }
                field("Tax Code"; Rec."Tax Code")
                {
                }
                field("Tax Name"; Rec."Tax Name")
                {
                }
                field("Taxable Basis"; Rec."Taxable Basis")
                {
                }
                field("Markup Category"; Rec."Markup Category")
                {
                }
            }
        }
    }

    actions
    {
    }
}

