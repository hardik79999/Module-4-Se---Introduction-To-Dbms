------------------------------------------------------------
-- 1. Introduction to SQL
------------------------------------------------------------
-- Lab 1: Create database and students table
CREATE DATABASE school_db;
USE school_db;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    age INT,
    class VARCHAR(20),
    address VARCHAR(100)
);

-- Lab 2: Insert records & SELECT
INSERT INTO students VALUES
(1, 'Rohan', 9, '4th', 'Delhi'),
(2, 'Priya', 12, '6th', 'Mumbai'),
(3, 'Amit', 11, '5th', 'Chennai'),
(4, 'Sneha', 10, '5th', 'Kolkata'),
(5, 'Karan', 13, '7th', 'Pune');

SELECT * FROM students;

------------------------------------------------------------
-- 2. SQL Syntax
------------------------------------------------------------
-- Lab 1: Retrieve specific columns
SELECT student_name, age FROM students;

-- Lab 2: Students age > 10
SELECT * FROM students WHERE age > 10;

------------------------------------------------------------
-- 3. SQL Constraints
------------------------------------------------------------
-- Lab 1: Create teachers table
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(50) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Lab 2: Add FOREIGN KEY
ALTER TABLE students
ADD teacher_id INT,
ADD CONSTRAINT fk_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);

------------------------------------------------------------
-- 4. DDL Commands
------------------------------------------------------------
-- Lab 1: Create courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    course_credits INT
);

-- Lab 2: Create university_db
CREATE DATABASE university_db;

------------------------------------------------------------
-- 5. ALTER Command
------------------------------------------------------------
-- Lab 1: Add course_duration
ALTER TABLE courses ADD course_duration VARCHAR(20);

-- Lab 2: Drop column course_credits
ALTER TABLE courses DROP COLUMN course_credits;
CREATE DATABASE school_db1;
USE school_db1;

CREATE TABLE students1 (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    age INT,
    class VARCHAR(20),
    address VARCHAR(100)
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(50) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

------------------------------------------------------------
-- 6. DROP Command
------------------------------------------------------------
-- Lab 1: Drop teachers table
DROP TABLE teachers;

-- Lab 2: Drop students table
DROP TABLE students1;
SELECT DATABASE();
USE school_db;
DESC courses;
------------------------------------------------------------
-- 7. DML
------------------------------------------------------------
-- Lab 1: Insert courses
INSERT INTO courses 
VALUES
(101, 'Math', '6 months'),
(102, 'Science', '4 months'),
(103, 'English', '3 months');

-- Lab 2: Update course duration
UPDATE courses SET course_duration = '5 months' WHERE course_id = 102;

-- Lab 3: Delete a course
DELETE FROM courses WHERE course_id = 103;

------------------------------------------------------------
-- 8. DQL
------------------------------------------------------------
-- Lab 1: Select all courses
SELECT * FROM courses;

-- Lab 2: Sort courses by duration
SELECT * FROM courses ORDER BY course_duration DESC;

-- Lab 3: Limit top 2
SELECT * FROM courses LIMIT 2;

------------------------------------------------------------
-- 9. DCL
------------------------------------------------------------
-- Lab 1: Create users & grant
DROP USER 'user1'@'localhost';
DROP USER 'user2'@'localhost';

CREATE USER 'user1'@'localhost' IDENTIFIED BY 'password1';
CREATE USER 'user2'@'localhost' IDENTIFIED BY 'password2';
GRANT SELECT ON school_db.courses TO 'user1'@'localhost';



-- Lab 2: Revoke & grant
REVOKE INSERT ON school_db.courses FROM 'user1'@'localhost';
GRANT INSERT ON school_db.courses TO 'user2'@'localhost';

------------------------------------------------------------
-- 10. TCL
------------------------------------------------------------
-- Lab 1: Insert & COMMIT
START TRANSACTION;
INSERT INTO courses VALUES (104, 'History', '8 months');
COMMIT;

-- Lab 2: Insert & ROLLBACK
START TRANSACTION;
INSERT INTO courses VALUES (105, 'Geography', '6 months');
ROLLBACK;

-- Lab 3: SAVEPOINT
START TRANSACTION;
SAVEPOINT before_update;
UPDATE courses SET course_duration = '9 months' WHERE course_id = 101;
ROLLBACK TO before_update;
COMMIT;
-- ------------------------------------------------------------
-- 11. Joins
-- ------------------------------------------------------------
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Lab 1: INNER JOIN
SELECT employees.emp_name, departments.dept_name
FROM employees
INNER JOIN departments ON employees.dept_id = departments.dept_id;

-- Lab 2: LEFT JOIN
SELECT departments.dept_name, employees.emp_name
FROM departments
LEFT JOIN employees ON departments.dept_id = employees.dept_id;

-- ------------------------------------------------------------
-- 12. Group By
-- ------------------------------------------------------------
-- Lab 1: Count employees per dept
SELECT dept_id, COUNT(*) AS emp_count
FROM employees GROUP BY dept_id;

-- Lab 2: Avg salary per dept
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees GROUP BY dept_id;

-- ------------------------------------------------------------
-- 13. Stored Procedures
-- ------------------------------------------------------------
DELIMITER //
-- Lab 1: Procedure getEmployeesByDept
CREATE PROCEDURE getEmployeesByDept(IN d_id INT)
BEGIN
    SELECT * FROM employees WHERE dept_id = d_id;
END;
//

-- Lab 2: Procedure getCourseDetails
CREATE PROCEDURE getCourseDetails(IN c_id INT)
BEGIN
    SELECT * FROM courses WHERE course_id = c_id;
END;
//
DELIMITER ;

-- ------------------------------------------------------------
-- 14. Views
-- ------------------------------------------------------------
-- Lab 1: Create view
CREATE VIEW emp_dept_view AS
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Lab 2: Modify view
CREATE OR REPLACE VIEW emp_dept_view AS
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary >= 50000;

-- ------------------------------------------------------------
-- 15. Triggers
-- ------------------------------------------------------------
DELIMITER //
-- Lab 1: Trigger log new employee
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO emp_log VALUES (NEW.emp_id, NOW(), 'Inserted');
END;
//

-- Lab 2: Trigger update timestamp
CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.salary = NEW.salary;
END;
//
DELIMITER ;
-- ----------------------------------------------------------
-- 16. PL/SQL Blocks
-- ----------------------------------------------------------
-- Lab 1: Print total employees
-- (In MySQL we use SELECT instead of DBMS_OUTPUT)
SELECT COUNT(*) AS total_employees FROM employees;

-- Lab 2: Total sales from orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    amount DECIMAL(10,2)
);

SELECT SUM(amount) AS total_sales FROM orders;

-- ----------------------------------------------------------
-- 17. PL/SQL Control Structures
-- ----------------------------------------------------------

-- Lab 1: IF-THEN condition (check department of an employee)

DELIMITER //
CREATE PROCEDURE checkDept(IN e_id INT)
BEGIN
    DECLARE d_id INT;
    SELECT dept_id INTO d_id FROM employees WHERE emp_id = e_id;

    IF d_id = 1 THEN
        SELECT 'Employee is in HR Department' AS result;
    ELSEIF d_id = 2 THEN
        SELECT 'Employee is in Finance Department' AS result;
    ELSE
        SELECT 'Employee is in Other Department' AS result;
    END IF;
END;
//
DELIMITER ;


-- Lab 2: FOR LOOP (iterate employee records & show names)
DELIMITER //
CREATE PROCEDURE listEmpNames()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE e_name VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT emp_name FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    emp_loop: LOOP
        FETCH cur INTO e_name;
        IF done = 1 THEN
            LEAVE emp_loop;
        END IF;
        SELECT e_name AS employee_name;
    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;


-- ----------------------------------------------------------
-- 18. Cursors
-- ----------------------------------------------------------
DELIMITER //
-- Lab 1: Cursor employees
CREATE PROCEDURE listEmployees()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE e_name VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT emp_name FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO e_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT e_name;
    END LOOP;
    CLOSE cur;
END;
//

-- Lab 2: Cursor courses
CREATE PROCEDURE listCourses()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE c_name VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT course_name FROM courses;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO c_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT c_name;
    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;

-- ----------------------------------------------------------
-- 19. Rollback & Savepoint
-- ----------------------------------------------------------
-- Lab 1: Transaction with savepoint
START TRANSACTION;
INSERT INTO courses VALUES (201, 'Biology', '6 months');
SAVEPOINT s1;
INSERT INTO courses VALUES (202, 'Physics', '7 months');
ROLLBACK TO s1;
COMMIT;

-- Lab 2: Commit part & rollback
START TRANSACTION;
INSERT INTO courses VALUES (203, 'Chemistry', '8 months');
SAVEPOINT s2;
INSERT INTO courses VALUES (204, 'Computer', '9 months');
ROLLBACK TO s2;
COMMIT;