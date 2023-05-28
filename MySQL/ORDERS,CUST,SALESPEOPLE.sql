create database Advproject;
use advproject;

create table salespeople (snum int,sname varchar(50),city varchar(50),comm float);
 insert into salespeople values (1001,"Peel","London",0.12),(1002,"Serres","San Jose",0.13),(1003,"Axelrod","New york",0.10),(1004,"Motika","London",0.11),(1007,"Rafkin","Barcelona",0.15);
select* from salespeople;
alter table salespeople add primary key(snum);
desc salespeople;

create table cust (cnum int not null,cname varchar(50),city varchar(50),rating int,snum int,primary key(cnum) , foreign key(snum) references salespeople(snum));
insert into cust values (2001,"Hoffman","London",100,1001),(2002,"Giovanne","Rome",200,1003),(2003,"Liu","San Jose",300,1002),(2004,"Grass","Berlin",100,1002),(2006,"Clemens","London",300,1007),(2007,"Pereira","Rome",100,1004),(2008,"James","London",200,1007);
select* from cust;
desc cust;

create table orders (onum int primary key not null ,amount int ,odate date,cnum int,snum int,foreign key(snum) references salespeople(snum),foreign key(cnum) references cust(cnum));
alter table orders 
modify amount float;
desc orders;
insert into orders values (3001,18.69,"1994-10-03",2008,1007),(3002,1900.10,"1994-10-03",2007,1004),(3003,767.19,"1994-10-03",2001,1001),(3005,5160.45,"1994-10-03",2003,1002),(3006,1098.16,"1994-10-04",2008,1007),(3007,75.75,"1994-10-05",2004,1002),(3008,4723.00,"1994-10-05",2006,1001),(3009,1713.23,"1994-10-04",2002,1003),(3010,1309.95,"1994-10-06",2004,1002),(3011,9891.88,"1994-10-06",2006,1001);
select * from orders;
-------------------------------------------------------------------------------------------------------------------
use advproject;
--	Write a query to match the salespeople to the customers according to the city they are living.

SELECT salespeople.sname AS "Salesperson",
cust.cname, salespeople.city ,cust.snum
FROM salespeople,cust 
WHERE salespeople.city=cust.city;

-- Write a query to select the names of customers and the salespersons who are providing service to them.
SELECT salespeople.sname AS "Salesperson",
cust.cname as Customer,cust.snum 
FROM salespeople,cust 
WHERE salespeople.snum=cust.snum;

-- 	Write a query to find out all orders by customers not located in the same cities as that of their salespeople.
select  onum,orders.cnum,orders.snum,cust.cname
from orders,cust,salespeople
where cust.city<>salespeople.city and orders.cnum=cust.cnum and orders.snum=salespeople.snum;

--	Write a query that lists each order number followed by name of customer who made that order
select orders.onum,cust.cname from orders,cust
where orders.cnum=cust.cnum;

--	Write a query that finds all pairs of customers having the same rating
Select a.cname, b.cname,a.rating from cust a, cust b where a.rating = b.rating and a.cnum != b.cnum;

-- Write a query to find out all pairs of customers served by a single salesperson
select a.cname,b.cname,salespeople.sname from cust a,cust b,salespeople 
where a.snum=b.snum and a.snum=salespeople.snum and a.cname!=b.cname;

--	Write a query that produces all pairs of salespeople who are living in same city
select a.sname,b.sname,a.city from salespeople a,salespeople b
where a.city=b.city and a.sname!=b.sname;

--	Write a Query to find all orders credited to the same salesperson who services Customer 2008
select * from orders where snum=(select distinct snum from orders where cnum=2008);

--	Write a Query to find out all orders that are greater than the average for Oct 4th
select * from orders where amount>(select avg(amount) from orders where odate="1994-10-04");

--	Write a Query to find all orders attributed to salespeople in London.
select * from orders where snum in(select snum from  salespeople where city = "london");

-- 	Write a query to find all the customers whose cnum is 1000 above the snum of Serres.
select cname,cnum from cust where cnum >(select snum from salespeople where sname="Serres")+1000;

-- 	Write a query to count customers with ratings above San Jose’s average rating.
select count(cname) from cust where
rating > (select avg(rating) from cust where city ="San Jose"); 

--	Write a query to show each salesperson with multiple customers.

SELECT * 
FROM salespeople
WHERE snum IN (
   SELECT DISTINCT snum
   FROM cust a 
   WHERE EXISTS (
      SELECT * 
      FROM cust b 
      WHERE b.snum=a.snum 
      AND b.cname<>a.cname));