pageextension 50010 pageextension50010 extends "Posted Sales Invoice"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Invoice"(Page 132)".

    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 3"; Rec."Sell-to Customer Name 3")
            {
            }
        }
        addafter("External Document No.")
        {
            field("Campaign No."; Rec."Campaign No.")
            {
                Editable = false;
            }
        }
        addafter("Tax Info")
        {
            group("Sales Hierarchy")
            {
                Caption = 'Sales Hierarchy';
                field("FO Code"; Rec."FO Code")
                {
                }
                field("FA Code"; Rec."FA Code")
                {
                }
                field("TME Code"; Rec."TME Code")
                {
                }
                field("RME Code"; Rec."RME Code")
                {
                }
                field("ZMM Code"; Rec."ZMM Code")
                {
                }
                field("HOD Code"; Rec."HOD Code")
                {
                }
            }
        }
    }
    actions
    {
        addafter(IncomingDocAttachFile)
        {
            action("Tax Invoice")
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    recSalesInvHdr.RESET();
                    recSalesInvHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHdr.FIND('-') THEN
                        REPORT.RUN(50004, TRUE, FALSE, recSalesInvHdr);
                end;
            }
        }
    }

    var
        recSalesInvHdr: Record 112;
}

