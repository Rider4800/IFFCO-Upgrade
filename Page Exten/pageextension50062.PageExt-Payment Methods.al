pageextension 50062 pageextension50062 extends "Payment Methods"
{
    layout
    {
        addafter("Pmt. Export Line Definition")
        {
            field("Payment Method Branch"; Rec."Payment Method Branch")
            {
            }
        }
    }
}

