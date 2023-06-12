-- Data Cleaning Project - Netflix Movies and TV Shows Dataset


-- Exploring the Dataset
SELECT * FROM movie_data;
------------------------------------------------------------------------------------------------------

-- Identifying and removing duplicates. Checking for and eliminating any duplicate rows in the dataset. Duplicates can skew analysis results and itroduce inaccuracies.

-- No duplicates - shows 8807 rows of total records
SELECT DISTINCT(show_id)
FROM movie_data;

-- Identifying duplicates - no duplicates found
SELECT show_id, COUNT(*) as num_of_duplicates
FROM movie_data
GROUP BY(show_id)
HAVING COUNT(*) > 1
ORDER BY show_id DESC;

-- If there were duplicate values, we can use the query below to remove them
DELETE FROM movie_data
WHERE show_id NOT IN (
    SELECT MIN(show_id)
    FROM movie_data
    GROUP BY show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description
);
------------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT * FROM movie_data;

-- Adding a new column (new_date_converted) with a data type (Date) 
ALTER TABLE movie_data
ADD new_date_converted Date;

-- Setting and updating the new_date_converted column equals to the date_added column with a new data type (Date)
UPDATE movie_data
SET new_date_converted = CONVERT(Date, date_added)

-- Removing the date_added column since I added the new_date_converted column with the approperiate data type formart (Date) to the table
ALTER TABLE movie_data
DROP COLUMN date_added;

---------------------------------------------------------------------------------------------------------------------------------------------

-- Identifying columns with missing values and deciding how to handle them

SELECT
    COUNT(CASE WHEN show_id IS NULL THEN 1 END) AS showid_nulls,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_nulls,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_nulls,
    COUNT(CASE WHEN director IS NULL THEN 1 END) AS director_nulls,
    --COUNT(CASE WHEN cast IS NULL THEN 1 END) AS cast_nulls,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_nulls,
    --COUNT(CASE WHEN date_added IS NULL THEN 1 END) AS date_added_nulls,
	COUNT(CASE WHEN new_date_converted IS NULL THEN 1 END) AS new_date_converted_nulls,
    COUNT(CASE WHEN release_year IS NULL THEN 1 END) AS release_year_nulls,
    COUNT(CASE WHEN rating IS NULL THEN 1 END) AS rating_nulls,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_nulls
    --COUNT(CASE WHEN listed_in IS NULL THEN 1 END) AS listed_in_nulls,
    --COUNT(CASE WHEN description IS NULL THEN 1 END) AS description_nulls
FROM movie_data;

-- Handeling the missing values

-- Using the COALESCE() function to set the null values in the director column equla to 'Unknown'
UPDATE movie_data
SET director = COALESCE(director, 'Unknown');

-- Replacing missing values in the country column and filling in with a default value 'Not Available'
UPDATE movie_data
SET country = 'Not Available'
WHERE country IS NULL;

-- Both the rating and duration have 3 null values so I will delete them
DELETE FROM movie_data
WHERE rating IS NULL OR duration IS NULL;

-------------------------------------------------------------------------------------------------

-- Fixing inconsistent or misspelled values

select * from movie_data;

UPDATE movie_data 
SET type = 'Movie'
WHERE type IN ('M', 'm', 'movies');

UPDATE movie_data 
SET type = 'TV Show'
WHERE type IN ('TV', 'tv', 'shows');

-- Replacing misspelled country names

UPDATE movie_data
SET country = 'United States'
WHERE country = 'United Sates'

------------------------------------------------------------------------------------------------------

-- Cleaning Text Data - Remonving leading and trailing spaces

UPDATE movie_data
SET type = TRIM(type),
    title = TRIM(title),
    director = TRIM(director),
    country = TRIM(country);

---------------------------------------------------------------------------------------------------------------------

-- Removing unnecessary columns

ALTER TABLE movie_data
DROP COLUMN cast;

ALTER TABLE movie_data
DROP COLUMN description;

ALTER TABLE movie_data
DROP COLUMN listed_in;

