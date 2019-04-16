use sakila;

-- 1a, first name, and last name
describe actor;
select first_name, last_name from actor;

-- 1b, first and last name together named actor name
select upper(concat(first_name, '.', last_name)) as 'Actor Name' from actor;

-- 2a
select actor_id, first_name, last_name from actor where first_name = 'Joe';

-- 2b
select actor_id, first_name, last_name from actor where upper(last_name) like '%GEN%';

-- 2c
select actor_id, first_name, last_name from actor where last_name like '%LI%' order by last_name, first_name;

-- 2d
describe country;
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
alter table actor add column description blob after last_name;

-- 3b
alter table actor drop description;

-- 4a
select last_name, count(*) as 'Number of actor' from actor group by last_name;

-- 4b
select last_name, count(*) as 'Number of actor' from actor  group by last_name having count(*) >= 2;

-- 4c
update actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLAMS';

-- 4d
update actor set first_name = 'GROUCHO' where first_name = 'HARPO' and last_name = 'WILLAMS';

-- 5a
describe sakila.address;

-- 6a
select first_name s, last_name s, address a from staff s join address a on s.address_id = a.address_id;

-- 6b
describe payment;
describe staff;

select sum(p.amount), p.staff_id, s.first_name,s.last_name from payment p join staff s on s.staff_id = p.staff_id where payment_date like '2005-08%' group by p.staff_id ;

-- 6c
describe film_actor;
select p.title, p.film_id, count(a.actor_id) from film p join film_actor a on p.film_id = a.film_id group by p.film_id;

-- 6d
SELECT title, (
SELECT COUNT(*) FROM inventory
WHERE film.film_id = inventory.film_id
) AS 'Number of Copies'
FROM film
WHERE title = "Hunchback Impossible";

-- 6e
SELECT c.first_name, c.last_name, sum(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY c.customer_id
order by c.last_name;

-- 7a 

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film 
WHERE language_id = 1
);

-- 7b

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

-- 7c

SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

-- 7d

SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

-- 7e

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

-- 7f

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

-- 7g

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);


--  7h

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

--  8a

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
  	
--  8b

SELECT * FROM genre_revenue;

--  8c

DROP VIEW genre_revenue;



