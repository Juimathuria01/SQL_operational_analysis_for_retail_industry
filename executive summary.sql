--  Executive Summary
--  Business question: What should RetailCo fix first?

-- The one-page data summary

WITH total_customers AS (
    SELECT COUNT(*) AS total_customers
    FROM customers
),
total_revenue AS (
    SELECT ROUND(SUM(total_amount), 2) AS total_revenue
    FROM orders
    WHERE status = 'delivered'
),
late_delivery_rate AS (
    SELECT
        ROUND(
            100.0 * SUM(CASE WHEN s.delivered_at > o.promised_delivery_at THEN 1 ELSE 0 END)
            / COUNT(*), 1
        ) AS late_rate_pct
    FROM shipments s
    JOIN orders o ON s.order_id = o.order_id
    WHERE s.delivered_at IS NOT NULL
),
ticket_breakdown AS (
    SELECT
        ROUND(
            100.0 * SUM(CASE WHEN category = 'late_delivery' THEN 1 ELSE 0 END)
            / COUNT(*), 1
        ) AS late_ticket_pct
    FROM support_tickets
),
churn_risk AS (
    WITH customer_summary AS (
        SELECT
            c.customer_id,
            COUNT(o.order_id)                                       AS total_orders,
            ROUND(SUM(o.total_amount), 2)                           AS total_revenue,
            ('2024-06-18'::DATE - MAX(o.ordered_at)::DATE)          AS days_since_last_order
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_id
    ),
    rfm AS (
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
                WHEN (r_score + f_score + m_score) >= 10             THEN 'Champions'
                WHEN (r_score + f_score + m_score) BETWEEN 7 AND 9   THEN 'Loyal'
                WHEN (r_score + f_score + m_score) BETWEEN 4 AND 6
                     AND r_score <= 2                                 THEN 'At Risk'
                WHEN (r_score + f_score + m_score) < 4
                     OR r_score = 1                                   THEN 'Lost'
                ELSE 'Other'
            END AS segment
        FROM rfm
    )
    SELECT COUNT(*) AS at_risk_or_lost
    FROM segmented
    WHERE segment IN ('At Risk', 'Lost')
)
SELECT
    tc.total_customers,
    tr.total_revenue,
    ldr.late_rate_pct,
    tb.late_ticket_pct,
    cr.at_risk_or_lost
FROM total_customers tc
CROSS JOIN total_revenue    tr
CROSS JOIN late_delivery_rate ldr
CROSS JOIN ticket_breakdown tb
CROSS JOIN churn_risk       cr;

-- Prioritized issue ranking
WITH issue1 AS (
    SELECT
        'Fulfillment delays — Central Hub'          AS issue_name,
        COUNT(DISTINCT s.order_id)                  AS affected_count,
        ROUND(SUM(o.total_amount), 2)               AS revenue_at_risk
    FROM shipments s
    JOIN orders     o  ON s.order_id     = o.order_id
    JOIN warehouses w  ON s.warehouse_id = w.warehouse_id
    WHERE w.name = 'Central Hub'
      AND s.delivered_at > o.promised_delivery_at
      AND s.delivered_at >= '2024-03-19'
),
issue2 AS (
    WITH customer_summary AS (
        SELECT
            c.customer_id,
            COUNT(o.order_id)                                       AS total_orders,
            ROUND(SUM(o.total_amount), 2)                           AS total_revenue,
            ('2024-06-18'::DATE - MAX(o.ordered_at)::DATE)          AS days_since_last_order
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_id
    ),
    rfm AS (
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
    )
    SELECT
        'At-Risk customers'                         AS issue_name,
        COUNT(*)                                    AS affected_count,
        ROUND(SUM(total_revenue), 2)                AS revenue_at_risk
    FROM rfm
    WHERE (r_score + f_score + m_score) BETWEEN 4 AND 6
      AND r_score <= 2
),
issue3 AS (
    SELECT
        'Unresolved support tickets > 7 days'       AS issue_name,
        COUNT(DISTINCT t.ticket_id)                 AS affected_count,
        ROUND(SUM(o.total_amount), 2)               AS revenue_at_risk
    FROM support_tickets t
    LEFT JOIN orders o ON t.order_id = o.order_id
    WHERE t.status IN ('open', 'in_progress')
      AND ('2024-06-18'::DATE - t.created_at::DATE) > 7
)
SELECT * FROM issue1
UNION ALL
SELECT * FROM issue2
UNION ALL
SELECT * FROM issue3;


--Consulting memo (SQL comments)

/*
================================================================
TO:   RetailCo Leadership
FROM: Jui Mathuria, Data & AI Consultant
DATE: April 2026
RE:   Operational Bottleneck Analysis — April 2026
================================================================

EXECUTIVE SUMMARY
-----------------
A SQL-driven analysis of RetailCo's orders, shipments, customer
history, and support tickets reveals three compounding problems
that together put $3,338 in near-term revenue at risk and are
quietly eroding customer trust. The problems are operationally
connected — a single underperforming warehouse is generating
late deliveries that trigger support tickets, which in turn are
accelerating customer churn. Fixing the root cause addresses
all three issues simultaneously.


KEY FINDINGS
------------
1. FULFILLMENT — Central Hub (Dallas) is responsible for 100%
   of late deliveries in the dataset.
   
   Supporting data:
   - Overall late delivery rate: 37.5% (9 of 24 shipments)
   - Central Hub late rate: 100% (9 of 9 shipments)
   - West Coast and East Coast hubs: 0% late rate
   - Delays are consistent: 1-5 days over promise, every time
   - This pattern indicates a systemic process issue, not
     random carrier variance
   - Revenue tied to late Central Hub orders: $2,108.91

2. CUSTOMER CHURN — 7 of 14 active customers (50%) are
   classified as At Risk or Lost using RFM segmentation.

   Supporting data:
   - At Risk customers: 4, representing $1,229.93 in revenue
   - Lost customers: 3, representing $729.97 in revenue
   - 3 late deliveries generated NO support ticket — meaning
     some customers are churning silently without complaining
   - Priya Patel (gold tier) appears in both the churn risk
     list AND has an overdue 48-day support ticket — highest
     individual retention priority

3. SUPPORT OVERLOAD — 53.3% of all support tickets are
   late_delivery related, and the category appears every
   single month without exception.

   Supporting data:
   - late_delivery tickets take an average of 47.2 hours
     to resolve — the longest of any category
   - 2 tickets are currently overdue (open > 14 days),
     both high priority
   - Resolving the Central Hub issue would eliminate this
     ticket category almost entirely


RECOMMENDED ACTIONS (priority order)
--------------------------------------
1. AUDIT CENTRAL HUB OPERATIONS — Investigate the dispatch
   and carrier handoff process at the Dallas facility.
   The consistent 1-5 day delay window rules out random
   carrier issues and points to a fixed bottleneck in the
   outbound process (e.g. cut-off times, carrier pickup
   schedule, or packing queue delays).
   Expected impact: Eliminates $2,108 in at-risk revenue,
   reduces support ticket volume by ~53%

2. LAUNCH A RETENTION CAMPAIGN FOR AT-RISK CUSTOMERS —
   Target the 4 At Risk customers immediately, prioritizing
   Priya Patel and any customer who received a late delivery
   without filing a ticket (silent churners are highest risk).
   Expected impact: Protects up to $1,229 in lifetime revenue

3. RESOLVE ALL OVERDUE SUPPORT TICKETS THIS WEEK —
   Two tickets have been open beyond SLA: Priya Patel's
   return request (48 days) and Sophie Martin's late delivery
   complaint (20 days). Both customers are in the churn risk
   segment. Closing these immediately is low cost, high signal.
   Expected impact: Reduces churn probability for 2 at-risk
   customers, protects $489 in associated order value


NEXT STEPS — PHASE 2 INVESTIGATION
------------------------------------
The following questions could not be answered with the current
dataset and should be prioritized for Phase 2:

- Carrier-level data: Which specific carrier is handling
  Central Hub shipments? UPS appears frequently in late rows
  — is this a contract or route issue?

- Inventory data: Are late Central Hub orders correlated with
  specific products being out of stock at that location,
  forcing reallocation delays?

- Customer satisfaction scores: Do customers who received
  late deliveries but filed no ticket show lower repeat
  purchase rates? This would quantify the silent churn risk.

- Seasonality: 6 months of data is insufficient to determine
  whether delays worsen during peak periods (Q4, holidays).
  12+ months recommended for trend analysis.
================================================================
*/

