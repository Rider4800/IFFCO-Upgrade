page 50034 "Scheme GL Mapping"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 50021;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

