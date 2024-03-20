pageextension 70005 "MICSalespersons_Purchaser70005" extends "Salespersons/Purchasers"
{
    layout
    {
        AddLast("Control1")
        {
            field("c006_Email_List_MIC"; Rec."c006_Email_List")
            {
                ToolTip = 'Use semicolons ";" to separate email addresses that will receive order confirmation emails.';
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}
