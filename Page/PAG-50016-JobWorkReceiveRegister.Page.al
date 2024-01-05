page 50016 "Job Work Receive Register"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = 5747;
    SourceTableView = WHERE("Transfer-from Code" = FILTER('JW*'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                }
                field(TransferToName; TransferToName)
                {
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //acxcp
        recLocation.RESET();
        recLocation.SETRANGE(Code, Rec."Transfer-to Code");
        IF recLocation.FINDFIRST THEN
            TransferToName := recLocation.Name;
        //acxcp
    end;

    var
        TransferShipmentHeader: Record 5744;
        TransferToName: Text;
        recLocation: Record 14;
}

