pageextension 50095 pageextension50095 extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Receipt Date")
        {
            field("Transfer Order Date"; Rec."Transfer Order Date")
            {
            }
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action("Jobwork Issue Register")
            {
                Caption = 'Jobwork Issue Register';
                Image = ListPage;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page 50015;
                ApplicationArea = ALL;
            }
            action("Material Out")
            {
                Promoted = true;
                PromotedCategory = "Report";
                Visible = true;
                ApplicationArea = ALL;

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
                ApplicationArea = ALL;

                trigger OnAction()
                begin
                    recTransferShipHeader.RESET();
                    recTransferShipHeader.SETRANGE("No.", Rec."No.");
                    IF recTransferShipHeader.FIND('-') THEN BEGIN
                        REPORT.RUN(50015, TRUE, FALSE, recTransferShipHeader);
                    END;
                end;
            }
        }
    }

    var
        recTransferShipHeader: Record 5744;
}

