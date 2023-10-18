codeunit 50007 TransferHeaderTableEvent
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterInitFromTransferFromLocation', '', false, false)]
    local procedure OnAfterInitFromTransferFromLocation(Location: Record Location; var TransferHeader: Record "Transfer Header")
    begin
        Location.TESTFIELD("Shortcut Dimension 1 Code");//KM010721
        Location.TESTFIELD("Shortcut Dimension 2 Code");//KM010721
        TransferHeader.VALIDATE("Shortcut Dimension 1 Code", Location."Shortcut Dimension 1 Code");//KM
        TransferHeader.VALIDATE("Shortcut Dimension 2 Code", Location."Shortcut Dimension 2 Code");//KM
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterInitFromTransferToLocation', '', false, false)]
    local procedure OnAfterInitFromTransferToLocation(Location: Record Location; var TransferHeader: Record "Transfer Header")
    begin
        Location.TESTFIELD("Shortcut Dimension 1 Code");//KM010721
        Location.TESTFIELD("Shortcut Dimension 2 Code");//KM010721
    end;
}
