page 50052 Acx_outstanding
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Acx_outstanding';
    DelayedInsert = true;
    EntityName = 'Acx_outstanding';
    EntitySetName = 'Acx_outstanding';
    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Post_dt; Rec."Posting Date")
                {
                }
                field(Document_No; Rec."Document No.")
                {
                }
                field(External_Document_No; Rec."External Document No.")
                {
                }
                field(Doc_Date; Rec."Document Date")
                {
                }
                field(Customer_Posting_Group; Rec."Customer Posting Group")
                {
                }
                field(Customer_No; Rec."Customer No.")
                {
                }
                field(Due_dt; Rec."Due Date")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Resp_Center_Loc_State_Code; Rec.Description)
                {
                }
                field(Location_Code; Rec."Location Code")
                {
                }
                field(Name; Rec."Customer Name")
                {
                }
                field(Name2; Rec."Your Reference")
                {
                }
                field(Name3; Rec."Message to Recipient")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();

        CLERec.Reset();
        CLERec.SetFilter("Customer Posting Group", '<>%1|<>%2', 'RM_SUPP', 'EMPLOYEE');
        if CLERec.FindFirst() then begin
            repeat
                Rec.Init();
                Rec."Posting Date" := CLERec."Posting Date";
                Rec."Document No." := CLERec."Document No.";
                Rec."External Document No." := CLERec."External Document No.";
                Rec."Document Date" := CLERec."Document Date";
                Rec."Customer Posting Group" := CLERec."Customer Posting Group";
                Rec."Customer No." := CLERec."Customer No.";
                Rec."Due Date" := CLERec."Due Date";
                CLERec.CalcFields("Amount");
                Rec.Amount := CLERec.Amount;
                if CustRec.Get(CLERec."Customer No.") then begin
                    Rec.Description := CustRec."Responsibility Center" + '' + CLERec."Location State Code";
                    Rec."Customer Name" := CustRec.Name;
                    Rec."Your Reference" := CustRec."Name 2";
                    Rec."Message to Recipient" := CustRec."Name 3";
                end;
                Rec."Location Code" := CLERec."Location Code";
                Rec.Insert();
            until CLERec.Next() = 0;
        end;
    end;

    var
        CLERec: Record "Cust. Ledger Entry";
        CustRec: Record Customer;
}