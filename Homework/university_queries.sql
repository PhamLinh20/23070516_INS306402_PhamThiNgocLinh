-- =======================================================
-- Student Name:  Pham Thi Ngoc Linh
-- Student ID:    23070516
-- Assignment:    Homework 05 
-- Date:          2026-10-11
-- Database:      university_db
-- =======================================================

USE university_db;

-- -------------------------------------------------------
-- Query 1: Basic SELECT
-- -------------------------------------------------------
/*
Query 1: List All Students
Description: Retrieves all columns from the students table to display
             the full profile of all registered students.
Expected Output: A table showing all 5 registered students with their ID,
                 student code, full name, email, gender, and department ID.
*/
SELECT * 
FROM students;
/*
+----+--------------+--------------------+---------------------+--------+---------------+
| id | student_code | full_name          | email               | gender | department_id |
+----+--------------+--------------------+---------------------+--------+---------------+
|  1 | 23070516     | Pham Thi Ngoc Linh | 23070516@vnu.edu.vn | Female |             3 |
|  2 | 23070517     | Nguyen Quang Minh  | 23070517@vnu.edu.vn | Male   |             2 |
|  3 | 23070518     | Tran Bao Chau      | 23070518@vnu.edu.vn | Female |             1 |
|  4 | 23070519     | Le Hoang Nam       | 23070519@vnu.edu.vn | Male   |             4 |
|  5 | 23070520     | Dang Thu Thao      | 23070520@vnu.edu.vn | Female |             5 |
+----+--------------+--------------------+---------------------+--------+---------------+
(5 rows)
*/


-- -------------------------------------------------------
-- Query 2: WHERE with comparison
-- -------------------------------------------------------
/*
Query 2: High Performing Enrollments
Description: Filters enrollment records using a comparison operator
             to retrieve all completed course registrations where the grade is at least 3.70.
Expected Output: A list of enrollment records with grade >= 3.70.
*/
SELECT 
    id,
    student_id,
    course_id,
    semester_id,
    grade
FROM enrollments
WHERE grade >= 3.70;
/*
+----+------------+-----------+-------------+-------+
| id | student_id | course_id | semester_id | grade |
+----+------------+-----------+-------------+-------+
|  1 |          1 |         3 |           2 |  4.00 |
|  3 |          1 |         1 |           5 |  3.70 |
|  4 |          2 |         3 |           2 |  3.70 |
|  7 |          3 |         2 |           1 |  4.00 |
|  8 |          3 |         4 |           2 |  3.80 |
| 11 |          5 |         5 |           1 |  4.00 |
+----+------------+-----------+-------------+-------+
(6 rows)
*/


-- -------------------------------------------------------
-- Query 3: WHERE with AND/OR
-- -------------------------------------------------------
/*
Query 3: Filter Active High Credit Courses
Description: Combines multiple logical conditions using AND and OR to find
             courses that carry at least 3 credits and belong to either
             the Faculty of Applied Sciences (department_id = 3) or
             the Faculty of Engineering and Technology (department_id = 2).
Expected Output: Courses meeting credit and department criteria.
*/
SELECT 
    course_code,
    title,
    credits,
    department_id
FROM courses
WHERE credits >= 3 
  AND (department_id = 2 OR department_id = 3);
/*
+-------------+-------------------------------+---------+---------------+
| course_code | title                         | credits | department_id |
+-------------+-------------------------------+---------+---------------+
| INS3080     | Artificial Intelligence       |       3 |             3 |
| INS1077     | Computer Network Fundamentals |       3 |             2 |
+-------------+-------------------------------+---------+---------------+
(2 rows)
*/


-- -------------------------------------------------------
-- Query 4: ORDER BY
-- -------------------------------------------------------
/*
Query 4: Sort Students Alphabetically
Description: Sorts all student records alphabetically by full name in ascending order,
             with gender displayed for quick demographic review.
Expected Output: All 5 students ordered alphabetically from Dang Thu Thao to Tran Bao Chau.
*/
SELECT 
    student_code,
    full_name,
    gender,
    email
FROM students
ORDER BY full_name ASC;
/*
+--------------+--------------------+--------+---------------------+
| student_code | full_name          | gender | email               |
+--------------+--------------------+--------+---------------------+
| 23070520     | Dang Thu Thao      | Female | 23070520@vnu.edu.vn |
| 23070519     | Le Hoang Nam       | Male   | 23070519@vnu.edu.vn |
| 23070517     | Nguyen Quang Minh  | Male   | 23070517@vnu.edu.vn |
| 23070516     | Pham Thi Ngoc Linh | Female | 23070516@vnu.edu.vn |
| 23070518     | Tran Bao Chau      | Female | 23070518@vnu.edu.vn |
+--------------+--------------------+--------+---------------------+
(5 rows)
*/


-- -------------------------------------------------------
-- Query 5: LIMIT
-- -------------------------------------------------------
/*
Query 5: Top 3 Highest Grades
Description: Returns the top 3 highest grades achieved in the system,
             ignoring NULL grades and ordered descending.
Expected Output: 3 enrollment records showing the top grades of 4.00.
*/
SELECT 
    student_id,
    course_id,
    semester_id,
    grade
FROM enrollments
WHERE grade IS NOT NULL
ORDER BY grade DESC
LIMIT 3;
/*
+------------+-----------+-------------+-------+
| student_id | course_id | semester_id | grade |
+------------+-----------+-------------+-------+
|          1 |         3 |           2 |  4.00 |
|          3 |         2 |           1 |  4.00 |
|          5 |         5 |           1 |  4.00 |
+------------+-----------+-------------+-------+
(3 rows)
*/


-- -------------------------------------------------------
-- Query 6: LIKE
-- -------------------------------------------------------
/*
Query 6: Search Instructors with Family Name 'Pham'
Description: Uses pattern matching with the LIKE operator to search for instructors
             whose full name starts with the family name 'Pham'.
Expected Output: Instructors named Pham Dinh Tan and Pham Thi Tuyet Mai.
*/
SELECT 
    id,
    full_name,
    email
FROM instructors
WHERE full_name LIKE 'Pham%';
/*
+----+--------------------+--------------------+
| id | full_name          | email              |
+----+--------------------+--------------------+
|  3 | Pham Dinh Tân      | tanpd@vnu.edu.vn   |
|  5 | Pham Thi Tuyet Mai | maiptt@vnuis.edu.vn|
+----+--------------------+--------------------+
(2 rows)
*/


-- -------------------------------------------------------
-- Query 7: Aggregate — COUNT / SUM
-- -------------------------------------------------------
/*
Query 7: Total Academic Offerings Overview
Description: Demonstrates aggregate functions by calculating the total number of
             available courses, total academic credits offered across the catalog,
             and the average credit value per course.
Expected Output: Single row summary of total courses, sum of credits, and average credits.
*/
SELECT 
    COUNT(*)               AS total_courses,
    SUM(credits)           AS total_credits_offered,
    ROUND(AVG(credits), 2) AS average_credits
FROM courses;
/*
+---------------+----------------------+-----------------+
| total_courses | total_credits_offered| average_credits |
+---------------+----------------------+-----------------+
|             5 |                   14 |            2.80 |
+---------------+----------------------+-----------------+
(1 row)
*/


-- -------------------------------------------------------
-- Query 8: Aggregate with GROUP BY + HAVING
-- -------------------------------------------------------
/*
Query 8: Students with More Than Two Enrollments
Description: Groups enrollment records by student_id and uses the HAVING clause
             to filter and show only students who have enrolled in more than 2 courses,
             displaying their enrollment count and calculated GPA.
Expected Output: Students 1 (Pham Thi Ngoc Linh), 2 (Nguyen Quang Minh),
                 and 3 (Tran Bao Chau) each having 3 enrollments.
*/
SELECT 
    student_id,
    COUNT(*)               AS total_enrollments,
    ROUND(AVG(grade), 2)   AS average_grade
FROM enrollments
GROUP BY student_id
HAVING COUNT(*) > 2;
/*
+------------+-------------------+---------------+
| student_id | total_enrollments | average_grade |
+------------+-------------------+---------------+
|          1 |                 3 |          3.57 |
|          2 |                 3 |          3.60 |
|          3 |                 3 |          3.80 |
+------------+-------------------+---------------+
(3 rows)
*/


-- -------------------------------------------------------
-- Query 9: JOIN — two tables
-- -------------------------------------------------------
/*
Query 9: Courses with Lead Instructors
Description: Performs an INNER JOIN between courses and instructors using instructor_id
             to show each course alongside the lecturer teaching it and their contact email.
Expected Output: 5 courses matched with their respective lecturer names and emails.
*/
SELECT 
    c.course_code,
    c.title            AS course_title,
    c.credits,
    i.full_name        AS instructor_name,
    i.email            AS instructor_email
FROM courses c
JOIN instructors i ON c.instructor_id = i.id
ORDER BY c.course_code ASC;
/*
+-------------+---------------------------------+---------+---------------------+---------------------+
| course_code | course_title                    | credits | instructor_name     | instructor_email    |
+-------------+---------------------------------+---------+---------------------+---------------------+
| INE1051     | Macroeconomics                  |       2 | Nghiem Xuan Hoa     | hoanx@vnu.edu.vn    |
| INS1016     | English for Specific Purposes 1 |       3 | Pham Thi Tuyet Mai  | maiptt@vnuis.edu.vn |
| INS1077     | Computer Network Fundamentals   |       3 | Pham Dinh Tan       | tanpd@vnu.edu.vn    |
| INS2098     | Principles of Accounting        |       3 | Nguyen Thi Kim Oanh | nguyenthikimoanh... |
| INS3080     | Artificial Intelligence         |       3 | Truong Cong Doan    | tcdoan@vnu.edu.vn   |
+-------------+---------------------------------+---------+---------------------+---------------------+
(5 rows)
*/


-- -------------------------------------------------------
-- Query 10: JOIN — three or more tables
-- -------------------------------------------------------
/*
Query 10: Complete Enrollment Records
Description: Multi-table JOIN combining enrollments, students, courses, and semesters
             to produce a comprehensive transcript view including student name, course title,
             semester term, and final grade.
Expected Output: Detailed list of all 12 enrollments sorted by student code and semester name.
*/
SELECT 
    s.student_code,
    s.full_name        AS student_name,
    c.course_code,
    c.title            AS course_title,
    sem.name           AS semester_name,
    e.grade
FROM enrollments e
JOIN students s  ON e.student_id = s.id
JOIN courses c   ON e.course_id = c.id
JOIN semesters sem ON e.semester_id = sem.id
ORDER BY s.student_code ASC, sem.name ASC;
/*
+--------------+--------------------+-------------+---------------------------------+-----------------------------------+-------+
| student_code | student_name       | course_code | course_title                    | semester_name                     | grade |
+--------------+--------------------+-------------+---------------------------------+-----------------------------------+-------+
| 23070516     | Pham Thi Ngoc Linh | INE1051     | Macroeconomics                  | 1st Term (Academic Year 2024-2025)|  3.00 |
| 23070516     | Pham Thi Ngoc Linh | INS1077     | Computer Network Fundamentals   | 2nd Term (Academic Year 2023-2024)|  4.00 |
| 23070516     | Pham Thi Ngoc Linh | INS3080     | Artificial Intelligence         | 2nd Term (Academic Year 2024-2025)|  3.70 |
| 23070517     | Nguyen Quang Minh  | INS3080     | Artificial Intelligence         | 1st Term (Academic Year 2024-2025)|  3.50 |
| 23070517     | Nguyen Quang Minh  | INS1077     | Computer Network Fundamentals   | 2nd Term (Academic Year 2023-2024)|  3.70 |
| 23070517     | Nguyen Quang Minh  | INS1016     | English for Specific Purposes 1 | 2nd Term (Academic Year 2024-2025)|  NULL |
| 23070518     | Tran Bao Chau      | INS2098     | Principles of Accounting        | 1st Term (Academic Year 2023-2024)|  4.00 |
| 23070518     | Tran Bao Chau      | INS1016     | English for Specific Purposes 1 | 1st Term (Academic Year 2024-2025)|  3.60 |
| 23070518     | Tran Bao Chau      | INE1051     | Macroeconomics                  | 2nd Term (Academic Year 2023-2024)|  3.80 |
| 23070519     | Le Hoang Nam       | INE1051     | Macroeconomics                  | 1st Term (Academic Year 2023-2024)|  3.40 |
| 23070519     | Le Hoang Nam       | INS2098     | Principles of Accounting        | 2nd Term (Academic Year 2023-2024)|  3.10 |
| 23070520     | Dang Thu Thao      | INS1016     | English for Specific Purposes 1 | 1st Term (Academic Year 2023-2024)|  4.00 |
| 23070520     | Dang Thu Thao      | INE1051     | Macroeconomics                  | 1st Term (Academic Year 2024-2025)|  NULL |
+--------------+--------------------+-------------+---------------------------------+-----------------------------------+-------+
(12 rows)
*/