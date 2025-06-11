-- Question-8: Catalog Database Solution
-- Oracle SQL Syntax

-- Table Creation
CREATE TABLE Author (
    author_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    city VARCHAR2(30),
    country VARCHAR2(30)
);

CREATE TABLE Publisher (
    pub_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    city VARCHAR2(30),
    country VARCHAR2(30)
);

CREATE TABLE Category (
    cat_id NUMBER PRIMARY KEY,
    description VARCHAR2(50)
);

CREATE TABLE Catalog (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(100),
    author_id NUMBER,
    pub_id NUMBER,
    year_of_publication NUMBER,
    cat_id NUMBER,
    price NUMBER(8,2),
    CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES Author(author_id),
    CONSTRAINT fk_publisher FOREIGN KEY (pub_id) REFERENCES Publisher(pub_id),
    CONSTRAINT fk_category FOREIGN KEY (cat_id) REFERENCES Category(cat_id)
);

-- Data Insertion
-- Author records (5 records)
INSERT INTO Author VALUES (1, 'John Doe', 'New York', 'USA');
INSERT INTO Author VALUES (2, 'Jane Smith', 'London', 'UK');
INSERT INTO Author VALUES (3, 'Bob Johnson', 'Toronto', 'Canada');
INSERT INTO Author VALUES (4, 'Alice Brown', 'Sydney', 'Australia');
INSERT INTO Author VALUES (5, 'Charlie Wilson', 'Berlin', 'Germany');

-- Publisher records (5 records)
INSERT INTO Publisher VALUES (1, 'McGraw-Hill', 'New York', 'USA');
INSERT INTO Publisher VALUES (2, 'Pearson', 'London', 'UK');
INSERT INTO Publisher VALUES (3, 'Wiley', 'Hoboken', 'USA');
INSERT INTO Publisher VALUES (4, 'Oxford Press', 'Oxford', 'UK');
INSERT INTO Publisher VALUES (5, 'Cambridge Press', 'Cambridge', 'UK');

-- Category records (5 records)
INSERT INTO Category VALUES (1, 'Computer Science');
INSERT INTO Category VALUES (2, 'Business');
INSERT INTO Category VALUES (3, 'Mathematics');
INSERT INTO Category VALUES (4, 'Physics');
INSERT INTO Category VALUES (5, 'Engineering');

-- Catalog records (5 records)
INSERT INTO Catalog VALUES (1, 'Database Systems', 1, 2, 1995, 1, 450.00);
INSERT INTO Catalog VALUES (2, 'Business Analytics', 2, 1, 1998, 2, 350.00);
INSERT INTO Catalog VALUES (3, 'Advanced Algorithms', 3, 3, 2000, 1, 500.00);
INSERT INTO Catalog VALUES (4, 'Marketing Management', 4, 4, 1996, 2, 300.00);
INSERT INTO Catalog VALUES (5, 'Computer Networks', 5, 5, 1999, 1, 400.00);

-- Additional records for better query results
INSERT INTO Catalog VALUES (6, 'Linear Algebra', 1, 2, 2001, 3, 250.00);
INSERT INTO Catalog VALUES (7, 'Quantum Physics', 2, 3, 1994, 4, 600.00);
INSERT INTO Catalog VALUES (8, 'Software Engineering', 3, 1, 1993, 1, 380.00);

-- Queries

-- a. Give the name of books whose price is greater than maximum of category average
SELECT title
FROM Catalog
WHERE price > (
    SELECT MAX(avg_price)
    FROM (
        SELECT AVG(price) as avg_price
        FROM Catalog
        GROUP BY cat_id
    )
);

-- b. Get publisher name, average, maximum and minimum price of book of all publishers other than McGraw-Hill
SELECT p.name as Publisher_Name,
       AVG(c.price) as Average_Price,
       MAX(c.price) as Maximum_Price,
       MIN(c.price) as Minimum_Price
FROM Publisher p JOIN Catalog c ON p.pub_id = c.pub_id
WHERE p.name != 'McGraw-Hill'
GROUP BY p.name;

-- c. Get the title, price of all books whose prices are greater than the average price of the book in business category
SELECT title, price
FROM Catalog
WHERE price > (
    SELECT AVG(price)
    FROM Catalog c JOIN Category cat ON c.cat_id = cat.cat_id
    WHERE cat.description = 'Business'
);

-- d. Increase the price of all books which are published before 1997 by 20%
UPDATE Catalog
SET price = price * 1.20
WHERE year_of_publication < 1997;

-- e. Give the title, author's name, publisher's name, year of publication, price of all computer books
SELECT c.title, a.name as Author_Name, p.name as Publisher_Name, 
       c.year_of_publication, c.price
FROM Catalog c 
JOIN Author a ON c.author_id = a.author_id
JOIN Publisher p ON c.pub_id = p.pub_id
JOIN Category cat ON c.cat_id = cat.cat_id
WHERE cat.description = 'Computer Science';

-- f. Give all author's name whose books are published on month of July
-- Note: Since we don't have exact publication dates, this query assumes publication year
-- In real scenario, we would need a publication_date column
SELECT DISTINCT a.name
FROM Author a JOIN Catalog c ON a.author_id = c.author_id
WHERE EXTRACT(MONTH FROM TO_DATE(c.year_of_publication || '-07-01', 'YYYY-MM-DD')) = 7;

-- Alternative interpretation: If we had actual publication dates
-- SELECT DISTINCT a.name
-- FROM Author a JOIN Catalog c ON a.author_id = c.author_id
-- WHERE EXTRACT(MONTH FROM c.publication_date) = 7;