pageextension 50051 pageextension50051 extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
            }
        }
        addafter(Description)
        {
            field("Description2"; Rec."Description 2")
            {
                Caption = 'Description 2';
            }
            field("Technical Name"; Rec."Technical Name")
            {
            }
        }
        addafter(Inventory)
        {
            group(SubGroup)
            {
                field(OpeningBal_Caption; OpeningBal_Caption)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field("Opening Balance Qty. in KG"; Rec."Opening Balance Qty. in KG")
                {
                    Caption = 'Opening Balance Qty. in KG';
                    //OptionCaption = 'OpeningBal_Caption';
                    ShowCaption = false;
                }
            }
        }
        addafter(Blocked)
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                Editable = false;
            }
        }
        addafter("Lead Time Calculation")
        {
            field("Units per Parcel"; Rec."Units per Parcel")
            {
            }
        }
    }

    var
        "Quantity in CRTN/KG": Decimal;
        recItemUOM: Record 5404;
        recItem: Record 27;
        OpeningBal_Caption: Text;

    trigger OnOpenPage()
    begin
        //ACX-RK 23032021 Begin
        recItem.RESET();
        recItem.SETRANGE("No.", Rec."No.");
        IF recItem.FINDFIRST THEN BEGIN
            recItemUOM.RESET();
            recItemUOM.SETRANGE("Item No.", recItem."No.");
            recItemUOM.SETRANGE(Code, recItem."Sales Unit of Measure");
            IF recItemUOM.FINDFIRST THEN BEGIN
                recItem.CALCFIELDS(Inventory);
                recItem."Opening Balance Qty. in KG" := recItem.Inventory * recItemUOM."Qty. per Unit of Measure";
                recItem.MODIFY;
            END;
        END;

        OpeningBal_Caption := 'Opening Balance Qty. in ' + FORMAT(Rec."Sales Unit of Measure");
    end;
}

