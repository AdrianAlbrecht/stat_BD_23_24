--SELECT * FROM DEPARTMENTS WHERE department_id = (SELECT max(department_id) FROM DEPARTMENTS);
--DELETE FROM departments WHERE department_id = 280;
--SELECT * FROM nowa;
--SELECT * FROM JOBS;
--DELETE FROM JOBS WHERE job_id = 'T_TST';
SELECT * FROM employees;