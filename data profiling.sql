--  Module 1 — Data Profiling
--  How big is this dataset?
select *
from(
select 'customers' as table_name, count(*) as row_count from customers cu
union all
select 'order_items', count(*) from order_items oi 
union all
select 'orders', count(*) from orders o 
union all
select 'products', count(*) from products p 
union all
select 'shipments', count(*) from shipments s 
union all
select 'support_tickets',count(*) from support_tickets st 
union all
select 'warehouses', count(*) from warehouses w)as counts
order by row_count desc;

--  What's the shape of the orders table?
select distinct o.status,count(o.status) as order_count from orders o
group by o.status
order by order_count DESC;

-- Are there data quality issues?
select shipment_id, order_id, shipment_id, delivered_at from shipments s 
where shipped_at > delivered_at;

-- Null check
select count(*) from support_tickets st 
where order_id is null;