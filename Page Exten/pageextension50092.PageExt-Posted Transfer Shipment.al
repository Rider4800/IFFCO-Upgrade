pageextension 50092 pageextension50092 extends "Posted Transfer Shipment"
{
    layout
    {

        modify("Transfer-from Post Code")
        {
            Visible = false;
        }
        addafter("In-Transit Code")
        {
            field("Transfer-from Bin Code"; Rec."Transfer-from Bin Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action("Material Out")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Report";
                Visible = true;

                trigger OnAction()
                begin
                    recTransferShipHeader.RESET();
                    recTransferShipHeader.SETRANGE("No.", Rec."No.");
                    IF recTransferShipHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50007, TRUE, FALSE, recTransferShipHeader);
                    END;
                end;
            }
            action("Branch Transfer")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    recTransferShipHeader.RESET();
                    recTransferShipHeader.SETRANGE("No.", Rec."No.");
                    IF recTransferShipHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50015, TRUE, FALSE, recTransferShipHeader);
                    END;
                end;
            }
            action("Consignment Branch Transfer")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    recTransferShipHeader.RESET();
                    recTransferShipHeader.SETRANGE("No.", Rec."No.");
                    IF recTransferShipHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50020, TRUE, FALSE, recTransferShipHeader);
                    END;
                end;
            }
            action("E-Invoice TransferShipment")
            {
                ApplicationArea = All;
                Caption = 'E-Invoice TransferShipment';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocument;

                trigger OnAction()
                var
                    CU50014: Codeunit 50014;
                begin
                    CU50014.CreateJsonTransferShipOrder(Rec);
                end;
            }
        }
    }

    var
        recTransferShipHeader: Record 5744;
}

