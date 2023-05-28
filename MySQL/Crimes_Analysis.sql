select  * from crime;
--- 1. Find the total number of crimes recorded in 2020 
--- UPDATE crime SET `Date Rptd` = STR_TO_DATE(`Date Rptd`, '%m/%d/%Y %h:%i:%s %p');
select count(DR_NO) as Number_of_Crimesin2020 from crime where year(`Date Rptd`)= 2020;
--- Answer:13406

--------------------
--- 2. Retrieve the top 10 crime types with the highest occurrence in 2020
--- alter table crime change `Crm Cd Desc` crime_type varchar(200); --- changing column name
select crime_type,count(crime_type)  from crime group by crime_type order by 2 desc limit 10; --- answer

--------------------
--- 3. Determine the month with the highest number of reported crimes in 2020.
select DATE_FORMAT(`Date Rptd`, '%M') as Month, count(1) from crime where year(`Date Rptd`)=2020 group by 1 order by 2 desc limit 1 ;

--------------------
--- 4. Calculate the average age of the victims involved in the crimes recorded in 2020.
select  avg(`Vict Age`) avg_age_victims from crime where year(`Date Rptd`)= 2020;

--------------------
--- 5. Identify the top 5 areas with the highest crime rates in 2020.
select * from crime;
select c.`AREA NAME`, c.count_area/t.Total_crimes*1000 as crime_rate_per1000
from (
   select`AREA NAME`, count(`AREA NAME`) as count_area
    from crime
    where year(`Date Rptd`) = 2020
    group by`AREA NAME`
) as c 
cross join (
    select count(`AREA NAME`) as Total_crimes
    from crime
    where year(`Date Rptd`) = 2020
) as t;

-------------------
--- 5. Find the most common weapon used in crimes in 2020.

select * from crime;
select `Weapon Used Cd` as code, count(`Weapon Used Cd`) as NO_of_times, `Weapon Desc` from crime where year(`Date Rptd`)=2020 group by `Weapon Used Cd`,`Weapon Desc`  order by `Weapon Used Cd` desc limit 1;

---------------------
--- 6. Determine the number of crimes reported in each category (e.g., violent crimes, property crimes) in 2022.
 select * from crime;
select crime_type as category, count(crime_type) as num_of_crimes from crime  where year(`Date Rptd`)=2022 group by crime_type;

-------------------

--- 7.Retrieve the details of the oldest and youngest offenders involved in crimes .

select 'Minimum Age' AS age_indicator, crime.* from crime order by `Vict Age` asc limit 1;
select 'Maximun Age' AS age_indicator, crime.* from crime order by `Vict Age` desc limit 1 ;

--------

--- 8. Calculate the percentage of solved crimes .
select * from crime;
select b.Solved_count/b.total*100 as percentage_of_solved_crimes 
from (select sum(a.count_of_type) as Solved_count , (select count(`Status Desc`) from crime) as total 
from (select count(`Status Desc` ) as count_of_type, `Status Desc` from crime group by `Status Desc` ) a
 where a.`Status Desc` in ('Adult Arrest', 'Juv Arrest')) b;

