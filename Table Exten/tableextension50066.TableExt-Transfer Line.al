tableextension 50066 tableextension50066 extends "Transfer Line"
{
    procedure GetHedearBin()
    var
        recTransferHeader: Record 5740;
    begin
        recTransferHeader.RESET();
        recTransferHeader.SETRANGE("No.", Rec."Document No.");
        recTransferHeader.SETRANGE("Transfer-from Code", Rec."Transfer-from Code");
        recTransferHeader.SETRANGE("Transfer-to Code", Rec."Transfer-to Code");
        IF recTransferHeader.FINDFIRST THEN BEGIN
            IF recTransferHeader."Transfer-from Bin Code" <> '' THEN
                Rec.VALIDATE("Transfer-from Bin Code", recTransferHeader."Transfer-from Bin Code");
            IF recTransferHeader."Transfer-To Bin Code" <> '' THEN
                Rec.VALIDATE("Transfer-To Bin Code", recTransferHeader."Transfer-To Bin Code");
        END;
    end;
}

