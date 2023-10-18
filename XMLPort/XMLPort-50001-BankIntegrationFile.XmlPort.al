xmlport 50001 BankIntegrationFile
{
    Direction = Export;
    //16767 Encoding = UTF16;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>,';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(BankIntegrationFile)
        {
            tableelement("Bank Integration Entry"; "Bank Integration Entry")
            {
                XmlName = 'BankIntegrationEntry';
                SourceTableView = WHERE(Status = FILTER(0));
                fieldelement(TranType; "Bank Integration Entry"."Transaction Type")
                {

                    trigger OnBeforePassField()
                    begin
                        //TranType:="Bank Integration Entry".FIELDCAPTION("Transaction Type")
                    end;
                }
                fieldelement(BeneficiaryCode; "Bank Integration Entry"."Beneficiary Code")
                {

                    trigger OnBeforePassField()
                    begin
                        //BeneficiaryCode:="Bank Integration Entry".FIELDCAPTION("Beneficiary Code")
                    end;
                }
                fieldelement(BeneficiaryAccountNumber; "Bank Integration Entry"."Beneficiary Account Number")
                {
                }
                fieldelement(InstrumentAmount; "Bank Integration Entry"."Instrument Amount..")
                {
                }
                fieldelement(BeneficiaryName; "Bank Integration Entry"."Beneficiary Name")
                {
                }
                fieldelement(DraweeLocation; "Bank Integration Entry"."Drawee Location")
                {
                }
                fieldelement(PrintLocation; "Bank Integration Entry"."Print Location")
                {
                }
                fieldelement(BeneAddress1; "Bank Integration Entry"."Bene Address 1")
                {
                }
                fieldelement(BeneAddress2; "Bank Integration Entry"."Bene Address 2")
                {
                }
                fieldelement(BeneAddress3; "Bank Integration Entry"."Bene Address 3")
                {
                }
                fieldelement(BeneAddress4; "Bank Integration Entry"."Bene Address 4")
                {
                }
                fieldelement(BeneAddress5; "Bank Integration Entry"."Bene Address 5")
                {
                }
                fieldelement(InstructionReferenceNumber; "Bank Integration Entry"."Instruction Reference Number")
                {
                }
                fieldelement(CustomerReferenceNumber; "Bank Integration Entry"."Customer Reference Number")
                {
                }
                fieldelement(Paymentdetails1; "Bank Integration Entry"."Payment details 1")
                {
                }
                fieldelement(Paymentdetails2; "Bank Integration Entry"."Payment details 2")
                {
                }
                fieldelement(Paymentdetails3; "Bank Integration Entry"."Payment details 3")
                {
                }
                fieldelement(Paymentdetails4; "Bank Integration Entry"."Payment details 4")
                {
                }
                fieldelement(Paymentdetails5; "Bank Integration Entry"."Payment details 5")
                {
                }
                fieldelement(Paymentdetails6; "Bank Integration Entry"."Payment details 6")
                {
                }
                fieldelement(Paymentdetails7; "Bank Integration Entry"."Payment details 7")
                {
                }
                fieldelement(ChequeNumber; "Bank Integration Entry"."Cheque Number")
                {
                }
                textelement(chequedate)
                {
                    XmlName = 'ChequeDate';

                    trigger OnBeforePassVariable()
                    begin
                        ChequeDate := '';
                        //ChequeDate:='';
                        ChequeDate := FORMAT("Bank Integration Entry"."Chq / Trn Date", 0, '<Day,2>/<Month,2>/<Year4>');
                        // Dt := FORMAT(SalesInvoiceHeader."Posting Date",0,'<Day,2>/<Month,2>/<Year4>');
                    end;
                }
                fieldelement(MICRNumber; "Bank Integration Entry"."MICR Number")
                {
                }
                fieldelement(IFCCode; "Bank Integration Entry"."IFC Code")
                {
                }
                fieldelement(BeneBankName; "Bank Integration Entry"."Bene Bank Name")
                {
                }
                fieldelement(BeneBankBranchName; "Bank Integration Entry"."Bene Bank Branch Name")
                {
                }
                fieldelement(BeneBanEMailID; "Bank Integration Entry"."Beneficiary email id")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ChequeDate := '';
                    IF "Bank Integration Entry"."Chq / Trn Date" <> 0D THEN;
                    //ChequeDate:=FORMAT("Bank Integration Entry"."Chq / Trn Date",0,'<Day,2>/<Month,2>/<Year4>');
                end;

            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        EntryNo: Text;
        TranType: Text;
        BeneficiaryCode: Text;
}

