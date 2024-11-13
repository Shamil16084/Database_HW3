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
