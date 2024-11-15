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
