# Solamon-Portfolio-Projects - Advanced Projects #5, #6, and #7

In these three advanced projects, I will demonstrate my ability to build semantic models in the Power Platform that provide valuable characterizations of operational and financial data.

### **Project List:**

  - [**Project #5:** Projected Ship Dates in the Power Platform](https://github.com/gsolamon/Solamon-Portfolio-Projects/tree/main/Advanced%20Project%20%235:%20Projected%20Ship%20Dates%20in%20Power%20BI)
  - [**Project #6:** Greenlist Accessories Report](link incoming)
  - [**Project #7:** Consolidated Operating Model](link incoming)


### **Project Summaries:**

  **Advanced Project #5: Projected Ship Dates in the Power Platform**
  
  1. This dataflow/report takes the order backlog of the fictitious company "SolaCorp" and organizes it into a queue, assigning projected ship dates by taking into account output rates, production delays, orders on hold, and hot orders.
  2. The primary fact table of this model is the backlog (found at [SolaCorp Backlog.xlsx](link incoming)), which is made using Power BI Dataflows, Power BI Report Builder, and Power Automate to warehouse in Sharepoint. Each line of the backlog is an open order line:
  PICTURE
     
  3. In the "SolaCorp Backlog.xlsx" file, you can see how I generated the item descriptions using the dimension table in the "Item Description Generator" worksheet. SolaCorp manufactures 181 SKUs of 65 cooking appliances within 9 distinct product groups:
  PICTURE

  4. The "SolaCorp Projected Ship Dates.pbix" file (found at [this link](link incoming)) contains the report interface that is used by production planners, salespeople, and customer service representatives across the organization:
  PICTURE

  5. At Micromeritics Instrument Corporation (MIC), we use this report to schedule production and provide estimated shipping dates to salespeople/customers.
  6. The Projected Ship Dates data model can be seen below. SolaCorp Backlog is the fact table while Hot Orders, On Hold, Output Rates, and Product Groups are dynamic dimension tables:
  PICTURE
  
  7. Our dimension tables are maintained by our operations liason using the [SolaCorp Hot Orders + Output Rates + On Hold.xlsx](link incoming) file.
  8. The "Hot Orders" worksheet allows him to re-rank orders within product groups that need to be pushed up in the production schedule by pasting valid order number/item number combinations in columns A and B:
  PICTURE

  9. "Output Rates" allows us to set weekly output rates for each product group.
  10. "On Hold" leaves the order in the queue, but highlights the entry in yellow on the report usign conditional formatting so that customer service/accounting knows to work with the customer on payments:
  PICTURE

  11. The semantic model is mostly created in Power Query by transforming the backlog, joining (merging) dimension tables, and invoking custom ranking/grouping functions. The M code can be found at this [GitHub location](link incoming).
  12. To summarize the model, I take the following steps:
  - Load backlog as CSV using CSV/web contents data connectors.
  - Join "Product Groups" table on item description to get product groups for each order line.
  - Create Order_Item secondary key, enumerate 1 to order quantity, and expand this list onto new rows, giving each item its own line (quantity 1 per line).
  - Joined "Hot Orders" table on order number to get a re-ranked order date for hot orders.
  - Sorted on combined order date, grouped by product group, and used custom RankFunction to queue order lines by combined order date within these sorted groups:
  PICTURE

  - Joined "Output Rates" on product group and used custom function to assign a projected ship date to each order line according to weekly output rate, production delay date, and Friday shipments:
  PICTURE

  - Joined "On Hold" table on order number to get orders on hold.
      
  14. I also added the following calculated columns/measures using DAX:
  - Color On Hold, which is "yellow" for orders on hold and BLANK() for orders not on hold. Used for conditional formatting.
  - Mean Lead Time gives how long customers are waiting on average for a given product group.
  - Last Lead Time gives salespeople an estimated lead time if a new order is booked today.
  - Weekly Order Frequency gives average frequency of orders per week for a given product group.

  15. I also implemented security roles by geographic region so that salespeople can only see orders in their own territory:
  PICTURE

  **Advanced Project #6: Greenlist Accessories Report**
  
  1. WORK IN PROGRESS

  **Advanced Project #7: Consolidated Operating Model**
  
  1. WORK IN PROGRESS
