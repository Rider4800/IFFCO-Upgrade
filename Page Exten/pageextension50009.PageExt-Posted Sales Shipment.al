pageextension 50009 pageextension50009 extends "Posted Sales Shipment"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Shipment"(Page 130)".

    layout
    {
        addafter(SalesShipmLines)
        {
            group("Sales Hierarchy")
            {
                Caption = 'Sales Hierarchy';
                field("FO Code"; Rec."FO Code")
                {
                }
                field("FA Code"; Rec."FA Code")
                {
                }
                field("TME Code"; Rec."TME Code")
                {
                }
                field("RME Code"; Rec."RME Code")
                {
                }
                field("ZMM Code"; Rec."ZMM Code")
                {
                }
                field("HOD Code"; Rec."HOD Code")
                {
                }
            }
        }
    }
}

