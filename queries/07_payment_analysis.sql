-- =====================================================
-- Title: Payment Analysis
-- =====================================================
-- Objective:
-- Analyze customer payment preferences by comparing payment method usage,
-- revenue contribution, and ranking to understand which payment types drive the business.

-- =====================================================
-- 1. Revenue and Usage by Payment Type
-- Business Question:
-- Which payment methods are most frequently used, and which generate the highest revenue?
-- =====================================================
SELECT 
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(COUNT(*) * 100.0 / (SELECT 
                    COUNT(*)
                FROM
                    payments),
            2) AS usage_percentage,
    ROUND(SUM(payment_value) * 100.0 / (SELECT 
                    SUM(payment_value)
                FROM
                    payments),
            2) AS revenue_percentage
FROM
    payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- Insight:
-- This query compares payment method popularity with revenue contribution, helping identify the most preferred and financially important payment types.

-- =====================================================
-- 2. Revenue Ranking by Payment Type
-- Business Question:
-- How do payment methods rank based on total revenue generated?
-- =====================================================
WITH revenue AS (
    SELECT 
        payment_type, 
        ROUND(SUM(payment_value), 2) AS total_revenue,
        ROUND(
            SUM(payment_value) * 100.0 / (
                SELECT SUM(payment_value) 
                FROM payments
            ),
            2
        ) AS revenue_percentage
    FROM payments
    GROUP BY payment_type
)
SELECT 
    payment_type,
    total_revenue,
    revenue_percentage,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM revenue;

-- Insight:
-- This query ranks payment methods by revenue contribution, helping identify which payment types drive the largest share of business value.

-- =====================================================
-- 3. Usage vs Revenue Contribution by Payment Type
-- Business Question:
-- Do the most frequently used payment methods also contribute the highest share of revenue?
-- =====================================================
WITH payment_vs_revenue AS (
    SELECT 
        payment_type,
        COUNT(*) AS usage_count,
        ROUND(SUM(payment_value), 2) AS total_revenue,
        ROUND(
            COUNT(*) * 100.0 / (
                SELECT COUNT(*) 
                FROM payments
            ),
            2
        ) AS usage_percentage,
        ROUND(
            SUM(payment_value) * 100.0 / (
                SELECT SUM(payment_value) 
                FROM payments
            ),
            2
        ) AS revenue_percentage
    FROM payments
    GROUP BY payment_type
)
SELECT 
    payment_type,
    usage_percentage,
    revenue_percentage,
    ROUND(revenue_percentage - usage_percentage, 2) AS percentage_gap
FROM payment_vs_revenue;

-- Insight:
-- This query measures the gap between payment method usage and revenue contribution, helping identify whether frequently used payment methods also generate proportional business value.