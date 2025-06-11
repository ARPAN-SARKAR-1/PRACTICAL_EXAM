-- PERSON-PROJECT DATABASE - Oracle SQL Implementation
-- ==================================================

-- 1. TABLE CREATION
-- ================

-- Drop tables if they exist (for clean execution)
DROP TABLE Person CASCADE CONSTRAINTS;
DROP TABLE Project CASCADE CONSTRAINTS;

-- Create PROJECT table (referenced table must be created first)
CREATE TABLE Project (
    PROJECT_NO NUMBER(4) PRIMARY KEY,
    PROJECT_NAME VARCHAR2(10) UNIQUE
);

-- Create PERSON table with all specified constraints
CREATE TABLE Person (
    PERSON_NO VARCHAR2(5) PRIMARY KEY,
    PERSON_NAME VARCHAR2(10) NOT NULL,
    SALARY NUMBER(7,2) CHECK (SALARY BETWEEN 5000 AND 30000),
    BIRTH_DATE DATE,
    JOIN_DATE DATE,
    P_NO NUMBER(4),
    CITY VARCHAR2(15) CHECK (CITY LIKE 'Ind_%'),
    FOREIGN KEY (P_NO) REFERENCES Project(PROJECT_NO)
);

-- 2. DATA INSERTION
-- ================

-- Insert 4 records into PROJECT table
INSERT INTO Project VALUES (1001, 'ERP System');
INSERT INTO Project VALUES (1002, 'Web Portal');
INSERT INTO Project VALUES (1003, 'Mobile App');
INSERT INTO Project VALUES (1004, 'Analytics');

-- Insert 10+ records into PERSON table
INSERT INTO Person VALUES ('P001', 'Peter', 15000.00, DATE '1990-03-15', DATE '2020-03-10', 1001, 'Ind_Mumbai');
INSERT INTO Person VALUES ('P002', 'Priya', 18000.00, DATE '1988-07-20', DATE '2019-07-25', 1002, 'Ind_Delhi');
INSERT INTO Person VALUES ('P003', 'Rajesh', 22000.00, DATE '1985-11-10', DATE '2018-05-15', 1001, 'Ind_Pune');
INSERT INTO Person VALUES ('P004', 'Sunita', 12000.00, DATE '1992-01-05', DATE '2021-01-12', 1003, 'Ind_Chennai');
INSERT INTO Person VALUES ('P005', 'Amit', 25000.00, DATE '1987-09-18', DATE '2017-04-20', 1002, 'Ind_Bangalore');
INSERT INTO Person VALUES ('P006', 'Neha', 16000.00, DATE '1991-06-12', DATE '2020-08-30', 1004, 'Ind_Hyderabad');
INSERT INTO Person VALUES ('P007', 'Deepak', 20000.00, DATE '1989-12-25', DATE '2019-12-01', 1001, 'Ind_Kolkata');
INSERT INTO Person VALUES ('P008', 'Kavita', 14000.00, DATE '1993-04-08', DATE '2022-02-14', 1003, 'Ind_Ahmedabad');
INSERT INTO Person VALUES ('P009', 'Rahul', 28000.00, DATE '1986-08-30', DATE '2016-11-22', 1002, 'Ind_Jaipur');
INSERT INTO Person VALUES ('P010', 'Pooja', 19000.00, DATE '1990-10-22', DATE '2020-10-15', 1004, 'Ind_Lucknow');
INSERT INTO Person VALUES ('P011', 'Vikash', 13000.00, DATE '1994-02-14', DATE '2022-06-18', 1003, 'Ind_Bhopal');
INSERT INTO Person VALUES ('P012', 'Pallavi', 21000.00, DATE '1988-05-03', DATE '2018-09-07', 1001, 'Ind_Indore');

-- Commit the data
COMMIT;

-- 3. SHOW RESULTS (Display all tables data)
-- ==========================================

SELECT * FROM Project ORDER BY PROJECT_NO;
SELECT * FROM Person ORDER BY PERSON_NO;

-- 4. REQUIRED SQL QUERIES
-- =======================

-- Query i: Find the number of employees in each project with project name
SELECT pr.PROJECT_NAME, COUNT(p.PERSON_NO) AS NUM_EMPLOYEES
FROM Project pr
LEFT JOIN Person p ON pr.PROJECT_NO = p.P_NO
GROUP BY pr.PROJECT_NO, pr.PROJECT_NAME
ORDER BY pr.PROJECT_NO;

-- Query ii: Find the employee who earns highest salary in each project
SELECT pr.PROJECT_NAME, p.PERSON_NAME, p.SALARY
FROM Person p
JOIN Project pr ON p.P_NO = pr.PROJECT_NO
WHERE p.SALARY = (
    SELECT MAX(p2.SALARY)
    FROM Person p2
    WHERE p2.P_NO = p.P_NO
)
ORDER BY pr.PROJECT_NO;

-- Query iii: Find the employee whose name begins with 'P' and ends with 'r'
SELECT *
FROM Person
WHERE PERSON_NAME LIKE 'P%r';

-- Query iv: Name of the employee whose joining month & birth month are same
SELECT PERSON_NAME, BIRTH_DATE, JOIN_DATE
FROM Person
WHERE EXTRACT(MONTH FROM BIRTH_DATE) = EXTRACT(MONTH FROM JOIN_DATE);

-- Query v: List the employee with three hash('#') padded before and after
SELECT CONCAT('###', CONCAT(PERSON_NAME, '###')) AS PADDED_NAME
FROM Person;

-- Query vi: List the names of the employees, who earn lowest salary
SELECT PERSON_NAME, SALARY
FROM Person
WHERE SALARY = (SELECT MIN(SALARY) FROM Person);