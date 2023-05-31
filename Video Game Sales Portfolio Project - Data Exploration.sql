/*
Video Game Sales Dataset - Data Exploration
*/


-- Retrieving the total number of records in the dataset

SELECT COUNT(*) AS TotalRecords
FROM vgsales;


-- Showing the top-selling games of all time

SELECT Name, Global_Sales
FROM vgsales
ORDER BY Global_Sales DESC;


-- Showing the total sales for each gaming platform

SELECT Platform, SUM(Global_Sales) AS TotalSales
FROM vgsales 
GROUP BY Platform;


-- Identifying the most popular genres based on sales

SELECT Genre, SUM(Global_Sales) AS TotalSales
FROM vgsales
GROUP BY Genre
ORDER BY TotalSales DESC;


-- Calculating the average sales per year

SELECT Year, AVG(Global_Sales) AS Average_Sales 
FROM vgsales 
GROUP BY Year
ORDER BY Year DESC;


-- Showing top publishers with the highest sales

SELECT Publisher, ROUND(SUM(Global_Sales), 2) AS TotalSales
FROM vgsales
GROUP BY Publisher
ORDER BY TotalSales DESC


-- Finding the distribution of games across different platforms

SELECT Platform, COUNT(*) AS GameCount
FROM vgsales
GROUP BY Platform
ORDER BY GameCount DESC;


-- Calculating the average sales per genre

SELECT Genre, ROUND(AVG(Global_Sales), 2) AS AverageSales
FROM vgsales
GROUP BY Genre
ORDER BY AverageSales DESC;


-- Identifying the best-selling games for each year

SELECT Year, Name, Global_Sales
FROM (
    SELECT Year, Name, Global_Sales,
    ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Global_Sales DESC) AS rn
    FROM vgsales
) AS sub
WHERE rn = 1;


-- Retrieving the total sales for each region (NA, EU, JP, Other)

SELECT
  SUM(NA_Sales) AS NA_Sales,
  SUM(EU_Sales) AS EU_Sales,
  SUM(JP_Sales) AS JP_Sales,
  SUM(Other_Sales) AS Other_Sales
FROM vgsales;


-- Finding the top-selling games for a specific platform(PS4)

SELECT Name, Global_Sales
FROM vgsales
WHERE Platform = 'PS4'
ORDER BY Global_Sales DESC;



-- Finding the top-selling games released in a specific year(2004)

SELECT Name, Global_Sales
FROM vgsales
WHERE Year = '2004'
ORDER BY Global_Sales DESC;


-- Identify the platforms with the highest number of games release

SELECT Platform, COUNT(*) AS GameCount
FROM vgsales
GROUP BY Platform
ORDER BY GameCount DESC;



-- Finding the top publishers with the highest sales growth rate

SELECT Publisher, (MAX(Global_Sales) - MIN(Global_Sales)) / MIN(Global_Sales) AS SalesGrowthRate
FROM vgsales
GROUP BY Publisher
HAVING COUNT(DISTINCT Year) > 1
ORDER BY SalesGrowthRate DESC;



-- Identifying the genres that have experienced the highest decline in sales over the years

SELECT Genre, (MIN(Global_Sales) - MAX(Global_Sales)) / MAX(Global_Sales) AS SalesDeclineRate
FROM vgsales
GROUP BY Genre
HAVING COUNT(DISTINCT Year) > 1
ORDER BY SalesDeclineRate DESC;



-- Categorizing games into different sales ranges based on global sales

SELECT Name, Global_Sales,
    CASE
        WHEN Global_Sales < 1 THEN 'Low Sales'
        WHEN Global_Sales >= 1 AND Global_Sales < 10 THEN 'Moderate Sales'
        WHEN Global_Sales >= 10 AND Global_Sales < 50 THEN 'High Sales'
        ELSE 'Very High Sales'
    END AS SalesCategory
FROM vgsales;



--Assigning a popularity rating to games based on their global sales

SELECT Name, Global_Sales,
    CASE
        WHEN Global_Sales >= 10 THEN 'Very Popular'
        WHEN Global_Sales >= 5 AND Global_Sales < 10 THEN 'Popular'
        WHEN Global_Sales >= 1 AND Global_Sales < 5 THEN 'Moderately Popular'
        ELSE 'Not Popular'
    END AS PopularityRating
FROM vgsales;



-- Categorizing games by their release decade

SELECT Name, Year,
    CASE
        WHEN Year >= '1980' AND Year < '1990' THEN '1980s'
        WHEN Year >= '1990' AND Year < '2000' THEN '1990s'
        WHEN Year >= '2000' AND Year < '2010' THEN '2000s'
        WHEN Year >= '2010' AND Year < '2020' THEN '2010s'
        ELSE '2020s and Beyond'
    END AS ReleaseDecade
FROM vgsales;



-- Determining the region with the highest sales for each game

SELECT Name, NA_Sales, EU_Sales, JP_Sales, Other_Sales,
    CASE
        WHEN NA_Sales >= EU_Sales AND NA_Sales >= JP_Sales AND NA_Sales >= Other_Sales THEN 'North America'
        WHEN EU_Sales >= NA_Sales AND EU_Sales >= JP_Sales AND EU_Sales >= Other_Sales THEN 'Europe'
        WHEN JP_Sales >= NA_Sales AND JP_Sales >= EU_Sales AND JP_Sales >= Other_Sales THEN 'Japan'
        ELSE 'Other Regions'
    END AS HighestSalesRegion
FROM vgsales;



-- Retrieving games released between 2010 and 2015 (inclusive)

SELECT *
FROM vgsales
WHERE Year BETWEEN 2010 AND 2015;



-- Retrieving games published by Nintendo or Sony

SELECT *
FROM vgsales
WHERE Publisher IN ('Nintendo', 'Sony');



-- Retrieving games where the platform is not DS or Wii

SELECT *
FROM vgsales
WHERE Platform NOT IN ('DS', 'Wii');


-- Retrieving games with a null value for the publisher

SELECT *
FROM vgsales
WHERE Publisher IS NULL;


-- Retrieving games with global sales greater than 1 million and released in 2010 or later

SELECT *
FROM vgsales
WHERE Global_Sales > 1.0 AND Year >= 2010;



-- Retrieving games with a name containing "Mario"

SELECT *
FROM vgsales
WHERE Name LIKE '%Mario%';



-- Retrieving games with sales greater than 1 million in North America and Europe

SELECT *
FROM vgsales
WHERE NA_Sales > 1.0 AND EU_Sales > 1.0;



-- Retrieving publishers with a total sales greater than 5 million

SELECT Publisher, SUM(Global_Sales) AS TotalSales
FROM vgsales
GROUP BY Publisher
HAVING SUM(Global_Sales) > 5.0;