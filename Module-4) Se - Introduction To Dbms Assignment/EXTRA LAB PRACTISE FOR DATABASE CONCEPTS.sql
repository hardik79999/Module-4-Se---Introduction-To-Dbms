-- 1. Introduction to SQL
-- Lab 3: Create database and books table

CREATE DATABASE library_db;
USE library_db;
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    publisher VARCHAR(255),
    year_of_publication INT,
    price DECIMAL(10,2)
);

INSERT INTO books (book_id, title, author, publisher, year_of_publication, price) VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', 1960, 12.99),
(2, '1984', 'George Orwell', 'Secker & Warburg', 1949, 10.50),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribner''s Sons', 1925, 11.25),
(4, 'Pride and Prejudice', 'Jane Austen', 'T. Egerton', 1813, 9.99),
(5, 'The Catcher in the Rye', 'J.D. Salinger', 'Little, Brown and Company', 1951, 13.75);

-- Lab 4: Create members table
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(255) NOT NULL,
    date_of_membership DATE,
    email VARCHAR(100)
);

INSERT INTO members (member_id, member_name, date_of_membership, email) VALUES
(1, 'John Smith', '2021-05-15', 'john.smith@email.com'),
(2, 'Sarah Johnson', '2022-01-20', 'sarah.j@email.com'),
(3, 'Mike Brown', '2023-03-10', 'mike.brown@email.com'),
(4, 'Emily Davis', '2021-11-05', 'emily.d@email.com'),
(5, 'David Wilson', '2022-08-30', 'david.wilson@email.com');

-- 2. SQL Syntax
-- Lab 3: Retrieve members who joined before 2022
SELECT * FROM members 
WHERE date_of_membership < '2022-01-01'
ORDER BY date_of_membership;

-- Lab 4: Display books by specific author sorted by year
SELECT title FROM books 
WHERE author = 'George Orwell'
ORDER BY year_of_publication DESC;

-- 3. SQL Constraints
-- Lab 3: Add CHECK constraint for price
ALTER TABLE books
ADD CONSTRAINT chk_price CHECK (price > 0);

-- Lab 4: Add UNIQUE constraint for email
ALTER TABLE members
ADD CONSTRAINT unq_email UNIQUE (email);

-- 4. Main SQL Commands and Sub-commands (DDL)
-- Lab 3: Create authors table
CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    country VARCHAR(100)
);

-- Lab 4: Create publishers table
CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(255),
    contact_number VARCHAR(20) UNIQUE,
    address TEXT
);

-- 5. ALTER Command
-- Lab 3: Add genre column and update values
ALTER TABLE books ADD COLUMN genre VARCHAR(100);

UPDATE books SET genre = 'Fiction' WHERE book_id = 1;
UPDATE books SET genre = 'Dystopian' WHERE book_id = 2;
UPDATE books SET genre = 'Classic' WHERE book_id = 3;
UPDATE books SET genre = 'Romance' WHERE book_id = 4;
UPDATE books SET genre = 'Coming-of-age' WHERE book_id = 5;

-- Lab 4: Modify email column length
ALTER TABLE members 
MODIFY COLUMN email VARCHAR(100);

-- 6. DROP Command
-- Lab 3: Drop publishers table
DESCRIBE publishers;
DROP TABLE publishers;

-- Lab 4: Backup and drop members table
CREATE TABLE members_backup AS SELECT * FROM members;
DROP TABLE members;

-- Restore members table from backup
CREATE TABLE members AS SELECT * FROM members_backup;
DROP TABLE members_backup;

-- 7. Data Manipulation Language (DML)
-- Lab 4: Insert authors and update one
INSERT INTO authors (author_id, first_name, last_name, country) VALUES
(1, 'Harper', 'Lee', 'USA'),
(2, 'George', 'Orwell', 'UK'),
(3, 'F. Scott', 'Fitzgerald', 'USA');

UPDATE authors SET last_name = 'Miller' WHERE author_id = 3;

-- Lab 5: Delete expensive books
DELETE FROM books WHERE price > 100;

-- 8. UPDATE Command
-- Lab 3: Update publication year
UPDATE books 
SET year_of_publication = 2020 
WHERE book_id = 1;

-- Lab 4: Increase price for older books
UPDATE books 
SET price = price * 1.10 
WHERE year_of_publication < 2015;

-- 9. DELETE Command
-- Lab 3: Remove old members
DELETE FROM members 
WHERE date_of_membership < '2020-01-01';

-- Lab 4: Delete books with NULL author
DELETE FROM books 
WHERE author IS NULL;

-- 10. Data Query Language (DQL)
-- Lab 4: Books in price range
SELECT * FROM books 
WHERE price BETWEEN 50 AND 100;

-- Lab 5: Top 3 books by author
SELECT * FROM books 
ORDER BY author ASC 
LIMIT 3;

-- 11. Data Control Language (DCL)
-- Lab 3: Grant SELECT to librarian
CREATE USER IF NOT EXISTS 'librarian'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON library_db.books TO 'librarian'@'localhost';

-- Lab 4: Grant INSERT and UPDATE to admin
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT INSERT, UPDATE ON library_db.members TO 'admin'@'localhost';

-- 12. REVOKE Command
-- Lab 3: Revoke INSERT from librarian
REVOKE INSERT ON library_db.books FROM 'librarian'@'localhost';

-- Lab 4: Revoke all from admin
REVOKE ALL PRIVILEGES ON library_db.members FROM 'admin'@'localhost';

-- 13. Transaction Control Language (TCL)
-- Lab 3: COMMIT and ROLLBACK
START TRANSACTION;
INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
VALUES (6, 'Book1', 'Author1', 'Pub1', 2020, 20.00, 'Fiction');
INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
VALUES (7, 'Book2', 'Author2', 'Pub2', 2021, 25.00, 'Non-Fiction');
COMMIT;

START TRANSACTION;
INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
VALUES (8, 'Book3', 'Author3', 'Pub3', 2022, 30.00, 'Mystery');
ROLLBACK;

-- Lab 4: SAVEPOINT and ROLLBACK
START TRANSACTION;
SAVEPOINT before_update;
UPDATE members SET member_name = 'Test Name' WHERE member_id = 1;
ROLLBACK TO before_update;
COMMIT;

-- 14. SQL Joins
-- Lab 3: INNER JOIN books and authors
-- First, let's modify the books table to include author_id for proper joining
ALTER TABLE books ADD COLUMN author_id INT;
UPDATE books SET author_id = 1 WHERE author = 'Harper Lee';
UPDATE books SET author_id = 2 WHERE author = 'George Orwell';
UPDATE books SET author_id = 3 WHERE author = 'F. Scott Fitzgerald';

SELECT b.title, a.first_name, a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id;

-- Lab 4: FULL OUTER JOIN (MySQL doesn't support FULL OUTER JOIN directly)
SELECT b.title, a.first_name, a.last_name
FROM books b
LEFT JOIN authors a ON b.author_id = a.author_id
UNION
SELECT b.title, a.first_name, a.last_name
FROM books b
RIGHT JOIN authors a ON b.author_id = a.author_id;

-- 15. SQL Group By
-- Lab 3: Group books by genre
SELECT genre, COUNT(*) as total_books
FROM books
GROUP BY genre;

-- Lab 4: Group members by join year
SELECT YEAR(date_of_membership) as join_year, COUNT(*) as total_members
FROM members
GROUP BY YEAR(date_of_membership);

-- 16. SQL Stored Procedure
-- Lab 3: Stored procedure for books by author
DELIMITER //
CREATE PROCEDURE GetBooksByAuthor(IN author_name VARCHAR(255))
BEGIN
    SELECT * FROM books WHERE author = author_name;
END //
DELIMITER ;

-- Lab 4: Stored procedure for book price
DELIMITER //
CREATE PROCEDURE GetBookPrice(IN b_id INT)
BEGIN
    SELECT price FROM books WHERE book_id = b_id;
END //
DELIMITER ;

-- 17. SQL View
-- Lab 3: View for book details
CREATE VIEW book_details AS
SELECT title, author, price FROM books;

-- Lab 4: View for old members
CREATE VIEW old_members AS
SELECT * FROM members 
WHERE date_of_membership < '2020-01-01';

-- 18. SQL Trigger
-- Lab 3: Trigger for last_modified timestamp
ALTER TABLE books ADD COLUMN last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Lab 4: Trigger for delete logging
CREATE TABLE log_changes (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    action VARCHAR(50),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER book_delete_log
AFTER DELETE ON books
FOR EACH ROW
BEGIN
    INSERT INTO log_changes (book_id, action) VALUES (OLD.book_id, 'DELETE');
END //
DELIMITER ;

-- 19. Introduction to PL/SQL
-- Note: PL/SQL is Oracle's procedural language. For MySQL, we use stored procedures/functions
-- Lab 3: Insert book and show confirmation
DELIMITER //
CREATE PROCEDURE InsertBookWithConfirmation(
    IN b_id INT, 
    IN b_title VARCHAR(255), 
    IN b_author VARCHAR(255), 
    IN b_publisher VARCHAR(255), 
    IN b_year INT, 
    IN b_price DECIMAL(10,2), 
    IN b_genre VARCHAR(100)
)
BEGIN
    INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
    VALUES (b_id, b_title, b_author, b_publisher, b_year, b_price, b_genre);
    SELECT 'Book inserted successfully' AS Message;
END //
DELIMITER ;

-- Lab 4: Display total number of books
DELIMITER //
CREATE PROCEDURE GetTotalBooks()
BEGIN
    DECLARE total_count INT;
    SELECT COUNT(*) INTO total_count FROM books;
    SELECT CONCAT('Total books: ', total_count) AS Result;
END //
DELIMITER ;

-- 20. PL/SQL Syntax
-- Lab 3: Declare variables and display
DELIMITER //
CREATE PROCEDURE DisplayBookInfo()
BEGIN
    DECLARE v_book_id INT;
    DECLARE v_price DECIMAL(10,2);
    
    SET v_book_id = 1;
    SELECT price INTO v_price FROM books WHERE book_id = v_book_id;
    
    SELECT CONCAT('Book ID: ', v_book_id, ', Price: $', v_price) AS Book_Info;
END //
DELIMITER ;

-- Lab 4: Use constants and arithmetic
DELIMITER //
CREATE PROCEDURE CalculateDiscountedPrice()
BEGIN
    DECLARE discount DECIMAL(5,2) DEFAULT 0.10;
    DECLARE original_price DECIMAL(10,2);
    DECLARE discounted_price DECIMAL(10,2);
    
    SET original_price = 50.00;
    SET discounted_price = original_price * (1 - discount);
    
    SELECT CONCAT('Original: $', original_price, ', Discounted: $', discounted_price) AS Price_Calculation;
END //
DELIMITER ;

-- 21. PL/SQL Control Structures
-- Lab 3: IF-THEN-ELSE for price check
DELIMITER //
CREATE PROCEDURE CheckBookPrice(IN b_id INT)
BEGIN
    DECLARE book_price DECIMAL(10,2);
    
    SELECT price INTO book_price FROM books WHERE book_id = b_id;
    
    IF book_price > 100 THEN
        SELECT 'Expensive book' AS Message;
    ELSE
        SELECT 'Affordable book' AS Message;
    END IF;
END //
DELIMITER ;

-- Lab 4: FOR LOOP to display books (MySQL doesn't have FOR loop, using cursor instead)
DELIMITER //
CREATE PROCEDURE DisplayAllBooks()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_title VARCHAR(255);
    DECLARE v_author VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT title, author FROM books;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_title, v_author;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Title: ', v_title, ', Author: ', v_author) AS Book_Details;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- 22. SQL Cursors
-- Lab 3: Cursor for members table
DELIMITER //
CREATE PROCEDURE DisplayAllMembers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_member_id INT;
    DECLARE v_member_name VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT member_id, member_name FROM members;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_member_id, v_member_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('ID: ', v_member_id, ', Name: ', v_member_name) AS Member_Info;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- Lab 4: Cursor for books by author
DELIMITER //
CREATE PROCEDURE DisplayBooksByAuthor(IN author_name VARCHAR(255))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_title VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT title FROM books WHERE author = author_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_title;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT v_title AS Book_Title;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- 23. Rollback and Commit Savepoint
-- Lab 3: Transaction with SAVEPOINT
START TRANSACTION;
INSERT INTO members (member_id, member_name, date_of_membership, email) 
VALUES (6, 'New Member', '2023-12-01', 'new@email.com');
SAVEPOINT after_insert;
UPDATE members SET email = 'updated@email.com' WHERE member_id = 6;
ROLLBACK TO after_insert;
COMMIT;

-- Lab 4: COMMIT and ROLLBACK with SAVEPOINT
START TRANSACTION;
INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
VALUES (10, 'Book A', 'Author A', 'Pub A', 2023, 45.00, 'Fiction');
INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
VALUES (11, 'Book B', 'Author B', 'Pub B', 2023, 55.00, 'Non-Fiction');
SAVEPOINT after_two_inserts;
INSERT INTO books (book_id, title, author, publisher, year_of_publication, price, genre) 
VALUES (12, 'Book C', 'Author C', 'Pub C', 2023, 65.00, 'Mystery');
ROLLBACK TO after_two_inserts;
COMMIT;
