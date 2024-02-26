pageextension 50094 pageextension50094 extends "Transfer Route Specification"
{
    layout
    {
        addafter("In-Transit Code")
        {
            // field(Structure; Rec.Structure)
            // {
            //     ApplicationArea = All;
            // }
            field("GST Applicable"; Rec."GST Applicable")
            {
                ApplicationArea = All;
            }
        }
    }
}

