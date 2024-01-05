xmlport 50002 ExportSalesPrice
{
    Format = VariableText;
    Direction = Export;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '';//New line
    schema
    {
        tableelement("Sales Price"; "Sales Price")
        {
            XmlName = 'SalesPrice';
            fieldelement(ItemNo; "Sales Price"."Item No.")
            {
            }
            fieldelement(SalesCode; "Sales Price"."Sales Code")
            {
            }
            fieldelement(StartDate; "Sales Price"."Starting Date")
            {
            }
            fieldelement(UnitPrice; "Sales Price"."Unit Price")
            {
            }
            fieldelement(AllowInvDisc; "Sales Price"."Allow Invoice Disc.")
            {
            }
            fieldelement(SalesType; "Sales Price"."Sales Type")
            {
            }
            fieldelement(MinQty; "Sales Price"."Minimum Quantity")
            {
            }
            fieldelement(EndDate; "Sales Price"."Ending Date")
            {
            }
            fieldelement(UOM; "Sales Price"."Unit of Measure Code")
            {
            }
            fieldelement(AllowLineDisc; "Sales Price"."Allow Line Disc.")
            {
            }
            fieldelement(MRPPRice; "Sales Price"."MRP Price New")
            {
            }
        }
    }
}