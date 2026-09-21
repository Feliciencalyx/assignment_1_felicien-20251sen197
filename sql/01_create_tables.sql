-- =============================================================================
-- PL/SQL Assignment One - Sunrise Supermarket
-- File: 01_schema.sql
-- Description: Drop existing tables (if any) and create the 4 required tables:
--              1. customers
--              2. products
--              3. orders
--              4. order_items
-- Target Database: Oracle Database (FREEPDB1)
-- =============================================================================

-- Clean up existing tables in reverse dependency order
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE order_items CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE orders CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE products CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- -----------------------------------------------------------------------------
-- 1. Customers Table
-- -----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    email         VARCHAR2(100) UNIQUE,
    city          VARCHAR2(50)
);

-- -----------------------------------------------------------------------------
-- 2. Products Table
-- -----------------------------------------------------------------------------
CREATE TABLE products (
    product_id   NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    category     VARCHAR2(50)  NOT NULL,
    price        NUMBER(10,2)  NOT NULL,
    CONSTRAINT chk_product_price CHECK (price >= 0)
);

-- -----------------------------------------------------------------------------
-- 3. Orders Table
-- -----------------------------------------------------------------------------
CREATE TABLE orders (
    order_id    NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    order_date  DATE   NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- -----------------------------------------------------------------------------
-- 4. Order Items Table
-- -----------------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id NUMBER PRIMARY KEY,
    order_id      NUMBER NOT NULL,
    product_id    NUMBER NOT NULL,
    quantity      NUMBER NOT NULL,
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT chk_item_quantity
        CHECK (quantity > 0)
);

-- Verify tables created
SELECT table_name FROM user_tables 
WHERE table_name IN ('CUSTOMERS', 'PRODUCTS', 'ORDERS', 'ORDER_ITEMS') 
ORDER BY table_name;
