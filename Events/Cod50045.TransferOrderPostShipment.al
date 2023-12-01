codeunit 50045 TransferOrderPostShipment
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        recItemUOM: Record "Item Unit of Measure";
        recItem: Record Item;
        recEwayEinvoice: Record "E-Way Bill & E-Invoice";
        recLocation: Record Location;
        recEwayEinvoice2: Record "E-Way Bill & E-Invoice";
        recTransportMenthod: Record "Transport Method";
        TransMethd: Code[10];
        cuq: Codeunit "TransferOrder-Post Receipt";
    begin
        TransShptHeader."Transporter Code" := TransHeader."Transporter Code"; //HT (For E-Way Bill and E-Invoice Integration)
        TransShptHeader."Transporter Name" := TransHeader."Transporter Name";
        TransShptHeader."Transporter GSTIN" := TransHeader."Transporter GSTIN";//ACX-RK 220521
        TransShptHeader."Transfer-To Bin Code" := TransHeader."Transfer-To Bin Code";//KM230621
        TransShptHeader."Transfer-To Bin Code" := TransHeader."Transfer-To Bin Code";//KM230621
        TransShptHeader.VALIDATE("Responsibility Center", TransHeader."Responsibility Center");//KM060721
        TransShptHeader."Port Code" := TransHeader."Port Code"; //HT (For E-Way Bill and E-Invoice Integration)

        //HT (For E-Way Bill and E-Invoice Integration)-
        recEwayEinvoice.INIT;
        recEwayEinvoice."No." := TransShptHeader."No.";
        recEwayEinvoice."Posting Date" := TransShptHeader."Posting Date";

        recLocation.RESET();
        recLocation.SETRANGE(Code, TransShptHeader."Transfer-from Code");
        IF recLocation.FIND('-') THEN BEGIN
            recEwayEinvoice."Location Code" := TransShptHeader."Transfer-from Code";
            recEwayEinvoice."Location State Code" := recLocation."State Code";
            recEwayEinvoice."Location GST Reg. No." := recLocation."GST Registration No.";
        END;

        recLocation.RESET();
        recLocation.SETRANGE(Code, TransShptHeader."Transfer-to Code");
        IF recLocation.FIND('-') THEN BEGIN
            recEwayEinvoice."Transfer-to Code" := TransShptHeader."Transfer-to Code";
            recEwayEinvoice."Sell-to Customer Name" := recLocation.Name;
            recEwayEinvoice."Sell-to Address" := recLocation.Address;
            recEwayEinvoice."Sell-to Address 2" := recLocation."Address 2";
            recEwayEinvoice."Sell-to City" := recLocation.City;
            recEwayEinvoice."Sell-to Post Code" := recLocation."Post Code";
            recEwayEinvoice.State := recLocation."State Code";
            recEwayEinvoice."Customer GST Reg. No." := recLocation."GST Registration No.";
            recEwayEinvoice."Sell-to Country/Region Code" := recLocation."Country/Region Code";
        END;

        recEwayEinvoice."Transporter Code" := TransShptHeader."Transporter Code";
        recEwayEinvoice."Port Code" := TransShptHeader."Port Code";
        recEwayEinvoice."Distance (Km)" := FORMAT(TransShptHeader."Distance (Km)");

        IF TransShptHeader."Vehicle Type" = TransShptHeader."Vehicle Type"::" " THEN BEGIN
            recEwayEinvoice."Vehicle Type" := recEwayEinvoice."Vehicle Type"::" ";
        END ELSE
            IF TransShptHeader."Vehicle Type" = TransShptHeader."Vehicle Type"::ODC THEN BEGIN
                recEwayEinvoice."Vehicle Type" := recEwayEinvoice."Vehicle Type"::"over dimensional cargo";
            END ELSE
                IF TransShptHeader."Vehicle Type" = TransShptHeader."Vehicle Type"::Regular THEN BEGIN
                    recEwayEinvoice."Vehicle Type" := recEwayEinvoice."Vehicle Type"::regular;
                END;

        recEwayEinvoice."LR/RR No." := TransShptHeader."LR/RR No.";
        recEwayEinvoice."LR/RR Date" := TransShptHeader."LR/RR Date";
        recEwayEinvoice."Vehicle No." := TransShptHeader."Vehicle No.";
        recEwayEinvoice."Mode of Transport" := UPPERCASE(TransShptHeader."Mode of Transport");
        recEwayEinvoice."Transaction Type" := 'Transfer Shipment';
        recEwayEinvoice."Transporter GSTIN" := TransHeader."Transporter GSTIN";//RK 22May21
        recEwayEinvoice."E-way Bill Part" := recEwayEinvoice."E-way Bill Part"::Registered;//RK 05May22
        //RK 29Mar21 Begin
        IF recTransportMenthod.GET(TransShptHeader."Transport Method") THEN
            TransMethd := FORMAT(recTransportMenthod."Transportation Mode");
        EVALUATE(recEwayEinvoice."Transportation Mode", TransMethd);
        //RK End
        recEwayEinvoice.INSERT;
        //HT (For E-Way Bill and E-Invoice Integration)+
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    local procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header"; InvtPickPutaway: Boolean)
    begin
        UpdateGDAsPerLocation(TransferHeader."No.");//KM
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