-- Funkcja nr 1
/*
CREATE OR REPLACE FUNCTION znajdz_prace(id_pracy VARCHAR2) RETURN VARCHAR2
IS
    v_nazwa_pracy VARCHAR2(100);
BEGIN
    SELECT job_title
    INTO v_nazwa_pracy
    FROM JOBS
    WHERE job_id = id_pracy;

    RETURN v_nazwa_pracy;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Praca o podanym ID nie istnieje');
END;
/
SELECT znajdz_prace('SA_REP') AS nazwa_pracy FROM DUAL;
SELECT znajdz_prace('TEST_NIE_MA') AS nazwa_pracy FROM DUAL;
*/
-- Funkcja nr 2
/*
CREATE OR REPLACE FUNCTION roczne_zarobki(id_pracownika INT) RETURN FLOAT
IS
    v_wynagrodzenie FLOAT;
    v_premia FLOAT;
BEGIN
    -- Oblicz wynagrodzenie 12-miesiêczne
    SELECT (salary * 12)
    INTO v_wynagrodzenie
    FROM employees
    WHERE employee_id = id_pracownika;

    -- Oblicz premiê jako wynagrodzenie * commission_pct
    SELECT (salary * commission_pct)
    INTO v_premia
    FROM employees
    WHERE employee_id = id_pracownika;

    -- Zwróæ roczne zarobki (wynagrodzenie 12-miesiêczne + premia)
    IF v_premia IS NOT NULL THEN
        RETURN (v_wynagrodzenie + v_premia);
    END IF;
    RETURN v_wynagrodzenie;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20002, 'Pracownik o podanym ID nie istnieje');
END;
/
SELECT roczne_zarobki(5) FROM DUAL;
SELECT roczne_zarobki(100) FROM DUAL;
SELECT roczne_zarobki(145) FROM DUAL;
*/
-- Funkcja nr 3
/*
CREATE OR REPLACE FUNCTION pobierz_kierunkowy(nr_telefonu IN VARCHAR2) RETURN VARCHAR2
IS
    v_kierunkowy VARCHAR2(50);
BEGIN
    -- Usuwamy znak plus i od razu zwracamy resztê jako numer kierunkowy.
    v_kierunkowy := '(' || SUBSTR(nr_telefonu,1, LENGTH(nr_telefonu)-9) || ')' || SUBSTR(nr_telefonu,LENGTH(nr_telefonu)-9+1);

    RETURN v_kierunkowy;
END;
/
SELECT pobierz_kierunkowy('+48665504213') FROM DUAL;
*/
-- Funkcja nr 4
/*
CREATE OR REPLACE FUNCTION zmien_wielkosc_liter(p_ciag VARCHAR2) RETURN VARCHAR2
IS
    v_wynik VARCHAR2(4000);
BEGIN
    IF LENGTH(p_ciag) = 0 THEN
        RETURN NULL;
    END IF;
    
    v_wynik := INITCAP(SUBSTR(p_ciag, 1, 1)) || LOWER(SUBSTR(p_ciag, 2, LENGTH(p_ciag) - 2)) || INITCAP(SUBSTR(p_ciag, -1, 1));
    
    RETURN v_wynik;
END;
/
SELECT zmien_wielkosc_liter('przYK³ad') AS wynik FROM DUAL;
*/
-- Funkcja nr 5
/*
CREATE OR REPLACE FUNCTION pesel_na_date(p_pesel VARCHAR2) RETURN VARCHAR2
IS
    v_rok VARCHAR2(4);
    v_miesiac VARCHAR2(2);
    v_dzien VARCHAR2(2);
    v_data_ur VARCHAR2(10);
BEGIN
    IF LENGTH(p_pesel) <> 11 THEN
        RAISE_APPLICATION_ERROR(-20003, 'B³êdny PESEL (iloœæ znaków)!');
    END IF;
    
    -- Wyodrêbniamy rok, miesi¹c i dzieñ z numeru PESEL
    v_miesiac := SUBSTR(p_pesel, 3, 2);
    IF v_miesiac > 20 THEN
        v_rok := '20' || SUBSTR(p_pesel, 1, 2);
        v_miesiac := TO_CHAR(TO_NUMBER( v_miesiac)-20);
    ELSE
        v_rok := '19' || SUBSTR(p_pesel, 1, 2);
    END IF;
    v_dzien := SUBSTR(p_pesel, 5, 2);
    
    -- Tworzymy datê urodzenia w formacie 'yyyy-mm-dd'
    v_data_ur := v_rok || '-' || v_miesiac || '-' || v_dzien;
    
    RETURN v_data_ur;
END;
/
SELECT pesel_na_date('90010212345') AS data_urodzenia FROM DUAL;
SELECT pesel_na_date('16302316152') AS data_urodzenia FROM DUAL;
*/
-- Funkcja nr 6
/*
CREATE OR REPLACE FUNCTION liczba_pracownikow_i_departamentow(kraj VARCHAR2)
RETURN 
    VARCHAR2
IS
    v_liczba_pracownikow INT;
    v_liczba_departamentow INT;
    wynik VARCHAR2(100);
BEGIN
    -- ZnajdŸ liczbê pracowników w danym kraju
    SELECT COUNT(*) INTO v_liczba_pracownikow
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE d.location_id IN (SELECT l.location_id FROM locations l JOIN countries c ON l.country_id = c.country_id 
    WHERE c.country_name = kraj);

    -- ZnajdŸ liczbê departamentów w danym kraju
    SELECT COUNT(*) INTO v_liczba_departamentow
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = kraj;

    IF v_liczba_departamentow = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Podany kraj nie istnieje w bazie danych.');
    END IF;
    
    wynik := ' Liczba pracowników: ' || TO_CHAR(v_liczba_pracownikow) || '. Liczba departamentów: ' 
    || TO_CHAR(v_liczba_departamentow);
    
    RETURN wynik;

END;
/
SELECT liczba_pracownikow_i_departamentow('United States of America') FROM DUAL;
SELECT liczba_pracownikow_i_departamentow('£akanda') FROM DUAL;
*/
-- Trigger nr 1
/*
CREATE TABLE DEPARTMENTS_ARCHIVE (
    department_id NUMBER,
    department_name VARCHAR2(50),
    data_zamkniecia DATE,
    manager_id NUMBER,
    location_id NUMBER
);
*/
/*
CREATE OR REPLACE TRIGGER archiwum_departamentu_po_usunieciu
AFTER DELETE ON departments
FOR EACH ROW
BEGIN
    INSERT INTO departments_archive
    VALUES (:OLD.department_id, :OLD.department_name, SYSTIMESTAMP, :OLD.manager_id, :OLD.location_id);
END;
/
INSERT INTO departments VALUES (1234, 'Test_usuwania', 100, 1000);
SELECT * FROM departments WHERE department_id = 1234;
SELECT * FROM departments_archive;
DELETE FROM departments WHERE department_id = 1234;
SELECT * FROM departments_archive;
*/
-- Trigger nr 2
/*
CREATE TABLE zlodziej (
    zlodziej_id NUMBER,
    user_name VARCHAR2(50),
    czas_zmiany TIMESTAMP
);
CREATE TABLE Tabela_Pomocnicza
(
    id NUMBER
);
CREATE OR REPLACE PROCEDURE Usun_Rekordy_Procedura AS
BEGIN
    -- Warunki usuwania rekordów z Tabela_Pomocnicza
    DELETE FROM employees WHERE employee_id IN (SELECT id FROM Tabela_Pomocnicza);
    DELETE FROM Tabela_Pomocnicza;
END;
/
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'Usuwanie_Rekordow_Employee',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Usun_Rekordy_Procedura; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=1', -- Przyk³adowe ustawienia interwa³u
        enabled         => TRUE
    );
END;
/
BEGIN --Powinno zadzia³aæ, ale nie mam uprawnieñ :)
    DBMS_SCHEDULER.create_job (
        job_name        => 'Usuwanie_Rekordow_Job',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Usun_Rekordy_Procedura; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=1', -- Przyk³adowe ustawienia interwa³u
        enabled         => TRUE
    );
END;
/
*/
/*
CREATE OR REPLACE TRIGGER sprawdz_zarobki_pracownika
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
DECLARE
    v_wide³ka_min NUMBER := 2000;
    v_wide³ka_max NUMBER := 26000;
    v_max_id NUMBER;
    custom_exc EXCEPTION;
BEGIN
    SELECT MAX(zlodziej_id) INTO v_max_id FROM zlodziej;
    IF v_max_id IS NOT NULL THEN
        v_max_id := v_max_id + 1;
    ELSE
         v_max_id := 1; -- Ustaw ID na 1, jeœli tabela jest pusta
    END IF;
    
    IF :NEW.salary < v_wide³ka_min OR :NEW.salary > v_wide³ka_max THEN    
        DBMS_OUTPUT.PUT_LINE('Zarobki pracownika poza dozwolonymi wide³kami (2000 - 26000). Operacja zabroniona.');
        -- Zapisz log w tabeli zlodziej
        INSERT INTO zlodziej
        VALUES (v_max_id, USER, SYSTIMESTAMP);
        IF INSERTING THEN
            -- Kod do wykonania dla operacji INSERT
            INSERT INTO Tabela_Pomocnicza (id) VALUES (:NEW.employee_id);
        END IF;
        IF UPDATING THEN
            -- Kod do wykonania dla operacji UPDATE
            :NEW.salary := :OLD.salary;
        END IF;
    END IF;
END;
/
-- Wywo³anie b³êdne, bo wynagrodzenie (27000) jest poza wide³kami
INSERT INTO employees (employee_id, first_name, last_name, salary, email, hire_date, job_id) 
VALUES (994, 'John', 'Doe', 27000, 'example@example.com', '03/06/17', 'AD_PRES');
SELECT * FROM zlodziej;
SELECT * FROM employees WHERE employee_id=994;
UPDATE employees SET salary = 90000 WHERE employee_id = 104;
SELECT * FROM employees WHERE employee_id = 104;
SELECT * FROM zlodziej;
/*
BEGIN --Wiêc tu wywo³uje to rêcznie ;p
    Usun_Rekordy_Procedura;
END;
/
SELECT * FROM employees WHERE employee_id=994;
*/
-- Trigger nr 3
/*
CREATE SEQUENCE employee_id_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE OR REPLACE TRIGGER employees_auto_increment
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF :NEW.employee_id IS NULL THEN
    SELECT employee_id_seq.NEXTVAL INTO :NEW.employee_id FROM DUAL;
  END IF;
END;
/
INSERT INTO employees (first_name, last_name, salary, email, hire_date, job_id) 
VALUES ('John', 'Doe', 2100, 'example@example.com', '03/06/17', 'AD_PRES');
*/
-- Trigger nr 4
/*
CREATE OR REPLACE TRIGGER jod_grades_trigger
BEFORE INSERT OR UPDATE OR DELETE ON JOB_GRADES
BEGIN
  -- Zabrania wszelkich operacji na tabeli JOD_GRADES
  RAISE_APPLICATION_ERROR(-20024, 'Operacje na tabeli JOB_GRADES s¹ zabronione.');
END;
/
UPDATE JOB_GRADES SET min_salary = 1 WHERE grade='A';
*/
-- Trigger nr 5
/*
CREATE OR REPLACE TRIGGER jobs_before_update_trigger
BEFORE UPDATE ON jobs
FOR EACH ROW
BEGIN
    :NEW.max_salary := :OLD.max_salary;
    :NEW.min_salary := :OLD.min_salary;
END;
/
Update JOBS SET min_salary=1, max_salary= 2 WHERE job_id = 'AD_PRES';
SELECT * FROM JOBS WHERE job_id = 'AD_PRES';
*/
-- Paczka nr 1
/*
CREATE OR REPLACE PACKAGE moj_pakiet1 AS
    FUNCTION znajdz_prace(id_pracy VARCHAR2) RETURN VARCHAR2;
    FUNCTION roczne_zarobki(id_pracownika INT) RETURN FLOAT;
    FUNCTION pobierz_kierunkowy(nr_telefonu IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION zmien_wielkosc_liter(p_ciag VARCHAR2) RETURN VARCHAR2;
    FUNCTION pesel_na_date(p_pesel VARCHAR2) RETURN VARCHAR2;
    FUNCTION liczba_pracownikow_i_departamentow(kraj VARCHAR2) RETURN VARCHAR2;
    PROCEDURE DodajJob(p_Job_id Jobs.Job_id%TYPE, p_Job_title Jobs.Job_title%TYPE);
    PROCEDURE EdytujTytulJob(p_JOB_id JOBS.job_id%TYPE, p_JOB_title JOBS.job_title%TYPE);
    PROCEDURE UsunJob(p_job_id JOBS.job_id%TYPE);
    PROCEDURE ZarobkiPracownika(p_employee_id Employees.employee_id%TYPE, o_Zarobki OUT employees.salary%TYPE,
    o_Nazwisko OUT employees.last_name%TYPE);
    PROCEDURE DodajEmployee(
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
    );
END moj_pakiet1;
/
-- Cia³o pakietu
CREATE OR REPLACE PACKAGE BODY moj_pakiet1 AS
    FUNCTION znajdz_prace(id_pracy VARCHAR2) RETURN VARCHAR2
    IS
        v_nazwa_pracy VARCHAR2(100);
    BEGIN
        SELECT job_title
        INTO v_nazwa_pracy
        FROM JOBS
        WHERE job_id = id_pracy;
    
        RETURN v_nazwa_pracy;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Praca o podanym ID nie istnieje');
    END;
    FUNCTION roczne_zarobki(id_pracownika INT) RETURN FLOAT
    IS
        v_wynagrodzenie FLOAT;
        v_premia FLOAT;
    BEGIN
        -- Oblicz wynagrodzenie 12-miesiêczne
        SELECT (salary * 12)
        INTO v_wynagrodzenie
        FROM employees
        WHERE employee_id = id_pracownika;
    
        -- Oblicz premiê jako wynagrodzenie * commission_pct
        SELECT (salary * commission_pct)
        INTO v_premia
        FROM employees
        WHERE employee_id = id_pracownika;
    
        -- Zwróæ roczne zarobki (wynagrodzenie 12-miesiêczne + premia)
        IF v_premia IS NOT NULL THEN
            RETURN (v_wynagrodzenie + v_premia);
        END IF;
        RETURN v_wynagrodzenie;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20002, 'Pracownik o podanym ID nie istnieje');
    END;
    FUNCTION pobierz_kierunkowy(nr_telefonu IN VARCHAR2) RETURN VARCHAR2
    IS
        v_kierunkowy VARCHAR2(50);
    BEGIN
        -- Usuwamy znak plus i od razu zwracamy resztê jako numer kierunkowy.
        v_kierunkowy := '(' || SUBSTR(nr_telefonu,1, LENGTH(nr_telefonu)-9) || ')' || SUBSTR(nr_telefonu,LENGTH(nr_telefonu)-9+1);
    
        RETURN v_kierunkowy;
    END;
    FUNCTION zmien_wielkosc_liter(p_ciag VARCHAR2) RETURN VARCHAR2
    IS
        v_wynik VARCHAR2(4000);
    BEGIN
        IF LENGTH(p_ciag) = 0 THEN
            RETURN NULL;
        END IF;
        
        v_wynik := INITCAP(SUBSTR(p_ciag, 1, 1)) || LOWER(SUBSTR(p_ciag, 2, LENGTH(p_ciag) - 2)) || INITCAP(SUBSTR(p_ciag, -1, 1));
        
        RETURN v_wynik;
    END;
    FUNCTION pesel_na_date(p_pesel VARCHAR2) RETURN VARCHAR2
    IS
        v_rok VARCHAR2(4);
        v_miesiac VARCHAR2(2);
        v_dzien VARCHAR2(2);
        v_data_ur VARCHAR2(10);
    BEGIN
        IF LENGTH(p_pesel) <> 11 THEN
            RAISE_APPLICATION_ERROR(-20003, 'B³êdny PESEL (iloœæ znaków)!');
        END IF;
        
        -- Wyodrêbniamy rok, miesi¹c i dzieñ z numeru PESEL
        v_miesiac := SUBSTR(p_pesel, 3, 2);
        IF v_miesiac > 20 THEN
            v_rok := '20' || SUBSTR(p_pesel, 1, 2);
            v_miesiac := TO_CHAR(TO_NUMBER( v_miesiac)-20);
        ELSE
            v_rok := '19' || SUBSTR(p_pesel, 1, 2);
        END IF;
        v_dzien := SUBSTR(p_pesel, 5, 2);
        
        -- Tworzymy datê urodzenia w formacie 'yyyy-mm-dd'
        v_data_ur := v_rok || '-' || v_miesiac || '-' || v_dzien;
        
        RETURN v_data_ur;
    END;
    FUNCTION liczba_pracownikow_i_departamentow(kraj VARCHAR2) RETURN VARCHAR2
    IS
        v_liczba_pracownikow INT;
        v_liczba_departamentow INT;
        wynik VARCHAR2(100);
    BEGIN
        -- ZnajdŸ liczbê pracowników w danym kraju
        SELECT COUNT(*) INTO v_liczba_pracownikow
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        WHERE d.location_id IN (SELECT l.location_id FROM locations l JOIN countries c ON l.country_id = c.country_id 
        WHERE c.country_name = kraj);
    
        -- ZnajdŸ liczbê departamentów w danym kraju
        SELECT COUNT(*) INTO v_liczba_departamentow
        FROM departments d
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = kraj;
    
        IF v_liczba_departamentow = 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Podany kraj nie istnieje w bazie danych.');
        END IF;
        
        wynik := ' Liczba pracowników: ' || TO_CHAR(v_liczba_pracownikow) || '. Liczba departamentów: ' 
        || TO_CHAR(v_liczba_departamentow);
        
        RETURN wynik;
    
    END;
    PROCEDURE DodajJob(p_Job_id Jobs.Job_id%TYPE, p_Job_title Jobs.Job_title%TYPE)
    AS
    BEGIN
      INSERT INTO Jobs (Job_id, Job_title)
      VALUES (p_Job_id, p_Job_title);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('B³¹d podczas dodawania wiersza do tabeli Jobs: ' || SQLERRM);
    END DodajJob;
    PROCEDURE EdytujTytulJob(p_JOB_id JOBS.job_id%TYPE, p_JOB_title JOBS.job_title%TYPE)
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
    PROCEDURE UsunJob(p_job_id JOBS.job_id%TYPE)
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
    PROCEDURE ZarobkiPracownika(p_employee_id Employees.employee_id%TYPE, o_Zarobki OUT employees.salary%TYPE,
    o_Nazwisko OUT employees.last_name%TYPE)
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
    PROCEDURE DodajEmployee(
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
END moj_pakiet1;
/
*/
--Paczka nr 2
CREATE OR REPLACE PACKAGE regions_pkg AS
  -- Procedury CRUD
  PROCEDURE dodaj_region(p_region_id NUMBER, p_region_name VARCHAR2);
  PROCEDURE aktualizuj_region(p_region_id NUMBER, p_new_region_name VARCHAR2);
  PROCEDURE usun_region(p_region_id NUMBER);
  
  -- Funkcje odczytu z ró¿nymi parametrami
  FUNCTION pobierz_region(p_region_id NUMBER) RETURN VARCHAR2;
  FUNCTION pobierz_region_po_nazwie(p_region_name VARCHAR2) RETURN NUMBER;
END regions_pkg;
/

-- Cia³o pakietu
CREATE OR REPLACE PACKAGE BODY regions_pkg AS
  PROCEDURE dodaj_region(p_region_id NUMBER, p_region_name VARCHAR2) IS
  BEGIN
    INSERT INTO regions (region_id, region_name) VALUES (p_region_id, p_region_name);
    COMMIT;
  END dodaj_region;

  PROCEDURE aktualizuj_region(p_region_id NUMBER, p_new_region_name VARCHAR2) IS
  BEGIN
    UPDATE regions SET region_name = p_new_region_name WHERE region_id = p_region_id;
    COMMIT;
  END aktualizuj_region;

  PROCEDURE usun_region(p_region_id NUMBER) IS
  BEGIN
    DELETE FROM regions WHERE region_id = p_region_id;
    COMMIT;
  END usun_region;

  FUNCTION pobierz_region(p_region_id NUMBER) RETURN VARCHAR2 IS
    v_region_name regions.region_name%TYPE;
  BEGIN
    SELECT region_name INTO v_region_name FROM regions WHERE region_id = p_region_id;
    RETURN v_region_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL; -- Obs³uga braku danych
  END pobierz_region;

  FUNCTION pobierz_region_po_nazwie(p_region_name VARCHAR2) RETURN NUMBER IS
    v_region_id regions.region_id%TYPE;
  BEGIN
    SELECT region_id INTO v_region_id FROM regions WHERE region_name = p_region_name;
    RETURN v_region_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL; -- Obs³uga braku danych
  END pobierz_region_po_nazwie;
END regions_pkg;
/