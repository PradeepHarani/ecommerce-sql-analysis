-- =====================================================
-- Title: Additional Business Metrics
-- =====================================================
-- Objective:
-- Analyze supporting business metrics such as average order value,
-- monthly order volume, product revenue performance, state-wise order value,
-- and installment behavior to deepen overall business understanding.

-- =====================================================
-- 1. Average Order Value (AOV)
-- Business Question:
-- What is the average revenue generated per order?
-- =====================================================
WITH order_value AS (
    SELECT 
        order_id,
        SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
)
SELECT 
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_value;

-- Insight:
-- This query measures the average value generated per order, helping assess customer spending behavior at the order level.

-- =====================================================
-- 2. Monthly Order Volume
-- Business Question:
-- How many orders are placed each month?
-- =====================================================
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY year_month
ORDER BY year_month;

-- Insight:
-- This query tracks monthly order volume to identify business growth patterns and demand fluctuations over time.

-- =====================================================
-- 3. Top Products by Revenue
-- Business Question:
-- Which products generate the highest revenue?
-- =====================================================
SELECT 
    product_id,
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Insight:
-- This query highlights the top revenue-generating products, helping identify products that contribute most to overall sales performance.

-- =====================================================
-- 4. State-wise Average Order Value
-- Business Question:
-- Which states have the highest average order value?
-- =====================================================
WITH order_revenue AS (
    SELECT 
        o.order_id,
        c.customer_state,
        SUM(oi.price + oi.freight_value) AS order_total
    FROM orders o
    JOIN customers c 
        ON o.customer_id = c.customer_id
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY o.order_id, c.customer_state
)
SELECT 
    customer_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_revenue
GROUP BY customer_state
ORDER BY average_order_value DESC;

-- Insight:
-- This query compares average order value across states and helps identify regions where customers generate higher value per order.

-- =====================================================
-- 5. Payment Installment Analysis
-- Business Question:
-- How does revenue vary by number of payment installments?
-- =====================================================
SELECT 
    payment_installments,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- Insight:
-- This query shows how installment usage relates to transaction volume and revenue, helping evaluate customer payment behavior and financing preferences.