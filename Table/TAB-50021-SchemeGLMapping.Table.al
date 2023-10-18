table 50021 "Scheme GL Mapping"
{

    fields
    {
        field(1; "Customer Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Posting Group";
        }
        field(2; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                recGL.RESET();
                recGL.SETRANGE("No.", "G/L Account");
                IF recGL.FINDFIRST THEN
                    "G/L Account Name" := recGL.Name
                ELSE
                    "G/L Account Name" := '';
            end;
        }
        field(3; "G/L Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Customer Posting Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recGL: Record 15;
}

