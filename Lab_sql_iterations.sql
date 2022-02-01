use sakila;

-- Lab | SQL Iterations
-- Write a query to find what is the total business done by each store.

select * from store;
select * from payment;
select * from staff;

SELECT s.store_id, SUM(amount) AS amount
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY 1;

-- Convert the previous query into a stored procedure.

DELIMITER //
CREATE PROCEDURE businees_store ()
BEGIN
SELECT s.store_id, SUM(amount) AS amount
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY 1;
END //
DELIMITER ;

CALL businees_store();

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DROP PROCEDURE IF EXISTS business_store_id;
DELIMITER //
CREATE PROCEDURE business_store_id(IN x INT)
BEGIN
SELECT s.store_id, SUM(amount) AS amount
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
WHERE s.store_id = x
GROUP BY 1;
END //
DELIMITER ;

CALL business_store_id(1);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.

DROP PROCEDURE IF EXISTS business_store_v3;
DELIMITER //
CREATE PROCEDURE business_store_v3( IN x INT, OUT total_sales_value INT)
BEGIN
SELECT SUM(amount) AS amount INTO total_sales_value
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
WHERE s.store_id = x;
END //
DELIMITER ;


call business_store_v3(1, @_total_sales_value);
select @_total_sales_value;


-- In the previous query, add another variable flag. 
-- If the total sales value for the store is over 30.000, then label it as green_flag, 
-- otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DROP PROCEDURE IF EXISTS business_store_v4;
DELIMITER //
CREATE PROCEDURE business_store_v4( IN x INT, OUT total_sales_value INT, OUT flag CHAR(40))
BEGIN
SELECT s.store_id, SUM(amount) AS amount INTO total_sales_value, flag
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
WHERE s.store_id = x
GROUP BY 1,3;
IF SUM(amount) > 30000 THEN SET flag = 'GREEN';
ELSE 
SET flag = 'RED';
END IF;
END //
DELIMITER ;



call business_store_v4(1, @_total_sales_value,  @_flag);
select @_flag;