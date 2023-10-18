-- Zad 1
/*
SET SERVEROUTPUT ON;
DECLARE
    numer_max NUMBER(5);
BEGIN
   SELECT max(department_id) INTO numer_max FROM DEPARTMENTS;
   DBMS_OUTPUT.PUT_LINE('Wartoœæ zmiennej: ' || numer_max);
   INSERT INTO departments(department_id, department_name) VALUES ((numer_max+10), 'EDUCATION');
EXCEPTION
   WHEN no_data_found THEN
        numer_max := 0;
END;
*/
-- Zad 2
/*
SET SERVEROUTPUT ON;
DECLARE
    numer_max NUMBER(5);
BEGIN
   SELECT max(department_id) INTO numer_max FROM DEPARTMENTS;
   DBMS_OUTPUT.PUT_LINE('Wartoœæ zmiennej: ' || numer_max);
   INSERT INTO departments(department_id, department_name) VALUES ((numer_max+10), 'EDUCATION');
   UPDATE departments SET location_id = 3000 WHERE department_id = (numer_max+10);
EXCEPTION
   WHEN no_data_found THEN
        numer_max := 0;
END;
*/
--Zad 3
/*
CREATE TABLE nowa (wartosc VARCHAR2(10));
BEGIN
  FOR i IN 1..10 LOOP
    IF i != 4 AND i != 6 THEN
      INSERT INTO nowa (wartosc) VALUES (TO_CHAR(i));
    END IF;
  END LOOP;
  COMMIT;
END;
*/
--Zad 4
/*
DECLARE
  v_country countries%ROWTYPE;
BEGIN
  SELECT * INTO v_country FROM countries WHERE country_id = 'CA';
  DBMS_OUTPUT.PUT_LINE('Nazwa kraju: ' || v_country.country_name);
  DBMS_OUTPUT.PUT_LINE('ID regionu: ' || v_country.region_id);
END;
*/
--Zad 5
/*
SET SERVEROUTPUT ON;
DECLARE
    TYPE DepartmentIndex IS TABLE OF departments.department_name%TYPE INDEX BY BINARY_INTEGER;
    v_departments DepartmentIndex;
BEGIN
    FOR i IN 1..10 LOOP
        v_departments(i * 10) := NULL;
        SELECT department_name INTO v_departments(i * 10)
        FROM departments
        WHERE department_id = i * 10;
    END LOOP;
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Numer departamentu: ' || i * 10 || ', Nazwa departamentu: ' || v_departments(i * 10));
    END LOOP;
END;
*/
--Zad 6
/*
SET SERVEROUTPUT ON;
DECLARE
  v_department departments%ROWTYPE;
BEGIN
  FOR i IN 1..10 LOOP
    SELECT * INTO v_department
    FROM departments
    WHERE department_id = i * 10;
    DBMS_OUTPUT.PUT_LINE('Informacje o departamencie o ID ' || v_department.department_id);
    DBMS_OUTPUT.PUT_LINE('Nazwa departamentu: ' || v_department.department_name);
    DBMS_OUTPUT.PUT_LINE('ID mened¿era: ' || v_department.manager_id);
    DBMS_OUTPUT.PUT_LINE('ID lokalizacji: ' || v_department.location_id);
    DBMS_OUTPUT.NEW_LINE; -- Nowa linia miêdzy departamentami
  END LOOP;
END;
*/
--Zad 7
/*
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_employees IS SELECT last_name, salary FROM employees WHERE department_id = 50;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    FOR emp_rec IN c_employees LOOP
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        IF v_salary > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' nie dawaæ podwy¿ki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' daæ podwy¿kê');
        END IF;
    END LOOP;
END;
*/
--Zad 8
/*
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_employee_salary (min_salary NUMBER, max_salary NUMBER, name_part VARCHAR2)
    IS SELECT first_name, last_name, salary FROM employees WHERE salary BETWEEN
    min_salary AND max_salary AND UPPER(first_name) LIKE '%' || UPPER(name_part) 
    || '%';
  
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 1000-5000 i imieniem zawieraj¹cym "a" lub "A":');
    FOR emp_rec IN c_employee_salary(1000, 5000, 'a') LOOP
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 5000-20000 i imieniem zawieraj¹cym "u" lub "U":');
    FOR emp_rec IN c_employee_salary(5000, 20000, 'u') LOOP
        v_first_name := emp_rec.first_name;
        v_last_name := emp_rec.last_name;
        v_salary := emp_rec.salary;
        DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
    END LOOP;
END;
*/
--Zad 9
--a
CREATE OR REPLACE PROCEDURE DodajJob(
  p_Job_id Jobs.Job_id%TYPE,
  p_Job_title Jobs.Job_title%TYPE
)
AS
BEGIN
  INSERT INTO Jobs (Job_id, Job_title)
  VALUES (p_Job_id, p_Job_title);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania wiersza do tabeli Jobs: ' || SQLERRM);
END DodajJob;
/
CALL DodajJob('T_TST', 'TESTER');
CALL DodajJob('IT_PROG', 'Programmer');
--b
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE EdytujTytulJob(
    p_JOB_id JOBS.job_id%TYPE,
    p_JOB_title JOBS.job_title%TYPE
)
AS
    no_jobs_updated EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_jobs_updated, -20000);
BEGIN
    UPDATE JOBS SET job_title = p_JOB_title WHERE job_id = p_job_id;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE no_jobs_updated;
    END IF;
    COMMIT;
EXCEPTION
    WHEN no_jobs_updated THEN
        DBMS_OUTPUT.PUT_LINE('Brak zaktualizowanych wierszy w tabeli Jobs.');
END EdytujTytulJob;
/
CALL edytujtytuljob('IT_PROG','Programista');
CALL edytujtytuljob('N_NIEMO', 'Nie ma');
--c
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE UsunJob(
    p_job_id JOBS.job_id%TYPE
)
AS
    no_jobs_deleted EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_jobs_deleted, -20001);
BEGIN
    DELETE FROM Jobs WHERE job_id = p_job_id;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE no_jobs_deleted;
    END IF;
    COMMIT;
EXCEPTION
    WHEN no_jobs_deleted THEN
        DBMS_OUTPUT.PUT_LINE('Brak usuniêtych wierszy w tabeli Jobs.');
END UsunJob;
/
CALL usunjob('T_TST');
CALL usunjob('T_TST');
--d
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE ZarobkiPracownika(
    p_employee_id Employees.employee_id%TYPE,
    o_Zarobki OUT employees.salary%TYPE,
    o_Nazwisko OUT employees.last_name%TYPE
)
AS
BEGIN
    SELECT salary, last_name INTO o_zarobki, o_nazwisko FROM employees
    WHERE employees.employee_id = p_employee_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak pracownika o podanym ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('B³¹d podczas pobierania danych pracownika: ' || SQLERRM);
END ZarobkiPracownika;
/
SET SERVEROUTPUT ON;
DECLARE
  v_Zarobki NUMBER;
  v_Nazwisko VARCHAR2(50);
BEGIN
    ZarobkiPracownika(101, v_Zarobki, v_Nazwisko);
    IF v_Zarobki IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Zarobki pracownika: ' || v_Zarobki);
        DBMS_OUTPUT.PUT_LINE('Nazwisko pracownika: ' || v_Nazwisko);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Brak pracownika o podanym ID lub wyst¹pi³ b³¹d: ' || v_Nazwisko);
    END IF;
END;
/
DECLARE
  v_Zarobki NUMBER;
  v_Nazwisko VARCHAR2(50);
BEGIN
    ZarobkiPracownika(1010, v_Zarobki, v_Nazwisko);
    IF v_Zarobki IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Zarobki pracownika: ' || v_Zarobki);
        DBMS_OUTPUT.PUT_LINE('Nazwisko pracownika: ' || v_Nazwisko);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Brak pracownika o podanym ID lub wyst¹pi³ b³¹d: ' || v_Nazwisko);
    END IF;
END;
/
--e
CREATE OR REPLACE PROCEDURE DodajEmployee(
    p_First_name employees.first_name%TYPE,
    p_Last_name employees.last_name%TYPE,
    p_Salary employees.salary%TYPE DEFAULT 1000,
    p_email employees.email%TYPE DEFAULT 'example@mail.com',
    p_phone_number employees.phone_number%TYPE DEFAULT NULL,
    p_hire_date employees.hire_date%TYPE DEFAULT SYSDATE,
    p_job_id employees.job_id%TYPE DEFAULT 'IT_PROG',
    p_commission_pct employees.commission_pct%TYPE DEFAULT NULL,
    p_manager_id employees.manager_id%TYPE DEFAULT NULL,
    p_department_id employees.department_id%TYPE DEFAULT 60
)
AS
    salary_too_high EXCEPTION;
    PRAGMA EXCEPTION_INIT(salary_too_high, -20002);
    v_Employee_id NUMBER;
BEGIN
    SELECT (MAX(employee_id)+1) INTO v_Employee_id FROM employees;
    IF p_Salary > 20000 THEN
        RAISE salary_too_high;
    ELSE
        INSERT INTO employees
        VALUES (v_Employee_id, p_First_name, p_Last_name, p_email, p_phone_number,
        p_hire_date, p_job_id, p_salary, p_commission_pct, p_manager_id, p_department_id);
        COMMIT;
    END IF;
EXCEPTION
    WHEN salary_too_high THEN
        DBMS_OUTPUT.PUT_LINE('Wynagrodzenie przekracza 20000, nie mo¿na dodaæ pracownika.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania pracownika: ' || SQLERRM);
END DodajEmployee;
/
CALL dodajemployee('Andrzej', 'Wazon', 3000);
CALL dodajemployee('Jacek', 'Beton', 30000);
CALL dodajemployee('Konstanty', 'Wagasz', 5000, 'kwagasz@gmail.com');