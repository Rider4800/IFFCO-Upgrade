pageextension 50058 pageextension50058 extends "Bank Account Ledger Entries"
{
    actions
    {
        addafter("Print Voucher")
        {
            action(BankIntegration)
            {
                Caption = 'BankIntegration';
                Image = ImportExport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(recBankAccLedgEntry);
                    IF recBankAccLedgEntry.FINDFIRST THEN
                        REPEAT
                            recBankIntEntry.RESET();
                            recBankIntEntry.SETRANGE("Document No.", recBankAccLedgEntry."Document No.");
                            IF recBankIntEntry.FINDFIRST THEN
                                REPEAT
                                    IF recBankIntEntry.Status = recBankIntEntry.Status::Finish THEN
                                        ERROR('Document No. -%1 is already Closed', recBankIntEntry."Document No.")////acxcp05052022
                                    ELSE
                                        recBankIntEntry.Status := recBankIntEntry.Status::New;
                                    recBankIntEntry.MODIFY;
                                UNTIL recBankIntEntry.NEXT = 0;
                        UNTIL recBankAccLedgEntry.NEXT = 0;
                    COMMIT;

                    REPORT.RUNMODAL(REPORT::BankExpFile, FALSE, TRUE);
                    CurrPage.SETSELECTIONFILTER(recBankAccLedgEntry);
                    IF recBankAccLedgEntry.FINDFIRST THEN
                        REPEAT
                            recBankIntEntry.RESET();
                            recBankIntEntry.SETRANGE("Document No.", recBankAccLedgEntry."Document No.");
                            IF recBankIntEntry.FINDFIRST THEN
                                REPEAT
                                    recBankIntEntry.Status := recBankIntEntry.Status::Finish;
                                    recBankIntEntry.MODIFY;
                                UNTIL recBankIntEntry.NEXT = 0;
                        UNTIL recBankAccLedgEntry.NEXT = 0;
                    COMMIT;//lk
                end;
            }
        }
    }

    var
        recBankIntEntry: Record 50023;
        recBankAccLedgEntry: Record 271;
}

