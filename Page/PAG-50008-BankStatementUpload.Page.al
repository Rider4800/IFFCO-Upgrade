page 50008 "Bank Statement Upload"
{
    Editable = false;
    PageType = List;
    SourceTable = 50004;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Dr/CR"; Rec."Dr/CR")
                {
                }
                field("Entry Amount"; Rec."Entry Amount")
                {
                }
                field("Value date"; Rec."Value date")
                {
                }
                field(Product; Rec.Product)
                {
                }
                field("Party Code"; Rec."Party Code")
                {
                }
                field("Party Name"; Rec."Party Name")
                {
                }
                field("Virtual Account Number"; Rec."Virtual Account Number")
                {
                }
                field(Locations; Rec.Locations)
                {
                }
                field("Remitting Bank"; Rec."Remitting Bank")
                {
                }
                field("UTR No"; Rec."UTR No")
                {
                }
                field("Remitter Name"; Rec."Remitter Name")
                {
                }
                field("Remitter Account No"; Rec."Remitter Account No")
                {
                }
                field("Region Name"; Rec."Region Name")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Pre Document No."; Rec."Pre Document No.")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }
                field("Uploaded By"; Rec."Uploaded By")
                {
                }
                field("Uploaded Date"; Rec."Uploaded Date")
                {
                }
                field("Uploaded Time"; Rec."Uploaded Time")
                {
                }
                field("Modified By"; Rec."Modified By")
                {
                }
                field("Modified Date"; Rec."Modified Date")
                {
                }
                field("Modified Time"; Rec."Modified Time")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Upload Bank Statement")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report 50048;
            }
            action("Validate & Create Voucher")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report 50010;

                trigger OnAction()
                begin
                    //2222
                end;
            }
            action("Change Status")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Selection(Rec);
                end;
            }
        }
    }

    local procedure Selection(BankStatement: Record 50004)
    begin
        CurrPage.SETSELECTIONFILTER(BankStatement);
        IF BankStatement.FINDFIRST THEN BEGIN
            REPEAT
                IF BankStatement.Status = BankStatement.Status::Error THEN BEGIN
                    BankStatement.Status := BankStatement.Status::New;
                    BankStatement.MODIFY();
                END;
            UNTIL BankStatement.NEXT = 0;
        END;
    end;
}

