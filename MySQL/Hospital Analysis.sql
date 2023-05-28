----------------Step 1: Understand the data----------------------
-- To view the dataset we will run following query
select *
from project.dataset

----------------Step 2: Look for blank values----------------------
select *
from project.dataset
where hospital is null;


-----------------Step 3: Exploratory Data Analysis----------------------
-- As we are focusing on only those hospitals whose MSPB ratio score is given in the dataset,
-- we will be avoiding all the entries of score 'Not Available'

-- Query 1:
#No of hospitals and States#
select
count(distinct Hospital) as dis_num_of_hospital,
count(distinct state) as dis_num_of_states
from project.dataset
where score != 'not available'

-- Query 2:
#No of cities and counties#
select
count(distinct city) as dis_num_of_cities,
count(distinct county) as num_of_county
from project.dataset
where score != 'not available'

-- Query 3: 
#No of hospitals from each state#
select state,
count(distinct Hospital) as num_of_hosp
from project.dataset
where score != 'not available'
group by state
order by num_of_hosp DESC

-- Query 4:
#Highest MSPB ratio score#
select
max(score)
from project.dataset
where score != 'not available'

-- Query 5:
#List of hospitals with highest MSPB ratio score#
select Hospital, state, score
from project.dataset
where Score!= 'Not Available'
order by score DESC
limit 10

-- Query 6:
#Lowest MSPB ratio score#
select
min(score)
from project.dataset
where score != 'not available'

-- Query 7:
#List of hospitals with lowest MSPB ratio score#
select Hospital, state, score
from project.dataset
where Score!= 'Not Available'
order by score
limit 10

-- Query 8:
#No of hospitals having MSPB ratio score '1'#
select (count(distinct hospital)) as Hospitals_score_1
from project.dataset
where score = '1'

-- Query 9:
#No of hospitals having MSPB ratio score greater than 1#
select count(distinct hospital) as Hospitals_score_greater_than_1 
from project.dataset
where score  > '1' and
score != 'Not Available'

-- Query 10:
#No of hospitals having MSPB ratio score smaller than 1#
select count(distinct hospital) as Hospitals_score_smaller_than_1 
from project.dataset
where score  < '1' and
score != 'Not Available'

-- These are the queries I have runned for the EDA of given dataset
--------------------------------Thank You---------------------------------