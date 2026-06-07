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

    -- 5).What is the median, 80th and 95th percentile for this same reallocation days metric for each region?


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


