query 50003 GSTR2CDNRQuery1
{
    QueryType = Normal;

    elements
    {
        dataitem(Detailed_GST_Ledger_Entry; "Detailed GST Ledger Entry")
        {
            DataItemTableFilter = "GST Component Code" = filter(<> 'CESS');
            column(Document_Type; "Document Type")
            {
            }
            column(Location__Reg__No_; "Location  Reg. No.")
            {
            }
            filter(Transaction_Type; "Transaction Type")
            {
                ColumnFilter = Transaction_Type = const(Purchase);
            }
            filter(GSTled_Input_Service_Dist_; "GSTled Input Service Dist.")
            {

            }
            filter(External_Document_No_; "External Document No.")
            {

            }

            column(Posting_Date; "Posting Date")
            {
            }
            column(Source_No_; "Source No.")
            {
            }
            column(Credit_Availed; "Credit Availed")
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }
            column(Original_Invoice_No_; "Original Invoice No.")
            {

            }
            column(GST_Vendor_Type; "GST Vendor Type")
            {
            }
            filter(GST_Component_Code; "GST Component Code")
            {
            }
            column(Reverse_Charge; "Reverse Charge")
            {
            }
            column(Eligibility_for_ITC; "Eligibility for ITC")
            {

            }
            column(Buyer_Seller_Reg__No_; "Buyer/Seller Reg. No.")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(GST__; "GST %")
            {

            }
            column(GST_Jurisdiction_Type; "GST Jurisdiction Type")
            {
            }
            column(GST_Amount; "GST Amount")
            {
                Method = Sum;
            }
            column(GST_Base_Amount; "GST Base Amount")
            {
                Method = Sum;
            }
            dataitem(Detailed_GST_Ledger_Entry_Info; "Detailed GST Ledger Entry Info")
            {
                SqlJoinType = InnerJoin;
                DataItemLink = "Entry No." = Detailed_GST_Ledger_Entry."Entry No.";
                column(Adv__Pmt__Adjustment; "Adv. Pmt. Adjustment")
                {
                }
                column(Finance_Charge_Memo; "Finance Charge Memo")
                {

                }
                filter(Buyer_Seller_State_Code; "Buyer/Seller State Code")
                {

                }
                filter(Original_Invoice_Date; "Original Invoice Date")
                {

                }
                column(GST_Reason_Type; "GST Reason Type")
                {

                }
                column(Purchase_Invoice_Type; "Purchase Invoice Type")
                {
                }
                column(Original_Doc__Type; "Original Doc. Type")
                {

                }

            }
        }
    }
}