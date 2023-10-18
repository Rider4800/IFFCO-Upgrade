pageextension 50050 pageextension50050 extends "Recurring General Journal"
{
    layout
    {
        addafter("Depreciation Book Code")
        {
            field("Gen.Prod.PostingGroup"; Rec."Gen. Prod. Posting Group")
            {
                Caption = 'Gen. Prod. Posting Group';
            }
        }
        addafter("VAT Difference")
        {
            field("Provisional Entries"; Rec."Provisional Entries")
            {
                Editable = false;
            }
        }
    }
}

