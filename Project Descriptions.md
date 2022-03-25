# Solamon-Portfolio-Projects

The purpose of completing these projects is to demonstrate my proficiency in the skills required for a career in data analytics or business intelligence.

### **Project List:**

  - Project #1: COVID-19 Data Exploration in SQL
  - Project #2: COVID-19 Data Visualization in Microsoft Power BI
  - Project #3: Cleaning Housing Data in SQL **(work in progress)**

### **Project Summaries:**

  ####  Project #1: COVID-19 Data Exploration in SQL
  
    1. Installed MS Access, MS SQL Server 2019 Express, and MS SQL Server Management Studio (SSMS) on my personal desktop.
    2. Downloaded large COVID-19 dataset from Our World in Data (Source: https://ourworldindata.org/covid-deaths).
    3. Used Microsoft Excel to split the CSV file into COVID data workbook (100,000+ rows) and a country data workbook (217 rows) to show SQL joins later in project.
    4. Connected to local SQLEXPRESS server and named it "Covid Project."
    5. Imported Covid Data and Country Data workbooks as tables into my Covid Project SQL Server.
    6. Wrote 31 total queries in Microsoft SQL Server Management Studio to explore key statistics in Covid Data and created 12 views that will be used in Project #2.
    7. Query details below:
      - 2 display all data in Covid Data and Country Data workbooks.
      - 7 queries for country case count, case rate, death count, death rate, and case-fatality statistics, some over all dates and some aggregate (MAX) over time.
      - 2 queries for continent case and death count.
      - 2 queries for global statistics.
      - 4 queries for country vaccination, testing, hospitalization, and ICU admissions over time.
      - 1 using CTE to obtain rolling vaccination percentage over time.
      - 1 using temporary table to obtain rolling vaccination percentage over time.
      - 12 views created to be used in Project #2.
    8. SQL Skills used:
      - SELECT statements, WHERE, TOP N, LIKE
      - ORDER BY, GROUP BY, PARTITION OVER
      - Aggregate functions, SUM, MAX, MIN
      - LEFT JOIN ON, aliases, primary/foreign keys
      - COALESCE, CAST
      - Data types, INT, BIGINT, NVARCHAR, NUMERIC, DATETIME
      - Common Table Expressions (CTE), WITH
      - Temporary tables, DROP, CREATE, INSERT INTO
      - CREATE VIEW, USE, GO (to create all 12 views in a single query batch)

  ####  Project #2: Visualizing COVID-19 Data in Power BI
  
    1. <a href="https://app.powerbi.com/view?r=eyJrIjoiNzUzOGUxOWYtMTdjZi00ZWY2LWEzMWQtNWY0NzkyOTYxMTMxIiwidCI6IjRjY2NhM2I1LTcxY2QtNGU2ZC05NzRiLTRkOWJlYjk2YzZkNiIsImMiOjN9" onclick="window.open('https://app.powerbi.com/view?r=eyJrIjoiNzUzOGUxOWYtMTdjZi00ZWY2LWEzMWQtNWY0NzkyOTYxMTMxIiwidCI6IjRjY2NhM2I1LTcxY2QtNGU2ZC05NzRiLTRkOWJlYjk2YzZkNiIsImMiOjN9', '_self');">Completed Power BI Dashboard Link</a>
    2. If the Power BI dashboard is not available please see this [PNG infographic](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/f262aa7946a8b4269cdc6a06dba11e4cce322001/Power%20BI%20Dashboard%20Infographic.PNG), which outlines its features.
    3. 
