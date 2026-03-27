-- =====================================================
-- Title: Customer Analysis
-- =====================================================
-- Objective:
-- Analyze customer revenue contribution and purchasing behavior
-- to identify top customers and understand repeat vs one-time buying patterns.

-- =====================================================
-- 1. Top 10 Customers by Revenue
-- Business Question:
-- Who are the top revenue-contributing customers, and how many orders have they placed?
-- =====================================================
SELECT
    c.customer_unique_id,
    ROUND(SUM(price + freight_value), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Insight:
-- This query identifies the highest revenue-generating customers and shows whether their contribution comes from frequent purchases or high-value orders.

-- =====================================================
-- 2. Repeat vs One-time Customers
-- Business Question:
-- What proportion of customers are one-time buyers compared to repeat customers?
-- =====================================================
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time buyer'
        ELSE 'Regular customer'
    END AS buyer_type,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_orders), 2) AS customer_percentage
FROM customer_orders
GROUP BY buyer_type;

-- Insight:
-- This query helps evaluate customer retention by showing how much of the business comes from repeat customers versus one-time buyers.