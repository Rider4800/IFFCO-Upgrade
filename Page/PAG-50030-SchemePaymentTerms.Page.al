page 50030 "Scheme Payment Terms"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50017;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Sales Type"; Rec."Sales Type")
                {
                }
                field("Sales Code"; Rec."Sales Code")
                {
                }
                field("Sales Description"; Rec."Sales Description")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Code; Rec.Code)
                {
                }
                field("Product Name"; Rec."Product Name")
                {
                }
                field("Fixed Credit Due Date"; Rec."Fixed Credit Due Date")
                {
                }
                field("Credit Payment Term"; Rec."Credit Payment Term")
                {
                }
                field("Fixed Cash Due Date"; Rec."Fixed Cash Due Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

