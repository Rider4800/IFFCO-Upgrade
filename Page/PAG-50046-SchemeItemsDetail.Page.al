page 50046 "Scheme Items Detail"
{
    PageType = List;
    SourceTable = 50026;

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
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                }
                field("Included Under Scheme"; Rec."Included Under Scheme")
                {
                }
                field("MRP Value"; Rec."MRP Value")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Scheme Calculation Type"; Rec."Scheme Calculation Type")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Excluded; Rec.Excluded)
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }

    var
        cuScheme: Codeunit 50003;
}

