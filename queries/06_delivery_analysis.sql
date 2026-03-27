-- =====================================================
-- Title: Delivery Performance Analysis
-- =====================================================
-- Objective:
-- Evaluate delivery efficiency by measuring on-time versus delayed deliveries
-- and comparing delivery performance across different states.

-- =====================================================
-- 1. On-time vs Delayed Deliveries
-- Business Question:
-- What percentage of orders are delivered on time versus delayed?
-- =====================================================
WITH delivery_status_cte AS (
    SELECT 
        order_id,
        TIMESTAMPDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        ) AS delivered_days,
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date
                THEN 'Delivered On-Time'
            ELSE 'Delayed Delivery'
        END AS delivery_status
    FROM orders
    WHERE order_estimated_delivery_date IS NOT NULL
      AND order_delivered_customer_date IS NOT NULL
)
SELECT 
    delivery_status,
    COUNT(*) AS delivery_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS delivery_status_percentage
FROM delivery_status_cte
GROUP BY delivery_status;

-- Insight:
-- This query measures delivery efficiency by comparing the share of on-time and delayed orders, helping assess the reliability of the logistics process.

-- =====================================================
-- 2. Delivery Performance by State
-- Business Question:
-- How does delivery performance vary across states in terms of average delivery time and delay rate?
-- =====================================================
SELECT 
    cs.customer_state,
    ROUND(AVG(TIMESTAMPDIFF(DAY,
                os.order_purchase_timestamp,
                os.order_delivered_customer_date)),
            2) AS avg_delivery_days,
    COUNT(*) AS total_deliveries,
    SUM(CASE
        WHEN os.order_delivered_carrier_date > os.order_estimated_delivery_date THEN 1
        ELSE 0
    END) AS delayed_deliveries,
    ROUND(SUM(CASE
                WHEN os.order_delivered_carrier_date > os.order_estimated_delivery_date THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS delayed_percentage
FROM
    customers cs
        INNER JOIN
    orders os ON cs.customer_id = os.customer_id
WHERE
    os.order_delivered_customer_date IS NOT NULL
        AND os.order_estimated_delivery_date IS NOT NULL
GROUP BY cs.customer_state
ORDER BY avg_delivery_days DESC;

-- Insight:
-- This query compares delivery speed and delay rates across states, helping identify regions where logistics performance may need improvement.