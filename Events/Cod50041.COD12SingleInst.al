codeunit 50041 COD12SingleInst
{
    SingleInstance = true;
    procedure ClearVariables()
    begin
        Clear(Codeunit12Glb);
    end;

    procedure ClearPostDtldCustLedgEntries()
    begin
        clear(TotalAmountLCYDtldCustEntry);
        clear(TotalAmountAddCurrDtldCustEntry);
        Clear(GenJnlLineDtldCustEntry);
    end;

    procedure ClearPostDtldVendLedgEntries()
    begin
        TotalAmountLCY := 0;
        TotalAmountAddCurr := 0;
        Clear(GenJnlLine);
    end;

    procedure SetData(Codeunit12Para: Codeunit 12)
    begin
        Codeunit12Glb := Codeunit12Para;

    end;

    procedure GetData(var Codeunit12Para: Codeunit 12)
    begin
        Codeunit12Para := Codeunit12Glb;
    end;

    procedure SetDataPostDtldVendLedgEntries(TotalAmountLCYPara: Decimal; TotalAmountAddCurrPara: Decimal; GenJnlLinePara: Record 81)
    begin
        TotalAmountLCY += TotalAmountLCYPara;
        TotalAmountAddCurr += TotalAmountAddCurrPara;
        GenJnlLine := GenJnlLinePara;
    end;

    procedure GetDataPostDtldVendLedgEntries(var TotalAmountLCYPara: Decimal; var TotalAmountAddCurrPara: Decimal; var GenJnlLinePara: Record 81)
    begin
        TotalAmountLCYPara := TotalAmountLCY;
        TotalAmountAddCurrPara := TotalAmountAddCurr;
        GenJnlLinePara := GenJnlLine;
    end;

    procedure SetDataPostDtldCustLedgEntries(TotalAmountLCYPara: Decimal; TotalAmountAddCurrPara: Decimal; GenJnlLinePara: Record 81)
    begin
        TotalAmountLCYDtldCustEntry += TotalAmountLCYPara;
        TotalAmountAddCurrDtldCustEntry += TotalAmountAddCurrPara;
        GenJnlLineDtldCustEntry := GenJnlLinePara;
    end;

    procedure GetDataPostDtldCustLedgEntries(var TotalAmountLCYPara: Decimal; var TotalAmountAddCurrPara: Decimal; var GenJnlLinePara: Record 81)
    begin
        TotalAmountLCYPara := TotalAmountLCYDtldCustEntry;
        TotalAmountAddCurrPara := TotalAmountAddCurrDtldCustEntry;
        GenJnlLinePara := GenJnlLineDtldCustEntry;
    end;


    procedure ClearFinanceDimCode()
    begin
        Clear(strFinanceDimensionCode);
    end;

    procedure SetFinanceDimCode(strFinanceDimensionCodePara: Code[20])
    begin
        strFinanceDimensionCode := strFinanceDimensionCodePara;

    end;

    procedure GetFinanceDimCode(var strFinanceDimensionCodePara: Code[20])
    begin
        strFinanceDimensionCodePara := strFinanceDimensionCode;
    end;

    procedure ClearEntryNo()
    begin
        clear(EntryNo);
    end;

    procedure SetOldCVLedgEntryBufEntryNo(EntryNoPara: Integer)
    begin
        EntryNo := EntryNoPara;

    end;

    procedure GetOldCVLedgEntryBufEntryNo(var EntryNoPara: Integer)
    begin
        EntryNoPara := EntryNo;
    end;

    var
        Codeunit12Glb: Codeunit 12;
        TotalAmountLCY: Decimal;
        TotalAmountAddCurr: Decimal;
        TotalAmountLCYDtldCustEntry: Decimal;
        TotalAmountAddCurrDtldCustEntry: Decimal;
        GenJnlLineDtldCustEntry: Record 81;
        GenJnlLine: Record 81;
        strFinanceDimensionCode: Code[20];
        EntryNo: Integer;
}