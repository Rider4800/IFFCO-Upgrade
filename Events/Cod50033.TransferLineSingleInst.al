codeunit 50033 TransferLineSingleInst
{
    SingleInstance = true;
    procedure ClearVariables()
    begin
        Clear(ItemNoGLb);
    end;

    procedure SetData(ItemNoPara: Code[20])
    begin
        ItemNoGLb := ItemNoPara;

    end;

    procedure GetData(var ItemNoPara: Code[20])
    begin
        ItemNoPara := ItemNoGLb;
    end;

    var
        ItemNoGLb: Code[20];
}
