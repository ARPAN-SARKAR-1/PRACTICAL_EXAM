-- Question-9: Student Database Solution
-- Oracle SQL Syntax

-- Table Creation
CREATE TABLE Stream (
    StreamID NUMBER PRIMARY KEY,
    Name VARCHAR2(30),
    Duration NUMBER,
    Fees NUMBER(8,2)
);

CREATE TABLE StudentMaster (
    Roll NUMBER PRIMARY KEY,
    Class VARCHAR2(10),
    Name VARCHAR2(30),
    Total_Marks NUMBER,
    StreamID NUMBER,
    CONSTRAINT fk_stream FOREIGN KEY (StreamID) REFERENCES Stream(StreamID)
);

-- Data Insertion
-- Stream records (4 records)
INSERT INTO Stream VALUES (1, 'Computer Science', 4, 45000);
INSERT INTO Stream VALUES (2, 'Mechanical Engineering', 4, 40000);
INSERT INTO Stream VALUES (3, 'Electronics', 3, 35000);
INSERT INTO Stream VALUES (4, 'Civil Engineering', 5, 50000);

-- StudentMaster records (10 records)
INSERT INTO StudentMaster VALUES (101, '10A', 'Rajesh', 850, 1);
INSERT INTO StudentMaster VALUES (102, '10B', 'Priyank', NULL, 2);
INSERT INTO StudentMaster VALUES (103, '10A', 'Sumeeta', 920, 1);
INSERT INTO StudentMaster VALUES (104, '10C', 'Michael', 780, 3);
INSERT INTO StudentMaster VALUES (105, '10B', 'Ananya', NULL, 4);
INSERT INTO StudentMaster VALUES (106, '10A', 'Vikrant', 890, 1);
INSERT INTO StudentMaster VALUES (107, '10C', 'Shabana', 750, 2);
INSERT INTO StudentMaster VALUES (108, '10B', 'Deepak', NULL, 3);
INSERT INTO StudentMaster VALUES (109, '10A', 'Ravi', 800, 4);
INSERT INTO StudentMaster VALUES (110, '10C', 'Meghana', 870, 1);

-- Queries

-- a. List those students who do not appear in the exam yet (i.e. Total Marks not applicable)
SELECT Roll, Name, Class
FROM StudentMaster
WHERE Total_Marks IS NULL;

-- b. Give student details that get highest marks stream wise
SELECT sm.Roll, sm.Name, sm.Class, sm.Total_Marks, sm.StreamID
FROM StudentMaster sm
WHERE sm.Total_Marks = (
    SELECT MAX(sm2.Total_Marks)
    FROM StudentMaster sm2
    WHERE sm2.StreamID = sm.StreamID
    AND sm2.Total_Marks IS NOT NULL
);

-- c. List student details who take admission in longest duration course
SELECT sm.Roll, sm.Name, sm.Class, sm.Total_Marks, s.Name as Stream_Name, s.Duration
FROM StudentMaster sm JOIN Stream s ON sm.StreamID = s.StreamID
WHERE s.Duration = (SELECT MAX(Duration) FROM Stream);

-- d. List details of each student who gets more than the average marks in stream
SELECT sm.Roll, sm.Name, sm.Class, sm.Total_Marks, sm.StreamID
FROM StudentMaster sm
WHERE sm.Total_Marks > (
    SELECT AVG(sm2.Total_Marks)
    FROM StudentMaster sm2
    WHERE sm2.StreamID = sm.StreamID
    AND sm2.Total_Marks IS NOT NULL
);

-- e. List student whose name contains seven letters and fees between 30000 and 60000
SELECT sm.Roll, sm.Name, sm.Class, s.Fees
FROM StudentMaster sm JOIN Stream s ON sm.StreamID = s.StreamID
WHERE LENGTH(sm.Name) = 7 AND s.Fees BETWEEN 30000 AND 60000;

-- f. List those students whose middle letter and first letter same
SELECT Roll, Name, Class
FROM StudentMaster
WHERE LENGTH(Name) > 2 
AND SUBSTR(Name, 1, 1) = SUBSTR(Name, CEIL(LENGTH(Name)/2), 1);

-- g. Create a view for stream which contains stream id, stream name, duration, fees and number of students
CREATE VIEW StreamView AS
SELECT s.StreamID, s.Name as Stream_Name, s.Duration, s.Fees,
       COUNT(sm.Roll) as Number_of_Students
FROM Stream s LEFT JOIN StudentMaster sm ON s.StreamID = sm.StreamID
GROUP BY s.StreamID, s.Name, s.Duration, s.Fees;

-- To view the created view
SELECT * FROM StreamView;