# Solamon-Portfolio-Projects

The purpose of completing these projects is to demonstrate my proficiency in the skills required for a career in data analytics or business intelligence.

### **Project List:**

  - [**Project #1:** COVID-19 Data Exploration in SQL](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/4ce04f2fe36f4cd38c422f059bd7ce914641a344/Project%20%231%20Queries.sql)
  - [**Project #2:** COVID-19 Data Visualization in Microsoft Power BI](https://app.powerbi.com/view?r=eyJrIjoiNzUzOGUxOWYtMTdjZi00ZWY2LWEzMWQtNWY0NzkyOTYxMTMxIiwidCI6IjRjY2NhM2I1LTcxY2QtNGU2ZC05NzRiLTRkOWJlYjk2YzZkNiIsImMiOjN9)
  - [**Project #3:** Cleaning Housing Data in SQL (ETL)](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/d77e687f087d7e365c3723597acb71785a1435fb/Project%20%233:%20Cleaning%20Housing%20Data%20in%20SQL%20(ETL)/Parcel%20Queries.sql)
  - [**Project #4:** Visualizing Spotify Data in Python](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/77c68a0648f8fa792d922a3a267448bb718ab321/Project%20%234:%20Visualizing%20Spotify%20Data%20in%20Python/Portfolio%20Project%20%234.ipynb)

### **Project Summaries:**

  **Project #1: COVID-19 Data Exploration in SQL**
  
  1. Installed MS Access, MS SQL Server 2019 Express, and MS SQL Server Management Studio (SSMS) on my personal desktop.
  2. Downloaded large COVID-19 dataset from Our World in Data (Source: [Our World in Data Covid Deaths](https://ourworldindata.org/covid-deaths)).
  3. Used Microsoft Excel to split the CSV file into a "Covid Data" workbook (100,000+ rows) and a "Country Data" workbook (217 rows) to show SQL joins later in project.
  5. Connected to local SQLEXPRESS server and named it "Covid Project."
  6. Imported "Covid Data" and "Country Data" workbooks as tables into my "Covid Project" SQL Server database.
  7. Wrote 31 total queries in Microsoft SQL Server Management Studio to explore key statistics in "Covid Data" and created 12 views that will be used in Project #2.
  8. Query details below:
     - 2 queries to display all data in "Covid Data" and "Country Data" workbooks.
     - 7 queries for country case count, case rate, death count, death rate, and case-fatality statistics using TOP N filters and aggregate functions (MAX and SUM).
     - 2 queries for continent case and death count.
     - 2 queries for global statistics.
     - 4 queries for country vaccination, testing, hospitalization, and ICU admissions over time.
     - 1 using CTE to obtain rolling vaccination percentage over time.
     - 1 using temporary table to obtain rolling vaccination percentage over time.
     - 12 views created to be used in Project #2.
  9. SQL skills used:
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
  2. If the Power BI dashboard is not available (for licensing or other reasons) please see this following PNG infographic, which outlines its features:
  
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
  
  **Project #3: Cleaning Housing Data in SQL (ETL)**
  
  1. Found public housing dataset for Henderson County, NC, on their website (Source: [Henderson County Government Website](https://hendersoncountync.sharefile.com/share/view/s8ceee93ece54dbb9/fod01be9-6fee-41e3-9de5-c8ce062aa493)).
  2. Downloaded and extracted large CSV file called "parcels" on the website (69,000+ rows with many data quality issues).
  3. Summary of data quality issues:
     - Too many irrelevant or empty columns.
     - Duplicate rows for a single land sale.
     - Many rows were delimited incorrectly, which shifted other data into the wrong field.
     - All data types are strings, even the dates and numeric values.
     - All entries have redundant single quotes (') around each string.
     - Empty cells use double quotes ('') instead of NULL.
     - Mailing addresses are only split into components, no concatenations available.
     - Date columns use DATETIME format even when it is better to use DATE.
     - Some addresses use '0   NO ADDRESS ASSIGNED ' instead of NULL.
     - Addresses with no building number use '0   ' as the number.
     - Some addresses are completely missing.
  4. Connected to new "Housing Project" database using Microsoft SQL Server Management Studio and imported "Parcels" spreadsheet as a database object.
  5. Wrote queries in SQL to extract, transform, and load (ETL) this originally messy dataset to turn it into a clean, organized table view (which can be viewed at [this file location](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/d77e687f087d7e365c3723597acb71785a1435fb/Project%20%233:%20Cleaning%20Housing%20Data%20in%20SQL%20(ETL)/Final%20Henderson%20Land%20Parcels.xlsx)).
  6. Extraction steps:
     - 1 query to view entire Parcels table with ordering.
     - 1 multi-part query to validate and aggregate key statistics.
     - 1 query to reformat and concatenate address data so that a mailing list can be made.
  7. Transformation steps:
     - 1 query deletes rows that were incorrectly delimited.
     - 1 query drops empty columns from table.
     - 1 query trims unnecessary single quotes (') from strings entries then converts from STRING to DATE type.
     - 4 queries convert all columns with datetime STRINGs into DATE type.
     - 3 test queries to check aspects of Dynamic SQL that will be used.
     - 1 complex query uses Dynamic SQL that iterates through all columns (began with 90 total) and replaces all double quotes ('') with NULL.
     - 4 queries that clean address formats, replace '0   NO ADDRESS ASSIGNED ' with NULL, and append 4-digit ZIP code extension to mailing ZIP code if it is given.
     - 1 query uses CTE to remove duplicate rows where only one land sale occured.
     - 1 query drops all irrelevant rows.
  8. Load step:
     - 1 query creates a table view that can be used to export to Excel, Power BI, or other visualization software.
  9. SQL skills used:
     - Aggregate functions, COUNT, MIN, MAX, SUM, AVG, etc.
     - Escape characters, string reformatting, LEN, RIGHT, LEFT, CHAR(13)
     - Datatypes, CAST, CONVERT, TRY_CONVERT, NVARCHAR, INT, NUMERIC
     - DELETE, ALTER, UPDATE, DROP, IF EXISTS
     - ORDER BY, OVER, PARTITION BY, OFFSET, FETCH
     - DECLARE, SET, temporary variables
     - Dynamic SQL, WHILE loop
     - NULLIF, ISNULL, IIF
     - CTE, WITH, AS
     - CREATE VIEW, GO

  **Project #4: Visualizing Spotify Data in Python**
  
  1. Found public Spotify track library database (250,000+ rows; about 10,000 tracks per genre) on Kaggle (Source: [Kaggle Spotify Database](https://www.kaggle.com/datasets/zaheenhamidani/ultimate-spotify-tracks-db)).
  2. Opened new Python Notebook in Jupyter. Completed Python Notebook can be found on [my GitHub at this location](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/77c68a0648f8fa792d922a3a267448bb718ab321/Project%20%234:%20Visualizing%20Spotify%20Data%20in%20Python/Portfolio%20Project%20%234.ipynb). **Please note that some results (namely textual outputs) do not always display properly in the GitHub Notebook View. If you want to see all Python outputs, you may need to download the Python Notebook file and run the code in your own Python IDE. All tables, graphs, and images seem to display correctly.**
  3. Imported Python libraries: pandas, numpy, seaborn, and matplotlib.
  4. Read CSV file "SpotifyFeatures.csv" into the DataFrame (df) from my downloads folder.
  5. Used "df.head()" to read a sample of the data columns.
  6. Checked for missing data using "np.mean(df[col].isnull())" then displayed results.
  7. Checked data types of the columns using "df.dtypes"; some are objects, some are integers, and some are float64.
  8. Checked how many unique genres Spotify uses (there are 26 but two of them are "Children's Music" and 'Children’s Music').
  9. Used "df.loc[(df.genre == "Children's Music"), 'genre'] = 'Children’s Music'" to rewrite entries with "Children's Music" as 'Children’s Music'.
  10. Checked that 'popularity' is scored as an integer from 0 to 100.
  11. Calculated min, max, and average values of numerical columns to get an idea of their general characteristics.
  12. Sorted by popularity to see which songs were most popular on Spotify in this subset.
  13. Dropped any duplicate rows; created "df2" using "df2 = df.drop_duplicates(subset = ['track_name', 'artist_name'], keep = 'first')
," which drops any duplicate occurences with the same title and artist (but different genres).
  14. Made 10 correlation hypotheses (the definitions of each Spotify track feature can be found at [Spotify's Developer Website](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features)).
  15. Created 10 scatterplots using matplotlib and 1 regression plot using seaborn to show relationship between the numerical variables and track popularity:

  ![PNG Scatterplots](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c5351340ce5b4033432b8898c1c0816e82c4987f/Project%20%234:%20Visualizing%20Spotify%20Data%20in%20Python/Visuals%20Folder/PopularityScatterplotsSummary.PNG)
  
     A. shows negative correlation with regression line between acousticness and popularity
     B. shows popularity vs. acousticness (0 being mixed, 1 being acoustic)
     C. shows popularity vs. danceability
     D. shows popularity vs. duration in milliseconds
     E. shows popularity vs. energy 
     F. shows popularity vs. liveness (0 being recorded, 1 being live performance)
     G. shows popularity vs. loudness (in dB)
     H. shows popularity vs. instrumentalness (0 being lyrical, 1 being instruments-only)
     I. shows popularity vs. speechiness (0 being no words being used, 1 being very many words used)
     J. shows popularity vs. tempo (in beats per minute)
     K. shows popularity vs. valence (0 being very sad/depressing, 1 being very happy/uplifting)
  16. Created correlation matrix and heat map (shown below #16) to show which numerical variables were most or least correlated.
  17. Created 3 scatterplots using seaborn that were clustered by genre to see how genre affected relationships between speechiness, valence, instrumentalness, and popularity:
  
  ![PNG Clustered Plots](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/c5351340ce5b4033432b8898c1c0816e82c4987f/Project%20%234:%20Visualizing%20Spotify%20Data%20in%20Python/Visuals%20Folder/HeatmapClusteredScatterplots.PNG)
  
     L. shows heat map of correlations between numerical variables (black being strong negative correlation, white being strong positive correlation, and red/purple being weak or no correlation
     M. shows clustered scatterplot of popularity vs. speechiness with strong clustering of "comedy" genre with high speechiness and moderate popularity
     N. shows scatterplot of popularity vs. instrumentalness with no noticeable clusters
     O. shows scatterplot of popularity vs. valence with no noticeable clusters.
  18. Used for loop, if statement, and "df_numerical[col_name].cat.codes" to quantify categorical data fields ('genre', 'key', 'mode', and 'time_signature').
  19. Used these quantified categories to create an extended correlation matrix that now measured the effect of categorical variables on numerical variables.
  20. Returned sorted list of strongly negative correlation pairs that were between -1 < r <= -0.4.
  21. Returned sorted list of strongly positive correlation pairs that were between 0.4 <= r < 1.
  22. Made conclusions on which variables were most correlated:
      - Higher valence (happier) songs had more energy (r = +0.436771).
      - Louder songs were more danceable (r = +0.438668).
      - Live-sounding tracks were speechier (r = +0.510147).
      - Higher valence (happier) songs were more danceable (r = +0.547154).
      - Louder songs had higher energy (r = +0.816088).
      - Acoustic songs had lower energy (r = -0.725576).
      - Acoustic songs were less loud (r = -0.690202).
      - Instrumental songs were less loud (r = -0.506320).
      - Speechiness showed strong clustering by genre.
      - Instrumentalness did not show clustering by genre.
  23. This type of study would be very useful when examining marketing or sales data to see which product categories are most popular and which variables have the greatest correlations between each other.
  24. Python skills used:
      - importing, aliases, reading csv, changing display settings, head()
      - loc[], unique()
      - print(), min(), max(), mean()
      - sort_values(by = ?)
      - drop_duplicates(subset = ?, keep = ?)
      - plt.scatter(), sns.regplot(), sns.heatmap(), sns.scatterplot(x = ?, y = ?, data = df, hue = 'genre', legend = 'full')
      - corr(method = 'pearson'), 'spearman', 'kendall'
      - for loop, if(), astype(), cat.codes
      - unstack(), between()

**Thank you for reading. -Greg Solamon**
