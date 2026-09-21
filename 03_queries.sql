-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: 03_queries.sql
-- Description: Complete analytical queries required by the assignment:
--              1. JOIN Query 1 (INNER JOIN: orders + customers)
--              2. JOIN Query 2 (JOIN: order_items + products)
--              3. JOIN Query 3 (LEFT JOIN: customers + orders)
--              4. CTE Query 1 (Calculate total spend & filter above average)
--              5. Window Query 1 (Rank customers by total spend)
--              6. Window Query 2 (Number each customer's orders sequentially)
--              7. Window Query 3 (Running total of revenue over time)
--              8. Window Query 4 (Days between current & previous order for repeat buyers)
-- =============================================================================

SET SQLBLANKLINES ON;

-- =============================================================================
-- 1. JOIN QUERIES
-- =============================================================================

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

-- Verification of the zero-order customer edge case
PROMPT =========================================================================
PROMPT JOIN QUERY 3 (Edge-Case Check): Verify customers without orders appear
PROMPT =========================================================================
SELECT c.customer_id,
       c.customer_name,
       o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- =============================================================================
-- 2. CTE QUERY
-- =============================================================================

PROMPT =========================================================================
PROMPT CTE QUERY 1: Customer total spend and customers spending above average
PROMPT =========================================================================
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           NVL(SUM(oi.quantity * p.price), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       total_spent,
       ROUND((SELECT AVG(total_spent) FROM customer_totals), 2) AS average_spend
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
ORDER BY total_spent DESC;

-- =============================================================================
-- 3. WINDOW-FUNCTION QUERIES
-- =============================================================================

PROMPT =========================================================================
PROMPT WINDOW QUERY 1: Rank customers by total amount spent, highest first
PROMPT =========================================================================
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           NVL(SUM(oi.quantity * p.price), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank,
       DENSE_RANK() OVER (ORDER BY total_spent DESC) AS dense_spending_rank
FROM customer_totals
ORDER BY spending_rank, customer_id;

PROMPT =========================================================================
PROMPT WINDOW QUERY 2: Number each customer's orders in the order placed
PROMPT =========================================================================
SELECT o.order_id,
       o.customer_id,
       c.customer_name,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date,
       ROW_NUMBER() OVER (
           PARTITION BY o.customer_id 
           ORDER BY o.order_date, o.order_id
       ) AS customer_order_seq
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.customer_id, customer_order_seq;

PROMPT =========================================================================
PROMPT WINDOW QUERY 3: Show a running total of revenue over time, ordered by order date
PROMPT =========================================================================
WITH order_revenue AS (
    SELECT o.order_id,
           o.order_date,
           c.customer_name,
           SUM(oi.quantity * p.price) AS order_total
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.order_date, c.customer_name
)
SELECT order_id,
       TO_CHAR(order_date, 'DD-MON-YYYY') AS order_date,
       customer_name,
       order_total,
       SUM(order_total) OVER (
           ORDER BY order_date, order_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_revenue
FROM order_revenue
ORDER BY order_date, order_id;

PROMPT =========================================================================
PROMPT WINDOW QUERY 4: Days between current and previous order (repeat buyers)
PROMPT =========================================================================
WITH repeat_customers AS (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
),
ordered_history AS (
    SELECT o.order_id,
           o.customer_id,
           c.customer_name,
           o.order_date,
           LAG(o.order_date, 1) OVER (
               PARTITION BY o.customer_id 
               ORDER BY o.order_date, o.order_id
           ) AS prev_order_date
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.customer_id IN (SELECT customer_id FROM repeat_customers)
)
SELECT order_id,
       customer_id,
       customer_name,
       TO_CHAR(order_date, 'DD-MON-YYYY') AS order_date,
       TO_CHAR(prev_order_date, 'DD-MON-YYYY') AS prev_order_date,
       ROUND(order_date - prev_order_date) AS days_between_orders
FROM ordered_history
ORDER BY customer_id, order_date;
