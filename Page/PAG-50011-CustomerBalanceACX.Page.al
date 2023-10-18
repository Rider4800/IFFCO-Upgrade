page 50011 "Customer Balance-ACX"
{
    PageType = List;
    SourceTable = 18;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field("Global Dimension 1 Filter"; Dim1Filter)
                {
                    Caption = 'Global Dimension 1 Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CLEAR(DimValList);
                        CLEAR(DimVal);
                        //CLEAR(PAGE);
                        GLSetup.GET();
                        DimVal.RESET;
                        DimVal.SETFILTER("Dimension Code", GLSetup."Global Dimension 1 Code");
                        DimValList.LOOKUPMODE := TRUE;
                        DimValList.SETTABLEVIEW(DimVal);
                        IF DimValList.RUNMODAL = ACTION::LookupOK THEN
                            Text := DimValList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        DimFilterOnAfterValidate;
                    end;
                }
                field("Global Dimension 2 Filter"; Dim2Filter)
                {
                    Caption = 'Global Dimension 2 Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CLEAR(DimValList);
                        CLEAR(DimVal);
                        //CLEAR(PAGE);

                        GLSetup.GET();
                        DimVal.RESET;
                        DimVal.SETFILTER("Dimension Code", GLSetup."Global Dimension 2 Code");
                        DimValList.LOOKUPMODE := TRUE;
                        DimValList.SETTABLEVIEW(DimVal);
                        IF DimValList.RUNMODAL = ACTION::LookupOK THEN
                            Text := DimValList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        DimFilterOnAfterValidate;
                    end;
                }
                field("Date Filter"; DateFilter)
                {
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        TextManagement.MakeDateFilter(DateFilter);
                        IF DateFilter <> '' THEN
                            DateFilterOnAfterValid;
                    end;
                }
            }
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Opening Balance (LCY)"; Rec."Opening Balance (LCY)")
                {
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                }
                field("Closing Balance (LCY)"; Rec."Closing Balance (LCY)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //SecCtrMgmt.ApplyCustSecurity(Rec, cdSecurityCtr, cdSecurityCtrGD1) ;
    end;

    var
        DateFilter: Text;
        Dim1Filter: Code[20];
        Dim2Filter: Code[20];
        DimValList: Page 560;
        DimVal: Record 349;
        GLSetup: Record 98;
        cdSecurityCtr: Code[20];
        cdSecurityCtrGD1: Code[20];
        TextManagement: Codeunit 41;

    procedure DateFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    procedure DimFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    procedure SetRecFilters()
    begin
        IF Dim1Filter <> '' THEN BEGIN
            Rec.SETFILTER("Global Dimension 1 Filter", Dim1Filter);
        END ELSE
            Rec.SETRANGE("Global Dimension 1 Filter");

        IF Dim2Filter <> '' THEN BEGIN
            Rec.SETFILTER("Global Dimension 2 Filter", Dim2Filter);
        END ELSE
            Rec.SETRANGE("Global Dimension 2 Filter");

        IF DateFilter <> '' THEN BEGIN
            Rec.SETFILTER("Date Filter", DateFilter);
            Rec.SETRANGE("Opening Filter", 0D, Rec.GETRANGEMIN(Rec."Date Filter") - 1);
        END ELSE BEGIN
            Rec.SETRANGE("Date Filter");
            Rec.SETRANGE("Opening Filter");
        END;
        CurrPage.UPDATE(FALSE);
    end;
}

