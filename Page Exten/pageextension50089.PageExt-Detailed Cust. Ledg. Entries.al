pageextension 50089 pageextension50089 extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
            {
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Import Excel")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    CU50200: Codeunit 50200;
                begin
                    CU50200.ImportExcel();
                end;
            }
            action("delete data")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    Rec7001: Record 7001;
                begin
                    Rec7001.Reset();
                    if Rec7001.FindSet() then
                        repeat
                            Rec7001.Delete();
                        until Rec7001.Next() = 0;
                    Message('deleted price list line');
                end;
            }
            action("export sales price data")
            {
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                begin
                    Xmlport.Run(50002, true, false);
                    Message('EXPORTED SALES PRICE');
                end;
            }
            action("import sales price data")
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                begin
                    Xmlport.Run(50003, false, true);
                    Message('IMPORTED SALES PRICE');
                end;
            }
        }
    }
}

