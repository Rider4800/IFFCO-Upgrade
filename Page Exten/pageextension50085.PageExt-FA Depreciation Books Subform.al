pageextension 50085 pageextension50085 extends "FA Depreciation Books Subform"
{
    layout
    {
        addafter("No. of Depreciation Months")
        {
            field("Acquisition Date"; rec."Acquisition Date")
            {
            }
        }
        moveafter("Fixed Depr. Amount"; "Salvage Value")

    }
}

