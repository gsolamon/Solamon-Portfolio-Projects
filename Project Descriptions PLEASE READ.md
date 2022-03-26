# Solamon-Portfolio-Projects

The purpose of completing these projects is to demonstrate my proficiency in the skills required for a career in data analytics or business intelligence.

### **Project List:**

  - [**Project #1:** COVID-19 Data Exploration in SQL](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/4ce04f2fe36f4cd38c422f059bd7ce914641a344/Project%20%231%20Queries.sql)
  - [**Project #2:** COVID-19 Data Visualization in Microsoft Power BI](https://app.powerbi.com/view?r=eyJrIjoiNzUzOGUxOWYtMTdjZi00ZWY2LWEzMWQtNWY0NzkyOTYxMTMxIiwidCI6IjRjY2NhM2I1LTcxY2QtNGU2ZC05NzRiLTRkOWJlYjk2YzZkNiIsImMiOjN9)
  - **Project #3:** Cleaning Housing Data in SQL **(work in progress)**
  - **Project #4:** Building Visuals in Python **(work in progress)**

### **Project Summaries:**

  **Project #1: COVID-19 Data Exploration in SQL**
  
  1. Installed MS Access, MS SQL Server 2019 Express, and MS SQL Server Management Studio (SSMS) on my personal desktop.
  2. Downloaded large COVID-19 dataset from Our World in Data (Source: [Our World in Data Covid Deaths](https://ourworldindata.org/covid-deaths)).
  3. Used Microsoft Excel to split the CSV file into a Covid Data workbook (100,000+ rows) and a Country Data workbook (217 rows) to show SQL joins later in project.
  5. Connected to local SQLEXPRESS server and named it "Covid Project."
  6. Imported Covid Data and Country Data workbooks as tables into my Covid Project SQL Server.
  7. Wrote 31 total queries in Microsoft SQL Server Management Studio to explore key statistics in Covid Data and created 12 views that will be used in Project #2.
  8. Query details below:
     - 2 queries to display all data in Covid Data and Country Data workbooks.
     - 7 queries for country case count, case rate, death count, death rate, and case-fatality statistics, some over all dates and some aggregate (MAX) over time.
     - 2 queries for continent case and death count.
     - 2 queries for global statistics.
     - 4 queries for country vaccination, testing, hospitalization, and ICU admissions over time.
     - 1 using CTE to obtain rolling vaccination percentage over time.
     - 1 using temporary table to obtain rolling vaccination percentage over time.
     - 12 views created to be used in Project #2.
  9. SQL Skills used:
     - SELECT statements, WHERE, TOP N, LIKE
     - ORDER BY, GROUP BY, PARTITION OVER
     - Aggregate functions, SUM, MAX, MIN
     - LEFT JOIN ON, aliases, primary/foreign keys
     - COALESCE, CAST
     - Data types, INT, BIGINT, NVARCHAR, NUMERIC, DATETIME
     - Common Table Expressions (CTE), WITH
     - Temporary tables, DROP, CREATE, INSERT INTO
     - CREATE VIEW, USE, GO (to create all 12 views in a single query batch)

  **Project #2: Visualizing COVID-19 Data in Power BI**
  
  1. [Completed Power BI Dashboard Link](https://app.powerbi.com/view?r=eyJrIjoiNzUzOGUxOWYtMTdjZi00ZWY2LWEzMWQtNWY0NzkyOTYxMTMxIiwidCI6IjRjY2NhM2I1LTcxY2QtNGU2ZC05NzRiLTRkOWJlYjk2YzZkNiIsImMiOjN9)
  2. If the Power BI dashboard is not available (for licensing reasons or whatever) please see this following PNG infographic, which outlines its features:
  
  ![PNG infographic](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/f262aa7946a8b4269cdc6a06dba11e4cce322001/Power%20BI%20Dashboard%20Infographic.PNG)
  
  3. Procedure and skills:
     - Opened a blank report in Power BI Desktop.
     - Clicked "Get Data" and connected to my local machine's SQLEXPRESS server to find "Covid Data" database.
     - Imported the 12 SQL views that I had created during Project #1 into Power BI and began to transform them in Power Query Editor window.
     - Used Power Query Editor to make column names more readable, convert decimals to percentages, change datetimes to dates, rearrange columns, and replace NULL values with 0 to increase model performance.
     - Used Power Query Editor to merge the 12 original views into 3 new data tables (MergedContinentData, MergedCountryData, and MergedDateData), which were used to generate most of my visuals.
     - Created 4 new measures in DAX using aggregate functions then displayed them in 4 card visuals with conditional text formatting to show case and death severity for a selected region.
     - Created a customized theme to be more readable.
     - Created Continent Data column chart to show COVID-19 cases by continent; created tooltips with more detailed data; turned off slicer interactions to avoid redundant visuals.
     - Created Country Data bar chart to show COVID-19 cases by country; created tooltips with more detailed data; kept slicer interactions on "filter;" added X-axis slider to make smaller country data more readable.
     - Created line graph to show case percentage progression for each country over time starting from March 21, 2020, and ending March 21, 2022; created a visual-level filter to only display the TOP 10 countries by population from a selected region (by default China, India, United States, etc.); kept slicer interactions on to respond to user selections.
     - Created a Filled Map visual with conditional formatting to color countries based upon their overall case count; created tooltip to show number of deaths and population size; kept auto-zoom and user-controlled zoom.
     - Published report to Microsoft Power BI Web Service and made it public (via first link in this section).
     - Also created a Live Dashboard by pinning this report, but I cannot share it because my trial access of Power BI Web Service is almost expired.
  
  **Project #3: Cleaning Housing Data in SQL**
  1. Work in progress.

  **Project #4: Building Visuals in Python**
  1. Work in progress.
