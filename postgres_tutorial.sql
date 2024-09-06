-- *****  N T A I    P O S T G R E S Q L   C E R T I F I C A T I O N  *****
-- follow along -> postgresqltutorial.com modifying the queries to show comprehension

--********
--SELECT
--********
--1) query 1 column
select title from film;
--2) select multiple columns
select title, description from film;
--3) select data from all columns
select * from film;
--4) with concatenate expression and alias
select
	title || ' (' || release_year || ')' as title_and_release,
	description
from
	film;
--5) select statement without FROM clause
select current_date;
--********
--COLUMN ALIAS
--********
--1) assign column alias to column
select rental_date as date_of_rental from rental;
select rental_date date_of_rental from rental;
--2) assign column alias to an expression
select
	title || ' (' || release_year || ')' as title_and_release,
	description
from
	film;
--3) column aliases that contain spaces
select
	title || ' (' || release_year || ')' as "title and release",
	description
from
	film;
--********
--ORDER BY
--********
--1) Using PostgreSQL ORDER BY clause to sort rows by one column
select
	title ,release_year, description
from
	film
order by title	;
--2) Using PostgreSQL ORDER BY clause to sort rows by one column in descending order
select
	title ,release_year, description
from
	film
order by title	desc;
--3) Using PostgreSQL ORDER BY clause to sort rows by multiple columns
select
	title ,release_year, description, rental_duration, rental_rate, length
from
	film
order by length asc, rental_rate desc;
--4) Using PostgreSQL ORDER BY clause to sort rows by expressions
select
	title ,release_year, description, rental_duration, rental_rate, length,
	round(rental_rate/length,2) as cost_per_min
from
	film
order by cost_per_min desc;
--PostgreSQL ORDER BY clause and NULL
-- create a new table
CREATE TABLE sort_demo(num INT);

-- insert some data
INSERT INTO sort_demo(num) 
VALUES 
  (1), 
  (2), 
  (3), 
  (null);

SELECT 
  num 
FROM 
  sort_demo 
ORDER BY 
  num nulls first;

--********
--SELECT DISTINCT
--********  

SELECT DISTINCT inventory_id, count(rental_id) as num_rentals FROM rental group by inventory_id;
select count(distinct inventory_id) as num_inventory from rental;
select count(distinct film_id) as num_films from film;
select count(distinct inventory_id) as inventory_count from inventory;
--********
--WHERE			... & LIKE
--********  
SELECT 
  title, release_year, description
FROM 
  film
WHERE 
  title LIKE '%Heaven%';


--********
--AND OPERATOR
--********  
SELECT 
  title, release_year, description
FROM 
  film
WHERE 
  title LIKE '%Heaven%'
  and description LIKE '%Cat%';


--********
--OR OPERATOR
--********  
SELECT 
  *
FROM 
  actor
WHERE 
  first_name = 'Grace'
  or first_name = 'Joe';

--********
--LIMIT
--********  

select * from rental order by rental_date limit 10;

select * from rental order by rental_date limit 10 offset 8;

select * from rental order by customer_id, rental_date limit 10;

--********
--FETCH
--********  

select * from category order by category_id offset 10 rows fetch next 5 rows only;


--********
--IN
--********  
SELECT 
  *
FROM 
  actor
WHERE 
  first_name in('Grace', 'Joe', 'John', 'Susan','Al');


--********
--BETWEEN
--********  
SELECT * FROM customer where customer_id between 5 and 15;

--********
--LIKE
--********  

-- see WHERE and AND

--********
--IS NULL
--********  

SELECT 
  *
FROM 
  sort_demo
WHERE
  num is null;

--********
--JOINS
--********  


--********
--TABLE ALIASES
--********  
select c.first_name, c.last_name from customer c order by c.last_name desc limit 15;

--********
--INNER JOIN
--********  
select c.customer_id,c.first_name, c.last_name, f.title, f.description
from customer c 
inner join rental r on c.customer_id = r.customer_id 
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
order by c.last_name limit 25;

--********
--LEFT JOIN
--********  

select f.film_id ,f.title, f.release_year, a.actor_id  
from film f 
left join film_actor a using (film_id) 
where a.actor_id is null;

--********
--RIGHT JOIN
--********  

select f.film_id ,f.title, f.release_year, a.actor_id  
from film_actor a 
right join film f using (film_id) 
where a.actor_id is null;

SELECT f.film_id, f.title, f.release_year, a.actor_id  
FROM film_actor a 
RIGHT JOIN film f USING (film_id)
ORDER BY a.actor_id NULLS FIRST;

--********
--SELF-JOIN
--********  
SELECT 
  e.first_name || ' ' || e.last_name employee, m.first_name || ' ' || m.last_name manager 
FROM 
  employee e 
  INNER JOIN employee m ON m.employee_id = e.manager_id 
ORDER BY 
  manager;

SELECT 
  f1.title, f2.title, f1.replacement_cost 
FROM film f1 
INNER JOIN film f2 ON f1.film_id > f2.film_id 
  AND f1.replacement_cost = f2.replacement_cost
order by f1.replacement_cost desc;

--********
--FULL OUTER JOIN
--********  
with 
list_months as (
    select 
        generate_series('2005-01-01 00:00:00'::timestamp, 
            '2005-12-01 00:00:00'::timestamp, 
            '1 month'
        ) as month_series
),
months as (
  select 
		date_part('month',month_series) as month_num,
		trim(to_char(month_series,'Month')) as the_month
  from list_months
	group by to_char(month_series,'Month'),date_part('month',month_series) 
	order by date_part('month',month_series)
)
select  m.month_num,
  m.the_month as rental_month,
	count(distinct r.rental_id) num_rentals
from months m 
full outer join rental r 
on m.the_month = trim(to_char(r.rental_date, 'Month'))  
group by m.the_month,m.month_num 
order by m.month_num;

select count(distinct rental_id) as num_rentals, trim(to_char(rental_date, 'Month'))  as rental_month 
from rental 
group by trim(to_char(rental_date, 'Month'));

--********
--CROSS JOIN
--********  
--list of all films in each store
select * from film cross join store;

--********
--NATURAL JOIN             
--********  

select f.film_id ,f.title, f.release_year, c.category_id  
from film f 
natural left join film_category c 
order by f.film_id; --does not work due to the last_update column 

select f.film_id ,f.title, f.release_year, c.category_id  
from film f 
left join film_category c using (film_id) 
order by f.film_id; 


--********
--GROUP BY
--********  
select customer_id, count(rental_id) as num_rentals
from rental
group by customer_id
order by customer_id;

--********
--HAVING
--********  
select customer_id, count(rental_id) as num_rentals
from rental
group by customer_id
having count(rental_id)>40
order by customer_id;

--********
--GROUPING SETS
--********  
select customer_id, inventory_id, count(rental_id) as num_rentals
from rental
group by 
	grouping sets ((customer_id),(inventory_id),())
order by customer_id nulls first,inventory_id nulls first;


--********
--CUBE
--********  
select customer_id, inventory_id, count(rental_id) as num_rentals
from rental
group by 
	CUBE (customer_id,inventory_id)
order by customer_id nulls first,inventory_id nulls first;

--********
--ROLLUP
--********  
select date_part('year',rental_date) as rental_year, date_part('month',rental_date) as rental_month, 
date_part('day',rental_date) as rental_day, count(rental_id) as num_rentals from rental
group by 
	rollup (date_part('year',rental_date),date_part('month',rental_date),date_part('day',rental_date)) 
order by date_part('year',rental_date) nulls first,date_part('month',rental_date) nulls first,date_part('day',rental_date);
--the above SQL written before the sample!  writing another..
select extract(year from create_date) y, extract(month from create_date) m, extract(day from create_date) d,
count(customer_id) 
from customer
group by
	rollup(extract(year from create_date), extract(month from create_date), extract(day from create_date))
order by extract(year from create_date) nulls first, extract(month from create_date) nulls first, extract(day from create_date);
--lol I guess all customers were created on the same day
--love this function!

--********
--UNION
--********  
SELECT * FROM (
    SELECT  i.film_id, COUNT(i.film_id) AS rental_count, 'Top 3' AS rank
    FROM  rental r 
    LEFT JOIN  inventory i USING (inventory_id) 
    GROUP BY  i.film_id 
    ORDER BY  COUNT(i.film_id) DESC LIMIT 3) 
	AS top_films

UNION ALL

SELECT * FROM (
    SELECT i.film_id, COUNT(r.rental_id) AS rental_count, 'Bottom 3' AS rank
    FROM inventory i 
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY i.film_id 
    ORDER BY rental_count ASC NULLS FIRST LIMIT 3) 
	AS bottom_films;


--********
--INTERSECT
--********  


--********
--EXCEPT
--********  


--********
--COMMON TABLE EXPRESSION (CTE)
--********  



--********
--RECURSIVE CTE
--********  


--********
--INSERT
--********  


--********
--INSERT MULTIPLE ROWS
--********  


--********
--UPDATE
--********  


--********
--UPDATE JOIN
--********  


--********
--DELETE
--********  



--********
--DELETE JOIN
--********  


--********
--UPSERT
--********  


--********
--MERGE
--********  


--********
--TRANSACTION
--********  


--********
--IMPORT CSV FILE INTO TABLE
--********  


--********
--EXPORT TABLE TO CSV FILE
--********  


--********
--Subquery
--********  


--********
--Correlated Subquery
--********


--********
--ANY Operator
--********  



--********
--ALL Operator
--******** 



--********
--EXISTS Operator
--******** 

