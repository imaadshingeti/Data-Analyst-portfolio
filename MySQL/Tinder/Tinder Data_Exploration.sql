-- 2. Write a query to print the name and details of all the one user to whom a particular user has sent request.
SELECT * 
FROM users 
WHERE uid IN (
              SELECT reciever   
              FROM right_swapping   
              WHERE SENDER  = 1) 

--SELECT SENDER,COUNT(*) 
FROM right_swapping 
GROUP BY SENDER 
ORDER BY COUNT(*) DESC
LIMIT 1,1

-- then apply join for name
SELECT u.name,COUNT(SENDER) 
FROM right_swapping s 
JOIN users u ON u.uid=s.SENDER 
GROUP BY s.SENDER 
ORDER BY COUNT(SENDER) DESC 
LIMIT 1,1 ) 

-- 3 Find the name of the user who has received min number of requests
SELECT u.name 
FROM right_swapping r 
JOIN users u ON u.uid=r.reciever 
GROUP BY reciever 
ORDER BY COUNT(reciever) 
LIMIT 1,1

-- 5  Find all the matches for a particular user 
-- a b --> ON r.SENDER=s.reciever 
-- b a --> WHERE r.reciever=s.SENDER 

SELECT r.SENDER,r.reciever FROM right_swapping r join right_swapping s ON r.SENDER=s.reciever WHERE r.reciever=s.SENDER 

-- for name 
SELECT u1.name, u2.name FROM right_swapping r join right_swapping s ON r.SENDER=s.reciever
JOIN users u1 ON r.SENDER=u1.uid
JOIN users u2 ON r.reciever=u2.uid
WHERE r.reciever=s.SENDER 

-- 
