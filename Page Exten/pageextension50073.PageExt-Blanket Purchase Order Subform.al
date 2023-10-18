pageextension 50073 pageextension50073 extends "Blanket Purchase Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("MRP Price"; Rec."MRP Price")
            {
            }
        }
    }
}

