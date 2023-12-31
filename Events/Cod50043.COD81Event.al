codeunit 50043 COD81Event
{
    // [EventSubscriber(ObjectType::Codeunit, 19, 'OnBeforeRunPreview', '', false, false)]
    // local procedure OnBeforeRunPreview(Subscriber: Variant; RecVar: Variant)
    // var
    //     RecordRefVar: RecordRef;
    //     recSalesLine: Record 37;
    //     SalesHdr: Record 36;
    //     codeun: Codeunit 81;
    // begin
    //     RecordRefVar := Subscriber;
    //     if RecordRefVar.Caption = 'Sales Header' then begin
    //         RecordRefVar.Open(36);
    //         //KM300621
    //         recSalesLine.RESET();
    //         recSalesLine.SETRANGE("Document No.", format(RecordRefVar.Field(3)));
    //         IF recSalesLine.FINDFIRST THEN BEGIN
    //             REPEAT
    //                 IF recSalesLine.Type = recSalesLine.Type::Item THEN
    //                     recSalesLine.TESTFIELD("Unit Price");
    //                 recSalesLine.TESTFIELD("Line Amount");
    //             UNTIL recSalesLine.NEXT = 0;
    //         END;
    //         //KM300621
    //     end;
    // end;
    [EventSubscriber(ObjectType::Codeunit, 81, 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun(var SalesHeader: Record "Sales Header")
    var
        RecordRefVar: RecordRef;
        recSalesLine: Record 37;
        SalesHdr: Record 36;
        codeun: Codeunit 81;
    begin
        //KM300621
        recSalesLine.RESET();
        recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF recSalesLine.FINDFIRST THEN BEGIN
            REPEAT
                IF recSalesLine.Type = recSalesLine.Type::Item THEN begin
                    recSalesLine.TESTFIELD("Unit Price");
                    recSalesLine.TESTFIELD("Line Amount");
                end;
            UNTIL recSalesLine.NEXT = 0;
        END;
    end;
}
