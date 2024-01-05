xmlport 50003 ImportSalesPrice
{
    Format = VariableText;
    Direction = Import;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '';//New line

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'SalesPrice';
                AutoSave = false;
                textelement(ItemNo)
                {
                    MinOccurs = Zero;
                }
                textelement(SalesCode)
                {
                    MinOccurs = Zero;
                }
                textelement(StartDate)
                {
                    MinOccurs = Zero;
                }
                textelement(UnitPrice)
                {
                    MinOccurs = Zero;
                }
                textelement(AllowInvDisc)
                {
                    MinOccurs = Zero;
                }
                textelement(SalesType)
                {
                    MinOccurs = Zero;
                }
                textelement(MinQty)
                {
                    MinOccurs = Zero;
                }
                textelement(EndDate)
                {
                    MinOccurs = Zero;
                }
                textelement(UOM)
                {
                    MinOccurs = Zero;
                }
                textelement(AllowLineDisc)
                {
                    MinOccurs = Zero;
                }
                textelement(MRPPRice)
                {
                    MinOccurs = Zero;
                }
                trigger OnAfterInitRecord()
                begin
                    Counter += 1;
                    IF Counter = 1 THEN
                        currXMLport.SKIP;
                end;

                trigger OnBeforeInsertRecord()
                var
                    _ItemNo: Code[20];
                    _SalesCode: Code[20];
                    _StartDate: Date;
                    _UnitPrice: Decimal;
                    _AllowInvDisc: Boolean;
                    _Salestype: Text[100];
                    _MinQty: Decimal;
                    _EndDate: Date;
                    _UOM: Code[10];
                    _AllowLineDisc: Boolean;
                    _MRPPRice: Decimal;
                    LocalPriceListLine: Record "Price List Line";
                    LocalPriceListLine1: Record "Price List Line";
                    LineNo: Integer;
                    ItemRec: Record Item;
                begin
                    if ItemNo <> '' then
                        EVALUATE(_ItemNo, ItemNo);
                    if SalesCode <> '' then
                        EVALUATE(_SalesCode, SalesCode);
                    if StartDate <> '' then
                        EVALUATE(_StartDate, StartDate);
                    if UnitPrice <> '' then
                        EVALUATE(_UnitPrice, UnitPrice);
                    if AllowInvDisc <> '' then
                        EVALUATE(_AllowInvDisc, AllowInvDisc);
                    if Salestype <> '' then
                        EVALUATE(_Salestype, Salestype);
                    if MinQty <> '' then
                        EVALUATE(_MinQty, MinQty);
                    if EndDate <> '' then
                        EVALUATE(_EndDate, EndDate);
                    if UOM <> '' then
                        EVALUATE(_UOM, UOM);
                    if AllowLineDisc <> '' then
                        EVALUATE(_AllowLineDisc, AllowLineDisc);
                    if MRPPRice <> '' then
                        EVALUATE(_MRPPRice, MRPPRice);

                    LocalPriceListLine.Init();
                    LocalPriceListLine."Price List Code" := 'S00001';

                    LocalPriceListLine1.reset();
                    if not LocalPriceListLine1.findlast() then
                        LineNo := 1
                    else
                        LineNo := LocalPriceListLine1."Line No." + 1;

                    LocalPriceListLine."Line No." := LineNo;
                    LocalPriceListLine.Insert();
                    LocalPriceListLine."Product No." := _ItemNo;
                    LocalPriceListLine."Asset No." := _ItemNo;
                    if ItemRec.Get(_ItemNo) then begin
                        LocalPriceListLine.Description := ItemRec.Description;
                        LocalPriceListLine."Unit of Measure Code" := ItemRec."Base Unit of Measure";
                    end;
                    LocalPriceListLine."Assign-to No." := _SalesCode;
                    LocalPriceListLine."Source No." := _SalesCode;
                    LocalPriceListLine."Starting Date" := _StartDate;
                    LocalPriceListLine."Unit Price" := _UnitPrice;
                    LocalPriceListLine."Allow Invoice Disc." := true;
                    EVALUATE(LocalPriceListLine."Source Type", _Salestype);
                    LocalPriceListLine."Minimum Quantity" := _MinQty;
                    LocalPriceListLine."Ending Date" := _EndDate;
                    //Evaluate(LocalPriceListLine."Unit of Measure Code", _UOM);
                    LocalPriceListLine."Allow Line Disc." := true;
                    LocalPriceListLine."MRP Price" := _MRPPRice;
                    LocalPriceListLine.Modify();
                end;
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        MESSAGE('Total %1 Line has been Imported Successfully..', Counter);
    end;

    trigger OnPreXmlPort()
    begin
        Counter := 0;
    end;

    var
        Counter: Integer;
}