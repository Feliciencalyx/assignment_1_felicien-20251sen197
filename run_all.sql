-- PL/SQL Assignment 1 - Sunrise Supermarket
-- Master execution script: run_all.sql
-- Database: Oracle Database 23ai Free (FREEPDB1)
-- Schema: sunrise_user

SET ECHO OFF
SET FEEDBACK ON
SET HEADING ON
SET LINESIZE 200
SET PAGESIZE 100
SET TAB OFF
SET WRAP ON
SET SQLBLANKLINES ON

-- Column formatting for clean terminal output
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
COLUMN previous_order_date FORMAT A14 HEADING 'Prev Date'
COLUMN current_order_date FORMAT A14 HEADING 'Order Date'
COLUMN total_spent FORMAT 999999 HEADING 'Total Spent (RWF)'
COLUMN average_spend FORMAT 999999.99 HEADING 'Avg Spend (RWF)'
COLUMN spending_rank FORMAT 9999 HEADING 'Rank'
COLUMN customer_order_number FORMAT 9999 HEADING 'Order #'
COLUMN revenue_for_date FORMAT 999999 HEADING 'Daily Revenue (RWF)'
COLUMN running_revenue FORMAT 999999 HEADING 'Running Total (RWF)'
COLUMN days_between_orders FORMAT 9999 HEADING 'Days Apart'

PROMPT
PROMPT 1. Creating tables (01_schema.sql)...
@@01_schema.sql

PROMPT
PROMPT 2. Inserting sample data (02_data.sql)...
@@02_data.sql

PROMPT
PROMPT 3. Running analytical queries (03_queries.sql)...
@@03_queries.sql

PROMPT
PROMPT Done. All scripts executed successfully.
