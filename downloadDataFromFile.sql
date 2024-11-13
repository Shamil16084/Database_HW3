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