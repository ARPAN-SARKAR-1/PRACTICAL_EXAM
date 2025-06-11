-- EMPLOYEE-COMPANY DATABASE Question-3 - Oracle SQL Implementation
-- ================================================================

-- 1. TABLE CREATION
-- ================

-- Drop tables if they exist (for clean execution)
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Company CASCADE CONSTRAINTS;

-- Create COMPANY table (modified to allow companies in multiple cities)
CREATE TABLE Company (
    company_name VARCHAR2(50),
    city VARCHAR2(30),
    PRIMARY KEY (company_name, city)
);

-- Create EMPLOYEE table
CREATE TABLE Employee (
    person_name VARCHAR2(50) PRIMARY KEY,
    street VARCHAR2(50),
    city VARCHAR2(30),
    company_name VARCHAR2(50),
    salary NUMBER(10,2),
    manager_name VARCHAR2(50),
    FOREIGN KEY (manager_name) REFERENCES Employee(person_name)
);

-- 2. DATA INSERTION
-- ================

-- Insert 4+ records into COMPANY table (companies in multiple cities)
INSERT INTO Company VALUES ('First Bank Corporation', 'New York');
INSERT INTO Company VALUES ('First Bank Corporation', 'Boston');
INSERT INTO Company VALUES ('Small Bank Corporation', 'Boston');
INSERT INTO Company VALUES ('Small Bank Corporation', 'Chicago');
INSERT INTO Company VALUES ('Small Bank Corporation', 'Miami');
INSERT INTO Company VALUES ('Tech Solutions Inc', 'San Francisco');
INSERT INTO Company VALUES ('Global Finance Ltd', 'Chicago');

-- Insert 10+ records into EMPLOYEE table
-- Insert managers first (to satisfy foreign key constraints)
INSERT INTO Employee VALUES ('John Manager', '123 Wall St', 'New York', 'First Bank Corporation', 75000.00, NULL);
INSERT INTO Employee VALUES ('Sarah Boss', '456 State St', 'Boston', 'Small Bank Corporation', 65000.00, NULL);
INSERT INTO Employee VALUES ('Mike Director', '789 Market St', 'San Francisco', 'Tech Solutions Inc', 80000.00, NULL);
INSERT INTO Employee VALUES ('Lisa Chief', '321 Lake St', 'Chicago', 'Global Finance Ltd', 85000.00, NULL);

-- Insert regular employees including Jones
INSERT INTO Employee VALUES ('Jones', '234 Oak St', 'Springfield', 'First Bank Corporation', 45000.00, 'John Manager');
INSERT INTO Employee VALUES ('Alice Smith', '567 Wall St', 'New York', 'First Bank Corporation', 52000.00, 'John Manager');
INSERT INTO Employee VALUES ('Bob Johnson', '890 Broadway', 'Boston', 'First Bank Corporation', 48000.00, 'John Manager');
INSERT INTO Employee VALUES ('Carol Wilson', '432 Main St', 'Boston', 'Small Bank Corporation', 38000.00, 'Sarah Boss');
INSERT INTO Employee VALUES ('David Brown', '765 Oak Ave', 'Chicago', 'Small Bank Corporation', 41000.00, 'Sarah Boss');
INSERT INTO Employee VALUES ('Eve Davis', '198 Pine St', 'San Francisco', 'Tech Solutions Inc', 68000.00, 'Mike Director');
INSERT INTO Employee VALUES ('Frank Miller', '654 Elm St', 'Chicago', 'Global Finance Ltd', 72000.00, 'Lisa Chief');
INSERT INTO Employee VALUES ('Grace Lee', '987 Cedar Rd', 'Miami', 'Small Bank Corporation', 43000.00, 'Sarah Boss');

-- Commit the data
COMMIT;

-- 3. SHOW RESULTS (Display all tables data)
-- ==========================================

SELECT * FROM Company ORDER BY company_name, city;
SELECT * FROM Employee ORDER BY person_name;

-- 4. REQUIRED SQL QUERIES
-- =======================

-- Query a: Modify the database so that Jones now lives in Newtown
UPDATE Employee
SET city = 'Newtown'
WHERE person_name = 'Jones';
COMMIT;

-- Query b: Find all employees who earn more than the average salary of all employees of their company
SELECT e1.person_name, e1.company_name, e1.salary
FROM Employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.company_name = e1.company_name
);

-- Query c: Find the company that has the smallest payroll
SELECT company_name, total_payroll
FROM (
    SELECT company_name, SUM(salary) AS total_payroll
    FROM Employee
    GROUP BY company_name
    ORDER BY total_payroll ASC
)
WHERE ROWNUM = 1;

-- Query d: Give all employees of First Bank Corporation a 5 percent raise
UPDATE Employee
SET salary = salary * 1.05
WHERE company_name = 'First Bank Corporation';
COMMIT;

-- Query e: Find all companies located in every city in which Small Bank Corporation is located
SELECT DISTINCT c1.company_name
FROM Company c1
WHERE NOT EXISTS (
    SELECT c2.city
    FROM Company c2
    WHERE c2.company_name = 'Small Bank Corporation'
    AND c2.city NOT IN (
        SELECT c3.city
        FROM Company c3
        WHERE c3.company_name = c1.company_name
    )
)
AND c1.company_name != 'Small Bank Corporation';

-- Query f: Give all managers of First Bank Corporation a 10-percent raise unless the salary becomes greater than $100,000
UPDATE Employee
SET salary = CASE 
    WHEN salary * 1.10 <= 100000 THEN salary * 1.10
    ELSE salary
END
WHERE company_name = 'First Bank Corporation'
AND person_name IN (SELECT DISTINCT manager_name FROM Employee WHERE manager_name IS NOT NULL);
COMMIT;

-- Query g: Delete all tuples in the Employee table for employees of Small Bank Corporation
-- Note: Need to handle foreign key constraints by updating manager references first
UPDATE Employee
SET manager_name = NULL
WHERE manager_name IN (
    SELECT person_name
    FROM Employee
    WHERE company_name = 'Small Bank Corporation'
);

DELETE FROM Employee
WHERE company_name = 'Small Bank Corporation';
COMMIT;