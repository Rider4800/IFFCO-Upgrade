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
                        /*if GLEntry."G/L Account No." in ['411200020', '411200030'] then begin
                            GLEntryRec := Rec;
                            Rec.Reset();
                            Rec.Init();
                            Rec.TransferFields(GLEntryRec);
                            Rec."Entry No." += EntryNo;
                            Rec.Insert();
                        end;*/
                    end else begin
                        Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                        Rec.Modify();
                    end;
                end;

                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", GLEntry."Document No.");
                PurchInvLine.SetFilter("No.", '<>%1', '');
                if PurchInvLine.FindFirst() then begin
                    Rec.Reset();
                    if GLAcc.Get(GLEntry."G/L Account No.") then
                        Rec.SetRange("G/L Account Name", GLAcc.Name);
                    Rec.SetRange("Transaction No.", PurchInvLine."Line No.");
                    Rec.SetRange("Document No.", GLEntry."Document No.");
                    Rec.SetRange("Posting Date", GLEntry."Posting Date");
                    Rec.SetRange("External Document No.", GLEntry."External Document No.");
                    Rec.SetRange("Source No.", GLEntry."Source No.");
                    Rec.SetRange("Location Code", GLEntry."Location Code");
                    if Location.get(GLEntry."Location Code") then begin
                        Rec.SetRange(Description, Location.Name);
                        Rec.SetRange("Reason Code", Location."State Code");
                    end;
                    Rec.SetRange("Global Dimension 1 Code", PurchInvLine."Item Category Code");//Item Category Code
                    Rec.SetRange("Gen. Prod. Posting Group", PurchInvLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                    Rec.SetRange("Job No.", PurchInvLine."Posting Group");//Posting Group
                    if Item.Get(PurchInvLine."No.") then begin
                        ItemCategoryCode.Reset();
                        ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                        ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                        if ItemCategoryCode.findfirst then
                            Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                    end;
                    Rec.SetRange(Rec.Quantity, PurchInvLine.Quantity);
                    Rec.SetRange("Document Type", GLEntry."Document Type");
                    Rec.SetRange("Business Unit Code", PurchInvLine."No.");
                    if PurchInvHead.Get(PurchInvLine."Document No.") then begin
                        Rec.SetRange("Bal. Account No.", PurchInvHead."Order No.");//Order No
                        Rec.SetRange("VAT Reporting Date", PurchInvHead."Order Date"); //Order Date
                        Rec.SetRange("Source Code", PurchInvHead."Payment Terms Code");//Payment Terms Code
                        Rec.SetRange("VAT Bus. Posting Group", PurchInvHead."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                        Rec.SetRange("VAT Prod. Posting Group", PurchInvHead."Vendor Posting Group");//Vendor Posting Group
                        Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchInvHead."GST Vendor Type"));//GST Customer Type
                    end;
                    Rec.SetRange(Amount, PurchInvLine.Amount);
                    Rec.SetRange("Credit Amount", PurchInvLine."Line Discount %");//Line Discount
                    Rec.SetRange("Debit Amount", PurchInvLine."Inv. Discount Amount");//Inv_Discount Amount
                    Rec.SetRange("Add.-Currency Credit Amount", PurchInvLine."Line Discount Amount");//Line Discount Amount
                    Rec.SetRange(Rec."VAT Amount", PurchInvLine."Unit Cost");//Unit Cost
                    Rec.SetRange(Comment, PurchInvLine.Description);
                    Rec.SetRange("Shortcut Dimension 4 Code", format(PurchInvLine."GST Group Type"));//GST Group Type
                    Rec.SetRange("Shortcut Dimension 5 Code", format(PurchInvLine."GST Jurisdiction Type"));//GST Jurisdiction
                    Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchInvLine.RecordId)); //IGST Perc
                    Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchInvLine.RecordId));//IGST Amount
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
                            Rec."VAT Bus. Posting Group" := PurchInvHead."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                            Rec."VAT Prod. Posting Group" := PurchInvHead."Vendor Posting Group";//Vendor Posting Group
                            Rec."Shortcut Dimension 3 Code" := Format(PurchInvHead."GST Vendor Type");//GST Customer Type
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
                        rec."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                        Rec."Job No." := PurchInvLine."Posting Group";//Posting Group
                        if Item.Get(PurchInvLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                        end;

                        Rec."Document Type" := GLEntry."Document Type";
                        Rec."Business Unit Code" := PurchInvLine."No.";//Item_no
                        Rec.Comment := PurchInvLine.Description;//Item_desc
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
                    end else begin
                        Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                        Rec.Modify();
                    end;
                end;

                PurchCrMemoLine.Reset();
                PurchCrMemoLine.SetRange("Document No.", GLEntry."Document No.");
                PurchCrMemoLine.SetFilter("No.", '<>%1', '');
                if PurchCrMemoLine.FindFirst() then begin
                    //Pur_Dr_Note--->

                    Rec.Reset();
                    if GLAcc.Get(GLEntry."G/L Account No.") then
                        Rec.SetRange("G/L Account Name", GLAcc.Name); //name
                    Rec.SetRange("Transaction No.", PurchCrMemoLine."Line No.");
                    Rec.SetRange("Document No.", GLEntry."Document No.");
                    Rec.SetRange("Posting Date", GLEntry."Posting Date");
                    Rec.SetRange("External Document No.", GLEntry."External Document No.");
                    Rec.SetRange("Source No.", GLEntry."Source No.");
                    Rec.SetRange("Location Code", GLEntry."Location Code");
                    if Location.get(GLEntry."Location Code") then begin
                        Rec.SetRange(Description, Location.Name);
                        Rec.SetRange("Reason Code", Location."State Code");
                    end;
                    Rec.SetRange("Global Dimension 1 Code", PurchCrMemoLine."Item Category Code");//Item Category Code
                    Rec.SetRange("Gen. Prod. Posting Group", PurchCrMemoLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                    Rec.SetRange("Job No.", PurchCrMemoLine."Posting Group");//Posting Group
                    if Item.Get(PurchCrMemoLine."No.") then begin
                        ItemCategoryCode.Reset();
                        ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                        ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                        if ItemCategoryCode.findfirst then
                            Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                    end;
                    Rec.SetRange(Rec.Quantity, PurchCrMemoLine.Quantity);
                    Rec.SetRange("Document Type", GLEntry."Document Type");
                    Rec.SetRange("Business Unit Code", PurchCrMemoLine."No.");
                    if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                        Rec.SetRange("Source Code", PurchCrMemoHdr."Payment Terms Code");//Payment Terms Code
                        Rec.SetRange("VAT Bus. Posting Group", PurchCrMemoHdr."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                        Rec.SetRange("VAT Prod. Posting Group", PurchCrMemoHdr."Vendor Posting Group");//Vendor Posting Group
                        Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchCrMemoHdr."GST Vendor Type"));//GST Customer Type
                    end;
                    Rec.SetRange(Amount, PurchCrMemoLine.Amount);
                    Rec.SetRange("Credit Amount", PurchCrMemoLine."Line Discount %");//Line Discount
                    Rec.SetRange("Debit Amount", PurchCrMemoLine."Inv. Discount Amount");//Inv_Discount Amount
                    Rec.SetRange("Add.-Currency Credit Amount", PurchCrMemoLine."Line Discount Amount");//Line Discount Amount
                    Rec.SetRange(Rec."VAT Amount", PurchCrMemoLine."Unit Cost");//Unit Cost
                    Rec.SetRange(Comment, PurchCrMemoLine.Description);
                    Rec.SetRange("Shortcut Dimension 4 Code", format(PurchCrMemoLine."GST Group Type"));//GST Group Type
                    Rec.SetRange("Shortcut Dimension 5 Code", format(PurchCrMemoLine."GST Jurisdiction Type"));//GST Jurisdiction
                    Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId)); //IGST Perc
                    Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId));//IGST Amount
                    if not Rec.FindFirst() then begin
                        Rec.Init();
                        Rec."Entry No." += EntryNo;
                        Rec."Shortcut Dimension 6 Code" := 'Pur_Dr_Note';//trnType
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec."G/L Account Name" := GLAcc.Name; //GL_Description
                        Rec."Transaction No." := PurchCrMemoLine."Line No.";//Line No_
                        Rec."Document No." := GLEntry."Document No."; //Document No
                        Rec."Bal. Account No." := '';//Order No
                        Rec."VAT Reporting Date" := 0D; //Order Date
                        if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                            Rec."Source Code" := PurchCrMemoHdr."Payment Terms Code";//Payment Terms Code
                            Rec."VAT Bus. Posting Group" := PurchCrMemoHdr."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                            Rec."VAT Prod. Posting Group" := PurchCrMemoHdr."Vendor Posting Group";//Vendor Posting Group
                            Rec."Shortcut Dimension 3 Code" := Format(PurchCrMemoHdr."GST Vendor Type");//GST Customer Type
                        end;

                        Rec."Posting Date" := GLEntry."Posting Date";//Posting Date
                        Rec."External Document No." := GLEntry."External Document No.";
                        Rec."Source No." := GLEntry."Source No.";

                        Rec."Location Code" := GLEntry."Location Code";
                        if Location.get(Rec."Location Code") then begin
                            rec.Description := Location.Name;//Loc_Name
                            Rec."Reason Code" := Location."State Code";//Loc_State_Code
                        end;
                        Rec."Global Dimension 1 Code" := PurchCrMemoLine."Item Category Code";//Item Category Code
                        rec."Gen. Prod. Posting Group" := PurchCrMemoLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                        Rec."Job No." := PurchCrMemoLine."Posting Group";//Posting Group
                        if Item.Get(PurchCrMemoLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                        end;

                        Rec."Document Type" := GLEntry."Document Type";
                        Rec."Business Unit Code" := PurchCrMemoLine."No.";//Item_no
                        Rec.Comment := PurchCrMemoLine.Description;//Item_desc
                        Rec."VAT Amount" := PurchCrMemoLine."Unit Cost";//Unit Cost
                        Rec.Amount := -1 * PurchCrMemoLine.Amount;//Line Amount
                        Rec."Credit Amount" := PurchCrMemoLine."Line Discount %";//Line Discount
                        Rec."Debit Amount" := PurchCrMemoLine."Inv. Discount Amount";//Inv_Discount Amount
                        Rec."Add.-Currency Credit Amount" := PurchCrMemoLine."Line Discount Amount";//Line Discount Amount
                        rec."Add.-Currency Debit Amount" := Cu50200.GetGSTBaseAmtPostedLine(PurchCrMemoLine."Document No.", PurchCrMemoLine."Line No.");//GST Base Amount

                        Rec."Shortcut Dimension 4 Code" := format(PurchCrMemoLine."GST Group Type");//GST Group Type
                        Rec."Shortcut Dimension 5 Code" := format(PurchCrMemoLine."GST Jurisdiction Type");//GST Jurisdiction
                        Rec."Non-Deductible VAT Amount" := GLEntry.Amount;//GL_Amt
                        Rec."Non-Deductible VAT Amount ACY" := Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId); //IGST Perc
                        Rec."Additional-Currency Amount" := Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId);//IGST Amount
                        Rec.Quantity := PurchCrMemoLine.Quantity;//Quantity
                        Rec.Insert();
                    end else begin
                        Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                        Rec.Modify();
                    end;
                    //<--Pur_Dr_Note

                    //--->Adjustment
                    if (GLEntry."Document Type" in [GLEntry."Document Type"::" ", GLEntry."Document Type"::Refund])
                    and (GLEntry."G/L Account No." = '411200010') then begin
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
                            Rec."Document Type" := Rec."Document Type";
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
                        end else begin
                            Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                            Rec.Modify();
                        end;
                    end;

                    //<---Adjustment

                    //Pur_Inv---->
                    if GLEntry."G/L Account No." = '411200010' then begin
                        PurchInvLine.Reset();
                        PurchInvLine.SetRange("Document No.", GLEntry."Document No.");
                        PurchInvLine.SetFilter("No.", '<>%1', '');
                        if PurchInvLine.FindFirst() then begin
                            Rec.Reset();
                            if GLAcc.Get(GLEntry."G/L Account No.") then
                                Rec.SetRange("G/L Account Name", GLAcc.Name);
                            Rec.SetRange("Transaction No.", PurchInvLine."Line No.");
                            Rec.SetRange("Document No.", GLEntry."Document No.");
                            Rec.SetRange("Posting Date", GLEntry."Posting Date");
                            Rec.SetRange("External Document No.", GLEntry."External Document No.");
                            Rec.SetRange("Source No.", GLEntry."Source No.");
                            Rec.SetRange("Location Code", GLEntry."Location Code");
                            if Location.get(GLEntry."Location Code") then begin
                                Rec.SetRange(Description, Location.Name);
                                Rec.SetRange("Reason Code", Location."State Code");
                            end;
                            Rec.SetRange("Global Dimension 1 Code", PurchInvLine."Item Category Code");//Item Category Code
                            Rec.SetRange("Gen. Prod. Posting Group", PurchInvLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                            Rec.SetRange("Job No.", PurchInvLine."Posting Group");//Posting Group
                            if Item.Get(PurchInvLine."No.") then begin
                                ItemCategoryCode.Reset();
                                ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                if ItemCategoryCode.findfirst then
                                    Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                            end;
                            Rec.SetRange(Rec.Quantity, PurchInvLine.Quantity);
                            Rec.SetRange("Document Type", GLEntry."Document Type");
                            Rec.SetRange("Business Unit Code", PurchInvLine."No.");
                            if PurchInvHead.Get(PurchInvLine."Document No.") then begin
                                Rec.SetRange("Bal. Account No.", PurchInvHead."Order No.");//Order No
                                Rec.SetRange("VAT Reporting Date", PurchInvHead."Order Date"); //Order Date
                                Rec.SetRange("Source Code", PurchInvHead."Payment Terms Code");//Payment Terms Code
                                Rec.SetRange("VAT Bus. Posting Group", PurchInvHead."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                                Rec.SetRange("VAT Prod. Posting Group", PurchInvHead."Vendor Posting Group");//Vendor Posting Group
                                Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchInvHead."GST Vendor Type"));//GST Customer Type
                            end;
                            Rec.SetRange(Amount, PurchInvLine.Amount);
                            Rec.SetRange("Credit Amount", PurchInvLine."Line Discount %");//Line Discount
                            Rec.SetRange("Debit Amount", PurchInvLine."Inv. Discount Amount");//Inv_Discount Amount
                            Rec.SetRange("Add.-Currency Credit Amount", PurchInvLine."Line Discount Amount");//Line Discount Amount
                            Rec.SetRange(Rec."VAT Amount", PurchInvLine."Unit Cost");//Unit Cost
                            Rec.SetRange(Comment, PurchInvLine.Description);
                            Rec.SetRange("Shortcut Dimension 4 Code", format(PurchInvLine."GST Group Type"));//GST Group Type
                            Rec.SetRange("Shortcut Dimension 5 Code", format(PurchInvLine."GST Jurisdiction Type"));//GST Jurisdiction
                            Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchInvLine.RecordId)); //IGST Perc
                            Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchInvLine.RecordId));//IGST Amount
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
                                    Rec."VAT Bus. Posting Group" := PurchInvHead."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                                    Rec."VAT Prod. Posting Group" := PurchInvHead."Vendor Posting Group";//Vendor Posting Group
                                    Rec."Shortcut Dimension 3 Code" := Format(PurchInvHead."GST Vendor Type");//GST Customer Type
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
                                rec."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                                Rec."Job No." := PurchInvLine."Posting Group";//Posting Group
                                if Item.Get(PurchInvLine."No.") then begin
                                    ItemCategoryCode.Reset();
                                    ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                    ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                    if ItemCategoryCode.findfirst then
                                        Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                                end;

                                Rec."Document Type" := GLEntry."Document Type";
                                Rec."Business Unit Code" := PurchInvLine."No.";//Item_no
                                Rec.Comment := PurchInvLine.Description;//Item_desc
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
                            end else begin
                                Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                                Rec.Modify();
                            end;
                        end;

                    end;

                    //<---Pur_Inv

                    //-->Pur_Dr_Note
                    if GLEntry."G/L Account No." = '411200010' then begin
                        PurchCrMemoLine.Reset();
                        PurchCrMemoLine.SetRange("Document No.", GLEntry."Document No.");
                        PurchCrMemoLine.SetFilter("No.", '<>%1', '');
                        if PurchCrMemoLine.FindFirst() then begin
                            //Pur_Dr_Note--->

                            Rec.Reset();
                            if GLAcc.Get(GLEntry."G/L Account No.") then
                                Rec.SetRange("G/L Account Name", GLAcc.Name); //name
                            Rec.SetRange("Transaction No.", PurchCrMemoLine."Line No.");
                            Rec.SetRange("Document No.", GLEntry."Document No.");
                            Rec.SetRange("Posting Date", GLEntry."Posting Date");
                            Rec.SetRange("External Document No.", GLEntry."External Document No.");
                            Rec.SetRange("Source No.", GLEntry."Source No.");
                            Rec.SetRange("Location Code", GLEntry."Location Code");
                            if Location.get(GLEntry."Location Code") then begin
                                Rec.SetRange(Description, Location.Name);
                                Rec.SetRange("Reason Code", Location."State Code");
                            end;
                            Rec.SetRange("Global Dimension 1 Code", PurchCrMemoLine."Item Category Code");//Item Category Code
                            Rec.SetRange("Gen. Prod. Posting Group", PurchCrMemoLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                            Rec.SetRange("Job No.", PurchCrMemoLine."Posting Group");//Posting Group
                            if Item.Get(PurchCrMemoLine."No.") then begin
                                ItemCategoryCode.Reset();
                                ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                if ItemCategoryCode.findfirst then
                                    Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                            end;
                            Rec.SetRange(Rec.Quantity, PurchCrMemoLine.Quantity);
                            Rec.SetRange("Document Type", GLEntry."Document Type");
                            Rec.SetRange("Business Unit Code", PurchCrMemoLine."No.");
                            if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                                Rec.SetRange("Source Code", PurchCrMemoHdr."Payment Terms Code");//Payment Terms Code
                                Rec.SetRange("VAT Bus. Posting Group", PurchCrMemoHdr."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                                Rec.SetRange("VAT Prod. Posting Group", PurchCrMemoHdr."Vendor Posting Group");//Vendor Posting Group
                                Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchCrMemoHdr."GST Vendor Type"));//GST Customer Type
                            end;
                            Rec.SetRange(Amount, PurchCrMemoLine.Amount);
                            Rec.SetRange("Credit Amount", PurchCrMemoLine."Line Discount %");//Line Discount
                            Rec.SetRange("Debit Amount", PurchCrMemoLine."Inv. Discount Amount");//Inv_Discount Amount
                            Rec.SetRange("Add.-Currency Credit Amount", PurchCrMemoLine."Line Discount Amount");//Line Discount Amount
                            Rec.SetRange(Rec."VAT Amount", PurchCrMemoLine."Unit Cost");//Unit Cost
                            Rec.SetRange(Comment, PurchCrMemoLine.Description);
                            Rec.SetRange("Shortcut Dimension 4 Code", format(PurchCrMemoLine."GST Group Type"));//GST Group Type
                            Rec.SetRange("Shortcut Dimension 5 Code", format(PurchCrMemoLine."GST Jurisdiction Type"));//GST Jurisdiction
                            Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId)); //IGST Perc
                            Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId));//IGST Amount
                            if not Rec.FindFirst() then begin
                                Rec.Init();
                                Rec."Entry No." += EntryNo;
                                Rec."Shortcut Dimension 6 Code" := 'Pur_Dr_Note';//trnType
                                if GLAcc.Get(GLEntry."G/L Account No.") then
                                    Rec."G/L Account Name" := GLAcc.Name; //GL_Description
                                Rec."Transaction No." := PurchCrMemoLine."Line No.";//Line No_
                                Rec."Document No." := GLEntry."Document No."; //Document No
                                Rec."Bal. Account No." := '';//Order No
                                Rec."VAT Reporting Date" := 0D; //Order Date
                                if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                                    Rec."Source Code" := PurchCrMemoHdr."Payment Terms Code";//Payment Terms Code
                                    Rec."VAT Bus. Posting Group" := PurchCrMemoHdr."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                                    Rec."VAT Prod. Posting Group" := PurchCrMemoHdr."Vendor Posting Group";//Vendor Posting Group
                                    Rec."Shortcut Dimension 3 Code" := Format(PurchCrMemoHdr."GST Vendor Type");//GST Customer Type
                                end;

                                Rec."Posting Date" := GLEntry."Posting Date";//Posting Date
                                Rec."External Document No." := GLEntry."External Document No.";
                                Rec."Source No." := GLEntry."Source No.";

                                Rec."Location Code" := GLEntry."Location Code";
                                if Location.get(Rec."Location Code") then begin
                                    rec.Description := Location.Name;//Loc_Name
                                    Rec."Reason Code" := Location."State Code";//Loc_State_Code
                                end;
                                Rec."Global Dimension 1 Code" := PurchCrMemoLine."Item Category Code";//Item Category Code
                                rec."Gen. Prod. Posting Group" := PurchCrMemoLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                                Rec."Job No." := PurchCrMemoLine."Posting Group";//Posting Group
                                if Item.Get(PurchCrMemoLine."No.") then begin
                                    ItemCategoryCode.Reset();
                                    ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                    ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                    if ItemCategoryCode.findfirst then
                                        Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                                end;

                                Rec."Document Type" := GLEntry."Document Type";
                                Rec."Business Unit Code" := PurchCrMemoLine."No.";//Item_no
                                Rec.Comment := PurchCrMemoLine.Description;//Item_desc
                                Rec."VAT Amount" := PurchCrMemoLine."Unit Cost";//Unit Cost
                                Rec.Amount := -1 * PurchCrMemoLine.Amount;//Line Amount
                                Rec."Credit Amount" := PurchCrMemoLine."Line Discount %";//Line Discount
                                Rec."Debit Amount" := PurchCrMemoLine."Inv. Discount Amount";//Inv_Discount Amount
                                Rec."Add.-Currency Credit Amount" := PurchCrMemoLine."Line Discount Amount";//Line Discount Amount
                                rec."Add.-Currency Debit Amount" := Cu50200.GetGSTBaseAmtPostedLine(PurchCrMemoLine."Document No.", PurchCrMemoLine."Line No.");//GST Base Amount

                                Rec."Shortcut Dimension 4 Code" := format(PurchCrMemoLine."GST Group Type");//GST Group Type
                                Rec."Shortcut Dimension 5 Code" := format(PurchCrMemoLine."GST Jurisdiction Type");//GST Jurisdiction
                                Rec."Non-Deductible VAT Amount" := GLEntry.Amount;//GL_Amt
                                Rec."Non-Deductible VAT Amount ACY" := Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId); //IGST Perc
                                Rec."Additional-Currency Amount" := Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId);//IGST Amount
                                Rec.Quantity := PurchCrMemoLine.Quantity;//Quantity
                                Rec.Insert();
                            end else begin
                                Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                                Rec.Modify();
                            end;
                            //<--Pur_Dr_Note

                        end;
                        //<---Pur_Dr_Note
                    end;

                end;

                //Adjustment--->
                if (GLEntry."G/L Account No." in ['411200020', '411200030']) and (GLEntry."Document Type" in [GLEntry."Document Type"::" ", GLEntry."Document Type"::Refund]) then begin
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
                        /*if GLEntry."G/L Account No." in ['411200020', '411200030'] then begin
                            GLEntryRec := Rec;
                            Rec.Reset();
                            Rec.Init();
                            Rec.TransferFields(GLEntryRec);
                            Rec."Entry No." += EntryNo;
                            Rec.Insert();
                        end;*/
                    end else begin
                        Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                        Rec.Modify();
                    end;
                end;
                //<----Adjustment

                //--->Pur_Invoice
                if GLEntry."G/L Account No." in ['411200020', '411200030'] then begin
                    PurchInvLine.Reset();
                    PurchInvLine.SetRange("Document No.", GLEntry."Document No.");
                    PurchInvLine.SetFilter("No.", '<>%1', '');
                    if PurchInvLine.FindFirst() then begin
                        Rec.Reset();
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec.SetRange("G/L Account Name", GLAcc.Name);
                        Rec.SetRange("Transaction No.", PurchInvLine."Line No.");
                        Rec.SetRange("Document No.", GLEntry."Document No.");
                        Rec.SetRange("Posting Date", GLEntry."Posting Date");
                        Rec.SetRange("External Document No.", GLEntry."External Document No.");
                        Rec.SetRange("Source No.", GLEntry."Source No.");
                        Rec.SetRange("Location Code", GLEntry."Location Code");
                        if Location.get(GLEntry."Location Code") then begin
                            Rec.SetRange(Description, Location.Name);
                            Rec.SetRange("Reason Code", Location."State Code");
                        end;
                        Rec.SetRange("Global Dimension 1 Code", PurchInvLine."Item Category Code");//Item Category Code
                        Rec.SetRange("Gen. Prod. Posting Group", PurchInvLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                        Rec.SetRange("Job No.", PurchInvLine."Posting Group");//Posting Group
                        if Item.Get(PurchInvLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                        end;
                        Rec.SetRange(Rec.Quantity, PurchInvLine.Quantity);
                        Rec.SetRange("Document Type", GLEntry."Document Type");
                        Rec.SetRange("Business Unit Code", PurchInvLine."No.");
                        if PurchInvHead.Get(PurchInvLine."Document No.") then begin
                            Rec.SetRange("Bal. Account No.", PurchInvHead."Order No.");//Order No
                            Rec.SetRange("VAT Reporting Date", PurchInvHead."Order Date"); //Order Date
                            Rec.SetRange("Source Code", PurchInvHead."Payment Terms Code");//Payment Terms Code
                            Rec.SetRange("VAT Bus. Posting Group", PurchInvHead."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                            Rec.SetRange("VAT Prod. Posting Group", PurchInvHead."Vendor Posting Group");//Vendor Posting Group
                            Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchInvHead."GST Vendor Type"));//GST Customer Type
                        end;
                        Rec.SetRange(Amount, PurchInvLine.Amount);
                        Rec.SetRange("Credit Amount", PurchInvLine."Line Discount %");//Line Discount
                        Rec.SetRange("Debit Amount", PurchInvLine."Inv. Discount Amount");//Inv_Discount Amount
                        Rec.SetRange("Add.-Currency Credit Amount", PurchInvLine."Line Discount Amount");//Line Discount Amount
                        Rec.SetRange(Rec."VAT Amount", PurchInvLine."Unit Cost");//Unit Cost
                        Rec.SetRange(Comment, PurchInvLine.Description);
                        Rec.SetRange("Shortcut Dimension 4 Code", format(PurchInvLine."GST Group Type"));//GST Group Type
                        Rec.SetRange("Shortcut Dimension 5 Code", format(PurchInvLine."GST Jurisdiction Type"));//GST Jurisdiction
                        Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchInvLine.RecordId)); //IGST Perc
                        Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchInvLine.RecordId));//IGST Amount
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
                                Rec."VAT Bus. Posting Group" := PurchInvHead."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                                Rec."VAT Prod. Posting Group" := PurchInvHead."Vendor Posting Group";//Vendor Posting Group
                                Rec."Shortcut Dimension 3 Code" := Format(PurchInvHead."GST Vendor Type");//GST Customer Type
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
                            rec."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                            Rec."Job No." := PurchInvLine."Posting Group";//Posting Group
                            if Item.Get(PurchInvLine."No.") then begin
                                ItemCategoryCode.Reset();
                                ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                if ItemCategoryCode.findfirst then
                                    Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                            end;

                            Rec."Document Type" := GLEntry."Document Type";
                            Rec."Business Unit Code" := PurchInvLine."No.";//Item_no
                            Rec.Comment := PurchInvLine.Description;//Item_desc
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
                        end else begin
                            Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                            Rec.Modify();
                        end;
                    end;

                end;
                //<---Pur_Invoice


                //---->Pur_Dr_Note
                if GLEntry."G/L Account No." in ['411200020', '411200030'] then begin
                    PurchCrMemoLine.Reset();
                    PurchCrMemoLine.SetRange("Document No.", GLEntry."Document No.");
                    PurchCrMemoLine.SetFilter("No.", '<>%1', '');
                    if PurchCrMemoLine.FindFirst() then begin
                        Rec.Reset();
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec.SetRange("G/L Account Name", GLAcc.Name); //name
                        Rec.SetRange("Transaction No.", PurchCrMemoLine."Line No.");
                        Rec.SetRange("Document No.", GLEntry."Document No.");
                        Rec.SetRange("Posting Date", GLEntry."Posting Date");
                        Rec.SetRange("External Document No.", GLEntry."External Document No.");
                        Rec.SetRange("Source No.", GLEntry."Source No.");
                        Rec.SetRange("Location Code", GLEntry."Location Code");
                        if Location.get(GLEntry."Location Code") then begin
                            Rec.SetRange(Description, Location.Name);
                            Rec.SetRange("Reason Code", Location."State Code");
                        end;
                        Rec.SetRange("Global Dimension 1 Code", PurchCrMemoLine."Item Category Code");//Item Category Code
                        Rec.SetRange("Gen. Prod. Posting Group", PurchCrMemoLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                        Rec.SetRange("Job No.", PurchCrMemoLine."Posting Group");//Posting Group
                        if Item.Get(PurchCrMemoLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                        end;
                        Rec.SetRange(Rec.Quantity, PurchCrMemoLine.Quantity);
                        Rec.SetRange("Document Type", GLEntry."Document Type");
                        Rec.SetRange("Business Unit Code", PurchCrMemoLine."No.");
                        if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                            Rec.SetRange("Source Code", PurchCrMemoHdr."Payment Terms Code");//Payment Terms Code
                            Rec.SetRange("VAT Bus. Posting Group", PurchCrMemoHdr."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                            Rec.SetRange("VAT Prod. Posting Group", PurchCrMemoHdr."Vendor Posting Group");//Vendor Posting Group
                            Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchCrMemoHdr."GST Vendor Type"));//GST Customer Type
                        end;
                        Rec.SetRange(Amount, PurchCrMemoLine.Amount);
                        Rec.SetRange("Credit Amount", PurchCrMemoLine."Line Discount %");//Line Discount
                        Rec.SetRange("Debit Amount", PurchCrMemoLine."Inv. Discount Amount");//Inv_Discount Amount
                        Rec.SetRange("Add.-Currency Credit Amount", PurchCrMemoLine."Line Discount Amount");//Line Discount Amount
                        Rec.SetRange(Rec."VAT Amount", PurchCrMemoLine."Unit Cost");//Unit Cost
                        Rec.SetRange(Comment, PurchCrMemoLine.Description);
                        Rec.SetRange("Shortcut Dimension 4 Code", format(PurchCrMemoLine."GST Group Type"));//GST Group Type
                        Rec.SetRange("Shortcut Dimension 5 Code", format(PurchCrMemoLine."GST Jurisdiction Type"));//GST Jurisdiction
                        Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId)); //IGST Perc
                        Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId));//IGST Amount
                        if not Rec.FindFirst() then begin
                            Rec.Init();
                            Rec."Entry No." += EntryNo;
                            Rec."Shortcut Dimension 6 Code" := 'Pur_Dr_Note';//trnType
                            if GLAcc.Get(GLEntry."G/L Account No.") then
                                Rec."G/L Account Name" := GLAcc.Name; //GL_Description
                            Rec."Transaction No." := PurchCrMemoLine."Line No.";//Line No_
                            Rec."Document No." := GLEntry."Document No."; //Document No
                            Rec."Bal. Account No." := '';//Order No
                            Rec."VAT Reporting Date" := 0D; //Order Date
                            if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                                Rec."Source Code" := PurchCrMemoHdr."Payment Terms Code";//Payment Terms Code
                                Rec."VAT Bus. Posting Group" := PurchCrMemoHdr."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                                Rec."VAT Prod. Posting Group" := PurchCrMemoHdr."Vendor Posting Group";//Vendor Posting Group
                                Rec."Shortcut Dimension 3 Code" := Format(PurchCrMemoHdr."GST Vendor Type");//GST Customer Type
                            end;

                            Rec."Posting Date" := GLEntry."Posting Date";//Posting Date
                            Rec."External Document No." := GLEntry."External Document No.";
                            Rec."Source No." := GLEntry."Source No.";

                            Rec."Location Code" := GLEntry."Location Code";
                            if Location.get(Rec."Location Code") then begin
                                rec.Description := Location.Name;//Loc_Name
                                Rec."Reason Code" := Location."State Code";//Loc_State_Code
                            end;
                            Rec."Global Dimension 1 Code" := PurchCrMemoLine."Item Category Code";//Item Category Code
                            rec."Gen. Prod. Posting Group" := PurchCrMemoLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                            Rec."Job No." := PurchCrMemoLine."Posting Group";//Posting Group
                            if Item.Get(PurchCrMemoLine."No.") then begin
                                ItemCategoryCode.Reset();
                                ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                if ItemCategoryCode.findfirst then
                                    Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                            end;

                            Rec."Document Type" := GLEntry."Document Type";
                            Rec."Business Unit Code" := PurchCrMemoLine."No.";//Item_no
                            Rec.Comment := PurchCrMemoLine.Description;//Item_desc
                            Rec."VAT Amount" := PurchCrMemoLine."Unit Cost";//Unit Cost
                            Rec.Amount := -1 * PurchCrMemoLine.Amount;//Line Amount
                            Rec."Credit Amount" := PurchCrMemoLine."Line Discount %";//Line Discount
                            Rec."Debit Amount" := PurchCrMemoLine."Inv. Discount Amount";//Inv_Discount Amount
                            Rec."Add.-Currency Credit Amount" := PurchCrMemoLine."Line Discount Amount";//Line Discount Amount
                            rec."Add.-Currency Debit Amount" := Cu50200.GetGSTBaseAmtPostedLine(PurchCrMemoLine."Document No.", PurchCrMemoLine."Line No.");//GST Base Amount

                            Rec."Shortcut Dimension 4 Code" := format(PurchCrMemoLine."GST Group Type");//GST Group Type
                            Rec."Shortcut Dimension 5 Code" := format(PurchCrMemoLine."GST Jurisdiction Type");//GST Jurisdiction
                            Rec."Non-Deductible VAT Amount" := GLEntry.Amount;//GL_Amt
                            Rec."Non-Deductible VAT Amount ACY" := Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId); //IGST Perc
                            Rec."Additional-Currency Amount" := Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId);//IGST Amount
                            Rec.Quantity := PurchCrMemoLine.Quantity;//Quantity
                            Rec.Insert();
                        end else begin
                            Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                            Rec.Modify();
                        end;

                    end
                end;
            //<----Pur_Dr_Note


             //Adjustment--->
                if (GLEntry."G/L Account No." = '411300010') and (GLEntry."Document Type" in [GLEntry."Document Type"::" ", GLEntry."Document Type"::Refund]) then begin
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
                        /*if GLEntry."G/L Account No." in ['411200020', '411200030'] then begin
                            GLEntryRec := Rec;
                            Rec.Reset();
                            Rec.Init();
                            Rec.TransferFields(GLEntryRec);
                            Rec."Entry No." += EntryNo;
                            Rec.Insert();
                        end;*/
                    end else begin
                        Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                        Rec.Modify();
                    end;
                end;
                //<----Adjustment

                //--->Pur_Invoice
                if (GLEntry."G/L Account No." = '411300010') then begin
                    PurchInvLine.Reset();
                    PurchInvLine.SetRange("Document No.", GLEntry."Document No.");
                    PurchInvLine.SetFilter("No.", '<>%1', '');
                    if PurchInvLine.FindFirst() then begin
                        Rec.Reset();
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec.SetRange("G/L Account Name", GLAcc.Name);
                        Rec.SetRange("Transaction No.", PurchInvLine."Line No.");
                        Rec.SetRange("Document No.", GLEntry."Document No.");
                        Rec.SetRange("Posting Date", GLEntry."Posting Date");
                        Rec.SetRange("External Document No.", GLEntry."External Document No.");
                        Rec.SetRange("Source No.", GLEntry."Source No.");
                        Rec.SetRange("Location Code", GLEntry."Location Code");
                        if Location.get(GLEntry."Location Code") then begin
                            Rec.SetRange(Description, Location.Name);
                            Rec.SetRange("Reason Code", Location."State Code");
                        end;
                        Rec.SetRange("Global Dimension 1 Code", PurchInvLine."Item Category Code");//Item Category Code
                        Rec.SetRange("Gen. Prod. Posting Group", PurchInvLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                        Rec.SetRange("Job No.", PurchInvLine."Posting Group");//Posting Group
                        if Item.Get(PurchInvLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                        end;
                        Rec.SetRange(Rec.Quantity, PurchInvLine.Quantity);
                        Rec.SetRange("Document Type", GLEntry."Document Type");
                        Rec.SetRange("Business Unit Code", PurchInvLine."No.");
                        if PurchInvHead.Get(PurchInvLine."Document No.") then begin
                            Rec.SetRange("Bal. Account No.", PurchInvHead."Order No.");//Order No
                            Rec.SetRange("VAT Reporting Date", PurchInvHead."Order Date"); //Order Date
                            Rec.SetRange("Source Code", PurchInvHead."Payment Terms Code");//Payment Terms Code
                            Rec.SetRange("VAT Bus. Posting Group", PurchInvHead."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                            Rec.SetRange("VAT Prod. Posting Group", PurchInvHead."Vendor Posting Group");//Vendor Posting Group
                            Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchInvHead."GST Vendor Type"));//GST Customer Type
                        end;
                        Rec.SetRange(Amount, PurchInvLine.Amount);
                        Rec.SetRange("Credit Amount", PurchInvLine."Line Discount %");//Line Discount
                        Rec.SetRange("Debit Amount", PurchInvLine."Inv. Discount Amount");//Inv_Discount Amount
                        Rec.SetRange("Add.-Currency Credit Amount", PurchInvLine."Line Discount Amount");//Line Discount Amount
                        Rec.SetRange(Rec."VAT Amount", PurchInvLine."Unit Cost");//Unit Cost
                        Rec.SetRange(Comment, PurchInvLine.Description);
                        Rec.SetRange("Shortcut Dimension 4 Code", format(PurchInvLine."GST Group Type"));//GST Group Type
                        Rec.SetRange("Shortcut Dimension 5 Code", format(PurchInvLine."GST Jurisdiction Type"));//GST Jurisdiction
                        Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchInvLine.RecordId)); //IGST Perc
                        Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchInvLine.RecordId));//IGST Amount
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
                                Rec."VAT Bus. Posting Group" := PurchInvHead."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                                Rec."VAT Prod. Posting Group" := PurchInvHead."Vendor Posting Group";//Vendor Posting Group
                                Rec."Shortcut Dimension 3 Code" := Format(PurchInvHead."GST Vendor Type");//GST Customer Type
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
                            rec."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                            Rec."Job No." := PurchInvLine."Posting Group";//Posting Group
                            if Item.Get(PurchInvLine."No.") then begin
                                ItemCategoryCode.Reset();
                                ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                if ItemCategoryCode.findfirst then
                                    Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                            end;

                            Rec."Document Type" := GLEntry."Document Type";
                            Rec."Business Unit Code" := PurchInvLine."No.";//Item_no
                            Rec.Comment := PurchInvLine.Description;//Item_desc
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
                        end else begin
                            Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                            Rec.Modify();
                        end;
                    end;

                end;
                //<---Pur_Invoice


                //---->Pur_Dr_Note
                if (GLEntry."G/L Account No." = '411300010') then begin
                    PurchCrMemoLine.Reset();
                    PurchCrMemoLine.SetRange("Document No.", GLEntry."Document No.");
                    PurchCrMemoLine.SetFilter("No.", '<>%1', '');
                    if PurchCrMemoLine.FindFirst() then begin
                        Rec.Reset();
                        if GLAcc.Get(GLEntry."G/L Account No.") then
                            Rec.SetRange("G/L Account Name", GLAcc.Name); //name
                        Rec.SetRange("Transaction No.", PurchCrMemoLine."Line No.");
                        Rec.SetRange("Document No.", GLEntry."Document No.");
                        Rec.SetRange("Posting Date", GLEntry."Posting Date");
                        Rec.SetRange("External Document No.", GLEntry."External Document No.");
                        Rec.SetRange("Source No.", GLEntry."Source No.");
                        Rec.SetRange("Location Code", GLEntry."Location Code");
                        if Location.get(GLEntry."Location Code") then begin
                            Rec.SetRange(Description, Location.Name);
                            Rec.SetRange("Reason Code", Location."State Code");
                        end;
                        Rec.SetRange("Global Dimension 1 Code", PurchCrMemoLine."Item Category Code");//Item Category Code
                        Rec.SetRange("Gen. Prod. Posting Group", PurchCrMemoLine."Gen. Prod. Posting Group");//Gen. Prod. Posting Group
                        Rec.SetRange("Job No.", PurchCrMemoLine."Posting Group");//Posting Group
                        if Item.Get(PurchCrMemoLine."No.") then begin
                            ItemCategoryCode.Reset();
                            ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                            ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                            if ItemCategoryCode.findfirst then
                                Rec.SetRange("Global Dimension 2 Code", ItemCategoryCode.Code);//Product Group Code //need to ask
                        end;
                        Rec.SetRange(Rec.Quantity, PurchCrMemoLine.Quantity);
                        Rec.SetRange("Document Type", GLEntry."Document Type");
                        Rec.SetRange("Business Unit Code", PurchCrMemoLine."No.");
                        if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                            Rec.SetRange("Source Code", PurchCrMemoHdr."Payment Terms Code");//Payment Terms Code
                            Rec.SetRange("VAT Bus. Posting Group", PurchCrMemoHdr."Buy-from Vendor No.");//Buy-from Vendor Name //NEED TO DO CHANGES
                            Rec.SetRange("VAT Prod. Posting Group", PurchCrMemoHdr."Vendor Posting Group");//Vendor Posting Group
                            Rec.SetRange("Shortcut Dimension 3 Code", Format(PurchCrMemoHdr."GST Vendor Type"));//GST Customer Type
                        end;
                        Rec.SetRange(Amount, PurchCrMemoLine.Amount);
                        Rec.SetRange("Credit Amount", PurchCrMemoLine."Line Discount %");//Line Discount
                        Rec.SetRange("Debit Amount", PurchCrMemoLine."Inv. Discount Amount");//Inv_Discount Amount
                        Rec.SetRange("Add.-Currency Credit Amount", PurchCrMemoLine."Line Discount Amount");//Line Discount Amount
                        Rec.SetRange(Rec."VAT Amount", PurchCrMemoLine."Unit Cost");//Unit Cost
                        Rec.SetRange(Comment, PurchCrMemoLine.Description);
                        Rec.SetRange("Shortcut Dimension 4 Code", format(PurchCrMemoLine."GST Group Type"));//GST Group Type
                        Rec.SetRange("Shortcut Dimension 5 Code", format(PurchCrMemoLine."GST Jurisdiction Type"));//GST Jurisdiction
                        Rec.SetRange("Non-Deductible VAT Amount ACY", Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId)); //IGST Perc
                        Rec.SetRange("Additional-Currency Amount", Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId));//IGST Amount
                        if not Rec.FindFirst() then begin
                            Rec.Init();
                            Rec."Entry No." += EntryNo;
                            Rec."Shortcut Dimension 6 Code" := 'Pur_Dr_Note';//trnType
                            if GLAcc.Get(GLEntry."G/L Account No.") then
                                Rec."G/L Account Name" := GLAcc.Name; //GL_Description
                            Rec."Transaction No." := PurchCrMemoLine."Line No.";//Line No_
                            Rec."Document No." := GLEntry."Document No."; //Document No
                            Rec."Bal. Account No." := '';//Order No
                            Rec."VAT Reporting Date" := 0D; //Order Date
                            if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                                Rec."Source Code" := PurchCrMemoHdr."Payment Terms Code";//Payment Terms Code
                                Rec."VAT Bus. Posting Group" := PurchCrMemoHdr."Buy-from Vendor No.";//Buy-from Vendor Name //NEED TO DO CHANGES
                                Rec."VAT Prod. Posting Group" := PurchCrMemoHdr."Vendor Posting Group";//Vendor Posting Group
                                Rec."Shortcut Dimension 3 Code" := Format(PurchCrMemoHdr."GST Vendor Type");//GST Customer Type
                            end;

                            Rec."Posting Date" := GLEntry."Posting Date";//Posting Date
                            Rec."External Document No." := GLEntry."External Document No.";
                            Rec."Source No." := GLEntry."Source No.";

                            Rec."Location Code" := GLEntry."Location Code";
                            if Location.get(Rec."Location Code") then begin
                                rec.Description := Location.Name;//Loc_Name
                                Rec."Reason Code" := Location."State Code";//Loc_State_Code
                            end;
                            Rec."Global Dimension 1 Code" := PurchCrMemoLine."Item Category Code";//Item Category Code
                            rec."Gen. Prod. Posting Group" := PurchCrMemoLine."Gen. Prod. Posting Group";//Gen. Prod. Posting Group
                            Rec."Job No." := PurchCrMemoLine."Posting Group";//Posting Group
                            if Item.Get(PurchCrMemoLine."No.") then begin
                                ItemCategoryCode.Reset();
                                ItemCategoryCode.SetRange(Code, Item."Item Category Code");
                                ItemCategoryCode.SetFilter("Parent Category", '<>%1', '');
                                if ItemCategoryCode.findfirst then
                                    Rec."Global Dimension 2 Code" := ItemCategoryCode.Code;//Product Group Code //need to ask
                            end;

                            Rec."Document Type" := GLEntry."Document Type";
                            Rec."Business Unit Code" := PurchCrMemoLine."No.";//Item_no
                            Rec.Comment := PurchCrMemoLine.Description;//Item_desc
                            Rec."VAT Amount" := PurchCrMemoLine."Unit Cost";//Unit Cost
                            Rec.Amount := -1 * PurchCrMemoLine.Amount;//Line Amount
                            Rec."Credit Amount" := PurchCrMemoLine."Line Discount %";//Line Discount
                            Rec."Debit Amount" := PurchCrMemoLine."Inv. Discount Amount";//Inv_Discount Amount
                            Rec."Add.-Currency Credit Amount" := PurchCrMemoLine."Line Discount Amount";//Line Discount Amount
                            rec."Add.-Currency Debit Amount" := Cu50200.GetGSTBaseAmtPostedLine(PurchCrMemoLine."Document No.", PurchCrMemoLine."Line No.");//GST Base Amount

                            Rec."Shortcut Dimension 4 Code" := format(PurchCrMemoLine."GST Group Type");//GST Group Type
                            Rec."Shortcut Dimension 5 Code" := format(PurchCrMemoLine."GST Jurisdiction Type");//GST Jurisdiction
                            Rec."Non-Deductible VAT Amount" := GLEntry.Amount;//GL_Amt
                            Rec."Non-Deductible VAT Amount ACY" := Cu50200.PostedLineIGSTPerc(PurchCrMemoLine.RecordId); //IGST Perc
                            Rec."Additional-Currency Amount" := Cu50200.PostedLineIGST(PurchCrMemoLine.RecordId);//IGST Amount
                            Rec.Quantity := PurchCrMemoLine.Quantity;//Quantity
                            Rec.Insert();
                        end else begin
                            Rec."Non-Deductible VAT Amount" += GLEntry.Amount;//GL_Amt
                            Rec.Modify();
                        end;

                    end
                end;
            //<----Pur_Dr_Note
            until GLEntry.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    begin
        //need to work for GST Base Amount
        //need to work for buy from vendor name

    end;

    var
        GLEntry: Record 17;
        GLEntryRec: Record 17;
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
        DetGSTLedEntry: Record "Detailed GST Ledger Entry";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
}
