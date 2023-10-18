pageextension 50114 pageextension50114 extends "Purch. Cr. Memo Subform"
{
    layout
    {
        moveafter("Return Reason Code"; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        addafter("Return Reason Code")
        {
            /*12887 field is removed--->
            field("TDS Category"; Rec."TDS Category")
            {
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
            }
            <---field is removed 12887*/
            /*12887---> TDS Nature of Deduction is replaced by TDS Section Code
             field("TDS Nature of Deduction"; "TDS Nature of Deduction")
             {
             }<--12887*/
            field("TDS Section Code"; Rec."TDS Section Code")
            {
            }
            /*12887 field is removed---->
            field("TDS %"; Rec."TDS %")
            {
            }
            field("TDS Amount Including Surcharge"; rec."TDS Amount Including Surcharge")
            {
            }
            field("TDS Base Amount"; rec."TDS Base Amount")
            {
            }
            field("TDS Group"; rec."TDS Group")
            {
            }
            <---12887*/
        }
    }
}

