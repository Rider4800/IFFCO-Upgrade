pageextension 50010 pageextension50010 extends "Posted Sales Invoice"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Invoice"(Page 132)".

    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 3"; Rec."Sell-to Customer Name 3")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("Campaign No."; Rec."Campaign No.")
            {
                ApplicationArea = All;
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
                    ApplicationArea = All;
                }
                field("FA Code"; Rec."FA Code")
                {
                    ApplicationArea = All;
                }
                field("TME Code"; Rec."TME Code")
                {
                    ApplicationArea = All;
                }
                field("RME Code"; Rec."RME Code")
                {
                    ApplicationArea = All;
                }
                field("ZMM Code"; Rec."ZMM Code")
                {
                    ApplicationArea = All;
                }
                field("HOD Code"; Rec."HOD Code")
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                Promoted = true;
                Image = Invoice;
                PromotedCategory = Report;

                trigger OnAction()
                begin
                    recSalesInvHdr.RESET();
                    recSalesInvHdr.SETRANGE("No.", Rec."No.");
                    IF recSalesInvHdr.FIND('-') THEN
                        REPORT.RUN(50004, TRUE, FALSE, recSalesInvHdr);
                end;
            }
            action("E-Invoice SalesInvoice")
            {
                ApplicationArea = All;
                Caption = 'E-Invoice SalesInvoice';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocument;

                trigger OnAction()
                var
                    CU50012: Codeunit 50012;
                begin
                    CU50012.CreateJsonSalesInvoiceOrder(Rec);
                end;
            }
        }
    }

    var
        recSalesInvHdr: Record 112;
}

