-- PL/SQL Assignment 1 - Sunrise Supermarket
-- 03_queries.sql: Analytical queries (JOINs, CTE, Window Functions)

SET SQLBLANKLINES ON;

-- -----------------------------------------------------------------------------
-- 1. JOIN Queries
-- -----------------------------------------------------------------------------

PROMPT 1. List every order with customer's name, city, and order date
SELECT o.order_id,
       c.customer_name,
       c.city,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date, o.order_id;

PROMPT 2. List every order item with product name, category, price, and quantity
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

PROMPT 3. List all customers and their orders (including customers with no orders)
SELECT c.customer_id,
       c.customer_name,
       c.city,
       o.order_id,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

PROMPT 3 (Verification): Customers with 0 orders
SELECT c.customer_id,
       c.customer_name,
       o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- -----------------------------------------------------------------------------
-- 2. CTE Query
-- -----------------------------------------------------------------------------

PROMPT 4. CTE: Customers above average spending
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

-- -----------------------------------------------------------------------------
-- 3. Window Function Queries
-- -----------------------------------------------------------------------------

PROMPT 5. Window 1: Rank customers by total amount spent
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
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM customer_totals
ORDER BY spending_rank;

PROMPT 6. Window 2: Number each customer's orders
SELECT o.customer_id,
       c.customer_name,
       o.order_id,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date,
       ROW_NUMBER() OVER (
           PARTITION BY o.customer_id 
           ORDER BY o.order_date, o.order_id
       ) AS customer_order_number
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.customer_id, customer_order_number;

PROMPT 7. Window 3: Running total of revenue over time
WITH daily_revenue AS (
    SELECT o.order_date,
           SUM(oi.quantity * p.price) AS revenue_for_date
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_date
)
SELECT TO_CHAR(order_date, 'DD-MON-YYYY') AS order_date,
       revenue_for_date,
       SUM(revenue_for_date) OVER (
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_revenue
FROM daily_revenue
ORDER BY order_date;

PROMPT 8. Window 4: Days between consecutive orders
WITH order_history AS (
    SELECT o.customer_id,
           c.customer_name,
           o.order_id,
           o.order_date,
           LAG(o.order_date) OVER (
               PARTITION BY o.customer_id 
               ORDER BY o.order_date, o.order_id
           ) AS previous_order_date
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
)
SELECT customer_id,
       customer_name,
       order_id,
       TO_CHAR(previous_order_date, 'DD-MON-YYYY') AS previous_order_date,
       TO_CHAR(order_date, 'DD-MON-YYYY') AS current_order_date,
       ROUND(order_date - previous_order_date) AS days_between_orders
FROM order_history
WHERE previous_order_date IS NOT NULL
ORDER BY customer_id, order_date;
