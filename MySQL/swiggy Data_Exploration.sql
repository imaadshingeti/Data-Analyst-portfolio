1-- Find customers who have never ordered 
(SELECT user_id FROM orders) --> All people who orders 

SELECT * FROM users 
WHERE user_id NOT IN (SELECT user_id FROM orders);  -->Minus from all users

2-- # Average Price/dish 
-- SUM(price)/COUNT(*) ===> AVG(price) 

SELECT f_id,SUM(price)/COUNT(*) FROM menu GROUP BY f_id  
-- for name of food 
SELECT f.f_name,SUM(m.price)/COUNT(m.f_id) as Avg_price 
FROM menu m 
JOIN food f 
ON m.f_id=f.f_id 
GROUP BY m.f_id;

3-- Find top restautant in terms of number of orders for given month 
SELECT r_name 
FROM restaurent 
WHERE r_id = 
(SELECT r_id FROM orders GROUP BY r_id  ORDER BY COUNT(*) DESC LIMIT 1)

4-- Find top restautant in terms of number of orders for JUNE month 
SELECT r_name FROM restaurent WHERE r_id = (SELECT r_id 
FROM orders 
WHERE MONTHNAME(date) LIKE "July" 
GROUP BY r_id 
ORDER by COUNT(*) DESC 
LIMIT 1) 

5-- restaurants with monthly sales > x for a particular month

SELECT r_id,SUM(amount) FROM orders WHERE MONTHNAME(date) LIKE "July" GROUP BY r_id 

-- full query with name of restaurent
SELECT r.r_name,SUM(o.amount) 
FROM orders o 
JOIN restaurent r 
ON o.r_id=r.r_id 
WHERE (MONTHNAME(o.date) LIKE "July") AND (o.amount>5000) 
GROUP BY o.r_id 


6-- Show all orders with order details for a particular customer in a particular date range 

SELECT f.f_name,u.name,o.amount 
 FROM order_details od 
 JOIN orders o 
 ON od.order_id=o.order_id 
 JOIN users u 
 ON u.user_id=o.user_id 
 JOIN food f 
 ON f.f_id=od.f_id 
 WHERE date  BETWEEN "2022-06-10" AND "2022-07-10" ;
 
7-- Find the restaurant with max repeat customer 
 
SELECT r_id,COUNT(*) as Loyal_Customer # wo restarent jaha sab s zyada baar baar y hua hai -- loyal customer 
FROM (
    SELECT o.r_id,o.user_id,COUNT(o.r_id) as Visit 
    FROM orders o  
    GROUP BY o.r_id ,o.user_id 
    HAVING Visit>1) AS t  
GROUP BY r_id 
ORDER BY Loyal_Customer DESC 
LIMIT 1

8-- Month over month revenue growth of a swiggy 

WITH t1 AS (
  SELECT MONTHNAME(date) as Month,SUM(amount) as Revenue 
  FROM orders 
  GROUP BY MONTHNAME(date) 
  ORDER BY MONTH(date) )
  
(SELECT Month,Revenue, LAG(Revenue,1) OVER(ORDER BY Revenue) 
 FROM t1) AS t2
 
SELECT ((Revenue-Pre)/Revenue)*100 
FROM t2 ; 

9-- Customer -> favorite food
WITH temp AS (SELECT o.user_id,od.f_id ,COUNT(od.f_id) AS frequency 
FROM orders o JOIN order_details od ON o.order_id=od.order_id 
GROUP BY o.user_id,od.f_id 
ORDER BY COUNT(od.f_id) DESC)

SELECT user_id,f_id,frequency  
FROM temp AS T1 
WHERE T1.frequency IN ( 
    SELECT MAX(frequency)
    FROM temp AS T2 
    WHERE T1.user_id=T2.user_id)
    
10 -- Find most loyal customers for all restaurant[Homework] 
WITH t AS (SELECT user_id,r_id,COUNT(user_id) AS again 
           FROM `orders` 
           GROUP BY user_id,r_id ) 

SELECT r_id,user_id,MAX(again) FROM t GROUP BY r_id ;  

11-- Month over month revenue growth of a restaurant 
WITH t AS (SELECT r_id,MONTHNAME(date) as Month,SUM(amount) as Revenue 
           FROM orders 
           GROUP BY MONTHNAME(date),r_id 
           HAVING r_id=1 
           ORDER BY MONTH(date) )
 
SELECT r_id,Month,((Revenue - LAG(Revenue,1)OVER(ORDER BY Revenue))/Revenue)*100 
FROM t

12-- Most Paired Products 

SELECT f1.f_name, f2.f_name, COUNT(*) AS pair_count 
FROM orders o
JOIN order_details od1 ON o.order_id = od1.order_id
JOIN order_details od2 ON o.order_id = od2.order_id AND od1.id < od2.id
JOIN food f1 ON od1.f_id = f1.f_id
JOIN food f2 ON od2.f_id = f2.f_id AND f1.f_id < f2.f_id
GROUP BY f1.f_name, f2.f_name
ORDER BY pair_count DESC;
