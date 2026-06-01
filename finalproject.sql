CREATE DATABASE UniversityDB;

USE UniversityDB;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Mathematics');

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Students VALUES
(1,'John','Doe','john.doe@email.com','2000-01-15','2022-08-01'),
(2,'Jane','Smith','jane.smith@email.com','1999-05-25','2021-08-01');

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);

INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),
(102,'Data Structures',2,4);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);

INSERT INTO Instructors VALUES
(1,'Alice','Johnson','alice.johnson@univ.com',1,80000),
(2,'Bob','Lee','bob.lee@univ.com',2,70000);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID)
    REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),
(2,2,102,'2021-08-01');



-- 1
-- students table 
-- INSERT
INSERT INTO Students
VALUES (3,'Rahul','Patel','rahul@gmail.com','2001-03-10','2023-08-01');

-- SELECT
SELECT * FROM Students;

-- UPDATE
UPDATE Students
SET Email='rahul123@gmail.com'
WHERE StudentID=3;

-- DELETE
DELETE FROM Students
WHERE StudentID=3;


-- courses
-- INSERT
INSERT INTO Courses
VALUES (103,'Python',1,3);

-- SELECT
SELECT * FROM Courses;

-- UPDATE
UPDATE Courses
SET Credits=4
WHERE CourseID=103;

-- DELETE
DELETE FROM Courses
WHERE CourseID=103;



-- instructors table
-- INSERT
INSERT INTO Instructors
VALUES (3,'Raj','Patel','raj@univ.com',1,75000);

-- SELECT
SELECT * FROM Instructors;

-- UPDATE
UPDATE Instructors
SET Salary=80000
WHERE InstructorID=3;

-- DELETE
DELETE FROM Instructors
WHERE InstructorID=3;



-- enrollments table
-- INSERT
INSERT INTO Enrollments
VALUES (3,1,102,'2023-08-01');

-- SELECT
SELECT * FROM Enrollments;

-- UPDATE
UPDATE Enrollments
SET CourseID=101
WHERE EnrollmentID=3;

-- DELETE
DELETE FROM Enrollments
WHERE EnrollmentID=3;



-- departments table
-- INSERT
INSERT INTO Departments
VALUES (3,'Commerce');

-- SELECT
SELECT * FROM Departments;

-- UPDATE
UPDATE Departments
SET DepartmentName='Business'
WHERE DepartmentID=3;

-- DELETE
DELETE FROM Departments
WHERE DepartmentID=3;



-- 2
SELECT *
FROM Students
WHERE EnrollmentDate > '2022-12-31';


-- 3
SELECT *
FROM Courses
WHERE DepartmentID=2
LIMIT 5;


-- 4
SELECT CourseID,
COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;


-- 5
SELECT StudentID
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(CourseID)=2;


-- 6
SELECT AVG(Credits)
AS AverageCredits
FROM Courses;


-- 7
SELECT MAX(Salary)
AS MaxSalary
FROM Instructors
WHERE DepartmentID=1;


-- 8
SELECT DepartmentID,
COUNT(*) AS TotalStudents
FROM Courses
GROUP BY DepartmentID;


-- 9
SELECT *
FROM Students s
INNER JOIN Enrollments e
ON s.StudentID=e.StudentID;


-- 10
SELECT *
FROM Students s
LEFT JOIN Enrollments e
ON s.StudentID=e.StudentID;


-- 11
SELECT *
FROM Students
WHERE StudentID IN
(
SELECT StudentID
FROM Enrollments
);


-- 12
SELECT StudentID,
YEAR(EnrollmentDate)
FROM Students;


-- 13
SELECT CONCAT(FirstName,' ',LastName)
AS FullName
FROM Instructors;


-- 14
SELECT CourseID,
COUNT(StudentID) AS TotalStudents,
SUM(COUNT(StudentID))
OVER(ORDER BY CourseID) AS RunningTotal
FROM Enrollments
GROUP BY CourseID;


-- 15
SELECT StudentID,
FirstName,
EnrollmentDate,
CASE
    WHEN YEAR(CURDATE()) - YEAR(EnrollmentDate) > 4
    THEN 'Senior'
    ELSE 'Junior'
END AS Status
FROM Students;