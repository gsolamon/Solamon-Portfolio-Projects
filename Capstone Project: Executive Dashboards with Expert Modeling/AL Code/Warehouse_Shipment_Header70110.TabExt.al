tableextension 70110 "Warehouse Shipment Header Ext" extends "Warehouse Shipment Header"
{
    fields
    {
        field(70110; "Color Status"; Enum "Color Status")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Color Status" where("No." = field(SO_Lookup70113)));
        }
        field(70111; "Added To Greenlist DateTime"; DateTime)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Added to Greenlist DateTime" where("No." = field(SO_Lookup70113)));
        }
        field(70112; "Added To Greenlist By"; Code[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Added to Greenlist By" where("No." = field(SO_Lookup70113)));
        }
        field(70113; "SO_Lookup70113"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("No."),
                                                                            "Source Type" = filter(37)));
        }
        field(70114; "Recent Greenlist"; Enum "Recent Greenlist")
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}