--Checking for NULL or empty values 

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 END) AS null_customer_id,
	SUM(CASE WHEN order_status IS NULL THEN 1 END) AS null_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 END) AS null_purchase_time
FROM olist_orders;

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 END) AS null_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 END) AS null_customer_unique_id
FROM olist_customers;

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 END) AS null_order_id,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 END) AS null_order_item_id,
	SUM(CASE WHEN product_id IS NULL THEN 1 END) AS null_product_id,
    SUM(CASE WHEN price IS NULL THEN 1 END) AS null_price,
	SUM(CASE WHEN freight_value IS NULL THEN 1 END) AS null_freight_value
FROM olist_order_items;

SELECT
    SUM(CASE WHEN payment_type IS NULL THEN 1 END) AS null_payment_type,
	SUM(CASE WHEN payment_value IS NULL THEN 1 END) AS null_payment_value
FROM olist_order_payments;

--Creating a new table 'orders_clean' with only delivered orders

SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp
INTO orders_clean
FROM olist_orders o
JOIN olist_customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';

--Showing cohort month for each customer

WITH first_purchase AS (
    SELECT customer_unique_id, FORMAT(MIN(order_purchase_timestamp), 'yyyy-MM') AS cohort_month
    FROM orders_clean
    GROUP BY customer_unique_id
),
orders_with_cohort AS (
	SELECT oc.customer_unique_id, fp.cohort_month, FORMAT(oc.order_purchase_timestamp, 'yyyy-MM') AS order_month
	FROM orders_clean oc
	JOIN first_purchase fp
		ON oc.customer_unique_id = fp.customer_unique_id
)
SELECT *
FROM orders_with_cohort
ORDER BY cohort_month, customer_unique_id;

--Calculating retention by cohort month

WITH first_purchase AS (
    SELECT customer_unique_id, FORMAT(MIN(order_purchase_timestamp), 'yyyy-MM') AS cohort_month
    FROM orders_clean
    GROUP BY customer_unique_id
),
orders_with_cohort AS (
	SELECT oc.customer_unique_id, fp.cohort_month, FORMAT(oc.order_purchase_timestamp, 'yyyy-MM') AS order_month
	FROM orders_clean oc
	JOIN first_purchase fp
		ON oc.customer_unique_id = fp.customer_unique_id
),
time_difference AS (
	SELECT customer_unique_id, cohort_month, order_month, DATEDIFF(month, CAST(cohort_month + '-01' AS DATE), CAST(order_month + '-01' AS DATE)) AS months_since_first_purchase
	FROM orders_with_cohort
)
SELECT cohort_month, months_since_first_purchase, COUNT(DISTINCT customer_unique_id) AS active_customers
FROM time_difference
GROUP BY cohort_month, months_since_first_purchase
ORDER BY cohort_month, months_since_first_purchase;

--Calculating repeat purchase rate

WITH customer_orders AS (
    SELECT customer_unique_id, COUNT(*) AS total_orders
    FROM orders_clean
    GROUP BY customer_unique_id
)
SELECT COUNT(*) AS total_customers, COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS repeat_customers,
   CAST(COUNT(CASE WHEN total_orders > 1 THEN 1 END) * 1.0/ COUNT(*) AS DECIMAL(10,4)) AS repeat_purchase_rate
FROM customer_orders;

--Calculate days of inactivity per customer (90 days or more of inactivity contibutes to churn)

DECLARE @cutoff_date DATE = (
    SELECT MAX(order_purchase_timestamp) FROM orders_clean
);

WITH last_purchase AS (
    SELECT customer_unique_id, MAX(order_purchase_timestamp) AS last_order_date
    FROM orders_clean
    GROUP BY customer_unique_id
),
inactivity AS (
    SELECT customer_unique_id,
           last_order_date,
           DATEDIFF(day, last_order_date, @cutoff_date) AS days_of_inactivity,
           CASE WHEN DATEDIFF(day, last_order_date, @cutoff_date) > 90 THEN 1 ELSE 0 END AS churn_flag
    FROM last_purchase
)
SELECT *
FROM inactivity;

--Calculating churn rate

DECLARE @cutoff_date DATE = (
    SELECT MAX(order_purchase_timestamp) FROM orders_clean
);

WITH last_purchase AS (
    SELECT customer_unique_id, MAX(order_purchase_timestamp) AS last_order_date
    FROM orders_clean
    GROUP BY customer_unique_id
),
inactivity AS (
	SELECT customer_unique_id, DATEDIFF(day, last_order_date, @cutoff_date) AS days_of_inactivity
	FROM last_purchase
)
SELECT COUNT(*) AS total_customers, COUNT(CASE WHEN days_of_inactivity > 90 THEN 1 END) AS inactive_customers,
	CAST(COUNT(CASE WHEN days_of_inactivity > 90 THEN 1 END) * 1.0/ COUNT(*) AS DECIMAL(10,4)) AS churn_rate
FROM inactivity;






