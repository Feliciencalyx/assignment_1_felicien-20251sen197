-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- Master Execution Script: run_all.sql
-- Target Database: Oracle AI Database 26ai / 23ai Free (FREEPDB1)
-- Schema / User: sunrise_user
-- =============================================================================

SET ECHO OFF
SET FEEDBACK ON
SET HEADING ON
SET LINESIZE 200
SET PAGESIZE 100
SET TAB OFF
SET WRAP ON
SET SQLBLANKLINES ON

-- Format columns for neat terminal display
COLUMN customer_id FORMAT 9999 HEADING 'Cust ID'
COLUMN customer_name FORMAT A20 HEADING 'Customer Name'
COLUMN email FORMAT A28 HEADING 'Email Address'
COLUMN city FORMAT A14 HEADING 'City'
COLUMN product_id FORMAT 9999 HEADING 'Prod ID'
COLUMN product_name FORMAT A24 HEADING 'Product Name'
COLUMN category FORMAT A16 HEADING 'Category'
COLUMN price FORMAT 999999 HEADING 'Price (RWF)'
COLUMN quantity FORMAT 9999 HEADING 'Qty'
COLUMN item_total FORMAT 999999 HEADING 'Item Total (RWF)'
COLUMN order_id FORMAT 9999 HEADING 'Order ID'
COLUMN order_item_id FORMAT 9999 HEADING 'Item ID'
COLUMN order_date FORMAT A14 HEADING 'Order Date'
COLUMN prev_order_date FORMAT A14 HEADING 'Prev Date'
COLUMN total_spent FORMAT 999999 HEADING 'Total Spent (RWF)'
COLUMN average_spend FORMAT 999999.99 HEADING 'Avg Spend (RWF)'
COLUMN spending_rank FORMAT 9999 HEADING 'Rank'
COLUMN dense_spending_rank FORMAT 9999 HEADING 'Dense Rank'
COLUMN customer_order_seq FORMAT 9999 HEADING 'Order #'
COLUMN order_total FORMAT 999999 HEADING 'Order Total (RWF)'
COLUMN running_total_revenue FORMAT 999999 HEADING 'Running Total (RWF)'
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
PROMPT EXECUTION COMPLETE! ALL TESTS PASSED SUCCESSFULLY.
PROMPT =========================================================================
