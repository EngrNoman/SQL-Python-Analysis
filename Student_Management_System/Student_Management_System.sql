-- Schema Design 

CREATE TABLE student(
	student_id INT IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) UNIQUE NOT NULL,
	phone VARCHAR(15),
	date_of_birth DATE,
	created_at DATETIME2 DEFAULT GETDATE()
);

ALTER TABLE student
ALTER COLUMN phone VARCHAR(50);

CREATE TABLE course(
course_id INT IDENTITY(1,1) PRIMARY KEY,
course_name  VARCHAR(100) NOT NULL,
course_code VARCHAR(20) UNIQUE NOT NULL,
credits INT CHECK (credits BETWEEN 1 AND 5),
created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE entrollments(
enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
student_id INT REFERENCES student(student_id) ON DELETE CASCADE,
course_id INT REFERENCES course(course_id) ON DELETE CASCADE,
entrollment_date DATETIME2 DEFAULT GETDATE(),
grade CHAR(2) CHECK(grade IN('A' , 'B' , 'C', 'D' ,'F' ,NULL)),
UNIQUE(student_id , course_id)
);


-- Insert sample students
INSERT INTO student (first_name, last_name, email, phone, date_of_birth)
VALUES 
('Alice', 'Johnson', 'alice@email.com', '1234567890', '2000-06-15'),
('Bob', 'Smith', 'bob@email.com', '0987654321', '1999-09-22');

-- Insert sample courses
INSERT INTO course (course_name, course_code, credits)
VALUES 
('Database Systems', 'DB101', 3),
('Data Structures', 'DS102', 4);

-- Enroll students in courses
INSERT INTO entrollments (student_id, course_id, grade)
VALUES 
(6, 2, 'B'); 


SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM entrollment;


-- Get all students and their enrollments:
SELECT s.student_id ,s.first_name , s.last_name , c.course_name ,e.grade
FROM student s
JOIN entrollment  e
ON s.student_id = e.student_id
JOIN course c
ON e.course_id = c.course_id

-- Find students who are enrolled in "Database Systems":
SELECT s.first_name ,s.last_name
FROM student s
JOIN entrollment e
ON s.student_id = e.student_id
JOIN course c 
ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

--  Count how many students are enrolled in each course:
SELECT c.course_name,COUNT(s.student_id)
FROM student s
JOIN entrollment e
ON s.student_id = e.student_id
JOIN course c 
ON e.course_id = c.course_id
GROUP BY c.course_name;


-- Adding Indexes for Performance

CREATE INDEX
idx_student_email 
ON student(email);

CREATE INDEX 
idx_course_code 
ON course(course_code);
CREATE INDEX 
idx_enrollment_student 
ON entrollment(student_id);
CREATE INDEX 
idx_enrollment_course 
ON entrollment(course_id);
