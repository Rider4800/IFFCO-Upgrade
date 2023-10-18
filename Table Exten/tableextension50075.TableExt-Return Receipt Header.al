tableextension 50075 tableextension50075 extends "Return Receipt Header"
{
    fields
    {
        field(50000; "Transporter Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE(Transporter = FILTER(true));
        }
        field(50001; "Transporter Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Transporter GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50005; "Sell-to Customer Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
        field(50007; "Bill-to Name 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ACX-RK';
        }
    }
}

