-- Question-10: Sailors Database Solution
-- Oracle SQL Syntax

-- Table Creation
CREATE TABLE Sailors (
    S_ID VARCHAR2(10) PRIMARY KEY,
    S_NAME VARCHAR2(20),
    RATING NUMBER,
    AGE NUMBER(4,1)
);

CREATE TABLE Boats (
    BID NUMBER PRIMARY KEY,
    BNAME VARCHAR2(20),
    COLOR VARCHAR2(15)
);

CREATE TABLE Booking (
    S_ID VARCHAR2(10),
    B_ID NUMBER,
    DAY DATE,
    PRIMARY KEY (S_ID, B_ID, DAY),
    CONSTRAINT fk_sailor FOREIGN KEY (S_ID) REFERENCES Sailors(S_ID),
    CONSTRAINT fk_boat FOREIGN KEY (B_ID) REFERENCES Boats(BID)
);

-- Data Insertion
-- Sailors records
INSERT INTO Sailors VALUES ('s502', 'Lusber', 8, 55.5);
INSERT INTO Sailors VALUES ('s503', 'Andy', 8, 25.5);
INSERT INTO Sailors VALUES ('s504', 'Rusty', 10, 35);
INSERT INTO Sailors VALUES ('s505', 'Horatio', 7, 35);
INSERT INTO Sailors VALUES ('s506', 'Zorba', 10, 16);
INSERT INTO Sailors VALUES ('s507', 'Horatio', 9, 35.5);
INSERT INTO Sailors VALUES ('s508', 'Art', 3, 25.5);
INSERT INTO Sailors VALUES ('s509', 'Bob', 3, 63.5);

-- Boats records
INSERT INTO Boats VALUES (101, 'interlake', 'blue');
INSERT INTO Boats VALUES (102, 'interlake', 'red');
INSERT INTO Boats VALUES (103, 'clipper', 'green');
INSERT INTO Boats VALUES (104, 'marine', 'red');

-- Booking records
INSERT INTO Booking VALUES ('s502', 102, DATE '1998-10-11');
INSERT INTO Booking VALUES ('s502', 103, DATE '1998-10-11');
INSERT INTO Booking VALUES ('s505', 102, DATE '1998-08-09');
INSERT INTO Booking VALUES ('s505', 104, DATE '1998-10-11');
INSERT INTO Booking VALUES ('s506', 101, DATE '1998-11-10');
INSERT INTO Booking VALUES ('s506', 102, DATE '1998-08-10');
INSERT INTO Booking VALUES ('s507', 103, DATE '1998-07-09');

-- Queries

-- 1. Find the average age of sailors with rating of 10
SELECT AVG(AGE) as Average_Age
FROM Sailors
WHERE RATING = 10;

-- 2. Find all sailors with rating above 7
SELECT S_ID, S_NAME, RATING, AGE
FROM Sailors
WHERE RATING > 7;

-- 3. Find the names of sailors who have reserved boat 103
SELECT DISTINCT s.S_NAME
FROM Sailors s JOIN Booking b ON s.S_ID = b.S_ID
WHERE b.B_ID = 103;

-- 4. Find the names of sailors who have reserved red boat
SELECT DISTINCT s.S_NAME
FROM Sailors s 
JOIN Booking bk ON s.S_ID = bk.S_ID
JOIN Boats b ON bk.B_ID = b.BID
WHERE b.COLOR = 'red';

-- 5. Find sids of sailors who have reserved red boat or green boat
SELECT DISTINCT s.S_ID
FROM Sailors s 
JOIN Booking bk ON s.S_ID = bk.S_ID
JOIN Boats b ON bk.B_ID = b.BID
WHERE b.COLOR IN ('red', 'green');

-- 6. Find the colors of boats reserved by Horatio
SELECT DISTINCT b.COLOR
FROM Boats b
JOIN Booking bk ON b.BID = bk.B_ID
JOIN Sailors s ON bk.S_ID = s.S_ID
WHERE s.S_NAME = 'Horatio';

-- 7. Find sid and age of sailors who have reserved a boat in November
SELECT DISTINCT s.S_ID, s.AGE
FROM Sailors s
JOIN Booking b ON s.S_ID = b.S_ID
WHERE EXTRACT(MONTH FROM b.DAY) = 11;