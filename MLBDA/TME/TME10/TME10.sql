-- Question 1
select distinct color
from product

-- Question 2
SELECT unitPrice
FROM Product
ORDER BY unitPrice DESC
LIMIT 10

-- Question 3
SELECT DISTINCT productId
FROM reviews
WHERE rating = 5

-- Question 4
SELECT customerId, emailAddress
FROM customer
WHERE emailAddress LIKE "%@herman.com"

-- Question 5
SELECT customerId
FROM purchases
WHERE ARRAY_LENGTH(lineItems)= 5

-- Question 6
SELECT DISTINCT customerId
FROM purchases
WHERE ANY p IN lineItems SATISFIES p.count > 4 END

-- Question 7
SELECT customerId
FROM purchases
WHERE EVERY p IN lineItems SATISFIES p.count > 4 END

-- Question 8.a
SELECT p.productId, c
FROM product p UNNEST categories AS c

-- Question 8.b
SELECT p.customerId, l
FROM purchases p UNNEST lineItems AS l

-- Question 9
SELECT p.customerId, ARRAY i.product FOR i IN p.lineItems END AS product
FROM purchases p

-- Question 10
SELECT c.customerId, c.state, p.lineItems
  FROM purchases p INNER JOIN customer c ON KEYS p.customerId

-- Question 11
SELECT p.customerId, SUM(i.count) AS qteProduits
 FROM purchases p UNNEST lineItems as i
 GROUP BY p.customerId

-- EXERCICE 2 :
-- Question 1
SELECT p.name
FROM product p UNNEST categories AS c
WHERE lower(c) = 'golf'
LIMIT 10 OFFSET 10

-- Question 2
SELECT DISTINCT c
FROM product p UNNEST categories AS c

-- Question 3


