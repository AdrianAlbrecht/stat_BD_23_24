SELECT * FROM employees;
DELETE FROM employees WHERE employee_id = 994;
DELETE FROM zlodziej;
SELECT * FROM Tabela_pomocnicza;
DELETE FROM employees WHERE employee_id IN (SELECT id FROM Tabela_Pomocnicza);
DELETE FROM Tabela_pomocnicza;
SELECT * FROM employees WHERE employee_id=994;
SELECT job_name, job_action, enabled
FROM USER_SCHEDULER_JOBS;
SELECT * FROM JOB_GRADES;
SELECT * FROM JOBS;