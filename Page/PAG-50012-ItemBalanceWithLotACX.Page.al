page 50012 "Item Balance With Lot-ACX"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 6505;

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
                        LocFilterOnAfterValidate;
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
                Enabled = false;
                field("Item No."; Rec."Item No.")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field(Description; recItem.Description)
                {
                }
                field("Base Unit of Measure"; recItem."Base Unit of Measure")
                {
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
                field("Product Group Code"; ProdGrpCode)
                {
                }
                field("Item Category Code"; recItem."Item Category Code")
                {
                }
                field("Inventory Posting Group"; recItem."Inventory Posting Group")
                {
                }
                field("MFG Date"; Rec."MFG Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Total Inventory>")
            {
                Caption = '&Total Inventory';
                Image = CalculateInventory;

                trigger OnAction()
                begin
                    decOpening := 0;
                    decIncrease := 0;
                    decDecrease := 0;
                    decClosing := 0;

                    recItem.COPYFILTERS(Rec);
                    IF recItem.FIND('-') THEN BEGIN
                        REPEAT
                            recItem.CALCFIELDS("Opening Balance", Increases, Decreases, "Closing Balance");
                            decOpening += recItem."Opening Balance";
                            decIncrease += recItem.Increases;
                            decDecrease += recItem.Decreases;
                            decClosing += recItem."Closing Balance";

                        UNTIL recItem.NEXT = 0;
                    END;
                    MESSAGE('Opening          : %1' +
                            '\Increases       : %2' +
                            '\Decreases       : %3' +
                            '\Closing         : %4',
                              decOpening,
                              decIncrease,
                              decDecrease,
                              decClosing);
                end;
            }
            action("Total Amount")
            {
                Caption = '&Total Amount';

                trigger OnAction()
                begin
                    /*
                    decOpeningAmnt := 0 ;
                    decIncreaseAmnt := 0 ;
                    decDecreaseAmnt := 0 ;
                    decClosingAmnt := 0 ;
                    
                    recItem.COPYFILTERS(Rec) ;
                    IF recItem.FIND('-') THEN BEGIN
                       REPEAT
                         recItem.CALCFIELDS("Amount Opening Balance", "Amount Increases", "Amount Decreases", "Amount Closing Balance") ;
                         decOpeningAmnt += recItem."Amount Opening Balance" ;
                         decIncreaseAmnt += recItem."Amount Increases" ;
                         decDecreaseAmnt += recItem."Amount Decreases" ;
                         decClosingAmnt += recItem."Amount Closing Balance" ;
                    
                       UNTIL recItem.NEXT = 0 ;
                       END ;
                       MESSAGE('Opening          : %1' +
                               '\Increases       : %2'+
                               '\Decreases       : %3'+
                               '\Closing         : %4',
                                 decOpeningAmnt,
                                 decIncreaseAmnt,
                                 decDecreaseAmnt,
                                 decClosingAmnt) ;
                    */

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        recItem.GET(Rec."Item No.");
        if recItmCtg.Get(recItem."Item Category Code") then
            ProdGrpCode := recItmCtg."Parent Category";
        /*
        txtItemCategory := '';
        txtPrdGroup := '';
        
        recItmCtg.RESET;
        recItmCtg.SETRANGE(recItmCtg.Code,"Item Category Code");
        IF recItmCtg.FIND('-') THEN BEGIN
           txtItemCategory := recItmCtg.Description ;
           recProdGrp.RESET;
           recProdGrp.SETRANGE(recProdGrp."Item Category Code",recItmCtg.Code);
           recProdGrp.SETRANGE(recProdGrp.Code,"Product Group Code");
           IF recProdGrp.FIND('-') THEN
              txtPrdGroup := recProdGrp.Description ;
        END;
        
        txtBrandName := '';
        
        recDimValue.RESET;
        recDimValue.SETFILTER(recDimValue."Dimension Code",'Brand');
        recDimValue.SETRANGE(recDimValue.Code,"Attribute 4");
        IF recDimValue.FIND('-') THEN
           txtBrandName := recDimValue.Name;
        */

    end;

    trigger OnOpenPage()
    begin
        //ACXBASE
        //SecCtrMgmt.ApplyItemSecurity(Rec, cdSecurityCtr, cdSecurityCtrGD1) ;
        //ACXBASE
    end;

    var
        dateFilter: Text;
        LocationList: Page 15;
        LocationFilter: Code[20];
        cdSecurityCtr: Code[20];
        cdSecurityCtrGD1: Code[20];
        recItmCtg: Record 5722;
        //recProdGrp: Record 5723;  
        txtItemCategory: Text[50];
        txtPrdGroup: Text[50];
        recDimValue: Record 349;
        txtBrandName: Text[50];
        decOpening: Decimal;
        decIncrease: Decimal;
        decDecrease: Decimal;
        decClosing: Decimal;
        recItem: Record 27;
        decOpeningAmnt: Decimal;
        decIncreaseAmnt: Decimal;
        decDecreaseAmnt: Decimal;
        decClosingAmnt: Decimal;
        TextManagement: Codeunit 41;
        ProdGrpCode: Code[20];

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

        //EVALUATE("Date Filter", dateFilter);

        IF dateFilter <> '' THEN BEGIN
            Rec.SETFILTER("Date Filter", dateFilter);
            Rec.SETRANGE("MFG Date", 0D, Rec.GETRANGEMIN(Rec."Date Filter") - 1);
        END ELSE BEGIN
            Rec.SETRANGE("Date Filter");
            Rec.SETRANGE("MFG Date");
        END;

        CurrPage.UPDATE(FALSE);
    end;
}

