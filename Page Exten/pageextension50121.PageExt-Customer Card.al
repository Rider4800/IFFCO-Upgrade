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
            //->E-Bazaar Customization
            field("Parent Customer"; Rec."Parent Customer")
            {
                ApplicationArea = all;
            }
            //<-E-Bazaar Customization
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
            //->E-Bazaar Customization
            field("Preferred Campaign No."; Rec."Preferred Campaign No.")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Preferred Campaign No.', ENN = 'Campaign No.';
            }
            //<-E-Bazaar Customization
            group("KYC Documents")
            {
                Caption = 'KYC Documents';
                field("Dealership Proposal"; rec."Dealership Proposal")
                {
                    ApplicationArea = All;
                }
                field("Dealership Proposal Remark"; rec."Dealership Proposal Remark")
                {
                    ApplicationArea = All;
                }
                field("Firm Consititution Certificate"; rec."Firm Consititution Certificate")
                {
                    ApplicationArea = All;
                }
                field("Firm Const. Remark"; rec."Firm Const. Remark")
                {
                    ApplicationArea = All;
                }
                field("Signed Blank Cheque"; rec."Signed Blank Cheque")
                {
                    ApplicationArea = All;
                }
                field("Signed Blank Cheq. Remark"; rec."Signed Blank Cheq. Remark")
                {
                    ApplicationArea = All;
                }
                field("Security Deposite"; rec."Security Deposite")
                {
                    ApplicationArea = All;
                }
                field("Security Deposite Remark"; rec."Security Deposite Remark")
                {
                    ApplicationArea = All;
                }
                field("Banker Varification Cert."; rec."Banker Varification Cert.")
                {
                    ApplicationArea = All;
                }
                field("Banker Varification Cert. Rem"; rec."Banker Varification Cert. Rem")
                {
                    ApplicationArea = All;
                }
                field("Last 3Yr B/Sheet"; rec."Last 3Yr B/Sheet")
                {
                    ApplicationArea = All;
                }
                field("Last 3Yr B/Sheet Remark"; rec."Last 3Yr B/Sheet Remark")
                {
                    ApplicationArea = All;
                }
                field("GST Cert."; rec."GST Cert.")
                {
                    ApplicationArea = All;
                }
                field("GST Cert. Remark"; rec."GST Cert. Remark")
                {
                    ApplicationArea = All;
                }
                field("Firm PAN"; rec."Firm PAN")
                {
                    ApplicationArea = All;
                }
                field("Firm PAN Remark"; rec."Firm PAN Remark")
                {
                    ApplicationArea = All;
                }
                field("KYC Form"; rec."KYC Form")
                {
                    ApplicationArea = All;
                }
                field("KYC Form Remark"; rec."KYC Form Remark")
                {
                    ApplicationArea = All;
                }
                field("ITR Last 3Yr"; rec."ITR Last 3Yr")
                {
                    ApplicationArea = All;
                }
                field("ITR Last 3Yr Remark"; rec."ITR Last 3Yr Remark")
                {
                    ApplicationArea = All;
                }
                field("Business Policy Signed"; rec."Business Policy Signed")
                {
                    ApplicationArea = All;
                }
                field("Business Policy Signed Remark"; rec."Business Policy Signed Remark")
                {
                    ApplicationArea = All;
                }
                field("Req. Letter -Dealership"; rec."Req. Letter -Dealership")
                {
                    ApplicationArea = All;
                }
                field("Req. Lette -Dealership Remark"; rec."Req. Lette -Dealership Remark")
                {
                    ApplicationArea = All;
                }
            }
            group("Customer Class1")
            {
                Caption = 'Customer Class';
                field("Customer Class"; rec."Customer Class")
                {
                    ApplicationArea = All;
                }
                field("Blocked/Unblocked Reason"; rec."Blocked/Unblocked Reason")
                {
                    ApplicationArea = All;
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