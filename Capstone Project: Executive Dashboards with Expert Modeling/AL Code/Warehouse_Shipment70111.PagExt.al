pageextension 70111 "Warehouse Shipment Ext" extends "Warehouse Shipment"
{
    layout
    {
        addlast(General)
        {
            field("Color Status"; Rec."Color Status")
            {
                ApplicationArea = All;
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