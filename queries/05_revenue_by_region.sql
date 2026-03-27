-- =====================================================
-- Title: Revenue Distribution by Region
-- =====================================================
-- Objective:
-- Analyze revenue contribution across states to identify the highest-performing
-- regions and understand geographic revenue concentration.

-- =====================================================
-- 1. Revenue Contribution by State
-- Business Question:
-- Which states contribute the most to total revenue, and how is revenue distributed across regions?
-- =====================================================
SELECT 
    cs.customer_state,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(
        SUM(oi.price + oi.freight_value) * 100.0 / (
            SELECT SUM(price + freight_value)
            FROM order_items oi
            INNER JOIN orders o 
                ON oi.order_id = o.order_id
        ),
        2
    ) AS revenue_percentage
FROM customers cs
INNER JOIN orders o 
    ON cs.customer_id = o.customer_id
INNER JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY cs.customer_state
ORDER BY total_revenue DESC;

-- Insight:
-- This query shows which states generate the highest revenue and helps identify regions where the business is most financially dependent.