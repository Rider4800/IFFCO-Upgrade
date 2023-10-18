codeunit 50030 SaleLineEventSingleInstan
{
    SingleInstance = true;
    procedure ClearVariables()
    begin
        Clear(SaleLineGLb);
    end;

    procedure SetData(SaleLinePara: Record 37)
    begin
        SaleLineGLb := SaleLinePara;

    end;

    procedure GetData(var SaleLinePara: Record 37)
    begin
        SaleLinePara := SaleLineGLb;
    end;

    var
        SaleLineGLb: Record 37;
}
