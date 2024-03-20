pageextension 70007 SalesOrderExtension extends "Sales Order"
{
    actions
    {
        addafter(Release)
        {
            action(ReleaseAndSend)
            {
                ApplicationArea = All;
                Caption = 'Release and Send Confirmation';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = false;
                ShortcutKey = 'Ctrl+Shift+F9';
                ToolTip = 'Release the document to the next stage of processing and send an order confirmation email to the customer and salesperson.';
                Visible = true;
                trigger OnAction();
                var
                    ReleaseCode: Codeunit "Release Sales Document";
                    ConfEmailCode: Codeunit SendOrderConfirmation;
                begin
                    ReleaseCode.Run(Rec);
                    ConfEmailCode.SendOrderConfirmation(Rec."No.");
                end;
            }
        }
    }
}