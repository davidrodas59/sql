SELECT * 
FROM actor;

SELECT first_name, last_name
FROM actor;


UPDATE actor
SET first_name = CONCAT(UCASE(LEFT(first_name, 1)), 
                             LCASE(SUBSTRING(first_name, 2)));
	
UPDATE actor
SET last_name = CONCAT(UCASE(LEFT(last_name, 1)),
							LCASE(SUBSTRING(last_name, 2)));
                            
SELECT first_name, last_name
FROM actor;

#select id, first, last name

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name  = 'Joe';

#Find all actors whose last name contain the letters GEN:

SELECT *
FROM actor
WHERE last_name Like  '%GEN%';

# Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT *
FROM actor
WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name ASC;

#2d. Using IN, display the country_id and country columns of the following countries: 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China::
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use the data type 
#BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
#done through alter command

ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `last_update` `last_update` 
TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
ON UPDATE CURRENT_TIMESTAMP AFTER `last_name`;

#3b. 
Delete description
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

#4a. List the last names of actors, as well as how many actors have that last name.


SELECT COUNT(last_name), last_name 
FROM actor
GROUP BY last_name
ORDER BY last_name;

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors

SELECT COUNT(*), last_name
FROM actor
GROUP BY last_name
HAVING  COUNT(*) >1;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
#
UPDATE actor
SET first_name = 'Harpo'
WHERE first_name = 'Groucho' and last_name = 'Williams';


#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = 'Groucho'
WHERE first_name = 'Harpo' and last_name = 'Williams';
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE actor;
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT actor.first_name, actor.last_name, address.address
FROM actor
INNER JOIN address ON actor.actor_id=address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.staff_id, COUNT(payment.amount) AS payment
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.actor_id
GROUP BY actor_id;


#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory.inventory_id) AS Hunchback
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY film.film_id;


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT SUM(payment.amount) AS payment
FROM payment
INNER JOIN customer ON customer.customer_id = payment.customer_id;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
# Use joins to retrieve this information.
SELECT first_name, last_name, email 
FROM customer cu
JOIN address a ON (cu.address_id = a.address_id)
JOIN city cit ON (a.city_id=cit.city_id)
JOIN country cntry ON (cit.country_id=cntry.country_id)
WHERE cntry.country_id = '20';
#WHERE city.country_id = '20';
#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT film.title, film.film_id
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
WHERE film_category.category_id = '8' ;


#7e. Display the most frequently rented movies in descending order.

SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Count_of_Rented_Movies DESC;
#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) 
FROM payment p
JOIN staff s ON (p.staff_id=s.staff_id)
GROUP BY store_id;
#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country FROM store s
JOIN address a ON (s.address_id=a.address_id)
JOIN city c ON (a.city_id=c.city_id)
JOIN country cntry ON (c.country_id=cntry.country_id);
#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the 
#Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW grossing
AS SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM grossing;
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW grossing;

