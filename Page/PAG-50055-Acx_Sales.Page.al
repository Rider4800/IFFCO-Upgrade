page 50055 Acx_Sales
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Acx_Sales';
    DelayedInsert = true;
    EntityName = 'Acx_Sales';
    EntitySetName = 'Acx_Sales';
    PageType = API;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Source_Code; SourceCode)
                {
                }
                field(Transaction_Type; TrnType)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();

        SILRec.Reset();
        SILRec.SetFilter(Quantity, '<>%1', 0);
        SILRec.SetFilter(Type, '%1|%2|%3', SILRec.Type::"Charge (Item)", SILRec.Type::Item, SILRec.Type::"G/L Account");
        SILRec.SetFilter("No.", '<>%1|<>%2|<>%3|<>%4|<>%5|<>%6|<>%7|<>%8|<>%9|<>%10', '424700020', '424700010', '424700090', '424700110', '424700030', '424700100', '424800020', '427000330', '427000210', '424800080');
        if SILRec.FindFirst() then begin
            repeat
                Rec.Init();
                Rec.TransferFields(SILRec);
                Rec.Insert();
                Rec."Assessee Code" := 'SIL';
                Rec.Modify();
            until SILRec.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        ClearVariables();

        if Rec."Assessee Code" = 'SIL' then begin
            if SIHRec.Get(Rec."Document No.") then begin
                SourceCode := SIHRec."Source Code";
                TrnType := 'Invoice';
            end;
        end;
    end;

    procedure ClearVariables()
    begin
        Clear(SourceCode);
        Clear(TrnType);
        PostDate := 0D;
        DocDate := 0D;
        Clear(OrderNo);
    end;

    var
        SILRec: Record "Sales Invoice Line";
        SIHRec: Record "Sales Invoice Header";
        SourceCode: Code[20];
        TrnType: Text[20];
        SIHNo: Code[20];
        PostDate: Date;
        DocDate: Date;
        OrderNo: Code[20];
        OrderDate: Date;
}