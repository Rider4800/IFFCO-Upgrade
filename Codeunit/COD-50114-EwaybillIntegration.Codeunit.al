codeunit 50114 EwayBillIntegration

{
    Permissions = tabledata "Sales Invoice Header" = rm;

    trigger OnRun()
    begin

    end;

    var
        Team001: Label 'Error When Contacting API';
        G_Authenticate_URL: Text;
        G_Authenticate_URL2: Text;
        G_Authenticate_URL3: text;
        G_Authenticate_URL4: Text;


    procedure GenerateEWayBill(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        JEWayPayload: JsonObject;
        GSTIN: Code[20];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        LocationG: Record Location;
        PayloadText: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    if SalesInvoiceHeader.get(DocNo) then begin
                        GSTIN := SalesInvoiceHeader."Location GST Reg. No.";
                    end;
                end;
            DocumentType::"Credit Memo":
                begin
                    if SalesCrMemoHeader.get(DocNo) then
                        GSTIN := SalesCrMemoHeader."Location GST Reg. No.";
                end;
            DocumentType::"Transfer Shipment":
                begin
                    if TransferShipmentHeader.get(DocNo) then begin
                        if LocationG.get(TransferShipmentHeader."Transfer-from Code") then
                            GSTIN := LocationG."GST Registration No.";
                    end;
                end;
        end;

        ReadActionDetails(JEWayPayload, DocNo, DocumentType);
        ReadItemDetails(DocNo, DocumentType, JEWayPayload);
        JEWayPayload.WriteTo(PayloadText);
        Message(PayloadText);
        GenerateEwayRequestSendtobinary(DocNo, DocumentType, PayloadText)
    end;

    local procedure ReadActionDetails(var JReadActionDtls: JsonObject; DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        EWay_SalesInvoiceHeader: Record "Sales Invoice Header";
        EWay_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        EWay_transferShipmentHeader: Record "Transfer Shipment Header";
        DtldGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        recLoc: Record Location;
        RecCompanyInfo: Record "Company Information";
        RecState: Record State;
        RecShiptoAdd: Record "Ship-to Address";
        DtldGSTLedgerEntry2: Record "Detailed GST Ledger Entry";
        Val_DetailedGSTEntry: Record "Detailed GST Ledger Entry";
        EwayBill: Record "E-Way Bill & E-Invoice";
        RecVendor: Record Vendor;
        GSTINNo: Code[20];
        Irnno: Text;
        Distance: Decimal;
        UserGstin: Text;
        Supplytype: text;
        SubSupplytype: Text;
        SubSupplyDesc: Text;
        DocumentTypes: Text;
        DocumentNo: Code[50];
        documentdate: Text;
        GstinOfConsinor: text;
        LegalNameConsinor: Text;
        Addr1Consinor: Text;
        Addr2Consinor: Text;
        PlaceOfConsinor: Text;
        PincodeOfConsinor: Text;
        StateOfConsinor: Text;
        ActualFromStateNmae: Text;
        //
        GstinOfConsignee: text;
        LegalNameConsignee: Text;
        Addr1Consignee: Text;
        Addr2Consignee: Text;
        PlaceOfConsignee: Text;
        PincodeOfConsignee: Text;
        StateOfConsignee: Text;
        ActualToStateNmae: Text;
        Transtype: Text;
        OtherValue: Decimal;
        TotalInvoiceValue: Decimal;
        TaxableAmopunt: Decimal;
        CgstAmount: Decimal;
        SgstAmount: Decimal;
        IgstAmount: Decimal;
        CessAmount: Decimal;
        TransportID: text;
        TransportName: Text;
        TransportDocuNo: Text;
        TransportDate: Text;
        TransportMode: Text;
        TransportDistance: Decimal;
        VehicleNo: Text;
        VehicleType: Text;
        GenrateStatus: Decimal;
        DataSource: Text;
        UserRef: Text;
        LocationCode: Text;
        EwayBillType: Text;
        TokanEway: Text[800];
        WorkDatet: Integer;
        dattext: text;
        WorkMonth: Integer;
        txtWorkmonth: Text;
        WorkYear: Integer;
        WorkdateFinal: Text;
        //
        Dates: Integer;
        dateLR: Text;
        Month: Integer;
        Year: Integer;
        txtmonth: Text;
        transportdates: Text;
        recEwayBillocType: Record 50000;
        recLocation: Record Location;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    RecCompanyInfo.GET();
                    if EWay_SalesInvoiceHeader.get(DocNo) then begin
                        DtldGSTLedgerEntry.RESET;
                        //   DtldGSTLedgerEntry.SETRANGE(DtldGSTLedgerEntry."Document Type", DocumentType);
                        DtldGSTLedgerEntry.SETRANGE(DtldGSTLedgerEntry."Document No.", EWay_SalesInvoiceHeader."No.");
                        IF DtldGSTLedgerEntry.FINDFIRST THEN BEGIN
                            UserGstin := DtldGSTLedgerEntry."Location  Reg. No.";
                            Supplytype := 'Outward';
                            SubSupplytype := 'Supply';
                            SubSupplyDesc := '';
                            if EWay_SalesInvoiceHeader."Invoice Type" IN [EWay_SalesInvoiceHeader."Invoice Type"::"Bill of Supply"] then
                                DocumentTypes := 'Bill of Supply'
                            else
                                DocumentTypes := 'Tax Invoice';
                            DocumentNo := EWay_SalesInvoiceHeader."No.";
                            //
                            WorkDatet := DATE2DMY(EWay_SalesInvoiceHeader."Posting Date", 1);
                            IF WorkDatet < 10 THEN
                                dattext := '0' + FORMAT(WorkDatet)
                            ELSE
                                dattext := FORMAT(WorkDatet);

                            //dattext := FORMAT(DATE2DMY(RecSalesInvHdr."Posting Date",1));
                            WorkMonth := DATE2DMY(EWay_SalesInvoiceHeader."Posting Date", 2);
                            IF WorkMonth < 10 THEN
                                txtWorkmonth := FORMAT(0) + FORMAT(WorkMonth)
                            ELSE
                                txtWorkmonth := FORMAT(WorkMonth);

                            WorkYear := DATE2DMY(EWay_SalesInvoiceHeader."Posting Date", 3);

                            WorkdateFinal := FORMAT(dattext) + '/' + txtWorkmonth + '/' + FORMAT(WorkYear);
                            //
                            documentdate := Format(WorkdateFinal);
                            RecLoc.RESET();
                            RecLoc.SETRANGE(Code, EWay_SalesInvoiceHeader."Location Code");
                            IF RecLoc.FIND('-') THEN BEGIN
                                // GstinOfConsinor := recLoc."GST Registration No."; //For Prod
                                GstinOfConsinor := '05AAABB0639G1Z8';//For Uat
                                LegalNameConsinor := RecCompanyInfo.Name;
                                Addr1Consinor := recLoc.Address;
                                Addr2Consinor := recLoc."Address 2";
                                PlaceOfConsinor := recLoc.City;
                                PincodeOfConsinor := recLoc."Post Code";
                                RecState.RESET();
                                RecState.SETRANGE(Code, RecLoc."State Code");
                                IF RecState.FIND('-') THEN BEGIN
                                    StateOfConsinor := RecState.Description;
                                    ActualFromStateNmae := RecState.Description;
                                end;
                            end;

                            IF EWay_SalesInvoiceHeader."GST Customer Type" = EWay_SalesInvoiceHeader."GST Customer Type"::Unregistered THEN
                                GSTINNo := 'URP'
                            ELSE
                                GSTINNo := EWay_SalesInvoiceHeader."Customer GST Reg. No.";
                            if EWay_SalesInvoiceHeader."Ship-to Code" <> '' then begin
                                RecShiptoAdd.RESET();
                                RecShiptoAdd.SETRANGE("Customer No.", EWay_SalesInvoiceHeader."Sell-to Customer No.");
                                RecShiptoAdd.SETRANGE(Code, EWay_SalesInvoiceHeader."Ship-to Code");
                                IF RecShiptoAdd.FIND('-') THEN begin
                                    IF EWay_SalesInvoiceHeader."GST Customer Type" = EWay_SalesInvoiceHeader."GST Customer Type"::Unregistered THEN
                                        GSTINNo := 'URP'
                                    ELSE
                                        GSTINNo := RecShiptoAdd."GST Registration No.";
                                    // GstinOfConsignee := GSTINNo;//for Prod
                                    GstinOfConsignee := '05AAABC0181E1ZE';//For Uat
                                    LegalNameConsignee := RecShiptoAdd.Name;
                                    Addr1Consignee := RecShiptoAdd.Address;
                                    Addr2Consignee := RecShiptoAdd."Address 2";
                                    PlaceOfConsignee := RecShiptoAdd.City;
                                    PincodeOfConsignee := RecShiptoAdd."Post Code";
                                    RecState.RESET();
                                    RecState.SETRANGE(Code, RecShiptoAdd.State);
                                    IF RecState.FIND('-') THEN BEGIN
                                        StateOfConsignee := RecState.Description;
                                        ActualToStateNmae := RecState.Description;
                                    end;
                                end;//mapp test
                            end else begin
                                // GstinOfConsignee := GSTINNo;//for Prod
                                GstinOfConsignee := '05AAABC0181E1ZE';//For Uat
                                LegalNameConsignee := EWay_SalesInvoiceHeader."Sell-to Customer Name";
                                Addr1Consignee := EWay_SalesInvoiceHeader."Sell-to Address";
                                Addr2Consignee := EWay_SalesInvoiceHeader."Sell-to Address 2";
                                PlaceOfConsignee := EWay_SalesInvoiceHeader."Sell-to City";
                                PincodeOfConsignee := EWay_SalesInvoiceHeader."Sell-to Post Code";
                                RecState.RESET();
                                RecState.SETRANGE(Code, EWay_SalesInvoiceHeader.State);
                                IF RecState.FIND('-') THEN BEGIN
                                    StateOfConsignee := RecState.Description;
                                    ActualToStateNmae := RecState.Description;
                                end;
                            end;

                            Transtype := 'Regular';
                            OtherValue := 0;
                            TotalInvoiceValue := GetTotalInvValue(DtldGSTLedgerEntry."Document No.");
                            Val_DetailedGSTEntry.RESET;
                            Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                            Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'CGST');
                            Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                            CgstAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                            TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                            Val_DetailedGSTEntry.RESET;
                            Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                            Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'SGST');
                            Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                            SgstAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                            TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                            Val_DetailedGSTEntry.RESET;
                            Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                            Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'IGST');
                            Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                            IgstAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                            if TaxableAmopunt = 0 then
                                TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                            Val_DetailedGSTEntry.RESET;
                            Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                            Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'CESS');
                            Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                            CessAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                            if TaxableAmopunt = 0 then
                                TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                            if EWay_SalesInvoiceHeader."Transporter Code" <> '' then begin
                                RecVendor.RESET();
                                RecVendor.SETRANGE("No.", EWay_SalesInvoiceHeader."Transporter Code");
                                IF RecVendor.FIND('-') THEN BEGIN
                                    TransportID := RecVendor."GST Registration No.";
                                    TransportName := RecVendor.Name;
                                end;
                            end else begin
                                TransportID := EWay_SalesInvoiceHeader."Transporter GSTIN";
                                TransportName := EWay_SalesInvoiceHeader."Transporter Name";
                            end;
                            TransportDocuNo := EWay_SalesInvoiceHeader."LR/RR No.";
                            IF EWay_SalesInvoiceHeader."LR/RR Date" <> 0D THEN BEGIN//ACX-RK 100521
                                Dates := DATE2DMY(EWay_SalesInvoiceHeader."LR/RR Date", 1);
                                Month := DATE2DMY(EWay_SalesInvoiceHeader."LR/RR Date", 2);
                                Year := DATE2DMY(EWay_SalesInvoiceHeader."LR/RR Date", 3);
                            END;
                            IF Dates < 10 THEN
                                dateLR := '0' + FORMAT(Dates)
                            ELSE
                                dateLR := FORMAT(Dates);

                            IF Month < 10 THEN
                                txtmonth := FORMAT(0) + FORMAT(Month)
                            ELSE
                                txtmonth := FORMAT(Month);
                            transportdates := FORMAT(dateLR) + '/' + txtmonth + '/' + FORMAT(Year);
                            TransportDate := transportdates;
                            TransportMode := EWay_SalesInvoiceHeader."Mode of Transport";
                            TransportDistance := EWay_SalesInvoiceHeader."Distance (Km)";
                            VehicleNo := EWay_SalesInvoiceHeader."Vehicle No.";
                            VehicleType := Format(EWay_SalesInvoiceHeader."Vehicle Type");
                            GenrateStatus := 1;
                            DataSource := 'erp';
                            UserRef := '1232435466sdsf234';
                            LocationCode := 'XYZ';
                            IF EwayBill."E-way Bill Part" = EwayBill."E-way Bill Part"::Registered THEN
                                EwayBillType := 'AC'
                            ELSE
                                EwayBillType := 'ABC';

                            IF EWay_SalesInvoiceHeader."E-way Bill Part" = EWay_SalesInvoiceHeader."E-way Bill Part"::Registered THEN
                                EwayBillType := 'AC'
                            ELSE
                                EwayBillType := 'ABC';
                        end;
                    end;

                    //transferShipment
                end;
            DocumentType::"Transfer Shipment":
                begin
                    RecCompanyInfo.GET();
                    if EWay_transferShipmentHeader.get(DocNo) then begin

                        EwayBill.RESET();
                        EwayBill.SETRANGE("No.", DocNo);
                        IF EwayBill.FIND('-') THEN BEGIN
                            RecCompanyInfo.GET();
                            UserGstin := EwayBill."Location GST Reg. No.";
                            Supplytype := 'Outward';
                            IF EwayBill."Customer GST Reg. No." = EwayBill."Location GST Reg. No." THEN BEGIN
                                SubSupplytype := 'Others';
                                SubSupplyDesc := 'Stock transfer';
                            end else begin
                                SubSupplytype := 'Others';
                                SubSupplyDesc := 'Bill of Supply';
                            end;
                            recEwayBillocType.RESET;
                            recEwayBillocType.SETRANGE("No.", DocNo);
                            IF recEwayBillocType.FINDFIRST THEN
                                DocumentTypes := Format(recEwayBillocType."Document Type");

                            DocumentNo := EwayBill."No.";
                            //
                            WorkDatet := DATE2DMY(EwayBill."Posting Date", 1);
                            IF WorkDatet < 10 THEN
                                dattext := '0' + FORMAT(WorkDatet)
                            ELSE
                                dattext := FORMAT(WorkDatet);

                            //dattext := FORMAT(DATE2DMY(RecSalesInvHdr."Posting Date",1));
                            WorkMonth := DATE2DMY(EwayBill."Posting Date", 2);
                            IF WorkMonth < 10 THEN
                                txtWorkmonth := FORMAT(0) + FORMAT(WorkMonth)
                            ELSE
                                txtWorkmonth := FORMAT(WorkMonth);

                            WorkYear := DATE2DMY(EwayBill."Posting Date", 3);

                            WorkdateFinal := FORMAT(dattext) + '/' + txtWorkmonth + '/' + FORMAT(WorkYear);
                            //
                            documentdate := Format(WorkdateFinal);
                            RecLoc.RESET();
                            RecLoc.SETRANGE(Code, EwayBill."Location Code");
                            IF RecLoc.FIND('-') THEN BEGIN
                                // GstinOfConsinor := recLoc."GST Registration No."; //For Prod
                                GstinOfConsinor := '05AAABB0639G1Z8';//For Uat
                                LegalNameConsinor := RecCompanyInfo.Name;
                                Addr1Consinor := recLoc.Address;
                                Addr2Consinor := recLoc."Address 2";
                                PlaceOfConsinor := recLoc.City;
                                PincodeOfConsinor := recLoc."Post Code";
                                RecState.RESET();
                                RecState.SETRANGE(Code, RecLoc."State Code");
                                IF RecState.FIND('-') THEN BEGIN
                                    StateOfConsinor := RecState.Description;
                                    ActualFromStateNmae := RecState.Description;
                                end;
                            end;

                            // IF EWay_SalesInvoiceHeader."GST Customer Type" = EWay_SalesInvoiceHeader."GST Customer Type"::Unregistered THEN
                            //     GSTINNo := 'URP'
                            // ELSE
                            //     GSTINNo := EWay_SalesInvoiceHeader."Customer GST Reg. No.";
                            IF recLocation.GET(EwayBill."Transfer-to Code") THEN BEGIN
                                if recLocation."GST Registration No." <> '' then
                                    GSTINNo := recLocation."GST Registration No."
                                else
                                    GSTINNo := 'URP';
                                // GstinOfConsignee := GSTINNo;//for Prod
                                GstinOfConsignee := '05AAABC0181E1ZE';//For Uat
                                LegalNameConsignee := recLocation.Name;
                                Addr1Consignee := recLocation.Address;
                                Addr2Consignee := recLocation."Address 2";
                                PlaceOfConsignee := recLocation.City;
                                PincodeOfConsignee := recLocation."Post Code";
                                RecState.RESET();
                                RecState.SETRANGE(Code, EwayBill.State);
                                IF RecState.FIND('-') THEN BEGIN
                                    StateOfConsignee := RecState.Description;
                                    ActualToStateNmae := RecState.Description;
                                end
                            end;
                            // if EWay_SalesInvoiceHeader."Ship-to Code" <> '' then begin
                            //     RecShiptoAdd.RESET();
                            //     RecShiptoAdd.SETRANGE("Customer No.", EWay_SalesInvoiceHeader."Sell-to Customer No.");
                            //     RecShiptoAdd.SETRANGE(Code, EWay_SalesInvoiceHeader."Ship-to Code");
                            //     IF RecShiptoAdd.FIND('-') THEN begin
                            //         IF EWay_SalesInvoiceHeader."GST Customer Type" = EWay_SalesInvoiceHeader."GST Customer Type"::Unregistered THEN
                            //             GSTINNo := 'URP'
                            //         ELSE
                            //             GSTINNo := RecShiptoAdd."GST Registration No.";
                            //         // GstinOfConsignee := GSTINNo;//for Prod
                            //         GstinOfConsignee := '05AAABC0181E1ZE';//For Uat
                            //         LegalNameConsignee := RecShiptoAdd.Name;
                            //         Addr1Consignee := RecShiptoAdd.Address;
                            //         Addr2Consignee := RecShiptoAdd."Address 2";
                            //         PlaceOfConsignee := RecShiptoAdd.City;
                            //         PincodeOfConsignee := RecShiptoAdd."Post Code";
                            //         RecState.RESET();
                            //         RecState.SETRANGE(Code, RecShiptoAdd.State);
                            //         IF RecState.FIND('-') THEN BEGIN
                            //             StateOfConsignee := RecState.Description;
                            //             ActualToStateNmae := RecState.Description;
                            //         end;
                            //     end;//mapp test
                            // end else begin
                            //     // GstinOfConsignee := GSTINNo;//for Prod
                            //     GstinOfConsignee := '05AAABC0181E1ZE';//For Uat
                            //     LegalNameConsignee := EWay_SalesInvoiceHeader."Sell-to Customer Name";
                            //     Addr1Consignee := EWay_SalesInvoiceHeader."Sell-to Address";
                            //     Addr2Consignee := EWay_SalesInvoiceHeader."Sell-to Address 2";
                            //     PlaceOfConsignee := EWay_SalesInvoiceHeader."Sell-to City";
                            //     PincodeOfConsignee := EWay_SalesInvoiceHeader."Sell-to Post Code";
                            //     RecState.RESET();
                            //     RecState.SETRANGE(Code, EWay_SalesInvoiceHeader.State);
                            //     IF RecState.FIND('-') THEN BEGIN
                            //         StateOfConsignee := RecState.Description;
                            //         ActualToStateNmae := RecState.Description;
                            //     end;
                            // end;

                            Transtype := '1';
                            OtherValue := 0;
                            TotalInvoiceValue := EwayBill."Amount to Transfer";
                            //Next Working Karna H
                            DtldGSTLedgerEntry.RESET;
                            //   DtldGSTLedgerEntry.SETRANGE(DtldGSTLedgerEntry."Document Type", DocumentType);
                            DtldGSTLedgerEntry.SETRANGE(DtldGSTLedgerEntry."Document No.", EWay_transferShipmentHeader."No.");
                            IF DtldGSTLedgerEntry.FINDFIRST THEN BEGIN

                                Val_DetailedGSTEntry.RESET;
                                Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                                Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'CGST');
                                Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                                CgstAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                                TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                                Val_DetailedGSTEntry.RESET;
                                Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                                Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'SGST');
                                Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                                SgstAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                                TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                                Val_DetailedGSTEntry.RESET;
                                Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                                Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'IGST');
                                Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                                IgstAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                                if TaxableAmopunt = 0 then
                                    TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");

                                Val_DetailedGSTEntry.RESET;
                                Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
                                Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'CESS');
                                Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
                                CessAmount := ABS(Val_DetailedGSTEntry."GST Amount");
                                if TaxableAmopunt = 0 then
                                    TaxableAmopunt := ABS(Val_DetailedGSTEntry."GST Base Amount");
                            end;
                            if EwayBill."Transporter Code" <> '' then begin
                                RecVendor.RESET();
                                RecVendor.SETRANGE("No.", EwayBill."Transporter Code");
                                IF RecVendor.FIND('-') THEN BEGIN
                                    TransportID := RecVendor."GST Registration No.";
                                    TransportName := RecVendor.Name;
                                end;
                            end else begin
                                TransportID := EwayBill."Transporter GSTIN";
                                TransportName := EwayBill."Transporter Name";
                            end;
                            TransportDocuNo := EwayBill."LR/RR No.";
                            IF EwayBill."LR/RR Date" <> 0D THEN BEGIN//ACX-RK 100521
                                Dates := DATE2DMY(EwayBill."LR/RR Date", 1);
                                Month := DATE2DMY(EwayBill."LR/RR Date", 2);
                                Year := DATE2DMY(EwayBill."LR/RR Date", 3);
                            END;
                            IF Dates < 10 THEN
                                dateLR := '0' + FORMAT(Dates)
                            ELSE
                                dateLR := FORMAT(Dates);

                            IF Month < 10 THEN
                                txtmonth := FORMAT(0) + FORMAT(Month)
                            ELSE
                                txtmonth := FORMAT(Month);
                            transportdates := FORMAT(dateLR) + '/' + txtmonth + '/' + FORMAT(Year);
                            TransportDate := transportdates;
                            TransportMode := EwayBill."Mode of Transport";
                            TransportDistance := EWay_transferShipmentHeader."Distance (Km)";
                            VehicleNo := EwayBill."Vehicle No.";
                            VehicleType := Format(EwayBill."Vehicle Type");
                            GenrateStatus := 1;
                            DataSource := 'erp';
                            UserRef := '1232435466sdsf234';
                            LocationCode := 'XYZ';
                            EwayBillType := 'AC';
                        end;
                    end;
                end;
        //    end;
        //

        end;
        WriteActionDetails(JReadActionDtls, TokanEway, UserGstin, Supplytype, SubSupplytype, SubSupplyDesc, DocumentTypes, DocumentNo,
documentdate, GstinOfConsinor, LegalNameConsinor, Addr1Consinor, Addr2Consinor, PlaceOfConsinor, PincodeOfConsinor,
StateOfConsinor, ActualFromStateNmae, GstinOfConsignee, LegalNameConsignee, Addr1Consignee, Addr2Consignee, PlaceOfConsignee,
PincodeOfConsignee, StateOfConsignee, ActualToStateNmae, Transtype, OtherValue, TotalInvoiceValue, TaxableAmopunt, CgstAmount, SgstAmount,
IgstAmount, CessAmount, TransportID, TransportName, TransportDocuNo, TransportDate, TransportMode, TransportDistance, VehicleNo,
VehicleType, GenrateStatus, DataSource, UserRef, LocationCode, EwayBillType)
    end;
    //testing//
    local procedure WriteActionDetails(var JActionDtls: JsonObject;
    TokanEway: Text[800]; UserGstin: Text; Supplytype: Text; SubSupplytype: Text; SubSupplyDesc: Text;
    DocumentTypes: Text; DocumentNo: Code[50]; documentdate: text; GstinOfConsinor: text;
    LegalNameConsinor: Text; Addr1Consinor: Text; Addr2Consinor: Text; PlaceOfConsinor: Text; PincodeOfConsinor: Text;
    StateOfConsinor: Text; ActualFromStateNmae: Text; GstinOfConsignee: text; LegalNameConsignee: Text; Addr1Consignee: Text; Addr2Consignee: Text; PlaceOfConsignee: Text;
    PincodeOfConsignee: Text; StateOfConsignee: Text; ActualToStateNmae: Text; Transtype: Text; OtherValue: Decimal; TotalInvoiceValue: Decimal;
    TaxableAmopunt: Decimal; CgstAmount: Decimal; SgstAmount: Decimal; IgstAmount: Decimal; CessAmount: Decimal; TransportID: text;
    TransportName: Text; TransportDocuNo: Text; TransportDate: Text; TransportMode: Text; TransportDistance: Decimal; VehicleNo: Text;
    VehicleType: Text; GenrateStatus: Decimal; DataSource: Text; UserRef: Text; LocationCode: Text; EwayBillType: Text)
    var
    begin
        JActionDtls.Add('access_token', AuthenticateToken);
        // JActionDtls.Add('userGstin', UserGstin); For Prod
        JActionDtls.Add('userGstin', '05AAABB0639G1Z8');//For UAT
        JActionDtls.Add('supply_type', Supplytype);
        JActionDtls.Add('sub_supply_type', SubSupplytype);
        JActionDtls.Add('sub_supply_description', SubSupplyDesc);
        JActionDtls.Add('document_type', DocumentTypes);
        JActionDtls.Add('document_number', DocumentNo);
        JActionDtls.Add('document_date', documentdate);
        JActionDtls.Add('gstin_of_consignor', GstinOfConsinor);
        JActionDtls.Add('legal_name_of_consignor', LegalNameConsinor);
        JActionDtls.Add('address1_of_consignor', Addr1Consinor);
        JActionDtls.Add('address2_of_consignor', Addr2Consinor);
        JActionDtls.Add('place_of_consignor', PlaceOfConsinor);
        //JActionDtls.Add('pincode_of_consignor', PincodeOfConsinor);//for Prod
        JActionDtls.Add('pincode_of_consignor', '249151');//For SendboxUAT
                                                          //  JActionDtls.Add('state_of_consignor', StateOfConsinor);//for Prod
        JActionDtls.Add('state_of_consignor', 'Uttarakhand');//For SendboxUAT
                                                             // JActionDtls.Add('actual_from_state_name', ActualFromStateNmae);//for Prod
        JActionDtls.Add('actual_from_state_name', 'Uttarakhand');//For SendboxUAT
        JActionDtls.Add('gstin_of_consignee', GstinOfConsignee);
        JActionDtls.Add('legal_name_of_consignee', LegalNameConsignee);
        JActionDtls.Add('address1_of_consignee', Addr1Consignee);
        JActionDtls.Add('address2_of_consignee', Addr2Consignee);
        JActionDtls.Add('place_of_consignee', PlaceOfConsignee);
        //JActionDtls.Add('pincode_of_consignee', PincodeOfConsignee);//for Prod
        JActionDtls.Add('pincode_of_consignee', '248001');//For SendboxUAT
                                                          //JActionDtls.Add('state_of_supply', StateOfConsignee);//for Prod
        JActionDtls.Add('state_of_supply', 'Uttarakhand');//For SendboxUAT
                                                          // JActionDtls.Add('actual_to_state_name', ActualToStateNmae);
        JActionDtls.Add('actual_to_state_name', 'Uttarakhand');
        JActionDtls.Add('transaction_type', Transtype);
        JActionDtls.Add('other_value', OtherValue);
        JActionDtls.Add('total_invoice_value', TotalInvoiceValue);
        JActionDtls.Add('taxable_amount', TaxableAmopunt);
        JActionDtls.Add('cgst_amount', CgstAmount);
        JActionDtls.Add('sgst_amount', SgstAmount);
        JActionDtls.Add('igst_amount', IgstAmount);
        JActionDtls.Add('cess_amount', CessAmount);
        JActionDtls.Add('cess_nonadvol_value', 0);
        JActionDtls.Add('transporter_id', TransportID);
        JActionDtls.Add('transporter_name', TransportName);
        JActionDtls.Add('transporter_document_number', TransportDocuNo);
        JActionDtls.Add('transporter_document_date', TransportDate);
        JActionDtls.Add('transportation_mode', TransportMode);
        JActionDtls.Add('transportation_distance', TransportDistance);
        JActionDtls.Add('vehicle_number', VehicleNo);
        JActionDtls.Add('vehicle_type', VehicleType);
        JActionDtls.Add('generate_status', GenrateStatus);
        JActionDtls.Add('data_source', DataSource);
        JActionDtls.Add('user_ref', UserRef);
        JActionDtls.Add('location_code', LocationCode);
        JActionDtls.Add('eway_bill_status', EwayBillType);
        JActionDtls.Add('auto_print', 'Y');
        JActionDtls.Add('email', 'mayanksharma@mastersindia.co');
    end;

    local procedure ReadItemDetails(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; var JReadItemValue: JsonObject)
    var
        Item_SalesInvoiceLine: Record "Sales Invoice Line";
        Item_SalesCreditMemoLine: Record "Sales Cr.Memo Line";
        Item_TranferShipmentLine: Record "Transfer Shipment Line";
        UnitofMeasure: Record "Unit of Measure";
        RecSalesInvLineInnerLoop: Record "Sales Invoice Line";
        RecDGLE: Record "Detailed GST Ledger Entry";
        recHSN: Record "HSN/SAC";
        SiNo: Integer;
        txtProdName: Text[100];
        txtHSN: Text[100];
        txtUOM: Code[10];
        decCGSTper: Decimal;
        decSGSTper: Decimal;
        decIGSTper: Decimal;
        decCESSper: Decimal;
        decQty: Decimal;
        CessNonadvol: Decimal;
        decGSTBaseAmt: Decimal;
        cdePrvHSN: Code[30];
        GSTBaseAmtLine: Decimal;
        UOM: Code[10];
        JItemArray: JsonArray;
    begin
        JReadItemValue.Add('itemList', JItemArray);
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    Item_SalesInvoiceLine.Reset();
                    Item_SalesInvoiceLine.SetRange("Document No.", DocNo);
                    Item_SalesInvoiceLine.SetRange(Type, Item_SalesInvoiceLine.Type::Item);
                    Item_SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                    if Item_SalesInvoiceLine.FindSet() then
                        repeat
                            txtProdName := '';
                            txtHSN := '';
                            txtUOM := '';
                            decCGSTper := 0;
                            decSGSTper := 0;
                            decIGSTper := 0;
                            decCESSper := 0;
                            decQty := 0;
                            decGSTBaseAmt := 0;
                            GSTBaseAmtLine := 0;
                            IF Item_SalesInvoiceLine."HSN/SAC Code" <> cdePrvHSN THEN BEGIN
                                RecSalesInvLineInnerLoop.RESET();
                                RecSalesInvLineInnerLoop.SETRANGE("Document No.", Item_SalesInvoiceLine."Document No.");
                                RecSalesInvLineInnerLoop.SETRANGE("HSN/SAC Code", Item_SalesInvoiceLine."HSN/SAC Code");
                                RecSalesInvLineInnerLoop.SETRANGE(Type, RecSalesInvLineInnerLoop.Type::Item);
                                RecSalesInvLineInnerLoop.SETFILTER(Quantity, '<>%1', 0);
                                IF RecSalesInvLineInnerLoop.FINDFIRST THEN BEGIN
                                    cdePrvHSN := RecSalesInvLineInnerLoop."HSN/SAC Code";
                                    REPEAT
                                        recHSN.RESET();
                                        recHSN.SETRANGE(Code, RecSalesInvLineInnerLoop."HSN/SAC Code");
                                        IF recHSN.FIND('-') THEN BEGIN
                                            txtProdName := recHSN.Description;
                                        END;
                                        txtHSN := RecSalesInvLineInnerLoop."HSN/SAC Code";
                                        txtUOM := RecSalesInvLineInnerLoop."Unit of Measure Code";

                                        RecDGLE.RESET();
                                        RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
                                        RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
                                        RecDGLE.SETRANGE("GST Component Code", 'CGST');
                                        IF RecDGLE.FIND('-') THEN BEGIN
                                            decCGSTper := RecDGLE."GST %";
                                            GSTBaseAmtLine := RecDGLE."GST Base Amount";
                                        END;
                                        RecDGLE.RESET();
                                        RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
                                        RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
                                        RecDGLE.SETRANGE("GST Component Code", 'SGST');
                                        IF RecDGLE.FIND('-') THEN BEGIN
                                            decSGSTper := RecDGLE."GST %";
                                            GSTBaseAmtLine := RecDGLE."GST Base Amount";
                                        END;

                                        RecDGLE.RESET();
                                        RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
                                        RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
                                        RecDGLE.SETRANGE("GST Component Code", 'IGST');
                                        IF RecDGLE.FIND('-') THEN BEGIN
                                            decIGSTper := RecDGLE."GST %";
                                            GSTBaseAmtLine := RecDGLE."GST Base Amount";
                                        END;

                                        RecDGLE.RESET();
                                        RecDGLE.SETRANGE("Document No.", RecSalesInvLineInnerLoop."Document No.");
                                        RecDGLE.SETRANGE("HSN/SAC Code", RecSalesInvLineInnerLoop."HSN/SAC Code");
                                        RecDGLE.SETRANGE("GST Component Code", 'CESS');
                                        IF RecDGLE.FIND('-') THEN BEGIN
                                            decCESSper := RecDGLE."GST %";
                                            GSTBaseAmtLine := RecDGLE."GST Base Amount";
                                        END;

                                        decCGSTper := ROUND(decCGSTper, 1);
                                        decSGSTper := ROUND(decSGSTper, 1);
                                        decIGSTper := ROUND(decIGSTper, 1);

                                        decQty += RecSalesInvLineInnerLoop.Quantity;
                                        decGSTBaseAmt += Abs(GSTBaseAmtLine);

                                    UNTIL RecSalesInvLineInnerLoop.NEXT = 0;
                                    //
                                end;
                            end;
                            WriteItemList(JItemArray, txtProdName, txtHSN, txtUOM, decCGSTper, decSGSTper, decIGSTper, decCESSper, decQty, decGSTBaseAmt);

                        until Item_SalesInvoiceLine.Next() = 0;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    Item_TranferShipmentLine.Reset();
                    Item_TranferShipmentLine.SetRange("Document No.", DocNo);
                    Item_TranferShipmentLine.SETCURRENTKEY("HSN/SAC Code");
                    Item_TranferShipmentLine.SetFilter(Quantity, '<>%1', 0);
                    if Item_TranferShipmentLine.FindSet() then
                        repeat
                            txtProdName := '';
                            txtHSN := '';
                            txtUOM := '';
                            decCGSTper := 0;
                            decSGSTper := 0;
                            decIGSTper := 0;
                            decCESSper := 0;
                            decQty := 0;
                            decGSTBaseAmt := 0;
                            GSTBaseAmtLine := 0;
                            // IF Item_SalesInvoiceLine."HSN/SAC Code" <> cdePrvHSN THEN BEGIN
                            //     RecSalesInvLineInnerLoop.RESET();
                            //     RecSalesInvLineInnerLoop.SETRANGE("Document No.", Item_SalesInvoiceLine."Document No.");
                            //     RecSalesInvLineInnerLoop.SETRANGE("HSN/SAC Code", Item_SalesInvoiceLine."HSN/SAC Code");
                            //     RecSalesInvLineInnerLoop.SETRANGE(Type, RecSalesInvLineInnerLoop.Type::Item);
                            //     RecSalesInvLineInnerLoop.SETFILTER(Quantity, '<>%1', 0);
                            //     IF RecSalesInvLineInnerLoop.FINDFIRST THEN BEGIN
                            //         cdePrvHSN := RecSalesInvLineInnerLoop."HSN/SAC Code";
                            //         REPEAT
                            recHSN.RESET();
                            recHSN.SETRANGE(Code, Item_TranferShipmentLine."HSN/SAC Code");
                            IF recHSN.FIND('-') THEN BEGIN
                                txtProdName := recHSN.Description;
                            END;
                            IF txtProdName = '' THEN BEGIN
                                ERROR('HSN Description does not exist')
                            END;
                            txtHSN := Item_TranferShipmentLine."HSN/SAC Code";
                            txtUOM := Item_TranferShipmentLine."Unit of Measure Code";

                            RecDGLE.RESET();
                            RecDGLE.SETRANGE("Document No.", Item_TranferShipmentLine."Document No.");
                            RecDGLE.SETRANGE("HSN/SAC Code", Item_TranferShipmentLine."HSN/SAC Code");
                            RecDGLE.SETRANGE("GST Component Code", 'CGST');
                            IF RecDGLE.FIND('-') THEN BEGIN
                                decCGSTper := RecDGLE."GST %";
                                GSTBaseAmtLine := RecDGLE."GST Base Amount";
                            END;
                            RecDGLE.RESET();
                            RecDGLE.SETRANGE("Document No.", Item_TranferShipmentLine."Document No.");
                            RecDGLE.SETRANGE("HSN/SAC Code", Item_TranferShipmentLine."HSN/SAC Code");
                            RecDGLE.SETRANGE("GST Component Code", 'SGST');
                            IF RecDGLE.FIND('-') THEN BEGIN
                                decSGSTper := RecDGLE."GST %";
                                GSTBaseAmtLine := RecDGLE."GST Base Amount";
                            END;

                            RecDGLE.RESET();
                            RecDGLE.SETRANGE("Document No.", Item_TranferShipmentLine."Document No.");
                            RecDGLE.SETRANGE("HSN/SAC Code", Item_TranferShipmentLine."HSN/SAC Code");
                            RecDGLE.SETRANGE("GST Component Code", 'IGST');
                            IF RecDGLE.FIND('-') THEN BEGIN
                                decIGSTper := RecDGLE."GST %";
                                GSTBaseAmtLine := RecDGLE."GST Base Amount";
                            END;

                            RecDGLE.RESET();
                            RecDGLE.SETRANGE("Document No.", Item_TranferShipmentLine."Document No.");
                            RecDGLE.SETRANGE("HSN/SAC Code", Item_TranferShipmentLine."HSN/SAC Code");
                            RecDGLE.SETRANGE("GST Component Code", 'CESS');
                            IF RecDGLE.FIND('-') THEN BEGIN
                                decCESSper := RecDGLE."GST %";
                                GSTBaseAmtLine := RecDGLE."GST Base Amount";
                            END;

                            decCGSTper := ROUND(decCGSTper, 1);
                            decSGSTper := ROUND(decSGSTper, 1);
                            decIGSTper := ROUND(decIGSTper, 1);

                            decQty += RecSalesInvLineInnerLoop.Quantity;
                            decGSTBaseAmt += Abs(GSTBaseAmtLine);

                            //     UNTIL RecSalesInvLineInnerLoop.NEXT = 0;
                            //     //
                            //end;
                            // end;
                            WriteItemList(JItemArray, txtProdName, txtHSN, txtUOM, decCGSTper, decSGSTper, decIGSTper, decCESSper, decQty, decGSTBaseAmt);

                        until Item_TranferShipmentLine.Next() = 0;
                end;//Add
        end;
    end;

    local procedure WriteItemList(var JWriteItemArray: JsonArray; txtProdName: Text[100]; txtHSN: Text[100]; txtUOM: Code[10]; decCGSTper: Decimal;
    decSGSTper: Decimal; decIGSTper: Decimal; decCESSper: Decimal; decQty: Decimal; decGSTBaseAmt: Decimal)
    var
        JwriteItem: JsonObject;
        JSonNull: JsonValue;
    begin
        JSonNull.SetValueToNull();
        JwriteItem.add('product_name', txtProdName);
        JwriteItem.Add('product_description', txtProdName);
        JwriteItem.Add('hsn_code', txtHSN);
        JwriteItem.Add('quantity', decQty);
        JwriteItem.Add('unit_of_product', txtUOM);
        JwriteItem.Add('cgst_rate', decCGSTper);
        JwriteItem.Add('sgst_rate', decSGSTper);
        JwriteItem.Add('igst_rate', decIGSTper);
        JwriteItem.Add('cess_rate', decCESSper);
        JwriteItem.Add('cessNonAdvol', 0);
        JwriteItem.Add('taxable_amount', decGSTBaseAmt);
        JWriteItemArray.Add(JwriteItem);
        Clear(JwriteItem);
    end;

    procedure AuthenticateToken() TokanText: Text[800]
    var
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpResponse: HttpResponseMessage;
        JOutputObject: JsonObject;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
    begin
        // G_Authenticate_URL := 'https://pro.mastersindia.co/oauth/access_token';For Prod
        G_Authenticate_URL := 'https://sandb-api.mastersindia.co/api/v1/token-auth/';//For UAT
        EinvoiceHttpContent.WriteFrom(SetEinvoiceUserIDandPassword());
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(G_Authenticate_URL);
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            if JResultObject.Get('token', JResultToken) then begin
                TokanText := JResultToken.AsValue().AsText();
            end else
                MESSAGE('status code not ok');

        end else
            MESSAGE('no response from api');
    end;

    procedure SetEinvoiceUserIDandPassword() JsonTxt: Text
    var
        JsonObj: JsonObject;
    begin

        JsonObj.Add('username', 'aman@mastersindia.co');//ForUat
        JsonObj.Add('password', 'Miitspl@123');//ForUat
        JsonObj.WriteTo(JsonTxt);
        // Message(JsonTxt);
    end;

    procedure GSTRegValidations(DocNo: Code[20]): Text
    var
        RecGSTNO: Record "GST Registration Nos.";
        RECEwayBillEinvoice: Record "E-Way Bill & E-Invoice";
    begin
        RECEwayBillEinvoice.RESET();
        RECEwayBillEinvoice.SETRANGE("No.", DocNo);
        IF RECEwayBillEinvoice.FINDFIRST THEN BEGIN
            RecGSTNO.RESET();
            RecGSTNO.SETRANGE(Code, RECEwayBillEinvoice."Location GST Reg. No.");
            IF RecGSTNO.FINDFIRST THEN BEGIN
                IF RecGSTNO.Username = '' THEN
                    ERROR('Username must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO.Password = '' THEN
                    ERROR('Password must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO."Client ID" = '' THEN
                    ERROR('Client ID must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO."Client Secret" = '' THEN
                    ERROR('Client Secret must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
                IF RecGSTNO."Grant Type" = '' THEN
                    ERROR('Grant Type must have a value in GST Registration No. Table for GST Reg. No. is %1', RecGSTNO.Code);
            END
            ELSE
                ERROR('Location GST Reg. No. cannot be blank');
        end;
    end;

    local procedure GetTotalInvValue(DocNo: Code[20]): Decimal
    var
        CustLedgerEntry: Record 21;
    begin
        CustLedgerEntry.SETRANGE("Document No.", DocNo);
        CustLedgerEntry.SETAUTOCALCFIELDS("Original Amount", "Original Amt. (LCY)");
        CustLedgerEntry.FINDFIRST;
        EXIT(ABS(CustLedgerEntry."Original Amt. (LCY)"))
    end;

    local procedure GenerateEwayRequestSendtobinary(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; JsonPayload: Text)
    var
        Outstrm: OutStream;
        RequestResponse: BigText;
        EwayBillN: Text[50];
        GSTRegistrationNos: Record "GST Registration Nos.";
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JOutputObject: JsonObject;
        JOutputToken: JsonToken;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
        NewJsonObject: JsonObject;
        NewJsonToken: JsonToken;
        MessageToken: JsonToken;
        RecSalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        EwayBill: Record "E-Way Bill & E-Invoice";
        ErrorMsg: Text;
        EWayGenerated: Boolean;
        //
        temp01: Text;
        StatusCode: Text;
        SCode: Text;
        GetGenerateBillNo: Text;
        GetGenerateBillDate: Text;
        GetGenerateBillValidUpto: Text;
        Alert: Text;
        Error: Text;
        PrintURL: Text;
    begin
        // G_Authenticate_URL2 := 'https://pro.mastersindia.co/ewayBillsGenerate';For Prod
        G_Authenticate_URL2 := 'https://sandb-api.mastersindia.co/api/v1/ewayBillsGenerate/';//ForUat
        EwayBillN := '';
        ErrorMsg := '';
        EinvoiceHttpContent.WriteFrom(Format(JsonPayload));
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        // EinvoiceHttpHeader.Add('client_id', G_Client_ID);
        // EinvoiceHttpHeader.Add('client_secret', G_Client_Secret);
        // EinvoiceHttpHeader.Add('IPAddress', G_IP_Address);
        // EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        // EinvoiceHttpHeader.Add('user_name', GSTRegistrationNos."User Name");
        // EinvoiceHttpHeader.Add('Gstin', GSTRegistrationNos.Code);
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', AuthenticateToken()));
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(G_Authenticate_URL2);
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            //ReadWithJsonBuffer(ResultMessage);//testing
            Message('Return Value of Generate E-Way Bill : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultToken.IsObject then begin
                    JResultToken.WriteTo(OutputMessage);
                    JOutputObject.ReadFrom(OutputMessage);
                    JOutputObject.Get('status', NewJsonToken);
                    StatusCode := NewJsonToken.AsValue().AsText();
                    JOutputObject.Get('code', NewJsonToken);
                    SCode := NewJsonToken.AsValue().AsText();
                    if SCode = '200' then begin
                        if JOutputObject.Get('message', MessageToken) then begin
                            Clear(OutputMessage);
                            MessageToken.WriteTo(OutputMessage);
                            NewJsonObject.ReadFrom(OutputMessage);
                            NewJsonObject.Get('ewayBillNo', MessageToken);
                            GetGenerateBillNo := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('ewayBillDate', MessageToken);
                            GetGenerateBillDate := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('validUpto', MessageToken);
                            if MessageToken.AsValue().IsNull then
                                GetGenerateBillValidUpto := ''
                            else
                                GetGenerateBillValidUpto := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('alert', MessageToken);
                            Alert := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('error', MessageToken);
                            Error := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('url', MessageToken);
                            PrintURL := MessageToken.AsValue().AsText();
                        end;
                        case
                            DocumentType of
                            DocumentType::Invoice:
                                begin
                                    RecSalesInvHdr.RESET();
                                    RecSalesInvHdr.SETRANGE("No.", DocNo);
                                    IF RecSalesInvHdr.FIND('-') THEN BEGIN
                                        RecSalesInvHdr."E-Way Bill No." := GetGenerateBillNo;
                                        RecSalesInvHdr."E-Way Bill Date" := GetGenerateBillDate;
                                        RecSalesInvHdr."E-Way Bill Valid Upto" := GetGenerateBillValidUpto;
                                        RecSalesInvHdr."E-Way Bill Report URL" := PrintURL;
                                        RecSalesInvHdr."Vehicle Update Date" := '';
                                        RecSalesInvHdr."Vehicle Valid Upto" := '';
                                        RecSalesInvHdr."Cancel E-Way Bill Date" := '';
                                        RecSalesInvHdr."Reason Code for Vehicle Update" := RecSalesInvHdr."Reason Code for Vehicle Update"::" ";
                                        RecSalesInvHdr."Reason for Vehicle Update" := '';
                                        RecSalesInvHdr."Reason Code for Cancel" := RecSalesInvHdr."Reason Code for Cancel"::" ";
                                        RecSalesInvHdr."Reason for Cancel Remarks" := '';
                                        RecSalesInvHdr."Old Vehicle No." := RecSalesInvHdr."Vehicle No.";
                                        RecSalesInvHdr.MODIFY;
                                    END;
                                end;
                            DocumentType::"Transfer Shipment":
                                begin
                                    EwayBill.RESET();
                                    EwayBill.SETRANGE("No.", DocNo);
                                    IF EwayBill.FIND('-') THEN BEGIN
                                        EwayBill."E-Way Bill No." := GetGenerateBillNo;
                                        EwayBill."E-Way Bill Date" := GetGenerateBillDate;
                                        EwayBill."E-Way Bill Valid Upto" := GetGenerateBillValidUpto;
                                        EwayBill."E-Way Bill Report URL" := PrintURL;
                                        //    EwayBill."E-Way Bill Report URL" := 'C:\Users\HEMANT.THAPA\Downloads\'+PrintURL;
                                        EwayBill."Vehicle Update Date" := '';
                                        EwayBill."Vehicle Valid Upto" := '';
                                        EwayBill."Cancel E-Way Bill Date" := '';
                                        EwayBill."Reason Code for Vehicle Update" := EwayBill."Reason Code for Vehicle Update"::" ";
                                        EwayBill."Reason for Vehicle Update" := '';
                                        EwayBill."Reason Code for Cancel" := EwayBill."Reason Code for Cancel"::" ";
                                        EwayBill."Reason for Cancel Remarks" := '';
                                        EwayBill."Old Vehicle No." := EwayBill."Vehicle No.";
                                        EwayBill.MODIFY;
                                    END;
                                end;
                        end;
                        MESSAGE('E-Way Bill has Generated Successfully');
                    end else
                        MESSAGE('status code not ok');
                end else
                    MESSAGE('no response from api');
            end;
        end;
        IF SCode = FORMAT(200) THEN BEGIN
            RecSalesInvHdr.RESET();
            RecSalesInvHdr.SETRANGE("No.", DocNo);
            IF RecSalesInvHdr.FIND('-') THEN begin
                RecSalesInvHdr."E-Way Bill Status" := StatusCode + ' ' + SCode;
                RecSalesInvHdr.MODIFY;
            end;
        END ELSE BEGIN
            RecSalesInvHdr.RESET();
            RecSalesInvHdr.SETRANGE("No.", DocNo);
            IF RecSalesInvHdr.FIND('-') THEN begin
                RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                RecSalesInvHdr.MODIFY;
            end;
        END;
        IF SCode = FORMAT(200) THEN BEGIN
            EwayBill.RESET();
            EwayBill.SETRANGE("No.", DocNo);
            IF EwayBill.FIND('-') THEN begin
                EwayBill."E-Way Bill Status" := StatusCode + ' ' + SCode;
                EwayBill.MODIFY;
            end;
        END ELSE BEGIN
            EwayBill.RESET();
            EwayBill.SETRANGE("No.", DocNo);
            IF EwayBill.FIND('-') THEN begin
                EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                EwayBill.MODIFY;
            end;
        END;
    end;

    //Update Vehicle No.//
    procedure GenerateUpdateVehicleNo(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        JEWayPayload: JsonObject;
        GSTIN: Code[20];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        LocationG: Record Location;
        PayloadText: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    if SalesInvoiceHeader.get(DocNo) then begin
                        GSTIN := SalesInvoiceHeader."Location GST Reg. No.";
                        ReadUpdateVehicleNo(SalesInvoiceHeader."No.", DocumentType, JEWayPayload);
                        JEWayPayload.WriteTo(PayloadText);
                        message(PayloadText);
                        GenerateRequestUpdateVehicleNo(SalesInvoiceHeader."No.", DocumentType, PayloadText);
                    end;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    if TransferShipmentHeader.get(DocNo) then begin
                        //    GSTIN := SalesInvoiceHeader."Location GST Reg. No.";
                        ReadUpdateVehicleNo(TransferShipmentHeader."No.", DocumentType, JEWayPayload);
                        JEWayPayload.WriteTo(PayloadText);
                        message(PayloadText);
                        GenerateRequestUpdateVehicleNo(TransferShipmentHeader."No.", DocumentType, PayloadText);
                    end;
                end;
        end;
    end;

    local procedure ReadUpdateVehicleNo(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; var JReadVehDtl: JsonObject)
    var
        RecSalesInvHdr: Record "Sales Invoice Header";
        EWay_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        EWay_transferShipmentHeader: Record "Transfer Shipment Header";
        DtldGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        EwayBill: Record "E-Way Bill & E-Invoice";
        RecLoc: Record Location;
        RecState: Record State;
        UserGstin: text;
        EwayBillNo: text;
        VehicleNo: Text;
        VehicleType: text;
        PlaceOfConsignor: text;
        StateOfConsignor: text;
        ReasonCodeUpdateVeh: Text;
        ReasonForUpdateVeh: text;
        TransportDocuNo: text;
        TransportDocuDate: text;
        ModeOFTransport: text;
        DataSource: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    RecSalesInvHdr.RESET();
                    RecSalesInvHdr.SETRANGE("No.", DocNo);
                    IF RecSalesInvHdr.FIND('-') THEN BEGIN
                        UserGstin := RecSalesInvHdr."Location GST Reg. No.";
                        EwayBillNo := RecSalesInvHdr."E-Way Bill No.";
                        VehicleNo := RecSalesInvHdr."Vehicle No.";
                        VehicleType := Format(RecSalesInvHdr."Vehicle Type");
                        RecLoc.RESET();
                        RecLoc.SETRANGE(Code, RecSalesInvHdr."Location Code");
                        IF RecLoc.FIND('-') THEN BEGIN
                            PlaceOfConsignor := RecLoc.City;
                        END;
                        RecState.RESET();
                        RecState.SETRANGE(Code, RecSalesInvHdr."Location State Code");
                        IF RecState.FIND('-') THEN BEGIN
                            StateOfConsignor := RecState.Description;
                        END;
                        ReasonCodeUpdateVeh := Format(RecSalesInvHdr."Reason Code for Vehicle Update");
                        ReasonForUpdateVeh := RecSalesInvHdr."Reason for Vehicle Update";
                        TransportDocuNo := RecSalesInvHdr."LR/RR No.";
                        TransportDocuDate := FORMAT(RecSalesInvHdr."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        ModeOFTransport := Format(RecSalesInvHdr."Mode of Transport");
                        DataSource := 'erp';
                    end;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    EwayBill.RESET();
                    EwayBill.SETRANGE("No.", DocNo);
                    IF EwayBill.FIND('-') THEN BEGIN
                        UserGstin := EwayBill."Location GST Reg. No.";
                        EwayBillNo := EwayBill."E-Way Bill No.";
                        VehicleNo := EwayBill."Vehicle No.";
                        VehicleType := Format(EwayBill."Vehicle Type");
                        RecLoc.RESET();
                        RecLoc.SETRANGE(Code, EwayBill."Location Code");
                        IF RecLoc.FIND('-') THEN BEGIN
                            PlaceOfConsignor := RecLoc.City;
                        END;
                        RecState.RESET();
                        RecState.SETRANGE(Code, EwayBill."Location State Code");
                        IF RecState.FIND('-') THEN BEGIN
                            StateOfConsignor := RecState.Description;
                        END;
                        ReasonCodeUpdateVeh := Format(EwayBill."Reason Code for Vehicle Update");
                        ReasonForUpdateVeh := EwayBill."Reason for Vehicle Update";
                        TransportDocuNo := EwayBill."LR/RR No.";
                        TransportDocuDate := FORMAT(EwayBill."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        ModeOFTransport := Format(EwayBill."Mode of Transport");
                        DataSource := 'erp';
                    end;
                end;
        end;
        WriteUpdateVehicleNo(JReadVehDtl, UserGstin, EwayBillNo, VehicleNo, VehicleType, PlaceOfConsignor, StateOfConsignor, ReasonCodeUpdateVeh,
        ReasonForUpdateVeh, TransportDocuNo, TransportDocuDate, ModeOFTransport, DataSource)
    end;

    local procedure WriteUpdateVehicleNo(var JActionDtls: JsonObject; UserGstin: text; EwayBillNo: text; VehicleNo: Text; VehicleType: text;
    PlaceOfConsignor: text; StateOfConsignor: text; ReasonCodeUpdateVeh: Text; ReasonForUpdateVeh: text; TransportDocuNo: text;
    TransportDocuDate: text; ModeOFTransport: text; DataSource: Text)
    var

    begin
        JActionDtls.Add('access_token', AuthenticateToken());
        //   JActionDtls.Add('userGstin', UserGstin);//For Prod
        JActionDtls.Add('userGstin', '05AAABB0639G1Z8');//For UAT
        JActionDtls.Add('eway_bill_number', EwayBillNo);
        JActionDtls.Add('vehicle_number', VehicleNo);
        JActionDtls.Add('vehicle_type', VehicleType);
        JActionDtls.Add('place_of_consignor', PlaceOfConsignor);
        JActionDtls.Add('state_of_consignor', StateOfConsignor);
        JActionDtls.Add('reason_code_for_vehicle_updation', ReasonCodeUpdateVeh);
        JActionDtls.Add('reason_for_vehicle_updation', ReasonForUpdateVeh);
        JActionDtls.Add('transporter_document_number', TransportDocuNo);
        JActionDtls.Add('transporter_document_date', TransportDocuDate);
        JActionDtls.Add('mode_of_transport', ModeOFTransport);
        JActionDtls.Add('data_source', DataSource);
    end;

    local procedure GenerateRequestUpdateVehicleNo(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; JsonPayload: Text)
    var
        Outstrm: OutStream;
        RequestResponse: BigText;
        EwayBillN: Text[50];
        GSTRegistrationNos: Record "GST Registration Nos.";
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JOutputObject: JsonObject;
        JOutputToken: JsonToken;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        JResMassageToken: JsonToken;
        JMessageToken: JsonToken;
        NewJsonObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
        RecSalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        EwayBill: Record "E-Way Bill & E-Invoice";
        StatusCode: Text;
        Scode: Text;
        GetUpdateVehicleDate: Text;
        GetUpdateVehicleValidUptoDate: Text;
    begin
        // G_Authenticate_URL3 := 'https://pro.mastersindia.co/updateVehicleNumber';For Prod
        G_Authenticate_URL3 := 'https://sandb-api.mastersindia.co/api/v1/updateVehicleNumber/';//For UAT
        EinvoiceHttpContent.WriteFrom(Format(JsonPayload));
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', AuthenticateToken()));
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(G_Authenticate_URL3);
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Return Value of Update Vehicle No. : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultToken.IsObject then begin
                    JResultToken.WriteTo(OutputMessage);
                    JOutputObject.ReadFrom(OutputMessage);
                    JOutputObject.Get('status', JResMassageToken);
                    StatusCode := JResMassageToken.AsValue().AsText();
                    JOutputObject.Get('code', JResMassageToken);
                    SCode := JResMassageToken.AsValue().AsText();
                    if SCode = '200' then begin
                        if JOutputObject.Get('message', JMessageToken) then begin
                            Clear(OutputMessage);
                            JMessageToken.WriteTo(OutputMessage);
                            NewJsonObject.ReadFrom(OutputMessage);
                            NewJsonObject.Get('vehUpdDate', JMessageToken);
                            GetUpdateVehicleDate := JMessageToken.AsValue().AsText();
                            NewJsonObject.Get('validUpto', JMessageToken);
                            if JMessageToken.AsValue().IsNull then
                                GetUpdateVehicleValidUptoDate := ''
                            else
                                GetUpdateVehicleValidUptoDate := JMessageToken.AsValue().AsText();
                        end;
                        case
                            DocumentType of
                            DocumentType::Invoice:
                                begin
                                    RecSalesInvHdr.RESET();
                                    RecSalesInvHdr.SETRANGE("No.", DocNo);
                                    IF RecSalesInvHdr.FIND('-') THEN BEGIN
                                        RecSalesInvHdr."Vehicle Update Date" := FORMAT(GetUpdateVehicleDate);
                                        RecSalesInvHdr."Vehicle Valid Upto" := FORMAT(GetUpdateVehicleValidUptoDate);
                                        RecSalesInvHdr."Old Vehicle No." := RecSalesInvHdr."Vehicle No.";
                                        RecSalesInvHdr.MODIFY;
                                    END;
                                end;
                            DocumentType::"Transfer Shipment":
                                begin
                                    EwayBill.RESET();
                                    EwayBill.SETRANGE("No.", DocNo);
                                    IF EwayBill.FIND('-') THEN BEGIN
                                        EwayBill."Vehicle Update Date" := FORMAT(GetUpdateVehicleDate);
                                        EwayBill."Vehicle Valid Upto" := FORMAT(GetUpdateVehicleValidUptoDate);
                                        EwayBill."Old Vehicle No." := EwayBill."Vehicle No.";
                                        EwayBill.MODIFY;
                                    END;
                                end;
                        end;
                        MESSAGE('Vehicle No. has been Updated Successfully');
                    end else
                        MESSAGE('status code not ok');
                end else
                    MESSAGE('no response from api');
            end;

        end;
        IF SCode = FORMAT(200) THEN BEGIN
            RecSalesInvHdr.RESET();
            RecSalesInvHdr.SETRANGE("No.", DocNo);
            IF RecSalesInvHdr.FIND('-') THEN begin
                RecSalesInvHdr."E-Way Bill Status" := StatusCode + ' ' + SCode;
                RecSalesInvHdr.MODIFY
            end;
        END
        ELSE BEGIN
            RecSalesInvHdr.RESET();
            RecSalesInvHdr.SETRANGE("No.", DocNo);
            IF RecSalesInvHdr.FIND('-') THEN begin
                RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                RecSalesInvHdr.MODIFY;
            end;
        end;
        IF SCode = FORMAT(200) THEN BEGIN
            EwayBill.RESET();
            EwayBill.SETRANGE("No.", DocNo);
            IF EwayBill.FIND('-') THEN begin
                EwayBill."E-Way Bill Status" := StatusCode + ' ' + SCode;
                EwayBill.MODIFY
            end;
        END
        ELSE BEGIN
            EwayBill.RESET();
            EwayBill.SETRANGE("No.", DocNo);
            IF EwayBill.FIND('-') THEN begin
                EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                EwayBill.MODIFY;
            end;
        END;
    end;

    /*   procedure ReadWithJsonBuffer(jsonstring: text; DocNo: Code[20])//For Testing
       var
           jsonbuffer: Record "JSON Buffer" temporary;
           RecSalesInvHdr: Record "Sales Invoice Header";
       begin
           jsonbuffer.ReadFromText(jsonstring);
           //Page.Run(Page::"Json Buffers", jsonbuffer);
       end;*/
    //Cancel Eway Bill//

    procedure CancelEWayBill(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        JEWayPayload: JsonObject;
        GSTIN: Code[20];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        LocationG: Record Location;
        PayloadText: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    if SalesInvoiceHeader.get(DocNo) then begin
                        GSTIN := SalesInvoiceHeader."Location GST Reg. No.";
                        ReadCancelEWayBillBody(SalesInvoiceHeader."No.", DocumentType, JEWayPayload);
                        JEWayPayload.WriteTo(PayloadText);
                        message(PayloadText);
                        GenrateRequestCancelEWayBill(SalesInvoiceHeader."No.", DocumentType, PayloadText);
                    end;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    if TransferShipmentHeader.get(DocNo) then begin
                        //     GSTIN := TransferShipmentHeader."Location GST Reg. No.";
                        ReadCancelEWayBillBody(TransferShipmentHeader."No.", DocumentType, JEWayPayload);
                        JEWayPayload.WriteTo(PayloadText);
                        message(PayloadText);
                        GenrateRequestCancelEWayBill(TransferShipmentHeader."No.", DocumentType, PayloadText);
                    end;
                end;
        end;
    end;

    procedure GenrateRequestCancelEWayBill(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; JsonPayload: Text)
    var
        Body: Text;
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        ResultMessage: Text;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        EwayBill: Record "E-Way Bill & E-Invoice";
        LocationG: Record Location;
        GSTIN: Code[20];
        EWayCancel: Boolean;
        JOutputObject: JsonObject;
        JOutputToken: JsonToken;
        EwayBillN: Code[50];
        OutputMessage: Text;
        RequestResponse: BigText;
        Outstrm: OutStream;
        JResMassageToken: JsonToken;
        JMessageToken: JsonToken;
        NewJsonObject: JsonObject;
        StatusCode: Text;
        Scode: Text;
        GetCancelBillDate: Text;
        EwayBillNo: Text;
        RecSalesInvHdr: Record "Sales Invoice Header";
        JEWayPayload: JsonObject;
    begin
        //  G_Authenticate_URL4 := 'https://pro.mastersindia.co/ewayBillCancel';//For prod
        G_Authenticate_URL4 := 'https://sandb-api.mastersindia.co/api/v1/ewayBillCancel/';
        EinvoiceHttpContent.WriteFrom(JsonPayload);
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', AuthenticateToken()));
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(G_Authenticate_URL4);
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Return Value of Cancel E-Way Bill No. : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultObject.Get('results', JResultToken) then begin
                    if JResultToken.IsObject then begin
                        JResultToken.WriteTo(OutputMessage);
                        JOutputObject.ReadFrom(OutputMessage);
                        JOutputObject.Get('status', JResMassageToken);
                        StatusCode := JResMassageToken.AsValue().AsText();
                        JOutputObject.Get('code', JResMassageToken);
                        SCode := JResMassageToken.AsValue().AsText();
                        if SCode = '200' then begin
                            if JOutputObject.Get('message', JMessageToken) then begin
                                Clear(OutputMessage);
                                JMessageToken.WriteTo(OutputMessage);
                                NewJsonObject.ReadFrom(OutputMessage);
                                NewJsonObject.ReadFrom(OutputMessage);
                                NewJsonObject.Get('cancelDate', JMessageToken);
                                GetCancelBillDate := JMessageToken.AsValue().AsText();
                            end;
                            case
                                DocumentType of
                                DocumentType::Invoice:
                                    begin
                                        RecSalesInvHdr.RESET();
                                        RecSalesInvHdr.SETRANGE("No.", DocNo);
                                        IF RecSalesInvHdr.FIND('-') THEN BEGIN
                                            RecSalesInvHdr."Cancel E-Way Bill Date" := FORMAT(GetCancelBillDate);
                                            RecSalesInvHdr."Old Vehicle No." := '';
                                            RecSalesInvHdr.MODIFY;
                                        END;
                                    end;
                                DocumentType::"Transfer Shipment":
                                    begin
                                        EwayBill.RESET();
                                        EwayBill.SETRANGE("No.", DocNo);
                                        // EwayBill.SETRANGE("E-Way Bill No.", EwayBillNo);
                                        IF EwayBill.FIND('-') THEN BEGIN
                                            EwayBill."Cancel E-Way Bill Date" := FORMAT(GetCancelBillDate);
                                            EwayBill."Old Vehicle No." := '';
                                            EwayBill.MODIFY;
                                        END;
                                    end;
                            end;
                            MESSAGE('E-Way Bill has been Cancelled Successfully');
                        end else
                            MESSAGE('status code not ok');
                    end else
                        MESSAGE('no response from api');
                end;
            end;
        end;
        IF SCode = FORMAT(200) THEN BEGIN
            RecSalesInvHdr.RESET();
            RecSalesInvHdr.SETRANGE("No.", DocNo);
            IF RecSalesInvHdr.FIND('-') THEN begin
                RecSalesInvHdr."E-Way Bill Status" := StatusCode + ' ' + SCode;
                //      RecSalesInvHdr."E-Way Bill Report URL" := '';
                RecSalesInvHdr.MODIFY;
            end;
        END
        ELSE BEGIN
            RecSalesInvHdr.RESET();
            RecSalesInvHdr.SETRANGE("No.", DocNo);
            IF RecSalesInvHdr.FIND('-') THEN begin
                RecSalesInvHdr."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                RecSalesInvHdr.MODIFY;
            end;
        END;
        IF SCode = FORMAT(200) THEN BEGIN
            EwayBill.RESET();
            EwayBill.SETRANGE("No.", DocNo);
            IF EwayBill.FIND('-') THEN begin
                EwayBill."E-Way Bill Status" := StatusCode + ' ' + SCode;
                //      EwayBill."E-Way Bill Report URL" := '';
                EwayBill.MODIFY;
            end;
        END
        ELSE BEGIN
            EwayBill.RESET();
            EwayBill.SETRANGE("No.", DocNo);
            IF EwayBill.FIND('-') THEN begin
                EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                EwayBill.MODIFY;
            end;
        END;
    end;

    local procedure ReadCancelEWayBillBody(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; JsonCancelBody: JsonObject)
    var
        EWB_SalesInoviceHeader: Record "Sales Invoice Header";
        EWB_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        EWB_TransferShipmentHeader: Record "Transfer Shipment Header";
        EWB_Location: Record Location;
        GSTIN: Code[20];
        EWBNo: Code[50];
        CancelReason: Text;
        CancelRemarks: Text;
        DataSource: text;
        EwayBill: Record "E-Way Bill & E-Invoice";
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    if EWB_SalesInoviceHeader.get(DocNo) then begin
                        GSTIN := format(EWB_SalesInoviceHeader."Location GST Reg. No.");
                        EWBNo := format(EWB_SalesInoviceHeader."E-Way Bill No.");
                        CancelReason := format(EWB_SalesInoviceHeader."Reason Code for Cancel");
                        CancelRemarks := format(EWB_SalesInoviceHeader."Reason for Cancel Remarks");
                        DataSource := 'erp';
                    end;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    if EWB_TransferShipmentHeader.get(DocNo) then begin
                        EwayBill.RESET();
                        EwayBill.SETRANGE("No.", DocNo);
                        IF EwayBill.FIND('-') THEN BEGIN
                            GSTIN := format(EwayBill."Location GST Reg. No.");
                            EWBNo := format(EwayBill."E-Way Bill No.");
                            CancelReason := format(EwayBill."Reason Code for Cancel");
                            CancelRemarks := format(EwayBill."Reason for Cancel Remarks");
                            DataSource := 'erp';
                        end;
                    end;
                end;
        end;
        WriteCancelEWayBiilBody(JsonCancelBody, GSTIN, EWBNo, CancelReason, CancelRemarks, DataSource)
    end;

    local procedure WriteCancelEWayBiilBody(CanclEwayObject2: JsonObject;
    GSTIN: Code[20]; EWBNo: Code[50]; CancelReason: Text;
    CancelRemarks: Text; DataSource: Text)
    var
        CanclEwayObject: JsonObject;
        CanclEwayArray: JsonArray;
    begin
        CanclEwayObject2.Add('access_token', AuthenticateToken());
        // CanclEwayObject2.Add('userGstin', GSTIN);//For Prod
        CanclEwayObject2.Add('userGstin', '05AAABB0639G1Z8');//For Uat
        CanclEwayObject2.Add('eway_bill_number', EWBNo);
        CanclEwayObject2.Add('reason_of_cancel', CancelReason);
        CanclEwayObject2.Add('cancel_remark', CancelRemarks);
        CanclEwayObject2.Add('data_source', DataSource);
    end;

    procedure CalculateDistance(DocNo: Code[20]; DocType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        DtldGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        Remarks: Text;
        Status: Text;
        Location: Record 14;
        OriginPinCode: Text;
        ShipPinCode: Text;
        SalesInvoiceHeader: Record 112;
        ApproxDistance: Text;
        ReturnMsg: Label 'Status : %1\ %2';
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JOutputObject: JsonObject;
        JOutputToken: JsonToken;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        JResMassageToken: JsonToken;
        JMessageToken: JsonToken;
        NewJsonObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
        JResultArray: JsonArray;
        Dis_Int: Integer;
        ROBOSetup: Record "GST Registration Nos.";
        frompincode: text;
        topincode: Text;
        EwayBill: Record "E-Way Bill & E-Invoice";
        RecLoc: Record Location;
        Url: text;
        StatusCode: text;
        SCode: Text;
        GetCalculatedDistance: Text;
        RecSalesInvHdr: Record "Sales Invoice Header";
    begin
        case
            DocType of
            DocType::Invoice:
                begin
                    frompincode := '';
                    topincode := '';
                    RecSalesInvHdr.RESET();
                    RecSalesInvHdr.SETRANGE("No.", DocNo);
                    IF RecSalesInvHdr.FIND('-') THEN BEGIN
                        IF RecSalesInvHdr."Ship-to Code" <> '' THEN
                            frompincode := FORMAT(RecSalesInvHdr."Ship-to Post Code")
                        ELSE
                            frompincode := FORMAT(RecSalesInvHdr."Sell-to Post Code");

                        RecLoc.RESET();
                        RecLoc.SETRANGE(Code, RecSalesInvHdr."Location Code");
                        IF RecLoc.FIND('-') THEN
                            topincode := FORMAT(RecLoc."Post Code");
                    END;
                end;
            DocType::"Transfer Shipment":
                begin
                    frompincode := '';
                    topincode := '';
                    EwayBill.RESET();
                    EwayBill.SETRANGE("No.", DocNo);
                    IF EwayBill.FIND('-') THEN BEGIN
                        frompincode := FORMAT(EwayBill."Sell-to Post Code");
                        RecLoc.RESET();
                        RecLoc.SETRANGE(Code, EwayBill."Location Code");
                        IF RecLoc.FIND('-') THEN
                            topincode := FORMAT(RecLoc."Post Code");
                    END;
                end;
        end;
        // ForProd   Url := 'http://pro.mastersindia.co/distance?access_token=' + AuthenticateToken() + '&fromPincode=' + frompincode + '&toPincode=' + topincode;

        EinvoiceHttpHeader.Clear();
        //  EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', AuthenticateToken()));
        // EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(Url);
        EinvoiceHttpRequest.Method := 'GET';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Return Valueof Calculate Distance for E-Way Bill : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultObject.Get('results', JResultToken) then begin
                    if JResultToken.IsObject then begin
                        JResultToken.WriteTo(OutputMessage);
                        JOutputObject.ReadFrom(OutputMessage);
                        JOutputObject.Get('status', JResMassageToken);
                        StatusCode := JResMassageToken.AsValue().AsText();
                        JOutputObject.Get('code', JResMassageToken);
                        SCode := JResMassageToken.AsValue().AsText();
                        if SCode = '200' then begin
                            if JOutputObject.Get('message', JMessageToken) then begin
                                Clear(OutputMessage);
                                JMessageToken.WriteTo(OutputMessage);
                                NewJsonObject.ReadFrom(OutputMessage);
                                NewJsonObject.ReadFrom(OutputMessage);
                                NewJsonObject.Get('distance', JMessageToken);
                                GetCalculatedDistance := JMessageToken.AsValue().AsText();
                            end;
                            EwayBill.RESET();
                            EwayBill.SETRANGE("No.", DocNo);
                            IF EwayBill.FIND('-') THEN BEGIN
                                EVALUATE(EwayBill."Distance (Km)", GetCalculatedDistance);
                                EwayBill.MODIFY;
                            END;

                            MESSAGE('Distance (KM) has been Calculated Successfully');
                        end else
                            MESSAGE('status code not ok');
                    end else
                        MESSAGE('no response from api');
                end;

            end;
            IF SCode = FORMAT(200) THEN BEGIN
                EwayBill.RESET();
                EwayBill.SETRANGE("No.", DocNo);
                IF EwayBill.FIND('-') THEN begin
                    EwayBill."E-Way Bill Status" := StatusCode + ' ' + SCode;
                    EwayBill.MODIFY
                end;
            END
            ELSE BEGIN
                EwayBill.RESET();
                EwayBill.SETRANGE("No.", DocNo);
                IF EwayBill.FIND('-') THEN begin
                    EwayBill."E-Way Bill Status" := 'Faliure' + ' ' + SCode;
                    EwayBill.MODIFY;
                end;
            END;
        end;
    end;
    //E-way With Irn Case//
    procedure GenerateEWayBillWithIRN(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        JEWayPayload: JsonObject;
        GSTIN: Code[20];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        LocationG: Record Location;
        PayloadText: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    if SalesInvoiceHeader.get(DocNo) then begin
                    end;
                end;
            DocumentType::"Credit Memo":
                begin
                    if SalesCrMemoHeader.get(DocNo) then begin
                    end;

                end;
            DocumentType::"Transfer Shipment":
                begin
                    if TransferShipmentHeader.get(DocNo) then begin
                    end;
                end;
        end;
        ReadEwayDataWithIrn(JEWayPayload, DocNo, DocumentType);
        JEWayPayload.WriteTo(PayloadText);
        Message(PayloadText);
        GenerateEwayRequestSendWithIRN(DocNo, DocumentType, PayloadText)
    end;

    local procedure ReadEwayDataWithIrn(var JReadActionDtls: JsonObject; DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        EWay_SalesInvoiceHeader: Record "Sales Invoice Header";
        EWay_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        EWay_transferShipmentHeader: Record "Transfer Shipment Header";
        recEinvoice: Record 50000;
        recVend: Record Vendor;
        Irnno: Text;
        Distance: Text;
        UserGstin: Text;
        TransportId: Text;
        TransportMode: Text;
        TransportDocNo: Text;
        TransportDocumentDate: Text;
        VehicleNo: Text;
        VehicleType: Text;
        TransportName: Text;
        DataSource: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    recEinvoice.RESET();
                    recEinvoice.SETRANGE("No.", DocNo);
                    IF recEinvoice.FIND('-') THEN BEGIN
                        UserGstin := recEinvoice."Location GST Reg. No.";
                        Irnno := recEinvoice."E-Invoice IRN No";
                        recVend.RESET();
                        recVend.SETRANGE("No.", recEinvoice."Transporter Code");
                        IF recVend.FIND('-') THEN
                            TransportId := recVend."GST Registration No."
                        else
                            TransportId := '';
                        IF recEinvoice."Mode of Transport" = 'Road' THEN
                            TransportMode := '1';
                        IF recEinvoice."Mode of Transport" = 'Rail' THEN
                            TransportMode := '2';
                        IF recEinvoice."Mode of Transport" = 'Air' THEN
                            TransportMode := '3';
                        IF recEinvoice."Mode of Transport" = 'Ship' THEN
                            TransportMode := '4';
                        IF recEinvoice."Mode of Transport" = '' THEN
                            TransportMode := '';
                        TransportDocNo := recEinvoice."LR/RR No.";
                        TransportDocumentDate := FORMAT(recEinvoice."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        VehicleNo := recEinvoice."Vehicle No.";
                        Distance := recEinvoice."Distance (Km)";
                        IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::"over dimensional cargo" THEN
                            VehicleType := '0'
                        else
                            IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::regular THEN
                                VehicleType := 'R'
                            else
                                IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::" " THEN
                                    VehicleType := '';
                        TransportName := recVend.Name;
                        DataSource := 'erp';
                    end;
                end;
            DocumentType::"Credit Memo":
                begin
                    recEinvoice.RESET();
                    recEinvoice.SETRANGE("No.", DocNo);
                    IF recEinvoice.FIND('-') THEN BEGIN
                        UserGstin := recEinvoice."Location GST Reg. No.";
                        Irnno := recEinvoice."E-Invoice IRN No";
                        recVend.RESET();
                        recVend.SETRANGE("No.", recEinvoice."Transporter Code");
                        IF recVend.FIND('-') THEN
                            TransportId := recVend."GST Registration No."
                        else
                            TransportId := '';
                        IF recEinvoice."Mode of Transport" = 'Road' THEN
                            TransportMode := '1';
                        IF recEinvoice."Mode of Transport" = 'Rail' THEN
                            TransportMode := '2';
                        IF recEinvoice."Mode of Transport" = 'Air' THEN
                            TransportMode := '3';
                        IF recEinvoice."Mode of Transport" = 'Ship' THEN
                            TransportMode := '4';
                        IF recEinvoice."Mode of Transport" = '' THEN
                            TransportMode := '';
                        TransportDocNo := recEinvoice."LR/RR No.";
                        TransportDocumentDate := FORMAT(recEinvoice."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        VehicleNo := recEinvoice."Vehicle No.";
                        Distance := recEinvoice."Distance (Km)";
                        IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::"over dimensional cargo" THEN
                            VehicleType := '0'
                        else
                            IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::regular THEN
                                VehicleType := 'R'
                            else
                                IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::" " THEN
                                    VehicleType := '';
                        TransportName := recVend.Name;
                        DataSource := 'erp';
                    end;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    recEinvoice.RESET();
                    recEinvoice.SETRANGE("No.", DocNo);
                    IF recEinvoice.FIND('-') THEN BEGIN
                        UserGstin := recEinvoice."Location GST Reg. No.";
                        Irnno := recEinvoice."E-Invoice IRN No";
                        recVend.RESET();
                        recVend.SETRANGE("No.", recEinvoice."Transporter Code");
                        IF recVend.FIND('-') THEN
                            TransportId := recVend."GST Registration No."
                        else
                            TransportId := '';
                        IF recEinvoice."Mode of Transport" = 'Road' THEN
                            TransportMode := '1';
                        IF recEinvoice."Mode of Transport" = 'Rail' THEN
                            TransportMode := '2';
                        IF recEinvoice."Mode of Transport" = 'Air' THEN
                            TransportMode := '3';
                        IF recEinvoice."Mode of Transport" = 'Ship' THEN
                            TransportMode := '4';
                        IF recEinvoice."Mode of Transport" = '' THEN
                            TransportMode := '';
                        TransportDocNo := recEinvoice."LR/RR No.";
                        TransportDocumentDate := FORMAT(recEinvoice."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        VehicleNo := recEinvoice."Vehicle No.";
                        Distance := recEinvoice."Distance (Km)";
                        IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::"over dimensional cargo" THEN
                            VehicleType := '0'
                        else
                            IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::regular THEN
                                VehicleType := 'R'
                            else
                                IF recEinvoice."Vehicle Type" = recEinvoice."Vehicle Type"::" " THEN
                                    VehicleType := '';
                        TransportName := recVend.Name;
                        DataSource := 'erp';
                    end;
                end;
        end;
        WriteEwayWithIRNDetails(JReadActionDtls, Irnno, UserGstin, TransportId, TransportMode, TransportDocNo, TransportDocumentDate,
Distance, VehicleNo, VehicleType, TransportName, DataSource)
    end;

    local procedure WriteEwayWithIRNDetails(var JActionDtls: JsonObject;
    Irn: Text; UserGstin: Text; TransportId: Text; TransportMode: Text; TransportDocNo: Text; TransportDocumentDate: Text;
    Distance: Text; VehicleNo: Text; VehicleType: Text; TransportName: Text; DataSource: Text)
    var

    begin
        JActionDtls.Add('access_token', AuthenticateToken());
        // JActionDtls.Add('user_gstin', UserGstin);//ForProd//
        JActionDtls.Add('user_gstin', '09AAAPG7885R002');//ForUAT//
        JActionDtls.Add('irn', Irn);
        // JActionDtls.Add('transporter_id', TransportId);//ForProd
        JActionDtls.Add('transporter_id', '05AAABC0181E1ZE');//ForUAT
        JActionDtls.Add('transportation_mode', TransportMode);
        JActionDtls.Add('transporter_document_number', TransportDocNo);
        JActionDtls.Add('transporter_document_date', TransportDocumentDate);
        JActionDtls.Add('vehicle_number', VehicleNo);
        JActionDtls.Add('distance', Distance);
        JActionDtls.Add('vehicle_type', VehicleType);
        JActionDtls.Add('transporter_name', TransportName);
        JActionDtls.Add('data_source', DataSource);
    end;

    local procedure GenerateEwayRequestSendWithIRN(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; JsonPayload: Text)
    var
        Outstrm: OutStream;
        RequestResponse: BigText;
        EwayBillN: Text[50];
        GSTRegistrationNos: Record "GST Registration Nos.";
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JOutputObject: JsonObject;
        JOutputToken: JsonToken;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
        NewJsonObject: JsonObject;
        NewJsonToken: JsonToken;
        MessageToken: JsonToken;
        ErrorJsonObject: JsonObject;
        ErrorMassageToken: JsonToken;
        RecSalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        EwayBill: Record "E-Way Bill & E-Invoice";
        ErrorMsg: Text;
        EWayGenerated: Boolean;
        //
        temp01: Text;
        StatusCode: Text;
        SCode: Text;
        GetGenerateBillNo: Text;
        GetGenerateBillDate: Text;
        GetGenerateBillValidUpto: Text;
        Alert: Text;
        Error: Text;
        PrintURL: Text;
        G_Authenticate_URLIRN: Text;
        recResponseLog: Record 50003;
        recEinvoice: Record "E-Way Bill & E-Invoice";
    begin
        // G_Authenticate_URL2 := 'https://pro.mastersindia.co/generateEwaybillByIrn';For Prod
        G_Authenticate_URLIRN := ' https://sandb-api.mastersindia.co/api/v1/gen-ewb-by-irn/';//ForUat
        EwayBillN := '';
        ErrorMsg := '';
        EinvoiceHttpContent.WriteFrom(Format(JsonPayload));
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', AuthenticateToken()));
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(G_Authenticate_URLIRN);
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Generate E-Way Bill By Irn : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultToken.IsObject then begin
                    JResultToken.WriteTo(OutputMessage);
                    JOutputObject.ReadFrom(OutputMessage);
                    JOutputObject.Get('errorMessage', NewJsonToken);
                    ErrorMsg := NewJsonToken.AsValue().AsText();
                    JOutputObject.Get('status', NewJsonToken);
                    StatusCode := NewJsonToken.AsValue().AsText();
                    JOutputObject.Get('code', NewJsonToken);
                    SCode := NewJsonToken.AsValue().AsText();
                    if SCode = '200' then begin
                        if JOutputObject.Get('message', MessageToken) then begin
                            Clear(OutputMessage);
                            MessageToken.WriteTo(OutputMessage);
                            NewJsonObject.ReadFrom(OutputMessage);
                            NewJsonObject.Get('EwbNo', MessageToken);
                            GetGenerateBillNo := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('EwbDt', MessageToken);
                            GetGenerateBillDate := MessageToken.AsValue().AsText();
                            NewJsonObject.Get('EwbValidTill', MessageToken);
                            if MessageToken.AsValue().IsNull then
                                GetGenerateBillValidUpto := ''
                            else
                                GetGenerateBillValidUpto := MessageToken.AsValue().AsText();

                            recResponseLog.INIT;
                            recResponseLog."Document No." := DocNo;
                            recResponseLog."Response Date" := TODAY;
                            recResponseLog."Response Time" := TIME;
                            recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                            recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                            recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                            recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                            recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                            recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                            recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                            recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                            recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                            recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                            recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                            recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                            recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                            recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                            recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                            recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                            recResponseLog.Status := 'Success';
                            recResponseLog."Called API" := 'Generate E-Way Bill By IRN';
                            recResponseLog.INSERT;

                            recEinvoice.RESET();
                            recEinvoice.SETRANGE("No.", DocNo);
                            //    recEinvoice.SETRANGE("E-Invoice IRN No", GetGenerateBillNo);
                            IF recEinvoice.FIND('-') THEN BEGIN
                                recEinvoice.VALIDATE("E-Way Bill No.", FORMAT(GetGenerateBillNo));
                                recEinvoice."E-Way Bill Date" := FORMAT(GetGenerateBillDate);
                                recEinvoice."E-Way Bill Valid Upto" := FORMAT(GetGenerateBillValidUpto);
                                recEinvoice."E-Invoice Status" := StatusCode + ' ' + SCode;
                                recEinvoice.MODIFY;
                            END
                        end;
                    end else begin
                        recResponseLog.INIT;
                        recResponseLog."Document No." := DocNo;
                        recResponseLog."Response Date" := TODAY;
                        recResponseLog."Response Time" := TIME;
                        recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                        recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                        recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                        recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                        recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                        recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                        recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                        recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                        recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                        recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                        recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                        recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                        recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                        recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                        recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                        recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                        recResponseLog.Status := 'Failure';
                        recResponseLog."Called API" := 'Generate E-Way Bill By IRN';
                        recResponseLog.INSERT;

                        recEinvoice.RESET();
                        recEinvoice.SETRANGE("No.", DocNo);
                        IF recEinvoice.FIND('-') THEN
                            recEinvoice."E-Invoice Status" := 'Faliure' + ' ' + SCode;
                        MESSAGE('Error Message : ' + ErrorMsg);
                        recEinvoice.MODIFY;
                    end;
                end;
            end else
                MESSAGE('no response from api');
        end;
    end;

    //DistanseWitHIRN
    procedure CalculateDistanceWithIRN(DocNo: Code[20]; DocType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
    var
        DtldGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        Remarks: Text;
        Status: Text;
        Location: Record 14;
        OriginPinCode: Text;
        ShipPinCode: Text;
        SalesInvoiceHeader: Record 112;
        ApproxDistance: Text;
        ReturnMsg: Label 'Status : %1\ %2';
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JOutputObject: JsonObject;
        JOutputToken: JsonToken;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        JResMassageToken: JsonToken;
        JMessageToken: JsonToken;
        NewJsonObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
        JResultArray: JsonArray;
        Dis_Int: Integer;
        ROBOSetup: Record "GST Registration Nos.";
        frompincode: text;
        topincode: Text;
        EINV: Record "E-Way Bill & E-Invoice";
        RecLoc: Record Location;
        Url: text;
        StatusCode: text;
        SCode: Text;
        ErrorMasg: Text;
        GetCalculatedDistance: Text;
        RecSalesInvHdr: Record "Sales Invoice Header";
        RecVendor: Record Vendor;
        recResponseLog: Record 50003;
    begin
        EINV.RESET();
        EINV.SETRANGE("No.", DocNo);
        IF EINV.FIND('-') THEN BEGIN
            IF EINV."GST Customer Type" IN [EINV."GST Customer Type"::Export, EINV."GST Customer Type"::"SEZ Development", EINV."GST Customer Type"::"SEZ Unit"] THEN BEGIN
                frompincode := '';
                topincode := '';
                RecVendor.RESET();
                RecVendor.SETRANGE("No.", EINV."Port Code");
                IF RecVendor.FIND('-') THEN
                    frompincode := FORMAT(RecVendor."Post Code");

                RecLoc.RESET();
                RecLoc.SETRANGE(Code, EINV."Location Code");
                IF RecLoc.FIND('-') THEN
                    topincode := FORMAT(RecLoc."Post Code");
            END;
        END;

        EINV.RESET();
        EINV.SETRANGE("No.", DocNo);
        IF EINV.FIND('-') THEN BEGIN
            IF EINV."GST Customer Type" IN [EINV."GST Customer Type"::" ", EINV."GST Customer Type"::"Deemed Export", EINV."GST Customer Type"::Exempted, EINV."GST Customer Type"::Registered, EINV."GST Customer Type"::Unregistered]
                  THEN BEGIN
                frompincode := '';
                topincode := '';
                IF EINV."Ship-to Code" = '' THEN
                    frompincode := FORMAT(EINV."Sell-to Post Code")
                ELSE
                    frompincode := FORMAT(EINV."Ship-to Post Code");

                RecLoc.RESET();
                RecLoc.SETRANGE(Code, EINV."Location Code");
                IF RecLoc.FIND('-') THEN
                    topincode := FORMAT(RecLoc."Post Code");
            END;
        END;

        // ForProd   Url := 'http://pro.mastersindia.co/distance?access_token=' + AuthenticateToken() + '&fromPincode=' + frompincode + '&toPincode=' + topincode;

        EinvoiceHttpHeader.Clear();
        //  EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('JWT %1', AuthenticateToken()));
        // EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri(Url);
        EinvoiceHttpRequest.Method := 'GET';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message('Return Value of Calculate Distance for E-Way Bill : ' + Format(JResultObject));
            if JResultObject.Get('results', JResultToken) then begin
                if JResultObject.Get('results', JResultToken) then begin
                    if JResultToken.IsObject then begin
                        JResultToken.WriteTo(OutputMessage);
                        JOutputObject.ReadFrom(OutputMessage);
                        JOutputObject.Get('errorMessage', JResMassageToken);
                        ErrorMasg := JResMassageToken.AsValue().AsText();
                        JOutputObject.Get('status', JResMassageToken);
                        StatusCode := JResMassageToken.AsValue().AsText();
                        JOutputObject.Get('code', JResMassageToken);
                        SCode := JResMassageToken.AsValue().AsText();
                        if SCode = '200' then begin
                            if JOutputObject.Get('message', JMessageToken) then begin
                                Clear(OutputMessage);
                                JMessageToken.WriteTo(OutputMessage);
                                NewJsonObject.ReadFrom(OutputMessage);
                                NewJsonObject.ReadFrom(OutputMessage);
                                NewJsonObject.Get('distance', JMessageToken);
                                GetCalculatedDistance := JMessageToken.AsValue().AsText();
                            end;
                            recResponseLog.INIT;
                            recResponseLog."Document No." := DocNo;
                            recResponseLog."Response Date" := TODAY;
                            recResponseLog."Response Time" := TIME;
                            recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                            recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                            recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                            recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                            recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                            recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                            recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                            recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                            recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                            recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                            recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                            recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                            recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                            recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                            recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                            recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                            recResponseLog.Status := 'Success';
                            recResponseLog."Called API" := 'Calculate Distance';
                            recResponseLog.INSERT;
                            EINV.RESET();
                            EINV.SETRANGE("No.", DocNo);
                            IF EINV.FIND('-') THEN BEGIN
                                EVALUATE(EINV."Distance (Km)", GetCalculatedDistance);
                                EINV.MODIFY;
                            END;
                        end else
                            recResponseLog.INIT;
                        recResponseLog."Document No." := DocNo;
                        recResponseLog."Response Date" := TODAY;
                        recResponseLog."Response Time" := TIME;
                        recResponseLog."Response Log 1" := COPYSTR(ResultMessage, 1, 250);
                        recResponseLog."Response Log 2" := COPYSTR(ResultMessage, 251, 250);
                        recResponseLog."Response Log 3" := COPYSTR(ResultMessage, 501, 250);
                        recResponseLog."Response Log 4" := COPYSTR(ResultMessage, 751, 250);
                        recResponseLog."Response Log 5" := COPYSTR(ResultMessage, 1001, 250);
                        recResponseLog."Response Log 6" := COPYSTR(ResultMessage, 1251, 250);
                        recResponseLog."Response Log 7" := COPYSTR(ResultMessage, 1501, 250);
                        recResponseLog."Response Log 8" := COPYSTR(ResultMessage, 1751, 250);
                        recResponseLog."Response Log 9" := COPYSTR(ResultMessage, 2001, 250);
                        recResponseLog."Response Log 10" := COPYSTR(ResultMessage, 2251, 250);
                        recResponseLog."Response Log 11" := COPYSTR(ResultMessage, 2501, 250);
                        recResponseLog."Response Log 12" := COPYSTR(ResultMessage, 2751, 250);
                        recResponseLog."Response Log 13" := COPYSTR(ResultMessage, 3001, 250);
                        recResponseLog."Response Log 14" := COPYSTR(ResultMessage, 3251, 250);
                        recResponseLog."Response Log 15" := COPYSTR(ResultMessage, 3501, 250);
                        recResponseLog."Response Log 16" := COPYSTR(ResultMessage, 3751, 100);
                        recResponseLog.Status := 'Failure';
                        recResponseLog."Called API" := 'Calculate Distance';
                        recResponseLog.INSERT;

                        EINV.RESET();
                        EINV.SETRANGE("No.", DocNo);
                        IF EINV.FIND('-') THEN
                            EINV."E-Invoice Status" := 'Faliure' + ' ' + SCode;
                        Message(ErrorMasg);
                        EINV.Modify();
                    end;
                end;
                MESSAGE('no response from api');
            end;
        end;
    end;
}