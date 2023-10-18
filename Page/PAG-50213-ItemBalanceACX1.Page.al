page 50213 "Item Balance-ACX1"
{
    PageType = List;
    SourceTable = 27;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field("Location Filter"; LocationFilter)
                {
                    Caption = 'Location Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CLEAR(LocationList);
                        //CLEAR(PAGE);
                        LocationList.LOOKUPMODE := TRUE;
                        IF LocationList.RUNMODAL = ACTION::LookupOK THEN
                            Text := LocationList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        LocFilterOnAfterValidate
                    end;
                }
                field("Date Filter"; dateFilter)
                {
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        TextManagement.MakeDateFilter(dateFilter);
                        IF dateFilter <> '' THEN
                            StartingDateFilterOnAfterValid;
                    end;
                }
            }
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("No. 2"; Rec."No. 2")
                {
                    Caption = 'No. 2';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    Editable = false;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                }
                field(Increases; Rec.Increases)
                {
                }
                field(Decreases; Rec.Decreases)
                {
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                field("Product Group Code"; ProdGrpCode)
                {
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                }
                field("CIB Registration"; Rec."CIB Registration")
                {
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                }
                //->Team-17783
                //     field("MRP Price"; "MRP Price")
                //     {
                //     }
                //->Team-17783  Commented as this field is not present in BC. Need to review
            }
        }
    }

    trigger OnOpenPage()
    begin
        //MZH
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FILTERGROUP(0);
        END;
        //MZH
    end;

    trigger OnAfterGetRecord()
    begin
        recItem.GET(Rec."No.");
        if recItmCtg.Get(recItem."Item Category Code") then
            ProdGrpCode := recItmCtg."Parent Category";
    end;

    var
        dateFilter: Text;
        LocationList: Page 15;
        LocationFilter: Code[20];
        cdSecurityCtr: Code[20];
        cdSecurityCtrGD1: Code[20];
        UserMgt: Codeunit "User Setup Management";
        TextManagement: Codeunit 41;
        recItmCtg: Record 5722;
        ProdGrpCode: Code[20];
        recItem: Record Item;

    procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    procedure LocFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    procedure SetRecFilters()
    begin
        IF LocationFilter <> '' THEN BEGIN
            Rec.SETFILTER("Location Filter", LocationFilter);
        END ELSE
            Rec.SETRANGE("Location Filter");


        IF dateFilter <> '' THEN BEGIN
            Rec.SETFILTER("Date Filter", dateFilter);
            Rec.SETRANGE("Opening Filter", 0D, Rec.GETRANGEMIN(Rec."Date Filter") - 1);
        END ELSE BEGIN
            Rec.SETRANGE("Date Filter");
            Rec.SETRANGE("Opening Filter");
        END;

        CurrPage.UPDATE(FALSE);
    end;
}

