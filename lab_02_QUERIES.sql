-- Query 1
/*SELECT CONCAT(Last_Name, CONCAT(', ', Salary)) AS Last_name_and_salary
FROM Employees
WHERE (Department_ID = 20 OR Department_ID = 50) AND SALARY BETWEEN 2000 AND 7000
ORDER BY Last_Name;*/
-- Query 2
/*SELECT e1.Hire_date, e1.Last_name, e1.Email
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.Manager_ID IS NOT NULL
AND TO_CHAR(e2.HIRE_DATE, 'YYYY') = '2005'
ORDER BY e1.Hire_date;*/
-- Query 3
/*SELECT CONCAT(First_name, CONCAT(' ',Last_Name)) AS Name, Salary, Phone_number
FROM Employees
WHERE SUBSTR(Last_Name, 3, 1) = 'e'
AND SUBSTR(First_Name, 1, 2) = 'Da'
ORDER BY Name DESC, Salary ASC;*/
-- Query 4
/*SELECT First_name, Last_name, round(months_between(CURRENT_DATE, Hire_date)) AS months_worked,
CASE
WHEN round(months_between(CURRENT_DATE, Hire_date))<150 THEN 0.1*Salary --Nie wiem dlaczego jak dam WHEN months_worked <150 to krzyczy, ¿e identyfikator nierozpoznany :(
WHEN round(months_between(CURRENT_DATE, Hire_date))<200 THEN 0.2*Salary
ELSE 0.3*Salary END
AS wysokoœæ_dodatku
FROM Employees
ORDER BY Months_worked;*/
-- QUERY 5
/*SELECT Dep.Department_name, SUM(j.min_salary) AS Suma_Minimalnej, SUM(j.max_salary) AS Suma_Maxymalnej, AVG(j.min_salary) AS Œrednia_Minimalnej, AVG(j.max_salary) AS Œrednia_Maxymalnej
FROM Departments Dep
JOIN Job_history JH
ON jh.department_id = dep.department_id
JOIN JOBS J
ON jh.job_id = j.job_id
WHERE j.min_salary > 5000
GROUP BY Dep.Department_name;*/
--Query 6
/*SELECT e.LAST_NAME, e.department_id, dep.department_name, e.job_id 
FROM Employees e
JOIN Departments dep
ON e.department_id = dep.department_id
JOIN Locations loc
ON dep.location_id = loc.location_id
WHERE loc.city = 'Toronto';*/
--Query 7
/*SELECT e.First_name, e.Last_name
FROM employees e
WHERE e.department_id IN (SELECT dep.department_id 
FROM departments dep
JOIN employees e
ON e.department_id = dep.department_id
WHERE e.employee_id IN (SELECT employee_id
FROM employees
WHERE first_name = 'Jennifer'));*/
--Query 8
/*SELECT *
FROM departments
WHERE department_id NOT IN (SELECT UNIQUE dep.department_id
FROM departments dep
JOIN employees e
ON e.department_id = dep.department_id)*/
-- Query 9 DONE IN lab_02.sql file
-- Query 10
/*SELECT e.First_Name, e.Last_Name, dep.Department_name, e.salary, (SELECT jg.Grade from JOB_GRADES jg WHERE e.salary between jg.min_salary AND jg.max_salary) AS Grade
FROM employees e
JOIN departments dep
ON e.department_id = dep.department_id;*/
-- Query 11
/*SELECT e.first_name, e.Last_name, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(e.salary) FROM employees e)
ORDER BY e.salary;*/
-- QUERY 12
SELECT e.employee_id ,e.First_name, e.Last_name
FROM employees e
WHERE e.department_id IN (SELECT UNIQUE dep.department_id 
FROM departments dep
JOIN employees e
ON e.department_id = dep.department_id
WHERE e.employee_id IN (SELECT employee_id
FROM employees
WHERE last_name LIKE '%u%'));