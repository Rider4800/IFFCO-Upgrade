codeunit 50005 GenJnlLineTableEvent
{
    // [EventSubscriber(ObjectType::Table, 81, 'OnValidateAmountOnBeforeCheckCreditLimit', '', false, false)]
    // procedure OnValidateAmountOnBeforeCheckCreditLimit(CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit"; FieldNumber: Integer;
    //         var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    // begin
    //     IsHandled := true;
    //     if (FieldNumber <> 0) and
    //         (FieldNumber <> GenJournalLine.FieldNo("Applies-to Doc. No.")) and
    //         (((GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) and
    //             (GenJournalLine."Account No." <> '') and (GenJournalLine.Amount > 0) and
    //             (FieldNumber <> GenJournalLine.FieldNo("Bal. Account No."))) or
    //             ((GenJournalLine."Bal. Account Type" = "Bal. Account Type"::Customer) and
    //             (GenJournalLine."Bal. Account No." <> '') and (GenJournalLine.Amount < 0) and
    //             (FieldNumber <> GenJournalLine.FieldNo("Account No."))))
    //             AND (GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Refund)//KM
    //         then
    //         CustCheckCrLimit.GenJnlLineCheck(GenJournalLine);
    // end;
}
