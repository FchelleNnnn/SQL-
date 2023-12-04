
/* DATA QUERY LANGUAGE */

SELECT * FROM SCHOOL;
SELECT * FROM SUBJECTS;
SELECT * FROM STAFF;
SELECT * FROM STAFF_SALARY;
SELECT * FROM CLASSES;
SELECT * FROM STUDENTS;
SELECT * FROM PARENTS;
SELECT * FROM STUDENT_CLASSES;
SELECT * FROM STUDENT_PARENT;
SELECT * FROM ADDRESS;

SELECT * FROM STUDENTS;

SELECT STUDENT_ID, FIRST_NAME --fetch only specific columns
FROM STUDENTS;

/* Different SQL Operators:::    = , <, >, >=, <=, <>, !=, BETWEEN, ORDER BY, IN, NOT IN, LIKE, ALIASE, DISTINCT, LIMIT, CASE:
Comparison Operators: =, <>, != , >, <, >=, <=
Arithmetic Operators: +, -, *, /, %
Logical Operators: AND, OR, NOT, IN, BETWEEN, LIKE etc.    */

SELECT * FROM SUBJECTS
WHERE SUBJECT_NAME <> 'Mathematics' --comparison operators

SELECT *
FROM STAFF_SALARY 
WHERE SALARY <= 10000; -- comparison operators

SELECT *
FROM STAFF_SALARY
WHERE SALARY BETWEEN 5000 AND 10000 
ORDER BY SALARY --logical operators 

SELECT *
FROM SUBJECTS 
WHERE SUBJECT_NAME IN ('Mathematics', 'Science' , 'Arts') --logical operators (in)

SELECT *
FROM SUBJECTS 
WHERE SUBJECT_NAME LIKE ('S%') --logical operators

SELECT *
FROM SUBJECTS 
WHERE SUBJECT_NAME LIKE ('%c') --logical operators

--fetch all staff details who are female and over the age of 50
-- AND / OR
SELECT *
FROM STAFF
WHERE AGE > 50 AND GENDER = 'F' --logical operators

SELECT(5+2) as addition; -- arithmetic operators
SELECT(5*2) as multiplication; -- aritmetic operators

/* OTHER SQL FUNCTIONS */

SELECT DISTINCT STAFF_TYPE FROM STAFF ; --removes duplicated values
SELECT STAFF_TYPE FROM STAFF LIMIT 5 ; --fetch the first 5 records

/* CASE STATEMENT */ 
-- from the staff salary , if the salary > 10,000 then it is high salary , '5000-10000' 'Average salary' 
--else too low
SELECT * ,
CASE
	WHEN SALARY > 10000 THEN 'High Salary'
	WHEN SALARY BETWEEN 5000 AND 10000 THEN 'Average Salary'
	ELSE 'Too Low'
	END as "Range"
FROM STAFF_SALARY

/* JOIN */
--using SUBJECTS and CLASSES table , fetch all the class name where subject is music
SELECT class_name
FROM CLASSES a
JOIN SUBJECTS b ON a.subject_id = b.subject_id
WHERE subject_name = 'Music'

--using subjects, classes and staffs table, fetch the full name of all staffs who teach mathematics. 

SELECT DISTINCT CONCAT(first_name , ' ' , last_name) as Full_name
FROM STAFF a
JOIN CLASSES b ON a.staff_id = b.teacher_id
JOIN SUBJECTS c ON c.subject_id = b.subject_id
WHERE subject_name = 'Mathematics' ;

/* UNION / UNION ALL */

-- using staff and classes table, fetch all staff who teach gr. 8, 9 and 10
-- also fetch all the non-teaching staffs

SELECT * FROM STAFF;
SELECT * FROM CLASSES;

SELECT staff_type , CONCAT(first_name , ' ' , last_name) as full_name , age, gender ,join_date
FROM STAFF a
JOIN CLASSES b ON a.staff_id = b.teacher_id
WHERE class_name IN ('Grade 8' , 'Grade 9', 'Grade 10')
AND staff_type = 'Teaching'

UNION --using union , it removes the duplicated values

SELECT staff_type , CONCAT(first_name , ' ' , last_name) as full_name , age, gender , join_date
FROM STAFF a
--JOIN CLASSES b ON a.staff_id = b.teacher_id JOIN SHOULD BE REMOVED BECAUSE IT WILL JUST LINK THE TEACHING STAFFS 
-- FROM THE CLASSES TABLE
WHERE a.staff_type = 'Non-Teaching'

/*GROUP BY STATEMENT AND HAVING CLAUSE */

-- from the student_classes table , fetch the count of students in each class

SELECT class_id , COUNT(1) as no_of_students
FROM STUDENT_CLASSES
GROUP BY class_id
ORDER BY class_id

-- from the student classes table, fetch the class which has more than 100 students

SELECT class_id , COUNT(1) as no_of_students
FROM STUDENT_CLASSES
GROUP BY class_id
HAVING COUNT(1) > 100 -- it is like a where condition but with group by
ORDER BY class_id

/* SUBQUERY - query written inside the query */

--using  parents, student_parent , students and address table ,
-- fetch the details of parents having more than 1 kids going to school. 
--display the student details. (parent name, student name, student age, student gender and address)

SELECT * FROM parents;
SELECT * FROM student_parent; 
SELECT * FROM students ; 
SELECT * FROM address;

SELECT CONCAT(a.first_name , ' ' , a.last_name) as parent_name  ,
CONCAT(c.first_name , ' ' , c.last_name) as student_name ,
c.age as student_age, c.gender as student_gender ,
CONCAT(street, ' ', city , ' ' , state , ' ' , country) as address
FROM parents a
JOIN student_parent b ON a.parent_id = b.parent_id
JOIN students c ON b.student_id = c.student_id
JOIN address d ON d.address_id = a.address_id
WHERE a.parent_id IN 
(SELECT e.parent_id 
FROM student_parent e 
GROUP BY e.parent_id -- ,count(1) can be removed since it is grouped by and there is a having clause
HAVING COUNT(1) > 1)
ORDER BY a.parent_id;

/* AGGREGATE FUNCTIONS */

--calculate the average salary of teaching staffs using staff_salary and staff

SELECT * FROM STAFF
SELECT * FROM STAFF_SALARY

SELECT ROUND(AVG(a.salary)::decimal,2) as avg_Salary 
FROM STAFF_SALARY a 
JOIN STAFF b ON b.staff_id = a.staff_id
WHERE b.staff_type = 'Non-Teaching'

SELECT staff_type , ROUND(SUM(a.salary)::decimal,2) as avg_Salary 
FROM STAFF_SALARY a 
JOIN STAFF b ON b.staff_id = a.staff_id
GROUP BY staff_type

/* INNER JOINS AND OUTER JOINS */

-- inner join 
SELECT COUNT(1)
FROM STAFF STF
JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME||' '||STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 2;

--left join 
--23 records present in the left table
-- all records from the left table will be fetched irrespective of whether there is a matching record
-- in the RIGHT TABLE
SELECT COUNT(1)
FROM STAFF STF
LEFT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME||' '||STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
LEFT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 2;

-- full outer join 
-- 26 records - all records from both tables
-- 21 matching records + 2 records from the left + 3 records from the right table
SELECT COUNT(1)
FROM STAFF STF
FULL OUTER JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME||' '||STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
FULL OUTER JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1,2;












