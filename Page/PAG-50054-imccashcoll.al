page 50054 imc_cash_coll
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'imcCashColl';
    DelayedInsert = true;
    EntityName = 'imc_cash_coll';
    EntitySetName = 'imc_cash_coll';
    PageType = API;
    SourceTable = "Bank Account Ledger Entry";
    SourceTableTemporary = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(State_Code; Rec."Document No.")
                {

                }
                field(Posting_Date; Rec."Posting Date")
                {

                }
                field(Amount; Rec.Amount)
                {

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();
        Clear(EntryNo);

        BankAccLedgEnt.Reset();
        BankAccLedgEnt.SetRange("Bank Account No.", 'B/CA/00003');
        BankAccLedgEnt.SetFilter("Posting Date", '>=', 20211201D);
        if BankAccLedgEnt.FindSet() then
            repeat
                CustLedgEntry.Reset();
                CustLedgEntry.SetRange("Document No.", BankAccLedgEnt."Document No.");
                if CustLedgEntry.FindSet() then
                    repeat
                        Customer.Reset();
                        Customer.SetRange("No.", CustLedgEntry."Customer No.");
                        Customer.SetFilter("State Code", '<>%1', '');
                        if Customer.FindFirst() then begin
                            Rec.Reset();
                            Rec.SetRange("Posting Date", BankAccLedgEnt."Posting Date");
                            if Customer."State Code" = 'HP' then
                                Rec.SetRange("Document No.", 'PB')
                            else
                                Rec.SetRange("Document No.", Customer."State Code");
                            if not Rec.FindFirst() then begin
                                Rec.Init();
                                Rec."Entry No." := EntryNo + 1;
                                Rec."Posting Date" := BankAccLedgEnt."Posting Date";
                                if Customer."State Code" = 'HP' then
                                    Rec."Document No." := 'PB'
                                else
                                    Rec."Document No." := Customer."State Code";
                                Rec.Amount := BankAccLedgEnt.Amount;
                                Rec.Insert();
                            end else begin
                                Rec.Amount += BankAccLedgEnt.Amount;
                                Rec.Modify();
                            end;
                        end;
                    until CustLedgEntry.Next() = 0;

            until BankAccLedgEnt.Next() = 0;


        Rec.Reset();
    end;

    var
        BankAccLedgEnt: Record "Bank Account Ledger Entry";
        Customer: Record 18;
        CustLedgEntry: Record "Cust. Ledger Entry";
        StatCode: Code[10];
        EntryNo: Integer;
}
