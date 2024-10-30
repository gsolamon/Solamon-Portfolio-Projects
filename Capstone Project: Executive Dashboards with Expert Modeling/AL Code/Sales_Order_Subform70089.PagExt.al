pageextension 70089 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addafter(Type)
        {
            field("Line Color Status"; Rec."Line Color Status")
            {
                ApplicationArea = All;
                StyleExpr = StyleExprLine;
                Editable = true;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec."Line Color Status" of
            Enum::"Line Color Status"::Red:
                StyleExprLine := 'Unfavorable';
            else
                StyleExprLine := '';
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        case Rec."Line Color Status" of
            Enum::"Line Color Status"::Red:
                StyleExprLine := 'Unfavorable';
            else
                StyleExprLine := '';
        end;
    end;

    var
        StyleExprLine: Text;
}