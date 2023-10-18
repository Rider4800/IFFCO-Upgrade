pageextension 50016 pageextension50016 extends "TDS Setup"
{
    layout
    {
        addafter("Nil Pay TDS Document Nos.")
        {
            field("Calc. Over & Above Threshold"; Rec."Calc. Over & Above Threshold")
            {
            }
        }
    }
}

