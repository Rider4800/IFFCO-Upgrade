pageextension 50119 VendorCard extends "Vendor Card"
{
    layout
    {
        modify("Aggregate Turnover")
        {
            Caption = 'RCM Applicability';

        }
        addafter(Transporter)
        {
            field("Finance Branch A/c Code"; rec."Finance Branch A/c Code")
            {
                ApplicationArea = all;
            }
            field("Created By"; rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Creation DateTime"; rec."Creation DateTime")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }

    }

    actions
    {

    }
    trigger OnOpenPage()
    begin
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            rec.FILTERGROUP(2);
            rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            rec.FILTERGROUP(0);
        END;
    end;

    var
        UserMgt: Codeunit "User Setup Management";
}