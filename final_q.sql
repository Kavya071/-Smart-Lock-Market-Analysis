Select * from dbo.flipkart_smart_locks_final$;



SELECT [Brand Name], COUNT(*) AS num_skus
FROM dbo.flipkart_smart_locks_final$
GROUP BY [Brand Name]
ORDER BY num_skus DESC;



SELECT SUBSTRING([Brand Name], 1, CHARINDEX(' ', [Brand Name] + ' ') - 1) AS brand, 
       COUNT(*) AS total_smart_locks
FROM dbo.flipkart_smart_locks_final$
GROUP BY SUBSTRING([Brand Name], 1, CHARINDEX(' ', [Brand Name] + ' ') - 1)
ORDER BY total_smart_locks DESC;


SELECT SUBSTRING([Brand Name], ' ', 1) AS brand, AVG(Ranking) AS avg_ranking, 
       RANK() OVER (ORDER BY AVG(Ranking)) AS relative_ranking
FROM dbo.flipkart_smart_locks_final$
WHERE SUBSTRING([Brand Name], ' ', 1) IN (
    SELECT SUBSTRING([Brand Name], ' ', 1)
    FROM dbo.flipkart_smart_locks_final$
    GROUP BY SUBSTRING([Brand Name], ' ', 1)
    HAVING COUNT(*) >= 2
)
GROUP BY SUBSTRING([Brand Name], ' ', 1)
ORDER BY avg_ranking;


SELECT LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1) AS brand,
       AVG(ranking) AS avg_ranking,
       RANK() OVER (ORDER BY AVG(ranking)) AS relative_ranking
FROM dbo.flipkart_smart_locks_final$
WHERE LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1) IN (
    SELECT LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1)
    FROM dbo.flipkart_smart_locks_final$
    GROUP BY LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1)
    HAVING COUNT(*) >= 2
)
GROUP BY LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1)
ORDER BY avg_ranking;



SELECT LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1) AS brand,
       AVG(rating) AS avg_rating,
       RANK() OVER (ORDER BY AVG(rating) DESC) AS relative_rating
FROM dbo.flipkart_smart_locks_final$
WHERE rating IS NOT NULL
  AND LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1) IN (
    SELECT LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1)
    FROM dbo.flipkart_smart_locks_final$
    WHERE rating IS NOT NULL
    GROUP BY LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1)
    HAVING COUNT(*) >= 2
)
GROUP BY LEFT([Brand Name], CHARINDEX(' ', [Brand Name] + ' ') - 1)
ORDER BY avg_rating DESC;


SELECT 
    CASE
        WHEN price < 5000 THEN 'Band 1: <Rs. 5000'
        WHEN price BETWEEN 5000 AND 9999 THEN 'Band 2: Rs. 5000-10000'
        WHEN price BETWEEN 10000 AND 19999 THEN 'Band 3: Rs. 10000-20000'
        ELSE 'Band 4: >Rs. 20000'
    END AS price_band,
    COUNT(*) AS sku_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.flipkart_smart_locks_final$), 2) AS percentage
FROM dbo.flipkart_smart_locks_final$
GROUP BY 
    CASE
        WHEN price < 5000 THEN 'Band 1: <Rs. 5000'
        WHEN price BETWEEN 5000 AND 9999 THEN 'Band 2: Rs. 5000-10000'
        WHEN price BETWEEN 10000 AND 19999 THEN 'Band 3: Rs. 10000-20000'
        ELSE 'Band 4: >Rs. 20000'
    END
ORDER BY sku_count DESC;


