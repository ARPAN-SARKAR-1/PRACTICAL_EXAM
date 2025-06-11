-- EMPLOYEE-COMPANY DATABASE - Oracle SQL Implementation
-- =====================================================

-- 1. TABLE CREATION
-- ================

-- Drop tables if they exist (for clean execution)
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Company CASCADE CONSTRAINTS;

-- Create COMPANY table (referenced table must be created first)
CREATE TABLE Company (
    company_name VARCHAR2(50) PRIMARY KEY,
    city VARCHAR2(30) NOT NULL
);

-- Create EMPLOYEE table
CREATE TABLE Employee (
    person_name VARCHAR2(50) PRIMARY KEY,
    street VARCHAR2(50),
    city VARCHAR2(30),
    company_name VARCHAR2(50),
    salary NUMBER(10,2),
    manager_name VARCHAR2(50),
    FOREIGN KEY (company_name) REFERENCES Company(company_name),
    FOREIGN KEY (manager_name) REFERENCES Employee(person_name)
);

-- 2. DATA INSERTION
-- ================

-- Insert 4 records into COMPANY table
INSERT INTO Company VALUES ('First Bank Corporation', 'New York');
INSERT INTO Company VALUES ('Small Bank Corporation', 'Boston');
INSERT INTO Company VALUES ('Tech Solutions Inc', 'San Francisco');
INSERT INTO Company VALUES ('Global Finance Ltd', 'Chicago');

-- Insert 10 records into EMPLOYEE table
-- Insert managers first (to satisfy foreign key constraints)
INSERT INTO Employee VALUES ('John Manager', '123 Wall St', 'New York', 'First Bank Corporation', 75000.00, NULL);
INSERT INTO Employee VALUES ('Sarah Boss', '456 State St', 'Boston', 'Small Bank Corporation', 65000.00, NULL);
INSERT INTO Employee VALUES ('Mike Director', '789 Market St', 'San Francisco', 'Tech Solutions Inc', 80000.00, NULL);
INSERT INTO Employee VALUES ('Lisa Chief', '321 Lake St', 'Chicago', 'Global Finance Ltd', 85000.00, NULL);

-- Insert regular employees
INSERT INTO Employee VALUES ('Alice Smith', '234 Wall St', 'New York', 'First Bank Corporation', 45000.00, 'John Manager');
INSERT INTO Employee VALUES ('Bob Johnson', '567 Broadway', 'New York', 'First Bank Corporation', 52000.00, 'John Manager');
INSERT INTO Employee VALUES ('Carol Wilson', '890 Main St', 'Boston', 'Small Bank Corporation', 38000.00, 'Sarah Boss');
INSERT INTO Employee VALUES ('David Brown', '432 Oak Ave', 'Boston', 'Small Bank Corporation', 41000.00, 'Sarah Boss');
INSERT INTO Employee VALUES ('Eve Davis', '765 Pine St', 'San Francisco', 'Tech Solutions Inc', 68000.00, 'Mike Director');
INSERT INTO Employee VALUES ('Frank Miller', '198 Elm St', 'Chicago', 'Global Finance Ltd', 72000.00, 'Lisa Chief');

-- Commit the data
COMMIT;

-- 3. SHOW RESULTS (Display all tables data)
-- ==========================================

SELECT * FROM Company;
SELECT * FROM Employee;

-- 4. REQUIRED SQL QUERIES
-- =======================

-- Query a: Find all employees in the database who do not work for First Bank Corporation
SELECT *
FROM Employee
WHERE company_name != 'First Bank Corporation';

-- Query b: Give all managers of First Bank Corporation a 10 percent raise
UPDATE Employee
SET salary = salary * 1.10
WHERE company_name = 'First Bank Corporation'
AND person_name IN (SELECT DISTINCT manager_name FROM Employee WHERE manager_name IS NOT NULL);
COMMIT;

-- Query c: Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000
SELECT person_name, street, city
FROM Employee
WHERE company_name = 'First Bank Corporation'
AND salary > 10000;

-- Query d: Find all employees in the database who live in the same cities as the companies for which they work
SELECT e.person_name, e.city, e.company_name
FROM Employee e
JOIN Company c ON e.company_name = c.company_name
WHERE e.city = c.city;

-- Query e: Find all employees in the database who live in the same cities and on the same streets as do their managers
SELECT e.person_name, e.street, e.city, e.manager_name
FROM Employee e
JOIN Employee m ON e.manager_name = m.person_name
WHERE e.city = m.city
AND e.street = m.street;

-- Query f: Define a view consisting of manager-name and the average salary of all employees who work for that manager
CREATE VIEW ManagerAvgSalary AS
SELECT manager_name, AVG(salary) AS average_salary
FROM Employee
WHERE manager_name IS NOT NULL
GROUP BY manager_name;

-- Display the view
SELECT * FROM ManagerAvgSalary;

-- Query g: Find all employees in the database who earn more than each employee of Small Bank Corporation
SELECT *
FROM Employee
WHERE salary > ALL (
    SELECT salary
    FROM Employee
    WHERE company_name = 'Small Bank Corporation'
);