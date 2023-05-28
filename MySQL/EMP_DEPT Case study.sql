use project;

CREATE TABLE dept(
deptno INT NOT NULL PRIMARY KEY,
dname VARCHAR(50),
loc VARCHAR(50));

INSERT INTO dept VALUES
(10,'OPERATIONS','BOSTON'),
(20,'RESEARCH','DALLAS'),
(30,'SALES','CHICAGO'),
(40,'ACCOUNTIING','NEW YORK');

select * from dept;

CREATE TABLE Employee (
  empno INT NOT NULL,
  ename VARCHAR(50),
  job VARCHAR(50) DEFAULT 'Clerk',
  mgr INT (4),
 hiredate DATE,
 sal DECIMAL(10, 2),
 CHECK (sal > 0),
 comm DECIMAL(7,2),
 deptno INT,
primary key(empno) , foreign key(deptno) references dept(deptno)
);

INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7369 ,'SMITH','CLERK',7902,'1890-12-17',800,NULL,20);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7499 ,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7521 ,'WARD','SALESMAN',7698,' 1981-02-22',1250,500,30);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7566, 'JONES','MANAGER',7839,' 1981-04-02',2975 ,NULL,20);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7654, 'MARTIN','SALESMAN',7698 ,'1981-09-28',1250,1400,30);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7698, 'BLAKE','MANAGER',7839,' 1981-05-01',2850,NULL,30);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7782, 'CLARK','MANAGER',7839 ,'1981-06-09' ,2450 ,NULL,10);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7788, 'SCOTT','ANALYST', 7566 ,'1987-04-19' ,3000 ,NULL,20);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7839, 'KING','PRESIDENT',NULL, '1981-11-17', 5000,NULL,10);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7844, 'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7876, 'ADAMS','CLERK',7788,'1987-05-23',1100 ,NULL,20);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7900, 'JAMES','CLERK',7698, '1981-12-03', 950 ,NULL,30);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7902, 'FORD','ANALYST',7566, '1981-12-03',3000 ,NULL,20);
INSERT INTO Employee(empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES(7934, 'MILLER','CLERK',7782, '1982-01-23',1300 ,NULL,10);

select * from Employee;

-- 3) List the Names and salary of the employee whose salary is greater than 1000

SELECT ename, sal
FROM Employee
WHERE sal > 1000;

-- 4.	List the details of the employees who have joined before end of September 81

SELECT *
FROM Employee
WHERE hiredate < '1981-10-01';

-- 5.	List Employee Names having I as second character

SELECT ename
FROM Employee
WHERE SUBSTRING(ename, 2, 1) = 'I';


-- 6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. 
-- Also assign the alias name for the columns

SELECT ename AS EmployeeName,
       sal,
       sal * 0.4 AS Allowances,
       sal * 0.1 AS PF,
       sal + (sal * 0.4) - (sal * 0.1) AS NetSalary
FROM Employee;

-- 7. List Employee Names with designations who does not report to anybody

SELECT ename, job
FROM Employee
WHERE mgr IS NULL;


-- 8.	List Empno, Ename and Salary in the ascending order of salary

SELECT empno, ename, sal
FROM Employee
ORDER BY sal ASC;

-- 9.	How many jobs are available in the Organization ?

SELECT COUNT(*) AS TotalJobs
FROM Employee;

-- 10.	Determine total payable salary of salesman category

SELECT SUM(sal) AS TotalPayableSalary
FROM Employee
WHERE job = 'SALESMAN';

-- 11.	List average monthly salary for each job within each department   

SELECT deptno, job, AVG(sal) AS AverageMonthlySalary
FROM Employee
GROUP BY deptno, job;

-- 12.	Use the Same EMP and DEPT table used in the Case study to Display EMPNAME,
-- SALARY and DEPTNAME in which the employee is working.

SELECT e.ename, e.sal, d.dname
FROM employee e
JOIN dept d ON e.deptno = d.deptno;

-- 13.	  Create the Job Grades Table as below

create table Job_Grades(grade varchar (50), lowest_sal int,highest_sal int);

INSERT INTO Job_Grades  VALUES
("A",0,999),
("B",1000,1999),
("C",2000,2999),
("D",3000,3999),
("E",4000,5000);

SELECT * FROM project.job_grades;

-- 14.	Display the last name, salary and Corresponding Grade

SELECT E.ename, E.sal, J.grade
 FROM employee E 
   JOIN job_grades J
     ON E.sal BETWEEN J.lowest_sal AND J.highest_sal;
     
-- 15.	Display the Emp name and the Manager name under whom the Employee works in the below format .

select emp.ename as "Employee", emp.empno as "Emp#", emp.mgr as "Mgr#",m.ename as "Manager"
from employee as emp LEFT OUTER JOIN employee m ON emp.mgr = m.empno;

-- 16.	Display Empname and Total sal where Total Sal (sal + Comm)

Select ename,sal,comm, (sal + ifnull(comm, 0)) as total_salary from employee;

-- 17.	Display Empname and Sal whose empno is a odd number

SELECT empno, ename, sal FROM employee WHERE empNo % 2 = 1;

-- 18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department

SELECT ename, RANK() OVER (ORDER BY sal DESC) AS RankInOrganization, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS RankInDepartment FROM Employee;

-- 19.	Display Top 3 Empnames based on their Salary

SELECT ename, sal
FROM employee
ORDER BY sal DESC
LIMIT 3;

-- 20.  Display Empname who has highest Salary in Each Department

SELECT deptno, ename, sal
FROM employee
WHERE (deptno, sal) IN (
  SELECT deptno, MAX(sal)
  FROM employee
  GROUP BY deptno
);






