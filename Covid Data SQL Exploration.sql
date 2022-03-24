-- GREG SOLAMON PORTFOLIO PROJECT - COVID-19
-- gsolamon@gmail.com
-- Data Source: <https://ourworldindata.org/covid-deaths>

-- DATA SOURCE TABLES:
-- Selects entire Covid Data table and orders by country, date.
SELECT *
FROM [Covid Data]
WHERE continent IS NOT NULL -- This qualifier excludes continents and economic statuses from being counted as countries.
ORDER BY 3, 4;

-- Selects entire Country Data table and orders from greatest to least population size.
SELECT *
FROM [Country Data]
WHERE continent IS NOT NULL
ORDER BY population DESC;

-- COVID DATA BY COUNTRY:
-- Returns top 50 countries by number of cases.
SELECT TOP 50 location, MAX(total_cases) AS case_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY location
ORDER BY case_count DESC;

-- Returns top 50 countries by number of deaths.
SELECT TOP 50 location, MAX(CAST(total_deaths AS INT)) AS death_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY location
ORDER BY death_count DESC;

-- Returns country, date, and death percentage for each day in each country.
SELECT covid.location, date, (total_deaths / population) * 100 AS death_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code -- Joins two tables on iso_code so that COVID-19 statistics can be examined against population statistics.
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
ORDER BY 1, 2;

-- Returns chance of having a positive case for each day in each country.
SELECT covid.location, date, (total_cases / population) * 100 AS case_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
ORDER BY 1, 2;

-- Returns top 50 countries by case rate (as a percentage of total population).
-- Note that smaller islands and city-states are overrepresented
SELECT TOP 50 covid.location, (MAX(total_cases) / population) * 100 AS case_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY covid.location, population
ORDER BY case_percentage DESC;

-- Returns top 50 countries by death rate (as a percentage of total population).
SELECT TOP 50 covid.location, (MAX(CAST(total_deaths AS INT)) / population) * 100 AS death_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY covid.location, population
ORDER BY death_percentage DESC;

-- Returns an estimation of chance of dying in each country given a positive case (case-fatality).
-- Note that Bayesian Statistics would need to be used to calculate the actual case-fatality.
SELECT location, (MAX(CAST(total_deaths AS INT)) / MAX(total_cases)) * 100 AS case_fatality_percentage
FROM [Covid Data]
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL -- AND location LIKE '%states%'
GROUP BY location
ORDER BY case_fatality_percentage DESC;

-- CONTINENT DATA:
-- Returns total case count for each continent in descending order.
SELECT continent, MAX(total_cases) AS case_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND continent LIKE 'North%'
GROUP BY continent
ORDER BY case_count DESC;

-- Returns total death count for each continent in descending order.
SELECT continent, MAX(CAST(total_deaths AS INT)) AS death_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND continent LIKE 'North%'
GROUP BY continent
ORDER BY death_count DESC;

-- GLOBAL NUMBERS:
-- Returns global case count, death count, and case-fatality statistic for each day.
SELECT date, SUM(new_cases) AS case_count, SUM(CAST(new_deaths AS INT)) AS death_count, (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS case_fatality_percentage
FROM [Covid Data]
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
GROUP BY date
ORDER BY 1;

-- Returns overall global case count, death count, and case-fatality statistic.
SELECT SUM(new_cases) AS case_count, SUM(CAST(new_deaths AS INT)) AS death_count, (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS case_fatality_percentage
FROM [Covid Data]
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
ORDER BY 1, 2;

-- VACCINATION, TESTS, AND HOSPITAL DATA:
-- Returns percentage of fully vaccinated people for each country as of 03/21/2022 ordered from highest to lowest rate.
SELECT covid.location, (MAX(people_fully_vaccinated) / population) * 100 AS full_vaccination_rate
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY covid.location, population
ORDER BY full_vaccination_rate DESC;

-- Returns continent, country, date, population, new vaccines per day, and a rolling sum of new vaccinations over time in each country (coalesced to 0).
SELECT covid.continent, covid.location, date, population, COALESCE(new_vaccinations, 0) AS new_vaccinations, SUM(COALESCE(CAST(new_vaccinations AS BIGINT), 0)) OVER (PARTITION BY covid.location ORDER BY covid.location, date) AS rolling_vaccinations -- Note that coalesce sets NULL values to 0 to reflect time before vaccines were available.
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
ORDER BY 2, 3;

-- Returns continent, country, date, population, new tests per day, a rolling sum of new tests (coalesced to 0), and COVID positive rate over time in each country.
SELECT covid.continent, covid.location, date, population, COALESCE(new_tests, 0) AS new_tests, SUM(COALESCE(CAST(new_tests AS BIGINT), 0)) OVER (PARTITION BY covid.location ORDER BY covid.location, date) AS rolling_tests, positive_rate -- Note that coalesce sets NULL values to 0 to reflect time before tests were available.
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
ORDER BY 2, 3;

-- Returns hospital patient count, hospitalization percentage (of total population), ICU patient count, and ICU patient percentage for each date in each country.
-- Note that summation aggregations cannot be done with this data set because patients stay in the hospital/ICU for variable amounts of time.
SELECT covid.continent, covid.location, date, population, hosp_patients AS hospital_patients, (hosp_patients / population) * 100 AS hospitalization_percentage, COALESCE(icu_patients, 0) AS icu_patients, (icu_patients / population) * 100 AS icu_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
ORDER BY 2, 3;

-- USING CTE TO SEE PROGRESSION OF NEW VACCINATIONS:
WITH VaccinatedPop (continent, location, date, population, new_people_vaccinated_smoothed, rolling_people_vaccinated)
AS
(
SELECT covid.continent, covid.location, date, population, COALESCE(new_people_vaccinated_smoothed, 0) AS new_vaccinations, SUM(COALESCE(CAST(new_people_vaccinated_smoothed AS BIGINT), 0)) OVER (PARTITION BY covid.location ORDER BY covid.location, date) AS rolling_people_vaccinated
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
)
SELECT *, (rolling_people_vaccinated / population) * 100 AS rolling_vaccination_percentage
FROM VaccinatedPop;

-- CREATING A TEMPORARY TABLE TO SHOW PROGRESSION OF VACCINATION AND CASES:
DROP TABLE IF EXISTS #VaccinatedPopPercent
CREATE TABLE #VaccinatedPopPercent
(
continent NVARCHAR(255),
location NVARCHAR(255),
date DATETIME,
population NUMERIC,
new_people_vaccinated_smoothed NUMERIC,
rolling_people_vaccinated NUMERIC
)

INSERT INTO #VaccinatedPopPercent
SELECT covid.continent,
	covid.location,
	date,
	population,
	COALESCE(new_people_vaccinated_smoothed, 0),
	SUM(COALESCE(CAST(new_people_vaccinated_smoothed AS BIGINT), 0)) OVER (PARTITION BY covid.location ORDER BY covid.location, date)
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
;

SELECT *, (rolling_people_vaccinated / population) * 100 AS rolling_vaccination_percentage
FROM #VaccinatedPopPercent;

-- CREATING VIEWS TO BE USED IN VISUALIZATIONS PROJECT:
USE [Covid Project]
GO

-- Cases by country.
CREATE VIEW CasesByCountry AS
SELECT location, MAX(total_cases) AS case_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY location;
GO

-- Deaths by country.
CREATE VIEW DeathsByCountry AS
SELECT location, MAX(CAST(total_deaths AS INT)) AS death_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY location;
GO

-- Country, date, and death percentage for each day in each country.
CREATE VIEW CountryDateDeathPercentage AS
SELECT covid.location, date, (total_deaths / population) * 100 AS death_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
;
GO

-- Chance of having a positive case for each day in each country.
CREATE VIEW CaseByDayByCountry AS
SELECT covid.location, date, (total_cases / population) * 100 AS case_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
;
GO

-- Case percentage by country.
CREATE VIEW CasePercentageByCountry AS
SELECT covid.location, (MAX(total_cases) / population) * 100 AS case_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY covid.location, population;
GO

-- Death percentage by country.
CREATE VIEW DeathPercentageByCountry AS
SELECT covid.location, (MAX(CAST(total_deaths AS INT)) / population) * 100 AS death_percentage
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY covid.location, population;
GO

-- Case-fatality percentage by country
CREATE VIEW CaseFatalityByCountry AS
SELECT location, (MAX(CAST(total_deaths AS INT)) / MAX(total_cases)) * 100 AS case_fatality_percentage
FROM [Covid Data]
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL -- AND location LIKE '%states%'
GROUP BY location;
GO

-- Case count by continent.
CREATE VIEW CasesByContinent AS
SELECT continent, MAX(total_cases) AS case_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND continent LIKE 'North%'
GROUP BY continent;
GO

-- Death count by continent.
CREATE VIEW DeathsByContinent AS
SELECT continent, MAX(CAST(total_deaths AS INT)) AS death_count
FROM [Covid Data]
WHERE continent IS NOT NULL -- AND continent LIKE 'North%'
GROUP BY continent;
GO

-- Global case count, death count, and case-fatality statistic for each day.
CREATE VIEW GlobalCasesDeathsCaseFatality AS
SELECT date, SUM(new_cases) AS case_count, SUM(CAST(new_deaths AS INT)) AS death_count, (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS case_fatality_percentage
FROM [Covid Data]
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
GROUP BY date;
GO

-- Vaccination rate by country.
CREATE VIEW VaccinationRateByCountry AS
SELECT covid.location, (MAX(people_fully_vaccinated) / population) * 100 AS full_vaccination_rate
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
GROUP BY covid.location, population;
GO

CREATE VIEW VaccinatedPopView AS
WITH VaccinatedPop (continent, location, date, population, new_people_vaccinated_smoothed, rolling_people_vaccinated)
AS
(
SELECT covid.continent, covid.location, date, population, COALESCE(new_people_vaccinated_smoothed, 0) AS new_vaccinations, SUM(COALESCE(CAST(new_people_vaccinated_smoothed AS BIGINT), 0)) OVER (PARTITION BY covid.location ORDER BY covid.location, date) AS rolling_people_vaccinated
FROM [Covid Data] AS covid
LEFT JOIN [Country Data] AS country
ON covid.iso_code = country.iso_code
WHERE covid.continent IS NOT NULL -- AND covid.location LIKE '%states%'
)
SELECT *, (rolling_people_vaccinated / population) * 100 AS rolling_vaccination_percentage
FROM VaccinatedPop;