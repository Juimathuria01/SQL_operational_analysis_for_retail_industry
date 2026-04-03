--  Module 2 — Fulfillment Bottleneck
--
--  What is the overall late delivery rate?
SELECT
    COUNT(*) AS total_delivered,
    SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END) AS late_shipments,
    ROUND(100.0 * SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END)/ COUNT(*), 1)AS late_rate_pct
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
WHERE s.status = 'delivered';

-- Which warehouse has the worst late rate?
SELECT
    w.name AS warehouse, w.city,COUNT(*) AS total_shipments,
    SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END) AS late_shipments,
    ROUND(100.0 * SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END)/ COUNT(*), 1)AS late_rate_pct
FROM shipments s
JOIN orders o     ON s.order_id     = o.order_id
JOIN warehouses w ON s.warehouse_id = w.warehouse_id
WHERE s.status = 'delivered'
GROUP BY w.warehouse_id, w.name, w.city
ORDER BY late_rate_pct DESC;


-- Bucket deliveries by how many days late

SELECT
    CASE
        WHEN s.delivered_at <= o.promised_delivery_at                        THEN 'On time'
        WHEN s.delivered_at <= o.promised_delivery_at + INTERVAL '3 days'    THEN '1-3 days late'
        WHEN s.delivered_at <= o.promised_delivery_at + INTERVAL '7 days'    THEN '4-7 days late'
        ELSE                                                                       '8+ days late'
    END          AS delay_bucket,
    COUNT(*)     AS shipment_count
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
WHERE s.delivered_at IS NOT NULL
GROUP BY delay_bucket
ORDER BY delay_bucket;


-- Which product categories ship late most often?
SELECT
    p.category,
    COUNT(DISTINCT s.shipment_id) AS total_shipments,
    SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END) AS late_shipments,
    ROUND(100.0 * SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END)/ COUNT(DISTINCT s.shipment_id), 1) AS late_rate_pct
FROM shipments s
JOIN orders o      ON s.order_id    = o.order_id
JOIN order_items i ON o.order_id    = i.order_id
JOIN products p    ON i.product_id  = p.product_id
WHERE s.status = 'delivered'
GROUP BY p.category
ORDER BY late_rate_pct DESC;


-- Average days to ship by warehouse
SELECT
    w.name AS warehouse,
    w.city,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (s.shipped_at - o.ordered_at)) / 86400
    ), 1)AS avg_days_to_ship
FROM shipments s
JOIN orders o ON s.order_id     = o.order_id
JOIN warehouses w ON s.warehouse_id = w.warehouse_id
WHERE s.shipped_at IS NOT NULL
GROUP BY w.warehouse_id, w.name, w.city
ORDER BY avg_days_to_ship DESC;
