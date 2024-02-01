create database school;
use school;
-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255)
);

-- Students table
CREATE TABLE Students (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    grade CHAR(1)
);

-- StudentScores table
CREATE TABLE StudentScores (
    id INT PRIMARY KEY,
    student_id INT,
    score INT
);

-- Grades table
CREATE TABLE Grades (
    student_id INT PRIMARY KEY,
    subject VARCHAR(50),
    score INT
);

-- LogEntries table
CREATE TABLE LogEntries (
    entry_id INT PRIMARY KEY,
    log_date DATE,
    description VARCHAR(255)
);

-- CourseScores table
CREATE TABLE CourseScores (
    student_id INT,
    course_code VARCHAR(10),
    score INT
);

-- Discount table
CREATE TABLE Discount (
    discount_id INT PRIMARY KEY,
    min_purchase_amount DECIMAL(10, 2),
    max_purchase_amount DECIMAL(10, 2),
    discount_percentage DECIMAL(4, 2)
);

-- StudentCredits table
CREATE TABLE StudentCredits (
    student_id INT PRIMARY KEY,
    balance INT
);


-- Insert records into Courses table
INSERT INTO Courses (course_id, course_name)
VALUES (1, 'Mathematics'), (2, 'History'), (3, 'Science');

-- Insert records into Students table
INSERT INTO Students (id, first_name, last_name, email, grade)
VALUES (1, 'John', 'Doe', 'john@example.com', 'A'),
       (2, 'Jane', 'Smith', 'jane@example.com', 'B'),
       (3, 'Michael', 'Johnson', 'michael@example.com', 'C');

-- Insert records into StudentScores table
INSERT INTO StudentScores (id, student_id, score)
VALUES (1, 1, 95), (2, 2, 85), (3, 3, 75);

-- Insert records into Grades table
INSERT INTO Grades (student_id, subject, score)
VALUES (1, 'Mathematics', 90), (2, 'History', 85), (3, 'Mathematics', 78);

-- Insert records into LogEntries table
INSERT INTO LogEntries (entry_id, log_date, description)
VALUES (1, '2023-01-01', 'Logged in'), (2, '2023-02-15', 'Performed action');

-- Insert records into CourseScores table
INSERT INTO CourseScores (student_id, course_code, score)
VALUES (1, 'MAT101', 92), (2, 'HIS101', 88), (3, 'SCI101', 79);

-- Insert records into Discount table
INSERT INTO Discount (discount_id, min_purchase_amount, max_purchase_amount, discount_percentage)
VALUES (1, 100, 199.99, 5), (2, 200, 499.99, 10), (3, 500, 999.99, 15);

-- Insert records into StudentCredits table
INSERT INTO StudentCredits (student_id, balance)
VALUES (1, 1000), (2, 1500), (3, 2000);


-- Question 1: Create a stored procedure named GetCourseCountGetCourseCount that calculates and returns the total number of courses in a Courses table.

Delimiter //
create procedure GetCourseCount()
Begin
select count(*) as "No_records" from courses;
end //
Delimiter ;

call GetCourseCount();

-- Question 2: Create the GetStudentFullName procedure to accept an additional input parameter middle_name and Display the full Name.
-- Format of Full Name : First_Name Middle_Name Last_Name.

Delimiter //
create procedure  GetStudentFullName(std_id int,middle_name varchar(50))
Begin
select concat(first_name,' ',middle_name,' ',last_name) as 'Full_Name' from students where id=std_id;
end //
Delimiter ;

call GetStudentFullName(3,'Kennedy');

-- Question 3: Create a stored procedure named GetTopStudents that accepts an input parameter count and returns the top N students
-- with the highest scores from a StudentScores table.

Delimiter //
create procedure  GetTopStudents(count int)
Begin
select * from studentscores order by score desc limit count;
end //
Delimiter ;

call GetTopStudents(2);

-- Question 4: Write a stored procedure named UpdateStudentEmail that takes a student's id and a new email as input parameters and updates 
-- the student's email in a Students table.

Delimiter //
create procedure UpdateStudentEmail(std_id int,new_email varchar(25))
Begin
update students set email=new_email where id=std_id;
end //
Delimiter ;

call UpdateStudentEmail(2,'jane@smith27@gmail.com');

select * from students;

-- Question 5: Create a stored procedure named CalculateAVG to avg score of Grades Table.

Delimiter //
create procedure CalculateAVG()
Begin
select avg(score) as "Average_Score" from grades;
end //
Delimiter ;

call CalculateAVG();

-- Question 6: Implement a stored procedure named DeleteOldRecords that deletes records older than one year from a LogEntries table.
-- Use the current date to determine the age of the records.

DELIMITER //
CREATE PROCEDURE DeleteOldRecords()
BEGIN
    DECLARE cutoff_date DATE;
    SET cutoff_date = DATE_SUB(NOW(), INTERVAL 1 YEAR);
    
    DELETE FROM LogEntries WHERE log_date < cutoff_date AND entry_id > 0;
END //
DELIMITER ;

call  DeleteOldRecords();

-- Question 7: Create a stored procedure named GetCourseStatistics that accepts a course code as input and returns 
-- the average, minimum, and maximum scores of students who took that course from a CourseScores table.

DELIMITER //
CREATE PROCEDURE GetCourseStatistics(course_code varchar(25))
BEGIN
  select avg(score) as 'avg_score',max(score) as 'max_score',min(score) as 'min_score' from coursescores where course_code=course_code;
END //
DELIMITER ;

call GetCourseStatistics('SCI101');

-- Question 8: Write a stored procedure named CalculateDiscount that takes a total purchase amount as an input and calculates a 
-- discount based on a discount table. Return the discounted amount.

DELIMITER //
CREATE PROCEDURE CalculateDiscount(IN total_purchase INT, OUT discount_amount DECIMAL(10, 2))
BEGIN
    DECLARE discount_perc DECIMAL(4, 2);
    SELECT discount_percentage INTO discount_perc FROM discount WHERE total_purchase >= min_purchase_amount AND total_purchase <= max_purchase_amount;
    SET discount_amount = total_purchase - (total_purchase * discount_perc / 100);
END //
DELIMITER ;

call CalculateDiscount(800,@discount_amount);

select @discount_amount;

-- Question 9: Implement a stored procedure named TransferCredits that transfers credits from one student's account to another. 
-- Accept both students' id and the number of credits to transfer as input parameters. 

Delimiter //
create procedure TransferCredits(id1 int,id2 int,credit int)
begin
declare from_student int;
declare to_student int;

select balance into from_student from studentcredits where student_id=id1;
select balance into to_student from studentcredits where student_id=id2;

if from_student>=credit then
update studentcredits set balance=balance-credit where student_id=id1;
update studentcredits set balance =balance + credit where student_id=id2;  
select 'Credits transferred successfully' AS result;
else
select 'Insufficient credits' AS result;
End if;
End //
Delimiter ;

call TransferCredits(2,3,200);

-- Question 10: Create a stored procedure named GenerateReport that generates a report by joining data from multiple tables. 
-- The procedure should accept relevant input parameters and return a result set. 

DELIMITER //
CREATE PROCEDURE GenerateDemographicReport(id int)
BEGIN
    SELECT s.first_name, s.last_name, s.email, s.grade, c.course_name,cs.score
    FROM Students s
    JOIN  coursescores cs ON s.id = cs.student_id
    JOIN Courses c ON cs.student_id = c.course_id
    WHERE s.id = id;
END //
DELIMITER ;

call GenerateDemographicReport(3);