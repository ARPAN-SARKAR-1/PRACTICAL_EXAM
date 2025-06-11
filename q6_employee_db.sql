-- Question-6: Employee Database Solution
-- Oracle SQL Syntax

-- Table Creation
CREATE TABLE DEPARTMENT (
    Dept_Name VARCHAR2(30),
    Dept_Num NUMBER PRIMARY KEY,
    MGR_SSN NUMBER
);

CREATE TABLE EMPLOYEE (
    EName VARCHAR2(30),
    SSN_No NUMBER PRIMARY KEY,
    DoB DATE,
    City VARCHAR2(30),
    Sex CHAR(1),
    Salary NUMBER(10,2),
    Manager_SSN NUMBER,
    Dept_No NUMBER,
    CONSTRAINT fk_dept FOREIGN KEY (Dept_No) REFERENCES DEPARTMENT(Dept_Num)
);

CREATE TABLE WORKS_ON (
    SSN_Num NUMBER,
    Project NUMBER,
    Hours NUMBER,
    PRIMARY KEY (SSN_Num, Project),
    CONSTRAINT fk_emp FOREIGN KEY (SSN_Num) REFERENCES EMPLOYEE(SSN_No)
);

-- Data Insertion
-- Department records (5 records)
INSERT INTO DEPARTMENT VALUES ('Research', 1, 12345);
INSERT INTO DEPARTMENT VALUES ('Marketing', 2, 23456);
INSERT INTO DEPARTMENT VALUES ('Finance', 3, 34567);
INSERT INTO DEPARTMENT VALUES ('IT', 4, 45678);
INSERT INTO DEPARTMENT VALUES ('HR', 5, 56789);

-- Employee records (8 records)
INSERT INTO EMPLOYEE VALUES ('John Smith', 45978, DATE '1985-01-15', 'New York', 'M', 55000, NULL, 1);
INSERT INTO EMPLOYEE VALUES ('Alice Johnson', 12345, DATE '1980-03-20', 'Boston', 'F', 75000, NULL, 1);
INSERT INTO EMPLOYEE VALUES ('Bob Wilson', 23456, DATE '1982-07-10', 'Chicago', 'M', 65000, 12345, 2);
INSERT INTO EMPLOYEE VALUES ('Carol Davis', 34567, DATE '1979-11-25', 'Miami', 'F', 70000, 12345, 3);
INSERT INTO EMPLOYEE VALUES ('David Brown', 45678, DATE '1983-05-30', 'Seattle', 'M', 60000, 12345, 4);
INSERT INTO EMPLOYEE VALUES ('Eve Miller', 56789, DATE '1981-09-18', 'Denver', 'F', 55000, 34567, 5);
INSERT INTO EMPLOYEE VALUES ('Frank Taylor', 67890, DATE '1984-12-05', 'Atlanta', 'M', 45000, 45678, 1);
INSERT INTO EMPLOYEE VALUES ('Grace Lee', 78901, DATE '1986-02-14', 'Portland', 'F', 50000, 23456, 2);

-- Works_On records (4 records)
INSERT INTO WORKS_ON VALUES (45978, 1, 20);
INSERT INTO WORKS_ON VALUES (45978, 2, 15);
INSERT INTO WORKS_ON VALUES (12345, 1, 25);
INSERT INTO WORKS_ON VALUES (23456, 3, 30);

-- Queries

-- a. Retrieve the social security numbers of all employees who work on project number 1, 2, or 3
SELECT SSN_Num
FROM WORKS_ON
WHERE Project IN (1, 2, 3);

-- b. Retrieve the names of all employees who do not have supervisors
SELECT EName
FROM EMPLOYEE
WHERE Manager_SSN IS NULL;

-- c. Retrieve the name and city of every employee who works for the 'Research' department
SELECT e.EName, e.City
FROM EMPLOYEE e JOIN DEPARTMENT d ON e.Dept_No = d.Dept_Num
WHERE d.Dept_Name = 'Research';

-- d. For each department, retrieve the department number, the number of employees in the department, and their average salary
SELECT d.Dept_Num, COUNT(e.SSN_No) as Num_Employees, AVG(e.Salary) as Avg_Salary
FROM DEPARTMENT d LEFT JOIN EMPLOYEE e ON d.Dept_Num = e.Dept_No
GROUP BY d.Dept_Num;

-- e. Select the social security numbers of all employees who work the same (project, hours) combination on some project that employee 'John Smith' (whose SSN =45978) works on
SELECT DISTINCT w1.SSN_Num
FROM WORKS_ON w1 JOIN WORKS_ON w2 ON w1.Project = w2.Project AND w1.Hours = w2.Hours
WHERE w2.SSN_Num = 45978 AND w1.SSN_Num != 45978;

-- f. List employees whose salary is greater than the salary of all the employees in department 5
SELECT EName, Salary
FROM EMPLOYEE
WHERE Salary > ALL (SELECT Salary FROM EMPLOYEE WHERE Dept_No = 5);

-- g. Show the system date-time in the format '22nd October TWO THOUSAND ONE:11:30 AM'
SELECT TO_CHAR(SYSDATE, 'DD"th" Month YYYY:HH:MI AM') as Formatted_DateTime
FROM DUAL;