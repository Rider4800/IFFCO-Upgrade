page 50029 "Sales Line Scheme Calculation"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = 50016;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Scheme Date"; Rec."Scheme Date")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Tax Charge Code"; Rec."Tax Charge Code")
                {
                }
                field("Scheme Calculation Type"; Rec."Scheme Calculation Type")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Code; Rec.Code)
                {
                }
                field("Line Discount"; Rec."Line Discount")
                {
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                }
                field("Line Quantity"; Rec."Line Quantity")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Free Item Code"; Rec."Free Item Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

