-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: 02_data.sql
-- Description: Inserts sample data meeting all requirements:
--              - At least 5 customers (8 provided: includes multi-order customers,
--                1 single-order customer, and 1 zero-order customer for edge case testing)
--              - At least 8 products across at least 3 categories (10 products across 4 categories)
--              - At least 15 orders (17 orders across multiple dates)
--              - At least 25 order items (31 items)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Insert Customers (8 customers)
-- -----------------------------------------------------------------------------
INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (1, 'Alice Smith', 'alice.smith@example.com', 'New York');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (2, 'Bob Jones', 'bob.jones@example.com', 'Chicago');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (3, 'Charlie Brown', 'charlie.brown@example.com', 'Houston');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (4, 'Diana Prince', 'diana.prince@example.com', 'Los Angeles');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (5, 'Evan Wright', 'evan.wright@example.com', 'Chicago');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (6, 'Fiona Gallagher', 'fiona.g@example.com', 'Boston');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (7, 'George Miller', 'george.m@example.com', 'Seattle');

INSERT INTO customers (customer_id, customer_name, email, city) 
VALUES (8, 'Hannah Abbott', 'hannah.a@example.com', 'Denver');

-- -----------------------------------------------------------------------------
-- 2. Insert Products (10 products across 4 categories: Produce, Dairy, Bakery, Beverages)
-- -----------------------------------------------------------------------------
INSERT INTO products (product_id, product_name, category, price) 
VALUES (1, 'Organic Bananas', 'Produce', 1.99);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (2, 'Gala Apples (1 lb)', 'Produce', 2.99);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (3, 'Baby Spinach (5 oz)', 'Produce', 3.49);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (4, 'Whole Milk (1 Gallon)', 'Dairy', 4.29);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (5, 'Greek Yogurt (32 oz)', 'Dairy', 5.89);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (6, 'Cheddar Cheese (8 oz)', 'Dairy', 4.79);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (7, 'Artisan Sourdough Bread', 'Bakery', 4.99);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (8, 'Butter Croissants (4-pack)', 'Bakery', 5.49);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (9, 'Colombian Roast Coffee (12 oz)', 'Beverages', 11.99);

INSERT INTO products (product_id, product_name, category, price) 
VALUES (10, 'Organic Green Tea (20 bags)', 'Beverages', 6.50);

-- -----------------------------------------------------------------------------
-- 3. Insert Orders (17 orders across Jan-Mar 2026)
-- -----------------------------------------------------------------------------
INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (101, 1, TO_DATE('2026-01-05', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (102, 2, TO_DATE('2026-01-08', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (103, 3, TO_DATE('2026-01-12', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (104, 1, TO_DATE('2026-01-15', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (105, 4, TO_DATE('2026-01-20', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (106, 5, TO_DATE('2026-01-25', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (107, 2, TO_DATE('2026-01-28', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (108, 3, TO_DATE('2026-02-02', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (109, 6, TO_DATE('2026-02-07', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (110, 1, TO_DATE('2026-02-12', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (111, 4, TO_DATE('2026-02-18', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (112, 5, TO_DATE('2026-02-24', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (113, 2, TO_DATE('2026-03-01', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (114, 3, TO_DATE('2026-03-05', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (115, 1, TO_DATE('2026-03-10', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (116, 6, TO_DATE('2026-03-15', 'YYYY-MM-DD'));

INSERT INTO orders (order_id, customer_id, order_date) 
VALUES (117, 8, TO_DATE('2026-03-18', 'YYYY-MM-DD'));

-- -----------------------------------------------------------------------------
-- 4. Insert Order Items (31 order items)
-- -----------------------------------------------------------------------------
-- Order 101 (Alice)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (1, 101, 1, 3);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (2, 101, 4, 1);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (3, 101, 7, 2);

-- Order 102 (Bob)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (4, 102, 9, 1);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (5, 102, 8, 2);

-- Order 103 (Charlie)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (6, 103, 2, 4);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (7, 103, 5, 2);

-- Order 104 (Alice)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (8, 104, 6, 2);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (9, 104, 10, 1);

-- Order 105 (Diana)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (10, 105, 9, 2);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (11, 105, 7, 1);

-- Order 106 (Evan)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (12, 106, 3, 3);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (13, 106, 4, 2);

-- Order 107 (Bob)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (14, 107, 1, 5);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (15, 107, 6, 1);

-- Order 108 (Charlie)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (16, 108, 8, 1);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (17, 108, 10, 2);

-- Order 109 (Fiona)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (18, 109, 9, 1);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (19, 109, 5, 1);

-- Order 110 (Alice)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (20, 110, 2, 3);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (21, 110, 4, 1);

-- Order 111 (Diana)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (22, 111, 7, 2);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (23, 111, 1, 4);

-- Order 112 (Evan)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (24, 112, 3, 2);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (25, 112, 6, 2);

-- Order 113 (Bob)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (26, 113, 9, 2);

-- Order 114 (Charlie)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (27, 114, 5, 1);
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (28, 114, 2, 2);

-- Order 115 (Alice)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (29, 115, 10, 2);

-- Order 116 (Fiona)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (30, 116, 8, 3);

-- Order 117 (Hannah - single order customer)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES (31, 117, 9, 1);

-- Commit transaction
COMMIT;

-- Verification of inserted row counts
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;
