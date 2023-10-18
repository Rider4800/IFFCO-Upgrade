report 16600 "TDS 194Q Opening"
{
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(VendorNo; VendorNo)
                {
                    Caption = 'Vendor No.';
                    TableRelation = Vendor;

                    trigger OnValidate()
                    begin
                        IF VendorNo = '' THEN BEGIN
                            ResetVar();
                            EXIT;
                        END;

                        //Vendor.GET(VendorNo);
                        IF NodHeader.GET(NodHeader.Type::Vendor, VendorNo) THEN BEGIN
                            NodHeader.TESTFIELD("Assesse Code");
                            AssesseeCode := NodHeader."Assesse Code";
                        END;
                    end;
                }
                field(AssesseeCode; AssesseeCode)
                {
                    Caption = 'Assessee Code';
                    Editable = false;
                    ToolTip = 'Specifies the assessee code that is defined on the vendor master.';
                }
                field(TDSSectionCode; TDSSectionCode)
                {
                    Caption = 'TDS Nature of Deduction';
                    ToolTip = 'Specifies the TDS section code for which opening entry is to be posted.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetFilterOnNODLines('', '');
                        IF NODLines.FIND('-') THEN
                            REPEAT
                                TDSNOD.RESET;
                                TDSNOD.SETRANGE(Code, NODLines."NOD/NOC");
                                IF TDSNOD.FINDFIRST THEN
                                    TDSNOD.MODIFYALL(Mark, TRUE);
                                COMMIT;
                            UNTIL NODLines.NEXT = 0;

                        TDSNOD.RESET;
                        TDSNOD.SETRANGE(Mark, TRUE);
                        IF PAGE.RUNMODAL(PAGE::"TDS Nature of Deductions", TDSNOD) = ACTION::LookupOK THEN BEGIN
                            TDSSectionCode := TDSNOD.Code;
                            GetTaxRateValues();
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        GetTaxRateValues();
                    end;
                }
                field(DocumentNo; DocumentNo)
                {
                    Caption = 'Document No';
                    ToolTip = 'Specifies the document number that will appear on the TDS ledger entries.';
                }
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date on which the TDS ledger entries are to be posted.';

                    trigger OnValidate()
                    begin
                        IF PostingDate = 0D THEN
                            EXIT;

                        IF TDSSectionCode = '' THEN
                            ERROR(TDSSectionCodeErr);

                        IF PostingDate >= EffectiveDate THEN
                            ERROR(PostingDateErr, EffectiveDate);
                    end;
                }
                field(PurchaseAmount; PurchaseAmount)
                {
                    Caption = 'Purchase Amount';
                    ToolTip = 'Specifies the purchase amount that needs to be posted as vendor opening entry for 194Q.';
                }
                field(TDSThresholdAmount; TDSThresholdAmount)
                {
                    Caption = 'TDS Threshold Amount';
                    Editable = false;
                    ToolTip = 'Specifies the TDS threshold amount that is defined on the TDS rate for TDS section code.';
                }
                field(Description; Description)
                {
                    Caption = 'Description';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        CompanyInformation: Record "79";
        SourceCodeSetup: Record "242";
    begin
        CheckValues();
        CompanyInformation.GET();
        Vendor.GET(VendorNo);
        SourceCodeSetup.GET();
        SourceCodeSetup.TESTFIELD("TDS Above Threshold Opening");

        TDSEntry.LOCKTABLE;
        IF TDSEntry.FINDLAST THEN
            NextTDSEntryNo := TDSEntry."Entry No." + 1
        ELSE
            NextTDSEntryNo := 1;

        TDSEntry.INIT();
        TDSEntry."Entry No." := NextTDSEntryNo;
        TDSEntry."Party Type" := TDSEntry."Party Type"::Vendor;
        TDSEntry."Party Code" := VendorNo;
        TDSEntry."T.A.N. No." := CompanyInformation."T.A.N. No.";
        TDSEntry."User ID" := USERID();
        TDSEntry."Source Code" := SourceCodeSetup."TDS Above Threshold Opening";
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", VendorNo);
        NODLines.SETFILTER("NOD/NOC", TDSSectionCode);
        NODLines.SETFILTER("Nature of Remittance", '');
        NODLines.SETFILTER("TDS Group", '<>%1', NODLines."TDS Group"::Others);
        IF NODLines.FINDFIRST THEN BEGIN
            TDSEntry."TDS Nature of Deduction" := NODLines."NOD/NOC";
            TDSSetup.RESET;
            TDSSetup.SETRANGE("TDS Nature of Deduction", TDSSectionCode);
            TDSSetup.SETRANGE("Assessee Code", AssesseeCode);
            TDSSetup.SETFILTER("TDS Group", FORMAT(NODLines."TDS Group"));
            TDSSetup.SETRANGE("Effective Date", 0D, WORKDATE);
            TDSSetup.SETRANGE("Concessional Code", '');
            TDSSetup.SETRANGE("Nature of Remittance", '');
            TDSSetup.SETRANGE("Act Applicable", 0);
            TDSSetup.SETRANGE("Country Code", '');
            IF TDSSetup.FINDLAST THEN
                IF TDSGroup.FindOnDate(NODLines."TDS Group", TDSSetup."Effective Date") THEN BEGIN
                    TDSEntry."TDS Section" := TDSGroup."TDS Section";
                    TDSEntry."TDS Group" := TDSGroup."TDS Group";
                END;
        END;
        IF TDSNature.GET(TDSSectionCode) THEN
            TDSEntry."TDS Category" := TDSNature.Category;
        TDSEntry.Description := Description;
        TDSEntry."Assessee Code" := AssesseeCode;
        TDSEntry."Deductee P.A.N. No." := Vendor."P.A.N. No.";
        TDSEntry."Account Type" := TDSEntry."Account Type"::Vendor;
        TDSEntry."Account No." := VendorNo;
        TDSEntry."Document Type" := TDSEntry."Document Type"::Invoice;
        TDSEntry."Document No." := DocumentNo;
        TDSEntry."Posting Date" := PostingDate;
        TDSEntry."TDS Base Amount" := PurchaseAmount;
        IF PurchaseAmount > TDSThresholdAmount THEN
            TDSEntry."Invoice Amount" := TDSThresholdAmount
        ELSE
            TDSEntry."Invoice Amount" := PurchaseAmount;
        TDSEntry."Over & Above Threshold Opening" := TRUE;
        TDSEntry."Calc. Over & Above Threshold" := TRUE;
        TDSEntry.INSERT();
    end;

    var
        TDSSetup: Record "13728";
        Vendor: Record "23";
        TDSEntry: Record "13729";
        VendorNo: Code[20];
        TDSSectionCode: Code[10];
        AssesseeCode: Code[10];
        DocumentNo: Code[20];
        PostingDate: Date;
        PurchaseAmount: Decimal;
        EffectiveDate: Date;
        TDSThresholdAmount: Decimal;
        CalcOverThreshold: Boolean;
        EffectiveDateLbl: Label 'Effective Date';
        TDSThresholdAmountLbl: Label 'TDS Threshold Amount';
        CalcOverThresholdLbl: Label 'Calc. Over & Above Threshold';
        CalcOverThresholdErr: Label 'Calc. Over & Above Threshold must be true in TDS Setup.';
        PostingDateErr: Label 'Posting Date must be earlier than effective date in TDS Setup %1.';
        TDSSectionCodeErr: Label 'TDS Section code must be specified.';
        VendorNoErr: Label 'Vendor No. must be specified.';
        DocumentNoErr: Label 'Document No. must be specified.';
        PurchaseAmountErr: Label 'Purchase Amount must be specified.';
        NodHeader: Record "13786";
        NODLines: Record "13785";
        TDSNOD: Record "13726";
        TDSGroup: Record "13731";
        Description: Text[30];
        TDSNature: Record "13726";
        NextTDSEntryNo: Integer;

    local procedure ResetVar()
    begin
        AssesseeCode := '';
        TDSSectionCode := '';
        EffectiveDate := 0D;
        DocumentNo := '';
        PostingDate := 0D;
        PurchaseAmount := 0;
        TDSThresholdAmount := 0;
        CalcOverThreshold := FALSE;
    end;

    local procedure CheckValues()
    begin
        IF VendorNo = '' THEN
            ERROR(VendorNoErr);

        IF TDSSectionCode = '' THEN
            ERROR(TDSSectionCodeErr);

        IF DocumentNo = '' THEN
            ERROR(DocumentNoErr);

        IF PostingDate = 0D THEN
            ERROR(PostingDateErr, EffectiveDate);

        IF PurchaseAmount = 0 THEN
            ERROR(PurchaseAmountErr);
    end;

    local procedure GetTaxRateValues()
    var
        RateID: Text;
        RowID: Guid;
    begin
        NODLines.RESET;
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", VendorNo);
        NODLines.SETFILTER("NOD/NOC", TDSSectionCode);
        NODLines.SETFILTER("Nature of Remittance", '');
        NODLines.SETFILTER("TDS Group", '<>%1', NODLines."TDS Group"::Others);
        IF NODLines.FINDFIRST THEN BEGIN
            TDSSetup.RESET;
            TDSSetup.SETRANGE("TDS Nature of Deduction", TDSSectionCode);
            TDSSetup.SETRANGE("Assessee Code", AssesseeCode);
            TDSSetup.SETRANGE("TDS Group", NODLines."TDS Group");
            TDSSetup.SETRANGE("Effective Date", 0D, WORKDATE);
            TDSSetup.SETRANGE("Concessional Code", '');
            TDSSetup.SETRANGE("Nature of Remittance", '');
            TDSSetup.SETRANGE("Act Applicable", 0);
            TDSSetup.SETRANGE("Country Code", '');
            IF TDSSetup.FINDLAST THEN BEGIN
                EffectiveDate := TDSSetup."Effective Date";
                TDSGroup.SETRANGE("TDS Group", NODLines."TDS Group");
                TDSGroup.SETRANGE("Effective Date", 0D, EffectiveDate);
                TDSGroup.FINDLAST;
                TDSGroup.TESTFIELD("TDS Threshold Amount");
                TDSThresholdAmount := TDSGroup."TDS Threshold Amount";
                CalcOverThreshold := TDSSetup."Calc. Over & Above Threshold";
            END;
        END;

        IF NOT CalcOverThreshold THEN
            ERROR(CalcOverThresholdErr);

        IF EffectiveDate <> 0D THEN
            PostingDate := CALCDATE('<-1D>', EffectiveDate);
    end;

    local procedure SetFilterOnNODLines(TDSNatureOfDeduction: Code[10]; NatureOfRemittance: Code[10])
    begin
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", VendorNo);
        NODLines.SETFILTER("NOD/NOC", TDSNatureOfDeduction);
        NODLines.SETFILTER("Nature of Remittance", NatureOfRemittance);
        NODLines.SETFILTER("TDS Group", '<>%1', NODLines."TDS Group"::Others);
    end;
}

