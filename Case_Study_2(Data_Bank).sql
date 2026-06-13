CREATE DATABASE data_bank

USE data_bank

CREATE TABLE regions (
  region_id INTEGER,
  region_name VARCHAR(9)
);

INSERT INTO regions
  (region_id, region_name)
VALUES
  ('1', 'Australia'),
  ('2', 'America'),
  ('3', 'Africa'),
  ('4', 'Asia'),
  ('5', 'Europe');


CREATE TABLE customer_nodes (
  customer_id INTEGER,
  region_id INTEGER,
  node_id INTEGER,
  start_date DATE,
  end_date DATE
);

BULK INSERT customer_nodes
FROM 'C:\Users\a\OneDrive\Desktop\customer_nodes.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

CREATE TABLE customer_transactions (
  customer_id INTEGER,
  txn_date DATE,
  txn_type VARCHAR(10),
  txn_amount INTEGER
);

BULK INSERT customer_transactions
FROM 'C:\Users\a\OneDrive\Desktop\customer_transactions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


-- A. Customer Nodes Exploration --
    -- 1).How many unique nodes are there on the Data Bank system?

            USE data_bank

              SELECT COUNT(DISTINCT node_id) AS unique_nodes FROM customer_nodes

    -- 2).What is the number of nodes per region?

            USE data_bank
              SELECT region_id,COUNT(DISTINCT node_id) AS nodes_count from customer_nodes
              GROUP BY region_id
              ORDER BY region_id ASC

    -- 3).How many customers are allocated to each region?

            USE data_bank
              SELECT region_id, COUNT(DISTINCT customer_id) AS customers_allocated FROM customer_nodes
              GROUP BY region_id
              ORDER BY region_id

    -- 4).How many days on average are customers reallocated to a different node?

            USE data_bank

            ;WITH reallocation_days AS (
            SELECT
                customer_id,
                DATEDIFF(day, start_date, end_date) AS days_allocated
            FROM customer_nodes
            WHERE end_date <> '9999-12-31'
            )
            SELECT
                AVG(CONVERT(decimal(10,2), days_allocated)) AS avg_reallocation_days
            FROM reallocation_days;

    -- 5).What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

            USE data_bank

            ;WITH reallocation_days AS (
            SELECT
                r.region_name,
                DATEDIFF(day, cn.start_date, cn.end_date) AS days_allocated
            FROM customer_nodes cn
            JOIN regions r
                ON cn.region_id = r.region_id
            WHERE cn.end_date <> '9999-12-31'
            )

            SELECT DISTINCT
                region_name,
            
                PERCENTILE_CONT(0.5)
                    WITHIN GROUP (ORDER BY days_allocated)
                    OVER (PARTITION BY region_name) AS median_days,
            
                PERCENTILE_CONT(0.8)
                    WITHIN GROUP (ORDER BY days_allocated)
                    OVER (PARTITION BY region_name) AS percentile_80_days,
            
                PERCENTILE_CONT(0.95)
                    WITHIN GROUP (ORDER BY days_allocated)
                    OVER (PARTITION BY region_name) AS percentile_95_days
            
            FROM reallocation_days
            ORDER BY region_name;


-- B. Customer Transactions --
    -- 1).What is the unique count and total amount for each transaction type?
            
            USE data_bank

            SELECT txn_type, SUM(txn_amount) as total_amount FROM customer_transactions
            GROUP BY txn_type

    -- 2).What is the average total historical deposit counts and amounts for all customers?

            USE data_bank

            SELECT
            AVG(total_deposits) as avg_total_deposits,
            AVG(total_amount) as avg_amount
            FROM
            (
            SELECT 
            customer_id,
            count(txn_type) as total_deposits,
            sum(txn_amount) as total_amount
            FROM customer_transactions
            WHERE txn_type = 'deposit'
            GROUP BY customer_id
            ) t

    -- 3).For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

            USE data_bank
            
            ;WITH monthly_transactions AS (
            SELECT
            customer_id,
            MONTH(txn_date) AS month_num,

            SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_count,
            SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_count,
            SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
            FROM customer_transactions
            GROUP BY
            customer_id,
            MONTH(txn_date)
            )

            SELECT
            month_num,
            COUNT(*) AS customer_count
            FROM monthly_transactions
            WHERE deposit_count > 1
            AND (purchase_count >= 1 OR withdrawal_count >= 1)
            GROUP BY month_num
            ORDER BY month_num;




