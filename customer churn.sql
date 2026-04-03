--  Customer Churn Risk
--  Business question: Which high-value customers are showing signs of disengaging?


-- Customer order summary
SELECT
    c.customer_id,
    c.full_name,
    c.tier,
    COUNT(o.order_id)                                               AS total_orders,
    ROUND(SUM(o.total_amount), 2)                                   AS total_revenue,
    MIN(o.ordered_at)::DATE                                         AS first_order_date,
    MAX(o.ordered_at)::DATE                                         AS last_order_date,
    ('2024-06-18'::DATE - MAX(o.ordered_at)::DATE)                  AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.tier
ORDER BY days_since_last_order DESC;

-- RFM score using a CTE
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.full_name,
        c.tier,
        COUNT(o.order_id)                                           AS total_orders,
        ROUND(SUM(o.total_amount), 2)                               AS total_revenue,
        MAX(o.ordered_at)::DATE                                     AS last_order_date,
        ('2024-06-18'::DATE - MAX(o.ordered_at)::DATE)              AS days_since_last_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.full_name, c.tier
),
rfm_scored AS (
    SELECT
        customer_id,
        full_name,
        tier,
        total_orders,
        total_revenue,
        days_since_last_order,

        -- Recency score
        CASE
            WHEN days_since_last_order < 30   THEN 4
            WHEN days_since_last_order < 90   THEN 3
            WHEN days_since_last_order < 180  THEN 2
            ELSE 1
        END AS r_score,

        -- Frequency score
        CASE
            WHEN total_orders >= 5  THEN 4
            WHEN total_orders >= 3  THEN 3
            WHEN total_orders = 2   THEN 2
            ELSE 1
        END AS f_score,

        -- Monetary score
        CASE
            WHEN total_revenue >= 1000  THEN 4
            WHEN total_revenue >= 500   THEN 3
            WHEN total_revenue >= 200   THEN 2
            ELSE 1
        END AS m_score

    FROM customer_summary
)
SELECT
    *,
    r_score + f_score + m_score AS rfm_total
FROM rfm_scored
ORDER BY rfm_total DESC;

-- ------------------------------------------------------------
-- Segment customers by RFM profile
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.full_name,
        c.tier,
        COUNT(o.order_id)                                           AS total_orders,
        ROUND(SUM(o.total_amount), 2)                               AS total_revenue,
        ('2024-06-18'::DATE - MAX(o.ordered_at)::DATE)              AS days_since_last_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.full_name, c.tier
),
rfm_scored AS (
    SELECT
        *,
        CASE
            WHEN days_since_last_order < 30   THEN 4
            WHEN days_since_last_order < 90   THEN 3
            WHEN days_since_last_order < 180  THEN 2
            ELSE 1
        END AS r_score,
        CASE
            WHEN total_orders >= 5  THEN 4
            WHEN total_orders >= 3  THEN 3
            WHEN total_orders = 2   THEN 2
            ELSE 1
        END AS f_score,
        CASE
            WHEN total_revenue >= 1000  THEN 4
            WHEN total_revenue >= 500   THEN 3
            WHEN total_revenue >= 200   THEN 2
            ELSE 1
        END AS m_score
    FROM customer_summary
),
rfm_total AS (
    SELECT
        *,
        r_score + f_score + m_score AS rfm_total
    FROM rfm_scored
)
SELECT
    full_name,
    tier,
    rfm_total,
    total_revenue,
    CASE
        WHEN rfm_total >= 10                          THEN 'Champions'
        WHEN rfm_total BETWEEN 7 AND 9                THEN 'Loyal'
        WHEN rfm_total BETWEEN 4 AND 6
             AND r_score <= 2                         THEN 'At Risk'
        WHEN rfm_total < 4 OR r_score = 1             THEN 'Lost'
        ELSE                                               'Other'
    END AS segment
FROM rfm_total
ORDER BY segment, total_revenue DESC;

--How much revenue is at risk?
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.full_name,
        c.tier,
        COUNT(o.order_id)                                           AS total_orders,
        ROUND(SUM(o.total_amount), 2)                               AS total_revenue,
        ('2024-06-18'::DATE - MAX(o.ordered_at)::DATE)              AS days_since_last_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.full_name, c.tier
),
rfm_scored AS (
    SELECT *,
        CASE WHEN days_since_last_order < 30  THEN 4
             WHEN days_since_last_order < 90  THEN 3
             WHEN days_since_last_order < 180 THEN 2
             ELSE 1 END AS r_score,
        CASE WHEN total_orders >= 5 THEN 4
             WHEN total_orders >= 3 THEN 3
             WHEN total_orders = 2  THEN 2
             ELSE 1 END AS f_score,
        CASE WHEN total_revenue >= 1000 THEN 4
             WHEN total_revenue >= 500  THEN 3
             WHEN total_revenue >= 200  THEN 2
             ELSE 1 END AS m_score
    FROM customer_summary
),
segmented AS (
    SELECT *,
        r_score + f_score + m_score AS rfm_total,
        CASE
            WHEN (r_score + f_score + m_score) >= 10                         THEN 'Champions'
            WHEN (r_score + f_score + m_score) BETWEEN 7 AND 9               THEN 'Loyal'
            WHEN (r_score + f_score + m_score) BETWEEN 4 AND 6
                 AND r_score <= 2                                             THEN 'At Risk'
            WHEN (r_score + f_score + m_score) < 4 OR r_score = 1            THEN 'Lost'
            ELSE 'Other'
        END AS segment
    FROM rfm_scored
)
SELECT
    segment,
    COUNT(*)                        AS customers,
    ROUND(SUM(total_revenue), 2)    AS total_revenue,
    ROUND(AVG(total_revenue), 2)    AS avg_revenue_per_customer
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;

