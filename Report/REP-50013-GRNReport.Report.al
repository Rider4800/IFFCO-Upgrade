report 50013 "GRN Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './GRNReport.rdlc';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            column(txtCountry123; txtCountry123)
            {
            }
            column(vEND; Vend)
            {
            }
            column(Pic; RecCompany.Picture)
            {
            }
            column(LocName; LocAdd[1])
            {
            }
            column(LocAddress; LocAdd[2])
            {
            }
            column(LocaAddress2; LocAdd[3])
            {
            }
            column(LocCity; LocAdd[4])
            {
            }
            column(LocName2; LocAdd[5])
            {
            }
            column(LocPostcode; LocAdd[6])
            {
            }
            column(Loccountry; LocAdd[7])
            {
            }
            column(locshiptoname; LocAdd[8])
            {
            }
            column(locshipname2; LocAdd[9])
            {
            }
            column(locshipAdd; LocAdd[10])
            {
            }
            column(locshipadd2; LocAdd[11])
            {
            }
            column(locshipcity; LocAdd[12])
            {
            }
            column(locshippostcode; LocAdd[13])
            {
            }
            column(LocCountryName; txtcohuntryname)
            {
            }
            column(LocShipCountryName; TxtLocShipCountyName)
            {
            }
            column(SHipName; "Purch. Rcpt. Header"."Buy-from Address 2")
            {
            }
            column(SHipNAme2; "Purch. Rcpt. Header"."Ship-to Name 2")
            {
            }
            column(shipadd2; "Purch. Rcpt. Header"."Ship-to Address 2")
            {
            }
            column(Shiptoaddress; "Purch. Rcpt. Header"."Ship-to Address")
            {
            }
            column(shiptopstcod; "Purch. Rcpt. Header"."Ship-to Post Code")
            {
            }
            column(shiptocountry; "Purch. Rcpt. Header"."Ship-to County")
            {
            }
            column(shiptocity; "Purch. Rcpt. Header"."Ship-to City")
            {
            }
            column(MATNameCountry; txtcohuntryname)
            {
            }
            column(COMPPHONE; RecCompany."Phone No.")
            {
            }
            column(MatDelLocationCode; "Purch. Rcpt. Header"."Location Code")
            {
            }
            column(CompName; RecCompany.Name)
            {
            }
            column(CompAddress; RecCompany.Address)
            {
            }
            column(CompAddress2; RecCompany."Address 2")
            {
            }
            column(CompLocationCode; RecCompany."Location Code")
            {
            }
            column(CompCity; RecCompany.City)
            {
            }
            column(CompPstCode; RecCompany."Post Code")
            {
            }
            column(CompHomePage; RecCompany."Home Page")
            {
            }
            column(CompEmail; RecCompany."E-Mail")
            {
            }
            column(CompVatRegNo; RecCompany."VAT Registration No.")
            {
            }
            column(CompBankName; RecCompany."Bank Name")
            {
            }
            column(CompBnkAccNo; RecCompany."Bank Account No.")
            {
            }
            column(GiroNo; RecCompany."Giro No.")
            {
            }
            column(CompCountry; comp2)
            {
            }
            column(GrnNo; "Purch. Rcpt. Header"."No.")
            {
            }
            column(GrnDate; FORMAT("Purch. Rcpt. Header"."Posting Date"))
            {
            }
            column(BuyFromVendorNos; "Purch. Rcpt. Header"."Buy-from Vendor No.")
            {
            }
            column(BuyFromVendorName; "Purch. Rcpt. Header"."Buy-from Vendor Name")
            {
            }
            column(VendorShipmentNo; "Purch. Rcpt. Header"."Vendor Shipment No.")
            {
            }
            column(DocumentDate; FORMAT("Purch. Rcpt. Header"."Document Date"))
            {
            }
            column(OrderNo; "Purch. Rcpt. Header"."Order No.")
            {
            }
            column(OrderDate; FORMAT("Purch. Rcpt. Header"."Order Date"))
            {
            }
            column(paytoNam; "Purch. Rcpt. Header"."Pay-to Name")
            {
            }
            column(paytoAdd; "Purch. Rcpt. Header"."Pay-to Address")
            {
            }
            column(PaytoAddr2; "Purch. Rcpt. Header"."Pay-to Address 2")
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(DocumentNo; "Purch. Rcpt. Line"."Document No.")
                {
                }
                column(ItemCode; "Purch. Rcpt. Line"."No.")
                {
                }
                column(Description; "Purch. Rcpt. Line".Description)
                {
                }
                column(QtyInvoiced; "Purch. Rcpt. Line"."Quantity Invoiced")
                {
                }
                column(UnitMeasureCode; "Purch. Rcpt. Line"."Unit of Measure Code")
                {
                }
                column(DirectUnitCost; "Purch. Rcpt. Line"."Direct Unit Cost")
                {
                }
                column(LocationCode; "Purch. Rcpt. Line"."Location Code")
                {
                }
                column(LotNo; Batch)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Document Line No." = FIELD("Line No.");
                    column(ITEDocumentNo; "Item Ledger Entry"."Document No.")
                    {
                    }
                    column(ITEDescpt; "Item Ledger Entry".Description)
                    {
                    }
                    column(ITEitemcode; "Item Ledger Entry"."Item No.")
                    {
                    }
                    column(ITEQty; "Item Ledger Entry".Quantity)
                    {
                    }
                    column(ITEUOM; "Item Ledger Entry"."Unit of Measure Code")
                    {
                    }
                    column(ITElocationcode; "Item Ledger Entry"."Location Code")
                    {
                    }
                    column(LotNo1; "Item Ledger Entry"."Lot No.")
                    {
                    }
                    column(DocumentLineNo; "Item Ledger Entry"."Document Line No.")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    RecIle.RESET;
                    RecIle.SETRANGE("Document No.", "Purch. Rcpt. Line"."Document No.");
                    RecIle.SETRANGE("Document Line No.", "Purch. Rcpt. Line"."Line No.");
                    IF RecIle.FINDFIRST THEN BEGIN
                        REPEAT
                            Batch := RecIle."Lot No.";
                            Batch += RecIle."Lot No." + Batch;
                        UNTIL RecIle.NEXT = 0;
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RecLoc.GET("Purch. Rcpt. Header"."Location Code");
                LocAdd[1] := RecLoc.Name;
                LocAdd[2] := RecLoc.Address;
                LocAdd[3] := RecLoc."Address 2";
                LocAdd[4] := RecLoc.City;
                LocAdd[5] := RecLoc."Name 2";
                LocAdd[6] := RecLoc."Post Code";
                //LocAdd[7]:=RecLoc."Country/Region Code";
                LocAdd[8] := RecLoc."Ship-To Name";
                LocAdd[9] := RecLoc."Ship-To Name2";
                LocAdd[10] := RecLoc."Ship-To Address";
                LocAdd[11] := RecLoc."Ship-To Address2";
                LocAdd[12] := RecLoc."Ship-To City";
                LocAdd[13] := RecLoc."Ship-To PostCode";
                //LocAdd[14]:=RecLoc."Ship-To Country/RegionCode";

                RecCountry.RESET();
                IF RecLoc."Country/Region Code" <> '' THEN BEGIN
                    RecCountry.GET(RecLoc."Country/Region Code");
                    txtcohuntryname := RecCountry.Name;
                END;
                RecCountry.RESET();
                RecCountry.SETRANGE(Code, RecLoc."Ship-To Country/RegionCode");
                IF RecCountry.FINDFIRST THEN BEGIN
                    ;
                    TxtLocShipCountyName := RecCountry.Name;
                END;
                RecVendor.RESET;
                RecVendor.SETRANGE("No.", "Purch. Rcpt. Header"."Buy-from Vendor No.");
                IF RecVendor.FINDFIRST THEN BEGIN
                    Vend := RecVendor.Contact;
                END;

                txtCountry123 := '';
                IF TxtLocShipCountyName = '' THEN
                    txtCountry123 := txtcohuntryname
                ELSE
                    txtCountry123 := TxtLocShipCountyName
            end;

            trigger OnPreDataItem()
            begin
                RecCompany.GET;
                RecCompany.CALCFIELDS(Picture);
                IF RecCompany."Country/Region Code" <> '' THEN BEGIN
                    RecCountry.GET(RecCompany."Country/Region Code");
                    comp2 := RecCountry.Name;
                END;

                //"Purch. Rcpt. Line".SETFILTER("Item Ledger Entry","Item Ledger Entry"."Quantity,'%1'");
                //"Purch. Rcpt. Line".SETFILTER("Purch. Rcpt. Line","Purch. Rcpt. Line"."Document No.",'<>%1','44000530');
            end;
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

    labels
    {
    }

    var
        RecCompany: Record 79;
        Comp: array[20] of Text;
        comp2: Text[50];
        RecVendor: Record 23;
        Vend: Text;
        LocAdd: array[30] of Text;
        RecLoc: Record 14;
        RecIle: Record 32;
        Batch: Code[100];
        RecCountry: Record 9;
        txtcohuntryname: Code[50];
        TxtLocShipCountyName: Code[50];
        txtCountry123: Text;
}

