tableextension 50077 tableextension50077 extends "Sales Price"
{
    keys
    {
        /*12887----> need to review as change in Primary Key is no allowed
                //Unsupported feature: Deletion (KeyCollection) on ""Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"(Key)".

                key(Key1; "Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "MRP Price")
                {
                    Clustered = true;
                }
                <---12887*/
    }
}

