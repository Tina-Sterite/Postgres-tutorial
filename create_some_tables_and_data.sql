CREATE TABLE directors(
director_id SMALLINT,
name VARCHAR(100) NOT NULL
);

-- ****** for the above.. should have used *****
CREATE TABLE directors(
    director_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);



--imdb.com Poll: Imdb Top 250 Directors (with 4 or more films in Imdb Top 250)
CREATE TABLE top_rated_directors(
  director_id SMALLINT NOT NULL, 
  rank SMALLINT,
  num_films SMALLINT,
  num_votes INT
);
--reddit.com directors with >= 8 movies with >= 16000 votes per movie
CREATE TABLE most_popular_directors(
  director_id SMALLINT NOT NULL,
  rank SMALLINT,
  good FLOAT,
  imdb_rating FLOAT
  ); 
--from the-numbers.com top grossing directors  
CREATE TABLE top_grossing_directors(
  director_id SMALLINT NOT NULL,
  rank SMALLINT,
  total_films SMALLINT,
  amt BIGINT
);

insert into directors
select distinct ROW_NUMBER() OVER (ORDER BY director), director from(
select director from top_rated_directors
union select director from most_popular_directors
union select director from top_grossing_directors) order by director;
select * from directors;


INSERT INTO top_rated_directors(rank, director_id, num_films, num_votes) 
VALUES 
   (1,4,6,3337), 
   (2,22, 8,2537), 
   (3,2, 9,1609),
   (4,17, 5,1378),
   (5,14, 6,1305), 
   (6,23, 6,853), 
   (7,10, 4,526),
   (8,1, 5,381),
   (9,9, 5,327),
   (10,21, 5,319);

select * from top_rated_directors;

INSERT INTO most_popular_directors(rank, director_id, good, imdb_rating) 
VALUES 
  (1, 4, 100.0, 8.20), 
  (2, 9, 100.0, 7.97), 
  (3, 17, 92.9, 7.94),
  (4, 22, 84.6, 7.76),
  (5, 16, 80.0, 7.71),
  (6, 6, 75.0, 7.64),
  (7, 20, 81.8, 7.60),
  (8, 1, 84.4, 7.54),
  (9, 8, 63.6, 7.45),
  (10, 7, 81.8, 7.45);

select * from most_popular_directors;

  INSERT INTO top_grossing_directors(rank,director_id, total_films, amt) 
VALUES 
  (1, 23, 37, 4635966882), 
  (2, 12, 14, 2697508805), 
  (3, 4, 13, 2392745658),
  (4, 15, 16, 2349060734),
  (5, 13, 10, 2280821799),
  (6, 3, 9, 2280821799),
  (7, 11, 7, 2198878974),
  (8, 16, 15, 2162574522),
  (9, 19, 34, 2107006487),
  (10, 18,24, 2106012859),
  (11, 5, 40, 1991216528);

  select * from top_grossing_directors;