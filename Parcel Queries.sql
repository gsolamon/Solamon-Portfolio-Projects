-- GREG SOLAMON PORTFOLIO PROJECT #3: CLEANING HOUSING DATA IN SQL (ETL)
-- gsolamon@gmail.com

-- Original CSV file can be found on Henderson County, NC, website: <https://hendersoncountync.sharefile.com/share/view/s8ceee93ece54dbb9/fod01be9-6fee-41e3-9de5-c8ce062aa493>.

-- ISSUES SUMMARY:
-- 1. Too many irrelevant or empty columns.
-- 2. Duplicate rows for a single land sale.
-- 3. Many rows were delimited incorrectly, which shifted other data into the wrong field.
-- 4. All data types are strings, even the dates and numeric values.
-- 5. All entries have redundant single quotes (') around each string.
-- 6. Empty cells use double quotes ('') instead of NULL.
-- 7. Mailing addresses are only split into components, no concatenations available.
-- 8. Date columns use DATETIME format even when it is better to use DATE.
-- 9. Some addresses use '0   NO ADDRESS ASSIGNED ' instead of NULL.
-- 10. Addresses with no building number use '0   ' as the number.
-- 11. Some addresses are completely missing.


-- EXTRACTION STEPS:
-- Displays entire Parcels table ordered by location address.
SELECT *
FROM Parcels
--ORDER BY ['LOCATION_ADDR']
;

-- Explores key aggregations in order to validate the dataset.
SELECT COUNT(['PARCEL_PK']) AS totalParcelCount,
	COUNT(DISTINCT ['LOCATION_ADDR']) AS distinctAddresses,
	MIN(['AUT_SNAPSHOT_DATE']) AS earliestSnapshot,
	MAX(['AUT_SNAPSHOT_DATE']) AS latestSnapshot,
	COUNT(DISTINCT ['CITY']) AS cityCount,
	COUNT(DISTINCT ['FIRE_DISTRICT']) AS fireDistrictCount,
	SUM(CAST(RIGHT(LEFT(['ACREAGE'], LEN(['ACREAGE']) -1), LEN(['ACREAGE']) - 2) AS NUMERIC)) AS totalAcreage,
	SUM(CAST(RIGHT(LEFT(['TOTAL_PROP_VALUE'], LEN(['TOTAL_PROP_VALUE']) -1), LEN(['TOTAL_PROP_VALUE']) - 2) AS NUMERIC)) AS totalPropertyValue,
	ROUND(AVG(CAST(RIGHT(LEFT(['TOTAL_PROP_VALUE'], LEN(['TOTAL_PROP_VALUE']) -1), LEN(['TOTAL_PROP_VALUE']) - 2) AS NUMERIC)), 2) AS avgPropertyValue,
	COUNT(DISTINCT ['PROPERTY_OWNER']) AS ownerCount,
	COUNT(DISTINCT ['Appraiser']) AS appraiserCount
FROM Parcels;

-- Returns concatenated mailing address (with trimmed strings and carriage returns) for each land owner (to make a mailing list).
SELECT
	RIGHT(LEFT(['PROPERTY_OWNER'], LEN(['PROPERTY_OWNER']) -1), LEN(['PROPERTY_OWNER']) - 2) + CHAR(13) +
	IIF(['OWNER_MAIL_2'] IS NULL,
		RIGHT(LEFT(['OWNER_MAIL_1'], LEN(['OWNER_MAIL_1']) -1), LEN(['OWNER_MAIL_1']) - 2),
		RIGHT(LEFT(['OWNER_MAIL_1'], LEN(['OWNER_MAIL_1']) -1), LEN(['OWNER_MAIL_1']) - 2) + CHAR(13) + RIGHT(LEFT(['OWNER_MAIL_2'], LEN(['OWNER_MAIL_2']) -1), LEN(['OWNER_MAIL_2']) - 2)
	) + CHAR(13) +
	RIGHT(LEFT(['OWNER_MAIL_CITY'], LEN(['OWNER_MAIL_CITY']) -1), LEN(['OWNER_MAIL_CITY']) - 2) + ', ' +
	RIGHT(LEFT(['OWNER_MAIL_STATE'], LEN(['OWNER_MAIL_STATE']) -1), LEN(['OWNER_MAIL_STATE']) - 2) + ' ' +
	RIGHT(LEFT(['OWNER_MAIL_ZIP'], LEN(['OWNER_MAIL_ZIP']) -1), LEN(['OWNER_MAIL_ZIP']) - 2)
	AS ownerMailingAddresses
FROM Parcels
-- WHERE ['PROPERTY_OWNER'] = 'WAL MART REAL ESATE BUSINESS TRUST'
;

-- TRANSFORMATION STEPS:
-- Deletes rows that were entered or delimited incorrectly.
DELETE
FROM Parcels
WHERE DELETE_IF_NOT_EMPTY IS NOT NULL; -- Incorrect delimiting pushed data into this field when it would have been empty if the data were delimited correctly.

-- Drops columns that contain no data.
ALTER TABLE Parcels
DROP COLUMN IF EXISTS DELETE_IF_NOT_EMPTY, F92, F93, F94, F95, F96, F97, F98, F99, F100, F101, F102, F103, F104, F105, F106, F107, F108;

-- Test code to determine how to left and right trim the ' characters from date strings.
SELECT ['DEED_DATE'], CONVERT(DATE, RIGHT(LEFT(['DEED_DATE'], 20), 19), 120)
FROM Parcels;

-- Converting all 'yyyy-mm-dd hh:mm:ss' STRINGS to DATE format using TRY_CONVERT.
UPDATE Parcels
SET
	['AUT_SNAPSHOT_DATE'] = TRY_CONVERT(DATE, RIGHT(LEFT(['AUT_SNAPSHOT_DATE'], 20), 19), 120),
	['DEED_DATE'] = TRY_CONVERT(DATE, RIGHT(LEFT(['DEED_DATE'], 20), 19), 120),
	['PKG_SALE_DATE'] = TRY_CONVERT(DATE, RIGHT(LEFT(['PKG_SALE_DATE'], 20), 19), 120),
	['LAND_SALE_DATE'] = TRY_CONVERT(DATE, RIGHT(LEFT(['LAND_SALE_DATE'], 20), 19), 120)
;

-- Test code to fetch the name of a column given some offset.
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Parcels'
ORDER BY COLUMN_NAME
OFFSET 10 ROWS
FETCH NEXT 1 ROW ONLY;

-- Test code to see how empty strings were written in table and compare with rules for SQL Server escape characters.
SELECT NULLIF(['OLD_MAP'], '''''')
FROM Parcels;

-- Test code to determine how to write Dynamic SQL with empty strings.
SELECT 'SET [' + (
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'Parcels'
	ORDER BY COLUMN_NAME
	OFFSET 10 ROWS
	FETCH NEXT 1 ROW ONLY
) + '] = NULLIF([' + (
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'Parcels'
	ORDER BY COLUMN_NAME
	OFFSET 10 ROWS
	FETCH NEXT 1 ROW ONLY
) + '], '''''''''''')'
FROM Parcels;

-- USING DYNAMIC SQL TO REPLACE ALL INSTANCES OF EMPTY STRING '' WITH NULL:
-- Declare 3 temporary variables.
DECLARE @CurrentColumn AS INT = 1;

DECLARE @ColCount AS INT
	= (SELECT COUNT(COLUMN_NAME)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'Parcels');

DECLARE @sql AS NVARCHAR(MAX);

-- While loop that writes then executes Dynamic SQL to change all instances of '' to NULL for the entire table (not just one column).
WHILE @CurrentColumn <= @ColCount
BEGIN
	SET @sql =
		'UPDATE Parcels
		SET [' + (
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'Parcels'
			ORDER BY COLUMN_NAME
			OFFSET @CurrentColumn ROWS
			FETCH NEXT 1 ROW ONLY
		) + '] = NULLIF([' + (
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'Parcels'
			ORDER BY COLUMN_NAME
			OFFSET @CurrentColumn ROWS
			FETCH NEXT 1 ROW ONLY
		) + '], '''''''''''')'

	EXEC(@sql);

	SET @CurrentColumn = @CurrentColumn + 1;
END;

-- Replaces '0   NO ADDRESS ASSIGNED ' with NULL.
UPDATE Parcels
SET ['LOCATION_ADDR'] = NULLIF(['LOCATION_ADDR'], '''0   NO ADDRESS ASSIGNED  ''');

-- Replaces NULL addresses with the property description (often an address).
UPDATE Parcels	
SET ['LOCATION_ADDR'] = ISNULL(['LOCATION_ADDR'], ISNULL(['PROPERTY_DESCR'], ['ZONING']));

-- Removes '0   ' from addresses with no building number.
UPDATE Parcels
SET ['LOCATION_ADDR'] = REPLACE(['LOCATION_ADDR'], '''0   ', '''');

-- Replaces owner's ZIP code with the 9-digit version if the extra digits are given.
UPDATE Parcels
SET ['OWNER_MAIL_ZIP'] = IIF(['OWNER_MAIL_PLUS_4'] IS NULL, ['OWNER_MAIL_ZIP'], LEFT(['OWNER_MAIL_ZIP'], 6) + '-' + LEFT(RIGHT(['OWNER_MAIL_PLUS_4'], 5), 4) + '''');

-- Removes duplicate property sale rows using CTE.
WITH duplicatesCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ['LOCATION_ADDR']
	ORDER BY ['LOCATION_ADDR']
	) AS rowNumber
FROM Parcels
)
DELETE
FROM duplicatesCTE
WHERE rowNumber > 1;

-- Drops irrelevant columns from Parcels.
ALTER TABLE Parcels
DROP COLUMN IF EXISTS ['REID'], ['PIN'], ['PIN_EXT'], ['PIN_MAP'], ['PIN_BLOCK'], ['PIN_LOT'], ['OLD_MAP'], ['VCS'], ['SPEC_DIST'], ['SPEC_DIST_PCNT'], ['TOWNSHIP'], ['PERMIT_DATE'], ['PERMIT_NUMBER'], ['HISTORY_REID_1'], ['HISTORY_REID_2'], ['TOTAL_LAND_VALUE_ASSESSED'], ['TOTAL_BLDG_VALUE_ASSESSED'], ['LAND_USE_VALUE'], ['USE_VALUE_DEFERRED'], ['HISTORIC_VALUE_DEFERRED'], ['TOTAL_DEFERRED_VALUE'], ['COST_TOTAL_VALUE'], ['INCOME_TOTAL_VALUE'], ['SALES_COMP_TOTAL_VALUE'], ['REVENUE_STAMPS'], ['TOTAL_UNITS'], ['RECYCLE_UNITS'], ['APT_SC_SQRFT'], ['HEATED_AREA'], ['OTHER_EXMPT'], ['VETRANS_EXCL'], ['DEED_PATH'], ['ACCOUNT_TYPE'], ['CITY_CODE'], ['FIRE_DISTRICT_CODE'], ['PHYADDR_STR_MISC'], ['TOTAL_OBLDG_VALUE'], ['MAP_BOOK'], ['MAP_PAGE'], ['MAP_SCALE'], ['MAP_ROD_DOC_ID'], ['IS_PENDING'], ['Assignment_Group'], ['PLAT_BOOK'], ['PLAT_PAGE'];

-- LOADING STEP:
-- Creates view of final Parcels table.
GO
CREATE VIEW ParcelsFinal AS
SELECT *
FROM Parcels;