pageextension 70085 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Color Status"; Rec."Color Status")
            {
                ApplicationArea = All;
                ToolTip = 'Select the color status for the sales order.';
                Visible = false;
            }
            field("Added to Greenlist DateTime"; Rec."Added to Greenlist DateTime")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Added to Greenlist By"; Rec."Added to Greenlist By")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}