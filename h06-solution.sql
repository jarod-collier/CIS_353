-- File: companyDML-a-solution
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file company.doc; it is provided for your convenience when checking the results of your queries.
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
** Print the resulting spooled file (companyDML-a.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-a.out
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: < ***** PLEASE ENTER YOUR NAME HERE ***** >
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/
SELECT E.ssn, E.lname
FROM   employee E
WHERE  E.super_ssn IS NULL OR E.lname LIKE '%a%a%' 
ORDER BY E.ssn;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
*/
SELECT E.ssn, E.lname, P.pnumber, P.pname, W.hours
FROM   employee E, works_on W, project P
WHERE  E.ssn = W.essn AND
       W.hours > 30 AND
       W.pno = P.pnumber
ORDER BY E.ssn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/
SELECT E.lname, E.dno, P.pnumber, P.dnum
FROM   employee E, works_on W, project P
WHERE  E.ssn = W.essn AND
       W.pno = P.pnumber AND
       E.dno != P.dnum
ORDER BY E.lname;
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/
SELECT DISTINCT E.ssn, E.lname, W.pno, P.plocation, E.dno, L.dlocation
FROM   employee E, dept_locations L, project P, works_on W
WHERE  E.ssn = W.essn AND
       E.dno = L.dnumber AND  
       W.pno = P.pnumber AND
       P.plocation = L.dlocation AND
       W.hours > 20
ORDER BY E.lname;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT E.ssn, E.lname, E.salary, S.ssn, S.lname, S.salary
FROM   employee E, employee S
WHERE  E.super_ssn = S.ssn AND 
       E.salary < 0.7 * S.salary
ORDER BY E.ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/
SELECT E1.lname, E2.lname
FROM   employee E1, employee E2, works_on W1, works_on W2, project P
WHERE  E1.ssn = W1.essn AND E2.ssn = W2.essn AND
       W1.pno = W2.pno AND W1.pno = P.pnumber AND
       p.plocation = 'Houston' AND
       E1.ssn > E2.ssn
ORDER BY E1.lname;
--
-- GROUP BY 1 ----------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT E.ssn, E.lname, SUM(W.hours)
FROM   employee E, works_on W
WHERE  E.ssn = W.essn
GROUP BY E.ssn, E.lname
HAVING SUM(W.hours) < 40 OR SUM(W.hours) IS NULL
ORDER BY E.lname;
--
-- GROUP BY 2 ----------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/ 
SELECT P.pnumber, P.pname, COUNT(*), SUM (W.hours)
FROM   works_on W, project P
WHERE  W.pno = P.pnumber
GROUP BY P.pnumber, P.pname
HAVING COUNT(*) > 2
ORDER BY P.pnumber;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in his department: Find the dno, ssn, lname, and salary . Sort the results by department number.
*/
SELECT E1.dno, E1.ssn, E1.lname, E1.salary
FROM   employee E1
WHERE  E1.salary =
       (SELECT MAX(E2.salary)
        FROM   Employee E2
        WHERE  E1.dno = E2.dno)
ORDER BY E1.dno; 
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
*/
SELECT E.ssn, E.lname
FROM   employee E
WHERE  E.ssn NOT IN
       (SELECT W.essn
        FROM   works_on W, project P
        WHERE  W.pno = P.pnumber AND P.plocation = 'Houston')
ORDER BY E.lname;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
*/
SELECT E.ssn, E.lname
FROM   employee E
WHERE  NOT EXISTS (
       (SELECT P.pnumber
        FROM   project P
        WHERE  P.plocation = 'Stafford')
       MINUS
       (SELECT W.pno
        FROM works_on W
        WHERE  E.ssn = W.essn))
ORDER BY E.lname;
--
SET ECHO OFF
SPOOL OFF


