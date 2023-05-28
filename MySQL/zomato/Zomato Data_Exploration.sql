--1 What is the total amount each customer spent on zomato ?
SELECT s.user_id,sum(p.price)
FROM sales s 
JOIN product p  
ON s.product_id=p.product_id 
GROUP by s.us

--2 How many days each customer visited zomato ?
SELECT user_id,COUNT(created_at) 
FROM sales 
GROUP by user_id

--3  What was the first product purchased by each customer ? which is our catchy or attracting product 
--  increase it production to decrease delivery time  and also add same type of product to increase its sales
SELECT sales.user_id,sales.product_id 
FROM sales 
where sales.created_at 
IN (SELECT MIN(sales.created_at) 
    FROM `sales` 
    GROUP by sales.user_id)

-- with rank function 
SELECT * FROM ( 
  SELECT *,rank() over(
                       PARTITION by user_id 
                       ORDER by created_at) rnk 
  from sales)a 
  WHERE rnk =1; 
  
--4  What is the most purchased item on the menu and how many times was it purchased by all customer ? 
-- we able to understand teste of customer going from where to where,then we provide differnt ads for new users and old users
--a.
SELECT product_id,COUNT(product_id) a FROM `sales` GROUP by product_id ORDER by a DESC LIMIT 1 

--b. 
With t1 as (SELECT * FROM sales 
            WHERE product_id 
               IN (SELECT product_id 
                   FROM (SELECT product_id,COUNT(product_id) a 
                         FROM `sales` 
                         GROUP by product_id 
                         ORDER by a DESC 
                         LIMIT 1) A ) ) 

SELECT user_id, COUNT(user_id) FROM t1 GROUP by user_id

-- 5 Which item is most popular for each customer ? 

-- pertcular user buy perticular item how many times,
with t1 as (
  SELECT user_id,product_id,COUNT(product_id)cnt 
  FROM `sales` 
  GROUP by user_id,product_id )

SELECT user_id, product_id 
FROM (SELECT *,rank() over(PARTITION by user_id ORDER BY cnt DESC) rnk 
      from t1)a 
      WHERE rnk=1

--6 Which item was purchased first by the customer after the become a gold member ? 

-- order placed after the gold membership taken by that perticular users
WITH t1 AS(SELECT s.user_id,s.product_id,s.created_at 
           FROM sales s join gold_user_signup g ON g.user_id=s.user_id WHERE g.gold_signup_date<=s.created_at)

SELECT user_id,product_id FROM (SELECT *,rank() over(PARTITION BY user_id ORDER by created_at ) rnk from t1 )a WHERE rnk=1 

--7 Which item was purchased just before they become a gold member ? 

WITH t1 AS(SELECT s.user_id,s.product_id,s.created_at 
           FROM sales s 
           join gold_user_signup g 
           ON g.user_id=s.user_id 
           WHERE g.gold_signup_date>s.created_at)

SELECT user_id,product_id FROM (
                                SELECT *,rank() over(PARTITION BY user_id ORDER by created_at DESC ) rnk 
                                from t1 )a 
                                WHERE rnk=1

--8 What is a total order and amount spent each member before the become the member ? 

WITH t1 AS(SELECT s.user_id,s.product_id,s.created_at 
           FROM sales s 
           join gold_user_signup g 
           ON g.user_id=s.user_id 
           WHERE g.gold_signup_date>s.created_at) 
           
SELECT t1.user_id,COUNT(p.product_id),SUM(p.price) 
FROM t1 
JOIN product p 
ON p.product_id=t1.product_id 
GROUP by t1.user_id 

--9 If buying each product generates points for eg 5rs-2 zomato point and each product has different purchasing points 
-- for eg for p1 5rs 1 zomato point, for p2 10rs-5zomato point and p3 5rs-1 zomato point I 

-- a. which user have how many points ? 
SELECT s.user_id,SUM(
CASE 
WHEN product_name = "p1" then price*0.2
WHEN product_name = "p2" then price*0.5
WHEN product_name = "p3" then price*0.2
END) AS points
FROM `product` p 
JOIN sales s 
ON p.product_id=s.product_id 
GROUP BY s.user_id 

--b. which product most point have been given till now 
SELECT s.product_id,SUM(
CASE 
WHEN product_name = "p1" then price*0.2
WHEN product_name = "p2" then price*0.5
WHEN product_name = "p3" then price*0.2
END) AS points
FROM `product` p 
JOIN sales s 
ON p.product_id=s.product_id 
GROUP BY s.product_id
ORDER BY points DESC 
LIMIT 1 

-- 10.  In the first one year after a customer joins the gold program (including their join date) irrespective of what the customer
-- has purchased they earn 5 zomato points for every 10 rs spent who earned more more 1 or 3 and what was their points earnings 
-- in thier first yr ?

WITH t1 AS (SELECT s.user_id,s.created_at,s.product_id 
            FROM sales s 
            JOIN gold_user_signup g ON s.user_id=g.user_id 
            WHERE g.gold_signup_date<=s.created_at AND s.created_at<=DATE_ADD(g.gold_signup_date,INTERVAL 1 Year)  
            ORDER BY s.created_at) 

SELECT user_id,SUM(p.price),sum(p.price*0.5) points 
FROM t1 
JOIN product p 
ON p.product_id=t1.product_id 
GROUP by user_id
   
--11 Rank all the transaction 
SELECT *,rank() over(PARTITION BY user_id ORDER BY created_at desc) 
FROM sales 

--12 rank all the transactions for each member whenever they are a zomato gold member for every non gold member transction mark as na ?  

SELECT s.user_id,s.product_id,s.created_at,
CASE
WHEN g.gold_signup_date<s.created_at THEN rank() over(PARTITION BY s.user_id ORDER BY s.created_at desc)
ELSE "na" 
END AS rnk
FROM sales s 
JOIN gold_user_signup g 
ON g.user_id=s.user_id
