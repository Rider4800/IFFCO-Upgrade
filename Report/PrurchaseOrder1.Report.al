report 50200 "Prurchase Order1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PrurchaseOrder1.rdlc';
    Caption = 'Order';

    dataset
    {
        dataitem(DataItem4458; Table38)
        {
            DataItemTableView = SORTING (Document Type, No.)
                                WHERE (Document Type=CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Order';
            column(HeaderCaption; HeaderCaption)
            {
            }
            column(DocType_PurchaseHeader; "Document Type")
            {
            }
            column(No_PurchaseHeader; "No.")
            {
            }
            column(AmtCaption; AmtCaptionLbl)
            {
            }
            column(PaymentTermsDesc; PaymentTerms.Description)
            {
            }
            column(ShipmentMethodDesc; ShipmentMethod.Description)
            {
            }
            column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
            {
            }
            column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
            {
            }
            column(VATPercentCaption; VATPercentCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(VATAmtCaption; VATAmtCaptionLbl)
            {
            }
            column(VATIdentCaption; VATIdentCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            {
            }
            column(ShpMethodDescCaption; ShpMethodDescCaptionLbl)
            {
            }
            column(PrepmtTermsDescCaption; PrepmtTermsDescCaptionLbl)
            {
            }
            column(DocDateCaption; DocDateCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            dataitem(CopyLoop; Table2000000026)
            {
                DataItemTableView = SORTING (Number);
                dataitem(PageLoop; Table2000000026)
                {
                    DataItemTableView = SORTING (Number)
                                        WHERE (Number = CONST (1));
                    column(OrderCopyText; STRSUBSTNO(Text004, CopyText))
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyRegistrationLbl; CompanyRegistrationLbl)
                    {
                    }
                    column(CompanyInfo_GST_RegistrationNo; CompanyInfo."GST Registration No.")
                    {
                    }
                    column(VendorRegistrationLbl; VendorRegistrationLbl)
                    {
                    }
                    column(Vendor_GST_RegistrationNo; Vendor."GST Registration No.")
                    {
                    }
                    column(GSTComponentCode1; GSTComponentCode[1] + ' Amount')
                    {
                    }
                    column(GSTComponentCode2; GSTComponentCode[2] + ' Amount')
                    {
                    }
                    column(GSTComponentCode3; GSTComponentCode[3] + ' Amount')
                    {
                    }
                    column(GSTComponentCode4; GSTComponentCode[4] + 'Amount')
                    {
                    }
                    column(GSTCompAmount1; ABS(GSTCompAmount[1]))
                    {
                    }
                    column(GSTCompAmount2; ABS(GSTCompAmount[2]))
                    {
                    }
                    column(GSTCompAmount3; ABS(GSTCompAmount[3]))
                    {
                    }
                    column(GSTCompAmount4; ABS(GSTCompAmount[4]))
                    {
                    }
                    column(IsGSTApplicable; IsGSTApplicable)
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(DocDate_PurchaseHeader; FORMAT("Purchase Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_PurchaseHeader; "Purchase Header"."VAT Registration No.")
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_PurchaseHeader; "Purchase Header"."Your Reference")
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(BuyfromVendNo_PurchaseHdr; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyFromAddr1; BuyFromAddr[1])
                    {
                    }
                    column(BuyFromAddr2; BuyFromAddr[2])
                    {
                    }
                    column(BuyFromAddr3; BuyFromAddr[3])
                    {
                    }
                    column(BuyFromAddr4; BuyFromAddr[4])
                    {
                    }
                    column(BuyFromAddr5; BuyFromAddr[5])
                    {
                    }
                    column(BuyFromAddr6; BuyFromAddr[6])
                    {
                    }
                    column(BuyFromAddr7; BuyFromAddr[7])
                    {
                    }
                    column(BuyFromAddr8; BuyFromAddr[8])
                    {
                    }
                    column(PricesIncluVAT_PurchaseHdr; "Purchase Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(VATBaseDis_PurchaseHdr; "Purchase Header"."VAT Base Discount %")
                    {
                    }
                    column(PricesInclVATtxt; PricesInclVATtxt)
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(DimText; DimText)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(BuyfromVendNo_PurchaseHdrCaption; "Purchase Header".FIELDCAPTION("Buy-from Vendor No."))
                    {
                    }
                    column(PricesIncluVAT_PurchaseHdrCaption; "Purchase Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(HeaderComment; HeaderComment)
                    {
                    }
                    dataitem(DimensionLoop1; Table2000000026)
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING (Number)
                                            WHERE (Number = FILTER (1 ..));
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(DataItem6547; Table39)
                    {
                        DataItemLink = Document Type=FIELD(Document Type),
                                       Document No.=FIELD(No.);
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING(Document Type,Document No.,Line No.);

                        trigger OnPostDataItem()
                        begin
                            //ACX-RK 15042021 Begin
                            recPurchComment.RESET();
                            recPurchComment.SETRANGE("No.","Purchase Line"."Document No.");
                            recPurchComment.SETRANGE("Line No.","Purchase Line"."Line No.");
                              IF recPurchComment.FINDFIRST THEN BEGIN
                                LineComment := recPurchComment.Comment;
                              END;
                            //ACX-RK 15042021 End
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.BREAK;
                        end;
                    }
                    dataitem(RoundLoop;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(PurchLineLineAmount;PurchLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchaseLineDescription;"Purchase Line".Description)
                        {
                        }
                        column(LineNo_PurchaseLine;"Purchase Line"."Line No.")
                        {
                        }
                        column(AllowInvDisctxt;AllowInvDisctxt)
                        {
                        }
                        column(PurchaseLineType;FORMAT("Purchase Line".Type,0,2))
                        {
                        }
                        column(No_PurchaseLine;"Purchase Line"."No.")
                        {
                        }
                        column(Quantity_PurchaseLine;"Purchase Line".Quantity)
                        {
                        }
                        column(UnitofMeasure_PurchaseLine;"Purchase Line"."Unit of Measure")
                        {
                        }
                        column(DirectUnitCost_PurchaseLine;"Purchase Line"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_PurchaseLine;"Purchase Line"."Line Discount %")
                        {
                        }
                        column(LineAmount_PurchaseLine;"Purchase Line"."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineDiscAmt_PurchaseLine;"Purchase Line"."Line Discount Amount")
                        {
                        }
                        column(NegativePurchLineInvDiscAmt;-PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText;TotalText)
                        {
                        }
                        column(PurchLineInvDiscountAmt;PurchLine."Line Amount"-PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(PurchLineAmountToVendor;PurchLine."Amount To Vendor")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineExciseAmount;PurchLine."Excise Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineTaxAmount;PurchLine."Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineServiceTaxAmount;PurchLine."Service Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(OtherTaxesAmount;OtherTaxesAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ChargesAmount;ChargesAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineTotalTDSIncludingSheCess;-PurchLine."Total TDS Including SHE CESS")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineWorkTaxAmount;-PurchLine."Work Tax Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineSerTaxeCessAmt;PurchLine."Service Tax eCess Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PurchLineSerTaxSHECessAmt;PurchLine."Service Tax SHE Cess Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmount;-VATDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmount;VATAmount)
                        {
                        }
                        column(VATAmountLineVATAmountText;VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(VATBaseAmount;VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT;TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal;TotalSubTotal)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount;TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount;TotalAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalServiceTaxAmount;TotalServiceTaxAmount)
                        {
                        }
                        column(TotalServiceTaxeCessAmount;TotalServiceTaxeCessAmount)
                        {
                        }
                        column(TotalServiceTaxSHE2CessAmt;TotalServiceTaxSHE2CessAmount)
                        {
                        }
                        column(TotalSerTaxTDSSHEeCessAmt;TotalServiceTaxTDSSHEeCessAmount)
                        {
                        }
                        column(TotalServiceWorkTaxAmount;TotalServiceWorkTaxAmount)
                        {
                        }
                        column(TotalExciseAmount;TotalExciseAmount)
                        {
                        }
                        column(TotalTaxAmount;TotalTaxAmount)
                        {
                        }
                        column(DirectUnitCostCaption;DirectUnitCostCaptionLbl)
                        {
                        }
                        column(DiscPercentCaption;DiscPercentCaptionLbl)
                        {
                        }
                        column(LineDiscAmtCaption;LineDiscAmtCaptionLbl)
                        {
                        }
                        column(AllowInvDiscCaption;AllowInvDiscCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(ExciseAmtCaption;ExciseAmtCaptionLbl)
                        {
                        }
                        column(TaxAmtCaption;TaxAmtCaptionLbl)
                        {
                        }
                        column(ServTaxAmtCaption;ServTaxAmtCaptionLbl)
                        {
                        }
                        column(OtherTaxesAmtCaption;OtherTaxesAmtCaptionLbl)
                        {
                        }
                        column(ChrgsAmtCaption;ChrgsAmtCaptionLbl)
                        {
                        }
                        column(TotalTDSIncleSHECessCaption;TotalTDSIncleSHECessCaptionLbl)
                        {
                        }
                        column(WorkTaxAmtCaption;WorkTaxAmtCaptionLbl)
                        {
                        }
                        column(ServTaxeCessAmtCaption;ServTaxeCessAmtCaptionLbl)
                        {
                        }
                        column(ServTaxeSHECessAmtCaption;ServTaxeSHECessAmtCaptionLbl)
                        {
                        }
                        column(VATDiscAmtCaption;VATDiscAmtCaptionLbl)
                        {
                        }
                        column(PurchaseLineDescriptionCaption;"Purchase Line".FIELDCAPTION(Description))
                        {
                        }
                        column(No_PurchaseLineCaption;"Purchase Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Quantity_PurchaseLineCaption;"Purchase Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UnitofMeasure_PurchaseLineCaption;"Purchase Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(ServTaxeSBCAmt;PurchLine."Service Tax SBC Amount")
                        {
                        }
                        column(ServTaxSBCAmtCaption;ServTaxSBCAmtCaptionLbl)
                        {
                        }
                        column(TotalServiceTaxSBCAmount;TotalServiceTaxSBCAmount)
                        {
                        }
                        column(KKCessAmt;PurchLine."KK Cess Amount")
                        {
                        }
                        column(KKCessAmtCaption;KKCessAmtCaptionLbl)
                        {
                        }
                        column(TotalKKCessAmount;TotalKKCessAmount)
                        {
                        }
                        column(TotalGSTAmount;TotalGSTAmount)
                        {
                        }
                        column(LineComment;LineComment)
                        {
                        }
                        dataitem(DimensionLoop2;Table2000000026)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number=FILTER(1..));
                            column(LineDimsCaption;LineDimsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                  IF NOT DimSetEntry2.FINDSET THEN
                                    CurrReport.BREAK;
                                END ELSE
                                  IF NOT Continue THEN
                                    CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                  OldDimText := DimText;
                                  IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                  ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3',DimText,
                                        DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
                                  IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                  END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                  CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID","Purchase Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            StructureLineDetails: Record "13795";
                        begin
                            IF Number = 1 THEN
                              PurchLine.FIND('-')
                            ELSE
                              PurchLine.NEXT;
                            "Purchase Line" := PurchLine;

                            IF NOT "Purchase Header"."Prices Including VAT" AND
                               (PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT")
                            THEN
                              PurchLine."Line Amount" := 0;

                            IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                              "Purchase Line"."No." := '';

                            IF IsGSTApplicable AND (PurchLine.Type <> PurchLine.Type::" ") THEN BEGIN
                              j := 1;
                              GSTComponent.RESET;
                              GSTComponent.SETRANGE("GST Jurisdiction Type",PurchLine."GST Jurisdiction Type");
                              IF GSTComponent.FINDSET THEN
                                REPEAT
                                  GSTComponentCode[j] := GSTComponent.Code;
                                  DetailedGSTEntryBuffer.RESET;
                                  DetailedGSTEntryBuffer.SETCURRENTKEY("Transaction Type","Document Type","Document No.","Line No.");
                                  DetailedGSTEntryBuffer.SETRANGE("Transaction Type",DetailedGSTEntryBuffer."Transaction Type"::Purchase);
                                  DetailedGSTEntryBuffer.SETRANGE("Document Type",PurchLine."Document Type");
                                  DetailedGSTEntryBuffer.SETRANGE("Document No.",PurchLine."Document No.");
                                  DetailedGSTEntryBuffer.SETRANGE("Line No.",PurchLine."Line No.");
                                  DetailedGSTEntryBuffer.SETRANGE("GST Component Code",GSTComponentCode[j]);
                                  IF DetailedGSTEntryBuffer.FINDSET THEN BEGIN
                                    REPEAT
                                      GSTCompAmount[j] += DetailedGSTEntryBuffer."GST Amount";
                                    UNTIL DetailedGSTEntryBuffer.NEXT = 0;
                                    j += 1;
                                  END;
                                UNTIL GSTComponent.NEXT = 0;
                            END;

                            StructureLineDetails.RESET;
                            StructureLineDetails.SETRANGE(Type,StructureLineDetails.Type::Purchase);
                            StructureLineDetails.SETRANGE("Document Type",PurchLine."Document Type");
                            StructureLineDetails.SETRANGE("Document No.",PurchLine."Document No.");
                            StructureLineDetails.SETRANGE("Item No.",PurchLine."No.");
                            StructureLineDetails.SETRANGE("Line No.",PurchLine."Line No.");
                            IF StructureLineDetails.FIND('-') THEN
                              REPEAT
                                IF NOT StructureLineDetails."Payable to Third Party" THEN BEGIN
                                  IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::Charges THEN
                                    ChargesAmount := ChargesAmount + ROUND(StructureLineDetails.Amount);
                                  IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::"Other Taxes" THEN
                                    OtherTaxesAmount := OtherTaxesAmount + ROUND(StructureLineDetails.Amount);
                                END;
                              UNTIL StructureLineDetails.NEXT = 0;

                            AllowInvDisctxt := FORMAT("Purchase Line"."Allow Invoice Disc.");

                            TotalSubTotal += "Purchase Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
                            TotalAmount += "Purchase Line".Amount;

                            TotalServiceTaxAmount += PurchLine."Service Tax Amount";
                            TotalServiceTaxeCessAmount += PurchLine."Service Tax eCess Amount";
                            TotalServiceTaxSHE2CessAmount += PurchLine."Service Tax SHE Cess Amount";
                            TotalServiceTaxTDSSHEeCessAmount += -PurchLine."Total TDS Including SHE CESS";
                            TotalServiceWorkTaxAmount += -PurchLine."Work Tax Amount";
                            TotalTaxAmount += PurchLine."Tax Amount";
                            TotalServiceTaxSBCAmount += PurchLine."Service Tax SBC Amount";
                            TotalKKCessAmount += PurchLine."KK Cess Amount";
                            TotalGSTAmount += PurchLine."Total GST Amount";
                            TotalExciseAmount += PurchLine."Excise Amount";
                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLine.DELETEALL;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.FIND('+');
                            WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2"= '') AND
                                  (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
                                  (PurchLine.Amount = 0) DO
                              MoreLines := PurchLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                              CurrReport.BREAK;
                            PurchLine.SETRANGE("Line No.",0,PurchLine."Line No.");
                            SETRANGE(Number,1,PurchLine.COUNT);
                            CurrReport.CREATETOTALS(PurchLine."Line Amount",PurchLine."Inv. Discount Amount",
                              PurchLine."Excise Amount",PurchLine."Tax Amount",PurchLine."Service Tax Amount",
                              PurchLine."Service Tax eCess Amount",PurchLine."Total TDS Including SHE CESS",PurchLine."Work Tax Amount",
                              PurchLine."Amount To Vendor",PurchLine."Service Tax SBC Amount");
                            CurrReport.CREATETOTALS(PurchLine."KK Cess Amount");
                            CurrReport.CREATETOTALS(PurchLine."Service Tax SHE Cess Amount");
                        end;
                    }
                    dataitem(VATCounter;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmountLineVATBase;VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount;VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount;VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineInvDisAmt;VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLineVATIdentifier;VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecCaption;VATAmtSpecCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption;InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption;LineAmtCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF VATAmount = 0 THEN
                              CurrReport.BREAK;
                            SETRANGE(Number,1,VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate;VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader;VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmountLCY;VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY;VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATLCY;VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(VATAmountLineVATIdentLCY;VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Purchase Header"."Currency Code"  = '') OR
                               (VATAmountLine.GetTotalVATAmount = 0) THEN
                              CurrReport.BREAK;

                            SETRANGE(Number,1,VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                              VALSpecLCYHeader := Text007 + Text008
                            ELSE
                              VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
                            VALExchRate := STRSUBSTNO(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total2;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number=CONST(1));
                        column(PaytoVendorNo_PurchHdr;"Purchase Header"."Pay-to Vendor No.")
                        {
                        }
                        column(VendAddr8;VendAddr[8])
                        {
                        }
                        column(VendAddr7;VendAddr[7])
                        {
                        }
                        column(VendAddr6;VendAddr[6])
                        {
                        }
                        column(VendAddr5;VendAddr[5])
                        {
                        }
                        column(VendAddr4;VendAddr[4])
                        {
                        }
                        column(VendAddr3;VendAddr[3])
                        {
                        }
                        column(VendAddr2;VendAddr[2])
                        {
                        }
                        column(VendAddr1;VendAddr[1])
                        {
                        }
                        column(PmtDetailsCaption;PmtDetailsCaptionLbl)
                        {
                        }
                        column(VendNoCaption;VendNoCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
                              CurrReport.BREAK;
                        end;
                    }
                    dataitem(Total3;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number=CONST(1));
                        column(SelltoCustomerNo_PurchHdr;"Purchase Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr1;ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2;ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3;ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4;ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5;ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6;ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7;ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8;ShipToAddr[8])
                        {
                        }
                        column(ShiptoAddrCaption;ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustomerNo_PurchHdrCaption;"Purchase Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
                              CurrReport.BREAK;
                        end;
                    }
                    dataitem(PrepmtLoop;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number=FILTER(1..));
                        column(PrepmtLineAmount;PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufGLAccountNo;PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(PrepmtInvBufDescription;PrepmtInvBuf.Description)
                        {
                        }
                        column(PrePmtTotalExclVATText;TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmountLineVATAmountText;PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtVATAmount;PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrePmtTotalInclVATText;TotalInclVATText)
                        {
                        }
                        column(PrepmtInvBufAmountPrepmtVATAmount;PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtTotalAmountInclVAT;PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtLoopNumber;Number)
                        {
                        }
                        column(DescCaption;DescCaptionLbl)
                        {
                        }
                        column(GLAccNoCaption;GLAccNoCaptionLbl)
                        {
                        }
                        column(PrepmtSpecCaption;PrepmtSpecCaptionLbl)
                        {
                        }
                        column(PrepmtLoopLineNo;PrepmtLoopLineNo)
                        {
                        }
                        dataitem(PrepmtDimLoop;Table2000000026)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number=FILTER(1..));
                            column(DummyColumn;0)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                  IF NOT PrepmtDimSetEntry.FINDSET THEN
                                    CurrReport.BREAK;
                                END ELSE
                                  IF NOT Continue THEN
                                    CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                  OldDimText := DimText;
                                  IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2',PrepmtDimSetEntry."Dimension Code",PrepmtDimSetEntry."Dimension Value Code")
                                  ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3',DimText,
                                        PrepmtDimSetEntry."Dimension Code",PrepmtDimSetEntry."Dimension Value Code");
                                  IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                  END;
                                UNTIL PrepmtDimSetEntry.NEXT = 0;

                                IF Number > 1 THEN
                                  PrepmtLineAmount := 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                  CurrReport.BREAK;

                                PrepmtDimSetEntry.SETRANGE("Dimension Set ID",PrepmtInvBuf."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                              IF NOT PrepmtInvBuf.FIND('-') THEN
                                CurrReport.BREAK;
                            END ELSE
                              IF PrepmtInvBuf.NEXT = 0 THEN
                                CurrReport.BREAK;

                            IF "Purchase Header"."Prices Including VAT" THEN
                              PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            ELSE
                              PrepmtLineAmount := PrepmtInvBuf.Amount;

                            PrepmtLoopLineNo += 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CREATETOTALS(
                              PrepmtInvBuf.Amount,PrepmtInvBuf."Amount Incl. VAT",
                              PrepmtVATAmountLine."Line Amount",PrepmtVATAmountLine."VAT Base",
                              PrepmtVATAmountLine."VAT Amount",
                              PrepmtLineAmount);
                            PrepmtLoopLineNo := 0;
                        end;
                    }
                    dataitem(PrepmtVATCounter;Table2000000026)
                    {
                        DataItemTableView = SORTING(Number);
                        column(PrepmtVATAmountLineVATAmt;PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmountLineVATBase;PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmountLineLineAmt;PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmountLineVAT;PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(PrepmtVATAmountLineVATIdent;PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepmtVATAmtSpecCaption;PrepmtVATAmtSpecCaptionLbl)
                        {
                        }
                        column(PrepmtVATIdentCaption;PrepmtVATIdentCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number,1,PrepmtVATAmountLine.COUNT);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtPurchLine: Record "39" temporary;
                    TempPurchLine: Record "39" temporary;
                begin
                    CLEAR(PurchLine);
                    CLEAR(PurchPost);
                    PurchLine.DELETEALL;
                    VATAmountLine.DELETEALL;
                    PurchPost.GetPurchLines("Purchase Header",PurchLine,0);
                    PurchLine.CalcVATAmountLines(0,"Purchase Header",PurchLine,VATAmountLine);
                    PurchLine.UpdateVATOnLines(0,"Purchase Header",PurchLine,VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DELETEALL;
                    PurchPostPrepmt.GetPurchLines("Purchase Header",0,PrepmtPurchLine);
                    IF NOT PrepmtPurchLine.ISEMPTY THEN BEGIN
                      PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header",TempPurchLine);
                      IF NOT TempPurchLine.ISEMPTY THEN
                        PurchPostPrepmt.CalcVATAmountLines("Purchase Header",TempPurchLine,PrePmtVATAmountLineDeduct,1);
                    END;
                    PurchPostPrepmt.CalcVATAmountLines("Purchase Header",PrepmtPurchLine,PrepmtVATAmountLine,0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrePmtVATAmountLineDeduct);
                    PurchPostPrepmt.UpdateVATOnLines("Purchase Header",PrepmtPurchLine,PrepmtVATAmountLine,0);
                    PurchPostPrepmt.BuildInvLineBuffer2("Purchase Header",PrepmtPurchLine,0,PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    IF Number > 1 THEN
                      CopyText := Text003;
                    CurrReport.PAGENO := 1;
                    OutputNo := OutputNo + 1;

                    TotalSubTotal := 0;
                    TotalAmount := 0;
                    ChargesAmount :=0;
                    OtherTaxesAmount :=0;

                    TotalInvoiceDiscountAmount := 0;

                    TotalServiceTaxAmount := 0;
                    TotalServiceTaxeCessAmount := 0;
                    TotalServiceTaxSHE2CessAmount := 0;
                    TotalServiceTaxTDSSHEeCessAmount := 0;
                    TotalServiceWorkTaxAmount := 0;
                    TotalTaxAmount := 0;
                    TotalServiceTaxSBCAmount := 0;
                    TotalKKCessAmount := 0;
                    TotalGSTAmount := 0;
                    TotalExciseAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                      PurchCountPrinted.RUN("Purchase Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number,1,NoOfLoops);
                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                CompanyInfo.GET;
                IsGSTApplicable := GSTManagement.IsGSTApplicable(Structure);
                Vendor.GET("Buy-from Vendor No.");

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                  FormatAddr.RespCenter(CompanyAddr,RespCenter);
                  CompanyInfo."Phone No." := RespCenter."Phone No.";
                  CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                  FormatAddr.Company(CompanyAddr,CompanyInfo);

                DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

                IF "Purchaser Code" = '' THEN BEGIN
                  SalesPurchPerson.INIT;
                  PurchaserText := '';
                END ELSE BEGIN
                  SalesPurchPerson.GET("Purchaser Code");
                  PurchaserText := Text000
                END;
                IF "Your Reference" = '' THEN
                  ReferenceText := ''
                ELSE
                  ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                  VATNoText := ''
                ELSE
                  VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                  GLSetup.TESTFIELD("LCY Code");
                  TotalText := STRSUBSTNO(Text001,GLSetup."LCY Code");
                  TotalInclVATText := STRSUBSTNO(Text13700,GLSetup."LCY Code");
                  TotalExclVATText := STRSUBSTNO(Text13701,GLSetup."LCY Code");
                END ELSE BEGIN
                  TotalText := STRSUBSTNO(Text001,"Currency Code");
                  TotalInclVATText := STRSUBSTNO(Text13700,"Currency Code");
                  TotalExclVATText := STRSUBSTNO(Text13701,"Currency Code");
                END;

                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr,"Purchase Header");
                IF "Buy-from Vendor No." <> "Pay-to Vendor No." THEN
                  FormatAddr.PurchHeaderPayTo(VendAddr,"Purchase Header");
                IF "Payment Terms Code" = '' THEN
                  PaymentTerms.INIT
                ELSE BEGIN
                  PaymentTerms.GET("Payment Terms Code");
                  PaymentTerms.TranslateDescription(PaymentTerms,"Language Code");
                END;
                IF "Prepmt. Payment Terms Code" = '' THEN
                  PrepmtPaymentTerms.INIT
                ELSE BEGIN
                  PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
                  PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms,"Language Code");
                END;
                IF "Shipment Method Code" = '' THEN
                  ShipmentMethod.INIT
                ELSE BEGIN
                  ShipmentMethod.GET("Shipment Method Code");
                  ShipmentMethod.TranslateDescription(ShipmentMethod,"Language Code");
                END;

                FormatAddr.PurchHeaderShipTo(ShipToAddr,"Purchase Header");

                IF NOT CurrReport.PREVIEW THEN BEGIN
                  IF ArchiveDocument THEN
                    ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

                  IF LogInteraction THEN BEGIN
                    CALCFIELDS("No. of Archived Versions");
                    SegManagement.LogDocument(
                      13,"No.","Doc. No. Occurrence","No. of Archived Versions",DATABASE::Vendor,"Buy-from Vendor No.",
                      "Purchaser Code",'',"Posting Description",'');
                  END;
                END;
                PricesInclVATtxt := FORMAT("Prices Including VAT");
                //ACX-RK 14042021 Begin
                IF "Purchase Header".Status = "Purchase Header".Status::Released THEN
                  HeaderCaption := 'Unsigned'
                ELSE
                  HeaderCaption := 'Order';
                //Header Comment
                recPurchComment.RESET();
                recPurchComment.SETRANGE("No.","Purchase Header"."No.");
                recPurchComment.SETRANGE("Document Line No.",0);
                  IF recPurchComment.FIND('-') THEN BEGIN
                    HeaderComment := recPurchComment.Comment;
                  END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoofCopies;NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInformation;ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(ArchiveDocument;ArchiveDocument)
                    {
                        Caption = 'Archive Document';

                        trigger OnValidate()
                        begin
                            IF NOT ArchiveDocument THEN
                              LogInteraction := FALSE;
                        end;
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            IF LogInteraction THEN
                              ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := PurchSetup."Archive Quotes and Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        PurchSetup.GET;
    end;

    var
        Text000: Label 'Purchaser';
        Text001: Label 'Total %1';
        Text003: Label 'COPY';
        Text004: Label 'Order %1';
        GLSetup: Record "98";
        CompanyInfo: Record "79";
        ShipmentMethod: Record "10";
        PaymentTerms: Record "3";
        PrepmtPaymentTerms: Record "3";
        SalesPurchPerson: Record "13";
        VATAmountLine: Record "290" temporary;
        PrepmtVATAmountLine: Record "290" temporary;
        PrePmtVATAmountLineDeduct: Record "290" temporary;
        PurchLine: Record "39" temporary;
        DimSetEntry1: Record "480";
        DimSetEntry2: Record "480";
        PrepmtDimSetEntry: Record "480";
        PrepmtInvBuf: Record "461" temporary;
        RespCenter: Record "5714";
        Language: Record "8";
        CurrExchRate: Record "330";
        PurchSetup: Record "312";
        GSTComponent: Record "16405";
        DetailedGSTEntryBuffer: Record "16412";
        Vendor: Record "23";
        PurchCountPrinted: Codeunit "317";
        FormatAddr: Codeunit "365";
        PurchPost: Codeunit "90";
        ArchiveManagement: Codeunit "5063";
        SegManagement: Codeunit "5051";
        PurchPostPrepmt: Codeunit "444";
        GSTManagement: Codeunit "16401";
        GSTCompAmount: array [20] of Decimal;
        GSTComponentCode: array [20] of Code[10];
        VendAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        BuyFromAddr: array [8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        OtherTaxesAmount: Decimal;
        ChargesAmount: Decimal;
        Text13700: Label 'Total %1 Incl. Taxes';
        Text13701: Label 'Total %1 Excl. Taxes';
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalTaxAmount: Decimal;
        TotalServiceTaxAmount: Decimal;
        TotalServiceTaxeCessAmount: Decimal;
        TotalServiceTaxSHE2CessAmount: Decimal;
        TotalServiceTaxTDSSHEeCessAmount: Decimal;
        TotalServiceWorkTaxAmount: Decimal;
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        OrderNoCaptionLbl: Label 'Order No.';
        PageCaptionLbl: Label 'Page';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        DirectUnitCostCaptionLbl: Label 'Direct Unit Cost';
        DiscPercentCaptionLbl: Label 'Discount %';
        AmtCaptionLbl: Label 'Amount';
        LineDiscAmtCaptionLbl: Label 'Line Discount Amount';
        AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';
        SubtotalCaptionLbl: Label 'Subtotal';
        ExciseAmtCaptionLbl: Label 'Excise Amount';
        TaxAmtCaptionLbl: Label 'Tax Amount';
        ServTaxAmtCaptionLbl: Label 'Service Tax Amount';
        OtherTaxesAmtCaptionLbl: Label 'Other Taxes Amount';
        ChrgsAmtCaptionLbl: Label 'Charges Amount';
        TotalTDSIncleSHECessCaptionLbl: Label 'Total TDS Incl. eCess Amount';
        WorkTaxAmtCaptionLbl: Label 'Work Tax Amount';
        ServTaxeCessAmtCaptionLbl: Label 'Service Tax eCess Amount';
        ServTaxeSHECessAmtCaptionLbl: Label 'Service Tax SHECess Amount';
        VATDiscAmtCaptionLbl: Label 'Payment Discount on VAT';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        PmtDetailsCaptionLbl: Label 'Payment Details';
        VendNoCaptionLbl: Label 'Vendor No.';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        DescCaptionLbl: Label 'Description';
        GLAccNoCaptionLbl: Label 'G/L Account No.';
        PrepmtSpecCaptionLbl: Label 'Prepayment Specification';
        PrepmtVATAmtSpecCaptionLbl: Label 'Prepayment VAT Amount Specification';
        PrepmtVATIdentCaptionLbl: Label 'VAT Identifier';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        VATPercentCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentCaptionLbl: Label 'VAT Identifier';
        TotalCaptionLbl: Label 'Total';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        ShpMethodDescCaptionLbl: Label 'Shipment Method';
        PrepmtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms';
        DocDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        TotalServiceTaxSBCAmount: Decimal;
        ServTaxSBCAmtCaptionLbl: Label 'SBC Amount';
        TotalKKCessAmount: Decimal;
        KKCessAmtCaptionLbl: Label 'KK Cess Amount';
        TotalGSTAmount: Decimal;
        TotalExciseAmount: Decimal;
        IsGSTApplicable: Boolean;
        j: Integer;
        CompanyRegistrationLbl: Label 'Company Registration No.';
        VendorRegistrationLbl: Label 'Vendor GST Reg No.';
        PrepmtLoopLineNo: Integer;
        HeaderCaption: Text;
        HeaderComment: Text;
        LineComment: Text;
        recPurchComment: Record "43";

    [Scope('Internal')]
    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewArchiveDocument: Boolean;NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;
}

