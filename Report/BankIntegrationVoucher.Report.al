report 50010 "Bank Integration Voucher"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Statement Upload"; 50004)
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending)
                                WHERE(Status = FILTER(New));

            trigger OnAfterGetRecord()
            begin
                txtErrorMessage := '';
                blStatus := FALSE;
                recCust.RESET();
                IF NOT recCust.GET("Bank Statement Upload"."Virtual Account Number") THEN BEGIN
                    txtErrorMessage := 'Customer not found!';
                    blStatus := TRUE;
                END;

                recCust.RESET();
                recCust.SETRANGE("No.", "Bank Statement Upload"."Virtual Account Number");
                IF recCust.FIND('-') THEN BEGIN
                    IF (recCust.Blocked = recCust.Blocked::All) THEN
                        txtErrorMessage := txtErrorMessage + ',' + 'Customer is blocked!';
                    blStatus := TRUE;
                END;


                IF (blStatus = TRUE) AND (txtErrorMessage <> '') THEN BEGIN
                    "Bank Statement Upload".Status := "Bank Statement Upload".Status::Error;
                    "Bank Statement Upload"."Error Message" := txtErrorMessage;
                    "Bank Statement Upload".MODIFY();
                END ELSE BEGIN
                    recGJL.RESET();
                    recGJL.INIT();
                    recGJL.VALIDATE("Journal Template Name", 'BANKRECEI');
                    recGJL.VALIDATE("Journal Batch Name", 'BANK_INT');

                    LineNo := 0;
                    recGJL1.RESET();
                    recGJL1.SETRANGE("Journal Template Name", 'BANKRECEI');
                    recGJL1.SETRANGE("Journal Batch Name", 'BANK_INT');
                    IF recGJL1.FINDLAST THEN
                        LineNo := recGJL1."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    recGJL.VALIDATE("Line No.", LineNo);

                    DocNo := '';
                    cdPostNo := '';
                    recGJB.RESET();
                    recGJB.SETRANGE("Journal Template Name", 'BANKRECEI');
                    recGJB.SETRANGE(Name, 'BANK_INT');
                    IF recGJB.FIND('-') THEN BEGIN
                        DocNo := NoSeries.GetNextNo(recGJB."No. Series", WORKDATE, FALSE);
                        cdPostNo := recGJB."Posting No. Series";
                    END;

                    recGJL.VALIDATE("Document No.", DocNo);
                    recGJL.VALIDATE("Document Date", "Bank Statement Upload"."Value date");
                    recGJL.VALIDATE("Posting Date", "Bank Statement Upload"."Value date");
                    recGJL.VALIDATE("Document Type", recGJL."Document Type"::Payment);
                    recGJL.VALIDATE("External Document No.", COPYSTR("Bank Statement Upload"."UTR No", 1, 30));
                    recGJL.VALIDATE("Account Type", recGJL."Account Type"::Customer);
                    recGJL.VALIDATE("Account No.", "Bank Statement Upload"."Virtual Account Number");
                    recGJL.VALIDATE("Credit Amount", "Bank Statement Upload"."Entry Amount");
                    recGJL.VALIDATE("Bal. Account Type", recGJL."Bal. Account Type"::"G/L Account");
                    recGJL.VALIDATE("Posting No. Series", cdPostNo);
                    recGenTemp.RESET();
                    recGenTemp.SETRANGE(Name, 'BANKRECEI');
                    IF recGenTemp.FINDFIRST THEN BEGIN
                        recGenTemp.TESTFIELD("Shortcut Dimension 1 Code");
                        recGenTemp.TESTFIELD("Shortcut Dimension 2 Code");
                        recGJL.VALIDATE("Shortcut Dimension 1 Code", recGenTemp."Shortcut Dimension 1 Code");
                        recGJL.VALIDATE("Shortcut Dimension 2 Code", recGenTemp."Shortcut Dimension 2 Code");
                    END;
                    recGenBatch.RESET();
                    recGenBatch.SETRANGE("Journal Template Name", 'BANKRECEI');
                    recGenBatch.SETRANGE(Name, 'BANK_INT');
                    IF recGenBatch.FINDFIRST THEN
                        recGJL.VALIDATE("Location Code", recGenBatch."Location Code");
                    recGJL.VALIDATE("Source Code", 'BANKRCPTV');
                    recGJL.INSERT();

                    //Balance Account Line
                    recGJL.RESET();
                    recGJL.INIT();
                    recGJL.VALIDATE("Journal Template Name", 'BANKRECEI');
                    recGJL.VALIDATE("Journal Batch Name", 'BANK_INT');

                    LineNo := 0;
                    recGJL1.RESET();
                    recGJL1.SETRANGE("Journal Template Name", 'BANKRECEI');
                    recGJL1.SETRANGE("Journal Batch Name", 'BANK_INT');
                    IF recGJL1.FINDLAST THEN
                        LineNo := recGJL1."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    recGJL.VALIDATE("Line No.", LineNo);
                    recGJL.VALIDATE("Document No.", DocNo);
                    recGJL.VALIDATE("Document Date", "Bank Statement Upload"."Value date");
                    recGJL.VALIDATE("Posting Date", "Bank Statement Upload"."Value date");
                    recGJL.VALIDATE("Document Type", recGJL."Document Type"::Payment);
                    recGJL.VALIDATE("External Document No.", COPYSTR("Bank Statement Upload"."UTR No", 1, 30));
                    recGJL.VALIDATE("Account Type", recGJL."Account Type"::"Bank Account");
                    recGJL.VALIDATE("Account No.", 'B/CA/00003');
                    recGJL.VALIDATE("Debit Amount", "Bank Statement Upload"."Entry Amount");
                    recGJL.VALIDATE("Bal. Account Type", recGJL."Bal. Account Type"::"G/L Account");
                    recGJL.VALIDATE("Posting No. Series", cdPostNo);
                    recGenTemp.RESET();
                    recGenTemp.SETRANGE(Name, 'BANKRECEI');
                    IF recGenTemp.FINDFIRST THEN BEGIN
                        recGenTemp.TESTFIELD("Shortcut Dimension 1 Code");
                        recGenTemp.TESTFIELD("Shortcut Dimension 2 Code");
                        recGJL.VALIDATE("Shortcut Dimension 1 Code", recGenTemp."Shortcut Dimension 1 Code");
                        recGJL.VALIDATE("Shortcut Dimension 2 Code", recGenTemp."Shortcut Dimension 2 Code");
                    END;
                    recGenBatch.RESET();
                    recGenBatch.SETRANGE("Journal Template Name", 'BANKRECEI');
                    recGenBatch.SETRANGE(Name, 'BANK_INT');
                    IF recGenBatch.FINDFIRST THEN
                        recGJL.VALIDATE("Location Code", recGenBatch."Location Code");

                    //recGJL.VALIDATE("Shortcut Dimension 1 Code",'HR_HO');
                    //recGJL.VALIDATE("Shortcut Dimension 2 Code",'IMCS-HO');
                    recGJL.VALIDATE("Source Code", 'BANKRCPTV');
                    recGJL.INSERT();

                    "Bank Statement Upload".Status := "Bank Statement Upload".Status::Created;
                    "Bank Statement Upload"."Pre Document No." := DocNo;
                    "Bank Statement Upload".MODIFY();

                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        blStatus: Boolean;
        recCust: Record 18;
        txtErrorMessage: Text[250];
        recDefaultDim: Record 352;
        LineNo: Integer;
        recGJL: Record 81;
        recGJB: Record 232;
        NoSeries: Codeunit 396;
        recGJL1: Record 81;
        DocNo: Code[20];
        cdPostNo: Code[20];
        recGenTemp: Record 80;
        recGenBatch: Record 232;
}

