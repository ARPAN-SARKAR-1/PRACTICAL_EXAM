-- Question-7: Scientist Database Solution
-- Oracle SQL Syntax

-- Table Creation
CREATE TABLE RESEARCH (
    Unique_Research_No VARCHAR2(10) PRIMARY KEY,
    research_name VARCHAR2(10) UNIQUE,
    CONSTRAINT chk_research_code CHECK (Unique_Research_No LIKE 'Ind_%')
);

CREATE TABLE SCIENTIST (
    sc_code VARCHAR2(5) PRIMARY KEY,
    scientist_name VARCHAR2(15) NOT NULL,
    salary NUMBER(7,2),
    birth_date DATE,
    join_date DATE,
    research_code VARCHAR2(10),
    city VARCHAR2(15),
    CONSTRAINT chk_sc_code CHECK (sc_code LIKE 'SR%A' OR sc_code LIKE 'SR%B' OR sc_code LIKE 'SR%C'),
    CONSTRAINT chk_salary CHECK (salary BETWEEN 45000 AND 80000),
    CONSTRAINT chk_birth_date CHECK (birth_date <= DATE '1980-01-01'),
    CONSTRAINT chk_join_date CHECK (EXTRACT(YEAR FROM join_date) BETWEEN 2000 AND 2008),
    CONSTRAINT chk_city CHECK (city IN ('Salt Lake', 'Noida', 'Gurgaon', 'Chennai', 'Bengaluru', 'Pune')),
    CONSTRAINT fk_research FOREIGN KEY (research_code) REFERENCES RESEARCH(Unique_Research_No)
);

-- Data Insertion
-- Research records (5 records)
INSERT INTO RESEARCH VALUES ('Ind_001', 'AI_ML');
INSERT INTO RESEARCH VALUES ('Ind_002', 'DataSci');
INSERT INTO RESEARCH VALUES ('Ind_003', 'Robotics');
INSERT INTO RESEARCH VALUES ('Ind_004', 'Biotech');
INSERT INTO RESEARCH VALUES ('Ind_005', 'Nanotech');

-- Scientist records (10 records)
INSERT INTO SCIENTIST VALUES ('SR01A', 'Pradeep Kumar', 55000, DATE '1975-03-15', DATE '2005-03-20', 'Ind_001', 'Chennai');
INSERT INTO SCIENTIST VALUES ('SR02B', 'Anjali Sharma', 62000, DATE '1978-07-10', DATE '2003-07-15', 'Ind_002', 'Pune');
INSERT INTO SCIENTIST VALUES ('SR03C', 'Rajesh Singh', 48000, DATE '1979-11-22', DATE '2007-11-25', 'Ind_003', 'Noida');
INSERT INTO SCIENTIST VALUES ('SR04A', 'Meera Patel', 70000, DATE '1976-05-08', DATE '2002-05-12', 'Ind_004', 'Bengaluru');
INSERT INTO SCIENTIST VALUES ('SR05B', 'Vikram Joshi', 58000, DATE '1977-09-30', DATE '2006-09-25', 'Ind_005', 'Gurgaon');
INSERT INTO SCIENTIST VALUES ('SR06C', 'Pooja Reddy', 65000, DATE '1974-12-18', DATE '2004-12-20', 'Ind_001', 'Chennai');
INSERT INTO SCIENTIST VALUES ('SR07A', 'Arjun Nair', 52000, DATE '1980-01-01', DATE '2008-01-05', 'Ind_002', 'Salt Lake');
INSERT INTO SCIENTIST VALUES ('SR08B', 'Deepika Roy', 60000, DATE '1978-04-25', DATE '2005-04-28', 'Ind_003', 'Pune');
INSERT INTO SCIENTIST VALUES ('SR09C', 'Suresh Gupta', 45000, DATE '1979-08-14', DATE '2007-08-16', 'Ind_004', 'Noida');
INSERT INTO SCIENTIST VALUES ('SR10A', 'Priya Agarwal', 75000, DATE '1975-02-28', DATE '2001-03-01', 'Ind_005', 'Bengaluru');

-- Queries

-- 1. Find the date when recruitment was closed
SELECT MAX(join_date) as Recruitment_Closed_Date
FROM SCIENTIST;

-- 2. Find the number of months of their tenure of service and display the same in number of days
SELECT scientist_name, 
       MONTHS_BETWEEN(SYSDATE, join_date) as Tenure_Months,
       TRUNC(MONTHS_BETWEEN(SYSDATE, join_date) * 30.44) as Tenure_Days
FROM SCIENTIST;

-- 3. Find the scientist whose name begins with 'P' and has at least 5 letters
SELECT scientist_name
FROM SCIENTIST
WHERE scientist_name LIKE 'P%' AND LENGTH(scientist_name) >= 5;

-- 4. Name of the scientists whose joining month & birth month are same
SELECT scientist_name
FROM SCIENTIST
WHERE EXTRACT(MONTH FROM join_date) = EXTRACT(MONTH FROM birth_date);

-- 5. Select 4th to 7th letter of scientist name and their full name in two columns
SELECT SUBSTR(scientist_name, 4, 4) as Letters_4_to_7, scientist_name as Full_Name
FROM SCIENTIST;

-- 6. Find the age of youngest scientist for each research level
SELECT research_code, MIN(TRUNC((SYSDATE - birth_date)/365.25)) as Youngest_Age
FROM SCIENTIST
GROUP BY research_code;

-- 7. Find the day of week of their joining date
SELECT scientist_name, TO_CHAR(join_date, 'DAY') as Join_Day_Of_Week
FROM SCIENTIST;

-- 8. Find the date of next Wednesday after their joining
SELECT scientist_name, join_date,
       NEXT_DAY(join_date, 'WEDNESDAY') as Next_Wednesday
FROM SCIENTIST;