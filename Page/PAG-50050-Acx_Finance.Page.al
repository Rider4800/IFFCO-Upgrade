page 50050 Acx_Finance
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Acx_Finance';
    DelayedInsert = true;
    EntityName = 'Acx_Finance';
    EntitySetName = 'Acx_Finance';
    PageType = API;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Entry_No; Rec."Entry No.")
                {
                }
                field("Posting_Date"; Rec."Posting Date")
                {
                }
                field(Document_Date; Rec."Document Date")
                {
                }
                field(Document_Type; DocType)
                {
                }
                field(Document_No; Rec."Document No.")
                {
                }
                field(External_Document_No; Rec."External Document No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(GL_Account_No; Rec."G/L Account No.")
                {
                }
                field(GL_Name; GLAccName)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(State; Rec."Global Dimension 1 Code")
                {
                }
                field(Warehouse; Rec."Global Dimension 2 Code")
                {
                }
                field(Source_Code; Rec."Source Code")
                {
                }
                field(Source_Type; SourceType)
                {
                }
                field(Source_No; Rec."Source No.")
                {
                }
                field(User_ID; Rec."User ID")
                {
                }
                field(Location_Code; Rec."Location Code")
                {
                }
                field(Branch_JV; Rec."Branch JV")
                {
                }
                field(Finance_Branch_Acc_Code; Rec."Finance Branch A/c Code")
                {
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Document Type" = Rec."Document Type"::" " then
            DocType := '';
        if Rec."Document Type" = Rec."Document Type"::Payment then
            DocType := 'Payment';
        if Rec."Document Type" = Rec."Document Type"::Invoice then
            DocType := 'Invoice';
        if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
            DocType := 'Credit Memo';
        if Rec."Document Type" = Rec."Document Type"::"Finance Charge Memo" then
            DocType := 'Finance Charge Memo';
        if Rec."Document Type" = Rec."Document Type"::Reminder then
            DocType := 'Reminder';
        if Rec."Document Type" = Rec."Document Type"::Refund then
            DocType := 'Refund';

        if GLAccRec.Get(Rec."G/L Account No.") then
            GLAccName := GLAccRec.Name;

        if Rec."Document Type" = Rec."Source Type"::" " then
            SourceType := '';
        if Rec."Document Type" = Rec."Source Type"::Customer then
            SourceType := 'Customer';
        if Rec."Document Type" = Rec."Source Type"::"Vendor" then
            SourceType := 'Vendor';
        if Rec."Document Type" = Rec."Source Type"::"Bank Account" then
            SourceType := 'Bank Account';
        if Rec."Document Type" = Rec."Source Type"::"Fixed Asset" then
            SourceType := 'Fixed Asset';
    end;

    var
        DocType: text[30];
        GLAccRec: Record "G/L Account";
        GLAccName: Text[50];
        SourceType: Text[50];
}