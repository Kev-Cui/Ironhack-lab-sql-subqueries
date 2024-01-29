-- Lab-sql-subqueries
USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT film_id, COUNT(film_id) FROM inventory WHERE film_id = (
	SELECT film_id FROM film WHERE title = 'Hunchback Impossible'); 
-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title FROM film WHERE length > (
	SELECT AVG(length) FROM film);
-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name FROM actor WHERE actor_id IN (
	SELECT actor_id FROM film_actor WHERE film_id = (
		SELECT film_id FROM film WHERE title = "Alone Trip"));
        
-- Bonus:
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT title FROM film WHERE film_id IN (
	SELECT film_id FROM film_category WHERE category_id = (
		SELECT category_id FROM category WHERE name = "Family"));
        
-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, last_name, email, country FROM 
	(
	SELECT first_name, last_name, email, country FROM customer
    JOIN address USING(address_id)
    JOIN city USING(city_id)
    JOIN country USING(country_id)
    ) sub
    WHERE country = "Canada";

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT title FROM film WHERE film_id IN 
	(
	SELECT film_id FROM film_actor
	WHERE actor_id = 
		(
		SELECT actor_id FROM actor
		JOIN film_actor USING (actor_id)
		GROUP BY actor_id
		ORDER BY COUNT(film_id) DESC
		LIMIT 1
		)
	);

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT title FROM film WHERE film_id IN 
	(
	SELECT film_id FROM inventory
	WHERE inventory_id IN 
		(
		SELECT inventory_id FROM rental
		WHERE customer_id = 
			(
			SELECT customer_id FROM payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC
			LIMIT 1
			)
		)
	);

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT client_id, total_amount_spent FROM 
	(
	SELECT customer_id AS client_id, SUM(amount) AS total_amount_spent FROM payment
	GROUP BY customer_id
	) sub1
WHERE total_amount_spent > 
	(
	SELECT AVG(total_amount_spent) FROM 
		(
		SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment
		GROUP BY customer_id
		) sub2
	);