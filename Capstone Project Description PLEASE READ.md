# Solamon-Portfolio-Projects - Capstone Project: Executive Dashboards with Expert Modeling

This capstone project will mirror one of my most valuable reports in production at Micromeritics Instrument Corporation. It delivers a high-level synopsis of operations through well-defined KPIs and intuitive drill-down capabilties. We use the report as our slide deck for weekly revenue meetings because the golden data model behind the report allows the presenter to answer almost any question that a stakeholder can have about our business.

### **Project Phases:**

  - [**Final Product:** Executive Dashboards]()
  - [**Build Phase #1:** ERP Customizations with D365 Business Central AL]()
  - [**Build Phase #2:** Orchestrating Dataflows with Power Automate and Sharepoint]()
  - [**Build Phase #3:** ETL and Data Modeling with Power Query M]()
  - [**Build Phase #4:** DAX Measures and Dashboarding in Power BI]()

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
  
  1. A diagram showing the orchestration of data from D365 Business Central to Power BI is given below. Please note that this orchestration only applies for the LIVE version of this report. This capstone project references STATIC files on GitHub that were generated by redacting/randomizing information from our Sharepoint warehouse:

  ![ERP to Power BI Orchestration]()
     
  2. Most of the data for these executive dashboards starts in the ERP (D365 Business Central).
  3. We use Power BI dataflows and the Business Central API connector to read table data into staging dataflows.
  4. We use these staging dataflows as a data source for either Power BI semantic models or secondary dataflows to apply transformation steps. Using staging dataflows allows for much faster ETL.
  5. We end up with semantic models containing cleaned tables for sales, orders, backlog, current greenlist, and any necessary helper tables.
  6. We then use Power BI Report Builder to build paginated reports of these cleaned tables using the published semantic models as our data sources.
  7. After publishing these paginated reports to a premium Power BI workspace, we can use Power Automate to refresh our models on a schedule and export our paginated reports to an XLSX file.
  8. Power Automate can then update a file location in Sharepoint, which acts as an informal data warehouse. If we were dealing with larger volumes of data, we may choose to use CSV files, a MS SQL Server data warehouse, or Fabric Data Lakehouse.
  9. In the next section, I will talk about ETL from this Sharepoint warehouse and building the "golden" data model.


  **Build Phase #3: ETL and Data Modeling with Power Query M**
  
  1. When reading data from the Sharepoint warehouse into Power Query, we use the Web Contents connector (because it is significantly faster than the Sharepoint connector).
  2. Because I have already done extensive cleansing when moving data from the "bronze" layer in Business Central to the "silver" layer in the Sharepoint warehouse, the transformation steps in Power Query when building the "golden" layer are fairly simple. For the most part, I only use filtering and aggregation. However, below is an example of a more advanced method that I used:

     - Extracted a previous week (Saturday PM) backlog snapshot from the data warehouse. Added a primary key called "Order_Line," which was defined as {Order Number}_{Line Number}.
     - Added a "Ship Qty" field to a new table called "Warehouse Shipment Lines" by taking all warehouse shipments up to the end of the previous fiscal week and agregating ship quantity over the primary key (Order_Line).
     - Added an "Inv Qty" field to the "Warehouse Shipment Lines" table by taking all invoices up to the end of the previous fiscal week, aggregating invoice quantity over the primary key (Order_Line), and joining/merging this field to the "Warehouse Shipment Lines" table on the Order_Line key.
     - Subtracted "Ship Qty" minus "Inv Qty" to get a new field "Ship-Not-Inv Qty" and "Ship-Not-Inv $" then joined these fields to the PW backlog snapshot to get the list of orders from last week that were shipped but not invoiced by Customer Service. This is one of their most important KPIs and gives a more accurate picture of the Shipping Department's performance:

  ![Ship-Not-Inv]()

  3. Below are some of these principles that I kept in mind to keep the average refresh time under 2 minutes despite the large number of aggregations and joins:

     - Use normalized data to import narrow fact tables and short as possible dimension tables.
     - Filter rows, remove columns, join, and group before using transformations that will break query folding like change type, add index, or window functions.
     - Pre-aggregating tables where you don't need high granularity will give you performance when loading visuals/slicing, but it will slow down refresh times. Push these types of pre-aggregations to the silver layer.

  4. After applying these transformation steps in Power Query, we now build the relationships between the tables in the model view of Power BI:
 
  ![Golden Data Model]()
  
  5. This "golden" data model is expertly built for the following reasons:

     - All fact tables (tables with red stars) are built using star schema and are always the "many" part of a one-to-many relationship (yellow highlight). This feature is essential for having performant visuals and simple DAX.
     - Dimension tables (labeled with blue "d") are always the "one" side of a one-to-many relationship. Furthermore, I use dimension tables for slicers with single-direction filtering whenever possible.
     - I have dedicated date tables for the current backlog, historic parts backlog, historic instruments backlog, and sales/orders tables so that these dimension tables can be as short as possible.
     - Instead of using one wide, highly granular fact table, I use 7 narrow, pre-aggregated fact tables to optimize visual and slicer performance.
     - I handle a many-to-many relationship between sales/order week and fiscal week using a bridge table (labeled with green "B"). A given sales/order week can have many sales, and a given fiscal week can have many dates.


  **Build Phase #4: DAX Measures and Dashboarding in Power BI**
  
  When a data model is well-built, we can avoid using complex DAX to tell our data story. For each of the following report pages, I will briefly describe the purpose, features, and any DAX that was required to build the view.
  
  1. Summary:

     - The purpose is to summarize Operations, Shipping, and Customer Service KPIs and provide stakeholders with an estimate of this week's revenue.
     - There is no advanced DAX on this slide (only SUM over 4 pre-filtered tables).
  
  2. PW Inst. Shipments vs. Greenlist:

     - This page shows the breakdown of PW sales by instrument and the composition of the CW greenlist. Carryover on the CW greenlist from the PW greenlist is shown as yellow:

      ![CW Greenlist by Inst.]()

     - We accomplish this conditional formatting using DAX and the field value conditional formatting option:

      ![Color Carryover]()
  
  3. CW Greenlist:

     - This page gives details on the CW greenlist and allows users to slice the table to know what percentage of the greenlist belongs to a certain category:

     ![CW Greenlist Notes]()

     - Some of the DAX on this page is advanced. For example, the "Instrument" column takes each order line of the greenlist, assigns an instrument with " xQty" if more than one are being sold to "Instrument Quantity," and aggregates over the order number with CONCATENATEX to get a comma separated list of instruments for each order:

     ![CW Greenlist Instruments DAX]()

     - The % of Total DAX is also complex, but we will cover it in the next page.
  
  4. Inst. Shipments:

     - This page delivers a similar view of instrument sales, but the users can slice by fiscal week and instrument. This is the most important page for determining the volume and mix of our shipments:
 
     ![Inst. Shipments Notes]()

     - The "% of Total" DAX measure is one of the most elegant measures in this report. It lets the user set the fiscal week slicer to any combination of weeks, treats this filter context as 100%, and then allows the user to set other slicers (like instrument, country, intercompany, or customer) to give a percent of subtotal for that given timeframe:

     ![Percent of Total]()
  
  6. Instrument Backlog:

     - This and the following pages are true dashboards that provide the user with countless options for slicing and drilling into data. We have used it at our company to identify orders that should be taken off hold, which instruments to prioritize building, and how our backlog is trending.

     ![Instrument Backlog Notes]()

     - I used DAX to build the "By Order Age" graph by adding two calculated column to the backlog called "Aging Days" and "Aging Category." Aging days is defined as the duration between today and order date. Aging Category groups orders into <30d, 30d+, 60d+, 90d+, 180d+ based upon aging days. The most complex DAX in this graph is what I used to set the y-axis scale:
 
     ![Aging Scale DAX]()

     - The measures related to the fiscal calendar in the "CY Orders and Shipments" visual are fairly advanced because of the many-to-many relationship. I have DAX measures in the "Fiscal Weeks Bridge" table for [Today], [Current Fiscal Week], and [Previous Fiscal Week], which allows me to use these in a calculated column called "Fiscal Weeks Slicer:"

     ![Fiscal Week Slicer DAX]()

     - Using this calculated column in a slicer allows me to set the default value of the slicer to "Previous Fiscal Week" so that the data updates from week to week without the user needing to change the slicer. However, the user can still see any combination of past fiscal weeks if they desire:

     ![Fiscal Week Slicer Selection]()
  
  7. Parts-Only Backlog:

     - This page provides a similar BI value as the previous page. However, it only looks at parts-only orders (no instruments). This partitioning provides a visibility to small orders that may be overlooked in preference of higher revenue instrument orders, which causes customer complaints and downtime.