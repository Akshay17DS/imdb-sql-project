# 🎬 IMDb SQL Data Analysis Project

This project uses SQL to explore the IMDb 5000 Movie Dataset through real-world queries — covering everything from basic operations like GROUP BY, ORDER BY, and LIMIT, to advanced techniques including joins, CTEs, and window functions.

---

## 📁 Dataset Overview

- **File Used:** `movie_metadata.csv`
- **Rows:** 1,463 movies
- **Columns:** Movie title, director, budget, gross, genres, actors, language, year, IMDb score, etc.
- **Source:** [IMDb 5000 Movie Dataset on Kaggle](https://www.kaggle.com/datasets/carolzhangdc/imdb-5000-movie-dataset)

---

## 🛠️ Tools & Environment

- **Database:** MySQL
- **Interface:** MySQL Workbench
- **Data Imported As:** `movie_metadata`

---

## 🧠 SQL Concepts Demonstrated

- Data Filtering & Sorting  
- Aggregations with `GROUP BY`, `HAVING`  
- Conditional logic using `CASE`  
- Joins
- CTEs and Subqueries  
- Window Functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`)

---

## 🔍 SQL Questions & Queries

### 1. 🎥 Top 5 Movies by IMDb Score

```sql
SELECT movie_title, imdb_score
FROM movie_metadata
ORDER BY imdb_score DESC
LIMIT 5;
```

### 2. 🎬 Top Grossing Movie Each Year

```sql
SELECT title_year, MAX(gross) AS max_gross
FROM movie_metadata
WHERE title_year IS NOT NULL
GROUP BY title_year
ORDER BY title_year;
```

### 3. 🎭 Count of Movies by Genre Combination

```sql
SELECT genres, COUNT(*) AS movie_count
FROM movie_metadata
WHERE genres IS NOT NULL
GROUP BY genres
ORDER BY movie_count DESC;
```

### 4. 🌍 Average Budget by Language

```sql
SELECT language, ROUND(AVG(budget), 0) AS avg_budget
FROM movie_metadata
WHERE budget IS NOT NULL
GROUP BY language
ORDER BY avg_budget DESC;
```

### 5. 🧾 Director Movie Count (More than 1)

```sql
SELECT director_name, COUNT(*) AS movie_count
FROM movie_metadata
GROUP BY director_name
HAVING COUNT(*) > 1
ORDER BY movie_count DESC;
```

### 6. 📈 Total Gross Revenue by Year

```sql
SELECT title_year, SUM(gross) AS total_gross
FROM movie_metadata
WHERE title_year IS NOT NULL
GROUP BY title_year
ORDER BY title_year;
```

### 7. 💥 Movies Where Gross > Budget

```sql
SELECT movie_title, gross, budget
FROM movie_metadata
WHERE gross > budget;
```

### 8. 🎯 Movie Performance Category

```sql
SELECT movie_title, gross, budget,
  CASE 
    WHEN gross >= budget THEN 'Hit'
    ELSE 'Flop'
  END AS performance
FROM movie_metadata
WHERE budget IS NOT NULL AND gross IS NOT NULL;
```

### 9. 🌟 IMDb Score Category

```sql
SELECT movie_title, imdb_score,
  CASE 
    WHEN imdb_score >= 8 THEN 'Excellent'
    WHEN imdb_score >= 6 THEN 'Good'
    WHEN imdb_score >= 4 THEN 'Average'
    ELSE 'Poor'
  END AS rating_category
FROM movie_metadata
WHERE imdb_score IS NOT NULL;
```

### 10. 🎞️ Top 5 Directors by Avg IMDb (min 3 movies)

```sql
SELECT director_name, AVG(imdb_score) AS avg_score
FROM movie_metadata
GROUP BY director_name
HAVING COUNT(*) >= 3
ORDER BY avg_score DESC
LIMIT 5;
```

### 11. 🎭 Most Common Language

```sql
SELECT language
FROM movie_metadata
GROUP BY language
ORDER BY COUNT(*) DESC
LIMIT 1;
```

### 12. 👤 INNER JOIN movie_cast and movie_metadata

```sql
SELECT mc.movie_title, mc.actor_name, mm.imdb_score
FROM movie_cast mc
INNER JOIN movie_metadata mm ON mc.movie_title = mm.movie_title;
```

### 13. 👥 LEFT JOIN to Show All Movies and Actors

```sql
SELECT mm.movie_title, mm.imdb_score, mc.actor_name
FROM movie_metadata mm
LEFT JOIN movie_cast mc ON mm.movie_title = mc.movie_title;
```

### 14. 📊 Actors with Avg IMDb > 7 (min 3 movies)

```sql
SELECT mc.actor_name, AVG(mm.imdb_score) AS avg_score, COUNT(*) AS movie_count
FROM movie_cast mc
JOIN movie_metadata mm ON mc.movie_title = mm.movie_title
WHERE mm.imdb_score > 7
GROUP BY mc.actor_name
HAVING COUNT(*) >= 3;
```

### 15. 🧾 CTE: Actors with ≥5 Movies

```sql
WITH actor_movies AS (
  SELECT actor_name, COUNT(*) AS movie_count
  FROM movie_cast
  GROUP BY actor_name
)
SELECT * FROM actor_movies
WHERE movie_count >= 5;
```

### 16. 🧠 CTE: Top 5 Actors by Avg IMDb Score (min 4 movies)

```sql
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
```

### 17. 🪜 ROW_NUMBER: Top Grossing Movie Per Language

```sql
WITH ranked AS (
  SELECT language, movie_title, gross,
    ROW_NUMBER() OVER(PARTITION BY language ORDER BY gross DESC) AS rn
  FROM movie_metadata
  WHERE gross IS NOT NULL
)
SELECT * FROM ranked WHERE rn = 1;
```

### 18. 🪜 ROW_NUMBER: Highest IMDb Movie Per Director

```sql
WITH ranked AS (
  SELECT director_name, movie_title, imdb_score,
    ROW_NUMBER() OVER(PARTITION BY director_name ORDER BY imdb_score DESC) AS rn
  FROM movie_metadata
  WHERE imdb_score IS NOT NULL
)
SELECT * FROM ranked WHERE rn = 1;
```

### 19. 🪜 RANK(): Top IMDb Movie per Content Rating

```sql
WITH ranked AS (
  SELECT content_rating, movie_title, imdb_score,
    RANK() OVER(PARTITION BY content_rating ORDER BY imdb_score DESC) AS rank
  FROM movie_metadata
)
SELECT * FROM ranked WHERE rank = 1;
```

### 20. 🪜 DENSE_RANK(): Top 3 Grossing Movies Per Language

```sql
WITH ranked AS (
  SELECT language, movie_title, gross,
    DENSE_RANK() OVER(PARTITION BY language ORDER BY gross DESC) AS rank
  FROM movie_metadata
)
SELECT * FROM ranked WHERE rank <= 3;
```

## ✅ Key Learnings

- **Mastered SQL for Data Exploration & Analysis**  
  Applied real-world SQL techniques such as `GROUP BY`, `HAVING`, `CASE`, and filtering to extract actionable insights from raw movie data.

- **Gained Hands-On Experience with Joins, CTEs, and Window Functions**  
  Used `JOIN`s to combine datasets, `CTEs` for cleaner query logic, and `ROW_NUMBER`, `RANK`, and `DENSE_RANK` for advanced analytics.

- **Built Practical, Query-Driven Insights from Real Movie Data**  
  Analyzed movie ratings, revenues, languages, and actor/director trends — turning raw data into business-relevant summaries.

## 👨‍💻 Author & Contact
- **Name:** D Akshaykumar  
- 📧 d.akshaykumar17@gmail.com  
- 🔗 [LinkedIn](https://linkedin.com)  
- 🔗 [GitHub](https://github.com/Akshay17DS)







