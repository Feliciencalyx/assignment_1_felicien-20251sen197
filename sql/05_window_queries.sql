-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: sql/05_window_queries.sql
-- Description: Window-Function Queries 1, 2, 3, and 4
-- =============================================================================

SET SQLBLANKLINES ON;

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
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM customer_totals
ORDER BY spending_rank;

PROMPT =========================================================================
PROMPT WINDOW QUERY 2: Number each customer's orders
PROMPT =========================================================================
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

PROMPT =========================================================================
PROMPT WINDOW QUERY 3: Running total of revenue over time
PROMPT =========================================================================
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

PROMPT =========================================================================
PROMPT WINDOW QUERY 4: Days between consecutive orders
PROMPT =========================================================================
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
