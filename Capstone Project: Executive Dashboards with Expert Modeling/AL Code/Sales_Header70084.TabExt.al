tableextension 70084 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(70084; "Color Status"; Enum "Color Status")
        {
            Caption = 'Color Status';
            DataClassification = ToBeClassified;
        }
        field(70085; "Added to Greenlist DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70086; "Added to Greenlist By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    trigger OnModify()
    begin
        if (xRec."Color Status" <> Rec."Color Status") and (Rec."Color Status" = Rec."Color Status"::Green) then begin
            "Added to Greenlist DateTime" := CurrentDateTime();
            "Added to Greenlist By" := UserId();
            Modify(true);
        end;
    end;
}