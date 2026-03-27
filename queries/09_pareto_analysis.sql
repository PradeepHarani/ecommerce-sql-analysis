-- =====================================================
-- Title: Pareto Analysis
-- =====================================================
-- Objective:
-- Evaluate whether a small percentage of customers contribute the majority
-- of total revenue and determine if the business follows the Pareto (80/20) principle.

-- =====================================================
-- 1. Customer Revenue Concentration
-- Business Question:
-- What percentage of customers is required to generate 80% of total revenue?
-- =====================================================
WITH customer_revenue AS (
    SELECT 
        cs.customer_unique_id,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM customers cs
    JOIN orders o 
        ON cs.customer_id = o.customer_id
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY cs.customer_unique_id
),
cumulative_per AS (
    SELECT 
        customer_unique_id,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        ROUND(
            SUM(total_revenue) OVER (ORDER BY total_revenue DESC) * 100.0 /
            SUM(total_revenue) OVER (),
            2
        ) AS cumulative_percentage
    FROM customer_revenue
)
SELECT 
    MIN(revenue_rank) AS customers_needed_for_80_percent,
    ROUND(
        MIN(revenue_rank) * 100.0 / COUNT(*),
        2
    ) AS percentage_of_customers
FROM cumulative_per
WHERE cumulative_percentage >= 80;

-- Insight:
-- This query measures revenue concentration across the customer base and shows whether the business follows the Pareto principle or depends on a broad distribution of customers.