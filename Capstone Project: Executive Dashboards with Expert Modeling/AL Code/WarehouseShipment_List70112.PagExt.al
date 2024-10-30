pageextension 70112 "Warehouse Shipment List Ext" extends "Warehouse Shipment List"
{
    layout
    {
        modify("No.")
        {
            ApplicationArea = All;
            StyleExpr = StyleExprNo;
        }
        addafter("No.")
        {
            field("Recent Greenlist"; Rec."Recent Greenlist")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
        addlast(Control1)
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

    trigger OnAfterGetRecord()
    var
        CurrentDateTime: DateTime;
        TimeDifference: Duration;
    begin
        CurrentDateTime := CurrentDateTime();

        if Rec."Added To Greenlist DateTime" = 0DT then
            Rec."Recent Greenlist" := "Recent Greenlist"::None
        else begin
            TimeDifference := CurrentDateTime - Rec."Added To Greenlist DateTime";

            if (TimeDifference <= 86400000) and (Rec."Color Status" = Rec."Color Status"::Green) then
                Rec."Recent Greenlist" := "Recent Greenlist"::Recent
            else
                Rec."Recent Greenlist" := "Recent Greenlist"::None;
        end;
        Rec.Modify(true);

        case Rec."Color Status" of
            Enum::"Color Status"::Green:
                StyleExprNo := 'Favorable';
            Enum::"Color Status"::Blue:
                StyleExprNo := 'StrongAccent';
            else
                StyleExprNo := '';
        end;
    end;

    var
        StyleExprNo: Text;
}