-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: 02_data.sql
-- Description: Populates sample data meeting and exceeding all requirements:
--              - 6 Customers (including multi-order buyers & 1 zero-order customer)
--              - 10 Products across 4 categories (Food, Beverages, Household, Personal Care)
--              - 15 Orders across August - September 2026
--              - 30 Order Items
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Customers (6 rows)
-- -----------------------------------------------------------------------------
INSERT INTO customers VALUES (1, 'Alice Uwase', 'alice.uwase@gmail.com', 'Kigali');
INSERT INTO customers VALUES (2, 'Eric Mugisha', 'eric.mugisha@gmail.com', 'Musanze');
INSERT INTO customers VALUES (3, 'Grace Mukamana', 'grace.mukamana@gmail.com', 'Huye');
INSERT INTO customers VALUES (4, 'Patrick Niyonzima', 'patrick.niyonzima@gmail.com', 'Rubavu');
INSERT INTO customers VALUES (5, 'Diane Ingabire', 'diane.ingabire@gmail.com', 'Kigali');
INSERT INTO customers VALUES (6, 'Samuel Habimana', 'samuel.habimana@gmail.com', 'Muhanga');

-- -----------------------------------------------------------------------------
-- 2. Products (10 rows across 4 categories: Food, Beverages, Household, Personal Care)
-- -----------------------------------------------------------------------------
INSERT INTO products VALUES (101, 'Rice 5kg', 'Food', 8500.00);
INSERT INTO products VALUES (102, 'Cooking Oil 1L', 'Food', 3500.00);
INSERT INTO products VALUES (103, 'Sugar 1kg', 'Food', 1800.00);
INSERT INTO products VALUES (104, 'Bread', 'Food', 1200.00);
INSERT INTO products VALUES (105, 'Milk 1L', 'Beverages', 1500.00);
INSERT INTO products VALUES (106, 'Orange Juice 1L', 'Beverages', 3000.00);
INSERT INTO products VALUES (107, 'Bottled Water', 'Beverages', 700.00);
INSERT INTO products VALUES (108, 'Laundry Soap', 'Household', 2200.00);
INSERT INTO products VALUES (109, 'Dishwashing Liquid', 'Household', 2800.00);
INSERT INTO products VALUES (110, 'Toothpaste', 'Personal Care', 2500.00);

-- -----------------------------------------------------------------------------
-- 3. Orders (15 rows)
-- -----------------------------------------------------------------------------
INSERT ALL
  INTO orders VALUES (1001, 1, DATE '2026-08-01')
  INTO orders VALUES (1002, 2, DATE '2026-08-02')
  INTO orders VALUES (1003, 3, DATE '2026-08-04')
  INTO orders VALUES (1004, 4, DATE '2026-08-05')
  INTO orders VALUES (1005, 5, DATE '2026-08-07')
  INTO orders VALUES (1006, 1, DATE '2026-08-10')
  INTO orders VALUES (1007, 2, DATE '2026-08-12')
  INTO orders VALUES (1008, 3, DATE '2026-08-15')
  INTO orders VALUES (1009, 4, DATE '2026-08-17')
  INTO orders VALUES (1010, 5, DATE '2026-08-20')
  INTO orders VALUES (1011, 1, DATE '2026-08-23')
  INTO orders VALUES (1012, 2, DATE '2026-08-25')
  INTO orders VALUES (1013, 3, DATE '2026-08-28')
  INTO orders VALUES (1014, 4, DATE '2026-09-02')
  INTO orders VALUES (1015, 5, DATE '2026-09-05')
SELECT 1 FROM dual;

-- -----------------------------------------------------------------------------
-- 4. Order Items (30 rows)
-- -----------------------------------------------------------------------------
INSERT INTO order_items VALUES (1, 1001, 101, 2);
INSERT INTO order_items VALUES (2, 1001, 105, 3);
INSERT INTO order_items VALUES (3, 1002, 102, 2);
INSERT INTO order_items VALUES (4, 1002, 108, 1);
INSERT INTO order_items VALUES (5, 1003, 103, 4);
INSERT INTO order_items VALUES (6, 1003, 106, 2);
INSERT INTO order_items VALUES (7, 1004, 104, 3);
INSERT INTO order_items VALUES (8, 1004, 109, 2);
INSERT INTO order_items VALUES (9, 1005, 101, 1);
INSERT INTO order_items VALUES (10, 1005, 110, 2);
INSERT INTO order_items VALUES (11, 1006, 102, 3);
INSERT INTO order_items VALUES (12, 1006, 107, 5);
INSERT INTO order_items VALUES (13, 1007, 101, 2);
INSERT INTO order_items VALUES (14, 1007, 103, 3);
INSERT INTO order_items VALUES (15, 1008, 105, 4);
INSERT INTO order_items VALUES (16, 1008, 108, 2);
INSERT INTO order_items VALUES (17, 1009, 106, 3);
INSERT INTO order_items VALUES (18, 1009, 110, 1);
INSERT INTO order_items VALUES (19, 1010, 104, 5);
INSERT INTO order_items VALUES (20, 1010, 109, 2);
INSERT INTO order_items VALUES (21, 1011, 101, 3);
INSERT INTO order_items VALUES (22, 1011, 102, 2);
INSERT INTO order_items VALUES (23, 1012, 103, 5);
INSERT INTO order_items VALUES (24, 1012, 107, 6);
INSERT INTO order_items VALUES (25, 1013, 105, 3);
INSERT INTO order_items VALUES (26, 1013, 106, 2);
INSERT INTO order_items VALUES (27, 1014, 108, 4);
INSERT INTO order_items VALUES (28, 1014, 109, 2);
INSERT INTO order_items VALUES (29, 1015, 101, 2);
INSERT INTO order_items VALUES (30, 1015, 110, 3);

-- Permanent commit of transaction
COMMIT;

-- Row verification
SELECT 
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items
FROM dual;
