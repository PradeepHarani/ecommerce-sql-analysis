-- =====================================================
-- Title: Customer Distribution Analysis
-- =====================================================
-- Objective:
-- Analyze the geographic distribution of customers across states and cities
-- to identify major customer markets and regional concentration.

-- =====================================================
-- 1. Customer Distribution by State
-- Business Question:
-- From which states do the customers come, and how concentrated is the customer base across states?
-- =====================================================
SELECT 
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customer_count,
    ROUND(
        (
            COUNT(DISTINCT customer_unique_id) / (
                SELECT COUNT(DISTINCT customer_unique_id)
                FROM customers
            )
        ) * 100,
        2
    ) AS customer_percentage
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Insight:
-- This query shows which states contribute the most customers and helps identify regions where the business has the strongest customer presence.

-- =====================================================
-- 2. Top Cities by Customer Count
-- Business Question:
-- Which cities have the highest number of customers, and how is the customer base distributed across urban areas?
-- =====================================================
SELECT
    customer_city,
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customer_count,
    ROUND(
        (
            COUNT(DISTINCT customer_unique_id) * 100.0 / (
                SELECT COUNT(DISTINCT customer_unique_id)
                FROM customers
            )
        ),
        2
    ) AS customer_percentage
FROM customers
GROUP BY customer_city, customer_state
ORDER BY customer_count DESC
LIMIT 20;

-- Insight:
-- This query highlights the cities with the largest customer base, helping identify key urban markets for targeted business expansion and marketing efforts.