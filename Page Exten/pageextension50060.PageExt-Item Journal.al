pageextension 50060 pageextension50060 extends "Item Journal"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Opening Balance Qty. in KG"; Rec."Opening Balance Qty. in KG")
            {
                Caption = 'Quantity in KG/CTN';
            }
        }
        addafter("Unit Cost")
        {
            field(Narration; Rec.Narration)
            {
            }
        }
    }
}

