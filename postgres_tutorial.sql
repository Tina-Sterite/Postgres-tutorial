-- *****  N T A I    P O S T G R E S Q L   C E R T I F I C A T I O N  *****
-- follow along -> postgresqltutorial.com modifying the queries to show comprehension

--********
--SELECT 1
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
--COLUMN ALIAS 2
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
--ORDER BY 3
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
--SELECT DISTINCT 4
--********  

SELECT DISTINCT inventory_id, count(rental_id) as num_rentals FROM rental group by inventory_id;
select count(distinct inventory_id) as num_inventory from rental;
select count(distinct film_id) as num_films from film;
select count(distinct inventory_id) as inventory_count from inventory;
--********
--WHERE	5		... & LIKE
--********  
SELECT 
  title, release_year, description
FROM 
  film
WHERE 
  title LIKE '%Heaven%';


--********
--AND OPERATOR 6
--********  
SELECT 
  title, release_year, description
FROM 
  film
WHERE 
  title LIKE '%Heaven%'
  and description LIKE '%Cat%';


--********
--OR OPERATOR 7
--********  
SELECT 
  *
FROM 
  actor
WHERE 
  first_name = 'Grace'
  or first_name = 'Joe';

--********
--LIMIT 8
--********  

select * from rental order by rental_date limit 10;

select * from rental order by rental_date limit 10 offset 8;

select * from rental order by customer_id, rental_date limit 10;

--********
--FETCH 9
--********  

select * from category order by category_id offset 10 rows fetch next 5 rows only;


--********
--IN 10
--********  
SELECT 
  *
FROM 
  actor
WHERE 
  first_name in('Grace', 'Joe', 'John', 'Susan','Al');


--********
--BETWEEN 11
--********  
SELECT * FROM customer where customer_id between 5 and 15;

--********
--LIKE 12
--********  

-- see WHERE and AND

--********
--IS NULL 13
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
--TABLE ALIASES 14
--********  
select c.first_name, c.last_name from customer c order by c.last_name desc limit 15;

--********
--INNER JOIN 15
--********  
select c.customer_id,c.first_name, c.last_name, f.title, f.description
from customer c 
inner join rental r on c.customer_id = r.customer_id 
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
order by c.last_name limit 25;

--********
--LEFT JOIN 16
--********  

select f.film_id ,f.title, f.release_year, a.actor_id  
from film f 
left join film_actor a using (film_id) 
where a.actor_id is null;

--********
--RIGHT JOIN 17
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
--SELF-JOIN 18
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
--FULL OUTER JOIN 19
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
--CROSS JOIN 20
--********  
--list of all films in each store
select * from store cross join film;

--********
--NATURAL JOIN  21        
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
--GROUP BY 22
--********  
select customer_id, count(rental_id) as num_rentals
from rental
group by customer_id
order by customer_id;

--********
--HAVING 23
--********  
select customer_id, count(rental_id) as num_rentals
from rental
group by customer_id
having count(rental_id)>40
order by customer_id;

--********
--GROUPING SETS 24
--********  
select customer_id, inventory_id, count(rental_id) as num_rentals
from rental
group by 
	grouping sets ((customer_id),(inventory_id),())
order by customer_id nulls first,inventory_id nulls first;


--********
--CUBE 25
--********  
select customer_id, inventory_id, count(rental_id) as num_rentals
from rental
group by 
	CUBE (customer_id,inventory_id)
order by customer_id nulls first,inventory_id nulls first;

--********
--ROLLUP 26
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
--UNION 27
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
--INTERSECT 28
--********  

SELECT d.director_id,d.name FROM most_popular_directors pd left join directors d using (director_id)
INTERSECT
SELECT d.director_id,d.name FROM top_grossing_directors gd left join directors d using (director_id);

--********
--EXCEPT 29
--********  

SELECT d.director_id,d.name FROM most_popular_directors pd left join directors d using (director_id)
EXCEPT
SELECT d.director_id,d.name FROM top_grossing_directors gd left join directors d using (director_id);

--********  C O M M O N   T A B L E   E X P R E S S I O N  ********
--********
--COMMON TABLE EXPRESSION (CTE) 30
--********  

with horror_films as(
select c.name as film_type,f.title, f.description
from film f inner join film_category fc on f.film_id=fc.film_id
inner join category c on fc.category_id = c.category_id
where c.name = 'Horror'
)
select * from horror_films;


--********
--RECURSIVE CTE 31
--********  

WITH RECURSIVE thestaff AS (
  SELECT 
    staff_id, 
	st.manager_staff_id as store_manager_id,
    first_name,
	last_name
  FROM 
    staff s
  LEFT JOIN store st on s.store_id=st.store_id
  WHERE 
    s.store_id = 1 
  UNION 
  SELECT 
    s.staff_id,
	m.manager_staff_id as store_manager_id, 
    s.first_name,
	s.last_name 
  FROM 
    store m 
    INNER JOIN thestaff s ON s.staff_id = m.manager_staff_id
) 
SELECT * FROM thestaff;

--********  M O D I F Y I N G   D A T A  ********
--********
--INSERT 32
--********  

INSERT INTO staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update,picture)
VALUES (3,'Sally','Smith',9,'s.smith@sakilastaff.com',1,True,'ssmith','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL)
RETURNING *;

--********
--INSERT MULTIPLE ROWS 33
--********  

INSERT INTO staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update,picture)
VALUES
    (4, 'Sam','Newton',24,'snewton@sakilastaff.com',2,True,'snewton','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
    (5, 'Mike','ONeil',60, 'moneil@sakilastaff.com',1,True,'moneil','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
    (6,'Kristen','Edgehill',91,'kedgehill@sakilastaff.com',1,True,'kedgehill','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(7,'Tianny','Cinnamon',96,'tcinnamon@sakilastaff.com',1,True,'tcinnamon','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(8,'Richard','Turrell',42,'rturrell@sakilastaff.com',2,True,'rturrell','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(9,'John','Sweeney',38,'jsweeney@sakilastaff.com',2,False,'jsweeney','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(10,'Judy','Earley',82,'jearley@sakilastaff.com',1,False,'jearley','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(11,'Kenneth','Hollis',73,'khollis@sakilastaff.com',2,True,'khollis','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(12,'Faheem','Mooney',64,'fmooney@sakilastaff.com',1,True,'fmooney','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(13,'Rocco','Surdam',55,'rsurdam@sakilastaff.com',2,True,'rsurdam','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(14,'Lucille','Walker',48,'lwalker@sakilastaff.com',1,True,'lwalker','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(15,'Barbara','Lopes',39,'blopes@sakilastaff.com',1,True,'blopes','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
	(16,'Ivy','Mccarron',29,'imccarron@sakilastaff.com',2,True,'imccarron','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL),
    (17,'Jade','Dalton',88,'jdalton@sakilastaff.com',2,False,'jdalton','8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL);

--********
--UPDATE 34
--********  
--adding Director column to film table
ALTER TABLE film
ADD COLUMN director_id smallint;

select * from film;--1000 rows

update film
set director_id = 1
where film_id<=43;

update film
set director_id = 2
where film_id between 44 and 86;

update film
set director_id = 3
where film_id between 87 and 129;

update film
set director_id = 4
where film_id between 130 and 172;

update film
set director_id = 5
where film_id between 173 and 215;

update film
set director_id = 6
where film_id between 215 and 43*6;

update film
set director_id = 7
where film_id between 43*6+1 and 43*7;

update film
set director_id = 8
where film_id between 43*7+1 and 43*8;

update film
set director_id = 9
where film_id between 43*8+1 and 43*9;

update film
set director_id = 10
where film_id between 43*9+1 and 43*10;

update film
set director_id = 11
where film_id between 43*10+1 and 43*11;

update film
set director_id = 12
where film_id between 43*11+1 and 43*12;

update film
set director_id = 13
where film_id between 43*12+1 and 43*13;

update film
set director_id = 14
where film_id between 43*13+1 and 43*14;

update film
set director_id = 15
where film_id between 43*14+1 and 43*15;

update film
set director_id = 16
where film_id between 43*15+1 and 43*16;

update film
set director_id = 17
where film_id between 43*16+1 and 43*17;

update film
set director_id = 18
where film_id between 43*17+1 and 43*18;

update film
set director_id = 19
where film_id between 43*18+1 and 43*19;

update film
set director_id = 20
where film_id between 43*19+1 and 43*20;

update film
set director_id = 21
where film_id between 43*20+1 and 43*21;

update film
set director_id = 22
where film_id between 43*21+1 and 43*22;

update film
set director_id = 23
where film_id between 43*22+1 and 1000;


--********
--UPDATE JOIN 35
--********  

select * from category;
select * from film_category where category_id = 10;
--replacement cost goes up on films where the directors are top grossing directors.
update film f
set replacement_cost = replacement_cost * 1.20
from top_grossing_directors t
where f.director_id = t.director_id;

--********
--DELETE 36
--********  
--deleting all rows from tables as part of the exercise, then dropping tables and will recreate
--the tables using director_id column instead of director column.  directors table has been created
--to be joined to get the director names.
delete from most_popular_directors;
select * from most_popular_directors;
delete from top_grossing_directors;
delete from top_rated_directors;
drop table if exists most_popular_directors;
drop table if exists top_grossing_directors;
drop table if exists top_rated_directors;

--********
--DELETE JOIN 37
--********  
-- NOT GOING TO RUN THIS SQL.. it's just for presentation purposes

DELETE FROM film
USING language
WHERE film.language_id = language.language_id
and language.name = 'Mandarin'


--********
--UPSERT 38 (before PostgreSQL 15)
--********  

n/a

--********
--MERGE 39 (use instead of UPSERT for PostgreSQL 15 or later)
--********  

MERGE INTO top_directors_programs tdp
using 
(select d.director_id, n.id as netflix_id from directors d right join netflix n on d.name=n.director where d.director_id in(
select distinct(director_id) from (
select director_id from top_grossing_directors
union all
select director_id from top_rated_directors
union all 
SELECT director_id FROM most_popular_directors))) n
on tdp.director_id = n.director_id and tdp.netflix_id = n.netflix_id
when not matched then
INSERT (director_id,netflix_id) 
VALUES (n.director_id,n.netflix_id);

select * from top_directors_programs;

--********
--TRANSACTION 40
--********  
BEGIN;

UPDATE directors
set name = 'David Smith'
where director_id = 6;

ROLLBACK;

select * from directors where director_id = 6;
--COMMIT


--********  I M P O R T / E X P O R T  ********
--********
--IMPORT CSV FILE INTO TABLE 41
--********  
CREATE TABLE netflix (
id VARCHAR(10),
type VARCHAR(30),
title VARCHAR(300),
director VARCHAR(500),
performers VARCHAR(1000),
country VARCHAR(500),
date_added VARCHAR(30),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(10),
listed_in VARCHAR(500),
description VARCHAR(1000)
);
drop table if exists netflix; --used to adjust column widths as longer values were discovered
--COLUMNS NOT NEEDED (id,type,title,director,performers,country,date_added,release_year,rating,duration,listed_in,description)
COPY netflix
FROM 'C:\Users\steri\Desktop\PostgreSQL\netflix_titles.csv' DELIMITER ',' CSV HEADER;

Select * from netflix;
--********
--EXPORT TABLE TO CSV FILE 42
--********  
COPY most_popular_directors 
TO 'C:\Users\steri\Desktop\PostgreSQL\popular_directors_db.csv' 
DELIMITER ',' 
CSV HEADER;

--********  S U B Q U E R Y  ********
--********
--Subquery 43
--********  

SELECT * from netflix where director in(
  select d.name from directors d right join most_popular_directors mpd on d.director_id = mpd.director_id)
order by director;
--********
--Correlated Subquery 44
--********

select * from netflix n
where n.type = 'Movie' and n.num_duration >= (
  select avg(num_duration) from netflix where type = 'Movie'
)
order by n.duration desc;

--********
--ANY Operator 45
--********  

select * from netflix where director = any(
  select name from directors where director_id in(
    select director_id from top_grossing_directors
  )
);

--********
--ALL Operator 46
--******** 

select * from netflix where director != all(
  select name from directors where director_id in(
    select director_id from top_grossing_directors
  )
);

--********
--EXISTS Operator 47
--********  

SELECT * FROM top_directors_programs td WHERE 
  EXISTS(SELECT 1 FROM netflix n WHERE 
      td.netflix_id = n.id AND
      n.type = 'TV Show');

--********  M A N A G I N G  T A B L E S  ********
--********
--PostgreSQL Data Types Intro.. no work to be done here
--********  
/*
Boolen, Char, Varchar, Text, Numeric, Integer, Serial, Float, real, float8
Date, Time, Timestamp, Interval, UUID, JSON, HSTORE, Array,
 User-defined Data Types, Enum, XML, BYTEA, Composite Types
*/
--********
--Create Table 48
--********  

create table top_directors_programs(
  id serial primary key,
  director_id smallint not null,
  netflix_id varchar(10) not null
);

--********
--Select Into 49
--********  

SELECT
    id, type, title, duration, listed_in
INTO TEMP TABLE rated_r
FROM
    netflix
WHERE
    rating = 'R';

select * from rated_r;    

--********
--Create Table As 50
--********  

create temp table rated_pg as
select id, type, title, duration, listed_in from netflix where rating = 'PG';

select * from rated_pg;

--********
--SERIAL 51
--********  

-- see Create Table above, line 730

--********
--Sequences 52
--********  

create table if not exists netflix_streams(
  stream_id bigint not null,
  customer_id int not null,
  netflix_id varchar(10) not null
);

create sequence if not exists netflix_stream_id as bigint 
increment 10 start 10
owned by netflix_streams.stream_id;

insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),12,'S123');
insert into netflix_streams(stream_id,customer_id,netflix_id) values  (nextval('netflix_stream_id'),34,'S99');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),134,'S199');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),63,'S265');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),412,'S50');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),321,'S698');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),524,'S123');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),487,'S956');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),222,'S47');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),394,'S741');
insert into netflix_streams(stream_id,customer_id,netflix_id) values (nextval('netflix_stream_id'),349,'S852');

--********
--Identity Column 53
--********  

-- see Drop Table (61) below, line 864

--********
--Generated Columns 54
--********  

ALTER TABLE netflix
ADD COLUMN num_duration INT GENERATED ALWAYS AS (CAST(SPLIT_PART(duration,' ',1) AS INT)) STORED;

--********
--Alter Table 55
--********  

--(see Generated Columns, above, line 780)

--********
--Rename Table 56
--********  

alter table if exists language rename to film_language;

--********
--Add Column 57
--********  

alter table netflix_streams
add column stream_datetime timestamptz;
--set timezone = 'America/Los_Angeles';
show timezone;

update netflix_streams set stream_datetime = '2024-06-12 12:45:58' where stream_id = 10;
update netflix_streams set stream_datetime = '2023-03-18 14:22:22' where stream_id = 20;
update netflix_streams set stream_datetime = '2023-05-17 9:14:47' where stream_id = 30;
update netflix_streams set stream_datetime = '2023-10-16 5:04:18' where stream_id = 40;
update netflix_streams set stream_datetime = '2024-12-23 7:45:39' where stream_id = 50;
update netflix_streams set stream_datetime = '2024-02-02 15:39:29' where stream_id = 60;
update netflix_streams set stream_datetime = '2023-11-02 22:28:03' where stream_id = 70;
update netflix_streams set stream_datetime = '2024-09-12 21:02:14' where stream_id = 80;
update netflix_streams set stream_datetime = '2023-03-27 8:16:07' where stream_id = 90;
update netflix_streams set stream_datetime = '2024-09-07 12:22:42' where stream_id = 100;
update netflix_streams set stream_datetime = '2024-07-02 1:49:34' where stream_id = 110;

--********
--Drop Column 58
--********  

--ADD A COLUMN to perform the next several steps
-- STEP 1
alter table netflix_streams
add column times_streamed int;

--LAST STEP - STEP 4
alter table netflix_streams drop column stream_count;

--********
--Change Column's Data Type 59
--********  

-- STEP 3
alter table netflix_streams
alter column stream_count 
type bigint;

--********
--Rename Column 60
--********  

-- STEP 2
alter table netflix_streams
rename column times_streamed to stream_count;

--********
-- Drop Table 61
--********  

CREATE TABLE imdb (
rank INT,
title VARCHAR(200),
genre VARCHAR(30),
description VARCHAR(1000),
director VARCHAR(100),
actors VARCHAR(1000),
year INT,
duration INT,
rating FLOAT,
votes INT,
revenue_millions FLOAT,
metascore INT
);

COPY imdb
FROM 'C:\Users\steri\Desktop\PostgreSQL\IMDB-Movie-Data.csv' DELIMITER ',' CSV HEADER;
select * from imdb;
ALTER TABLE imdb ADD COLUMN movie_id INT GENERATED BY DEFAULT AS IDENTITY (start with 10 increment by 10);

select * from imdb;

DROP TABLE if exists imdb;

--********
--Temporary Table 62
--********  

CREATE TEMP TABLE rated_nc17 as
select id, type, title, duration, listed_in from netflix where rating = 'NC-17';

select * from rated_nc17;

--********
--Truncate Table 63
--********  
--recreate imbd table in section 61 above, then truncate it here
TRUNCATE TABLE imdb;


--********  D A T A B A S E    C O N S T R A I N T S  ********
--********
--Primary Key 64
--********  

-- see Create Table (48) above, line 728

--********
--Foreign Key 65
--********  

ALTER TABLE directors
ADD CONSTRAINT directors_id_pk PRIMARY KEY (director_id);

ALTER TABLE top_directors_programs
ADD CONSTRAINT tdp_director_id_fk FOREIGN KEY (director_id) REFERENCES directors(director_id);
ALTER TABLE most_popular_directors
ADD CONSTRAINT mpd_director_id_fk FOREIGN KEY (director_id) REFERENCES directors(director_id);
ALTER TABLE top_grossing_directors
ADD CONSTRAINT tgd_director_id_fk FOREIGN KEY (director_id) REFERENCES directors(director_id);
ALTER TABLE top_rated_directors
ADD CONSTRAINT trd_director_id_fk FOREIGN KEY (director_id) REFERENCES directors(director_id);

--********
--CHECK Constraint 66
--********  

ALTER TABLE netflix
ADD CONSTRAINT netflix_duration_check CHECK (num_duration > 0);

--********
--UNIQUE Contstraint 67
--********  

ALTER TABLE customer
ADD CONSTRAINT customer_email_unique UNIQUE (email);

SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'customer'

--********
--NOT NULL Constraint 68
--********  

-- 5 examples in this file, search "not null" to find them

--********
--DEFAULT Contstraint 69
--********  
ALTER TABLE staff
ALTER COLUMN username
set DEFAULT ('trainee');

select * from staff;

insert into staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update,picture)
values (18,'Carol','Dagostino',94,'cdagostino@gmail.com',1,True,DEFAULT,'8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL);


--********  P O S T G R E S Q L    D A T A   T Y P E S   ********
--********
--Boolean 70
--********  

insert into staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update,picture)
values (19,'Charles','Rodgers',30,'crodgers@gmail.com',1,'1',DEFAULT,'8cb2237d0679ca88db6464eac60da96345513964',NOW(),NULL);

select active from staff where staff_id = 19; --set active to true using '1'

--Interesting, valid lieral values:
--True	  False
--true	  false
--‘t’	    ‘f ‘
--‘true’	‘false’
--‘y’	    ‘n’
--‘yes’	  ‘no’
--‘1’	    ‘0’

--********
--COMBINING ALL REMAINING DATA TYPES INTO ONE SECTION/ONE TABLE
--CHAR, VARCHAR, and TEXT; NUMERIC, INTEGER, and SERIAL; FLOAT, REAL, and DOUBLE PRECISION; DATE, TIME, and TIMESTAMP; INTERVAL; UUID; JSON; HSTORE; ARRAY; User-defined Data Types; Enum; XML; BYTEA; Composite Types
--********  

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE DOMAIN user_defined_type AS 
   VARCHAR NOT NULL CHECK (value !~ '\s');

drop domain if exists user_defined_column;

CREATE TYPE enum_type AS ENUM ('Male', 'Female', 'Trans','Neutral','Other');

Drop type if exists enum_type;

CREATE TYPE composite_type AS (
  pet_name VARCHAR(50),
  pet_species VARCHAR(50),
  pet_color VARCHAR(50),
  pet_age INT);

CREATE TABLE data_types(
  char_column CHAR(10),
  varchar_column VARCHAR(20),
  text_column TEXT,
  numeric_column NUMERIC(10,2),
  integer_column INT,
  serial_column SERIAL,
  float_column FLOAT,
  real_column REAL,
  double_column DOUBLE PRECISION,
  date_column DATE,
  time_column TIME,
  timestamp_column TIMESTAMP,
  interval_column INTERVAL,
  uuid_column UUID,
  json_column JSON,
  hstore_column HSTORE,
  array_column TEXT [],
  user_defined_column user_defined_type,
  enum_column enum_type,
  xml_column XML,
  bytea_column BYTEA,
  composite_column composite_type
); 
drop table if exists data_types;
insert into data_types(char_column,varchar_column,text_column,numeric_column,integer_column,serial_column,float_column,real_column,double_column,
date_column,time_column,timestamp_column,interval_column,uuid_column,json_column,hstore_column,array_column,
user_defined_column,enum_column,xml_column,bytea_column,composite_column)
values ('characters','var characters','text data',123.45,123,DEFAULT,123.45,123.45,123.45,
'2024-09-25','12:57:58','2024-09-25 12:57:58','1 day','550e8400-e29b-41d4-a716-446655440000','{"type":"json"}','"type"=>"hstore"','{"this","is","an","array","type"}',
'this_is_a_user_defined_type','Other','<root><pet><name>Sammy</name><age>4</age><species>Cat</species></pet></root>',E'\\x6269746561',
ROW('Sally','Cat','Gray',4));
select * from data_types;
select xml_column from data_types;
select (xpath('/root/pet/age/text()',xml_column))[1]::text::integer as pet_age from data_types;
select (xpath('/root/pet/name/text()',xml_column))[1]::text as pet_name from data_types;
--********  S E T    O P E R A T O R S    ********
--********
--UNION 86
--********  

--repeat of section 27?  also used in section 39

--********
--INTERSECT 87
--******** 

--repeat of section 28?

--********
--EXCEPT 88
--******** 

--repeat of section 29? (is something different required in these 3 sections?)

--********  CONDITIONAL EXPRESSIONS & OPERATORS    ********
--********
--CASE 89
--********  

select type,title,release_year, case when release_year < 2000 then 'Old' when release_year < 2021 then 'New' else 'Newest' end as age from netflix;

--********
--COALESCE 90
--******** 
select title,coalesce(director,'Mr. Mysterious') from netflix limit 100;


--********
--NULLIF 91
--******** 
select id,title,nullif(director,'') from netflix order by id desc limit 100;
select * from netflix where id = 's93';
update netflix set director = '' where director is null and id='s93';

--********
--CAST 92
--******** 

--used in section 54, line 799