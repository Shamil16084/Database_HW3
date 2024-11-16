 -- command for automatically  creates a table and populates it with the content

-- create a new course_book table in command line
CREATE TABLE Course_Book(
    CRN INTEGER,
    ISBN INTEGER,
    Title VARCHAR(255),
    Authors VARCHAR(255),
    Edition INTEGER,
    Publisher VARCHAR(100),
    Publisher_Address VARCHAR(255),
    Pages INTEGER,
    Year INTEGER,
    Course_Name VARCHAR(100),
    PRIMARY KEY (CRN, ISBN)
);

-- copy the values from csv file in my local computer
 \copy course_book(CRN, ISBN, Title, Authors, Edition, Publisher, Publisher_Address, Pages, Year, Course_Name) FROM 'C:/Users/TUF DASH/Desktop/table.csv' DELIMITER ';' CSV HEADER;

-- after this operations, we create Course_Book table and filled it with values from table.csv file
--1st normal form part
-- Drop the existing table
DROP TABLE IF EXISTS course_book_1NF;

--  Create a new 1NF table by splitting authors
CREATE TABLE course_book_1NF AS
SELECT 
    CRN,
    ISBN,
    Title,
    unnest(string_to_array(authors, ',')) AS author,  -- Splits authors and expands rows
    Edition,
    Publisher,
    Publisher_Address,
    Pages,
    Year,
    Course_Name
FROM 
    course_book;

--  Add a primary key
ALTER TABLE course_book_1NF
ADD PRIMARY KEY (CRN, ISBN, author);
--2nd normal form part
--  Drop existing tables 
DROP TABLE IF EXISTS Course_Textbook;
DROP TABLE IF EXISTS Textbook_Author;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Textbook;
DROP TABLE IF EXISTS Course;

--Create the Course table (specific to courses, dependent on CRN)
CREATE TABLE Course (
    CRN INTEGER PRIMARY KEY,
    Course_Name VARCHAR(100)
);

--  Create the Textbook table (specific to textbooks, dependent on ISBN)
CREATE TABLE Textbook (
    ISBN INTEGER PRIMARY KEY,
    Title VARCHAR(255),
    Edition INTEGER,
    Publisher VARCHAR(100),
    Publisher_Address VARCHAR(255),
    Pages INTEGER,
    Year INTEGER
);

--  Create the Author table (unique ones)
CREATE TABLE Author (
    Author_ID SERIAL PRIMARY KEY,
    Author_Name VARCHAR(100) UNIQUE
);

--  Create the Textbook_Author associative table linking based on ISBN and Author_ID

CREATE TABLE Textbook_Author (
    ISBN INTEGER REFERENCES Textbook(ISBN),
    Author_ID INTEGER REFERENCES Author(Author_ID),
    PRIMARY KEY (ISBN, Author_ID)
);

--  Create the Course_Textbook associative table

CREATE TABLE Course_Textbook (
    CRN INTEGER REFERENCES Course(CRN),
    ISBN INTEGER REFERENCES Textbook(ISBN),
    PRIMARY KEY (CRN, ISBN)
);

-- Insert data into the Course 
INSERT INTO Course (CRN, Course_Name)
SELECT DISTINCT CRN, Course_Name
FROM course_book_1NF;

-- Insert data into the Textbook table 
INSERT INTO Textbook (ISBN, Title, Edition, Publisher, Publisher_Address, Pages, Year)
SELECT DISTINCT ISBN, Title, Edition, Publisher, Publisher_Address, Pages, Year
FROM course_book_1NF;

-- Insert data into the Author 
INSERT INTO Author (Author_Name)
SELECT DISTINCT author
FROM course_book_1NF;

--  Insert data into the Textbook_Author
-- Joining 2 tables 
INSERT INTO Textbook_Author (ISBN, Author_ID)
SELECT DISTINCT cb.ISBN, a.Author_ID
FROM course_book_1NF cb
JOIN Author a ON cb.author = a.Author_Name;

--  Insert data into the Course_Textbook 
--  course-textbook association
INSERT INTO Course_Textbook (CRN, ISBN)
SELECT DISTINCT CRN, ISBN
FROM course_book_1NF;
--3rd normal form part
--  Drop the existing table
DROP TABLE IF EXISTS Publisher CASCADE;

--  Create the Publisher table with decomposed address fields
CREATE TABLE Publisher (
    Publisher_ID SERIAL PRIMARY KEY,
    Publisher_Name VARCHAR(100),
    Street_Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(20),
    Country VARCHAR(50)
);

--  Add Publisher_ID column to the Textbook table for referencing
ALTER TABLE Textbook
ADD COLUMN Publisher_ID INTEGER REFERENCES Publisher(Publisher_ID);

--  Insert unique publisher data into the Publisher 
INSERT INTO Publisher (Publisher_Name, Street_Address, City, State, Country)
SELECT DISTINCT 
    Publisher AS Publisher_Name,
    split_part(Publisher_Address, ',', 1) AS Street_Address,
    split_part(Publisher_Address, ',', 2) AS City,
    split_part(Publisher_Address, ',', 3) AS State,
    split_part(Publisher_Address, ',', 4) AS Country
FROM Textbook;

-- Update the Textbook table to reference Publisher_ID based on Publisher_Name
UPDATE Textbook
SET Publisher_ID = p.Publisher_ID
FROM Publisher p
WHERE Textbook.Publisher = p.Publisher_Name;

--  Drop Publisher and Publisher_Address columns from Textbook
ALTER TABLE Textbook
DROP COLUMN Publisher,
DROP COLUMN Publisher_Address;

DROP TABLE course_book;
DROP TABLE course_book_1nf;


