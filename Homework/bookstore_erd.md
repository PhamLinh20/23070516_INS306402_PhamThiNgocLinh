-- =======================================
-- Student Name:  Phạm Thị Ngọc Linh
-- Student ID:    23070516
-- Assignment:    Homework 6 - ERD
-- Date:          2026-10-04
-- =======================================
# Online Bookstore Database System - Entity-Relationship Diagram (ERD)

## 1. Entity-Relationship Diagram (ASCII Crow's Foot Notation)

+-----------------------+
|      publishers       |
+-----------------------+
| PK  id                |
|     name              |
|     address           |
|     website           |
|     phone             |
+-----------+-----------+
            | 1
            |
            | publishes (1:N)
            |
            | N
+-----------+-----------+        M : N via book_authors         +-----------------------+
|         books         |=======================================|        authors        |
+-----------------------+                                       +-----------------------+
| PK  id                |        +---------------------+        | PK  id                |
|     title             |=======>|    book_authors     |<=======|     name              |
|     isbn (UQ)         |  1:N   +---------------------+  1:N   |     biography         |
|     price             |        | PK, FK1  book_id    |        |     nationality       |
|     stock             |        | PK, FK2  author_id  |        |     birth_year        |
|     publication_date  |        |          author_role|        +-----------------------+
| FK  publisher_id      |        +---------------------+
+-----------+-----------+
            |
            |====================+ M : N via book_categories +-----------------------+
            |                    |                           |      categories       |
            |                    |   +-------------------+   +-----------------------+
            |                    +==>|  book_categories  |<==| PK  id                |<---+
            |                    1:N +-------------------+1:N|     name (UQ)         |    | (1:N Self-Ref)
            |                        | PK, FK1 book_id   |   |     description       |    | parent_id
            |                        | PK, FK2 category_id   | FK  parent_id         |----+
            |                        +-------------------+   +-----------------------+
            |
            +-------------------------+ 1:N
            |                         |
            | 1:N                     | 1:N
            v                         v
+-----------------------+    +-----------------------+
|      order_items      |    |        reviews        |
+-----------------------+    +-----------------------+
| PK  id                |    | PK  id                |
| FK  order_id          |    | FK  customer_id       |
| FK  book_id           |    | FK  book_id           |
|     quantity          |    |     rating (1..5)     |
|     unit_price        |    |     comment           |
|     subtotal          |    |     review_date       |
+-----------+-----------+    +-----------+-----------+
            | N                          | N
            |                            |
            | belongs to (N:1)           | written by (N:1)
            |                            |
            | 1                          | 1
+-----------+-----------+                |
|        orders         |                |
+-----------------------+                |
| PK  id                |                |
| FK  customer_id       |                |
|     order_date        |                |
|     status            |                |
|     shipping_address  |                |
|     total_amount      |                |
+-----------+-----------+                |
            | N                          |
            |                            |
            | places (1:N)               |
            |                            |
            | 1                          |
+-----------+-----------+                |
|       customers       |----------------+
+-----------------------+
| PK  id                |
|     name              |
|     email (UQ)        |
|     password_hash     |
|     phone             |
|     address           |
|     created_at        |
+-----------------------+

---

## 2. Entity Specifications and Attributes

| Entity | Attribute | Key Type | Constraint or Domain | Description |
| :--- | :--- | :---: | :--- | :--- |
| publishers | id | PK | INT, AUTO_INCREMENT | Unique identifier for publisher |
| | name | | VARCHAR(150), NOT NULL, UNIQUE | Publisher legal name |
| | address | | VARCHAR(255), NOT NULL | Headquarters physical address |
| | website | | VARCHAR(150), NULL | Official domain link |
| | phone | | VARCHAR(30), NULL | Contact telephone number |
| authors | id | PK | INT, AUTO_INCREMENT | Unique identifier for author |
| | name | | VARCHAR(120), NOT NULL | Full author name |
| | biography | | TEXT, NULL | Short background summary |
| | nationality | | VARCHAR(60), NOT NULL | Country of origin |
| | birth_year | | INT, NULL, CHECK (birth_year > 1800) | Author year of birth |
| categories | id | PK | INT, AUTO_INCREMENT | Unique identifier for category |
| | name | | VARCHAR(80), NOT NULL, UNIQUE | Genre or category title |
| | description | | VARCHAR(255), NULL | Scope and subject definition |
| | parent_id | FK | INT, NULL references categories(id) | Recursive key for parent category |
| books | id | PK | INT, AUTO_INCREMENT | Unique identifier for book title |
| | title | | VARCHAR(200), NOT NULL | Commercial book title |
| | isbn | | VARCHAR(17), NOT NULL, UNIQUE | Standard Book Number |
| | price | | DECIMAL(10,2), NOT NULL, CHECK (price > 0) | Retail catalog price |
| | stock | | INT, NOT NULL, DEFAULT 0, CHECK (stock >= 0) | On-hand inventory units |
| | publication_date | | DATE, NOT NULL | Official release date |
| | publisher_id | FK | INT, NOT NULL references publishers(id) | References publishing company |
| book_authors | book_id | PK, FK | INT, NOT NULL references books(id) | Foreign key linking book |
| | author_id | PK, FK | INT, NOT NULL references authors(id) | Foreign key linking author |
| | author_role | | VARCHAR(50), NOT NULL, DEFAULT 'Author' | Role: Lead Author, Co-Author |
| book_categories | book_id | PK, FK | INT, NOT NULL references books(id) | Foreign key linking book |
| | category_id | PK, FK | INT, NOT NULL references categories(id) | Foreign key linking category |
| customers | id | PK | INT, AUTO_INCREMENT | Unique identifier for user account |
| | name | | VARCHAR(120), NOT NULL | Customer full legal name |
| | email | | VARCHAR(120), NOT NULL, UNIQUE | Customer login email |
| | password_hash | | VARCHAR(255), NOT NULL | Secure salted cryptographic hash |
| | phone | | VARCHAR(30), NOT NULL | Primary contact phone number |
| | address | | VARCHAR(255), NOT NULL | Default shipping street address |
| | created_at | | DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP | Account creation timestamp |
| orders | id | PK | INT, AUTO_INCREMENT | Unique identifier for checkout order |
| | customer_id | FK | INT, NOT NULL references customers(id) | Customer who placed the order |
| | order_date | | DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP | Transaction timestamp |
| | status | | ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') | Fulfillment state |
| | shipping_address | | VARCHAR(255), NOT NULL | Delivery address |
| | total_amount | | DECIMAL(10,2), NOT NULL, CHECK (total_amount >= 0) | Monetary order total |
| order_items | id | PK | INT, AUTO_INCREMENT | Unique identifier for line item |
| | order_id | FK | INT, NOT NULL references orders(id) | References parent order |
| | book_id | FK | INT, NOT NULL references books(id) | References purchased book |
| | quantity | | INT, NOT NULL, DEFAULT 1, CHECK (quantity > 0) | Number of units purchased |
| | unit_price | | DECIMAL(10,2), NOT NULL, CHECK (unit_price > 0) | Locked-in purchase price |
| | subtotal | | DECIMAL(10,2), NOT NULL, CHECK (subtotal >= 0) | Line total (quantity * unit_price) |
| reviews | id | PK | INT, AUTO_INCREMENT | Unique identifier for review |
| | customer_id | FK | INT, NOT NULL references customers(id) | References review author |
| | book_id | FK | INT, NOT NULL references books(id) | References evaluated book |
| | rating | | INT, NOT NULL, CHECK (rating >= 1 AND rating <= 5) | Rating score from 1 to 5 |
| | comment | | TEXT, NULL | Narrative feedback |
| | review_date | | DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP | Submission timestamp |

---

## 3. Relationships and Cardinality

| Relationship Name | Cardinality | Parent Entity | Child Entity | Implementation Details |
| :--- | :---: | :--- | :--- | :--- |
| Publishing | 1 : N | publishers | books | books.publisher_id references publishers.id (ON DELETE RESTRICT, ON UPDATE CASCADE) |
| Authorship | M : N | books, authors | book_authors | Composite PK (book_id, author_id) references books.id and authors.id |
| Classification | M : N | books, categories | book_categories | Composite PK (book_id, category_id) references books.id and categories.id |
| Genre Hierarchy | 1 : N | categories | categories | Self-referencing FK categories.parent_id (ON DELETE SET NULL, ON UPDATE CASCADE) |
| Order Placement | 1 : N | customers | orders | orders.customer_id references customers.id (ON DELETE RESTRICT, ON UPDATE CASCADE) |
| Order Line Items | 1 : N | orders | order_items | order_items.order_id references orders.id (ON DELETE CASCADE, ON UPDATE CASCADE) |
| Product Ordering | 1 : N | books | order_items | order_items.book_id references books.id (ON DELETE RESTRICT, ON UPDATE CASCADE) |
| Customer Reviewing | 1 : N | customers | reviews | reviews.customer_id references customers.id (ON DELETE CASCADE, ON UPDATE CASCADE) |
| Book Feedback | 1 : N | books | reviews | reviews.book_id references books.id (ON DELETE CASCADE, ON UPDATE CASCADE) |

---

## 4. Normalization Verification (3NF Justification)

- First Normal Form (1NF):
  - Atomicity: All table columns contain strictly atomic and indivisible values.
  - No Repeating Groups: Multi-valued relationships (books having multiple authors or categories) are resolved through dedicated junction tables (book_authors, book_categories).
  - Identification: Every table contains an explicit primary key.

- Second Normal Form (2NF):
  - 1NF Compliance: Fully satisfies all rules of 1NF.
  - No Partial Dependencies: Every non-key column depends on the complete primary key.
  - For junction tables with composite primary keys like book_authors(book_id, author_id), the attribute author_role depends simultaneously on both book_id and author_id.
  - All other tables use single-column surrogate keys (id), naturally preventing partial dependencies.

- Third Normal Form (3NF):
  - 2NF Compliance: Fully satisfies all rules of 2NF.
  - No Transitive Dependencies: Non-key attributes depend only on the primary key, eliminating chains where X determines Y and Y determines Z.
  - Examples in this schema:
    - The books table stores only publisher_id. All publisher details (name, address, website, phone) remain in publishers, eliminating transitive dependency (book_id -> publisher_id -> publisher_name).
    - The orders table stores only customer_id, while customer profile information stays strictly in customers.
    - The order_items table stores unit_price as an immutable financial snapshot at checkout, making subtotals independent of future price changes in the books catalog.