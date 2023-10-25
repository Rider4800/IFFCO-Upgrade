codeunit 50046 TransferOrderPostReceipt
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeTransRcptHeaderInsert(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Transporter Code" := TransferHeader."Transporter Code"; //HT (For E-Way Bill and E-Invoice Integration)
        TransferReceiptHeader."Transporter Name" := TransferHeader."Transporter Name";
        TransferReceiptHeader."Transporter GSTIN" := TransferHeader."Transporter GSTIN";//ACX-RK 220521
        TransferReceiptHeader."Transfer-from Bin Code" := TransferHeader."Transfer-from Bin Code";//KM230621
        TransferReceiptHeader."Transfer-To Bin Code" := TransferHeader."Transfer-To Bin Code";//KM230621
        TransferReceiptHeader.VALIDATE("Responsibility Center", TransferHeader."Responsibility Center");//KM060721
        TransferReceiptHeader."Port Code" := TransferHeader."Port Code"; //HT 24082020 (For E-Way Bill and E-Invoice Integration)
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', false, false)]
    local procedure OnAfterTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        //km010721
        UpdateGDAsPerLocation(TransferHeader."No.");//KM010721
    end;

    procedure UpdateGDAsPerLocation("DocNo.": Code[20])
    var
        recTransferOrder: Record "Transfer Header";
        recLocation: Record Location;
    begin
        recTransferOrder.RESET();
        recTransferOrder.SETRANGE("No.", "DocNo.");
        IF recTransferOrder.FINDFIRST THEN BEGIN
            recLocation.RESET();
            recLocation.SETRANGE(Code, recTransferOrder."Transfer-to Code");
            IF recLocation.FINDFIRST THEN BEGIN
                recTransferOrder.VALIDATE("Shortcut Dimension 1 Code", recLocation."Shortcut Dimension 1 Code");
                recTransferOrder.VALIDATE("Shortcut Dimension 2 Code", recLocation."Shortcut Dimension 2 Code");
                recTransferOrder.MODIFY();
            END ELSE BEGIN
                recLocation.TESTFIELD("Shortcut Dimension 1 Code");
                recLocation.TESTFIELD("Shortcut Dimension 2 Code");
            END;
        END;
    end;
}