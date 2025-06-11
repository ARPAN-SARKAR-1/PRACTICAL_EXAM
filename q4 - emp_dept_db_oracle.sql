-- EMP-DEPT DATABASE - Oracle SQL Implementation
-- =============================================

-- 1. TABLE CREATION
-- ================

-- Drop tables if they exist (for clean execution)
DROP TABLE Emp CASCADE CONSTRAINTS;
DROP TABLE Dept CASCADE CONSTRAINTS;

-- Create DEPT table (referenced table must be created first)
CREATE TABLE Dept (
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13)
);

-- Create EMP table
CREATE TABLE Emp (
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10),
    JOB VARCHAR2(9),
    MGR NUMBER(4),
    HIREDATE DATE,
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2),
    FOREIGN KEY (DEPTNO) REFERENCES Dept(DEPTNO),
    FOREIGN KEY (MGR) REFERENCES Emp(EMPNO)
);

-- 2. DATA INSERTION
-- ================

-- Insert data into DEPT table
INSERT INTO Dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO Dept VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO Dept VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO Dept VALUES (40, 'OPERATIONS', 'BOSTON');

-- Insert data into EMP table (managers first to satisfy foreign key constraints)
INSERT INTO Emp VALUES (7839, 'KING', 'PRESIDENT', NULL, DATE '1981-11-17', 5000, NULL, 10);
INSERT INTO Emp VALUES (7566, 'JONES', 'MANAGER', 7839, DATE '1981-04-02', 2975, NULL, 20);
INSERT INTO Emp VALUES (7698, 'BLAKE', 'MANAGER', 7839, DATE '1981-05-01', 2850, NULL, 30);
INSERT INTO Emp VALUES (7782, 'CLARK', 'MANAGER', 7839, DATE '1981-06-09', 2450, NULL, 10);

-- Insert remaining employees
INSERT INTO Emp VALUES (7369, 'SMITH', 'CLERK', 7902, DATE '1980-12-17', 800, NULL, 20);
INSERT INTO Emp VALUES (7499, 'ALLEN', 'SALESMAN', 7698, DATE '1981-02-20', 1600, 300, 30);
INSERT INTO Emp VALUES (7521, 'WARD', 'SALESMAN', 7698, DATE '1981-02-22', 1250, 500, 30);
INSERT INTO Emp VALUES (7654, 'MARTIN', 'SALESMAN', 7698, DATE '1981-09-28', 1250, 1400, 30);
INSERT INTO Emp VALUES (7788, 'SCOTT', 'ANALYST', 7566, DATE '1987-04-19', 3000, NULL, 20);
INSERT INTO Emp VALUES (7844, 'TURNER', 'SALESMAN', 7698, DATE '1981-09-08', 1500, 0, 30);
INSERT INTO Emp VALUES (7902, 'FORD', 'ANALYST', 7566, DATE '1981-12-03', 3000, NULL, 20);

-- Commit the data
COMMIT;

-- 3. SHOW RESULTS (Display all tables data)
-- ==========================================

SELECT * FROM Dept ORDER BY DEPTNO;
SELECT * FROM Emp ORDER BY EMPNO;

-- 4. REQUIRED SQL QUERIES
-- =======================

-- Query i: List all the employees details who are getting commission
SELECT *
FROM Emp
WHERE COMM IS NOT NULL AND COMM > 0;

-- Query ii: List all the employees details who are getting no commission but the salary must be greater than 2000
SELECT *
FROM Emp
WHERE (COMM IS NULL OR COMM = 0) AND SAL > 2000;

-- Query iii: List all the employees details who does not reported anybody
SELECT *
FROM Emp
WHERE EMPNO NOT IN (SELECT DISTINCT MGR FROM Emp WHERE MGR IS NOT NULL);

-- Query iv: List all the location available in the dept table
SELECT LOC
FROM Dept;

-- Query v: List all the employees details according to their salary priority
SELECT *
FROM Emp
ORDER BY SAL DESC;

-- Query vi: List number of employees and total salary department wise
SELECT d.DEPTNO, d.DNAME, COUNT(e.EMPNO) AS NUM_EMPLOYEES, SUM(e.SAL) AS TOTAL_SALARY
FROM Dept d
LEFT JOIN Emp e ON d.DEPTNO = e.DEPTNO
GROUP BY d.DEPTNO, d.DNAME
ORDER BY d.DEPTNO;