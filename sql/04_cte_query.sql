-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: sql/04_cte_query.sql
-- Description: CTE Query - Customer total spend and above average spenders
-- =============================================================================

SET SQLBLANKLINES ON;

PROMPT =========================================================================
PROMPT CTE QUERY: Customer total spend and customers spending above average
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
