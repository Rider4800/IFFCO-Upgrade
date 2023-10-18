report 50023 "CD Voucher Creation"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1000000000; Table50020)
        {
            DataItemTableView = WHERE (Credit Note No.=FILTER(''),
                                      Posted Credit Note ID=FILTER(''),
                                      Posted Credit Note Date=FILTER(''),
                                      CD to be Given=FILTER(>0));
            RequestFilterFields = "Customer No.","Invoice No.",Date;

            trigger OnAfterGetRecord()
            begin
                recGJL.RESET();
                recGJL.INIT();
                recGJL.VALIDATE("Journal Template Name",'SCHEME');
                recGJL.VALIDATE("Journal Batch Name",'SCHE.');

                LineNo:=0;
                recGJL1.RESET();
                recGJL1.SETRANGE("Journal Template Name",'SCHEME');
                recGJL1.SETRANGE("Journal Batch Name",'SCHE.');
                IF recGJL1.FINDLAST THEN BEGIN
                  LineNo:= recGJL1."Line No."+10000;
                  DocNo := recGJL1."Document No.";
                END ELSE BEGIN
                  LineNo:= 10000;
                END;
                recGJL.VALIDATE("Line No.",LineNo);
                cdPostNo:='';
                recGJB.RESET();
                recGJB.SETRANGE("Journal Template Name",'SCHEME');
                recGJB.SETRANGE(Name,'SCHE.');
                IF recGJB.FIND('-') THEN BEGIN
                  //Update Last Doc No.
                  recNoSerLine.RESET();
                  recNoSerLine.SETRANGE("Series Code",recGJB."No. Series");
                  IF (recNoSerLine.FINDFIRST) AND (DocNo<>'') THEN BEGIN
                    recNoSerLine."Last No. Used" := DocNo;
                    recNoSerLine."Last Date Used" := WORKDATE;
                    recNoSerLine.MODIFY();
                  END;
                  IF "LastDocNo." = '' THEN BEGIN
                    "LastDocNo." := recNoSerLine."Last No. Used";
                    LastDocDate:= recNoSerLine."Last Date Used";
                  END;
                  DocNo := NoSeries.GetNextNo(recGJB."No. Series",WORKDATE,FALSE);
                  cdPostNo := recGJB."Posting No. Series";
                END;
                  recGJL.VALIDATE("Document No.",DocNo);
                  recGJL.VALIDATE("Document Date","ACX Calculated CD Summary".Date);
                  recGJL.VALIDATE("Posting Date","ACX Calculated CD Summary".Date);
                  recGJL.VALIDATE("Document Type",recGJL."Document Type"::" ");
                  recGJL.VALIDATE("External Document No.","ACX Calculated CD Summary"."Invoice No.");
                  recGJL.VALIDATE("Account Type",recGJL."Account Type"::Customer);
                  recGJL.VALIDATE("Account No.","ACX Calculated CD Summary"."Customer No.");
                  recGJL.VALIDATE("Account No.");
                  recGJL.VALIDATE("Credit Amount","ACX Calculated CD Summary"."CD to be Given");
                  recGJL.VALIDATE("Bal. Account Type",recGJL."Bal. Account Type"::"G/L Account");
                  recScheeGL.RESET();
                  recScheeGL.SETRANGE("Customer Posting Group","ACX Calculated CD Summary"."Customer Posting Group");
                  IF recScheeGL.FINDFIRST THEN
                    recGJL.VALIDATE("Bal. Account No.",recScheeGL."G/L Account");
                  recGJL.VALIDATE("Posting No. Series",cdPostNo);
                  recGJL.VALIDATE("Source Code",'JOURNALV');
                  recGJL."Cal. Scheme Line No." := "ACX Calculated CD Summary"."Line No.";
                  recGJL.VALIDATE("Shortcut Dimension 1 Code","ACX Calculated CD Summary"."State Code");
                  recGJL.VALIDATE("Shortcut Dimension 2 Code","ACX Calculated CD Summary"."Warehouse code");
                  recGJL.VALIDATE("Finance Branch A/c Code",'HR_HO');
                  recGJL.INSERT(TRUE);
                 //Update Last Doc No.
                  recNoSerLine.RESET();
                  recNoSerLine.SETRANGE("Series Code",recGJB."No. Series");
                  IF recNoSerLine.FINDFIRST THEN BEGIN
                    recNoSerLine."Last No. Used" := "LastDocNo.";
                    recNoSerLine."Last Date Used" := LastDocDate;
                    recNoSerLine.MODIFY();
                  END;
                UpdateJVPark(recGJL."Cal. Scheme Line No.",recGJL."Document No.");
            end;

            trigger OnPreDataItem()
            begin
                DocNo :='';
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

    trigger OnPreReport()
    begin
        "LastDocNo.":='';
        LastDocDate:=0D;
        DocNo:='';
    end;

    var
        recGJL: Record "81";
        LineNo: Integer;
        recGJL1: Record "81";
        DocNo: Code[20];
        cdPostNo: Code[20];
        recGJB: Record "232";
        NoSeries: Codeunit "396";
        recScheeGL: Record "50021";
        "LastDocNo.": Code[20];
        recNoSerLine: Record "309";
        LastDocDate: Date;

    local procedure UpdateJVPark("LineNo.": Integer;CNNo: Code[20])
    var
        recCalCD: Record "50020";
    begin
        recCalCD.RESET();
        recCalCD.SETRANGE("Line No.","LineNo.");
        IF recCalCD.FINDFIRST THEN BEGIN
          recCalCD."Credit Note No." := CNNo;
          recCalCD.MODIFY();
        END;
    end;
}

