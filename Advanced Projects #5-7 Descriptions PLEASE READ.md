# Solamon-Portfolio-Projects - Advanced Projects #5, #6, and #7

In these three advanced projects, I will demonstrate my ability to build semantic models in the Power Platform that provide valuable characterizations of operational and financial data.

### **Project List:**

  - [**Project #5:** Projected Ship Dates in the Power Platform](https://github.com/gsolamon/Solamon-Portfolio-Projects/tree/a4df116b6ae961cccb0e23dae92cdcf23fd586f1/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI)
  - [**Project #6:** Many-to-Many with Greenlist Accessories](https://github.com/gsolamon/Solamon-Portfolio-Projects/tree/main/Advanced%20Project%20%236%3A%20Many-to-Many%20with%20Greenlist%20Accessories)
  - [**Project #7:** Consolidated Operating Model](link incoming)


### **Project Summaries:**

  **Advanced Project #5: Projected Ship Dates in the Power Platform**
  
  1. This dataflow/report takes the order backlog of the fictitious company "SolaCorp" and organizes it into a queue, assigning projected ship dates by taking into account output rates, production delays, orders on hold, and hot orders.
  2. The primary fact table of this model is the backlog (found at [SolaCorp Backlog.xlsx](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/a4df116b6ae961cccb0e23dae92cdcf23fd586f1/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/SolaCorp%20Backlog.xlsx)), which is made using Power BI Dataflows, Power BI Report Builder, and Power Automate to warehouse in Sharepoint. Each line of the backlog is an open order line:
  ![SolaCorp Backlog Lines](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/SolaCorp%20Backlog%20Lines.png)
     
  3. In the "SolaCorp Backlog.xlsx" file, you can see how I generated the item descriptions using the dimension table in the "Item Description Generator" worksheet. SolaCorp manufactures 181 SKUs of 65 cooking appliances within 9 distinct product groups:
  ![Item Description Generator](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/Item%20Description%20Generator.png)

  4. The [SolaCorp Projected Ship Dates.pbix](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/b82648b4fd81018d272351dcee86be3753a5895c/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/SolaCorp%20Projected%20Ship%20Dates.pbix) file contains the report interface that is used by production planners, salespeople, and customer service representatives across the organization:
  ![Projected Ship Dates Interface](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/Projected%20Ship%20Dates%20Interface.png)

  5. At Micromeritics Instrument Corporation (MIC), we use this report to schedule production and provide estimated shipping dates to salespeople/customers.
  6. The Projected Ship Dates data model can be seen below. SolaCorp Backlog is the fact table while Hot Orders, On Hold, Output Rates, and Product Groups are dynamic dimension tables:
  ![Projected Ship Dates Data Model](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/d378cfa0d4c3b6f2d2c92dbbe21935b10b1bf56b/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/Projected%20Ship%20Dates%20Data%20Model.png)
  
  7. Our dimension tables are maintained by our operations liason using the [SolaCorp Hot Orders + Output Rates + On Hold.xlsx](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/a4df116b6ae961cccb0e23dae92cdcf23fd586f1/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/SolaCorp%20Hot%20Orders%20%2B%20Output%20Rates%20%2B%20On%20Hold.xlsx) file.
  8. The "Hot Orders" worksheet allows him to re-rank orders within product groups that need to be pushed up in the production schedule by pasting valid order number/item number combinations in columns A and B:
  ![Hot Orders](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/Hot%20Orders.png)

  9. "Output Rates" allows us to set weekly output rates for each product group.
  10. "On Hold" leaves the order in the queue, but highlights the entry in yellow on the report usign conditional formatting so that customer service/accounting knows to work with the customer on payments:
  ![On Hold](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/On%20Hold.png)

  11. The semantic model is mostly created in Power Query by transforming the backlog, joining (merging) dimension tables, and invoking custom ranking/grouping functions. The M code can be found at this [GitHub location](https://raw.githubusercontent.com/gsolamon/Solamon-Portfolio-Projects/main/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Power%20Query%20M%20Code.txt).
  12. To summarize the model, I take the following steps:
  - Load backlog as CSV using CSV/web contents data connectors.
  - Join "Product Groups" table on item description to get product groups for each order line.
  - Create Order_Item secondary key, enumerate 1 to order quantity, and expand this list onto new rows, giving each item its own line (quantity 1 per line).
  - Joined "Hot Orders" table on order number to get a re-ranked order date for hot orders.
  - Sorted on combined order date, grouped by product group, and used custom RankFunction to queue order lines by combined order date within these sorted groups:
  ![RankFunction](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/RankFunction.png)

  - Joined "Output Rates" on product group and used custom function to assign a projected ship date to each order line according to weekly output rate, production delay date, and Friday shipments:
  ![Projected Ship Dates Function](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/Projected%20Ship%20Dates%20Function.png)

  - Joined "On Hold" table on order number to get orders on hold.
      
  14. I also added the following calculated columns/measures using DAX:
  - Color On Hold, which is "yellow" for orders on hold and BLANK() for orders not on hold. Used for conditional formatting.
  - Mean Lead Time gives how long customers are waiting on average for a given product group.
  - Last Lead Time gives salespeople an estimated lead time if a new order is booked today.
  - Weekly Order Frequency gives average frequency of orders per week for a given product group.

  15. I also implemented security roles by geographic region so that salespeople can only see orders in their own territory:
  ![Security Roles](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c60a1db079fbcc40ee37e6ab17e0d9649a8d3032/Advanced%20Project%20%235%3A%20Projected%20Ship%20Dates%20in%20Power%20BI/Images/Security%20Roles.png)

  **Advanced Project #6: Many-to-Many with Greenlist Accessories**
  
  1. This report takes the weekly Greenlist (orders that have been approved to ship this week according to the Projected Ship Dates report) and lets the warehouse/Shipping Department know if there are accessory items needed with the shippable appliance. This report is essential at Micromeritics because it prevents the unawareness of required accessory items from holding up large revenue from instruments.
  2. The data model behind this report is unique in that it handles a "many-to-many" relationship between appliances and accessory items. That is, many appliances can have the same accessory and one appliance may have many accessories that go with it. Microsoft warns against using many-to-many relationships without understanding the "significantly different behavior:"
  PICTURE

  3. For this portfolio project, I tried to limit the size of the dataset while preserving the many-to-many relationship, which is in the LIVE version of this report. Below are SolaCorp's list of accessory kits and their corresponding appliance number(s):
  PICTURE

  4. Note that there are 5 appliances with accessories. Each appliance has between 2 and 6 accessory items. All 5 appliances have the BASIC_KIT accessory. This table defines the many-to-many relationship between appliance and accessory item. The entire data model is given below:
  PICTURE

  5. The Greenlist table is constructed using the same semantic model as the Projected Ship Dates report, filtering only to orders that are projected to ship within the next week. This Greenlist is joined (merged) to the table of open sales order lines and all null rows are filtered out. This leaves only the sales order lines that are expected to ship this week. The Power Query M code for the Open Sales Orders table can be found at this [GitHub location](link incoming).
  6. Available inventory for each item is calculated by transforming the Bin Contents table. Each row of Bin Contents represents a known quantity of an item within a warehouse bin. In this example, we will say that only alphabetical bin codes are available while numeric bins are not. Available inventory is found by filtering out these numeric bins then grouping by item code:
  PICTURE

  7. There are two key factors in handling the many-to-many relationship in this model. The first setting the data type of available inventory/accessory inventory in Bin Contents to text. The second is adding a decimal field called "Backlog Fraction" to the Accessory Kits table, which is the reciprocal of the "Multiplier" field (the number of accessories a given item has).
  8. When the Accessory Kits table is joined (merged) to the Open Sales Orders table on item number, order lines with accessory-having items will be duplicated/n-tuplicated by the "Multiplier" field where only the accessory items and accessory inventories will be distinct from one another. Order lines without accessories will not be duplicated and contain null values for accessory information:
  PICTURE

  9. After replacing null values with 0 for "Quantity per Parent" and 1 for "Backlog Fraction," I joined Bin Contents to Open Sales Orders on item number to get available inventory as a text field. Now the table is ready for manipulation in Power BI.
  10. I added 3 calculated columns and 7 measures to the Open Sales Order table using DAX. These are also essential in handling the many-to-many relationship:
  - Backlog Qty Number = VALUE('Open Sales Orders'[Backlog Quantity])
  - Backlog Fraction Number = 'Open Sales Orders'[Backlog Fraction] * 'Open Sales Orders'[Backlog Qty Number]
  - Backlog Fraction Number Measure = SUM('Open Sales Orders'[Backlog Fraction Number])
  - Backlog Qty Total = ROUND(SUM('Open Sales Orders'[Backlog Qty Number]), 0)
  - Accessory Inventory Measure = VALUE(FIRSTNONBLANK('Open Sales Orders'[Accessory Inventory], 'Open Sales Orders'[Accessory Inventory]))
  - Available Inventory Measure = VALUE(FIRSTNONBLANK('Open Sales Orders'[Available Inventory], 'Open Sales Orders'[Available Inventory]))
  - Accessory Quantity Total = [Backlog Qty Total] * VALUE(FIRSTNONBLANK('Open Sales Orders'[Quantity per Parent], 'Open Sales Orders'[Quantity per Parent]))
  - Has Accessory Kit = IF('Open Sales Orders'[Accessory Item Number] = BLANK(), FALSE(), TRUE())
  - NEED KITS = IF([Accessory Quantity Total] > [Accessory Inventory Measure], "NEED KITS", "OK FOR THIS WEEK")
  - NEED PARTS = IF([Backlog Fraction Number Measure] > [Available Inventory Measure], "NEED PARTS", IF([Backlog Fraction Number Measure] <= [Available Inventory Measure], "OK FOR THIS WEEK", ""))
  11. The first 4 of these columns and measures convert the backlog quantity to a number, multiply this number by the backlog fraction row-wise, and sum these values over duplicated rows to reobtain backlog quantity despite duplicated rows.
  12. The next 3 measures take the first non-blank text value for available inventory and convert to a number that can be summarized in a table.
  13. NEED KITS and NEED PARTS let report users know how many of each accessory kit/part they need to procure before greenlisted orders can ship. These warnings can be found in the Accessory Kits and Item Summary report pages:
  PICTURE

  **Advanced Project #7: Consolidated Operating Model**
  
  1. WORK IN PROGRESS
