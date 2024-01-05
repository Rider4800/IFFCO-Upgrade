page 50025 "Price Discount Structure List"
{
    CardPageID = "ACX Price Disc. Header";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50007;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Type"; Rec."Sales Type")
                {
                }
                field(Code; Rec.Code)
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Sales Code"; Rec."Sales Code")
                {
                }
                field("Sales Description"; Rec."Sales Description")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("S.No."; Rec."S.No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

