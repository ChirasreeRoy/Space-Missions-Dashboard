-- Creating a database
CREATE DATABASE SpaceMissions;

--Creating a table
CREATE TABLE missions (
    company_name VARCHAR(100),
    location VARCHAR(200),
    datum DATE,
    detail VARCHAR(200),
    status_rocket VARCHAR(50),
    rocket VARCHAR(100),
    status_mission VARCHAR(50),
    price DECIMAL(10,2)
);

--Verify the Data
SELECT TOP 100 * FROM missions;

--Check Number of Records  (9)
SELECT COUNT(*)FROM missions;

--Check Nulls  (9)
SELECT * FROM missions
WHERE country IS NULL;


--Check Null Values 
SELECT * FROM missions 
WHERE price IS NULL;

--You should also check other important columns
SELECT * FROM missions
WHERE rocket IS NULL
   OR location IS NULL
   OR MissionStatus IS NULL;

--You can replace missing price values
UPDATE missions
SET price = 0
WHERE price IS NULL;

--Check mission status types (7)
SELECT DISTINCT status_mission FROM missions;

--Standardizing the mission status values  (7)
UPDATE missions
SET MissionStatus = 'Failure'
WHERE MissionStatus = 'Partial Failure';

--Verify Rocket Status (8)
SELECT DISTINCT status_rocket FROM missions; (--“Is the most used rocket still active?”)

--Clean the Price Column
UPDATE missions
SET price = REPLACE(price,'$','');
ALTER TABLE missions
ALTER COLUMN price FLOAT;       --changing the datatype

--Check duplicate records
SELECT mission,
COUNT(*)
FROM missions
GROUP BY mission
HAVING COUNT(*) > 1;

--Check for Exact Duplicate Rows
SELECT *,
COUNT(*) AS duplicate_count
FROM missions
GROUP BY 
company,                           --true duplicates
location,
datum,
rocket,
mission,
status_mission,
status_rocket,
price
HAVING COUNT(*) > 1;

--Check Duplicate Mission Names (Sometimes the mission name repeats, but they are different launches.)
SELECT mission, COUNT(*)
FROM missions
GROUP BY mission
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;               --(If dates are different → not duplicates.)

--Check Duplicate Rocket + Date (better validation)  (Love)
SELECT rocket, datum, COUNT(*)
FROM missions
GROUP BY rocket, datum
HAVING COUNT(*) > 1;                  --(If same rocket + date + location appears twice → that is likely a duplicate.)

--Check duplicates using important columns (1)
SELECT mission, datum, rocket, location, COUNT(*) AS duplicate_count
FROM missions
GROUP BY mission, datum, rocket, location
HAVING COUNT(*) > 1;

--Remove True Duplicates (If They Exist) (2)
WITH duplicates AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, datum, rocket, mission
ORDER BY mission
) AS row_num
FROM missions
)
DELETE FROM duplicates
WHERE row_num > 1;

--How are null values coming in the country column?
UPDATE missions
SET country = RIGHT(location, CHARINDEX(',', REVERSE(location)) - 1);

--Price Column cleaning (3)
--(Some rows contain NaN instead of NULL, Sometimes the column is imported as VARCHAR instead of numeric)
--(For analysis in SQL and Power BI, the price should be numeric.)
   --Check the current values
SELECT DISTINCT price
FROM missions
ORDER BY price;
  --Replace "NaN" with NULL
UPDATE missions
SET price = NULL
WHERE price = 'NaN';
  --Convert the column to numeric
ALTER TABLE missions
ALTER COLUMN price FLOAT;
  --Check again
SELECT *
FROM missions
WHERE price IS NULL;
  --Create a useful metric for Power BI
SELECT country,
AVG(price) AS avg_launch_cost
FROM missions
GROUP BY country
ORDER BY avg_launch_cost DESC;

--How will I remove the null values in time column?
/*(you usually don’t delete rows just because one column (like time) is NULL, 
   unless the column is critical for your analysis.
   In this dataset, time is not needed for most analysis, so many analysts simply ignore it.*/

 --But if you still want to clean/remove NULL values, here are the correct options.
 SELECT *
 FROM missions
 WHERE time IS NULL;

 --Replace NULL with a Default Value (NOT FOR THIS PROJECT)
 UPDATE missions
SET time = '00:00:00'
WHERE time IS NULL;

--Remove Rows with NULL Time (NOT FOR THIS PROJECT)
DELETE FROM missions
WHERE time IS NULL;

/*Total rows are 4629 but distinct mission column count is coming as 4555. 
That means there are duplicates. hOW TO RESOLVE?
4629 - 4555 = 74 duplicate missions
But before deleting anything, we must confirm what exactly is duplicated.*/
   
   --Step 1 — Identify Duplicate Missions
   SELECT mission, COUNT(*) AS duplicate_count
   FROM missions
   GROUP BY mission
   HAVING COUNT(*) > 1
   ORDER BY duplicate_count DESC; --This shows which missions appear more than once

   --Step 2 — Check Full Duplicate Rows
   --Sometimes the entire row is duplicated, not just the mission name.
   SELECT *
  FROM missions
  WHERE mission IN (
    SELECT mission
    FROM missions
    GROUP BY mission
    HAVING COUNT(*) > 1
  )
  ORDER BY mission;

  --Step 3 — Remove Exact Duplicate Rows (Best Method)
  WITH duplicate_cte AS
  (
  SELECT *,
  ROW_NUMBER() OVER(
  PARTITION BY mission
  ORDER BY mission
  ) AS rn
 FROM missions
  )
 DELETE FROM duplicate_cte      /*(Keeps 1 copy of each mission, removes all other duplicates)*/
 WHERE rn > 1;
  
  --Verify
  SELECT COUNT(*) FROM missions;                      --Both should now match
  SELECT COUNT(DISTINCT mission) FROM missions;

  --Sometimes mission names repeat but are not duplicates (for example the same rocket mission name used again).
  --A safer duplicate check is using multiple columns:
  SELECT mission, datum, rocket, location, COUNT(*) FROM missions
  GROUP BY mission, datum, rocket, location           --This ensures you remove true duplicates only.
  HAVING COUNT(*) > 1;

  --First check duplicates using important columns.(1)
  --If duplicates exist, remove them (2)
  --Clean the Price Column (3)
  --Extract Useful Date Features (4)
  --Extract Country from Location (5) 
  --Extract Launch Site (6)
  --Verify Mission Status Categories (7)
  --Verify Rocket Status (8)
  --Final Dataset Check (9)
  
/*In (Love), 5 records are coming as output and count is 2 in each of them. That means there are duplicates.
  Those may or may not be duplicates.*/

  SELECT rocket, date, COUNT(*)
  FROM missions
  GROUP BY rocket, date   /*This means:“Show me cases where the same rocket launched 
                            more than once on the same date.”
                            But in real space missions, multiple launches can happen on the same day using the same rocket model.
                            So this does not automatically mean duplicates.
                            These are different missions, not duplicates.
                            Duplicates should be checked using columns that uniquely identify a mission
                            Many Space Missions datasets actually contain no true duplicates, only:
                            Same rocket used multiple times, Same launch date,Same launch location
                            So your 5 rows may actually be valid records.*/
  HAVING COUNT(*) > 1;

  --Quick Way to Verify (Very Useful)
  SELECT * FROM missions
  WHERE rocket = 'Falcon 9' AND datum = '2020-06-30'; /*Check if mission names differ.
                                                        If they differ → not duplicates*/




--CREATING USEFUL COLUMNS



--Extract year from date (4)
ALTER TABLE missions
ADD launch_year INT;

UPDATE missions
SET launch_year = YEAR(datum);

--Extract month from date (4)
ALTER TABLE missions
ADD launch_month INT;

UPDATE missions
SET launch_month = MONTH(datum);

--Extract Country    (5)
ALTER TABLE missions
ADD country VARCHAR(100);
UPDATE missions
SET country = PARSENAME(REPLACE(location, ',', '.'),1);
     --OR--
SELECT 
RIGHT(location, CHARINDEX(',', REVERSE(location)) - 1) AS country
FROM missions;

--Extract Launch Site  (6)
ALTER TABLE missions
ADD launch_site VARCHAR(150);

UPDATE missions
SET launch_site = LEFT(location, CHARINDEX(',',location)-1);

--Country and site extraction together  (5,6)
ALTER TABLE space_missions
ADD launch_site VARCHAR(100),
    country VARCHAR(100);

UPDATE space_missions
SET 
launch_site = LEFT(location, CHARINDEX(',',location)-1),
country = PARSENAME(REPLACE(location, ',', '.'),1);




--ANALYSIS QUERIES THAT WILL GO TO POWER BI VISUALS



--Rocket Launch Trend Over Time
CREATE VIEW launches_per_year AS
SELECT launch_year,
       COUNT(*) AS total_launches
FROM missions
GROUP BY launch_year
ORDER BY launch_year;

--Has mission success rate increased?
CREATE VIEW success_rate_over_time AS
SELECT 
       launch_year,
       COUNT(*) AS total_missions,
       SUM(CASE 
           WHEN status_mission = 'Success' 
           THEN 1 ELSE 0 END) AS successful_missions,
       ROUND(
       SUM(CASE 
           WHEN status_mission = 'Success' THEN 1 ELSE 0 END) * 100.0
       / COUNT(*),2) AS success_rate
FROM missions
GROUP BY launch_year
ORDER BY launch_year;

--Mission Success Rate
CREATE VIEW mission_success_rate AS
SELECT launch_year,
       COUNT(*) AS total_missions,
       SUM(CASE 
           WHEN status_mission = 'Success' 
           THEN 1 ELSE 0 END) AS successful_missions
FROM missions
GROUP BY launch_year;

--Most Successful Countries
CREATE VIEW country_success AS
SELECT country,
       COUNT(*) AS successful_missions
FROM missions
WHERE status_mission = 'Success'
GROUP BY country
ORDER BY successful_missions DESC;

--Has country dominance changed over time? 
--(1950s–1980s → USSR dominance, 1990s–2000s → USA dominance, 2010s+ → China rising)
CREATE VIEW country_dominance_by_decade AS
SELECT                                                     
       country,
       (launch_year / 10) * 10 AS decade,
       COUNT(*) AS missions
FROM missions
WHERE status_mission = 'Success'
GROUP BY country, (launch_year / 10) * 10
ORDER BY decade, missions DESC;

--Most Used Rockets
CREATE VIEW rocket_usage AS
SELECT rocket,
       status_rocket,
       COUNT(*) AS missions_count
FROM missions
GROUP BY rocket, status_rocket
ORDER BY missions_count DESC;

--Is the rocket still active?
CREATE VIEW rocket_status AS
SELECT 
       rocket,
       status_rocket,
       COUNT(*) AS missions
FROM missions
GROUP BY rocket, status_rocket
ORDER BY missions DESC;

--Launch Site Patterns
CREATE VIEW launch_sites AS
SELECT launch_site,
       country,
       COUNT(*) AS launches
FROM missions
GROUP BY launch_site, country
ORDER BY launches DESC;

--Top Launch Sites in the World
SELECT TOP 10
    LEFT(location, CHARINDEX(',', location) - 1) AS launch_site,
    COUNT(*) AS total_launches
FROM missions
GROUP BY LEFT(location, CHARINDEX(',', location) - 1)
ORDER BY total_launches DESC;

--The rocket used for the most missions.
SELECT TOP 1 * FROM rocket_status --limit used in MYSQL
ORDER BY total_missions DESC;



