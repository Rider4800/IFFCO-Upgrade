codeunit 50040 COD12Event
{

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterRunWithCheck', '', false, false)]
    local procedure OnAfterRunWithCheck(var GenJnlLine: Record "Gen. Journal Line"; sender: Codeunit "Gen. Jnl.-Post Line")
    var
        Cod12SingInst: Codeunit 50041;
    begin
        Clear(Cod12SingInst);
        Cod12SingInst.ClearVariables();
        Cod12SingInst.ClearFinanceDimCode();
        Cod12SingInst.SetData(sender);
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

            Cod12SingInst.SetFinanceDimCode(strFinanceDimensionCode);
        END;
        //ACXZAK01-END

    end;


    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var GenJnlLine: Record "Gen. Journal Line")
    var
        Cod12SingInst: Codeunit 50041;
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

            Cod12SingInst.SetFinanceDimCode(strFinanceDimensionCode);
        END;
        //ACXZAK01-END

    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostGLAcc', '', false, false)]
    local procedure OnBeforePostGLAcc(GenJournalLine: Record "Gen. Journal Line")
    begin
        //Acx_Anubha28/07/2021
        IF TempDocNo <> GenJournalLine."Document No." THEN
            CreateBranchEntry(GenJournalLine, GenJournalLine."Document No.");//Acx_Anubha
        TempDocNo := GenJournalLine."Document No.";
        //Acx_Anubha28/07/2021
    end;

    local procedure CreateBranchEntry(GenJnlLine: Record "Gen. Journal Line"; DocNo: Code[20])
    var
        RecGenJnl: Record "Gen. Journal Line";
        DimensionValue: Record "Dimension Value";
        Debmount: Decimal;
        CrAmount: Decimal;
        totAmount: Decimal;
        RecGenJnl2: Record "Gen. Journal Line";
        GlEntry: Record "G/L Entry";
        totAmntLCy: Decimal;
        Recgl: Record "G/L Account";
        Accno: Code[20];
        recbank: Record "Bank Account";
        bankGLAcc: Code[20];
        recdimvalue: Record "Dimension Value";
        finstate: Code[20];
        Recgl1: Record "G/L Account";
        DocNumLast: Code[20];
        Cod12SingInst: Codeunit 50041;
        Codeunit12Glb: Codeunit 12;
    begin
        Cod12SingInst.GetData(Codeunit12Glb);
        totAmount := 0;
        totAmntLCy := 0;
        IF DocNumLast <> GenJnlLine."Document No." THEN BEGIN
            Accno := '';
            RecGenJnl.RESET();
            RecGenJnl.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            RecGenJnl.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            //RecGenJnl.SETFILTER("Finance Branch A/c Code",'<>%1','');//change
            RecGenJnl.SETRANGE("Document No.", GenJnlLine."Document No.");
            IF RecGenJnl.FINDFIRST THEN BEGIN
                REPEAT
                    totAmount += ABS(RecGenJnl.Amount);
                    totAmntLCy += RecGenJnl."Amount (LCY)";
                UNTIL RecGenJnl.NEXT = 0;
            END;

            finstate := '';
            recdimvalue.RESET;
            recdimvalue.SETRANGE("Dimension Code", 'STATE');
            recdimvalue.SETRANGE(Code, GenJnlLine."Finance Branch A/c Code");
            IF recdimvalue.FINDFIRST THEN
                finstate := recdimvalue."STATE-FIN";

            RecGenJnl2.RESET();
            RecGenJnl2.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            RecGenJnl2.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            //RecGenJnl2.SETRANGE("Line No.",GenJnlLine."Line No.");
            RecGenJnl2.SETRANGE("Document No.", GenJnlLine."Document No.");
            //RecGenJnl2.SETRANGE("Credit Amount",'=%1',0);
            IF RecGenJnl2.FINDFIRST THEN BEGIN
                REPEAT //change
                    IF (RecGenJnl2."Shortcut Dimension 1 Code" <> '') AND (RecGenJnl2."Shortcut Dimension 1 Code" <> RecGenJnl2."Finance Branch A/c Code") AND (RecGenJnl2."Finance Branch A/c Code" <> '')
                   AND ((RecGenJnl2."Account Type" <> RecGenJnl2."Account Type"::Vendor) AND (RecGenJnl2."Account Type" <> RecGenJnl2."Account Type"::Customer))
                      //AND(RecGenJnl2."Credit Amount"<>0)
                      AND
                        ((RecGenJnl2."Bal. Account Type" <> RecGenJnl2."Bal. Account Type"::Vendor) AND (RecGenJnl2."Bal. Account Type" <> RecGenJnl2."Bal. Account Type"::Customer))
                        THEN BEGIN
                        Accno := '';//Change
                        Recgl.RESET;
                        IF Recgl.GET(RecGenJnl2."Account No.") AND (Recgl."Branch GL" <> FALSE) AND (RecGenJnl2."Finance Branch A/c Code" <> '') THEN BEGIN
                            Accno := RecGenJnl2."Account No.";
                        END ELSE BEGIN
                            IF (RecGenJnl2."Account Type" = RecGenJnl2."Account Type"::"Bank Account") AND (Accno = '') AND (RecGenJnl2."Finance Branch A/c Code" <> '') THEN
                                Accno := FindGlacc(RecGenJnl2."Account Type", RecGenJnl2."Account No.");
                        END;

                        Recgl1.RESET;
                        IF Recgl1.GET(RecGenJnl2."Bal. Account No.") AND (Recgl1."Branch GL" <> FALSE) AND (RecGenJnl2."Finance Branch A/c Code" <> '') THEN BEGIN
                            Accno := RecGenJnl2."Bal. Account No.";
                        END ELSE BEGIN
                            IF (RecGenJnl2."Bal. Account Type" = RecGenJnl2."Bal. Account Type"::"Bank Account") AND (Accno = '') AND (RecGenJnl2."Finance Branch A/c Code" <> '') THEN
                                Accno := FindGlacc(RecGenJnl2."Bal. Account Type", RecGenJnl2."Bal. Account No.")
                        END;

                        // REPEAT //change
                        RecGenJnl2.TESTFIELD("Shortcut Dimension 1 Code");
                        RecGenJnl2.TESTFIELD("Finance Branch A/c Code");
                        IF (Recgl.GET(GenJnlLine."Account No.") AND (Recgl."Branch GL")) OR (RecGenJnl2."Account Type" = RecGenJnl2."Account Type"::"Bank Account") THEN
                            Codeunit12Glb.InitGLEntry(GenJnlLine, GlEntry, Accno, -RecGenJnl2.Amount, RecGenJnl2."Amount (LCY)", TRUE, TRUE)
                        ELSE
                            Codeunit12Glb.InitGLEntry(GenJnlLine, GlEntry, Accno, -RecGenJnl2.Amount, -RecGenJnl2."Amount (LCY)", TRUE, TRUE);
                        GlEntry."Bal. Account Type" := GenJnlLine."Account Type";
                        // GLEntry."Bal. Account No." := GenJnlLine."Account No.";
                        GlEntry."Global Dimension 1 Code" := RecGenJnl2."Shortcut Dimension 1 Code";
                        recdimvalue.RESET;
                        recdimvalue.SETRANGE("Dimension Code", 'STATE');
                        recdimvalue.SETRANGE(Code, RecGenJnl2."Shortcut Dimension 1 Code");
                        IF recdimvalue.FINDFIRST THEN
                            finstate := recdimvalue."STATE-FIN";
                        GlEntry."Source Branch" := 'ACCBRANCH';
                        GlEntry."Branch JV" := TRUE;
                        Codeunit12Glb.InsertGLEntry(GenJnlLine, GlEntry, TRUE);

                        IF (Recgl.GET(GenJnlLine."Account No.") AND (Recgl."Branch GL")) OR (RecGenJnl2."Account Type" = RecGenJnl2."Account Type"::"Bank Account") THEN
                            Codeunit12Glb.InitGLEntry(GenJnlLine, GlEntry, Accno, RecGenJnl2.Amount, -RecGenJnl2."Amount Excl. GST", TRUE, TRUE)
                        ELSE
                            Codeunit12Glb.InitGLEntry(GenJnlLine, GlEntry, Accno, RecGenJnl2.Amount, RecGenJnl2."Amount Excl. GST", TRUE, TRUE);
                        GlEntry."Bal. Account Type" := GenJnlLine."Account Type";
                        // GLEntry."Bal. Account No." := GenJnlLine."Account No.";
                        GlEntry."Global Dimension 1 Code" := RecGenJnl2."Finance Branch A/c Code";
                        recdimvalue.RESET;
                        recdimvalue.SETRANGE("Dimension Code", 'STATE');
                        recdimvalue.SETRANGE(Code, RecGenJnl2."Finance Branch A/c Code");
                        IF recdimvalue.FINDFIRST THEN
                            finstate := recdimvalue."STATE-FIN";
                        GlEntry.VALIDATE("Global Dimension 2 Code", finstate);
                        GlEntry."Source Branch" := 'ACCBRANCH';
                        GlEntry."Branch JV" := TRUE;
                        Codeunit12Glb.InsertGLEntry(GenJnlLine, GlEntry, TRUE);
                        // IF (RecGenJnl2."Credit Amount"<>0) THEN
                        // CreateInterUnitEntries(RecGenJnl2."Shortcut Dimension 1 Code",RecGenJnl2."Finance Branch A/c Code",RecGenJnl2.Amount,RecGenJnl2."Amount (LCY)",GenJnlLine)
                        //  ELSE
                        CreateInterUnitEntries(RecGenJnl2."Shortcut Dimension 1 Code", RecGenJnl2."Finance Branch A/c Code", -RecGenJnl2.Amount, -RecGenJnl2."Amount (LCY)", GenJnlLine);
                        //  U
                        //  UNTIL RecGenJnl2.NEXT=0;//change
                    END;

                UNTIL RecGenJnl2.NEXT = 0;
            END;
            DocNumLast := GenJnlLine."Document No.";

        END;

    end;


    local procedure FindGlacc(Acctype: Enum "Gen. Journal Account Type"; Acc: Code[20]) accGL: Code[20]
    var
        recbankAcc: Record "Bank Account";
        recbankposting: Record "Bank Account Posting Group";
        RecGLAcc: Record "G/L Account";
    begin
        recbankAcc.RESET;
        IF recbankAcc.GET(Acc) THEN BEGIN
            recbankposting.RESET;
            recbankposting.SETRANGE(Code, recbankAcc."Bank Acc. Posting Group");
            IF recbankposting.FINDFIRST THEN BEGIN
                RecGLAcc.RESET;
                IF RecGLAcc.GET(recbankposting."G/L Account No.") AND (RecGLAcc."Branch GL") THEN
                    accGL := recbankposting."G/L Account No.";
            END;
        END;
    end;

    local procedure CreateInterUnitEntries(Fincode: Code[20]; FinBranchAcc: Code[20]; TotAmount: Decimal; TotAmountLCy: Decimal; GenJnlLine: Record "Gen. Journal Line")
    var
        DimVAL: Record "Dimension Value";
        GLNum: Code[20];
        GLEntry: Record "G/L Entry";
        recgl: Record "G/L Account";
        recdimvalue: Record "Dimension Value";
        finstate: Code[20];
        DocNum: Code[20];
        Cod12SingInst: Codeunit 50041;
        Codeunit12Glb: Codeunit 12;
    begin
        Cod12SingInst.GetData(Codeunit12Glb);
        finstate := '';
        recdimvalue.RESET;
        recdimvalue.SETRANGE("Dimension Code", 'STATE');
        recdimvalue.SETRANGE(Code, FinBranchAcc);
        IF recdimvalue.FINDFIRST THEN
            finstate := recdimvalue."STATE-FIN";

        //IF  DocNum<>DocumentNo THEN BEGIN
        DimVAL.RESET();
        DimVAL.SETRANGE("Dimension Code", 'STATE');
        DimVAL.SETRANGE(Code, Fincode);
        IF DimVAL.FINDFIRST THEN BEGIN
            DimVAL.TESTFIELD("Branch G/L Account");
            IF (recgl.GET(GenJnlLine."Account No.") AND (recgl."Branch GL")) OR (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") THEN
                Codeunit12Glb.InitGLEntry(GenJnlLine, GLEntry, DimVAL."Branch G/L Account", TotAmount, TotAmount, TRUE, TRUE)
            ELSE
                Codeunit12Glb.InitGLEntry(GenJnlLine, GLEntry, DimVAL."Branch G/L Account", TotAmount, TotAmount, TRUE, TRUE);
            //      MESSAGE('%1',DimVAL."Branch G/L Account");
            GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
            GLEntry."Global Dimension 1 Code" := FinBranchAcc;
            GLEntry.VALIDATE("Global Dimension 2 Code", finstate);
            GLEntry."Source Branch" := 'ACCBRANCH';
            GLEntry."Branch JV" := TRUE;
            Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            //       END;


            DimVAL.RESET();
            DimVAL.SETRANGE("Dimension Code", 'STATE');
            DimVAL.SETRANGE(Code, FinBranchAcc);
            IF DimVAL.FINDFIRST THEN BEGIN
                DimVAL.TESTFIELD("Branch G/L Account");
                IF (recgl.GET(GenJnlLine."Account No.") AND (recgl."Branch GL")) OR (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") THEN
                    Codeunit12Glb.InitGLEntry(GenJnlLine, GLEntry, DimVAL."Branch G/L Account", -TotAmount, -TotAmount, TRUE, TRUE)
                ELSE
                    Codeunit12Glb.InitGLEntry(GenJnlLine, GLEntry, DimVAL."Branch G/L Account", -TotAmount, -TotAmount, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
                GLEntry."Global Dimension 1 Code" := Fincode;
                GLEntry."Branch JV" := TRUE;
                GLEntry."Source Branch" := 'ACCBRANCH';
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            END;
            DocNum := GenJnlLine."Document No.";
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostGLAccOnAfterInitGLEntry', '', false, false)]
    local procedure OnPostGLAccOnAfterInitGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    var
        GLAcc: Record "G/L Account";
    begin
        //ACXZAK01-BEGIN
        GLAcc.GET(GenJournalLine."Account No.");
        IF NOT GenJournalLine."System-Created Entry" THEN
            IF GenJournalLine."Posting Date" = NORMALDATE(GenJournalLine."Posting Date") THEN
                IF GenJournalLine."Source Code" <> 'BRANCHCASH' THEN
                    GLAcc.TESTFIELD("Direct Posting", TRUE);
        //ACXZAK01-END
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostCustOnAfterAssignReceivablesAccount', '', false, false)]
    local procedure OnPostCustOnAfterAssignReceivablesAccount(GenJnlLine: Record "Gen. Journal Line")
    var
        GLAcc: Record "G/L Account";
        CodScheme: Codeunit "Scheme Calculation";
        recCalCDPPC: Record "ACX Scheme Summary";
    begin
        //PS29062021
        recBankStatement.RESET();
        recBankStatement.SETRANGE("Pre Document No.", GenJnlLine."Old Document No.");
        IF recBankStatement.FIND('-') THEN BEGIN
            recBankStatement."Posted Document No." := GenJnlLine."Document No.";
            recBankStatement.MODIFY();
        END;
        //KM290621
        recCalCD.RESET();
        recCalCD.SETRANGE("Credit Note No.", GenJnlLine."Old Document No.");
        IF recCalCD.FIND('-') AND (GenJnlLine."Cal. Scheme Line No." > 0) THEN BEGIN
            recCalCD.VALIDATE("Posted Credit Note ID", GenJnlLine."Document No.");
            recCalCD."Posted Credit Note Date" := GenJnlLine."Posting Date";
            recCalCD.IsCalculated := TRUE;
            recCalCD.MODIFY();
        END;
        IF GenJnlLine."Cal. Scheme Line No." <> 0 THEN
            CodScheme.InsertPostedCDDetails(recCalCD."Posted Credit Note ID", recCalCD."Customer No.");
        //KM290621
        //KM_090822+
        recCalCD.RESET();
        recCalCDPPC.SETRANGE("Credit Note No.", GenJnlLine."Old Document No.");
        recCalCDPPC.SETRANGE("Line No.", GenJnlLine."Cal. Scheme Line No.");
        recCalCDPPC.SETRANGE("Payment No.", GenJnlLine."External Document No.");
        recCalCDPPC.SETRANGE("Invoice No.", GenJnlLine."PPS Invoice No.");
        IF recCalCDPPC.FIND('-') THEN BEGIN
            recCalCDPPC.VALIDATE("Posted Credit Note ID", GenJnlLine."Document No.");
            recCalCDPPC."Posted Credit Note Date" := GenJnlLine."Posting Date";
            recCalCDPPC.IsCalculated := TRUE;
            recCalCDPPC.MODIFY();
        END;
        //KM_090822-
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnBeforeCustLedgEntryInsert(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        GLAcc: Record "G/L Account";
        CodScheme: Codeunit "Scheme Calculation";
        recCalCDPPC: Record "ACX Scheme Summary";
    begin
        IF GenJournalLine."Cal. Scheme Line No." <> 0 THEN
            CustLedgerEntry."Scheme Calculated" := TRUE;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostBankAcc', '', false, false)]
    local procedure OnBeforePostBankAcc(var GenJournalLine: Record "Gen. Journal Line")
    begin
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Bank Account") AND (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"Bank Account") THEN//Acx_Anubha
            CreateBranchEntry(GenJournalLine, GenJournalLine."Document No.");//Acx_Anubha
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Finance Branch A/c Code" := GenJournalLine."Finance Branch A/c Code";//Acx_Anubha
        GLEntry."Provisional Entries" := GenJournalLine."Provisional Entries";//ACXCP06122021
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //acxcp_300622_CampaignCode +
        //acxcp30062022 + //insert Campaign Code to CLE
        CustLedgerEntry."Campaign No." := GenJournalLine."Campaign No.";
        //acxcp30062022 -
        //acxcp_300622_CampaignCode -

        //acxcp_090822 + //ShipToReport
        CustLedgerEntry."Ship-to Code" := GenJournalLine."Ship-to Code";
        //acxcp_090822 -

    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        IF GenJournalLine."Cal. Scheme Line No." <> 0 THEN//KM
            DtldCustLedgEntry."Scheme Calculated" := TRUE;
    end;


    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterSetDtldCustLedgEntryNoOffset', '', false, false)]
    local procedure OnAfterSetDtldCustLedgEntryNoOffset()
    var
        Cu50041: Codeunit 50041;
    begin
        Cu50041.ClearPostDtldCustLedgEntries();
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostDtldCustLedgEntriesOnBeforePostDtldCustLedgEntry', '', false, false)]
    local procedure OnPostDtldCustLedgEntriesOnBeforePostDtldCustLedgEntry(AddCurrencyCode: Code[10]; AdjAmount: array[4] of Decimal; CustPostingGr: Record "Customer Posting Group"; sender: Codeunit "Gen. Jnl.-Post Line"; var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var NextEntryNo: Integer)
    var
        Cu50041: Codeunit 50041;
    begin
        // IsHandled := true;
        if ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) or
            (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) or
            ((AddCurrencyCode <> '') and (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
        then begin
            Cu50041.SetDataPostDtldCustLedgEntries(DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount", GenJnlLine);
            //PostDtldCustLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, AdjAmount);
        end;


    end;

    /*  local procedure PostDtldCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CustPostingGr: Record "Customer Posting Group"; var AdjAmount: array[4] of Decimal)
      var
          AccNo: Code[20];
          MultiplePostingGroups: Boolean;
      begin
          MultiplePostingGroups := CheckCustMultiplePostingGroups(DetailedCVLedgEntryBuffer);
          if MultiplePostingGroups and (DetailedCVLedgEntryBuffer."Entry Type" = DetailedCVLedgEntryBuffer."Entry Type"::Application) then
              AccNo := GetCustDtldCVLedgEntryBufferAccNo(GenJournalLine, DetailedCVLedgEntryBuffer)
          else
              AccNo := GetDtldCustLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, CustPostingGr, 0, false);
          PostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, AccNo, AdjAmount, false);
      end;

      local procedure GetDtldCustLedgEntryAccNo(GenJnlLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; CustPostingGr: Record "Customer Posting Group"; OriginalTransactionNo: Integer; Unapply: Boolean) AccountNo: Code[20]
      var
          GenPostingSetup: Record "General Posting Setup";
          Currency: Record Currency;
          AmountCondition: Boolean;
          IsHandled: Boolean;
          GLSetup: Record "General Ledger Setup";
      begin
          GLSetup.get('');
          with DtldCVLedgEntryBuf do begin
              AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf, Unapply);
              case "Entry Type" of
                  "Entry Type"::"Initial Entry":
                      ;
                  "Entry Type"::Application:
                      ;
                  "Entry Type"::"Unrealized Loss",
                  "Entry Type"::"Unrealized Gain",
                  "Entry Type"::"Realized Loss",
                  "Entry Type"::"Realized Gain":
                      begin
                          GetCurrency(Currency, "Currency Code");
                          CheckNonAddCurrCodeOccurred(Currency.Code);
                          exit(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
                      end;
                  "Entry Type"::"Payment Discount":
                      exit(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                  "Entry Type"::"Payment Discount (VAT Excl.)":
                      begin
                          TestField("Gen. Prod. Posting Group");
                          GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                          exit(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                      end;
                  "Entry Type"::"Appln. Rounding":
                      exit(CustPostingGr.GetApplRoundingAccount(AmountCondition));
                  "Entry Type"::"Correction of Remaining Amount":
                      exit(CustPostingGr.GetRoundingAccount(AmountCondition));
                  "Entry Type"::"Payment Discount Tolerance":
                      case GLSetup."Pmt. Disc. Tolerance Posting" of
                          GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                              exit(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                          GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                              exit(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                      end;
                  "Entry Type"::"Payment Tolerance":
                      case GLSetup."Payment Tolerance Posting" of
                          GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                              exit(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                          GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                              exit(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                      end;
                  "Entry Type"::"Payment Tolerance (VAT Excl.)":
                      begin
                          TestField("Gen. Prod. Posting Group");
                          GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                          case GLSetup."Payment Tolerance Posting" of
                              GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                                  exit(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                              GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                                  exit(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                          end;
                      end;
                  "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                      begin
                          GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                          case GLSetup."Pmt. Disc. Tolerance Posting" of
                              GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                                  exit(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                              GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                                  exit(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                          end;
                      end;
                  "Entry Type"::"Payment Discount (VAT Adjustment)",
                "Entry Type"::"Payment Tolerance (VAT Adjustment)",
                "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                      if Unapply then
                          PostDtldCustVATAdjustment(GenJnlLine, DtldCVLedgEntryBuf, OriginalTransactionNo);
                  else
                      FieldError("Entry Type");
              end;
          end;
      end;

      local procedure GetCustDtldCVLedgEntryBufferAccNo(var GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"): Code[20]
      var
          CustLedgerEntry: Record "Cust. Ledger Entry";
          CustomerPostingGroup: Record "Customer Posting Group";
      begin
          CustLedgerEntry.Get(DetailedCVLedgEntryBuffer."CV Ledger Entry No.");
          CustomerPostingGroup.Get(CustLedgerEntry."Customer Posting Group");
          exit(CustomerPostingGroup.GetReceivablesAccount());
      end;

      procedure CheckCustMultiplePostingGroups(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"): Boolean
      var
          CustLedgerEntry: Record "Cust. Ledger Entry";
          PostingGroup: Code[20];
          IsHandled: Boolean;
          IsMultiplePostingGroups: Boolean;
      begin
          PostingGroup := '';
          DetailedCVLedgEntryBuffer.Reset();
          DetailedCVLedgEntryBuffer.SetRange("Entry Type", DetailedCVLedgEntryBuffer."Entry Type"::Application);
          if DetailedCVLedgEntryBuffer.FindSet then
              repeat
                  CustLedgerEntry.Get(DetailedCVLedgEntryBuffer."CV Ledger Entry No.");
                  if (PostingGroup <> '') and (PostingGroup <> CustLedgerEntry."Customer Posting Group") then
                      exit(true);
                  PostingGroup := CustLedgerEntry."Customer Posting Group";
              until DetailedCVLedgEntryBuffer.Next() = 0;
          exit(false);
      end;
  */

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostDtldCustLedgEntriesOnAfterCreateGLEntriesForTotalAmounts', '', false, false)]
    local procedure OnPostDtldCustLedgEntriesOnAfterCreateGLEntriesForTotalAmounts(NextTransactionNo: Integer; var GlobalGLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        Cu50041: Codeunit 50041;
        TotalAmountLCY: Decimal;
        TotalAmountAddCurr: Decimal;
        GenJnlLine: Record 81;
        Codeunit12Glb: Codeunit 12;
        CustPostingGr: Record "Customer Posting Group";
        GLEntry: Record "G/L Entry";
    begin
        Cu50041.GetDataPostDtldVendLedgEntries(TotalAmountLCY, TotalAmountAddCurr, GenJnlLine);
        Cu50041.GetData(Codeunit12Glb);
        Cu50041.GetFinanceDimCode(strFinanceDimensionCode);
        CustPostingGr.GET(GenJnlLine."Posting Group");
        //ACXZAK01-BEGIN
        IF GenJnlLine."Source Code" <> 'TRANSFER' THEN BEGIN
            IF (strFinanceDimensionCode <> GenJnlLine."Finance Branch A/c Code") AND
                      (GenJnlLine."Finance Branch A/c Code" <> '') AND (strFinanceDimensionCode <> '') THEN BEGIN
                //Voucher at Current Location
                rsDimensionValue.RESET;
                rsDimensionValue.SETRANGE("Global Dimension No.", 1);
                rsDimensionValue.SETRANGE(Code, GenJnlLine."Finance Branch A/c Code");
                rsDimensionValue.FIND('-');
                rsDimensionValue.TESTFIELD("Branch G/L Account");
                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, CustPostingGr."Receivables Account", -TotalAmountLCY, -TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
                GLEntry."Bal. Account No." := rsDimensionValue."Branch G/L Account";
                GLEntry."Global Dimension 1 Code" := strFinanceDimensionCode;
                GLEntry.VALIDATE("Global Dimension 2 Code", rsDimensionValue."STATE-FIN");
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);

                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, rsDimensionValue."Branch G/L Account", TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
                GLEntry."Bal. Account No." := GenJnlLine."Account No.";
                GLEntry."Global Dimension 1 Code" := strFinanceDimensionCode;
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);

                //Voucher at Primary Branch Location
                rsDimensionValue.RESET;
                rsDimensionValue.SETRANGE("Global Dimension No.", 1);
                rsDimensionValue.SETRANGE(Code, strFinanceDimensionCode);
                rsDimensionValue.FIND('-');
                rsDimensionValue.TESTFIELD("Branch G/L Account");
                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, CustPostingGr."Receivables Account", TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
                GLEntry."Bal. Account No." := rsDimensionValue."Branch G/L Account";
                GLEntry."Global Dimension 1 Code" := GenJnlLine."Finance Branch A/c Code";
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
                //TempJnlLineDim

                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, rsDimensionValue."Branch G/L Account", -TotalAmountLCY, -TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
                GLEntry."Bal. Account No." := GenJnlLine."Account No.";
                GLEntry."Global Dimension 1 Code" := GenJnlLine."Finance Branch A/c Code";
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            END;
        END;

        //ACXZAK01-END

    end;

    //*12887---> need to review this work with Vivek sir as Branch Account GL Entries are creating
    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterSetDtldVendLedgEntryNoOffset', '', false, false)]
    local procedure OnAfterSetDtldVendLedgEntryNoOffset()
    var
        Cu50041: Codeunit 50041;
    begin
        Cu50041.ClearPostDtldVendLedgEntries();
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostDtldVendLedgEntriesOnBeforePostDtldVendLedgEntry', '', false, false)]
    local procedure OnPostDtldVendLedgEntriesOnBeforePostDtldVendLedgEntry(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var GenJnlLine: Record "Gen. Journal Line")
    var
        Cu50041: Codeunit 50041;
    begin
        GetGLSetup;
        IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
    (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
   ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
            THEN BEGIN
            //ACXZAK01-BEGIN
            Cu50041.SetDataPostDtldVendLedgEntries(DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount", GenJnlLine);
        END; //ACXZAK01-END
    end;


    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostDtldVendLedgEntriesOnAfterCreateGLEntriesForTotalAmounts', '', false, false)]
    local procedure OnPostDtldVendLedgEntriesOnAfterCreateGLEntriesForTotalAmounts(NextTransactionNo: Integer; var GlobalGLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        Cu50041: Codeunit 50041;
        TotalAmountLCY: Decimal;
        TotalAmountAddCurr: Decimal;
        GenJnlLine: Record 81;
        Codeunit12Glb: Codeunit 12;
        VendPostingGr: Record "Vendor Posting Group";
        GLEntry: Record "G/L Entry";
        recdim: Record "Dimension Value";
    begin
        VendPostingGr.get(GenJnlLine."Posting Group");
        Cu50041.GetDataPostDtldVendLedgEntries(TotalAmountLCY, TotalAmountAddCurr, GenJnlLine);
        Cu50041.GetData(Codeunit12Glb);
        Cu50041.GetFinanceDimCode(strFinanceDimensionCode);
        //ACXZAK01-BEGIN Branch Accounts
        IF GenJnlLine."Source Code" <> 'TRANSFER' THEN BEGIN
            IF (strFinanceDimensionCode <> GenJnlLine."Finance Branch A/c Code") AND
                         (GenJnlLine."Finance Branch A/c Code" <> '') AND (strFinanceDimensionCode <> '') THEN BEGIN

                //Voucher at Current Location
                rsDimensionValue.RESET;
                rsDimensionValue.SETRANGE("Global Dimension No.", 1);
                rsDimensionValue.SETRANGE(Code, GenJnlLine."Finance Branch A/c Code");
                rsDimensionValue.FIND('-');
                rsDimensionValue.TESTFIELD("Branch G/L Account");
                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, VendPostingGr."Payables Account", -TotalAmountLCY, -TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
                GLEntry."Bal. Account No." := rsDimensionValue."Branch G/L Account";
                GLEntry."Global Dimension 1 Code" := strFinanceDimensionCode;

                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);

                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, rsDimensionValue."Branch G/L Account", TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
                GLEntry."Bal. Account No." := GenJnlLine."Account No.";
                GLEntry."Global Dimension 1 Code" := strFinanceDimensionCode;
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);

                //Voucher at Primary Branch Location
                rsDimensionValue.RESET;
                rsDimensionValue.SETRANGE("Global Dimension No.", 1);
                rsDimensionValue.SETRANGE(Code, strFinanceDimensionCode);
                rsDimensionValue.FIND('-');
                rsDimensionValue.TESTFIELD("Branch G/L Account");
                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, VendPostingGr."Payables Account", TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
                GLEntry."Bal. Account No." := rsDimensionValue."Branch G/L Account";
                GLEntry."Global Dimension 1 Code" := GenJnlLine."Finance Branch A/c Code";
                recdim.RESET;
                recdim.SETRANGE("Dimension Code", 'STATE');
                recdim.SETRANGE(Code, GenJnlLine."Finance Branch A/c Code");
                IF recdim.FINDFIRST THEN
                    GLEntry.VALIDATE("Global Dimension 2 Code", recdim."STATE-FIN");
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);

                Codeunit12Glb.InitGLEntry(
                   GenJnlLine, GLEntry, rsDimensionValue."Branch G/L Account", -TotalAmountLCY, -TotalAmountAddCurr, TRUE, TRUE);
                GLEntry."Bal. Account Type" := GenJnlLine."Account Type";
                GLEntry."Bal. Account No." := GenJnlLine."Account No.";
                GLEntry."Global Dimension 1 Code" := GenJnlLine."Finance Branch A/c Code";
                recdim.RESET;
                recdim.SETRANGE("Dimension Code", 'STATE');
                recdim.SETRANGE(Code, GenJnlLine."Finance Branch A/c Code");
                IF recdim.FINDFIRST THEN
                    GLEntry.VALIDATE("Global Dimension 2 Code", recdim."STATE-FIN");
                GLEntry."Branch JV" := TRUE;
                Codeunit12Glb.InsertGLEntry(GenJnlLine, GLEntry, TRUE);
            END;
        END;
        //ACXZAK01
    end;

    LOCAL procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.GET;

        AddCurrencyCode := GLSetup."Additional Reporting Currency";
    end;
    //<----12887 need to review this work with Vivek sir as Branch Account GL Entries are creating*/

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterPostApply', '', false, false)]
    local procedure OnAfterPostApply(var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    var
        Cu50041: Codeunit 50041;
    begin
        Cu50041.ClearEntryNo();
        Cu50041.SetOldCVLedgEntryBufEntryNo(OldCVLedgEntryBuf."Entry No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 18430, 'OnBeforePostGSTWithNormalPaymentOnline', '', false, false)]
    local procedure OnBeforePostGSTWithNormalPaymentOnline(var IsHandled: Boolean)
    var
        Cu50041: Codeunit 50041;
        ApplyingVendorLedgerEntry: Record "Vendor Ledger Entry";
        EntryNum: Integer;
    begin
        Cu50041.GetOldCVLedgEntryBufEntryNo(EntryNum);
        if not ApplyingVendorLedgerEntry.Get(EntryNum) then;

        if ApplyingVendorLedgerEntry."Document Type" = ApplyingVendorLedgerEntry."Document Type"::Invoice then begin
            //ACX-RK 02092021 Bgin
            IF ApplyingVendorLedgerEntry."GST Reverse Charge" THEN
                IsHandled := true;
            //ACX-RK End

        end;
    end;

    //->17783   Flow "External Doc. No. New" field from GenJnlLine to BankAccLedgEntry
    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure OnAfterInitBankAccLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccountLedgerEntry."External Document No. New" := GenJournalLine."External Document No. New";
    end;
    //<-17783

    //->17783   Flow "External Doc. No. New" field from GenJnlLine to GLEntry
    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."External Document No. New" := GenJournalLine."External Document No. New";
    end;
    //<-17783

    var
        strFinanceDimension: Code[20];
        AddCurrencyCode: Code[10];
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
