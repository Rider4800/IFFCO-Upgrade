page 50062 Schemes
{
    ApplicationArea = All;
    Caption = 'Schemes';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
    }

    actions
    {
        area(Processing)
        {
            action("CD Slab")
            {
                RunObject = page 50031;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Calculate;
                PromotedCategory = Report;
            }
            action("CD Calculate")
            {
                RunObject = page 50032;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Calculate;
                PromotedCategory = Report;
            }
            action("Scheme GL Mapping")
            {
                RunObject = page 50034;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = GL;
                PromotedCategory = Report;
            }
            action("Posted Calculated CD Summary")
            {
                RunObject = Page 50043;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PostBatch;
                PromotedCategory = Report;
            }
            action("Scheme Master")
            {
                RunObject = page 50020;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Table;
                PromotedCategory = Report;
            }
            action("Price Discount Structure")
            {
                RunObject = page 50025;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Discount;
                PromotedCategory = Report;
            }
            action("Scheme Charges")
            {
                RunObject = page 50021;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = AssessFinanceCharges;
                PromotedCategory = Report;
            }
            action("Scheme Sales Line Discount")
            {
                RunObject = page 50022;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = SalesLineDisc;
                PromotedCategory = Report;
            }
            action("Scheme Payment Terms")
            {
                RunObject = page 50030;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Payment;
                PromotedCategory = Report;
            }
        }
    }
}
