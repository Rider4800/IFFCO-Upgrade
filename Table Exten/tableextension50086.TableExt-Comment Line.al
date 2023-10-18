tableextension 50086 tableextension50086 extends "Comment Line"
{
    fields
    {
        field(50000; EditRestrict; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
    }

    var
        recCommentLine: Record 97;
        Editable: Boolean;
}

