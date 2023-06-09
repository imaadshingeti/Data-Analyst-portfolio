 create database dmadeod_sql_project.
-- Step 1:  Check table: 
            SELECT * 
            FROM cc_data 
            LIMIT 10


-- Step 2: Check data types:
            desc cc_data;



-- Step 3 fix the date format:
            SET SQL_SAFE_UPDATES = 0;
            UPDATE cc_data SET call_timestamp =STR_TO_DATE(call_timestamp,'%m/%d/%y');
            SET SQL_SAFE_UPDATES = 1;


-- Step 4 change the data types:

            ALTER TABLE cc_data 
            MODIFY COLUMN call_timestamp date;
            ALTER TABLE cc_data 
            MODIFY COLUMN csat_score int(2);


--Step 5 Change column name: 
            ALTER TABLE cc_data 
            CHANGE COLUMN `call duration in minutes` CDinMin int(2) NOT NULL;





--  Step 6 replace the blank values with null:
            SET SQL_SAFE_UPDATES = 0;
            UPDATE cc_data SET csat_score =NULL 
            WHERE csat_score= 0;
            SET SQL_SAFE_UPDATES = 1;


-- Step 7 Check for the duplicates:
            SELECT 
            count(*) as row_num 
            FROM cc_data;
            Check unique row number:
            SELECT 
            COUNT(DISTINCT id ),COUNT(DISTINCT customer_name)
            FROM cc_data;



-- Step 8 Count the reasons for the call : 
            SELECT 
            reason, 
            COUNT(*),
            ROUND ((COUNT(*) / (SELECT COUNT(*) FROM cc_data)) *100,1) AS Percentage 
            FROM cc_data
            GROUP BY reason



-- Step 9 which day has the most calls?
            SELECT 
            DAYNAME(call_timestamp) AS Day_of_Call,
            COUNT(*) num_of_calls 
            FROM cc_data
            GROUP BY 1
            ORDER BY 2  
            DESC;

-- Step 10 Find out the minimum, maximum and average call duration.
             SELECT 
            MIN(CDinMin) AS Minimum_Duration, 
            MAX(CDinMin) AS Maximum_Duration, 
            ROUND(AVG(CDinMin),1) AS Avarage_Duration
            FROM cc_data;

-- STep 11 Sentiment count
            SELECT 
            sentiment, COUNT(*)
            FROM cc_data
            GROUP BY sentiment
            ORDER BY 2
            DESC




-- STep 12 Check how many call are within, below or above the service
            SELECT call_center,
            response_time,
            COUNT(*) AS counts
            FROM cc_data
            GROUP BY 1,2
            ORDER BY 1,3
            DESC
