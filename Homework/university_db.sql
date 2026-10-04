-- =======================================
-- Student Name:  Phạm Thị Ngọc Linh
-- Student ID:    23070516
-- Assignment:    Homework 4 
-- Date:          2026-10-04
-- =======================================
-- 1. DATABASE INITIALIZATION

DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university_db;

-- Drop existing tables in reverse dependency order to prevent foreign key errors
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS departments;

-- 2. TABLE CREATION WITH CONSTRAINTS

-- Table 1: departments
-- Stores academic departments/faculties (independent parent entity).
CREATE TABLE departments (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Table 2: semesters
-- Stores academic terms and their corresponding academic year.
CREATE TABLE semesters (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL UNIQUE,
academic_year VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- Table 3: instructors
-- Stores faculty members, linked to their parent department.
CREATE TABLE instructors (
id INT AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
department_id INT NOT NULL,
CONSTRAINT fk_instructors_department
FOREIGN KEY (department_id) REFERENCES departments (id)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 4: students
-- Stores student information linked to their major/department.
-- Uses ENUM for standardized gender input.
CREATE TABLE students (
id INT AUTO_INCREMENT PRIMARY KEY,
student_code VARCHAR(20) NOT NULL UNIQUE,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
gender ENUM('Male', 'Female') NOT NULL,
department_id INT NOT NULL,
CONSTRAINT fk_students_department
FOREIGN KEY (department_id) REFERENCES departments (id)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 5: courses
-- Stores course offerings linked to the managing department and lead instructor.
CREATE TABLE courses (
id INT AUTO_INCREMENT PRIMARY KEY,
course_code VARCHAR(20) NOT NULL UNIQUE,
title VARCHAR(100) NOT NULL,
credits INT NOT NULL DEFAULT 3,
department_id INT NOT NULL,
instructor_id INT NOT NULL,
CONSTRAINT chk_courses_credits CHECK (credits > 0 AND credits <= 10),
CONSTRAINT fk_courses_department
FOREIGN KEY (department_id) REFERENCES departments (id)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_courses_instructor
FOREIGN KEY (instructor_id) REFERENCES instructors (id)
ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 6: enrollments
-- Junction table modeling the many-to-many relationship between students and courses in a semester.
-- Composite UNIQUE constraint prevents multiple registrations for the same course in the same term.
-- Grade field uses DECIMAL(3,2) for a 0.00-4.00 grading scale and is optional (nullable for ongoing courses).
CREATE TABLE enrollments (
id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
semester_id INT NOT NULL,
grade DECIMAL(3, 2) DEFAULT NULL,
CONSTRAINT chk_enrollments_grade CHECK (grade IS NULL OR (grade >= 0.00 AND grade <= 4.00)),
CONSTRAINT unique_enrollment UNIQUE (student_id, course_id, semester_id),
CONSTRAINT fk_enrollments_student
FOREIGN KEY (student_id) REFERENCES students (id)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_enrollments_course
FOREIGN KEY (course_id) REFERENCES courses (id)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_enrollments_semester
FOREIGN KEY (semester_id) REFERENCES semesters (id)
ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. SAMPLE DATA INSERTION 

-- 1. Departments (5 faculties from VNU-IS)
INSERT INTO departments (id, name) VALUES
(1, 'Faculty of Finance and Accounting'),
(2, 'Faculty of Engineering and Technology'),
(3, 'Faculty of Applied Sciences'),
(4, 'Faculty of Economics and Management'),
(5, 'Faculty of Applied Linguistics');

-- 2. Semesters 
INSERT INTO semesters (id, name, academic_year) VALUES
(1, '1st Term (Academic Year 2023-2024)', '2023-2024'),
(2, '2nd Term (Academic Year 2023-2024)', '2023-2024'),
(3, '3rd Term (Academic Year 2023-2024)', '2023-2024'),
(4, '1st Term (Academic Year 2024-2025)', '2024-2025'),
(5, '2nd Term (Academic Year 2024-2025)', '2024-2025');

-- 3. Instructors 
INSERT INTO instructors (id, full_name, email, department_id) VALUES
(1, 'Truong Cong Doan', 'tcdoan@vnu.edu.vn', 3),
(2, 'Nguyen Thi Kim Oanh', 'nguyenthikimoanh@vnu.edu.vn', 1),
(3, 'Pham Dinh Tan', 'tanpd@vnu.edu.vn', 2),
(4, 'Nghiem Xuan Hoa', 'hoanx@vnu.edu.vn', 4),
(5, 'Pham Thi Tuyet Mai', 'maiptt@vnuis.edu.vn', 5);

-- 4. Students 
INSERT INTO students (id, student_code, full_name, email, gender, department_id) VALUES
(1, '23070516', 'Pham Thi Ngoc Linh', '23070516@vnu.edu.vn', 'Female', 3),
(2, '23070517', 'Nguyen Quang Minh', '23070517@vnu.edu.vn', 'Male', 2),
(3, '23070518', 'Tran Bao Chau', '23070518@vnu.edu.vn', 'Female', 1),
(4, '23070519', 'Le Hoang Nam', '23070519@vnu.edu.vn', 'Male', 4),
(5, '23070520', 'Dang Thu Thao', '23070520@vnu.edu.vn', 'Female', 5);

-- 5. Courses 
INSERT INTO courses (id, course_code, title, credits, department_id, instructor_id) VALUES
(1, 'INS3080', 'Artificial Intelligence', 3, 3, 1),
(2, 'INS2098', 'Principles of Accounting', 3, 1, 2),
(3, 'INS1077', 'Computer Network Fundamentals', 3, 2, 3),
(4, 'INE1051', 'Macroeconomics', 2, 4, 4),
(5, 'INS1016', 'English for Specific Purposes 1', 3, 5, 5);

-- 6. Enrollments 
INSERT INTO enrollments (student_id, course_id, semester_id, grade) VALUES
-- Student 1: Pham Thi Ngoc Linh (23070516)
(1, 3, 2, 4.00), -- INS1077 (Computer Network Fundamentals) in Term 2 (2023-2024) -> Grade A+ (4.00)
(1, 4, 4, 3.00), -- INE1051 (Macroeconomics) in Term 1 (2024-2025) -> Grade B (3.00)
(1, 1, 5, 3.70), -- INS3080 (Artificial Intelligence) in Term 2 (2024-2025) -> Grade A (3.70)

-- Student 2: Nguyen Quang Minh
(2, 3, 2, 3.70),
(2, 1, 4, 3.50),
(2, 5, 5, NULL),

-- Student 3: Tran Bao Chau
(3, 2, 1, 4.00),
(3, 4, 2, 3.80),
(3, 5, 4, 3.60),

-- Student 4: Le Hoang Nam
(4, 4, 1, 3.40),
(4, 2, 2, 3.10),

-- Student 5: Dang Thu Thao
(5, 5, 1, 4.00),
(5, 4, 4, NULL);