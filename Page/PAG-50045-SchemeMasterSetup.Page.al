page 50045 "Scheme Master Setup"
{
    PageType = List;
    SourceTable = 50005;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("OrderPriority Scheme"; Rec."OrderPriority Scheme")
                {
                }
                field("Scheme Date"; Rec."Scheme Date")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Payment From Date"; Rec."Payment From Date")
                {
                }
                field("Payment To Date"; Rec."Payment To Date")
                {
                }
                field("Price Group ID"; Rec."Price Group ID")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                }
                field("Modified By"; Rec."Modified By")
                {
                }
                field("Modified Date Time"; Rec."Modified Date Time")
                {
                }
                field(Exclusive; Rec.Exclusive)
                {
                }
                field("Credit Note"; Rec."Credit Note")
                {
                }
                field("Inventory Location ID"; Rec."Inventory Location ID")
                {
                }
                field("Inventory Site ID"; Rec."Inventory Site ID")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(SaleData)
            {
                Image = DataEntry;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //cuScheme.SaleData(Rec);
                end;
            }
        }
    }

    var
        cuScheme: Codeunit 50003;
}

