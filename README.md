# PL/SQL Assignment One — Sunrise Supermarket

## Student Details
* **Name:** Nshimyumukiza Felicien
* **Student ID:** `20251SEN197`
* **Course:** Advanced Database Systems / PL/SQL
* **Group:** Group B / Group C / Group I / Group D
* **DBMS Used:** Oracle AI Database 26ai Free
* **Client Tool:** SQL*Plus & Oracle SQL Developer
* **Pluggable Database:** `FREEPDB1`
* **Schema User:** `SUNRISE_USER`
* **Repository Name:** `assignment_1_felicien-20251sen197`

---

## 1. Project Summary

This project implements a relational database for **Sunrise Supermarket**, a grocery store operating in Rwanda (with customers across Kigali, Musanze, Huye, Rubavu, and Muhanga). The database tracks customers, supermarket products, customer orders, and individual order items.

After creating and populating the tables, SQL queries were written and executed using:
* **INNER JOIN** and **LEFT JOIN**
* **Common Table Expression (CTE)**
* **Window Functions** (`RANK`, `ROW_NUMBER`, `SUM() OVER`, and `LAG`)

The queries answer key business questions about top-spending customers, popular items, order sequences, daily revenue growth, and days between repeat purchases.

---

## 2. Business Scenario

Sunrise Supermarket sells everyday retail goods including food items (Rice, Cooking Oil, Sugar, Bread), beverages (Milk, Juice, Water), household items (Soap, Detergent), and personal care products (Toothpaste).

Store management needs clear reports from the database to answer these questions:
1. **Who are the highest-spending customers?** So marketing can offer them loyalty rewards.
2. **What items are being bought in each order?** To monitor stock levels and popular product combinations.
3. **Are there registered customers who have never bought anything?** So the store can send them a welcome discount.
4. **How is sales revenue growing over time?** To track running daily sales totals.
5. **How often do repeat customers return?** To see the average number of days between customer orders.

---

## 3. Database Schema Design

The database has four normalized tables:

| Table Name | Description | Primary Key | Foreign Keys |
|---|---|---|---|
| **`customers`** | Stores customer name, email, and city | `customer_id` | None |
| **`products`** | Stores product catalog, category, and price (RWF) | `product_id` | None |
| **`orders`** | Stores orders placed by customers and order dates | `order_id` | `customer_id` → `customers` |
| **`order_items`** | Stores products and quantities in each order | `order_item_id` | `order_id` → `orders`, `product_id` → `products` |

```mermaid
erDiagram
    CUSTOMERS ||--o{ ORDERS : places
    CUSTOMERS {
        NUMBER customer_id PK
        VARCHAR2 customer_name
        VARCHAR2 email
        VARCHAR2 city
    }
    ORDERS ||--|{ ORDER_ITEMS : contains
    ORDERS {
        NUMBER order_id PK
        NUMBER customer_id FK
        DATE order_date
    }
    PRODUCTS ||--o{ ORDER_ITEMS : contains
    PRODUCTS {
        NUMBER product_id PK
        VARCHAR2 product_name
        VARCHAR2 category
        NUMBER price
    }
    ORDER_ITEMS {
        NUMBER order_item_id PK
        NUMBER order_id FK
        NUMBER product_id FK
        NUMBER quantity
    }
```

---

## 4. Setup and Screenshots

All steps were executed in Oracle Database using SQL*Plus connected to the `FREEPDB1` pluggable database.

### 4.1 Connecting to `FREEPDB1`
First, switch from the root container to the pluggable database `FREEPDB1`:
```sql
SHOW PDBS;
ALTER SESSION SET CONTAINER = FREEPDB1;
```
![Switch PDB to FREEPDB1](screenshots/switch%20pdb%20to%20freepdb1.png)

Verify current user and container:
```sql
SELECT USER AS current_user, 
       SYS_CONTEXT('USERENV', 'CON_NAME') AS container_name 
FROM dual;
```
![Select Current FREEPDB1 User](screenshots/select%20curent%20freepdb1%20user.png)

---

### 4.2 Creating the User and Granting Permissions
Create `sunrise_user` with unlimited quota on `USERS`:
```sql
CREATE USER sunrise_user
IDENTIFIED BY Sunrise123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;
```
![Create User](screenshots/creating%20user.png)

Grant required privileges:
```sql
GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE SEQUENCE,
      CREATE PROCEDURE
TO sunrise_user;
```
![Grant Permissions](screenshots/grant%20user%20permissions.png)

Verify user exists:
```sql
SELECT username FROM dba_users WHERE username = 'SUNRISE_USER';
```
![Verify User Existence](screenshots/verify%20user%20existance.png)

Connect directly as `sunrise_user`:
```sql
CONNECT sunrise_user/Sunrise123@localhost:1521/FREEPDB1
```
![Connect to Sunrise User](screenshots/connect%20to%20sunriser.png)

---

### 4.3 Creating the Tables
```sql
CREATE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    email         VARCHAR2(100) UNIQUE,
    city          VARCHAR2(50)
);

CREATE TABLE products (
    product_id   NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    category     VARCHAR2(50)  NOT NULL,
    price        NUMBER(10,2)  NOT NULL,
    CONSTRAINT chk_product_price CHECK (price >= 0)
);

CREATE TABLE orders (
    order_id    NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    order_date  DATE   NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

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
```
![Table Creation](screenshots/table%20created.png)

---

## 5. Data Population Summary

The database was populated with sample data exceeding the minimum assignment requirements:

| Entity | Required Minimum | Inserted | Notes |
|---|---|---|---|
| **Customers** | At least 5 | **6** | 5 active customers + 1 customer with 0 orders |
| **Products** | At least 8 | **10** | 4 categories: Food, Beverages, Household, Personal Care |
| **Orders** | At least 15 | **15** | Dates between 01-AUG-2026 and 05-SEP-2026 |
| **Order Items** | At least 25 | **30** | Multiple items per order, prices in RWF |

### Data Insertion Details & Screenshots

#### 1. Customers (6 rows)
```sql
INSERT INTO customers VALUES (1, 'Alice Uwase', 'alice.uwase@gmail.com', 'Kigali');
INSERT INTO customers VALUES (2, 'Eric Mugisha', 'eric.mugisha@gmail.com', 'Musanze');
INSERT INTO customers VALUES (3, 'Grace Mukamana', 'grace.mukamana@gmail.com', 'Huye');
INSERT INTO customers VALUES (4, 'Patrick Niyonzima', 'patrick.niyonzima@gmail.com', 'Rubavu');
INSERT INTO customers VALUES (5, 'Diane Ingabire', 'diane.ingabire@gmail.com', 'Kigali');
INSERT INTO customers VALUES (6, 'Samuel Habimana', 'samuel.habimana@gmail.com', 'Muhanga');
```
![Insert Customers](screenshots/user%20insert.png)

---

#### 2. Products (10 rows across 4 categories)
```sql
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
```
![Insert Products](screenshots/product%20insertion.png)

Count verification:
![Count for Products](screenshots/count%20for%20products.png)

---

#### 3. Orders (15 rows)
```sql
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
```
![Insert Orders](screenshots/insert%20into%2015%20rows.png)

Count verification:
![Count for Orders](screenshots/order%20count.png)

---

#### 4. Order Items (30 rows)
```sql
INSERT INTO order_items VALUES (1, 1001, 101, 2);
INSERT INTO order_items VALUES (2, 1001, 105, 3);
...
INSERT INTO order_items VALUES (30, 1015, 110, 3);
COMMIT;
```
![Insert Order Items](screenshots/orders%20inserted.png)

Count verification:
![Order Items Count](screenshots/order%20items%20inserted.png)

---

#### 5. Full Database Verification
```sql
SELECT 
  (SELECT COUNT(*) FROM customers) AS customers,
  (SELECT COUNT(*) FROM products) AS products,
  (SELECT COUNT(*) FROM orders) AS orders,
  (SELECT COUNT(*) FROM order_items) AS order_items
FROM dual;
```
![Full Database Count](screenshots/full%20database%20count.png)

---

## 6. Analytical Queries, Screenshots & Interpretations

---

### JOIN Query 1: Every order with customer name, city, and date
#### SQL Code
```sql
SELECT o.order_id,
       c.customer_name,
       c.city,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.customer_id
ORDER BY o.order_date, o.order_id;
```

#### Explanation
An `INNER JOIN` matches each order in `orders` to its customer in `customers` using `customer_id`. Only customers who have placed orders appear in this list.

#### Screenshot & Output
![Order Joined with Customers](screenshots/Order%20joined%20with%20customers.png)

```text
  ORDER_ID CUSTOMER_NAME        CITY       ORDER_DATE
---------- -------------------- ---------- -----------
      1001 Alice Uwase          Kigali     01-AUG-2026
      1002 Eric Mugisha         Musanze    02-AUG-2026
      1003 Grace Mukamana       Huye       04-AUG-2026
      1004 Patrick Niyonzima    Rubavu     05-AUG-2026
      1005 Diane Ingabire       Kigali     07-AUG-2026
      1006 Alice Uwase          Kigali     10-AUG-2026
      1007 Eric Mugisha         Musanze    12-AUG-2026
      1008 Grace Mukamana       Huye       15-AUG-2026
      1009 Patrick Niyonzima    Rubavu     17-AUG-2026
      1010 Diane Ingabire       Kigali     20-AUG-2026
      1011 Alice Uwase          Kigali     23-AUG-2026
      1012 Eric Mugisha         Musanze    25-AUG-2026
      1013 Grace Mukamana       Huye       28-AUG-2026
      1014 Patrick Niyonzima    Rubavu     02-SEP-2026
      1015 Diane Ingabire       Kigali     05-SEP-2026

15 rows selected.
```

#### Business Interpretation
This query acts as the order delivery log. It helps store managers and delivery staff see where each order needs to go (Kigali, Musanze, Huye, Rubavu) and shows steady ordering from early August to September.

---

### JOIN Query 2: Every order item with product details and quantity
#### SQL Code
```sql
SELECT oi.order_item_id,
       oi.order_id,
       p.product_name,
       p.category,
       p.price,
       oi.quantity,
       (p.price * oi.quantity) AS item_total
FROM order_items oi
INNER JOIN products p
  ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;
```

#### Explanation
This query joins `order_items` and `products` using `product_id` to display the product name, category, unit price, and quantity for every line item, calculating `item_total = price * quantity`.

#### Screenshot & Output
![Order Items Joined with Products](screenshots/Order%20items%20joined%20with%20products..png)

```text
ORDER_ITEM_ID   ORDER_ID PRODUCT_NAME            CATEGORY          PRICE  QUANTITY ITEM_TOTAL
------------- ---------- ----------------------- ------------- --------- --------- ----------
            1       1001 Rice 5kg                Food               8500         2      17000
            2       1001 Milk 1L                 Beverages          1500         3       4500
            3       1002 Cooking Oil 1L          Food               3500         2       7000
            4       1002 Laundry Soap            Household          2200         1       2200
            5       1003 Sugar 1kg               Food               1800         4       7200
            6       1003 Orange Juice 1L         Beverages          3000         2       6000
            7       1004 Bread                   Food               1200         3       3600
            8       1004 Dishwashing Liquid      Household          2800         2       5600
            9       1005 Rice 5kg                Food               8500         1       8500
           10       1005 Toothpaste              Personal Care      2500         2       5000
           11       1006 Cooking Oil 1L          Food               3500         3      10500
           12       1006 Bottled Water           Beverages           700         5       3500
           13       1007 Rice 5kg                Food               8500         2      17000
           14       1007 Sugar 1kg               Food               1800         3       5400
           15       1008 Milk 1L                 Beverages          1500         4       6000
           16       1008 Laundry Soap            Household          2200         2       4400
           17       1009 Orange Juice 1L         Beverages          3000         3       9000
           18       1009 Toothpaste              Personal Care      2500         1       2500
           19       1010 Bread                   Food               1200         5       6000
           20       1010 Dishwashing Liquid      Household          2800         2       5600
           21       1011 Rice 5kg                Food               8500         3      25500
           22       1011 Cooking Oil 1L          Food               3500         2       7000
           23       1012 Sugar 1kg               Food               1800         5       9000
           24       1012 Bottled Water           Beverages           700         6       4200
           25       1013 Milk 1L                 Beverages          1500         3       4500
           26       1013 Orange Juice 1L         Beverages          3000         2       6000
           27       1014 Laundry Soap            Household          2200         4       8800
           28       1014 Dishwashing Liquid      Household          2800         2       5600
           29       1015 Rice 5kg                Food               8500         2      17000
           30       1015 Toothpaste              Personal Care      2500         3       7500

30 rows selected.
```

#### Business Interpretation
This shows the contents of every shopping basket. High-value staples like Rice 5kg bring in substantial revenue per sale (up to RWF 25,500), while frequent items like Milk and Bread keep daily sales steady.

---

### JOIN Query 3: All customers and their orders (including customers with no orders)
#### SQL Code
```sql
SELECT c.customer_id,
       c.customer_name,
       c.city,
       o.order_id,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
```

#### Explanation
A `LEFT JOIN` keeps all records from `customers`, even when there is no matching order in `orders`. For customer 6 (Samuel Habimana), the `order_id` and `order_date` columns appear as `NULL`.

#### Screenshot & Output
![All Customers and Their Orders](screenshots/All%20customers%20and%20their%20orders.png)

```text
CUSTOMER_ID CUSTOMER_NAME        CITY       ORDER_ID ORDER_DATE
----------- -------------------- ---------- -------- -----------
          1 Alice Uwase          Kigali         1001 01-AUG-2026
          1 Alice Uwase          Kigali         1006 10-AUG-2026
          1 Alice Uwase          Kigali         1011 23-AUG-2026
          2 Eric Mugisha         Musanze        1002 02-AUG-2026
          2 Eric Mugisha         Musanze        1007 12-AUG-2026
          2 Eric Mugisha         Musanze        1012 25-AUG-2026
          3 Grace Mukamana       Huye           1003 04-AUG-2026
          3 Grace Mukamana       Huye           1008 15-AUG-2026
          3 Grace Mukamana       Huye           1013 28-AUG-2026
          4 Patrick Niyonzima    Rubavu         1004 05-AUG-2026
          4 Patrick Niyonzima    Rubavu         1009 17-AUG-2026
          4 Patrick Niyonzima    Rubavu         1014 02-SEP-2026
          5 Diane Ingabire       Kigali         1005 07-AUG-2026
          5 Diane Ingabire       Kigali         1010 20-AUG-2026
          5 Diane Ingabire       Kigali         1015 05-SEP-2026
          6 Samuel Habimana      Muhanga

16 rows selected.
```

#### Verification of Customer Without Orders
```sql
SELECT c.customer_id,
       c.customer_name,
       o.order_id
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```
![Customer Without Orders](screenshots/Verify%20that%20the%20customer%20without%20orders%20appears.png)

#### Business Interpretation
This query reveals that Samuel Habimana registered in Muhanga but has never placed an order. Management can send him a first-time shopper voucher to encourage him to make his first purchase.

---

### CTE Query: Customers spending above average
#### SQL Code
```sql
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
```

#### Explanation
The CTE `customer_totals` calculates each customer's total spending (`quantity * price`). `LEFT JOIN` and `NVL()` ensure Samuel Habimana is included with 0 RWF. The outer query finds the store average spend (RWF 38,600) and returns only the customers whose total spending is above this average.

#### Screenshot & Output
![Every Customer Total](screenshots/every%20customers%20total.png)

```text
CUSTOMER_ID CUSTOMER_NAME        TOTAL_SPENT AVERAGE_SPEND
----------- -------------------- ----------- -------------
          1 Alice Uwase                68000         38600
          5 Diane Ingabire             49600         38600
          2 Eric Mugisha               44800         38600

3 rows selected.
```

Full customer spending summary from SQL*Plus:
```text
CUSTOMER_ID CUSTOMER_NAME        TOTAL_SPENT
----------- -------------------- -----------
          1 Alice Uwase                68000
          5 Diane Ingabire             49600
          2 Eric Mugisha               44800
          4 Patrick Niyonzima          35100
          3 Grace Mukamana             34100
          6 Samuel Habimana                0
Total: 231,600 RWF / 6 customers = 38,600 RWF average.
```

#### Business Interpretation
Alice Uwase, Diane Ingabire, and Eric Mugisha are top spenders who generate over 70% of total supermarket sales (RWF 162,400 out of RWF 231,600). They should receive VIP loyalty benefits and special discounts to maintain their repeat business.

---

### Window Query 1: Rank customers by total amount spent
#### SQL Code
```sql
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
```

#### Explanation
`RANK() OVER (ORDER BY total_spent DESC)` sorts customers by total amount spent in descending order and assigns each a position from 1 to 6.

#### Output
```text
Cust ID Customer Name        Total Spent (RWF)  Rank
------- -------------------- ----------------- -----
      1 Alice Uwase                      68000     1
      5 Diane Ingabire                   49600     2
      2 Eric Mugisha                     44800     3
      4 Patrick Niyonzima                35100     4
      3 Grace Mukamana                   34100     5
      6 Samuel Habimana                      0     6

6 rows selected.
```

#### Business Interpretation
This ranks each customer clearly by value. Alice Uwase is #1, followed by Diane and Eric.

---

### Window Query 2: Number each customer's orders
#### SQL Code
```sql
SELECT o.customer_id,
       c.customer_name,
       o.order_id,
       TO_CHAR(o.order_date, 'DD-MON-YYYY') AS order_date,
       ROW_NUMBER() OVER (
           PARTITION BY o.customer_id
           ORDER BY o.order_date, o.order_id
       ) AS customer_order_number
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.customer_id
ORDER BY o.customer_id, customer_order_number;
```

#### Explanation
`ROW_NUMBER()` numbers orders chronologically. `PARTITION BY o.customer_id` resets the counter back to 1 for each customer.

#### Output
```text
Cust ID Customer Name        Order ID Order Date     Order #
------- -------------------- -------- -------------- -------
      1 Alice Uwase              1001 01-AUG-2026          1
      1 Alice Uwase              1006 10-AUG-2026          2
      1 Alice Uwase              1011 23-AUG-2026          3
      2 Eric Mugisha             1002 02-AUG-2026          1
      2 Eric Mugisha             1007 12-AUG-2026          2
      2 Eric Mugisha             1012 25-AUG-2026          3
      3 Grace Mukamana           1003 04-AUG-2026          1
      3 Grace Mukamana           1008 15-AUG-2026          2
      3 Grace Mukamana           1013 28-AUG-2026          3
      4 Patrick Niyonzima        1004 05-AUG-2026          1
      4 Patrick Niyonzima        1009 17-AUG-2026          2
      4 Patrick Niyonzima        1014 02-SEP-2026          3
      5 Diane Ingabire           1005 07-AUG-2026          1
      5 Diane Ingabire           1010 20-AUG-2026          2
      5 Diane Ingabire           1015 05-SEP-2026          3

15 rows selected.
```

#### Business Interpretation
This allows the supermarket to identify whether an order is a customer's first purchase (`Order # = 1`) or a repeat order (`Order # >= 2`), helping evaluate customer retention.

---

### Window Query 3: Running total of revenue over time
#### SQL Code
```sql
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
```

#### Explanation
The CTE sums the sales revenue for each date. The windowed `SUM() OVER (...)` adds up each day's revenue cumulatively from the first date to the current date.

#### Output
```text
Order Date     Daily Revenue (RWF) Running Total (RWF)
-------------- ------------------- -------------------
01-AUG-2026                  21500               21500
02-AUG-2026                   9200               30700
04-AUG-2026                  13200               43900
05-AUG-2026                   9200               53100
07-AUG-2026                  13500               66600
10-AUG-2026                  14000               80600
12-AUG-2026                  22400              103000
15-AUG-2026                  10400              113400
17-AUG-2026                  11500              124900
20-AUG-2026                  11600              136500
23-AUG-2026                  32500              169000
25-AUG-2026                  13200              182200
28-AUG-2026                  10500              192700
02-SEP-2026                  14400              207100
05-SEP-2026                  24500              231600

15 rows selected.
```

#### Business Interpretation
This running total shows steady revenue growth from RWF 21,500 on August 1 to RWF 231,600 by September 5. Store management can check this report daily to verify sales pace against monthly targets.

---

### Window Query 4: Days between consecutive orders
#### SQL Code
```sql
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
```

#### Explanation
`LAG()` fetches the previous order date for the same customer. Subtracting the two dates (`order_date - previous_order_date`) calculates the number of days between purchases. First orders are excluded since they have no previous date.

#### Output
```text
Cust ID Customer Name        Order ID Prev Date      Order Date     Days Apart
------- -------------------- -------- -------------- -------------- ----------
      1 Alice Uwase              1006 01-AUG-2026    10-AUG-2026             9
      1 Alice Uwase              1011 10-AUG-2026    23-AUG-2026            13
      2 Eric Mugisha             1007 02-AUG-2026    12-AUG-2026            10
      2 Eric Mugisha             1012 12-AUG-2026    25-AUG-2026            13
      3 Grace Mukamana           1008 04-AUG-2026    15-AUG-2026            11
      3 Grace Mukamana           1013 15-AUG-2026    28-AUG-2026            13
      4 Patrick Niyonzima        1009 05-AUG-2026    17-AUG-2026            12
      4 Patrick Niyonzima        1014 17-AUG-2026    02-SEP-2026            16
      5 Diane Ingabire           1010 07-AUG-2026    20-AUG-2026            13
      5 Diane Ingabire           1015 20-AUG-2026    05-SEP-2026            16

10 rows selected.
```

#### Business Interpretation
Repeat customers return between 9 and 16 days after their prior order. If an active shopper goes more than 18 days without an order, an automated reminder message or coupon can be sent to bring them back.

---

## 7. Challenges Encountered and Resolutions

1. **ORA-65096 while creating user:**
   * *Problem:* Running `CREATE USER sunrise_user` while connected to `CDB$ROOT` failed with `ORA-65096` because local users cannot be created in the root container without the `C##` prefix.
   * *Resolution:* Switched container to the pluggable database first: `ALTER SESSION SET CONTAINER = FREEPDB1;`.

2. **ORA-02291 while inserting orders:**
   * *Problem:* Inserting orders before customers caused foreign key integrity errors on `FK_ORDERS_CUSTOMER`.
   * *Resolution:* Followed strict insertion order: customers and products first, then orders, and lastly order items.

3. **SP2-0734 during multi-line commands in SQL*Plus:**
   * *Problem:* Blank lines in multi-line SQL statements caused SQL*Plus to stop buffering and treat subsequent lines as invalid commands.
   * *Resolution:* Enabled `SET SQLBLANKLINES ON` and ran insert statements as single-line inserts.

4. **Missing COMMIT in SQL*Plus:**
   * *Problem:* Exiting SQL*Plus without running `COMMIT;` caused inserted rows in `order_items` to roll back.
   * *Resolution:* Added an explicit `COMMIT;` command at the end of the insert script and verified row counts with `SELECT COUNT(*)`.

5. **SQL*Plus trailing hyphen line continuation:**
   * *Problem:* Lines in prompt headers ending with a hyphen (`-`) were treated by SQL*Plus as line continuations, causing syntax errors on subsequent queries.
   * *Resolution:* Formatted prompt headers with `=` characters instead of hyphens.

6. **Ensuring customers without orders were included:**
   * *Problem:* Using `INNER JOIN` excluded registered customers who had not yet made a purchase.
   * *Resolution:* Used `LEFT JOIN` and `NVL()` so zero-order customers (Samuel Habimana) appeared in queries with a 0 spending amount.

---

## 8. How to Run the Project

### Prerequisites
* Oracle AI Database 26ai Free
* SQL*Plus or Oracle SQL Developer
* Pluggable database `FREEPDB1` open in read-write mode

---

### Method 1: Using the Master Script (SQL*Plus)

1. Open PowerShell or Command Prompt.
2. Navigate to the folder:
   ```powershell
   cd "D:\New folder"
   ```
3. Connect to `FREEPDB1`:
   ```powershell
   sqlplus sunrise_user/Sunrise123@localhost:1521/FREEPDB1
   ```
4. Run the master script:
   ```sql
   @run_all.sql
   ```
   *This drops old tables, recreates the schema, inserts all data, sets column formatting, and executes all 8 queries in order.*

---

### Method 2: Running Scripts Individually

You can also run the scripts in order from the `sql/` folder:
```sql
@sql/01_create_tables.sql
@sql/02_insert_data.sql
@sql/03_join_queries.sql
@sql/04_cte_query.sql
@sql/05_window_queries.sql
```

Verify row counts:
```sql
SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items
FROM dual;
```
Expected: 6 customers, 10 products, 15 orders, 30 order items.

---

### Method 3: Using Oracle SQL Developer
1. Open Oracle SQL Developer.
2. Connect with:
   * **Connection Name:** `FREEPDB1_Sunrise`
   * **Username:** `sunrise_user`
   * **Password:** `Sunrise123`
   * **Hostname:** `localhost`
   * **Port:** `1521`
   * **Service Name:** `freepdb1`
3. Open `run_all.sql` and run as a script (`F5`).

---

## 9. File Structure

```text
assignment_1_felicien-20251sen197/
├── 01_schema.sql           # Table creation DDL (root)
├── 02_data.sql             # Insert statements and COMMIT (root)
├── 03_queries.sql          # All 8 queries (root)
├── run_all.sql             # Master script to run everything
├── README.md               # Documentation with screenshots
├── sql/                    # Individual query files
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_join_queries.sql
│   ├── 04_cte_query.sql
│   └── 05_window_queries.sql
└── screenshots/            # SQL*Plus execution screenshots
    ├── switch pdb to freepdb1.png
    ├── select curent freepdb1 user.png
    ├── creating user.png
    ├── grant user permissions.png
    ├── verify user existance.png
    ├── connect to sunriser.png
    ├── table created.png
    ├── user insert.png
    ├── product insertion.png
    ├── insert into 15 rows.png
    ├── order count.png
    ├── orders inserted.png
    ├── order items inserted.png
    ├── count for products.png
    ├── count for orders.png
    ├── full database count.png
    ├── Order joined with customers.png
    ├── Order items joined with products..png
    ├── All customers and their orders.png
    ├── Verify that the customer without orders appears.png
    └── every customers total.png
```

---
*PL/SQL Assignment 1 completed by Nshimyumukiza Felicien (20251SEN197).*
