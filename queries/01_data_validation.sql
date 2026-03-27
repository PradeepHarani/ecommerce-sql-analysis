-- =====================================================
-- SECTION 0: DATA VALIDATION
-- =====================================================

-- Check total rows in orders
SELECT COUNT(*) FROM orders;

-- Check total rows in order_items
SELECT COUNT(*) FROM order_items;

-- Check distinct orders
SELECT COUNT(DISTINCT order_id) FROM orders;

-- Check invalid order_items (no matching orders)
SELECT COUNT(*)
FROM orders o
RIGHT JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_id IS NULL;