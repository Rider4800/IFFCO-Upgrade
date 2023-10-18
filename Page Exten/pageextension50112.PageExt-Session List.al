/*12887 "Session List" page not found ---->
pageextension 50112 pageextension50112 extends "Session List"
{
    actions
    {
        addafter("Debug Next Session")
        {
            action("Kill Session")
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to Stop session', FALSE) THEN
                        STOPSESSION("Session ID");
                end;
            }
        }
    }
}
<----12887 */

