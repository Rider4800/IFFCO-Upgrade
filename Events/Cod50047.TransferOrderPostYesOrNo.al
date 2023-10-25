codeunit 50047 TransferOrderPostYesOrNo
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', false, false)]
    local procedure OnBeforePost(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean; var TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment"; var TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt"; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post")
    var
        recTransferLine: Record "Transfer Line";
    begin
        //KM
        recTransferLine.RESET();
        recTransferLine.SETRANGE("Document No.", TransHeader."No.");
        IF recTransferLine.FINDFIRST THEN BEGIN
            REPEAT
                recTransferLine.TESTFIELD("Transfer Price");
            UNTIL recTransferLine.NEXT = 0;
        END;//KM
    end;
}