CREATE DATABASE StudentTracker;
USE StudentTracker;

-- 1. Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);

-- 2. Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender ENUM('Male','Female','Other'),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address TEXT,
    admission_date DATE,
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES Departments(department_id)
);

-- 3. Faculty
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    department_id INT,
    experience_years INT DEFAULT 0,
    FOREIGN KEY (department_id)
    REFERENCES Departments(department_id)
);

-- 4. Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    faculty_id INT,
    FOREIGN KEY (faculty_id)
    REFERENCES Faculty(faculty_id)
);

-- 5. Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id)
    REFERENCES Students(student_id),
    FOREIGN KEY (course_id)
    REFERENCES Courses(course_id)
);

-- 6. Attendance
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    attendance_date DATE,
    status ENUM('Present','Absent','Late'),
    FOREIGN KEY (student_id)
    REFERENCES Students(student_id),
    FOREIGN KEY (course_id)
    REFERENCES Courses(course_id)
);

-- 7. Grades
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    marks_obtained DECIMAL(5,2),
    grade VARCHAR(5),
    FOREIGN KEY (student_id)
    REFERENCES Students(student_id),
    FOREIGN KEY (course_id)
    REFERENCES Courses(course_id)
);

-- Insert Student
INSERT INTO Students
(name,dob,gender,email,phone_number,address,admission_date,department_id)
VALUES
('Khushi Kaneriya','2007-07-03','Female',
'khushikaneriya712@gmail.com','9510917026',
'Rajkot','2024-06-01',1);

-- Update Student
UPDATE Students
SET phone_number='9999999999'
WHERE student_id=1;

-- Delete Student
DELETE FROM Students
WHERE student_id=1;

-- Students in Computer Science Department
SELECT s.*
FROM Students s
JOIN Departments d
ON s.department_id=d.department_id
WHERE d.department_name='Computer Science';

-- Top 10 Students
SELECT *
FROM Grades
ORDER BY marks_obtained DESC
LIMIT 10;

-- Attendance Below 75%
SELECT student_id,
ROUND(
SUM(status='Present')*100/COUNT(*),2
) AS attendance_percentage
FROM Attendance
GROUP BY student_id
HAVING attendance_percentage < 75;

-- Attendance below 50% AND failing
SELECT g.student_id
FROM Grades g
JOIN (
    SELECT student_id,
    SUM(status='Present')*100/COUNT(*) AS attendance_percentage
    FROM Attendance
    GROUP BY student_id
) a
ON g.student_id=a.student_id
WHERE a.attendance_percentage < 50
AND g.marks_obtained < 40;

-- Marks above 90 OR perfect attendance
SELECT DISTINCT student_id
FROM Grades
WHERE marks_obtained > 90
OR student_id IN (
    SELECT student_id
    FROM Attendance
    GROUP BY student_id
    HAVING SUM(status='Present')=COUNT(*)
);

-- Faculty not assigned any course
SELECT *
FROM Faculty
WHERE faculty_id NOT IN
(SELECT faculty_id FROM Courses WHERE faculty_id IS NOT NULL);

-- Students Alphabetically
SELECT *
FROM Students
ORDER BY name;

-- Students per Department
SELECT department_id, COUNT(*) total_students
FROM Students
GROUP BY department_id;

-- Average Marks per Course
SELECT course_id,
AVG(marks_obtained) avg_marks
FROM Grades
GROUP BY course_id;

-- Average Attendance
SELECT AVG(attendance_percentage)
FROM (
SELECT student_id,
SUM(status='Present')*100/COUNT(*) attendance_percentage
FROM Attendance
GROUP BY student_id
) t;

-- Highest & Lowest Marks
SELECT course_id,
MAX(marks_obtained) highest_marks,
MIN(marks_obtained) lowest_marks
FROM Grades
GROUP BY course_id;

-- Total Students per Department
SELECT department_id,
COUNT(*) total_students
FROM Students
GROUP BY department_id;

-- INNER JOIN
SELECT s.student_id,s.name,d.department_name
FROM Students s
INNER JOIN Departments d
ON s.department_id=d.department_id;

-- LEFT JOIN
SELECT s.*
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id=e.student_id
WHERE e.student_id IS NULL;

-- RIGHT JOIN
SELECT c.course_name,f.name
FROM Faculty f
RIGHT JOIN Courses c
ON f.faculty_id=c.faculty_id;

-- FULL OUTER JOIN (MySQL Alternative)
SELECT s.student_id,g.grade_id
FROM Students s
LEFT JOIN Grades g
ON s.student_id=g.student_id

UNION

SELECT s.student_id,g.grade_id
FROM Students s
RIGHT JOIN Grades g
ON s.student_id=g.student_id;

-- Above Average Marks
SELECT *
FROM Grades
WHERE marks_obtained >
(SELECT AVG(marks_obtained) FROM Grades);

-- Faculty with 5+ years experience
SELECT *
FROM Courses
WHERE faculty_id IN (
SELECT faculty_id
FROM Faculty
WHERE experience_years >= 5
);

-- Missed More Than 10 Classes
SELECT student_id
FROM Attendance
WHERE status='Absent'
GROUP BY student_id
HAVING COUNT(*) > 10;

SELECT MONTH(attendance_date) AS month_no
FROM Attendance;

SELECT student_id,
TIMESTAMPDIFF(YEAR,admission_date,CURDATE()) AS years_since_admission
FROM Students;

SELECT DATE_FORMAT(attendance_date,'%d-%m-%Y')
FROM Attendance;

SELECT UPPER(name) FROM Faculty;

SELECT TRIM(name) FROM Students;

SELECT IFNULL(email,'Email Not Provided')
FROM Students;

-- Rank Students
SELECT student_id,
marks_obtained,
RANK() OVER(ORDER BY marks_obtained DESC) AS student_rank
FROM Grades;

-- Running Total Enrollments
SELECT enrollment_date,
COUNT(*) AS total,
SUM(COUNT(*)) OVER(ORDER BY enrollment_date) AS running_total
FROM Enrollments
GROUP BY enrollment_date;

-- Performance Level
SELECT student_id,
marks_obtained,
CASE
    WHEN marks_obtained > 90 THEN 'Excellent'
    WHEN marks_obtained BETWEEN 75 AND 90 THEN 'Good'
    ELSE 'Needs Improvement'
END AS performance_level
FROM Grades;

-- Attendance Category
SELECT student_id,
attendance_percentage,
CASE
    WHEN attendance_percentage > 80 THEN 'Regular'
    WHEN attendance_percentage BETWEEN 50 AND 80 THEN 'Irregular'
    ELSE 'Defaulter'
END AS attendance_status
FROM (
    SELECT student_id,
    SUM(status='Present')*100/COUNT(*) attendance_percentage
    FROM Attendance
    GROUP BY student_id
) t;