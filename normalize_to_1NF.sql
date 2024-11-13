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
