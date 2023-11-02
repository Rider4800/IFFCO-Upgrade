page 50058 Imc_purchase
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'imcPurchase';
    DelayedInsert = true;
    EntityName = 'Imc_purchase';
    EntitySetName = 'Imc_purchase';
    PageType = API;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        Clear(Rec);
        Rec.DeleteAll();

        Clear(EntryNo);

        GLEntry.Reset();
        GLEntry.SetFilter("G/L Account No.", '%1|%2|%3', '411100010', '411100020', '411100030');
        if GLEntry.FindSet() then
            repeat
                if GLEntry."Document Type" in [GLEntry."Document Type"::" ", GLEntry."Document Type"::Refund] then begin
                    Rec.Reset();
                    if GLAcc.Get(GLEntry."G/L Account No.") then
                        Rec.SetRange("G/L Account Name", GLAcc.Name);
                    Rec.SetRange("Posting Date", GLEntry."Posting Date");
                    Rec.SetRange("External Document No.", GLEntry."External Document No.");
                    Rec.SetRange("Document No.", GLEntry."Document No.");
                    Rec.SetRange("Source No.", GLEntry."Source No.");
                    Rec.SetRange("Location Code", GLEntry."Location Code");
                    if Location.get(GLEntry."Location Code") then begin
                        Rec.SetRange(Description, Location.Name);
                        Rec.SetRange("Reason Code", Location."State Code");
                    end;
                    VLE.Reset();
                    VLE.SetRange("Document No.", GLEntry."Document No.");
                    if VLE.FindFirst() then begin
                        Rec.SetRange("VAT Bus. Posting Group", VLE."Buy-from Vendor No.");
                        Rec.SetRange("VAT Prod. Posting Group", VLE."Vendor Posting Group");
                    end;
                    if not Rec.FindFirst() then begin
                        Rec.Init();
                        Rec."Entry No." += EntryNo;
                        Rec."Shortcut Dimension 6 Code" := 'Adjustment';//trnType
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec."G/L Account Name" := GLAcc.Name; //GL_Description
                        Rec."Transaction No." := 0;//Line No_
                        Rec."Document No." := GLEntry."Document No."; //Document No
                        Rec."Bal. Account No." := '';//Order No
                        Rec."VAT Reporting Date" := 0D; //Order Date
                        Rec."Posting Date" := GLEntry."Posting Date";//Posting Date
                        Rec."External Document No." := GLEntry."External Document No.";
                        Rec."Source No." := GLEntry."Source No.";
                        Rec."Source Code" := '';//Payment Terms Code
                        Rec."Location Code" := GLEntry."Location Code";
                        if Location.get(Rec."Location Code") then begin
                            rec.Description := Location.Name;//Loc_Name
                            Rec."Reason Code" := Location."State Code";//Loc_State_Code
                        end;
                        Rec."Global Dimension 1 Code" := '';//Item Category Code
                        rec."Gen. Prod. Posting Group" := '';//Gen. Prod. Posting Group
                        Rec."Job No." := '';//Posting Group
                        Rec."Global Dimension 2 Code" := '';//Product Group Code
                        Rec."Document Type" := Rec."Document Type"::" ";
                        Rec."Business Unit Code" := '';//Item_no
                        Rec.Comment := '';//Item_desc
                        VLE.Reset();
                        VLE.SetRange("Document No.", GLEntry."Document No.");
                        if VLE.FindFirst() then begin
                            Rec."VAT Bus. Posting Group" := VLE."Buy-from Vendor No.";//Buy-from Vendor Name
                            Rec."VAT Prod. Posting Group" := VLE."Vendor Posting Group";//Vendor Posting Group
                        end;
                        Rec."VAT Amount" := 0;//Unit Cost
                        Rec.Amount := GLEntry.Amount;//Line Amount
                        Rec."Credit Amount" := 0;//Line Discount
                        Rec."Debit Amount" := 0;//Inv_Discount Amount
                        Rec."Add.-Currency Credit Amount" := 0;//Line Discount Amount
                        rec."Add.-Currency Debit Amount" := 0;//GST Base Amount
                        Rec."Shortcut Dimension 3 Code" := '';//GST Customer Type
                        Rec."Shortcut Dimension 4 Code" := '';//GST Group Type
                        Rec."Shortcut Dimension 5 Code" := '';//GST Jurisdiction
                        Rec."Non-Deductible VAT Amount" := GLEntry.Amount;//GL_Amt
                        Rec."Non-Deductible VAT Amount ACY" := 0;//IGST Perc
                        Rec."Additional-Currency Amount" := 0;//IGST Amount
                        Rec.Quantity := 0;//Quantity
                        Rec.Insert();
                    end;
                end;

                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", GLEntry."Document No.");
                PurchInvLine.SetFilter("No.", '<>%1', '');
                if PurchInvLine.FindFirst() then begin
                    Rec.Reset();
                    if GLAcc.Get(GLEntry."G/L Account No.") then
                        Rec.SetRange("G/L Account Name", GLAcc.Name);
                    Rec.SetRange("Posting Date", GLEntry."Posting Date");
                    Rec.SetRange("External Document No.", GLEntry."External Document No.");
                    Rec.SetRange("Document No.", GLEntry."Document No.");
                    Rec.SetRange("Source No.", GLEntry."Source No.");
                    Rec.SetRange("Location Code", GLEntry."Location Code");
                    if Location.get(GLEntry."Location Code") then begin
                        Rec.SetRange(Description, Location.Name);
                        Rec.SetRange("Reason Code", Location."State Code");
                    end;
                    VLE.Reset();
                    VLE.SetRange("Document No.", GLEntry."Document No.");
                    if VLE.FindFirst() then begin
                        Rec.SetRange("VAT Bus. Posting Group", VLE."Buy-from Vendor No.");
                        Rec.SetRange("VAT Prod. Posting Group", VLE."Vendor Posting Group");
                    end;
                    if not Rec.FindFirst() then begin
                        Rec.Init();
                        Rec."Entry No." += EntryNo;
                        Rec."Shortcut Dimension 6 Code" := 'Pur_Invoice';//trnType
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec."G/L Account Name" := GLAcc.Name; //GL_Description
                        Rec."Transaction No." := PurchInvLine."Line No.";//Line No_
                        Rec."Document No." := GLEntry."Document No."; //Document No
                        if PurchInvHead.Get(PurchInvLine."Document No.") then begin
                            Rec."Bal. Account No." := PurchInvHead."Order No.";//Order No
                            Rec."VAT Reporting Date" := PurchInvHead."Order Date"; //Order Date
                            Rec."Source Code" := PurchInvHead."Payment Terms Code";//Payment Terms Code
                            Rec."VAT Bus. Posting Group" := PurchInvHead."Buy-from Vendor No.";//Buy-from Vendor Name
                            Rec."VAT Prod. Posting Group" := PurchInvHead."Vendor Posting Group";//Vendor Posting Group
                            /*GST Customer Type--> need to ask
                            if PurchInvHead."GST Vendor Type" = PurchInvHead."GST Vendor Type"::" " then
                                Rec."Shortcut Dimension 3 Code" := '0'
                                else if PurchInvHead."GST Vendor Type" = PurchInvHead."GST Vendor Type"::Registered then
                                Rec."Shortcut Dimension 3 Code" := '1'
                                else if PurchInvHead."GST Vendor Type" = PurchInvHead."GST Vendor Type"::Unregistered then
                                Rec."Shortcut Dimension 3 Code" := '2'
                                else if PurchInvHead."GST Vendor Type" = PurchInvHead."GST Vendor Type"::Exempted then
                                Rec."Shortcut Dimension 3 Code" := '5'
                                else if PurchInvHead."GST Vendor Type" = PurchInvHead."GST Vendor Type"::SEZ then
                                Rec."Shortcut Dimension 3 Code" := '5'
                            <---GST Customer Type */

                        end;

                        Rec."Posting Date" := GLEntry."Posting Date";//Posting Date
                        Rec."External Document No." := GLEntry."External Document No.";
                        Rec."Source No." := GLEntry."Source No.";

                        Rec."Location Code" := GLEntry."Location Code";
                        if Location.get(Rec."Location Code") then begin
                            rec.Description := Location.Name;//Loc_Name
                            Rec."Reason Code" := Location."State Code";//Loc_State_Code
                        end;
                        Rec."Global Dimension 1 Code" := PurchInvLine."Item Category Code";//Item Category Code
                        rec."Gen. Prod. Posting Group" := PurchInvLine."Gen. Bus. Posting Group";//Gen. Prod. Posting Group
                        Rec."Job No." := PurchInvLine."Posting Group";//Posting Group
                        if Item.Get(PurchInvLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code
                        end;

                        Rec."Document Type" := GLEntry."Document Type";
                        Rec."Business Unit Code" := PurchInvLine."No.";//Item_no
                        Rec.Comment := PurchInvLine.Description;//Item_desc
                                                                //from here--->

                        Rec."VAT Amount" := PurchInvLine."Unit Cost";//Unit Cost
                        Rec.Amount := PurchInvLine.Amount;//Line Amount
                        Rec."Credit Amount" := PurchInvLine."Line Discount %";//Line Discount
                        Rec."Debit Amount" := PurchInvLine."Inv. Discount Amount";//Inv_Discount Amount
                        Rec."Add.-Currency Credit Amount" := PurchInvLine."Line Discount Amount";//Line Discount Amount
                        rec."Add.-Currency Debit Amount" := Cu50200.GetGSTBaseAmtPostedLine(PurchInvLine."Document No.", PurchInvLine."Line No.");//GST Base Amount

                        Rec."Shortcut Dimension 4 Code" := format(PurchInvLine."GST Group Type");//GST Group Type
                        Rec."Shortcut Dimension 5 Code" := format(PurchInvLine."GST Jurisdiction Type");//GST Jurisdiction
                        Rec."Non-Deductible VAT Amount" := GLEntry.Amount;//GL_Amt
                        Rec."Non-Deductible VAT Amount ACY" := Cu50200.PostedLineIGSTPerc(PurchInvLine.RecordId); //IGST Perc
                        Rec."Additional-Currency Amount" := Cu50200.PostedLineIGST(PurchInvLine.RecordId);//IGST Amount
                        Rec.Quantity := PurchInvLine.Quantity;//Quantity
                        Rec.Insert();
                    end;
                end;
            until GLEntry.Next() = 0;
    end;

    var
        GLEntry: Record 17;
        VLE: Record "Vendor Ledger Entry";
        PurchInvHead: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        trnType: Text;
        GLAcc: Record 15;
        Location: Record 14;
        EntryNo: Integer;
        Item: Record 27;
        ItemCategoryCode: Record "Item Category";
        Cu50200: Codeunit 50200;
}
