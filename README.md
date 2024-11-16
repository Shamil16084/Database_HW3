Readme

"# Database_HW3"

Written by Shamil Abbasov;<br/>

Note: If you do not have time to read all these and run the scripts seperately, go for the final.sql script which automates all the process. Basically, connect to the database where you want to perform normalization operation, and run final.sql script using \i 'final.sql', but pay attention the the location of the script and use **full path** everywhere as through going the process. The path of the files in my laptop can be diffrent than yours, therefore please pay attention the the **location of files** and again use **full path**. Have a nice read and codes ahead!

In this assignment, we are going to perform normalization operation in a given .XLSX file and do all these operations on PostgreSQL environment. <br/>

First, I create new database for this assignment using this command and connect to it:  CREATE DATABASE dbname; \c dbname;<br/>

After this connection, I am in the database where going to perform the following operations. <br/>

1) Populate the unnormalized table into the database;<br/>

I automate this operation with the help of \copy command in the PLSQL. Basically, I create new table for unnormalized data using this command:  CREATE TABLE Course_Book ->which store unnormalized data from table<br/>

Secondly, I convert .xlsx format into .csv format, since PLSQL gives error when working with this format. Conversion is simple.  After it, following command is entered to populate the table: <br/>

**\copy course_book(CRN, ISBN, Title, Authors, Edition, Publisher, Publisher_Address, Pages, Year, Course_Name) FROM 'C:/Users/TUF DASH/Desktop/table.csv' DELIMITER ';' CSV HEADER;**

This command do the following: <br/

The COPY command allows you to directly load data from a CSV or text file into a PostgreSQL table. I use the \copy, which is a client-side command and reads files directly from your local machine.

Delimiter specifies the ; used in the CSV file to separate values in each row. The CSV HEADER option tells PostgreSQL that the first row in the CSV file contains column headers (i.e., the names of the columns), rather than actual data and skip it.

After this operation, first table which is same with unnormalized .csv file is populated in the database

Conversion to 1st NF

I create the .sql script and run it for creating new table which is in the 1st normal form. It saves time, and instead of manual entering commands, scripts allow that a code that can be executed from a command line.  The script is used for this purpose: normalize_to_1NF.sql'

Explanation of the Script:

DROP TABLE IF EXISTS course_book_1NF;: Drops the course_book_1NF table if it already exists, allowing to re-run the script without errors.
CREATE TABLE course_book_1NF AS ...:
Selects all the necessary columns from course_book. I prefer to create for each normal form new table, but you can drop the previous table in the end and continue with the latest created tables.
unnest(string_to_array(authors, ',')) AS author: Splits the authors column by commas, expanding each author into a separate row with the same CRN and ISBN values. First, string_to_array(authors, ',') method is convert the authors values which is string into array, then unnest operation takes place on this array. This operation makes the author column atomic, contains only 1 value per row.
ALTER TABLE course_book_1NF ADD PRIMARY KEY (CRN, ISBN, author);:
Adds a composite primary key on (CRN, ISBN, author), ensuring each row is unique by these attributes.
To run the script use the following command in terminal: \i 'C:/Users/TUF Dash/Desktop/db_hw3/normalize_to_1NF.sql

In your case, make sure to locate the correct path of the script .In addition, sometimes PLSQL gives error, double check using / (backslash) or \\ (double-forward slash).

After this operation new table named course_book_1NF  should be created.

Converting to 2nd NF.

Again, I use the script here as well. Following command take place to run it:  \i  'C:/Users/TUF DASH/Desktop/db_hw3/normalize_to_2NF.sql'

This script does following operations:

·        Drop existing tables if they exist (for re-runs):

·        Create the following necessary tables: Course_Textbook; Textbook_Author; Author; Textbook; Course;

·        Course_Textbook  and Textbook_Author authors are associate tables and link 2 different tables, therefore I give the foreign key reference to the corresponding table and column.

·        Insert the necessary data into the tables. While inserting, to eliminate the duplicate insertion , usage is distinct keyword is preferred.

·        Insertion into the Textbook_Author is special. I use the join operation to populate tis table. Basically, the join condition specifies that cb.author (the author name in course_book_1NF) must match a.Author_Name (the name of the author in the Author table).

 

Converting to 3rd  NF.

Again, usage of script save time and efficiency:  \i  'C:/Users/TUF DASH/Desktop/db_hw3/normalize_to_3NF.sql'

This script do similar jobs to the previous script such as drop tables if exist, and create the Publisher table with decomposed address fields. Defines the Publisher table with Publisher_ID as the primary key and decomposed address fields.

Insertion takes place in the following way:

Automatically inserts unique publishers by selecting distinct Publisher names and decomposing Publisher_Address using split_part.
split_part(Publisher_Address, ',', N) extracts address components based on the structure. split_part function is used to extract a specific component (from a string, based on a specified delimiter which is “,” in this case. N is the index of the part extracted. I make the following structure:
N = 1: Street_Address
N = 2: City
N = 3: State
N = 4: Country
Then I update Textbook Table: each textbook entry to reference Publisher_ID from the Publisher table, based on matching Publisher_Name.

 

 

References:

https://www.w3resource.com/PostgreSQL/postgresql_unnest-function.php

https://learn.microsoft.com/ru-ru/azure/databricks/sql/language-manual/functions/split_part

 

 

 

 

 

 

 

 

 

 

 

 

 
