pageextension 50049 pageextension50049 extends "Source Code Setup"
{
    layout
    {
        addafter("GST Liability Adjustment")
        {
            field("TDSAbove Threshold Opening"; Rec."TDS Above Threshold Opening")
            {
                Caption = 'TDS Above Threshold Opening';
            }
        }
    }
}

