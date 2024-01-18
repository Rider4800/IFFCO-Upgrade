pageextension 50090 pageextension50090 extends "Transfer Order"
{

    layout
    {
        //12887---> In-transit code is made non editable on transfer header table but change in editable propert not possible in table ext
        modify("In-Transit Code")
        {
            Editable = false;
        }
        //<---12887
        addafter("Transfer-from Code")
        {
            field("Transfer-from Bin Code"; Rec."Transfer-from Bin Code")
            {
                ApplicationArea = All;
            }

        }
        moveafter("Transfer-from Bin Code"; "Transfer-from Name")
        addafter("Transfer-to Code")
        {
            field("Transfer-To Bin Code"; Rec."Transfer-To Bin Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Transfer-To Bin Code"; "Transfer-to Name")
        addafter(Status)
        {
            field("Jobwork PO"; Rec."Jobwork PO")
            {
                ApplicationArea = All;
            }
        }
        addafter("Load Unreal Prof Amt on Invt.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field(ExpiryStockMovementAllowed; Rec.ExpiryStockMovementAllowed)
            {
                Caption = 'Expiry Stock Movement Allowed';
                Editable = ExpiryStockMovemAllowed;
                //Enabled = ExpiryStockMovemAllowed;
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    IF Rec.Status = Rec.Status::Released THEN BEGIN
                        ERROR('You can not modify please reopen ')
                    END;
                end;
            }
        }
        addafter("LR/RR Date")
        {
            field("Transporter Code"; Rec."Transporter Code")
            {
                ApplicationArea = All;
            }
            field("Transporter Name"; Rec."Transporter Name")
            {
                ApplicationArea = All;
            }
            field("Transporter GSTIN"; Rec."Transporter GSTIN")
            {
                ApplicationArea = All;
            }
            field("Port Code"; Rec."Port Code")
            {
                ApplicationArea = All;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        recusersetup: Record 91;
        ExpiryStockMovemAllowed: Boolean;
        recitemtracking: Record 336;
        rectransorderline: Record 5741;
        rectransheader: Record 5740;
        Checkboolen: Boolean;
        Editableeditfield: Boolean;
        rectrackingline: Record 336;


    trigger OnAfterGetCurrRecord()
    begin
        // IF Rec.Status = Rec.Status::Open THEN BEGIN
        //     Editableeditfield := TRUE;
        // END;
        // IF Rec.Status = Rec.Status::Released THEN BEGIN
        //     Editableeditfield := FALSE
        // END;
        // Rec.MODIFY;
        ExpiryStockMovementAllowedFuc();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('Deletion is not allowed.');
    end;

    local procedure ExpiryStockMovementAllowedFuc()
    begin
        recusersetup.GET(USERID);
        IF recusersetup.ExpiryStockMovementAllowed = TRUE THEN BEGIN
            ExpiryStockMovemAllowed := TRUE;
        END ELSE
            ExpiryStockMovemAllowed := FALSE;
    end;
}

