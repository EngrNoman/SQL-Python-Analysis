---Netflix Analysis


/*1  for each director count the no of movies and tv shows created by them in separate columns 
for directors who have created tv shows and movies both */
USE master

SELECT  nd.director 
, COUNT(DISTINCT CASE WHEN n.type='MOVIE' THEN n.show_id END) AS no_of_movies
,COUNT(DISTINCT CASE WHEN n.type='TV Show' THEN n.show_id END) AS no_of_tvshow
FROM netflix n
INNER JOIN netflix_director nd 
ON n.show_id = nd.show_id
GROUP BY nd.director
HAVING COUNT(dISTINCT n.type)>1


--2 which country has highest number of comedy movies 
SELECT TOP 1 nc.country , COUNT(DISTINCT nl.show_id) AS no_of_movies
FROM netflix_listed_in nl
INNER JOIN netflix_country nc ON nc.show_id = nl.show_id
INNER JOIN netflix n ON n.show_id = nc.show_id
WHERE nl.listed_in = 'Comedies' AND n.type='Movie'
GROUP BY nc.country 
ORDER BY no_of_movies DESC


--3 for each year (as per date added to netflix), which director has maximum number of movies released
WITH cte AS(
SELECT nd.director , YEAR(n.date_added) As date_Year ,  COUNT(DISTINCT n.show_id) AS no_of_Movies
FROM netflix n 
INNER JOIN netflix_director nd 
ON n.show_id = nd.show_id
WHERE n.type='Movie'
GROUP BY nd.director , YEAR(n.date_added)
)
,cte2 as(
SELECT *
, ROW_NUMBER() over(partition by date_year ORDER BY no_of_Movies DESC) AS rn
FROM cte
-- ORDER BY date_year , no_of_Movies DESC
)
SELECT * from cte2 
WHERE rn=1


-- 4 what is average duration of movies in each genre
SELECT nl.listed_in, AVG(CAST( REPLACE(duration,' min','') AS INT)) AS AVG_duration
FROM netflix n 
INNER JOIN netflix_listed_in nl
ON n.show_id = nl.show_id
WHERE type='Movie'
GROUP BY  nl.listed_in

/* 5  find the list of directors who have created horror and comedy movies both.
 display director names along with number of comedy and horror movies directed by them 
*/

SELECT nd.director
, count(distinct case when nl.listed_in='Comedies' then n.show_id end) as no_of_comedy 
, count(distinct case when nl.listed_in='Horror Movies' then n.show_id end) as no_of_horror
FROM netflix n
INNER JOIN netflix_listed_in nl 
ON n.show_id = nl.show_id
INNER JOIN netflix_director as nd 
ON nd.show_id = n.show_id
WHERE type='Movie' AND nl.listed_in IN('Comedies' , 'Horror Movies')
GROUP BY nd.director
HAVING COUNT(nl.listed_in)=2