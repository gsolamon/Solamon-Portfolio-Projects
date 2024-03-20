pageextension 70006 "MICSalesperson_Purchaser_70006" extends "Salesperson/Purchaser Card"
{
    layout
    {
        AddLast("General")
        {
            field("c006_Email_List_MIC"; Rec."c006_Email_List")
            {
                ToolTip = 'Use semicolons ";" to separate email addresses that will receive order confirmation emails.';
                ApplicationArea = all;
            }
        }
    }
}
