-- ============================================================================
-- Student Name:  Pham Thi Ngoc Linh
-- Student ID:    23070516
-- Assignment:    Homework 06 - Online Bookstore Database System
-- Date:          2026-10-19
-- Database:      bookstore_db
-- ============================================================================

/*
===============================================================================
NORMALIZATION EXPLANATION (1NF -> 2NF -> 3NF)
===============================================================================

1. First Normal Form (1NF):
   - Atomicity: Every column contains single atomic and indivisible values 
     (e.g., standard strings, single unit prices, single timestamps).
   - No Repeating Groups: Multi-valued relationships (such as multiple authors 
     or categories per book) are extracted into dedicated bridge tables 
     (`book_authors`, `book_categories`).
   - Identifiability: Every table defines a distinct primary key (surrogate 
     AUTO_INCREMENT IDs or composite primary keys on junction tables).

2. Second Normal Form (2NF):
   - Meets all 1NF requirements.
   - Elimination of Partial Dependencies: Every non-key attribute is fully 
     functionally dependent on the whole candidate key.
   - In junction tables with composite primary keys like `book_authors(book_id, author_id)`, 
     the attribute `author_role` depends strictly on both `book_id` and `author_id`.
   - All other tables use single-column surrogate keys (`id`), inherently precluding 
     partial functional dependencies.

3. Third Normal Form (3NF):
   - Meets all 2NF requirements.
   - Elimination of Transitive Dependencies: Non-key attributes depend solely on 
     the primary key and not on any other non-key attributes (X -> Y -> Z removed).
   - Architectural Examples:
     * `books` stores only `publisher_id`; publisher details (name, address, website, phone) 
       reside exclusively in `publishers` (`book_id -> publisher_id -> publisher_name` removed).
     * `orders` stores only `customer_id`; customer profile attributes remain in `customers`.
     * `order_items` stores historical `unit_price` at the moment of checkout, 
       ensuring monetary totals remain unaffected by future updates in `books.price`.
===============================================================================
*/

-- ----------------------------------------------------------------------------
-- 1. DATABASE INITIALIZATION
-- ----------------------------------------------------------------------------
DROP DATABASE IF EXISTS bookstore_db;
CREATE DATABASE bookstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookstore_db;

-- Drop tables in reverse order to respect foreign key constraints
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS book_categories;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;

-- ----------------------------------------------------------------------------
-- 2. TABLE CREATION WITH CONSTRAINTS
-- ----------------------------------------------------------------------------

-- Table 1: publishers
CREATE TABLE publishers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    website VARCHAR(150) DEFAULT NULL,
    phone VARCHAR(30) DEFAULT NULL
) ENGINE=InnoDB;

-- Table 2: authors
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    biography TEXT DEFAULT NULL,
    nationality VARCHAR(60) NOT NULL,
    birth_year INT DEFAULT NULL,
    CONSTRAINT chk_authors_birth_year CHECK (birth_year IS NULL OR birth_year > 1800)
) ENGINE=InnoDB;

-- Table 3: categories (Self-referencing 1:N hierarchy)
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255) DEFAULT NULL,
    parent_id INT DEFAULT NULL,
    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_id) REFERENCES categories (id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 4: books
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(17) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    publication_date DATE NOT NULL,
    publisher_id INT NOT NULL,
    CONSTRAINT chk_books_price CHECK (price > 0),
    CONSTRAINT chk_books_stock CHECK (stock >= 0),
    CONSTRAINT fk_books_publisher
        FOREIGN KEY (publisher_id) REFERENCES publishers (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 5: book_authors (Junction Table M:N between books and authors)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    author_role VARCHAR(50) NOT NULL DEFAULT 'Author',
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book
        FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ba_author
        FOREIGN KEY (author_id) REFERENCES authors (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 6: book_categories (Junction Table M:N between books and categories)
CREATE TABLE book_categories (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_bc_book
        FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bc_category
        FOREIGN KEY (category_id) REFERENCES categories (id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 7: customers
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table 8: orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    shipping_address VARCHAR(255) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_orders_total CHECK (total_amount >= 0.00),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 9: order_items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_items_quantity CHECK (quantity > 0),
    CONSTRAINT chk_items_unit_price CHECK (unit_price > 0),
    CONSTRAINT chk_items_subtotal CHECK (subtotal >= 0),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_items_book
        FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table 10: reviews
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT DEFAULT NULL,
    review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_reviews_rating CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT fk_reviews_customer
        FOREIGN KEY (customer_id) REFERENCES customers (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reviews_book
        FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 3. SAMPLE DATA INSERTION
-- ----------------------------------------------------------------------------

-- 1. Publishers (4 publishers)
INSERT INTO publishers (id, name, address, website, phone) VALUES
(1, 'O''Reilly Media', '1005 Gravenstein Highway North, Sebastopol, CA', 'https://www.oreilly.com', '+1-707-827-7000'),
(2, 'Addison-Wesley Professional', '75 Arlington Street, Suite 300, Boston, MA', 'https://www.informit.com', '+1-617-848-6000'),
(3, 'Nha Xuat Ban Tre', '161 Ly Chinh Thang, Ward 7, District 3, Ho Chi Minh City', 'https://www.nxbtre.com.vn', '+84-28-39316285'),
(4, 'Nha Xuat Ban Kim Dong', '55 Quang Trung, Hai Ba Trung District, Hanoi', 'https://www.nxbkimdong.com.vn', '+84-24-39434730');

-- 2. Authors (6 authors)
INSERT INTO authors (id, name, biography, nationality, birth_year) VALUES
(1, 'Martin Kleppmann', 'Researcher in distributed systems and author of Designing Data-Intensive Applications.', 'British', 1983),
(2, 'Robert C. Martin', 'Software engineer and author known as Uncle Bob, agile software advocate.', 'American', 1952),
(3, 'Andrew S. Tanenbaum', 'Professor emeritus of computer science at Vrije Universiteit Amsterdam.', 'American', 1944),
(4, 'Nguyen Nhat Anh', 'Prominent Vietnamese author of beloved adolescent and young adult literature.', 'Vietnamese', 1955),
(5, 'David Thomas', 'Programmer, author, and one of the original authors of The Pragmatic Programmer.', 'British', 1956),
(6, 'Andrew Hunt', 'Author, publisher, and agile pioneer co-writing The Pragmatic Programmer.', 'American', 1964);

-- 3. Categories (5 categories with self-referencing subcategories)
INSERT INTO categories (id, name, description, parent_id) VALUES
(1, 'Computer Science', 'Foundational and academic computing concepts', NULL),
(2, 'Software Engineering', 'Practices, architecture, clean coding, and methodologies', 1),
(3, 'Data & Cloud', 'Databases, distributed systems, and cloud infrastructure', 1),
(4, 'Vietnamese Literature', 'Contemporary and classic novels by Vietnamese writers', NULL),
(5, 'Youth & Fiction', 'Stories exploring youth, romance, and growing up', 4);

-- 4. Books (8 books)
INSERT INTO books (id, title, isbn, price, stock, publication_date, publisher_id) VALUES
(1, 'Designing Data-Intensive Applications', '978-1449373320', 45.99, 35, '2017-03-16', 1),
(2, 'Clean Code: A Handbook of Agile Software Craftsmanship', '978-0132350884', 38.50, 40, '2008-08-01', 2),
(3, 'Computer Networks (5th Edition)', '978-0132126953', 75.00, 20, '2010-10-07', 2),
(4, 'The Pragmatic Programmer: 20th Anniversary Edition', '978-0135957059', 42.00, 25, '2019-09-13', 2),
(5, 'Mat Biec', '978-6041088719', 8.50, 60, '2019-12-01', 3),
(6, 'Toi Thay Hoa Vang Tren Co Xanh', '978-6041123458', 9.00, 50, '2018-05-10', 3),
(7, 'Cho Toi Xin Mot Ve Di Tuoi Tho', '978-6041078901', 7.50, 45, '2017-08-20', 3),
(8, 'Clean Architecture: A Craftsman''s Guide', '978-0134494166', 39.99, 30, '2017-09-20', 2);

-- 5. Book-Authors M:N Junction (Resolving multiple authors per book)
INSERT INTO book_authors (book_id, author_id, author_role) VALUES
(1, 1, 'Lead Author'),
(2, 2, 'Sole Author'),
(3, 3, 'Lead Author'),
(4, 5, 'Co-Author'),
(4, 6, 'Co-Author'),
(5, 4, 'Sole Author'),
(6, 4, 'Sole Author'),
(7, 4, 'Sole Author'),
(8, 2, 'Sole Author');

-- 6. Book-Categories M:N Junction
INSERT INTO book_categories (book_id, category_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 4),
(5, 5),
(6, 4),
(6, 5),
(7, 4),
(7, 5),
(8, 2);

-- 7. Customers (5 customers)
INSERT INTO customers (id, name, email, password_hash, phone, address, created_at) VALUES
(1, 'Pham Thi Ngoc Linh', '23070516@vnu.edu.vn', '$2y$10$e8w8GZ6s1wz3z.9V9K3wOeW2h1bF1f9g5xQ8y2n1w4e7r0t9y2u3i', '0912345678', 'Son Dong, Hoai Duc, Hanoi', '2026-09-01 08:30:00'),
(2, 'Nguyen Quang Minh', '23070517@vnu.edu.vn', '$2y$10$m9w8GZ6s1wz3z.9V9K3wOeW2h1bF1f9g5xQ8y2n1w4e7r0t9y2u3i', '0987654321', 'Cau Giay, Hanoi', '2026-09-05 10:15:00'), (3, 'Tran Bao Chau', '23070518@vnu.edu.vn', '$2y$10$p0w8GZ6s1wz3z.9V9K3wOeW2h1bF1f9g5xQ8y2n1w4e7r0t9y2u3i', '0905112233', 'Hai Ba Trung, Hanoi', '2026-09-10 14:00:00'),
(4, 'Le Hoang Nam', '23070519@vnu.edu.vn', '$2y$10$q1w8GZ6s1wz3z.9V9K3wOeW2h1bF1f9g5xQ8y2n1w4e7r0t9y2u3i', '0934556677', 'Thanh Xuan, Hanoi', '2026-09-15 09:45:00'), (5, 'Dang Thu Thao', '23070520@vnu.edu.vn', '$2y$10$r2w8GZ6s1wz3z.9V9K3wOeW2h1bF1f9g5xQ8y2n1w4e7r0t9y2u3i', '0977889900', 'Dong Da, Hanoi', '2026-09-20 16:20:00');

-- 8. Orders (6 orders)
INSERT INTO orders (id, customer_id, order_date, status, shipping_address, total_amount) VALUES
(1, 1, '2026-10-01 09:30:00', 'Delivered', 'Son Dong, Hoai Duc, Hanoi', 84.49),
(2, 1, '2026-10-05 14:15:00', 'Shipped', 'Son Dong, Hoai Duc, Hanoi', 42.00),
(3, 2, '2026-10-08 11:00:00', 'Delivered', 'Cau Giay, Hanoi', 113.50),
(4, 3, '2026-10-12 16:45:00', 'Processing', 'Hai Ba Trung, Hanoi', 17.50),
(5, 4, '2026-10-15 10:20:00', 'Pending', 'Thanh Xuan, Hanoi', 84.99),
(6, 5, '2026-10-18 13:10:00', 'Delivered', 'Dong Da, Hanoi', 25.00);

-- 9. Order Items (13 line items total across 6 orders)
INSERT INTO order_items (id, order_id, book_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 1, 45.99, 45.99),
(2, 1, 2, 1, 38.50, 38.50),
(3, 2, 4, 1, 42.00, 42.00),
(4, 3, 3, 1, 75.00, 75.00),
(5, 3, 2, 1, 38.50, 38.50),
(6, 4, 5, 1, 8.50, 8.50),
(7, 4, 6, 1, 9.00, 9.00),
(8, 5, 1, 1, 45.99, 45.99),
(9, 5, 8, 1, 39.00, 39.00),
(10, 6, 5, 1, 8.50, 8.50),
(11, 6, 6, 1, 9.00, 9.00),
(12, 6, 7, 1, 7.50, 7.50),
(13, 6, 6, 1, 9.00, 9.00);

-- 10. Reviews (10 reviews)
INSERT INTO reviews (id, customer_id, book_id, rating, comment, review_date) VALUES
(1, 1, 1, 5, 'Masterpiece for distributed systems architecture. Highly recommended!', '2026-10-03 10:00:00'),
(2, 1, 4, 5, 'Timeless advice for everyday developers. Pragmatic Programmer 20th ed is great.', '2026-10-06 18:30:00'),
(3, 2, 3, 4, 'Very detailed theoretical networking concepts, clear illustrations.', '2026-10-10 15:40:00'),
(4, 2, 2, 5, 'Essential reading for writing maintainable and testable code.', '2026-10-11 09:20:00'),
(5, 3, 5, 5, 'A poetic and emotional novel, very nostalgic story.', '2026-10-14 20:10:00'),
(6, 3, 6, 4, 'Heartwarming childhood memory portrait from Nguyen Nhat Anh.', '2026-10-15 11:05:00'),
(7, 4, 1, 5, 'Excellent coverage of data replication and consensus algorithms.', '2026-10-16 14:15:00'),
(8, 4, 8, 4, 'Solid architectural principles, complements Clean Code very well.', '2026-10-17 17:00:00'),
(9, 5, 5, 4, 'Beautiful story and well-developed characters.', '2026-10-19 09:10:00'),
(10, 5, 7, 5, 'Brings back so many fond childhood memories. Highly relaxing.', '2026-10-19 13:45:00');