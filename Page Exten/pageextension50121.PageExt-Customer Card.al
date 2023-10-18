pageextension 50121 CustomerCard extends "Customer Card"
{

    layout
    {
        modify(Blocked)
        {
            Editable = BlockedUnblocked;
        }
        modify("Name 2")
        {
            Visible = true;
        }
        addafter(Name)
        {

            field("Name 3"; Rec."Name 3")
            {
                ApplicationArea = all;
            }
        }
        addafter("Search Name")
        {
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Last Date Modified")
        {
            field("Scheme Code"; Rec."Scheme Code")
            {
                ApplicationArea = all;
            }
            field("Finance Branch A/c Code"; Rec."Finance Branch A/c Code")
            {
                ApplicationArea = all;
            }

            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;

            }
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = all;
                Editable = false;
            }


        }

        addafter("Credit Limit (LCY)")
        {
            field("Excludes Credit Limit Allow"; Rec."Excludes Credit Limit Allow")
            {
                ApplicationArea = all;
            }
            field("One Time Credit Pass Allow"; Rec."One Time Credit Pass Allow")
            {
                ApplicationArea = all;
            }
            group("KYC Documents")
            {
                Caption = 'KYC Documents';
                field("Dealership Proposal"; rec."Dealership Proposal")
                {
                }
                field("Dealership Proposal Remark"; rec."Dealership Proposal Remark")
                {
                }
                field("Firm Consititution Certificate"; rec."Firm Consititution Certificate")
                {
                }
                field("Firm Const. Remark"; rec."Firm Const. Remark")
                {
                }
                field("Signed Blank Cheque"; rec."Signed Blank Cheque")
                {
                }
                field("Signed Blank Cheq. Remark"; rec."Signed Blank Cheq. Remark")
                {
                }
                field("Security Deposite"; rec."Security Deposite")
                {
                }
                field("Security Deposite Remark"; rec."Security Deposite Remark")
                {
                }
                field("Banker Varification Cert."; rec."Banker Varification Cert.")
                {
                }
                field("Banker Varification Cert. Rem"; rec."Banker Varification Cert. Rem")
                {
                }
                field("Last 3Yr B/Sheet"; rec."Last 3Yr B/Sheet")
                {
                }
                field("Last 3Yr B/Sheet Remark"; rec."Last 3Yr B/Sheet Remark")
                {
                }
                field("GST Cert."; rec."GST Cert.")
                {
                }
                field("GST Cert. Remark"; rec."GST Cert. Remark")
                {
                }
                field("Firm PAN"; rec."Firm PAN")
                {
                }
                field("Firm PAN Remark"; rec."Firm PAN Remark")
                {
                }
                field("KYC Form"; rec."KYC Form")
                {
                }
                field("KYC Form Remark"; rec."KYC Form Remark")
                {
                }
                field("ITR Last 3Yr"; rec."ITR Last 3Yr")
                {
                }
                field("ITR Last 3Yr Remark"; rec."ITR Last 3Yr Remark")
                {
                }
                field("Business Policy Signed"; rec."Business Policy Signed")
                {
                }
                field("Business Policy Signed Remark"; rec."Business Policy Signed Remark")
                {
                }
                field("Req. Letter -Dealership"; rec."Req. Letter -Dealership")
                {
                }
                field("Req. Lette -Dealership Remark"; rec."Req. Lette -Dealership Remark")
                {
                }
            }
            group("Customer Class1")
            {
                Caption = 'Customer Class';
                field("Customer Class"; rec."Customer Class")
                {
                }
                field("Blocked/Unblocked Reason"; rec."Blocked/Unblocked Reason")
                {
                }
            }
        }

    }

    actions
    {

    }

    var

        recCustomer: Record 18;
        recUserSetup: Record 91;
        BlockedUnblocked: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //ACX-RK 17032021 Begin
        recUserSetup.SETRANGE("User ID", USERID);
        recUserSetup.SETRANGE("Customer Blocked/Unblocked", TRUE);
        IF recUserSetup.FINDFIRST THEN
            BlockedUnblocked := TRUE
        ELSE
            BlockedUnblocked := FALSE;
        //ACX-RK End
    end;



}