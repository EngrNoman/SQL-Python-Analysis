USE master;

SELECT * FROM netflix_raw;	

SELECT * FROM netflix_raw 
WHERE show_id ='s5023';


-- Remove duplicates

SELECT show_id,COUNT(*)
FROM netflix_raw 
GROUP BY show_id 
HAVING COUNT(*) > 1;

SELECT * FROM netflix_raw
WHERE concat(title,type) in (
SELECT concat(title,type)
FROM netflix_raw
GROUP BY title,type
HAVING COUNT(*) > 1
)
ORDER BY title;


with cte as(
SELECT *
, ROW_NUMBER() over (partition by title , type order by show_id) as rn
FROM netflix_raw
)
SELECT show_id,type,title,CAST(date_added AS date) AS date_added , release_year
,rating, CASE WHEN duration IS NULL THEN rating ELSE duration END AS duration , description
INTO netflix
FROM cte 
WHERE rn=1

SELECT * FROM netflix


-- NEW Table for listed_in , director , country , cast

SELECT show_id , trim(value) as director
into netflix_director
FROM netflix_raw
CROSS APPLY STRING_SPLIT(director , ',');

SELECT show_id , trim(value) as country
into netflix_country
FROM netflix_raw
CROSS APPLY STRING_SPLIT(country , ',');

SELECT show_id , trim(value) as cast
into netflix_cast
FROM netflix_raw
CROSS APPLY STRING_SPLIT(cast , ',');

SELECT show_id , trim(value) as listed_in
into netflix_listed_in
FROM netflix_raw
CROSS APPLY STRING_SPLIT(listed_in , ',');

SELECT * 
FROM netflix_listed_in

-- Populate the Missing Value in Country , duration Columns
SELECT * 
FROM netflix_raw
WHERE country IS NULL

SELECT * 
FROM netflix_country
WHERE show_id ='s3';

INSERT INTO netflix_country
SELECT show_id, m.country
FROM netflix_raw nr
INNER JOIN(
SELECT director , country
FROM netflix_country nc
INNER JOIN netflix_director nd 
ON nc.show_id = nd.show_id
GROUP BY director , country
) m ON nr.director = m.director
WHERE nr.country IS NULL


----------
SELECT *
FROM netflix_raw
WHERE duration IS NULL;




