report 50025 "Voucher Printing - Post-ACX"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VoucherPrintingPostACX.rdlc';
    Caption = 'Posted Voucher';

    dataset
    {
        dataitem(DataItem7069; Table17)
        {
            DataItemTableView = SORTING (Document No., Posting Date, Amount)
                                ORDER(Descending);
            RequestFilterFields = "Posting Date", "Document No.";
            column(txtPurchCmmnt; txtPurchCmmnt)
            {
            }
            column(txtSaleComnt; txtSaleComnt)
            {
            }
            column(PreparedBy; "G/L Entry"."User ID")
            {
            }
            column(blnPrintAppEntries; blnPrintAppEntries)
            {
            }
            column(ShowDim; ShowDim)
            {
            }
            column(VoucherSourceDesc; SourceDesc + ' Voucher')
            {
            }
            column(DocumentNo_GLEntry; "Document No.")
            {
            }
            column(PostingDateFormatted; 'Date: ' + FORMAT("Posting Date"))
            {
            }
            column(CompanyInformationAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + '  ' + CompanyInformation.City)
            {
            }
            column(CompanyInformationName; CompanyInformation.Name)
            {
            }
            column(documentdate; FORMAT("G/L Entry"."Document Date"))
            {
            }
            column(CreditAmount_GLEntry; "Credit Amount")
            {
            }
            column(DebitAmount_GLEntry; "Debit Amount")
            {
            }
            column(DimName; DimName)
            {
            }
            column(DrText; DrText)
            {
            }
            column(GLAccName; GLAccName)
            {
            }
            column(CrText; CrText)
            {
            }
            column(DebitAmountTotal; DebitAmountTotal)
            {
            }
            column(CreditAmountTotal; CreditAmountTotal)
            {
            }
            column(ChequeDetail; 'Cheque No: ' + ChequeNo + '  Dated: ' + FORMAT(ChequeDate))
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(ChequeDate; ChequeDate)
            {
            }
            column(RsNumberText1NumberText2; 'Rs. ' + NumberText[1] + ' ' + NumberText[2])
            {
            }
            column(EntryNo_GLEntry; "Entry No.")
            {
            }
            column(PostingDate_GLEntry; "Posting Date")
            {
            }
            column(TransactionNo_GLEntry; "Transaction No.")
            {
            }
            column(VoucherNoCaption; VoucherNoCaptionLbl)
            {
            }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            {
            }
            column(DebitAmountCaption; DebitAmountCaptionLbl)
            {
            }
            column(ParticularsCaption; ParticularsCaptionLbl)
            {
            }
            column(AmountInWordsCaption; AmountInWordsCaptionLbl)
            {
            }
            column(PreparedByCaption; PreparedByCaptionLbl)
            {
            }
            column(CheckedByCaption; CheckedByCaptionLbl)
            {
            }
            column(ApprovedByCaption; ApprovedByCaptionLbl)
            {
            }
            column(ExternalDocumentNo_GLEntry; "G/L Entry"."External Document No.")
            {
            }
            column(Line_Narration; '')
            {
            }
            column(Voucher_Narration; txtNarr)
            {
            }
            dataitem(DataItem1000000017; Table480)
            {
                CalcFields = Dimension Value Name;
                DataItemLink = Dimension Set ID=FIELD(Dimension Set ID);
                DataItemLinkReference = "G/L Entry";
                DataItemTableView = SORTING (Dimension Set ID, Dimension Code)
                                    ORDER(Ascending);
                column(DimensionCode_DimensionSetEntry; "Dimension Set Entry"."Dimension Code")
                {
                }
                column(DimensionValueName_DimensionSetEntry; "Dimension Set Entry"."Dimension Value Name")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PageLoop := PageLoop - 1;

                    LinesPrinted := LinesPrinted + 1;
                end;
            }
            dataitem(LineNarration; Table16548)
            {
                DataItemLink = Transaction No.=FIELD(Transaction No.),
                               Entry No.=FIELD(Entry No.);
                DataItemTableView = SORTING(Entry No.,Transaction No.,Line No.);
                column(Narration_LineNarration;Narration)
                {
                }
                column(PrintLineNarration;PrintLineNarration)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF PrintLineNarration THEN BEGIN
                      PageLoop := PageLoop - 1;
                      LinesPrinted:=LinesPrinted + 1;
                    END;
                end;
            }
            dataitem(Integer2;Table2000000026)
            {
                DataItemTableView = SORTING(Number);
                column(IntegerOccurcesCaption;IntegerOccurcesCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PageLoop:=PageLoop-1;
                end;

                trigger OnPreDataItem()
                begin
                    GLEntry.SETCURRENTKEY("Document No.","Posting Date",Amount);
                    GLEntry.ASCENDING(FALSE);
                    GLEntry.SETRANGE("Posting Date","G/L Entry"."Posting Date");
                    GLEntry.SETRANGE("Document No.","G/L Entry"."Document No.");
                    GLEntry.FINDLAST;
                    IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                      CurrReport.BREAK;

                    SETRANGE(Number,1,PageLoop)
                end;
            }
            dataitem(PostedNarration1;Table16548)
            {
                DataItemLink = Transaction No.=FIELD(Transaction No.);
                DataItemTableView = SORTING(Entry No.,Transaction No.,Line No.);
                column(Narration_PostedNarration1;Narration)
                {
                }
                column(NarrationCaption;NarrationCaptionLbl)
                {
                }

                trigger OnPreDataItem()
                begin
                    GLEntry.SETCURRENTKEY("Document No.","Posting Date",Amount);
                    GLEntry.ASCENDING(FALSE);
                    GLEntry.SETRANGE("Posting Date","G/L Entry"."Posting Date");
                    GLEntry.SETRANGE("Document No.","G/L Entry"."Document No.");
                    GLEntry.FINDLAST;
                    IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                      CurrReport.BREAK;
                end;
            }
            dataitem(DimensionLoop;Table2000000026)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number=FILTER(1..));
                column(DimText;DimText)
                {
                }
                column(Header_DimensionsCaption;Header_DimensionsCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN BEGIN
                      IF NOT DimSetEntry.FINDSET THEN
                        CurrReport.BREAK;
                    END ELSE
                      IF NOT Continue THEN
                        CurrReport.BREAK;
                    
                    CLEAR(DimText);
                    Continue2 := FALSE;
                    REPEAT
                      OldDimText := DimText;
                      IF DimText = '' THEN BEGIN
                         recDimesnionValue.RESET;
                         recDimesnionValue.SETRANGE(recDimesnionValue."Dimension Code",DimSetEntry."Dimension Code");
                         recDimesnionValue.SETRANGE(recDimesnionValue.Code,DimSetEntry."Dimension Value Code");
                         IF recDimesnionValue.FINDFIRST THEN;
                    
                         DimText := STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",recDimesnionValue.Name)
                        //DimText := STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
                       END ELSE BEGIN
                         recDimesnionValue.RESET;
                         recDimesnionValue.SETRANGE(recDimesnionValue."Dimension Code",DimSetEntry."Dimension Code");
                         recDimesnionValue.SETRANGE(recDimesnionValue.Code,DimSetEntry."Dimension Value Code");
                         IF recDimesnionValue.FINDFIRST THEN;
                    
                        DimText :=
                          STRSUBSTNO(
                            '%1; %2 - %3',DimText,DimSetEntry."Dimension Code",recDimesnionValue.Name);
                        /*
                        DimText :=
                          STRSUBSTNO(
                            '%1; %2 - %3',DimText,DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
                            */
                         END;
                      IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                        DimText := OldDimText;
                        Continue2 := TRUE;
                        EXIT;
                      END;
                    UNTIL DimSetEntry.NEXT = 0;

                end;

                trigger OnPreDataItem()
                begin
                    IF NOT ShowDim THEN
                      CurrReport.BREAK;
                    DimSetEntry.SETRANGE("Dimension Set ID","G/L Entry"."Dimension Set ID");
                end;
            }
            dataitem(AppliedEntryLoop;Table2000000026)
            {
                DataItemLinkReference = "G/L Entry";
                DataItemTableView = SORTING(Number);
                MaxIteration = 0;
                PrintOnlyIfDetail = true;
                dataitem(DataItem1000000016;Table25)
                {
                    DataItemLink = Document No.=FIELD(Document No.);
                    DataItemLinkReference = "G/L Entry";
                    dataitem(DataItem1000000005;Table380)
                    {
                        DataItemLink = Vendor Ledger Entry No.=FIELD(Entry No.);
                        DataItemLinkReference = "Vendor Ledger Entry";
                        DataItemTableView = SORTING(Vendor Ledger Entry No.,Posting Date)
                                            WHERE(Unapplied=CONST(No));
                        dataitem(VendorApplication;Table2000000026)
                        {
                            DataItemTableView = SORTING(Number);
                            column(Vendor;decTtlVenapp)
                            {
                            }
                            column(VendApp_DocNo;txtAppDocNo)
                            {
                            }
                            column(VendApp_External_DocNo;txtAppExtnalDocno)
                            {
                            }
                            column(VendApp_Posting_Date;txtAppPostingDate)
                            {
                            }
                            column(VendApp_Org_Amount;decAppAmount)
                            {
                            }
                            column(VendApp_Doc_Date;txtAppDocDate)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                txtAppDocNo       :=  '';
                                txtAppDocNo       :=  '';
                                txtAppPostingDate :=  '';
                                decAppAmount      :=  0.0;

                                IF NOT FirstLine THEN
                                   VendLedgEntryApp.NEXT ;

                                FirstLine := FALSE ;

                                VendLedgEntry2.SETAUTOCALCFIELDS("Original Amt. (LCY)");

                                CASE ScenarioNo OF
                                     1:
                                       BEGIN
                                         IF VendLedgEntry2.GET(VendLedgEntryApp."Vendor Ledger Entry No.") THEN BEGIN
                                            txtAppDocNo       :=  VendLedgEntry2."Document No.";
                                            txtAppExtnalDocno :=  VendLedgEntry2."External Document No.";
                                            txtAppPostingDate :=  FORMAT(VendLedgEntry2."Posting Date");
                                            decAppAmount      :=  VendLedgEntryApp."Amount (LCY)";
                                            decTtlVenapp      :=  1;
                                            recGlEntry.RESET;
                                            recGlEntry.SETRANGE("Document No.",VendLedgEntry2."Document No.");
                                              IF recGlEntry.FINDFIRST THEN
                                                txtAppDocDate :=  FORMAT(recGlEntry."Document Date");
                                         END ;
                                       END ;
                                     2:
                                       BEGIN
                                         IF VendLedgEntry2.GET(VendLedgEntryApp."Applied Vend. Ledger Entry No.") THEN BEGIN
                                            txtAppDocNo       :=  VendLedgEntry2."Document No.";
                                            txtAppExtnalDocno :=  VendLedgEntry2."External Document No.";
                                            txtAppPostingDate :=  FORMAT(VendLedgEntry2."Posting Date");
                                            decAppAmount      :=  VendLedgEntryApp."Amount (LCY)";
                                            decTtlVenapp      :=  1;
                                            recGlEntry.RESET;
                                            recGlEntry.SETRANGE("Document No.",VendLedgEntry2."Document No.");
                                              IF recGlEntry.FINDFIRST THEN
                                                txtAppDocDate :=  FORMAT(recGlEntry."Document Date");
                                         END ;
                                       END ;
                                END ;
                            end;

                            trigger OnPreDataItem()
                            begin
                                VendLedgEntryApp.RESET ;
                                VendLedgEntryApp.SETCURRENTKEY("Document No.", "Document Type", "Posting Date");
                                VendLedgEntryApp.SETRANGE("Document No.", "Detailed Vendor Ledg. Entry"."Document No.") ;
                                VendLedgEntryApp.SETRANGE("Document Type", "Detailed Vendor Ledg. Entry"."Document Type") ;
                                VendLedgEntryApp.SETRANGE("Vendor No.", "Detailed Vendor Ledg. Entry"."Vendor No.") ;
                                VendLedgEntryApp.SETFILTER("Entry Type", '<>%1', VendLedgEntryApp."Entry Type"::"Initial Entry") ;
                                VendLedgEntryApp.SETFILTER("Vendor Ledger Entry No.", '<>%1', "Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.") ;
                                VendLedgEntryApp.SETRANGE(Unapplied, FALSE) ;
                                IF VendLedgEntryApp.FIND('-') THEN BEGIN
                                   ScenarioNo := 1 ;
                                END ELSE BEGIN
                                   VendLedgEntryApp.RESET ;
                                   VendLedgEntryApp.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
                                   VendLedgEntryApp.SETFILTER("Entry Type", '<>%1', VendLedgEntryApp."Entry Type"::"Initial Entry") ;
                                   VendLedgEntryApp.SETRANGE("Vendor Ledger Entry No.", "Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.") ;
                                   VendLedgEntryApp.SETRANGE(Unapplied, FALSE) ;
                                   IF VendLedgEntryApp.FIND('-') THEN BEGIN
                                    ScenarioNo := 2 ;
                                   END ;
                                   //ScenarioNo := 2 ;
                                END ;

                                IF VendLedgEntryApp.COUNT < 1 THEN BEGIN
                                  CurrReport.BREAK;
                                END;

                                SETRANGE(Number,1,VendLedgEntryApp.COUNT) ;

                                FirstLine := TRUE ;
                            end;
                        }
                    }
                }
                dataitem(DataItem1000000026;Table21)
                {
                    DataItemLink = Document No.=FIELD(Document No.);
                    DataItemLinkReference = "G/L Entry";
                    dataitem(DataItem1000000025;Table379)
                    {
                        DataItemLink = Cust. Ledger Entry No.=FIELD(Entry No.);
                        DataItemLinkReference = "Cust. Ledger Entry";
                        DataItemTableView = SORTING(Cust. Ledger Entry No.,Posting Date)
                                            WHERE(Unapplied=CONST(No));
                        dataitem(CustomerApplication;Table2000000026)
                        {
                            DataItemTableView = SORTING(Number);
                            column(Cust;decTtlCustapp)
                            {
                            }
                            column(CustApp_DocNo;txtAppDocNo)
                            {
                            }
                            column(CustApp_External_DocNo;txtAppExtnalDocno)
                            {
                            }
                            column(CustApp_Posting_Date;txtAppPostingDate)
                            {
                            }
                            column(CustApp_Org_Amount;decAppAmount)
                            {
                            }
                            column(CustApp_Doc_Date;txtAppDocDate)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                txtAppDocNo       :=  '';
                                txtAppDocNo       :=  '';
                                txtAppPostingDate :=  '';
                                decAppAmount      :=  0;

                                IF NOT FirstLine THEN
                                   CustLedgEntryApp.NEXT ;

                                FirstLine := FALSE ;

                                CustLedgEntry2.SETAUTOCALCFIELDS("Original Amt. (LCY)");

                                CASE ScenarioNo OF
                                     1:
                                       BEGIN
                                         IF CustLedgEntry2.GET(CustLedgEntryApp."Cust. Ledger Entry No.") THEN BEGIN
                                            txtAppDocNo       :=  CustLedgEntry2."Document No.";
                                            txtAppExtnalDocno :=  CustLedgEntry2."External Document No.";
                                            txtAppPostingDate :=  FORMAT(CustLedgEntry2."Posting Date");
                                            decAppAmount      :=  CustLedgEntryApp."Amount (LCY)";
                                            decTtlCustapp     :=  1;
                                            recGlEntry.RESET;
                                            recGlEntry.SETRANGE("Document No.",CustLedgEntry2."Document No.");
                                              IF recGlEntry.FINDFIRST THEN
                                                txtAppDocDate :=  FORMAT(recGlEntry."Document Date");

                                         END ;
                                       END ;
                                     2:
                                       BEGIN
                                         IF CustLedgEntry2.GET(CustLedgEntryApp."Applied Cust. Ledger Entry No.") THEN BEGIN
                                            txtAppDocNo       :=  CustLedgEntry2."Document No.";
                                            txtAppExtnalDocno :=  CustLedgEntry2."External Document No.";
                                            txtAppPostingDate :=  FORMAT(CustLedgEntry2."Posting Date");
                                            decAppAmount      :=  CustLedgEntryApp."Amount (LCY)";
                                            decTtlCustapp     :=  1;
                                            recGlEntry.RESET;
                                            recGlEntry.SETRANGE("Document No.",CustLedgEntry2."Document No.");
                                              IF recGlEntry.FINDFIRST THEN
                                                txtAppDocDate :=  FORMAT(recGlEntry."Document Date");

                                         END ;
                                       END ;
                                END ;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CustLedgEntryApp.RESET ;
                                CustLedgEntryApp.SETCURRENTKEY("Document No.", "Document Type", "Posting Date");
                                CustLedgEntryApp.SETRANGE("Document No.", "Detailed Cust. Ledg. Entry"."Document No.") ;
                                CustLedgEntryApp.SETRANGE("Document Type", "Detailed Cust. Ledg. Entry"."Document Type") ;
                                CustLedgEntryApp.SETRANGE("Customer No.", "Detailed Cust. Ledg. Entry"."Customer No.") ;
                                CustLedgEntryApp.SETFILTER("Entry Type", '<>%1', CustLedgEntryApp."Entry Type"::"Initial Entry") ;
                                CustLedgEntryApp.SETFILTER("Cust. Ledger Entry No.", '<>%1', "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.") ;
                                CustLedgEntryApp.SETRANGE(Unapplied, FALSE) ;
                                IF CustLedgEntryApp.FIND('-') THEN BEGIN
                                   ScenarioNo := 1 ;
                                END ELSE BEGIN
                                   CustLedgEntryApp.RESET ;
                                   CustLedgEntryApp.SETCURRENTKEY("Cust. Ledger Entry No.", "Posting Date");
                                   CustLedgEntryApp.SETFILTER("Entry Type", '<>%1', CustLedgEntryApp."Entry Type"::"Initial Entry") ;
                                   CustLedgEntryApp.SETRANGE("Cust. Ledger Entry No.", "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.") ;
                                   CustLedgEntryApp.SETRANGE(Unapplied, FALSE) ;
                                   IF CustLedgEntryApp.FIND('-') THEN BEGIN
                                    ScenarioNo := 2 ;
                                   END ;
                                   //ScenarioNo := 2 ;
                                END ;

                                IF CustLedgEntryApp.COUNT < 1 THEN BEGIN
                                  CurrReport.BREAK;
                                END;

                                SETRANGE(Number,1,CustLedgEntryApp.COUNT) ;


                                FirstLine := TRUE ;
                            end;
                        }
                    }
                }

                trigger OnPreDataItem()
                begin
                    GLEntry.SETCURRENTKEY("Document No.","Posting Date",Amount);
                    GLEntry.ASCENDING(FALSE);
                    GLEntry.SETRANGE("Posting Date","G/L Entry"."Posting Date");
                    GLEntry.SETRANGE("Document No.","G/L Entry"."Document No.");
                    GLEntry.FINDLAST;
                    IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                      CurrReport.BREAK;
                    SETRANGE(Number,1,1);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                decTtlVenapp  :=  0;
                decTtlCustapp :=  0;
                
                GLAccName := FindGLAccName("Source Type","Entry No.","Source No.","G/L Account No.");
                IF Amount < 0 THEN BEGIN
                  CrText := 'To';
                  DrText := '';
                END ELSE BEGIN
                  CrText := '';
                  DrText := 'Dr';
                END;
                /*
                SourceDesc := '';
                IF "Source Code" <> '' THEN BEGIN
                  SourceCode.GET("Source Code");
                  SourceDesc := SourceCode.Description;
                END;
                */
                PageLoop := PageLoop - 1;
                LinesPrinted := LinesPrinted + 1;
                
                ChequeNo := '';
                ChequeDate := 0D;
                IF ("Source No." <> '') AND ("Source Type"="Source Type"::"Bank Account") THEN BEGIN
                  IF BankAccLedgEntry.GET("Entry No.") THEN BEGIN
                    ChequeNo := BankAccLedgEntry."Cheque No.";
                    ChequeDate := BankAccLedgEntry."Cheque Date";
                  END;
                END;
                
                IF (ChequeNo <> '') AND (ChequeDate <> 0D) THEN BEGIN
                    PageLoop := PageLoop - 1;
                  LinesPrinted := LinesPrinted + 1;
                  END;
                IF PostingDate <> "Posting Date" THEN BEGIN
                  PostingDate := "Posting Date";
                  TotalDebitAmt := 0;
                END;
                IF DocumentNo <> "Document No." THEN BEGIN
                  DocumentNo := "Document No.";
                  TotalDebitAmt := 0;
                
                //YSR BEGIN
                txtPurchCmmnt :=  '';
                PurchCommnt.RESET;
                PurchCommnt.SETRANGE("Document Type",PurchCommnt."Document Type"::"Posted Invoice");
                PurchCommnt.SETRANGE("No.",DocumentNo);
                  IF PurchCommnt.FINDSET THEN REPEAT
                    txtPurchCmmnt +=  ' ' + PurchCommnt.Comment;
                  UNTIL PurchCommnt.NEXT=0;
                //YSR END
                
                //YSR BEGIN
                
                PurchCommnt.RESET;
                PurchCommnt.SETRANGE("Document Type",PurchCommnt."Document Type"::"Posted Credit Memo");
                PurchCommnt.SETRANGE("No.",DocumentNo);
                  IF PurchCommnt.FINDSET THEN REPEAT
                    txtPurchCmmnt +=  ' ' + PurchCommnt.Comment;
                  UNTIL PurchCommnt.NEXT=0;
                //YSR END
                END;
                
                //acxcp begin
                txtSaleComnt:='';
                recSalesComnt.RESET;
                recSalesComnt.SETRANGE("Document Type",recSalesComnt."Document Type"::"Posted Invoice");
                recSalesComnt.SETRANGE("No.",DocumentNo);
                  IF recSalesComnt.FINDSET THEN REPEAT
                    txtSaleComnt +=  ' ' + recSalesComnt.Comment;
                  UNTIL recSalesComnt.NEXT=0;
                
                
                //txtSaleComnt:='';
                recSalesComnt.RESET;
                recSalesComnt.SETRANGE("Document Type",recSalesComnt."Document Type"::"Posted Credit Memo");
                recSalesComnt.SETRANGE("No.",DocumentNo);
                  IF recSalesComnt.FINDSET THEN REPEAT
                    txtSaleComnt +=  ' ' + recSalesComnt.Comment;
                  UNTIL recSalesComnt.NEXT=0;
                
                //END;
                //acxcp end //150721 posted sales credit memo comments
                
                
                
                //YSR BEGIN
                DimName := '';
                LedgerDim.RESET;
                LedgerDim.SETRANGE("Dimension Set ID","G/L Entry"."Dimension Set ID");
                LedgerDim.SETAUTOCALCFIELDS("Dimension Value Name");
                  IF LedgerDim.FINDSET THEN REPEAT
                    DimName += ' '+ LedgerDim."Dimension Value Name";
                  UNTIL LedgerDim.NEXT = 0;
                
                
                /*
                strDimension := '';
                rsDimension.RESET;
                rsDimensionValue.RESET;
                rsDimension.SETFILTER(rsDimension.Code,"Dimension Code");
                IF rsDimension.FIND('-') THEN BEGIN
                   rsDimensionValue.SETFILTER(rsDimensionValue."Dimension Code", "Dimension Code") ;
                   rsDimensionValue.SETFILTER(rsDimensionValue.Code,"Dimension Value Code");
                   rsDimensionValue.FIND('-');
                   strDimension := rsDimension.Name + ' : ' ;
                      strDimension := strDimension + rsDimensionValue.Name;
                END;
                 */
                //YSR END
                
                IF PostingDate = "Posting Date" THEN BEGIN
                  InitTextVariable;
                  TotalDebitAmt += "Debit Amount";
                  FormatNoText(NumberText,ABS(TotalDebitAmt),'');
                  PageLoop := NUMLines;
                  LinesPrinted := 0;
                END;
                IF (PrePostingDate <> "Posting Date") OR (PreDocumentNo <> "Document No.") THEN BEGIN
                  DebitAmountTotal := 0;
                  CreditAmountTotal := 0;
                  PrePostingDate := "Posting Date";
                  PreDocumentNo := "Document No.";
                END;
                
                DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                CreditAmountTotal := CreditAmountTotal + "Credit Amount";
                
                /*
                txtNarr:='';
                recPostedNarr.RESET;
                recPostedNarr.SETRANGE("Document No.","G/L Entry"."Document No.");
                IF recPostedNarr.FIND('-') THEN
                   REPEAT
                   txtNarr+=recPostedNarr.Narration
                   UNTIL recPostedNarr.NEXT=0;
                   */
                
                txtNarr := '';
                recPostedNarr.RESET();
                recPostedNarr.SETRANGE("Document No.","G/L Entry"."Document No.");
                recPostedNarr.SETRANGE("Transaction No.","Transaction No.");
                IF recPostedNarr.FIND('-') THEN
                REPEAT
                txtNarr += recPostedNarr.Narration
                UNTIL
                recPostedNarr.NEXT=0;

            end;

            trigger OnPreDataItem()
            begin
                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
                txtNarr:='';
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintLineNarration;PrintLineNarration)
                    {
                        Caption = 'PrintLineNarration';
                    }
                    field(ShowDimensions;ShowDim)
                    {
                        Caption = 'Show Dimensions';
                    }
                    field(blnPrintAppEntries;blnPrintAppEntries)
                    {
                        Caption = 'Show Applied Entries';
                    }
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

    trigger OnInitReport()
    begin
        ShowDim :=  TRUE;
        PrintLineNarration  :=  TRUE;
        blnPrintAppEntries := TRUE;
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
    end;

    var
        CompanyInformation: Record "79";
        SourceCode: Record "230";
        GLEntry: Record "17";
        BankAccLedgEntry: Record "271";
        GLAccName: Text[100];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: array [2] of Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[50];
        ChequeDate: Date;
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
        OnesText: array [20] of Text[30];
        TensText: array [10] of Text[30];
        ExponentText: array [5] of Text[30];
        PrintLineNarration: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrePostingDate: Date;
        PreDocumentNo: Code[50];
        VoucherNoCaptionLbl: Label 'Voucher No. :';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        ParticularsCaptionLbl: Label 'Particulars';
        AmountInWordsCaptionLbl: Label 'Amount (in words):';
        PreparedByCaptionLbl: Label 'Prepared by:';
        CheckedByCaptionLbl: Label 'Checked by:';
        ApprovedByCaptionLbl: Label 'Approved by:';
        IntegerOccurcesCaptionLbl: Label 'IntegerOccurces';
        NarrationCaptionLbl: Label 'Narration :';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        Number1: Integer;
        BlnPrintDetailVendorLedger: Boolean;
        Number2: Integer;
        BlnPrintDetailCustLedger: Boolean;
        blnPrintAppEntries: Boolean;
        ShowDim: Boolean;
        DimSetEntry: Record "480";
        Continue: Boolean;
        DimText: Text[250];
        OldDimText: Text[250];
        Continue2: Boolean;
        recDimesnionValue: Record "349";
        "--ysr begin": Integer;
        VendLedgEntryApp: Record "380";
        VendLedgEntry2: Record "25";
        FirstLine: Boolean;
        ScenarioNo: Integer;
        CustLedgEntryApp: Record "379";
        CustLedgEntry2: Record "21";
        txtAppDocNo: Text;
        txtAppPostingDate: Text;
        txtAppExtnalDocno: Text;
        decAppAmount: Decimal;
        txtAppDocDate: Text;
        DimVal: Record "349";
        DimName: Text[250];
        LedgerDim: Record "480";
        PurchCommnt: Record "43";
        txtPurchCmmnt: Text;
        decTtlVenapp: Decimal;
        decTtlCustapp: Decimal;
        recGlEntry: Record "17";
        "--ysr End": Integer;
        recPostedNarr: Record "16548";
        txtNarr: Text[500];
        txtSaleComnt: Text;
        recSalesComnt: Record "44";

    [Scope('Internal')]
    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset";"Entry No.": Integer;"Source No.": Code[20];"G/L Account No.": Code[20]): Text[60]
    var
        AccName: Text[60];
        VendLedgerEntry: Record "25";
        Vend: Record "23";
        CustLedgerEntry: Record "21";
        Cust: Record "18";
        BankLedgerEntry: Record "271";
        Bank: Record "270";
        FALedgerEntry: Record "5601";
        FA: Record "5600";
        GLAccount: Record "15";
    begin
        IF "Source Type" = "Source Type"::Vendor THEN
          //IF VendLedgerEntry.GET("Entry No.") THEN BEGIN
          IF FoundinVPG("G/L Account No.") THEN BEGIN
            Vend.GET("Source No.");
            AccName := Vend."No." + ' ' + '-' + ' ' + Vend.Name;
          END ELSE BEGIN
            GLAccount.GET("G/L Account No.");
            AccName :=  GLAccount."No." + ' ' + '-' + ' ' + GLAccount.Name;
          END
        ELSE IF "Source Type" = "Source Type"::Customer THEN
          //IF CustLedgerEntry.GET("Entry No.") THEN BEGIN
          IF FoundinCPG("G/L Account No.") THEN BEGIN
            Cust.GET("Source No.");
            AccName :=  Cust."No." + ' ' + '-' + ' ' + Cust.Name;
          END ELSE BEGIN
            GLAccount.GET("G/L Account No.");
            AccName := GLAccount."No." + ' ' + '-' + ' ' + GLAccount.Name;
          END
        ELSE IF "Source Type" = "Source Type"::"Bank Account" THEN
          IF BankLedgerEntry.GET("Entry No.") THEN BEGIN
            Bank.GET("Source No.");
            AccName :=  Bank."No." + ' ' + '-' + ' ' + Bank.Name;
          END ELSE BEGIN
            GLAccount.GET("G/L Account No.");
            AccName := GLAccount."No." + ' ' + '-' + ' ' + GLAccount.Name;
          END
        ELSE BEGIN
          GLAccount.GET("G/L Account No.");
          AccName := GLAccount."No." + ' ' + '-' + ' ' + GLAccount.Name;
        END;

        IF "Source Type" = "Source Type"::" " THEN BEGIN
          GLAccount.GET("G/L Account No.");
          AccName := GLAccount."No." + ' ' + '-' + ' ' + GLAccount.Name;
        END;

        EXIT(AccName);
    end;

    [Scope('Internal')]
    procedure FormatNoText(var NoText: array [2] of Text[80];No: Decimal;CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record "4";
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526)
        ELSE BEGIN
          FOR Exponent := 4 DOWNTO 1 DO BEGIN
            PrintExponent := FALSE;
            IF No > 99999 THEN BEGIN
              Ones := No DIV (POWER(100,Exponent - 1) * 10);
              Hundreds := 0;
            END ELSE BEGIN
              Ones := No DIV POWER(1000,Exponent - 1);
              Hundreds := Ones DIV 100;
            END;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            IF Hundreds > 0 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text16527);
            END;
            IF Tens >= 2 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              IF Ones > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            END ELSE
              IF (Tens * 10 + Ones) > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            IF PrintExponent AND (Exponent > 1) THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            IF No > 99999 THEN
              No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100,Exponent - 1) * 10
            ELSE
              No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
          END;
        END;

        IF CurrencyCode <> '' THEN BEGIN
          Currency.GET(CurrencyCode);
          AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + Currency."Currency Numeric Description");
        END ELSE
          AddToNoText(NoText,NoTextIndex,PrintExponent,'RUPEES');

        AddToNoText(NoText,NoTextIndex,PrintExponent,Text16528);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
          AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[TensDec]);
          IF OnesDec > 0 THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[OnesDec]);
        END ELSE
          IF (TensDec * 10 + OnesDec) > 0 THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[TensDec * 10 + OnesDec])
          ELSE
            AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526);
        IF (CurrencyCode <> '') THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + Currency."Currency Decimal Description" + ' ONLY')
        ELSE
          AddToNoText(NoText,NoTextIndex,PrintExponent,' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array [2] of Text[80];var NoTextIndex: Integer;var PrintExponent: Boolean;AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
          NoTextIndex := NoTextIndex + 1;
          IF NoTextIndex > ARRAYLEN(NoText) THEN
            ERROR(Text16529,AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText,'<');
    end;

    [Scope('Internal')]
    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;

    local procedure FoundinVPG(gl: Code[20]): Boolean
    var
        VPG: Record "93";
        cpg: Record "92";
    begin
        VPG.RESET;
        VPG.SETRANGE("Payables Account", gl);
        EXIT(VPG.FINDFIRST);
    end;

    local procedure FoundinCPG(gl: Code[20]): Boolean
    var
        VPG: Record "93";
        cpg: Record "92";
    begin
        cpg.RESET;
        cpg.SETRANGE("Receivables Account", gl);
        EXIT(cpg.FINDFIRST);
    end;
}

