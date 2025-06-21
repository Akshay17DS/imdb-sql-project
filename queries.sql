-- Query 1
SELECT movie_title, imdb_score
FROM movie_metadata
ORDER BY imdb_score DESC
LIMIT 5;

-- Query 2
SELECT title_year, MAX(gross) AS max_gross
FROM movie_metadata
WHERE title_year IS NOT NULL
GROUP BY title_year
ORDER BY title_year;

-- Query 3
SELECT genres, COUNT(*) AS movie_count
FROM movie_metadata
WHERE genres IS NOT NULL
GROUP BY genres
ORDER BY movie_count DESC;

-- Query 4
SELECT language, ROUND(AVG(budget), 0) AS avg_budget
FROM movie_metadata
WHERE budget IS NOT NULL
GROUP BY language
ORDER BY avg_budget DESC;

-- Query 5
SELECT director_name, COUNT(*) AS movie_count
FROM movie_metadata
GROUP BY director_name
HAVING COUNT(*) > 1
ORDER BY movie_count DESC;

-- Query 6
SELECT title_year, SUM(gross) AS total_gross
FROM movie_metadata
WHERE title_year IS NOT NULL
GROUP BY title_year
ORDER BY title_year;

-- Query 7
SELECT movie_title, gross, budget
FROM movie_metadata
WHERE gross > budget;

-- Query 8
SELECT movie_title, gross, budget,
  CASE 
    WHEN gross >= budget THEN 'Hit'
    ELSE 'Flop'
  END AS performance
FROM movie_metadata
WHERE budget IS NOT NULL AND gross IS NOT NULL;

-- Query 9
SELECT movie_title, imdb_score,
  CASE 
    WHEN imdb_score >= 8 THEN 'Excellent'
    WHEN imdb_score >= 6 THEN 'Good'
    WHEN imdb_score >= 4 THEN 'Average'
    ELSE 'Poor'
  END AS rating_category
FROM movie_metadata
WHERE imdb_score IS NOT NULL;

-- Query 10
SELECT director_name, AVG(imdb_score) AS avg_score
FROM movie_metadata
GROUP BY director_name
HAVING COUNT(*) >= 3
ORDER BY avg_score DESC
LIMIT 5;

-- Query 11
SELECT language
FROM movie_metadata
GROUP BY language
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Query 12
SELECT mc.movie_title, mc.actor_name, mm.imdb_score
FROM movie_cast mc
INNER JOIN movie_metadata mm ON mc.movie_title = mm.movie_title;

-- Query 13
SELECT mm.movie_title, mm.imdb_score, mc.actor_name
FROM movie_metadata mm
LEFT JOIN movie_cast mc ON mm.movie_title = mc.movie_title;

-- Query 14
SELECT mc.actor_name, AVG(mm.imdb_score) AS avg_score, COUNT(*) AS movie_count
FROM movie_cast mc
JOIN movie_metadata mm ON mc.movie_title = mm.movie_title
WHERE mm.imdb_score > 7
GROUP BY mc.actor_name
HAVING COUNT(*) >= 3;

-- Query 15
WITH actor_movies AS (
  SELECT actor_name, COUNT(*) AS movie_count
  FROM movie_cast
  GROUP BY actor_name
)
SELECT * FROM actor_movies
WHERE movie_count >= 5;

-- Query 16
WITH actor_avg AS (
  SELECT mc.actor_name, AVG(mm.imdb_score) AS avg_score, COUNT(*) AS movie_count
  FROM movie_cast mc
  JOIN movie_metadata mm ON mc.movie_title = mm.movie_title
  GROUP BY mc.actor_name
)
SELECT * FROM actor_avg
WHERE movie_count >= 4
ORDER BY avg_score DESC
LIMIT 5;

-- Query 17
WITH ranked AS (
  SELECT language, movie_title, gross,
    ROW_NUMBER() OVER(PARTITION BY language ORDER BY gross DESC) AS rn
  FROM movie_metadata
  WHERE gross IS NOT NULL
)
SELECT * FROM ranked WHERE rn = 1;

-- Query 18
WITH ranked AS (
  SELECT director_name, movie_title, imdb_score,
    ROW_NUMBER() OVER(PARTITION BY director_name ORDER BY imdb_score DESC) AS rn
  FROM movie_metadata
  WHERE imdb_score IS NOT NULL
)
SELECT * FROM ranked WHERE rn = 1;

-- Query 19
WITH ranked AS (
  SELECT content_rating, movie_title, imdb_score,
    RANK() OVER(PARTITION BY content_rating ORDER BY imdb_score DESC) AS rank
  FROM movie_metadata
)
SELECT * FROM ranked WHERE rank = 1;

-- Query 20
WITH ranked AS (
  SELECT language, movie_title, gross,
    DENSE_RANK() OVER(PARTITION BY language ORDER BY gross DESC) AS rank
  FROM movie_metadata
)
SELECT * FROM ranked WHERE rank <= 3;

