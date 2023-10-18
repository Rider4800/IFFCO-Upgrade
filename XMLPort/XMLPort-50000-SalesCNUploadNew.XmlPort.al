xmlport 50000 SalesCNUpload_New
{
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF16;

    schema
    {
        textelement(SalesCNUploader)
        {
            tableelement("Sales Line"; "Sales Line")
            {
                AutoSave = false;
                XmlName = 'SalesCNLine';
                SourceTableView = WHERE("Document Type" = FILTER(3));
                textelement(externalDoc)
                {
                }
                textelement(DocType)
                {
                }
                textelement(DocNo)
                {
                }
                textelement(SellToCustomerNo)
                {
                    MinOccurs = Once;
                }
                textelement(BillToCustNo)
                {
                }
                textelement(ShipToCode)
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(DocumentDate)
                {
                }
                textelement(Structure)
                {
                }
                textelement(SalesPersonCode)
                {
                }
                textelement(LocationCode)
                {
                }
                textelement(StateCode)
                {
                    MinOccurs = Zero;
                }
                textelement(GD1)
                {
                }
                textelement(GD2)
                {
                }
                textelement(FAHQ)
                {
                }
                textelement(FO)
                {
                }
                textelement(RME)
                {
                }
                textelement(TMEHQ)
                {
                }
                textelement(FA)
                {
                }
                textelement(TME)
                {
                }
                textelement(ZMM)
                {
                }
                textelement(LineNo)
                {
                }
                textelement(Type)
                {
                    MinOccurs = Zero;
                }
                textelement(Number)
                {
                }
                textelement(Description)
                {
                }
                textelement(Description2)
                {
                }
                textelement(Qty)
                {
                }
                textelement(UOMCode)
                {
                }
                textelement(UnitPriceExclTax)
                {
                    MinOccurs = Zero;
                }
                textelement(Amount)
                {
                }
                textelement(GPPG)
                {
                    MinOccurs = Zero;
                }
                textelement(GSTGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(HSNCode)
                {
                    MinOccurs = Zero;
                }
                textelement(SaleComment)
                {
                }
                textelement(SaleCommentLineNo)
                {
                }
                textelement(SaleCommentDate)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    IF recSalesHeader."No." <> DocNo THEN BEGIN

                        //IF ExternalDocNo<>externalDoc THEN BEGIN
                        EVALUATE(PostingDat, FORMAT(PostingDate));
                        IF SSS.FINDLAST THEN BEGIN
                            documentNO := Noseries.GetNextNo(SSS."Credit Memo Nos.", PostingDat, TRUE);
                        END;
                        IntlineNo := 10000;
                        recSalesHeader.RESET();
                        recSalesHeader.INIT();
                        recSalesHeader.VALIDATE("Document Type", recSalesHeader."Document Type"::"Credit Memo");
                        recSalesHeader."No." := documentNO;
                        PostingDat := 0D;
                        EVALUATE(PostingDat, FORMAT(PostingDate));
                        recSalesHeader.VALIDATE("Posting Date", PostingDat);

                        DocDate := 0D;
                        EVALUATE(DocDate, FORMAT(DocumentDate));
                        recSalesHeader.VALIDATE("Document Date", DocDate);

                        recSalesHeader.VALIDATE("Sell-to Customer No.", SellToCustomerNo);
                        recSalesHeader.VALIDATE("External Document No.", externalDoc);
                        //16767  recSalesHeader.VALIDATE(Structure, 'GST'); Structure filed not found
                        recSalesHeader.VALIDATE("Location Code", LocationCode);
                        recSalesHeader.VALIDATE("Salesperson Code", SalesPersonCode);
                        recSalesHeader.VALIDATE(State, StateCode);

                        DimSetId := GetDimensions1(GD1, GD2, FAHQ, FO, RME, TMEHQ, FA, TME, ZMM);//ACXLK
                        recSalesHeader.VALIDATE("Dimension Set ID", DimSetId);
                        recSalesHeader.VALIDATE("Branch Accounting", TRUE);
                        /*
                         EVALUATE(recSalesHeader."Shortcut Dimension 1 Code",GD1);
                         recSalesHeader.VALIDATE("Shortcut Dimension 1 Code",GD1);
                         EVALUATE(recSalesHeader."Shortcut Dimension 2 Code",GD2);
                         recSalesHeader.VALIDATE("Shortcut Dimension 2 Code",GD2);
                         recSalesHeader.VALIDATE("Dimension Set ID",GetDimensions(GD1,GD2,'',''));
                         */
                        recSalesHeader.INSERT;

                        recSalesCommentLine.VALIDATE("Document Type", recSalesLine."Document Type"::"Credit Memo");
                        recSalesCommentLine.VALIDATE(Date, PostingDat);
                        recSalesCommentLine.VALIDATE("No.", documentNO);
                        recSalesCommentLine.VALIDATE("Line No.", IntlineNo);//0812
                        recSalesCommentLine.VALIDATE(Comment, SaleComment);
                        // SalcmtDate:=0D;
                        //EVALUATE(SalcmtDate,FORMAT(SaleCommentDate));
                        //recSalesCommentLine.VALIDATE(Date,SalcmtDate);
                        /*
                        SalcmtLineNo:=0;
                        EVALUATE(SalcmtLineNo,FORMAT(SaleCommentLineNo));//0812
                        recSalesCommentLine.VALIDATE("Line No.",SalcmtLineNo);//0812
                        */
                        recSalesCommentLine.INSERT;
                        //  recSalesLine.RESET();
                        recSalesLine.INIT();
                    END;

                    recSalesLine.VALIDATE("Document Type", recSalesLine."Document Type"::"Credit Memo");
                    recSalesLine.VALIDATE("Document No.", documentNO);
                    recSalesLine.VALIDATE("Line No.", IntlineNo);
                    EVALUATE(recSalesLine.Type, Type);
                    recSalesLine.VALIDATE("No.", Number);
                    recSalesLine.VALIDATE("Description 2", Description2);
                    EVALUATE(recSalesLine.Quantity, Qty);
                    recSalesLine.VALIDATE("Unit of Measure Code", UOMCode);
                    EVALUATE(recSalesLine."Unit Price", UnitPriceExclTax);
                    EVALUATE(recSalesLine."Line Amount", Amount);

                    IF GSTGroup <> '' THEN
                        recSalesLine.VALIDATE("GST Group Code", GSTGroup);
                    IF HSNCode <> '' THEN
                        recSalesLine.VALIDATE("HSN/SAC Code", HSNCode);

                    DimSetId := GetDimensions1(GD1, GD2, FAHQ, FO, RME, TMEHQ, FA, TME, ZMM);
                    recSalesLine.VALIDATE("Dimension Set ID", DimSetId);

                    recSalesLine.INSERT;
                    //acxcp_19112021 + //comment insert for uploader
                    /*
                    recSalesCommentLine.VALIDATE("Document Type",recSalesLine."Document Type"::"Credit Memo");
                    recSalesCommentLine.VALIDATE(Date,PostingDat);
                    recSalesCommentLine.VALIDATE("No.",documentNO);
                    recSalesCommentLine.VALIDATE("Line No.",IntlineNo);//0812
                    recSalesCommentLine.VALIDATE(Comment,SaleComment);
                   // SalcmtDate:=0D;
                    //EVALUATE(SalcmtDate,FORMAT(SaleCommentDate));
                    //recSalesCommentLine.VALIDATE(Date,SalcmtDate);
                    {
                    SalcmtLineNo:=0;
                    EVALUATE(SalcmtLineNo,FORMAT(SaleCommentLineNo));//0812
                    recSalesCommentLine.VALIDATE("Line No.",SalcmtLineNo);//0812
                    }
                    recSalesCommentLine.INSERT;
                    */
                    //    END;

                    //acxcp_19112021 -
                    IntlineNo := IntlineNo + 10000;

                    recSalesHeader."No." := DocNo;
                    // ExternalDocNo:=externalDoc;

                end;
            }
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

    trigger OnPostXmlPort()
    begin
        MESSAGE('Sales Credit Memo Created Successfully');
    end;

    var
        recSalesHeader: Record 36;
        recSalesLine: Record 37;
        documentNO: Code[40];
        Noseries: Codeunit 396;
        invoiceNO: Code[40];
        DocNumber: Code[20];
        SSS: Record 311;
        IntlineNo: Integer;
        DecQty: Decimal;
        DecPrice: Decimal;
        ExternalDocNo: Code[40];
        CustDutyAmt: Decimal;
        GstAssVlu: Decimal;
        DimSetId: Integer;
        RecGlSEtup: Record 98;
        recCurrency: Record 4;
        recExchCurrRate: Record 330;
        PostingDat: Date;
        CustmDuty: Decimal;
        reccommentline: Record 43;
        DocDate: Date;
        recSalesCommentLine: Record 44;
        SalcmtDate: Date;
        SalcmtLineNo: Integer;

    local procedure GetDimensions(Dim1: Code[20]; DIm2: Code[20]; Dim3: Code[20]; Dim4: Code[20]) DimensionSetId1: Integer
    var
        DimensionBuffer: Record 360;
        cuDimensionBufferManagement: Codeunit 411;
        cuDimMangmnt: Codeunit 408;
        DimSetid: Integer;
        TempDimSetEntry: Record 480 temporary;
        DimValue: Record 349;
        RecDefautDim: Record 352;
    begin
        TempDimSetEntry.RESET();
        //IF Dim1<>'' THEN BEGIN
        RecGlSEtup.GET();
        IF Dim1 <> '' THEN BEGIN

            TempDimSetEntry.VALIDATE("Dimension Code", RecGlSEtup."Shortcut Dimension 1 Code");
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim1);
            TempDimSetEntry.INSERT();
        END;

        IF DIm2 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", RecGlSEtup."Shortcut Dimension 2 Code");
            TempDimSetEntry.VALIDATE("Dimension Value Code", DIm2);
            TempDimSetEntry.INSERT();
        END;

        IF Dim3 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", RecGlSEtup."Shortcut Dimension 3 Code");
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim3);
            TempDimSetEntry.INSERT();
        END;

        IF Dim4 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", RecGlSEtup."Shortcut Dimension 4 Code");
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim4);
            TempDimSetEntry.INSERT();
        END;

        //END;
        //DimensionSetID:=
        EXIT(cuDimMangmnt.GetDimensionSetID(TempDimSetEntry));
    end;

    local procedure GetDimensions1(Dim11: Code[20]; Dim22: Code[20]; Dim33: Code[20]; Dim44: Code[20]; Dim55: Code[20]; Dim66: Code[20]; DIm77: Code[20]; Dim88: Code[20]; Dim99: Code[99]) DimensionSetID1: Integer
    var
        DimensionBuffer: Record 360;
        cuDimensionBufferManagement: Codeunit 411;
        cuDimMangmnt: Codeunit 408;
        DimSetid: Integer;
        TempDimSetEntry: Record 480 temporary;
        DimValue: Record 349;
        RecDefautDim: Record 352;
    begin
        TempDimSetEntry.RESET;
        RecGlSEtup.GET();
        IF Dim11 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", RecGlSEtup."Shortcut Dimension 1 Code");
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim11);
            TempDimSetEntry.INSERT();
        END;

        IF Dim22 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", RecGlSEtup."Shortcut Dimension 2 Code");
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim22);
            TempDimSetEntry.INSERT();
        END;
        IF Dim33 <> '' THEN BEGIN
            //TempDimSetEntry.VALIDATE("Dimension Code",RecGlSEtup."Shortcut Dimension 2 Code");
            TempDimSetEntry.VALIDATE("Dimension Code", 'FA HQ');
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim33);
            TempDimSetEntry.INSERT();
        END;
        IF Dim44 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", 'FO');
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim44);
            TempDimSetEntry.INSERT();
        END;
        IF Dim55 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", 'RME');
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim55);
            TempDimSetEntry.INSERT();
        END;
        IF Dim66 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", 'TME HQ');
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim66);
            TempDimSetEntry.INSERT();
        END;
        //ACXLK....................................................................................................//
        IF DIm77 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", 'FA');
            TempDimSetEntry.VALIDATE("Dimension Value Code", DIm77);
            TempDimSetEntry.INSERT();
        END;
        IF Dim88 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", 'TME');
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim88);
            TempDimSetEntry.INSERT();
        END;
        IF Dim99 <> '' THEN BEGIN
            TempDimSetEntry.VALIDATE("Dimension Code", 'ZMM');
            TempDimSetEntry.VALIDATE("Dimension Value Code", Dim99);
            TempDimSetEntry.INSERT();
        END;
        //ACXLK.................................................................................................................//
        EXIT(cuDimMangmnt.GetDimensionSetID(TempDimSetEntry));
    end;
}

