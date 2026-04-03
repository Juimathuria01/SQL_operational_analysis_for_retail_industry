--  Support Team Overload
--  Business question: What's driving the ticket spike, and which categories are overwhelming the team?

--  Ticket volume by month and category
SELECT
    DATE_TRUNC('month', created_at)::DATE   AS month,
    category,
    COUNT(*)                                AS ticket_count
FROM support_tickets
GROUP BY DATE_TRUNC('month', created_at), category
ORDER BY month, ticket_count DESC;

--  Average resolution time by category
SELECT
    category,
    COUNT(*)                                                        AS tickets_resolved,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (resolved_at - created_at)) / 3600
        )::NUMERIC, 1
    )                                                               AS avg_hours_to_resolve
FROM support_tickets
WHERE resolved_at IS NOT NULL
GROUP BY category
ORDER BY avg_hours_to_resolve DESC;

-- Are late deliveries causing support tickets?
WITH shipment_flags AS (
    SELECT
        s.order_id,
        MAX(CASE
            WHEN s.delivered_at > o.promised_delivery_at THEN 1
            ELSE 0
        END)                                                        AS was_late
    FROM shipments s
    JOIN orders o ON s.order_id = o.order_id
    WHERE s.delivered_at IS NOT NULL
    GROUP BY s.order_id
),
ticket_flags AS (
    SELECT
        order_id,
        1                                                           AS had_ticket
    FROM support_tickets
    WHERE category = 'late_delivery'
      AND order_id IS NOT NULL
    GROUP BY order_id
)
SELECT
    CASE WHEN sf.was_late = 1    THEN 'Late delivery'  ELSE 'On time'    END AS delivery_status,
    CASE WHEN tf.had_ticket = 1  THEN 'Ticket filed'   ELSE 'No ticket'  END AS ticket_status,
    COUNT(*)                                                                   AS order_count
FROM shipment_flags sf
LEFT JOIN ticket_flags tf ON sf.order_id = tf.order_id
GROUP BY sf.was_late, tf.had_ticket
ORDER BY sf.was_late DESC, tf.had_ticket DESC;

--Which customers open the most tickets?

WITH customer_tickets AS (
    SELECT
        customer_id,
        COUNT(*)                                                    AS ticket_count
    FROM support_tickets
    GROUP BY customer_id
),
customer_orders AS (
    SELECT
        customer_id,
        COUNT(*)                                                    AS order_count,
        ROUND(SUM(total_amount), 2)                                 AS total_revenue
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.full_name,
    c.tier,
    COALESCE(ct.ticket_count, 0)                                    AS ticket_count,
    COALESCE(co.order_count, 0)                                     AS order_count,
    COALESCE(co.total_revenue, 0)                                   AS total_revenue,
    CASE
        WHEN ct.ticket_count > co.order_count                       THEN 'RED ALERT'
        ELSE 'Normal'
    END                                                             AS flag
FROM customers c
LEFT JOIN customer_tickets ct ON c.customer_id = ct.customer_id
LEFT JOIN customer_orders  co ON c.customer_id = co.customer_id
WHERE ct.ticket_count IS NOT NULL
ORDER BY ticket_count DESC, total_revenue DESC;

-- Open tickets ageing report
SELECT
    t.ticket_id,
    c.full_name,
    t.category,
    t.priority,
    t.status,
    t.created_at::DATE                                              AS opened_on,
    ('2024-06-18'::DATE - t.created_at::DATE)                       AS days_open,
    CASE
        WHEN ('2024-06-18'::DATE - t.created_at::DATE) > 14        THEN 'Overdue'
        ELSE 'Within SLA'
    END                                                             AS sla_status
FROM support_tickets t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.status IN ('open', 'in_progress')
ORDER BY days_open DESC;

