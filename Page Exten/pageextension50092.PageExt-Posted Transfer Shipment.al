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
            }
            field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
            {
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action("Material Out")
            {
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
        }
    }

    var
        recTransferShipHeader: Record 5744;
}

