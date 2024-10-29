# Solamon-Portfolio-Projects - Capstone Project: Executive Dashboards with Expert Modeling

This capstone project will mirror one of my most valuable reports in production at Micromeritics Instrument Corporation. It delivers a high-level synopsis of operations through well-defined KPIs and intuitive drill-down capabilties. We use the report as our slide deck for weekly revenue meetings because the golden data model behind the report allows the presenter to answer almost any question that a stakeholder can have about our business.

### **Project Phases:**

  - [**Final Product:** Executive Dashboards]()
  - [**Build Phase #1:** ERP Customizations with D365 Business Central AL]()
  - [**Build Phase #2:** Orchestrating Dataflows with Power Automate and Sharepoint]()
  - [**Build Phase #3:** ETL and Data Modeling with Power Query M]()
  - [**Build Phase #4:** DAX Measures and Dashboarding in Power BI]()

### **Project Phase Descriptions:**

  **Final Product: Executive Dashboards**

  1. Here is a direct link to the report: [SolaCorp Executive Dashboards]()
  2. The purpose of this report is to provide executive-level stakeholders and key operations personnel with insights into week-over-week manufacturing performance. The most important questions that the report answers are:

  - How much product did we ship last week?
  - How much revenue can we expect from these shipments?
  - How much was shipped but not invoiced last week?
  - How much do we plan on shipping this week (current week greenlist)?
  - How much of the previous week greenlist did not ship last week?
  - How much of our CW greenlist is on hold? How much is intercompany? Where are they shipping?
  - What was the impact of our orders/shipments on the backlog?
  - What is the composition of our backlog? How much is on hold? What are our top items?
  - What is our backlog aging? Which orders are the oldest?
  
  3. The report answers the first four of these questions in the executive summary page:

  ![Executive Summary]()
     
  4. The rest can be answered in subsequent pages with user-friendly interfaces:

  ![Inst. Shipments]()

  ![Instrument Backlog]()


  **Build Phase #1: ERP Customizations in D365 Business Central AL**
  
  1. This project uses some light ERP customization to help users coordinate the greenlist in the ERP (D365 Business Central) and lets the Shipping Department know which orders are clear to ship.
  2. I added a custom enum field called "Color Status" to the Sales Header table that makes the order number bold green when the order has been added to the greenlist using the "Toggle Include in Greenlist" action:

  ![Sales Orders]()
  
  3. The shipment number also turns bold green to allow the Shipping Department to see which orders to work on. If an order has been added to the greenlist in the last 24 hours, the "Recent Greenlist" field will let Shipping know it's new:

  ![Warehouse Shipments]()
  
  4. To achieve these customizations, I used AL code to write page extensions that set a global variable (StyleExprNo) based upon the value of the "Color Status" field:

  ![StyleExprNo]()

  5. I also added 3 actions to the page to allow users to toggle between color statuses. If you would like to see how these are written in AL code, please see [this file]().
  6. The final major feature that I added was a "Recent Greenlist" field, which takes the system current datetime and subtracts from a custom field "Added to Greenlist DateTime" to get a duration. If this duration is less than 24 hours, the field is set to "24 hr." Here is the AL code for this feature:

  ![Recent Greenlist]()


  **Build Phase #2: Orchestrating Dataflows with Power Automate and Sharepoint**
  
  1. Most of the data for these executive dashboards starts in the ERP (D365 Business Central).
  2. We use Power BI dataflows and the Business Central API connector to read table data into staging dataflows.
  3. We use these staging dataflows as a data source for either Power BI semantic models or secondary dataflows to apply transformation steps. Using staging dataflows allows for much faster ETL.
  4. We end up with semantic models containing cleaned tables for sales, orders, backlog, current greenlist, and any necessary helper tables.
  5. We then use Power BI Report Builder to build paginated reports of these cleaned tables using the published semantic models as our data sources.
  6. After publishing these paginated reports to a premium Power BI workspace, we can use Power Automate to refresh our models on a schedule and export our paginated reports to an XLSX file.
  7. Power Automate can then update a file location in Sharepoint, which acts as an informal data warehouse. If we were dealing with larger volumes of data, we may choose to use CSV files or a MS SQL Server data warehouse.


  **Build Phase #3: ETL and Data Modeling with Power Query M**
  
  1. fff


  **Build Phase #4: DAX Measures and Dashboarding in Power BI**
  
  1. 
