pageextension 50099 pageextension50099 extends "Lot No. Information List"
{

    layout
    {
        modify("Variant Code")
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
        modify(CommentField)
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("MFG Date"; Rec."MFG Date")
            {
            }
            field("Expiration Date"; Rec."Expiration Date")
            {
            }
            field("Batch MRP"; Rec."Batch MRP")
            {
            }
        }
    }

    var
        recReservationEntry: Record 337;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        recReservationEntry.RESET();
        recReservationEntry.SETRANGE("Item No.", Rec."Item No.");
        recReservationEntry.SETRANGE("Lot No.", Rec."Lot No.");
        IF recReservationEntry.FINDFIRST THEN BEGIN
            recReservationEntry."MFG Date" := Rec."MFG Date";
            recReservationEntry."Batch MRP" := Rec."Batch MRP";
            //    recReservationEntry.MODIFY;
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('Insertion is not allowed');
    end;
}

