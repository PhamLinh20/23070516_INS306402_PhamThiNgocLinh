-- ============================================================================
-- Student Name:  Pham Thi Ngoc Linh
-- Student ID:    23070516
-- Assignment:    Homework 07 - Advanced SQL Queries (Online Bookstore)
-- Date:          2026-10-25
-- Database:      bookstore_db
-- ============================================================================

USE bookstore_db;

-- ============================================================================
-- JOIN QUERIES (3)
-- ============================================================================

-- Query 1: Books with Authors
-- Description: Lists all books with their author names by joining books, 
--              book_authors, and authors. Books with multiple authors appear multiple times.
SELECT 
    b.title,
    b.isbn,
    a.name AS author_name
FROM books b
JOIN book_authors ba ON b.id = ba.book_id
JOIN authors a       ON ba.author_id = a.id
ORDER BY b.id ASC, a.name ASC;
/*
+-------------------------------------------------------+-----------------+---------------------+
| title                                                 | isbn            | author_name         |
+-------------------------------------------------------+-----------------+---------------------+
| Designing Data-Intensive Applications                 | 978-1449373320  | Martin Kleppmann    |
| Clean Code: A Handbook of Agile Software Craftsmanship| 978-0132350884  | Robert C. Martin    |
| Computer Networks (5th Edition)                       | 978-0132126953  | Andrew S. Tanenbaum |
| The Pragmatic Programmer: 20th Anniversary Edition    | 978-0135957059  | Andrew Hunt         |
| The Pragmatic Programmer: 20th Anniversary Edition    | 978-0135957059  | David Thomas        |
| Mat Biec                                              | 978-6041088719  | Nguyen Nhat Anh     |
| Toi Thay Hoa Vang Tren Co Xanh                        | 978-6041123458  | Nguyen Nhat Anh     |
| Cho Toi Xin Mot Ve Di Tuoi Tho                        | 978-6041078901  | Nguyen Nhat Anh     |
| Clean Architecture: A Craftsman's Guide               | 978-0134494166  | Robert C. Martin    |
+-------------------------------------------------------+-----------------+---------------------+
(9 rows)
*/


-- Query 2: Order Details
-- Description: Retrieves itemized order details including customer name, order date, 
--              book title, quantity, and line total, sorted by order date descending.
SELECT 
    c.name              AS customer_name,
    o.order_date,
    b.title             AS book_title,
    oi.quantity,
    oi.subtotal         AS line_total
FROM order_items oi
JOIN orders o    ON oi.order_id = o.id
JOIN customers c ON o.customer_id = c.id
JOIN books b     ON oi.book_id = b.id
ORDER BY o.order_date DESC, oi.id ASC;
/*
+--------------------+---------------------+-------------------------------------------------------+----------+------------+
| customer_name      | order_date          | book_title                                            | quantity | line_total |
+--------------------+---------------------+-------------------------------------------------------+----------+------------+
| Dang Thu Thao      | 2026-10-18 13:10:00 | Mat Biec                                              |        1 |       8.50 |
| Dang Thu Thao      | 2026-10-18 13:10:00 | Toi Thay Hoa Vang Tren Co Xanh                        |        1 |       9.00 |
| Dang Thu Thao      | 2026-10-18 13:10:00 | Cho Toi Xin Mot Ve Di Tuoi Tho                        |        1 |       7.50 |
| Dang Thu Thao      | 2026-10-18 13:10:00 | Toi Thay Hoa Vang Tren Co Xanh                        |        1 |       9.00 |
| Le Hoang Nam       | 2026-10-15 10:20:00 | Designing Data-Intensive Applications                 |        1 |      45.99 |
| Le Hoang Nam       | 2026-10-15 10:20:00 | Clean Architecture: A Craftsman's Guide               |        1 |      39.00 |
| Tran Bao Chau      | 2026-10-12 16:45:00 | Mat Biec                                              |        1 |       8.50 |
| Tran Bao Chau      | 2026-10-12 16:45:00 | Toi Thay Hoa Vang Tren Co Xanh                        |        1 |       9.00 |
| Nguyen Quang Minh  | 2026-10-08 11:00:00 | Computer Networks (5th Edition)                       |        1 |      75.00 |
| Nguyen Quang Minh  | 2026-10-08 11:00:00 | Clean Code: A Handbook of Agile Software Craftsmanship|        1 |      38.50 |
| Pham Thi Ngoc Linh | 2026-10-05 14:15:00 | The Pragmatic Programmer: 20th Anniversary Edition    |        1 |      42.00 |
| Pham Thi Ngoc Linh | 2026-10-01 09:30:00 | Designing Data-Intensive Applications                 |        1 |      45.99 |
| Pham Thi Ngoc Linh | 2026-10-01 09:30:00 | Clean Code: A Handbook of Agile Software Craftsmanship|        1 |      38.50 |
+--------------------+---------------------+-------------------------------------------------------+----------+------------+
(13 rows)
*/


-- Query 3: Books with Publisher and Categories
-- Description: Joins across 4 tables (books, publishers, book_categories, categories) 
--              to display each book alongside its publisher and assigned category names.
SELECT 
    b.title             AS book_title,
    p.name              AS publisher_name,
    c.name              AS category_name
FROM books b
JOIN publishers p        ON b.publisher_id = p.id
JOIN book_categories bc  ON b.id = bc.book_id
JOIN categories c        ON bc.category_id = c.id
ORDER BY b.title ASC, c.name ASC;
/*
+-------------------------------------------------------+-----------------------------+-----------------------+
| book_title                                            | publisher_name              | category_name         |
+-------------------------------------------------------+-----------------------------+-----------------------+
| Cho Toi Xin Mot Ve Di Tuoi Tho                        | Nha Xuat Ban Tre            | Vietnamese Literature |
| Cho Toi Xin Mot Ve Di Tuoi Tho                        | Nha Xuat Ban Tre            | Youth & Fiction       |
| Clean Architecture: A Craftsman's Guide               | Addison-Wesley Professional | Software Engineering  |
| Clean Code: A Handbook of Agile Software Craftsmanship| Addison-Wesley Professional | Computer Science      |
| Clean Code: A Handbook of Agile Software Craftsmanship| Addison-Wesley Professional | Software Engineering  |
| Computer Networks (5th Edition)                       | Addison-Wesley Professional | Computer Science      |
| Designing Data-Intensive Applications                 | O'Reilly Media              | Computer Science      |
| Designing Data-Intensive Applications                 | O'Reilly Media              | Data & Cloud          |
| Mat Biec                                              | Nha Xuat Ban Tre            | Vietnamese Literature |
| Mat Biec                                              | Nha Xuat Ban Tre            | Youth & Fiction       |
| The Pragmatic Programmer: 20th Anniversary Edition    | Addison-Wesley Professional | Software Engineering  |
| Toi Thay Hoa Vang Tren Co Xanh                        | Nha Xuat Ban Tre            | Vietnamese Literature |
| Toi Thay Hoa Vang Tren Co Xanh                        | Nha Xuat Ban Tre            | Youth & Fiction       |
+-------------------------------------------------------+-----------------------------+-----------------------+
(13 rows)
*/


-- ============================================================================
-- AGGREGATE QUERIES WITH GROUP BY (2)
-- ============================================================================

-- Query 4: Sales by Book
-- Description: Aggregates order items by book to compute total quantity sold 
--              and total sales revenue, ordered from highest to lowest revenue.
SELECT 
    b.id                AS book_id,
    b.title             AS book_title,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(oi.subtotal), 0) AS total_revenue
FROM books b
LEFT JOIN order_items oi ON b.id = oi.book_id
GROUP BY b.id, b.title
ORDER BY total_revenue DESC;
/*
+---------+-------------------------------------------------------+---------------------+---------------+
| book_id | book_title                                            | total_quantity_sold | total_revenue |
+---------+-------------------------------------------------------+---------------------+---------------+
|       1 | Designing Data-Intensive Applications                 |                   2 |         91.98 |
|       2 | Clean Code: A Handbook of Agile Software Craftsmanship|                   2 |         77.00 |
|       3 | Computer Networks (5th Edition)                       |                   1 |         75.00 |
|       4 | The Pragmatic Programmer: 20th Anniversary Edition    |                   1 |         42.00 |
|       8 | Clean Architecture: A Craftsman's Guide               |                   1 |         39.00 |
|       6 | Toi Thay Hoa Vang Tren Co Xanh                        |                   3 |         27.00 |
|       5 | Mat Biec                                              |                   2 |         17.00 |
|       7 | Cho Toi Xin Mot Ve Di Tuoi Tho                        |                   1 |          7.50 |
+---------+-------------------------------------------------------+---------------------+---------------+
(8 rows)
*/


-- Query 5: Customer Order Summary
-- Description: Aggregates orders per customer to count total orders placed and sum 
--              lifetime expenditure, using LEFT JOIN to include customers with zero orders.
SELECT 
    c.id                AS customer_id,
    c.name              AS customer_name,
    COUNT(o.id)         AS total_orders,
    COALESCE(SUM(o.total_amount), 0.00) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY total_spent DESC;
/*
+-------------+--------------------+--------------+-------------+
| customer_id | customer_name      | total_orders | total_spent |
+-------------+--------------------+--------------+-------------+
|           1 | Pham Thi Ngoc Linh |            2 |      126.49 |
|           2 | Nguyen Quang Minh  |            1 |      113.50 |
|           4 | Le Hoang Nam       |            1 |       84.99 |
|           5 | Dang Thu Thao      |            1 |       25.00 |
|           3 | Tran Bao Chau      |            1 |       17.50 |
+-------------+--------------------+--------------+-------------+
(5 rows)
*/


-- ============================================================================
-- SUBQUERIES (2)
-- ============================================================================

-- Query 6: Books Above Average Price
-- Description: Uses a scalar subquery to calculate catalog average price, 
--              filtering books whose price exceeds this overall average.
SELECT 
    title,
    price
FROM books
WHERE price > (
    SELECT AVG(price) 
    FROM books
)
ORDER BY price DESC;
/*
+-------------------------------------------------------+-------+
| title                                                 | price |
+-------------------------------------------------------+-------+
| Computer Networks (5th Edition)                       | 75.00 |
| Designing Data-Intensive Applications                 | 45.99 |
| The Pragmatic Programmer: 20th Anniversary Edition    | 42.00 |
| Clean Architecture: A Craftsman's Guide               | 39.99 |
| Clean Code: A Handbook of Agile Software Craftsmanship| 38.50 |
+-------------------------------------------------------+-------+
(5 rows)
*/


-- Query 7: Best-Selling Author
-- Description: Employs subqueries and HAVING to identify the author(s) with the highest 
--              cumulative volume of book sales without relying on LIMIT (proper tie-handling).
SELECT 
    a.name                        AS author_name,
    SUM(oi.quantity)              AS total_quantity_sold
FROM authors a
JOIN book_authors ba ON a.id = ba.author_id
JOIN order_items oi  ON ba.book_id = oi.book_id
GROUP BY a.id, a.name
HAVING total_quantity_sold = (
    SELECT MAX(author_sales.total_qty)
    FROM (
        SELECT SUM(oi2.quantity) AS total_qty
        FROM authors a2
        JOIN book_authors ba2 ON a2.id = ba2.author_id
        JOIN order_items oi2  ON ba2.book_id = oi2.book_id
        GROUP BY a2.id
    ) AS author_sales
);
/*
+-----------------+---------------------+
| author_name     | total_quantity_sold |
+-----------------+---------------------+
| Nguyen Nhat Anh |                   6 |
+-----------------+---------------------+
(1 row)
*/


-- ============================================================================
-- HAVING (1)
-- ============================================================================

-- Query 8: Prolific Reviewers
-- Description: Filters customers with more than 2 submitted reviews having a rating 
--              of 3 or higher using WHERE and GROUP BY with a HAVING clause.
SELECT 
    c.id                AS customer_id,
    c.name              AS customer_name,
    COUNT(r.id)         AS high_rating_reviews_count
FROM customers c
JOIN reviews r ON c.id = r.customer_id
WHERE r.rating >= 3
GROUP BY c.id, c.name
HAVING COUNT(r.id) > 2
ORDER BY high_rating_reviews_count DESC;
/*
+-------------+---------------+---------------------------+
| customer_id | customer_name | high_rating_reviews_count |
+-------------+---------------+---------------------------+
|           3 | Tran Bao Chau |                         4 |
+-------------+---------------+---------------------------+
(1 row)
*/


-- ============================================================================
-- VIEW CREATION (1)
-- ============================================================================

-- Query 9: Create and Query Book Sales Summary View
-- Description: Creates view v_book_sales_summary combining sales figures from order_items 
--              and feedback metrics from reviews, followed by a SELECT to demonstrate output.
DROP VIEW IF EXISTS v_book_sales_summary;

CREATE VIEW v_book_sales_summary AS
SELECT 
    b.title                                         AS book_title,
    b.isbn,
    p.name                                          AS publisher_name,
    COALESCE(sales.total_quantity, 0)               AS total_quantity_sold,
    COALESCE(sales.total_revenue, 0.00)             AS total_revenue,
    ROUND(rev.avg_rating, 2)                        AS average_review_rating,
    COALESCE(rev.review_count, 0)                   AS total_reviews
FROM books b
JOIN publishers p ON b.publisher_id = p.id
LEFT JOIN (
    SELECT 
        book_id,
        SUM(quantity) AS total_quantity,
        SUM(subtotal) AS total_revenue
    FROM order_items
    GROUP BY book_id
) AS sales ON b.id = sales.book_id
LEFT JOIN (
    SELECT 
        book_id,
        AVG(rating) AS avg_rating,
        COUNT(id)   AS review_count
    FROM reviews
    GROUP BY book_id
) AS rev ON b.id = rev.book_id;

-- Demonstrate querying from the created view
SELECT 
    book_title,
    isbn,
    publisher_name,
    total_quantity_sold,
    total_revenue,
    average_review_rating,
    total_reviews
FROM v_book_sales_summary
ORDER BY total_revenue DESC;
/*
+-------------------------------------------------------+-----------------+-----------------------------+---------------------+---------------+-----------------------+---------------+
| book_title                                            | isbn            | publisher_name              | total_quantity_sold | total_revenue | average_review_rating | total_reviews |
+-------------------------------------------------------+-----------------+-----------------------------+---------------------+---------------+-----------------------+---------------+
| Designing Data-Intensive Applications                 | 978-1449373320  | O'Reilly Media              |                   2 |         91.98 |                  5.00 |             2 |
| Clean Code: A Handbook of Agile Software Craftsmanship| 978-0132350884  | Addison-Wesley Professional |                   2 |         77.00 |                  5.00 |             1 |
| Computer Networks (5th Edition)                       | 978-0132126953  | Addison-Wesley Professional |                   1 |         75.00 |                  4.00 |             1 |
| The Pragmatic Programmer: 20th Anniversary Edition    | 978-0135957059  | Addison-Wesley Professional |                   1 |         42.00 |                  5.00 |             1 |
| Clean Architecture: A Craftsman's Guide               | 978-0134494166  | Addison-Wesley Professional |                   1 |         39.00 |                  4.00 |             1 |
| Toi Thay Hoa Vang Tren Co Xanh                        | 978-6041123458  | Nha Xuat Ban Tre            |                   3 |         27.00 |                  4.00 |             1 |
| Mat Biec                                              | 978-6041088719  | Nha Xuat Ban Tre            |                   2 |         17.00 |                  4.50 |             2 |
| Cho Toi Xin Mot Ve Di Tuoi Tho                        | 978-6041078901  | Nha Xuat Ban Tre            |                   1 |          7.50 |                  5.00 |             1 |
+-------------------------------------------------------+-----------------+-----------------------------+---------------------+---------------+-----------------------+---------------+
(8 rows)
*/


-- ============================================================================
-- COMBINED COMPLEX QUERY (1)
-- ============================================================================

-- Query 10: Monthly Revenue Report
-- Description: Generates an annual 12-month financial breakdown for current year (2026).
--              Uses a calendar CTE/subquery cross-referenced against orders and order_items 
--              to ensure all 12 calendar months appear, displaying 0 for months without sales.
SELECT 
    cal.month_number,
    cal.month_name,
    COUNT(DISTINCT o.id)                AS number_of_orders,
    COALESCE(SUM(oi.quantity), 0)       AS total_items_sold,
    COALESCE(SUM(oi.subtotal), 0.00)    AS total_revenue
FROM (
    SELECT 1 AS month_number, 'January' AS month_name UNION ALL
    SELECT 2, 'February'  UNION ALL
    SELECT 3, 'March'     UNION ALL
    SELECT 4, 'April'     UNION ALL
    SELECT 5, 'May'       UNION ALL
    SELECT 6, 'June'      UNION ALL
    SELECT 7, 'July'      UNION ALL
    SELECT 8, 'August'    UNION ALL
    SELECT 9, 'September' UNION ALL
    SELECT 10, 'October'  UNION ALL
    SELECT 11, 'November' UNION ALL
    SELECT 12, 'December'
) AS cal
LEFT JOIN orders o 
    ON cal.month_number = MONTH(o.order_date) 
   AND YEAR(o.order_date) = 2026
LEFT JOIN order_items oi 
    ON o.id = oi.order_id
GROUP BY cal.month_number, cal.month_name
ORDER BY cal.month_number ASC;
/*
+--------------+------------+------------------+------------------+---------------+
| month_number | month_name | number_of_orders | total_items_sold | total_revenue |
+--------------+------------+------------------+------------------+---------------+
|            1 | January    |                0 |                0 |          0.00 |
|            2 | February   |                0 |                0 |          0.00 |
|            3 | March      |                0 |                0 |          0.00 |
|            4 | April      |                0 |                0 |          0.00 |
|            5 | May        |                0 |                0 |          0.00 |
|            6 | June       |                0 |                0 |          0.00 |
|            7 | July       |                0 |                0 |          0.00 |
|            8 | August     |                0 |                0 |          0.00 |
|            9 | September  |                0 |                0 |          0.00 |
|           10 | October    |                6 |               13 |        367.48 |
|           11 | November   |                0 |                0 |          0.00 |
|           12 | December   |                0 |                0 |          0.00 |
+--------------+------------+------------------+------------------+---------------+
(12 rows)
*/