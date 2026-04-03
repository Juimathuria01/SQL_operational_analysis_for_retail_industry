# RetailCo — SQL Operational Analysis

A end-to-end SQL analytics project built to practice translating raw business data into a clear, prioritised recommendation. The goal wasn't just to query data, it was to find a single thread connecting operational failures to customer impact, and surface what leadership should fix first.

---

## Project Goal

Given a retail company's data across orders, shipments, customers, and support tickets, can I identify one root cause that explains multiple downstream problems?

**Answer:** Yes. One underperforming warehouse was responsible for 100% of late deliveries, which cascaded into support overload and silent customer churn.

---

## Database Schema

The database consists of 6 tables:

| Table | Description |
|---|---|
| `customers` | 20 customers across tiers: standard, silver, gold, vip |
| `products` | 12 products across Electronics, Home Goods, and Furniture |
| `orders` | 30 orders with status, channel, and promised delivery date |
| `order_items` | Line items linking orders to products |
| `shipments` | 25 shipments with warehouse, carrier, and delivery timestamps |
| `support_tickets` | 15 tickets with category, priority, and resolution timestamps |

---

## Files

| File | Description |
|---|---|
| `Schema.sql` | Full database schema — tables, constraints, and indexes |
| `Seed.sql` | All seed data — warehouses, customers, products, orders, shipments, tickets |
| `Testing.sql` | Quick row count check across all tables |
| `data_profiling.sql` | Dataset shape, order status breakdown, data quality checks |
| `bottleneck_fulfillment.sql` |Late delivery rates by warehouse, category, and delay bucket |
| `customer_churn.sql` | RFM segmentation model (Recency, Frequency, Monetary) |
| `support_overload.sql` | Ticket volume, resolution times, ageing report |
| `executive_summary.sql` | One-page KPI summary + prioritised issue ranking + consulting memo |

---

## Key Findings

### 1. Fulfillment — Central Hub (Dallas)
- Overall late delivery rate: **37.5%**
- Central Hub late rate: **100%** (9 of 9 shipments)
- West Coast and East Coast hubs: **0%** late
- This is a systemic process failure, not carrier variance
- Revenue tied to late Central Hub orders: **$2,108.91**

### 2. Customer Churn
- **50% of active customers** classified as At Risk or Lost via RFM scoring
- 3 late deliveries generated **no support ticket** — customers churning silently
- At Risk customers represent **$1,229.93** in revenue
- Lost customers represent **$729.97** in revenue

### 3. Support Overload
- **53.3%** of all support tickets are `late_delivery` related
- This category appears **every single month** without exception
- `late_delivery` tickets take an average of **47.2 hours** to resolve — the longest of any category
- 2 tickets currently overdue (open > 14 days)

---

## The Single Thread

```
Central Hub delays → late deliveries → support ticket spike → customer churn
```

Fixing the fulfillment process at Central Hub eliminates the root cause of all three issues simultaneously.

---

## Analytical Methods Used

- **Data profiling** — row counts, null checks, data quality anomalies
- **Aggregation & grouping** — late rates by warehouse, category, delay bucket
- **CTEs (Common Table Expressions)** — multi-step RFM scoring
- **Window logic** — recency, frequency, monetary scoring
- **Customer segmentation** — Champions, Loyal, At Risk, Lost
- **SLA ageing** — open ticket duration vs. 14-day threshold

---

## How to Run

1. Run `Schema.sql` to create all tables
2. Run `Seed.sql` to load all data
3. Run the data analysis files (`data_profiling.sql`, `bottleneck_fulfillment.sql`, etc.)

**Compatible with:** PostgreSQL 15+ (standard ANSI SQL — no extensions required)

---

## Next Steps

- Building a **Power BI dashboard** to visualise the fulfillment delays, RFM segments, and support ticket breakdown for a non-technical audience
- Exploring whether **Tableau or Streamlit** might better serve operational storytelling at this scale

---

## Author

Built as part of a data analytics portfolio project.  
Focus: operational analysis, customer segmentation, and business-led SQL storytelling.
