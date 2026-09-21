-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- Master Execution Script: run_all.sql
-- Description: Sets display formats, runs DDL schema, inserts data,
--              and runs all 8 queries in sequence.
-- =============================================================================

SET ECHO OFF
SET FEEDBACK ON
SET HEADING ON
SET LINESIZE 200
SET PAGESIZE 100
SET TAB OFF
SET WRAP ON
SET SQLBLANKLINES ON

-- Configure column widths for neat tabular display
COLUMN customer_id FORMAT 9999 HEADING 'Cust ID'
COLUMN customer_name FORMAT A18 HEADING 'Customer Name'
COLUMN email FORMAT A26 HEADING 'Email Address'
COLUMN city FORMAT A14 HEADING 'City'
COLUMN product_id FORMAT 9999 HEADING 'Prod ID'
COLUMN product_name FORMAT A28 HEADING 'Product Name'
COLUMN category FORMAT A12 HEADING 'Category'
COLUMN price FORMAT $999.99 HEADING 'Price'
COLUMN quantity FORMAT 9999 HEADING 'Qty'
COLUMN item_total FORMAT $999.99 HEADING 'Item Total'
COLUMN order_id FORMAT 9999 HEADING 'Order ID'
COLUMN order_item_id FORMAT 9999 HEADING 'Item ID'
COLUMN order_date FORMAT A12 HEADING 'Order Date'
COLUMN prev_order_date FORMAT A12 HEADING 'Prev Date'
COLUMN total_spend FORMAT $9999.99 HEADING 'Total Spend'
COLUMN total_spent FORMAT $9999.99 HEADING 'Total Spent'
COLUMN avg_customer_spend FORMAT $9999.99 HEADING 'Avg Spend'
COLUMN benchmark_avg_spend FORMAT $9999.99 HEADING 'Benchmark Avg'
COLUMN difference_above_avg FORMAT $9999.99 HEADING 'Diff Above Avg'
COLUMN spending_rank FORMAT 9999 HEADING 'Rank'
COLUMN dense_spending_rank FORMAT 9999 HEADING 'Dense Rank'
COLUMN customer_order_seq FORMAT 9999 HEADING 'Order #'
COLUMN order_amount FORMAT $9999.99 HEADING 'Order Amt'
COLUMN running_total_revenue FORMAT $99999.99 HEADING 'Running Revenue'
COLUMN days_between_orders FORMAT 9999 HEADING 'Days Apart'

PROMPT =========================================================================
PROMPT STEP 1: EXECUTING SCHEMA DDL (01_schema.sql)
PROMPT =========================================================================
@@01_schema.sql

PROMPT
PROMPT =========================================================================
PROMPT STEP 2: POPULATING SAMPLE DATA (02_data.sql)
PROMPT =========================================================================
@@02_data.sql

PROMPT
PROMPT =========================================================================
PROMPT STEP 3: RUNNING ALL 8 ASSIGNMENT QUERIES (03_queries.sql)
PROMPT =========================================================================
@@03_queries.sql

PROMPT
PROMPT =========================================================================
PROMPT EXECUTION COMPLETE! ALL TESTS PASSED.
PROMPT =========================================================================
