codeunit 50040 COD12Event
{
    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterRunWithCheck', '', false, false)]
    local procedure OnAfterRunWithCheck(sender: Codeunit "Gen. Jnl.-Post Line"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        //ACXZAK01 - Branch Accounting
        IF NOT ((GenJnlLine."Source Code" = 'TRANSFER') OR (GenJnlLine."Source Code" = '')) THEN BEGIN
            strFinanceDimension := '';
            strFinanceDimensionCode := '';
            rsDimensionValue.RESET;
            rsDimensionValue.SETRANGE("Global Dimension No.", 1);
            IF rsDimensionValue.FIND('-') THEN BEGIN
                strFinanceDimension := rsDimensionValue."Dimension Code";
                DimSetEntry.RESET;
                DimSetEntry.SETRANGE("Dimension Set ID", GenJnlLine."Dimension Set ID");
                IF DimSetEntry.FINDSET THEN
                    REPEAT
                        IF DimSetEntry."Dimension Code" = strFinanceDimension THEN
                            strFinanceDimensionCode := DimSetEntry."Dimension Value Code";
                    UNTIL DimSetEntry.NEXT = 0;
            END;
            IF strFinanceDimensionCode = '' THEN
                strFinanceDimension := '';
        END;
        //ACXZAK01-END

    end;


    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var GenJnlLine: Record "Gen. Journal Line")
    begin
        //ACXZAK01 - Branch Accounting
        IF NOT ((GenJnlLine."Source Code" = 'PURCHASES') OR (GenJnlLine."Source Code" = 'SALES') OR (GenJnlLine."Source Code" = 'TRANSFER') OR (GenJnlLine."Source Code" = 'FAGLJNL') OR (GenJnlLine."Source Code" = '')) THEN
            // IF NOT ((GenJnlLine."Source Code" = 'PURCHASES') OR (GenJnlLine."Source Code" = 'SALES') OR (GenJnlLine."Source Code" = 'TRANSFER') OR (GenJnlLine."Source Code" = '')) THEN
            GenJnlLine.TESTFIELD(Amount);

        IF (GenJnlLine."Account No." <> '') AND
            (NOT GenJnlLine."System-Created Entry") AND (GenJnlLine."Account Type" <> GenJnlLine."Account Type"::"Fixed Asset")
        THEN
            GenJnlLine.TESTFIELD(Amount);


        IF NOT ((GenJnlLine."Source Code" = 'TRANSFER') OR (GenJnlLine."Source Code" = '')) THEN BEGIN
            strFinanceDimension := '';
            strFinanceDimensionCode := '';
            rsDimensionValue.RESET;
            rsDimensionValue.SETRANGE("Global Dimension No.", 1);
            IF rsDimensionValue.FINDFIRST THEN BEGIN
                strFinanceDimension := rsDimensionValue."Dimension Code";
                DimSetEntry.RESET;
                DimSetEntry.SETRANGE("Dimension Set ID", GenJnlLine."Dimension Set ID");
                IF DimSetEntry.FINDSET THEN
                    REPEAT
                        IF DimSetEntry."Dimension Code" = strFinanceDimension THEN
                            strFinanceDimensionCode := DimSetEntry."Dimension Value Code";
                    UNTIL DimSetEntry.NEXT = 0;
            END;
            IF strFinanceDimensionCode = '' THEN
                strFinanceDimension := '';
        END;
        //ACXZAK01-END

    end;

    var
        strFinanceDimension: Code[20];
        strFinanceDimensionCode: Code[20];
        rsDimensionValue: Record "Dimension Value";
        DimSetEntry: Record "Dimension Set Entry";
        BranchAmount: Decimal;
        ShortDim1: Code[20];
        FInDim: Code[20];
        DocNum: Code[20];
        DocNumLast: Code[20];
        recBankStatement: Record "Bank Statement Upload";
        recCalCD: Record "ACX Calculated CD Summary";
        TempDocNo: Code[20];

}
