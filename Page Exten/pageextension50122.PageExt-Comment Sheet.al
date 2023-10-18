pageextension 50122 CommentSheet extends "Comment Sheet"
{
    layout
    {
        modify(Comment)
        {
            Editable = Editable;
        }
        addbefore(Date)
        {
            field("No."; Rec."No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Code)
        {
            field(EditRestrict; rec.EditRestrict)
            {
                Visible = false;

                trigger OnValidate()
                begin
                    IF Rec.EditRestrict = TRUE THEN
                        Editable := TRUE
                    ELSE
                        Editable := FALSE;
                end;
            }

        }
    }

    actions
    {

    }
    trigger OnAfterGetRecord()

    begin
        IF Rec.EditRestrict = TRUE THEN
            Editable := FALSE
        ELSE
            Editable := TRUE;

    end;

    trigger OnOpenPage()
    begin
        IF Rec.EditRestrict = TRUE THEN
            Editable := FALSE
        ELSE
            Editable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Editable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)

    begin
        Editable := TRUE;

    end;

    var
        Editable: Boolean;
}