pageextension 50056 pageextension50056 extends "Bank Account Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Creation DateTime"; rec."Creation DateTime")
            {
                Editable = false;
            }
        }
    }
}

