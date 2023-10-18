codeunit 50020 BankAccLedgEntryTabEvent
{
    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        GLSetup: Record "General Ledger Setup";
        recglSetup: Record "General Ledger Setup";
    begin
        //ACXCP_BankIntegration
        //ACX_LK
        IF (GenJournalLine."Source Code" = 'BANKPYMTV') AND (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) AND
                (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Bank Account") AND (recglSetup."Bank Code" = GLSetup."Bank Code") THEN
            InsertintoBankIntegration(GenJournalLine, BankAccountLedgerEntry);
        //ACXCP_BankIntegration
    end;

    procedure InsertintoBankIntegration(GenJnlLine: Record "Gen. Journal Line"; BankAccountLedgerEntryRec: Record "Bank Account Ledger Entry")
    var
        recBankIntEntry: Record "Bank Integration Entry";
        recVendor: Record Vendor;
        recVBAcct: Record "Vendor Bank Account";
        recOrderAddress: Record "Order Address";
    begin
        recBankIntEntry.RESET();
        //recBankIntegEntry."Entry No."+1;
        recBankIntEntry."Transaction Type" := recBankIntEntry."Transaction Type"::N;
        //recBankIntEntry."Beneficiary Code":='';
        recVendor.RESET;
        recVendor.SETRANGE("No.", GenJnlLine."Bal. Account No.");
        //recVendor.GET(GenJnlLine."Bal. Account No.");
        IF recVendor.FINDFIRST THEN BEGIN
            recBankIntEntry."Beneficiary Name" := recVendor.Name;
            recBankIntEntry."Beneficiary email id" := recVendor."E-Mail";//ACXLK
            recVBAcct.RESET;
            recVBAcct.SETRANGE("Vendor No.", recVendor."No.");
            //recVBAcct.SETRANGE(Code, recVendor."Preferred Bank Account");     //Team-17783 Field removed from Vendor Table in BC
            IF recVBAcct.FINDFIRST THEN BEGIN
                recBankIntEntry."Beneficiary Account Number" := recVBAcct."Bank Account No.";
                recBankIntEntry."Beneficiary Code" := '';
                recBankIntEntry."IFC Code" := recVBAcct."SWIFT Code";
                recBankIntEntry."Bene Bank Name" := recVBAcct."Bank Branch No.";
                recBankIntEntry."Bene Bank Branch Name" := recVBAcct.City;
            END;
        END;
        recBankIntEntry."Instrument Amount" := ABS(GenJnlLine.Amount);
        recBankIntEntry."Instrument Amount.." := ROUND(ABS(GenJnlLine.Amount), 1);//ACXLK
        recBankIntEntry."Drawee Location" := '';
        recBankIntEntry."Print Location" := '';
        IF GenJnlLine."Order Address Code" <> '' THEN BEGIN
            recOrderAddress.RESET;
            recOrderAddress.SETRANGE(Code, GenJnlLine."Order Address Code");
            recOrderAddress.SETRANGE("Vendor No.", GenJnlLine."Bal. Account No.");
            IF recOrderAddress.FINDFIRST THEN BEGIN
                recBankIntEntry."Bene Address 1" := GenJnlLine."Order Address Code";
                recBankIntEntry."Bene Address 2" := recOrderAddress.Address;
                recBankIntEntry."Bene Address 3" := recOrderAddress."Address 2";
                recBankIntEntry."Bene Address 4" := recOrderAddress.City;
                recBankIntEntry."Bene Address 5" := recOrderAddress."Country/Region Code";
            END;
        END;
        //recBankIntEntry."Instruction Reference Number":='';
        recBankIntEntry."Customer Reference Number" := GenJnlLine."Payer Information";
        //recBankIntEntry."Payment details 1":='';
        //recBankIntEntry."Payment details 2":='';
        //recBankIntEntry."Payment details 3":='';
        //recBankIntEntry."Payment details 4":='';
        // recBankIntEntry."Payment details 5":='';
        // recBankIntEntry."Payment details 6":='';
        // recBankIntEntry."Payment details 7":='';
        // recBankIntEntry."Cheque Number":='';
        recBankIntEntry."Chq / Trn Date" := GenJnlLine."Posting Date";//acxcp05052022
                                                                      //recBankIntEntry."Chq / Trn Date":=FORMAT(GenJnlLine."Posting Date");

        //recBankIntEntry."MICR Number":='';
        recBankIntEntry."Created By" := USERID;
        recBankIntEntry."Created DateTime" := CURRENTDATETIME;
        recBankIntEntry."Document No." := GenJnlLine."Document No.";//ACXlk
        recBankIntEntry."Posting Date" := GenJnlLine."Posting Date";//ACXLK
        recBankIntEntry.Status := recBankIntEntry.Status::Closed;//ACXLK
        recBankIntEntry."Bank Entry No" := BankAccountLedgerEntryRec."Entry No.";//ACXLK


        recBankIntEntry.INSERT;
        //COMMIT;
    end;
}