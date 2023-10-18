pageextension 50086 pageextension50086 extends "Location Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; rec."Name 2")
            {
            }
        }
        addafter("Use As In-Transit")
        {
            field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
            {
            }
            field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
            {
            }
            field("Responsibility Center"; rec."Responsibility Center")
            {
            }
            field("Creation DateTime"; rec."Creation DateTime")
            {
                Editable = false;
            }
        }
        addafter("Tax Information")
        {
            group("Ship-To Information")
            {
                Caption = 'Ship-To Information';
                field(ShipToAddress; Rec.ShipToAddress)
                {
                }
                field("Ship-To Name"; Rec."Ship-To Name")
                {
                }
                field("Ship-To Name2"; Rec."Ship-To Name2")
                {
                }
                field("Ship-To Address"; Rec."Ship-To Address")
                {
                }
                field("Ship-To Address2"; Rec."Ship-To Address2")
                {
                }
                field("Ship-To City"; Rec."Ship-To City")
                {
                }
                field("Ship-To PostCode"; Rec."Ship-To PostCode")
                {
                }
                field("Ship-To StateCode"; Rec."Ship-To StateCode")
                {
                }
                field("Ship-To Country/RegionCode"; Rec."Ship-To Country/RegionCode")
                {
                }
            }
        }
    }
}

