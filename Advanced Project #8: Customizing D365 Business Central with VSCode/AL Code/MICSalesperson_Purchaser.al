tableextension 70004 "MICSalesperson_Purchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        field(70004; "c006_Email_List"; Text[1000])
        {
            Caption = 'Confirmation Email List';
            DataClassification = ToBeClassified;
        }
    }
}
