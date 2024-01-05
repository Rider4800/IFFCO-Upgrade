pageextension 50098 pageextension50098 extends "Lot No. Information Card"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Test Quality")
        {
            Visible = false;
        }
        modify("Certificate Number")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = false;
        }
        addafter("Lot No.")
        {
            field("Expiration Date"; Rec."Expiration Date")
            {
                ApplicationArea = All;
            }
            field("MFG Date"; Rec."MFG Date")
            {
                ApplicationArea = All;
            }
            field("Batch MRP"; Rec."Batch MRP")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        recTrackingList: Record 336;
        recReservationEntry: Record 337;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        recReservationEntry.RESET();
        recReservationEntry.SETRANGE("Lot No.", Rec."Lot No.");
        recReservationEntry.SETRANGE("Item No.", Rec."Item No.");
        IF recReservationEntry.FINDFIRST THEN BEGIN
            recReservationEntry."MFG Date" := Rec."MFG Date";
            //recReservationEntry."Expiration Date" := Rec."Expiration Date";
            recReservationEntry."Batch MRP" := Rec."Batch MRP";
            recReservationEntry.MODIFY;
        END;

    end;
}

