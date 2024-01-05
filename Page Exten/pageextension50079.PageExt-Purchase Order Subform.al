pageextension 50079 pageextension50079 extends "Purchase Order Subform"
{
    layout
    {
        moveafter("IC Partner Ref. Type"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter(Quantity; "TDS Section Code")
        addafter(Quantity)
        {
            /*12887--> "TDS Nature of Deduction" is replaced by "TDS Section Code"
            field("TDS Nature of Deduction"; "TDS Nature of Deduction")
            {
            }<--12887*/
            /*12887----> field is removed 
            field("TDS Amount"; "TDS Amount")
            {
            }
            <--12887*/
        }
        addafter("Direct Unit Cost")
        {
            field("MRP Price"; Rec."MRP Price")
            {
                ApplicationArea = All;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
            {
                ApplicationArea = All;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = All;
            }
            field("Short Quantity Remark"; Rec."Short Quantity Remark")
            {
                ApplicationArea = All;
            }
        }

    }
}

