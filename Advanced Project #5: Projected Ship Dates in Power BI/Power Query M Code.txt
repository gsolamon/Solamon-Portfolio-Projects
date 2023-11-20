let
    Source = Csv.Document(Web.Contents("https://raw.githubusercontent.com/gsolamon/Solamon-Portfolio-Projects/main/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/CSV%20Files/SolaCorp%20Backlog%20CSV.csv"),[Delimiter=",", Columns=10, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Backlog Quantity", Int64.Type}, {"Backlog USD", Currency.Type}, {"Order Date", type date}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "General Item Description", each Text.BeforeDelimiter([Item Description LOOKUP], " #")),
    #"Merged Queries" = Table.NestedJoin(#"Added Custom", {"General Item Description"}, #"SolaCorp Product Groups", {"Cooking Appliance"}, "SolaCorp Product Groups", JoinKind.LeftOuter),
    #"Expanded SolaCorp Product Groups" = Table.ExpandTableColumn(#"Merged Queries", "SolaCorp Product Groups", {"Product Group"}, {"Product Group"}),
    #"Added Custom1" = Table.AddColumn(#"Expanded SolaCorp Product Groups", "Order_Item", each [Order Number] & "_" & [Item Number]),
    #"Added Custom2" = Table.AddColumn(#"Added Custom1", "Enumeration List", each List.Generate(() => [Backlog Quantity], each _ > 0, each _ - 1)),
    #"Expanded Enumeration List" = Table.ExpandListColumn(#"Added Custom2", "Enumeration List"),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded Enumeration List", "Order_Item", "Order_Item - Copy"),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Duplicated Column", {{"Enumeration List", type text}}, "en-US"),{"Order_Item - Copy", "Enumeration List"},Combiner.CombineTextByDelimiter("_", QuoteStyle.None),"Order_Item_Number"),
    #"Added Custom3" = Table.AddColumn(#"Merged Columns", "Group_Order", each [Product Group] & "_" & [Order Number]),
    #"Merged Queries1" = Table.NestedJoin(#"Added Custom3", {"Group_Order"}, #"Hot Orders", {"Group_Order"}, "Hot Orders", JoinKind.LeftOuter),
    #"Expanded Hot Orders" = Table.ExpandTableColumn(#"Merged Queries1", "Hot Orders", {"New Order Date"}, {"New Order Date"}),
    #"Added Custom4" = Table.AddColumn(#"Expanded Hot Orders", "Combined Order Date", each if [New Order Date] = null then [Order Date] else [New Order Date]),
    #"Sorted Rows" = Table.Sort(#"Added Custom4",{{"Product Group", Order.Ascending}, {"Combined Order Date", Order.Ascending}, {"Order Number", Order.Ascending}}),
    #"Grouped Rows" = Table.Group(#"Sorted Rows", {"Product Group"}, {{"All Rows", each _, type table [Order Number=nullable text, Customer Number=nullable text, Region=nullable text, Item Number=nullable text, Item Description LOOKUP=nullable text, Backlog Quantity=nullable number, Backlog USD=nullable number, Order Date=nullable date, Salesperson Code=nullable text, Intercompany=nullable text, General Item Description=text, Product Group=nullable text, Order_Item=text, Order_Item_Number=text, Group_Order=text, New Order Date=nullable date, Combined Order Date=date]}}),
    RankFunction = (tabletorank as table) as table =>
     let
      SortRows = Table.Sort(tabletorank, {{"Combined Order Date", Order.Ascending}, {"Order Number", Order.Ascending}}),
      AddIndex = Table.AddIndexColumn(SortRows, "Rank", 1, 1)
     in
      AddIndex,
    AddedRank = Table.TransformColumns(#"Grouped Rows", {"All Rows", each RankFunction(_)}),
    #"Expanded All Rows" = Table.ExpandTableColumn(AddedRank, "All Rows", {"Order Number", "Customer Number", "Region", "Item Number", "Backlog Quantity", "Order Date", "Salesperson Code", "Order_Item", "Order_Item_Number", "Group_Order", "Rank"}, {"Order Number", "Customer Number", "Region", "Item Number", "Backlog Quantity", "Order Date", "Salesperson Code", "Order_Item", "Order_Item_Number", "Group_Order", "Rank"}),
    #"Merged Queries2" = Table.NestedJoin(#"Expanded All Rows", {"Product Group"}, #"Output Rates", {"Product Group"}, "Output Rates", JoinKind.LeftOuter),
    #"Expanded Output Rates" = Table.ExpandTableColumn(#"Merged Queries2", "Output Rates", {"Weekly Output", "First Ship Date"}, {"Weekly Output", "First Ship Date"}),
    #"Added Custom5" = Table.AddColumn(#"Expanded Output Rates", "Projected Ship Date", each if [First Ship Date] = null then Date.AddDays(DateTime.Date(DateTime.LocalNow()), (6 - Date.DayOfWeek(DateTime.LocalNow(), Day.Saturday)) + 7 * (Number.RoundUp(([Rank] -1) / [Weekly Output]))) else Date.AddDays([First Ship Date], (6 - Date.DayOfWeek([First Ship Date], Day.Saturday)) + 7 * (Number.RoundUp(([Rank] - 1) / [Weekly Output])))),
    #"Sorted Rows1" = Table.Sort(#"Added Custom5",{{"Rank", Order.Ascending}}),
    #"Added Index" = Table.AddIndexColumn(#"Sorted Rows1", "Index", 1, 1, Int64.Type),
    #"Removed Duplicates" = Table.Distinct(#"Added Index", {"Group_Order"}),
    #"Removed Columns" = Table.RemoveColumns(#"Removed Duplicates",{"Index"}),
    #"Sorted Rows2" = Table.Sort(#"Removed Columns",{{"Product Group", Order.Ascending}, {"Rank", Order.Ascending}}),
    #"Added Index1" = Table.AddIndexColumn(#"Sorted Rows2", "Index", 1, 1, Int64.Type),
    #"Merged Queries3" = Table.NestedJoin(#"Added Index1", {"Order Number"}, #"On Hold", {"Order Number"}, "On Hold", JoinKind.LeftOuter),
    #"Expanded On Hold" = Table.ExpandTableColumn(#"Merged Queries3", "On Hold", {"On Hold"}, {"On Hold"}),
    #"Replaced Value" = Table.ReplaceValue(#"Expanded On Hold",null,false,Replacer.ReplaceValue,{"On Hold"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","On Hold",true,Replacer.ReplaceValue,{"On Hold"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Replaced Value1",{{"Order Number", type text}, {"Customer Number", type text}, {"Region", type text}, {"Item Number", type text}, {"Backlog Quantity", type number}, {"Order Date", type date}, {"Salesperson Code", type text}, {"Order_Item", type text}, {"Order_Item_Number", type text}, {"Group_Order", type text}, {"Rank", Int64.Type}, {"Projected Ship Date", type date}, {"On Hold", type logical}})
in
    #"Changed Type1"
