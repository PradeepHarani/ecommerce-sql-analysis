-- =====================================================
-- Title: Revenue Analysis
-- =====================================================
-- Objective:
-- Analyze overall revenue, monthly revenue trends, month-over-month growth,
-- and identify the highest revenue month to understand business growth patterns.

-- =====================================================
-- 1. Total Revenue
-- Business Question:
-- What is the total revenue generated from all completed transactions?
-- =====================================================
SELECT 
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id;

-- Insight:
-- This query provides the overall revenue generated from product sales and freight charges.

-- =====================================================
-- 2. Monthly Revenue Trend
-- Business Question:
-- How is revenue changing over time on a monthly basis?
-- =====================================================
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
GROUP BY month
ORDER BY month;

-- Insight:
-- This query helps identify revenue growth patterns, fluctuations, and seasonality across months.

-- =====================================================
-- 3. Month-over-Month Revenue Growth
-- Business Question:
-- How much does revenue increase or decrease compared to the previous month?
-- =====================================================
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
        SUM(price + freight_value) AS total_revenue
    FROM order_items oi
    JOIN orders o 
        ON oi.order_id = o.order_id
    GROUP BY month
)
SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(LAG(total_revenue) OVER (ORDER BY month), 2) AS previous_month,
    ROUND(
        total_revenue - LAG(total_revenue) OVER (ORDER BY month),
        2
    ) AS revenue_change,
    ROUND(
        (
            (total_revenue - LAG(total_revenue) OVER (ORDER BY month))
            / LAG(total_revenue) OVER (ORDER BY month)
        ) * 100,
        2
    ) AS growth_percentage
FROM monthly_revenue;

-- Insight:
-- This query measures monthly revenue growth and highlights periods of sharp increase or decline.

-- =====================================================
-- 4. Highest Revenue Month
-- Business Question:
-- Which month generated the highest revenue?
-- =====================================================
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;

-- Insight:
-- This query identifies the peak revenue month, which helps in understanding high-demand periods.