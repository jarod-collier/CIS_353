-- File: companyDML-a-solution 
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and 
each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance; it is provided for your convenience when
 checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-a.out) and submit the printout 
in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However,
 you ***MUST*** run this file from the command line as just explained above 
 and then submit a printout of the spooled file. Submitting a printout of the 
 webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-a.out
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: Jarod Collier
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  
supervisor, or his last name contains at least two occurences of the letter 'a'. 
Sort the results by ssn.
*/
SELECT ssn, lname
FROM employee
WHERE lname LIKE '%a%a%' OR super_ssn is NULL
ORDER BY ssn;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: 
Find the ssn, lname, project number, project name, and numer of hours.
 Sort the results by ssn.
*/
SELECT ssn, lname, pnumber, pname, hours
FROM employee e, project p, works_on w
WHERE w.hours > 30 AND e.ssn = w.essn AND w.pno = p.pnumber 
ORDER BY ssn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled 
by the department he works for: Find the employee's lname, the 
department he works for, the project number that he works on, and the 
number of the department that controls that project. Sort the results by lname.
*/
SELECT lname, dno, pnumber, dnum
FROM employee e, project p, works_on w
WHERE e.ssn = w.essn AND w.pno = p.pnumber AND e.dno != p.dnum
ORDER BY lname;
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that 
is located in the same location as his department: 
Find the ssn, lname, project number, project location, department number, 
and department location.Sort the results by lname
*/
SELECT DISTINCT lname, ssn, pnumber, plocation, dnum, dlocation
FROM employee e, project p, works_on w, dept_locations d
WHERE w.hours > 20 AND e.ssn = w.essn AND 
		w.pno = p.pnumber AND e.dno = p.dnum AND p.plocation = d.dlocation
ORDER BY lname;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate 
supervisor's salary: Find his ssn, lname, salary; and his 
supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT e.ssn, e.lname, e.salary, s.ssn, s.lname, s.salary
FROM employee e, employee s
WHERE e.salary < .7 * s.salary AND e.super_ssn = s.ssn
ORDER BY e.ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that 
the two employees in the pair work on the same project. Remove duplicates. 
Sort the result by the lname in the left column in the result. 
*/
SELECT DISTINCT e1.lname, e2.lname
FROM employee e1, employee e2, works_on w1, works_on w2, project p
WHERE e1.ssn = w1.essn AND e2.ssn = w2.essn AND w1.pno = w2.pno AND
		p.plocation = 'Houston' AND w1.pno = p.pnumber AND 
		w2.pno = p.pnumber AND	e1.ssn < e2.ssn
ORDER BY e1.lname;
--
------------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for 
every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT  e.lname, e.ssn, COALESCE(SUM(w.hours),0)
FROM employee e, works_on w
WHERE e.ssn = w.essn 
GROUP BY e.lname, e.ssn
HAVING COALESCE(SUM(w.hours),0) < 40;
------------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: 
Find the project number, project name, number of employees working on it, 
and the total number of hours worked by all employees on that project. 
Sort the results by project number.
*/ 
SELECT p.pnumber, p.pname, COUNT(*), COALESCE(SUM(w.hours),0)
FROM works_on w, project p
WHERE w.pno = p.pnumber
GROUP BY p.pnumber, p.pname
HAVING COUNT(*) > 2
ORDER BY p.pnumber;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in his department: 
Find the dno, ssn, lname, and salary . Sort the results by department number.
*/
SELECT e1.dno, e1.ssn, e1.lname, e1.salary
FROM employee e1
WHERE e1.salary = (SELECT  MAX (e2.salary)
					FROM employee e2
					WHERE e1.dno = e2.dno)
ORDER BY e1.dno;
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in 
Houston: Find the ssn and lname. Sort the results by lname
*/
SELECT e.lname, e.ssn
FROM employee e
WHERE e.ssn NOT IN (SELECT w.essn
			FROM works_on w, project p
			WHERE w.pno = p.pnumber AND p.plocation = 'Houston') 
ORDER BY e.lname;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: 
Find the ssn and lname. Sort the results by lname
*/
SELECT e.lname, e.ssn
FROM employee e
WHERE NOT EXISTS ((SELECT p.pnumber
			FROM project p
			WHERE  p.plocation = 'Stafford')
			MINUS
			(SELECT p.pnumber
			FROM project p, works_on w
			WHERE w.essn = e.ssn AND
				w.pno = p.pnumber AND 
				p.plocation = 'Stafford'))
ORDER BY e.lname;
--
SET ECHO OFF
SPOOL OFF


