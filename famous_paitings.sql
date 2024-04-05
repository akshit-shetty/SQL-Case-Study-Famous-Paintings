-- SQL Case Study - Paintings

use paintings;

SELECT * FROM artist;
SELECT * FROM canvas_size;
SELECT * FROM image_link;
SELECT * FROM museum;
SELECT * FROM museum_hours;
SELECT * FROM product_size;
SELECT * FROM subject;
SELECT * FROM work;

-- Problem Statements


SELECT 
    *
FROM
    work
WHERE
    museum_id IS NULL;

-- 2. Are there museums without any paintings?

DELETE FROM museum_hours 
WHERE
    museum_id NOT IN (SELECT 
        museum_id
    FROM
        (SELECT 
            MIN(museum_id) AS id
        FROM
            museum_hours
        GROUP BY museum_id , day) AS min_ids);

-- 3. How many paintings have an asking price of more than their regular price?

SELECT 
    *
FROM
    product_size
WHERE
    sale_price > regular_price;

-- 4. Identify the paintings whose asking price is less than 50% of its regular price

SELECT 
    *
FROM
    product_size
WHERE
    sale_price < (regular_price * 50 / 100);

-- 5. Which canva size costs the most?

SELECT 
    cs.label AS canva, 
    ps.sale_price
FROM 
    (SELECT 
         *,
         RANK() OVER (ORDER BY sale_price DESC) AS rnk
     FROM 
         product_size) ps
JOIN 
    canvas_size cs 
ON 
    cs.size_id= ps.size_id
WHERE 
    ps.rnk = 1;
			 

-- 6. Delete duplicate records from work, product_size, subject and image_link tables


SELECT 
    *
FROM
    museum
WHERE
    city REGEXP '^[0-9]';


-- 8. Museum_Hours table has 1 invalid entry. Identify it and remove it.

SELECT 
    *
FROM
    museum_hours
WHERE
    day NOT IN ('Sunday' , 'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday');

DELETE FROM museum_hours 
WHERE
    day NOT IN ('Sunday' , 'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday');


-- 9. Fetch the top 10 most famous painting subject

SELECT subject, COUNT(work_id) AS no_of_paintings ,rank() over(order by count(1) desc) as ranking
FROM subject 
GROUP BY subject
ORDER BY no_of_paintings DESC
LIMIT 10;

-- 10. Identify the museums which are open on both Sunday and Monday. Display museum name, city.

SELECT 
    m.name, m.city
FROM
    museum m
        JOIN
    (SELECT 
        mh.museum_id
    FROM
        museum_hours mh
    WHERE
        mh.day IN ('Sunday' , 'Monday')
    GROUP BY mh.museum_id
    HAVING COUNT(DISTINCT mh.day) = 2) AS open_both_days ON m.museum_id = open_both_days.museum_id;


-- 11. How many museums are open every single day?

SELECT 
    COUNT(museum_id)
FROM
    (SELECT 
        museum_id, COUNT(museum_id)
    FROM
        museum_hours
    GROUP BY museum_id
    HAVING COUNT(museum_id) = 7) x;
          
          
-- 12. Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

SELECT m.name, top_museums.no_of_paintings
FROM (
      SELECT w.museum_id, COUNT(w.work_id) AS no_of_paintings, ROW_NUMBER() OVER (ORDER BY COUNT(w.work_id) DESC) AS rnk
      FROM work w
      GROUP BY w.museum_id
      ORDER BY no_of_paintings DESC
      LIMIT 6
) AS top_museums
JOIN museum m ON top_museums.museum_id = m.museum_id;

-- 13. Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)

SELECT a.full_name as Artists, a.nationality, top_artists.no_of_paintings
FROM (
      SELECT w.artist_id, COUNT(w.work_id) AS no_of_paintings, ROW_NUMBER() OVER (ORDER BY COUNT(w.work_id) DESC) AS rnk
      FROM work w
      GROUP BY w.artist_id
      ORDER BY no_of_paintings DESC
      LIMIT 5
) AS top_artists
JOIN artist a ON top_artists.artist_id = a.artist_id;


-- 14. Display the 3 least popular canva sizes

select label,ranking,no_of_paintings
	from (
		select cs.size_id,cs.label,count(1) as no_of_paintings
		, dense_rank() over(order by count(1) ) as ranking
		from product_size ps
		join canvas_size cs on cs.size_id = ps.size_id
		group by cs.size_id,cs.label) as least_popular_canva
	where least_popular_canva.ranking<=3;

-- 15. Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?

SELECT longest.museum_name, longest.state, longest.day, longest.open, longest.close, longest.duration
FROM (
    SELECT m.name AS museum_name, m.state, day, open, close,
           TIMEDIFF(STR_TO_DATE(close, '%h:%i:%p'), STR_TO_DATE(open, '%h:%i:%p')) AS duration,
           RANK() OVER (ORDER BY TIMEDIFF(STR_TO_DATE(close, '%h:%i:%p'), STR_TO_DATE(open, '%h:%i:%p')) DESC) AS rnk
    FROM museum_hours mh
    JOIN museum m ON m.museum_id = mh.museum_id
) AS longest
WHERE longest.rnk = 1;

-- 16. Which museum has the most no of most popular painting style?

WITH popular_styles AS (
    SELECT style, COUNT(*) AS num_paintings
    FROM work
    GROUP BY style
    ORDER BY num_paintings DESC
    LIMIT 1
),
museum_ranks AS (
    SELECT 
        m.name AS museum_name, 
        ps.style, 
        COUNT(*) AS num_paintings_in_style,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS museum_rank
    FROM museum m
    JOIN work w ON m.museum_id = w.museum_id
    JOIN popular_styles ps ON w.style = ps.style
    GROUP BY m.name, ps.style
)
SELECT museum_name, style, num_paintings_in_style
FROM museum_ranks
WHERE museum_rank = 1;

         
-- 17. Identify the artists whose paintings are displayed in multiple countries

WITH paint_countries AS (
    SELECT DISTINCT
        a.full_name AS Artists,
        m.country
    FROM work w
    JOIN artist a ON w.artist_id = a.artist_id
    JOIN museum m ON w.museum_id = m.museum_id
)
SELECT
    Artists,
    COUNT(1) AS no_of_countries
FROM
    paint_countries
GROUP BY
    Artists
HAVING COUNT(1) > 1
ORDER BY no_of_countries DESC;   

-- 18. Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.

SELECT 
    country, 
    GROUP_CONCAT(city) AS city, 
    SUM(no_of_museums) AS total_museums
FROM (
    SELECT 
        country, 
        city, 
        COUNT(1) AS no_of_museums
    FROM 
        museum
    GROUP BY 
        country, 
        city
) AS museums_by_city
GROUP BY 
    country
ORDER BY 
    total_museums DESC
LIMIT 1;

	

-- 19. Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city and canvas label


WITH most_least_exp AS (
    SELECT 
        a.full_name AS Artist, 
        ps.sale_price AS sale_price, 
        w.name AS Painting, 
        m.name AS Museum, 
        m.city AS City, 
        cs.label AS Canvas_label,
        RANK() OVER (ORDER BY ps.sale_price DESC) AS max_rn,
        RANK() OVER (ORDER BY ps.sale_price ASC) AS min_rn
    FROM 
        work w
    JOIN 
        product_size ps ON ps.work_id = w.work_id
    JOIN 
        canvas_size cs ON cs.size_id = ps.size_id
    JOIN 
        artist a ON a.artist_id = w.artist_id
    JOIN 
        museum m ON m.museum_id = w.museum_id
)
SELECT 
    Artist, 
    sale_price, 
    Painting, 
    Museum, 
    City, 
    Canvas_label
FROM 
    most_least_exp
WHERE 
    max_rn = 1 OR min_rn = 1;


-- 20. Which country has the 5th highest no of paintings?


SELECT country, Paintings.no_of_paintings
FROM (
    SELECT m.country, COUNT(1) AS no_of_paintings, RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
    FROM work w
    JOIN museum m ON w.museum_id = m.museum_id
    GROUP BY m.country
) as Paintings
WHERE Paintings.rnk = 5;


-- 21. Which are the 3 most popular and 3 least popular painting styles?


SELECT style, style_count.no_of_paintings , case when rnk <=3 then 'Most Popular' else 'Least Popular' end as remarks
FROM(
SELECT style, 
	   COUNT(1) as no_of_paintings, 
       RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk,
       count(1) over() as no_of_records
FROM work
where style is not null
GROUP BY style
) as style_count
WHERE rnk <=3 or rnk > no_of_records - 3;

-- 22. Which artist has the most no of Portraits paintings outside USA?. Display artist , no of paintings and the artist nationality.
SELECT * FROM artist;
SELECT * FROM canvas_size;
SELECT * FROM image_link;
SELECT * FROM museum;
SELECT * FROM museum_hours;
SELECT * FROM product_size;
SELECT * FROM subject;
SELECT * FROM work;


SELECT sub.Artist, sub.nationality, sub.no_of_paintings
FROM (
    SELECT a.full_name as Artist, a.nationality, COUNT(w.work_id) as no_of_paintings, 
           RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
    FROM work w
    JOIN artist a ON a.artist_id = w.artist_id
    JOIN subject s ON s.work_id = w.work_id
    WHERE s.subject = 'Portraits' AND a.nationality != 'American'
    GROUP BY Artist, a.nationality
) as sub
WHERE sub.rnk = 1;
