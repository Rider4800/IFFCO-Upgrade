page 50004 "Response Logs"
{
    // //HT (For E-Way Bill and E-Invoice Integration)

    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 50003;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Called API"; Rec."Called API")
                {
                }
                field("Response Date"; Rec."Response Date")
                {
                }
                field("Response Time"; Rec."Response Time")
                {
                }
                field("Response Log 1"; Rec."Response Log 1")
                {
                }
                field("Response Log 2"; Rec."Response Log 2")
                {
                }
                field("Response Log 3"; Rec."Response Log 3")
                {
                }
                field("Response Log 4"; Rec."Response Log 4")
                {
                }
                field("Response Log 5"; Rec."Response Log 5")
                {
                }
                field("Response Log 6"; Rec."Response Log 6")
                {
                }
                field("Response Log 7"; Rec."Response Log 7")
                {
                }
                field("Response Log 8"; Rec."Response Log 8")
                {
                }
                field("Response Log 9"; Rec."Response Log 9")
                {
                }
                field("Response Log 10"; Rec."Response Log 10")
                {
                }
                field("Response Log 11"; Rec."Response Log 11")
                {
                }
                field("Response Log 12"; Rec."Response Log 12")
                {
                }
                field("Response Log 13"; Rec."Response Log 13")
                {
                }
                field("Response Log 14"; Rec."Response Log 14")
                {
                }
                field("Response Log 15"; Rec."Response Log 15")
                {
                }
                field("Response Log 16"; Rec."Response Log 16")
                {
                }
            }
        }
    }

}

