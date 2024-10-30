pageextension 70086 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        modify("No.")
        {
            ApplicationArea = All;
            StyleExpr = StyleExprNo;
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("Toggle Include in Greenlist")
            {
                Caption = 'Toggle Include in Greenlist';
                ToolTip = 'Toggle selected orders to/from Green';
                ApplicationArea = All;
                Image = ToggleBreakpoint;

                trigger OnAction()
                var
                    SelectedRecords: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecords);
                    if SelectedRecords.FindSet() then begin
                        repeat
                            if SelectedRecords."Color Status" = SelectedRecords."Color Status"::Green then
                                SelectedRecords.Validate("Color Status", SelectedRecords."Color Status"::None)
                            else
                                SelectedRecords.Validate("Color Status", SelectedRecords."Color Status"::Green);
                            SelectedRecords.Modify(true);
                        until SelectedRecords.Next() = 0;
                    end;
                    CurrPage.Update();
                end;
            }
            action("Clear All Color Statuses")
            {
                Caption = 'Clear All Color Statuses';
                ToolTip = 'Clear color status for all orders';
                Image = ResetStatus;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ConfirmDialog: Boolean;
                    SalesHeader: Record "Sales Header";
                begin
                    ConfirmDialog := Confirm('Are you sure you want to clear all color statuses?', false);
                    if not ConfirmDialog then
                        exit;

                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    if SalesHeader.FindSet() then begin
                        repeat
                            SalesHeader."Color Status" := Enum::"Color Status"::None;
                            SalesHeader.Modify(true);
                        until SalesHeader.Next() = 0;
                    end;
                    CurrPage.Update();
                end;
            }
            action("Make Color Status Blue")
            {
                Caption = 'Make Color Status Blue';
                ToolTip = 'Make selected orders Blue color status';
                Image = ChangeStatus;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SelectedRecords: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecords);
                    if SelectedRecords.FindSet() then begin
                        repeat
                            SelectedRecords.Validate("Color Status", SelectedRecords."Color Status"::Blue);
                            SelectedRecords.Modify(true);
                        until SelectedRecords.Next() = 0;
                    end;
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
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