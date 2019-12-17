-- Run the following query to create a modified customers "table" (actually a VIEW)
-- This version of the customers table will have (duplicate rows) to simulate
-- multiple users with the same name.

-- THIS ONLY NEEDS TO RUN ONCE. After that, you can delete the query.
CREATE OR REPLACE VIEW customers_mod AS(
SELECT * FROM customers 
	UNION ALL
SELECT * FROM customers WHERE contactname ILIKE '%an%'
	UNION ALL
SELECT * FROM customers WHERE contactname ILIKE '%ia%');

SELECT * FROM customers_mod ORDER BY contactname;
-- ** What's a VIEW? In brief, a VIEW is a psuedo-table that is attached to the original tables 
-- it's created from, but as far is this exercise is concerned, it's a custom table.
-- Where going to autogenerate username for our customers using the customers_mod VIEW (see above).

-- Step 1: We want the user name to be the first 5 letters of their last name combined with the 
-- first 3 letters of their first name, all lower case.
-- Example George Clooney -> cloongeo



-- Gets me first name
SELECT split_part(contactname, ' ', 1) as first_token
FROM customers;

-- Gets last name
SELECT split_part(contactname, ' ',  2) AS last_name
FROM customers;

-- Answer

SELECT LOWER(CONCAT(LEFT(split_part(contactname, ' ',  2),5), LEFT(split_part(contactname, ' ', 1),3)))
FROM customers;


-- Step 2: Notice that there are customers with the same? Can you think of a way to 
-- make sure that all user names are unique? Add to the query in Step 1 so any users
-- with the same name as another username as a unique number attached to it
-- eg. (cloongeo1), but the first username has no digits appened to it.

WITH duped_keywords AS(
    SELECT LOWER(CONCAT(LEFT(split_part(contactname, ' ',  2),5), LEFT(split_part(contactname, ' ', 1),3))) AS code
    FROM customers)

SELECT code, COUNT(code),
    CASE WHEN COUNT(code) >1 
    THEN 'DUPE' 
    ELSE code
    END final_code
FROM duped_keywords
GROUP BY code;