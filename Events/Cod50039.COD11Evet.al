codeunit 50039 COD11Evet
{
    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckZeroAmount', '', false, false)]
    local procedure OnBeforeCheckZeroAmount(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
}
