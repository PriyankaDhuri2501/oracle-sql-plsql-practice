-- View all records from employees1 table
SELECT * FROM employees1;

-- View all records from HR schema customers table
SELECT * FROM HR.customers;

-- List all database usernames
SELECT username
FROM dba_users;

-- Change password of HR user
ALTER USER HR IDENTIFIED BY HR123;

-- View all tables owned by HR schema
SELECT * FROM all_tables WHERE owner = 'HR';

-- Drop employees table if it exists
DROP TABLE employees;

-- Create employees1 table
CREATE TABLE employees1 (
   emp_id     NUMBER PRIMARY KEY,
   emp_name   VARCHAR2(50),
   department VARCHAR2(50),
   salary     NUMBER,
   hire_date  DATE
);

-- Insert employee records
INSERT INTO employees1 VALUES (1, 'Priyanka', 'IT', 75000, DATE '2022-01-15');
INSERT INTO employees1 VALUES (2, 'Rahul', 'HR', 50000, DATE '2021-06-20');
INSERT INTO employees1 VALUES (3, 'Sneha', 'IT', 90000, DATE '2020-03-10');
INSERT INTO employees1 VALUES (4, 'Amit', 'Finance', 60000, DATE '2023-08-01');
INSERT INTO employees1 VALUES (5, 'Pooja', 'HR', 45000, DATE '2019-11-25');
INSERT INTO employees1 VALUES (6, 'Poo', 'Finance', NULL, DATE '2019-11-25');

-- Commit inserted data
COMMIT;

-- Get IT department employees sorted by salary descending
SELECT emp_name, salary
FROM employees1
WHERE department = 'IT'
ORDER BY salary DESC;

-- Department-wise aggregation (count, avg, max, min salary)
SELECT department,
       COUNT(*) AS total_employee,
       AVG(salary) AS avg_salary,
       MAX(salary) AS Highest,
       MIN(salary) AS Lowest
FROM employees1
GROUP BY department;

-- Departments with average salary greater than 55000
SELECT department, AVG(salary)
FROM employees1
GROUP BY department
HAVING AVG(salary) > 55000;

-- Create departments table
CREATE TABLE departments1 (
   dept_name   VARCHAR2(50),
   location    VARCHAR2(50)
);

-- Insert department data
INSERT INTO departments1 VALUES ('IT', 'Mumbai');
INSERT INTO departments1 VALUES ('HR', 'Pune');
INSERT INTO departments1 VALUES ('Finance', 'Delhi');

-- Commit department data
COMMIT;

-- Join employees with department location
SELECT e.emp_name, e.department, d.location
FROM employees1 e
JOIN departments1 d
ON e.department = d.dept_name;

-- Employees earning above average salary
SELECT emp_name, salary
FROM employees1
WHERE salary > (SELECT AVG(salary) FROM employees1);

-- Top salary employee in IT department (fetch first row only)
SELECT emp_name, salary
FROM employees1
WHERE department = 'IT'
ORDER BY salary DESC
FETCH FIRST ROW ONLY;

-- Replace NULL salary with 0 using COALESCE
SELECT emp_name, COALESCE(salary, 0)
FROM employees1;

-- Label department using DECODE
SELECT emp_name,
       DECODE(department,
              'IT', 'Tech_team',
              'HR', 'People_team',
              'Other') AS team_label
FROM employees1;

-- Calculate months worked and probation end date
SELECT emp_name,
       hire_date,
       MONTHS_BETWEEN(SYSDATE, hire_date) AS months_worked,
       ADD_MONTHS(hire_date, 6) AS probation_end
FROM employees1;

-- Rank employees by salary within department and overall
SELECT emp_name,
       salary,
       department,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_dept,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS overall_rank
FROM employees1;

-- Simple PL/SQL block
BEGIN
    DBMS_OUTPUT.PUT_LINE('STARTING PL/SQL');
END;

-- Fetch single employee using SELECT INTO
DECLARE
    v_name VARCHAR2(10);
    v_salary NUMBER(10);
BEGIN
    SELECT emp_name, salary
    INTO v_name, v_salary
    FROM employees1
    WHERE emp_id = 1;

    DBMS_OUTPUT.PUT_LINE(v_name || ' earns ' || v_salary);
END;

-- Conditional logic example in PL/SQL
DECLARE
    v_salary NUMBER := 5000;
BEGIN
    IF v_salary >= 70000 THEN
        DBMS_OUTPUT.PUT_LINE('Senior Employee');
    ELSIF v_salary >= 50000 THEN
        DBMS_OUTPUT.PUT_LINE('Mid Level');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Junior Employee');
    END IF;
END;

-- Loop through employees using FOR loop
BEGIN
    FOR rec IN (SELECT emp_name, salary FROM employees1) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.emp_name || ' ' || rec.salary);
    END LOOP;
END;

-- Cursor example for IT department employees
DECLARE
    CURSOR emp_cursor IS
        SELECT emp_name, salary FROM employees1 WHERE department = 'IT';
    v_name VARCHAR2(20);
    v_salary VARCHAR2(20);
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_name, v_salary;
        EXIT WHEN emp_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_name || ' earns ' || v_salary);
    END LOOP;
    CLOSE emp_cursor;
END;

-- Procedure to give salary raise by percentage
CREATE OR REPLACE PROCEDURE give_raise (
    p_dept IN VARCHAR2,
    p_percent IN NUMBER
) AS
BEGIN
    UPDATE employees1
    SET salary = salary + (salary * p_percent / 100)
    WHERE department = p_dept;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Raise given to ' || p_dept);
END;

-- Execute procedure for HR department
EXEC give_raise('HR', 5);

-- Select all employees
SELECT * FROM employees1;

-- Exception handling example for missing employee
DECLARE
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employees1
    WHERE emp_id = 99;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee Not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;

-- Trigger to prevent negative salary
CREATE OR REPLACE TRIGGER trg_salary_check
BEFORE INSERT OR UPDATE ON employees1
FOR EACH ROW
BEGIN
    IF :NEW.salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be negative!');
    END IF;
END;

-- Test insert (will fail if salary is negative)
INSERT INTO employees1 (emp_id, emp_name, salary, department)
VALUES (7, 'Test User', -5000, 'IT');

-- Check trigger details
SELECT trigger_name, table_name
FROM user_triggers
WHERE trigger_name = 'TRG_SALARY_CHECK';

-- Drop trigger
DROP TRIGGER trg_salary_check;

-- Delete specific employees
DELETE FROM employees1 WHERE emp_id IN (6,7);