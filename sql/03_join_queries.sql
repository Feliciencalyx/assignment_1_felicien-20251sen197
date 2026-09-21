-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: sql/03_join_queries.sql
-- Description: JOIN Queries 1, 2, and 3
-- =============================================================================

SET SQLBLANKLINES ON;

PROMPT =========================================================================
PROMPT JOIN QUERY 1: List every order with customer's name, city, and order date
PROMPT =========================================================================
SELECT o.order_id,
       c.customer_name,
       c.city,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date, o.order_id;

PROMPT =========================================================================
PROMPT JOIN QUERY 2: List every order item with product name, category, price, and quantity
PROMPT =========================================================================
SELECT oi.order_item_id,
       oi.order_id,
       p.product_name,
       p.category,
       p.price,
       oi.quantity,
       (p.price * oi.quantity) AS item_total
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;

PROMPT =========================================================================
PROMPT JOIN QUERY 3: List all customers and orders (including customers with no orders)
PROMPT =========================================================================
SELECT c.customer_id,
       c.customer_name,
       c.city,
       o.order_id,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

PROMPT =========================================================================
PROMPT JOIN QUERY 3 (Edge-Case Verification): Customers without orders
PROMPT =========================================================================
SELECT c.customer_id,
       c.customer_name,
       o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
