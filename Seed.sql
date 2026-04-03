-- ============================================================
--  RetailCo — Seed Data (fixed)
--  Run AFTER schema.sql
--  IDs are plain text strings — no UUID casting needed
-- ============================================================

-- Warehouses
INSERT INTO warehouses (warehouse_id, name, city, state, capacity) VALUES
  ('wh-001', 'West Coast Hub', 'Los Angeles', 'CA', 2000),
  ('wh-002', 'Central Hub',    'Dallas',      'TX', 1500),
  ('wh-003', 'East Coast Hub', 'Newark',      'NJ', 1800);


-- Customers
INSERT INTO customers (customer_id, email, full_name, city, state, created_at, tier) VALUES
  ('cust-001', 'sarah.chen@email.com',     'Sarah Chen',     'San Francisco', 'CA', '2021-03-15', 'vip'),
  ('cust-002', 'marcus.johnson@email.com', 'Marcus Johnson', 'Chicago',       'IL', '2021-07-22', 'gold'),
  ('cust-003', 'priya.patel@email.com',    'Priya Patel',    'Houston',       'TX', '2022-01-10', 'gold'),
  ('cust-004', 'tom.riley@email.com',      'Tom Riley',      'New York',      'NY', '2022-04-05', 'silver'),
  ('cust-005', 'diana.wu@email.com',       'Diana Wu',       'Seattle',       'WA', '2022-06-18', 'vip'),
  ('cust-006', 'james.okafor@email.com',   'James Okafor',   'Atlanta',       'GA', '2022-08-30', 'standard'),
  ('cust-007', 'emily.santos@email.com',   'Emily Santos',   'Miami',         'FL', '2022-11-12', 'silver'),
  ('cust-008', 'david.kim@email.com',      'David Kim',      'Los Angeles',   'CA', '2023-01-08', 'gold'),
  ('cust-009', 'lisa.morgan@email.com',    'Lisa Morgan',    'Phoenix',       'AZ', '2023-02-25', 'standard'),
  ('cust-010', 'ryan.torres@email.com',    'Ryan Torres',    'Denver',        'CO', '2023-04-14', 'standard'),
  ('cust-011', 'nina.clark@email.com',     'Nina Clark',     'Boston',        'MA', '2023-05-20', 'silver'),
  ('cust-012', 'alex.nguyen@email.com',    'Alex Nguyen',    'Portland',      'OR', '2023-06-03', 'standard'),
  ('cust-013', 'rachel.adams@email.com',   'Rachel Adams',   'Dallas',        'TX', '2023-07-17', 'gold'),
  ('cust-014', 'carlos.reyes@email.com',   'Carlos Reyes',   'San Antonio',   'TX', '2023-08-22', 'standard'),
  ('cust-015', 'jennifer.lee@email.com',   'Jennifer Lee',   'Minneapolis',   'MN', '2023-09-11', 'standard'),
  ('cust-016', 'mike.brown@email.com',     'Mike Brown',     'Philadelphia',  'PA', '2023-10-05', 'silver'),
  ('cust-017', 'anna.white@email.com',     'Anna White',     'Charlotte',     'NC', '2023-11-19', 'standard'),
  ('cust-018', 'kevin.hall@email.com',     'Kevin Hall',     'Las Vegas',     'NV', '2023-12-01', 'standard'),
  ('cust-019', 'sophie.martin@email.com',  'Sophie Martin',  'Nashville',     'TN', '2024-01-14', 'standard'),
  ('cust-020', 'omar.hassan@email.com',    'Omar Hassan',    'Detroit',       'MI', '2024-02-28', 'standard');


-- Products
INSERT INTO products (product_id, name, category, sku, cost_price, list_price) VALUES
  ('prod-001', '65" 4K Smart TV',            'Electronics', 'TV-65-4K',    420.00, 799.99),
  ('prod-002', 'Noise-Cancelling Headphones', 'Electronics', 'HP-NC-100',   85.00, 199.99),
  ('prod-003', 'Robot Vacuum Cleaner',        'Home Goods',  'RVC-200',    110.00, 279.99),
  ('prod-004', 'Air Purifier HEPA',           'Home Goods',  'AP-HEPA-01',  65.00, 149.99),
  ('prod-005', 'Mechanical Keyboard',         'Electronics', 'KBD-MECH-01', 55.00, 129.99),
  ('prod-006', 'Wireless Charging Pad',       'Electronics', 'CHG-WL-10',   18.00,  49.99),
  ('prod-007', 'Blender Pro 900W',            'Home Goods',  'BLD-900W',    40.00,  89.99),
  ('prod-008', 'Standing Desk Frame',         'Furniture',   'DSK-STD-01', 180.00, 399.99),
  ('prod-009', 'Ergonomic Chair',             'Furniture',   'CHR-ERG-01', 220.00, 549.99),
  ('prod-010', 'Smart Home Hub',              'Electronics', 'HUB-SMT-01',  45.00, 119.99),
  ('prod-011', 'LED Desk Lamp',               'Home Goods',  'LMP-LED-01',  22.00,  59.99),
  ('prod-012', 'Webcam 4K Pro',               'Electronics', 'CAM-4K-PRO',  60.00, 149.99);


-- Orders
INSERT INTO orders (order_id, customer_id, ordered_at, promised_delivery_at, status, total_amount, channel) VALUES
  ('ord-001', 'cust-001', '2024-01-05 09:12:00', '2024-01-10 23:59:00', 'delivered',  999.98, 'web'),
  ('ord-002', 'cust-002', '2024-01-08 14:30:00', '2024-01-13 23:59:00', 'delivered',  279.99, 'mobile'),
  ('ord-003', 'cust-003', '2024-01-12 11:05:00', '2024-01-17 23:59:00', 'delivered',  329.98, 'web'),
  ('ord-004', 'cust-004', '2024-01-15 16:45:00', '2024-01-20 23:59:00', 'delivered',  129.99, 'marketplace'),
  ('ord-005', 'cust-005', '2024-01-20 08:00:00', '2024-01-25 23:59:00', 'delivered', 1349.98, 'web'),
  ('ord-006', 'cust-006', '2024-02-01 10:22:00', '2024-02-06 23:59:00', 'delivered',  149.99, 'mobile'),
  ('ord-007', 'cust-007', '2024-02-05 13:15:00', '2024-02-10 23:59:00', 'delivered',  249.98, 'web'),
  ('ord-008', 'cust-008', '2024-02-10 09:45:00', '2024-02-15 23:59:00', 'delivered',  799.99, 'web'),
  ('ord-009', 'cust-001', '2024-02-14 17:30:00', '2024-02-19 23:59:00', 'delivered',  199.99, 'mobile'),
  ('ord-010', 'cust-009', '2024-02-18 12:00:00', '2024-02-23 23:59:00', 'delivered',   89.99, 'marketplace'),
  ('ord-011', 'cust-010', '2024-03-01 08:30:00', '2024-03-06 23:59:00', 'delivered',  549.99, 'web'),
  ('ord-012', 'cust-011', '2024-03-05 14:00:00', '2024-03-10 23:59:00', 'delivered',  209.98, 'web'),
  ('ord-013', 'cust-012', '2024-03-10 10:15:00', '2024-03-15 23:59:00', 'delivered',  399.99, 'mobile'),
  ('ord-014', 'cust-013', '2024-03-15 15:45:00', '2024-03-20 23:59:00', 'delivered',  679.98, 'web'),
  ('ord-015', 'cust-002', '2024-03-20 11:30:00', '2024-03-25 23:59:00', 'delivered',  119.99, 'marketplace'),
  ('ord-016', 'cust-014', '2024-04-02 09:00:00', '2024-04-07 23:59:00', 'delivered',  329.98, 'web'),
  ('ord-017', 'cust-015', '2024-04-08 13:20:00', '2024-04-13 23:59:00', 'delivered',  149.99, 'web'),
  ('ord-018', 'cust-016', '2024-04-12 16:00:00', '2024-04-17 23:59:00', 'delivered',  949.98, 'mobile'),
  ('ord-019', 'cust-003', '2024-04-20 10:45:00', '2024-04-25 23:59:00', 'returned',   279.99, 'web'),
  ('ord-020', 'cust-017', '2024-05-01 08:15:00', '2024-05-06 23:59:00', 'delivered',   59.99, 'marketplace'),
  ('ord-021', 'cust-005', '2024-05-05 14:30:00', '2024-05-10 23:59:00', 'delivered',  799.99, 'web'),
  ('ord-022', 'cust-018', '2024-05-10 11:00:00', '2024-05-15 23:59:00', 'cancelled',  399.99, 'web'),
  ('ord-023', 'cust-008', '2024-05-15 09:30:00', '2024-05-20 23:59:00', 'delivered',  549.99, 'mobile'),
  ('ord-024', 'cust-019', '2024-05-20 15:00:00', '2024-05-25 23:59:00', 'delivered',  209.98, 'web'),
  ('ord-025', 'cust-013', '2024-06-01 10:00:00', '2024-06-06 23:59:00', 'delivered',  899.98, 'web'),
  ('ord-026', 'cust-020', '2024-06-05 13:45:00', '2024-06-10 23:59:00', 'processing', 129.99, 'marketplace'),
  ('ord-027', 'cust-004', '2024-06-10 08:00:00', '2024-06-15 23:59:00', 'shipped',    279.99, 'web'),
  ('ord-028', 'cust-011', '2024-06-12 16:30:00', '2024-06-17 23:59:00', 'pending',    149.99, 'mobile'),
  ('ord-029', 'cust-001', '2024-06-15 09:15:00', '2024-06-20 23:59:00', 'processing', 999.99, 'web'),
  ('ord-030', 'cust-006', '2024-06-18 11:00:00', '2024-06-23 23:59:00', 'pending',     89.99, 'mobile');


-- Order Items
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price) VALUES
  ('item-001', 'ord-001', 'prod-001', 1, 799.99),
  ('item-002', 'ord-001', 'prod-002', 1, 199.99),
  ('item-003', 'ord-002', 'prod-003', 1, 279.99),
  ('item-004', 'ord-003', 'prod-004', 1, 149.99),
  ('item-005', 'ord-003', 'prod-005', 1, 129.99),
  ('item-006', 'ord-003', 'prod-006', 1,  49.99),
  ('item-007', 'ord-004', 'prod-005', 1, 129.99),
  ('item-008', 'ord-005', 'prod-001', 1, 799.99),
  ('item-009', 'ord-005', 'prod-009', 1, 549.99),
  ('item-010', 'ord-006', 'prod-004', 1, 149.99),
  ('item-011', 'ord-007', 'prod-002', 1, 199.99),
  ('item-012', 'ord-007', 'prod-006', 1,  49.99),
  ('item-013', 'ord-008', 'prod-001', 1, 799.99),
  ('item-014', 'ord-009', 'prod-002', 1, 199.99),
  ('item-015', 'ord-010', 'prod-007', 1,  89.99),
  ('item-016', 'ord-011', 'prod-009', 1, 549.99),
  ('item-017', 'ord-012', 'prod-002', 1, 199.99),
  ('item-018', 'ord-012', 'prod-011', 1,  59.99),
  ('item-019', 'ord-013', 'prod-008', 1, 399.99),
  ('item-020', 'ord-014', 'prod-008', 1, 399.99),
  ('item-021', 'ord-014', 'prod-003', 1, 279.99),
  ('item-022', 'ord-015', 'prod-010', 1, 119.99),
  ('item-023', 'ord-016', 'prod-005', 1, 129.99),
  ('item-024', 'ord-016', 'prod-003', 1, 279.99),
  ('item-025', 'ord-017', 'prod-004', 1, 149.99),
  ('item-026', 'ord-018', 'prod-001', 1, 799.99),
  ('item-027', 'ord-018', 'prod-002', 1, 199.99),
  ('item-028', 'ord-019', 'prod-003', 1, 279.99),
  ('item-029', 'ord-020', 'prod-011', 1,  59.99),
  ('item-030', 'ord-021', 'prod-001', 1, 799.99),
  ('item-031', 'ord-023', 'prod-009', 1, 549.99),
  ('item-032', 'ord-024', 'prod-002', 1, 199.99),
  ('item-033', 'ord-024', 'prod-011', 1,  59.99),
  ('item-034', 'ord-025', 'prod-001', 1, 799.99),
  ('item-035', 'ord-025', 'prod-010', 1, 119.99),
  ('item-036', 'ord-026', 'prod-005', 1, 129.99),
  ('item-037', 'ord-027', 'prod-003', 1, 279.99),
  ('item-038', 'ord-028', 'prod-004', 1, 149.99),
  ('item-039', 'ord-029', 'prod-001', 1, 799.99),
  ('item-040', 'ord-029', 'prod-002', 1, 199.99),
  ('item-041', 'ord-030', 'prod-007', 1,  89.99);


-- Shipments
-- NOTE: ship-025 has delivered_at < shipped_at — intentional data quality anomaly
INSERT INTO shipments (shipment_id, order_id, warehouse_id, shipped_at, delivered_at, carrier, status) VALUES
  ('ship-001', 'ord-001', 'wh-001', '2024-01-06 08:00:00', '2024-01-09 14:00:00', 'FedEx', 'delivered'),
  ('ship-002', 'ord-002', 'wh-002', '2024-01-09 09:00:00', '2024-01-16 17:00:00', 'UPS',   'delivered'),  -- LATE
  ('ship-003', 'ord-003', 'wh-003', '2024-01-13 10:00:00', '2024-01-16 12:00:00', 'FedEx', 'delivered'),
  ('ship-004', 'ord-004', 'wh-002', '2024-01-16 11:00:00', '2024-01-22 09:00:00', 'USPS',  'delivered'),  -- LATE
  ('ship-005', 'ord-005', 'wh-001', '2024-01-21 08:00:00', '2024-01-24 16:00:00', 'FedEx', 'delivered'),
  ('ship-006', 'ord-006', 'wh-002', '2024-02-02 09:00:00', '2024-02-09 11:00:00', 'UPS',   'delivered'),  -- LATE
  ('ship-007', 'ord-007', 'wh-003', '2024-02-06 10:00:00', '2024-02-09 15:00:00', 'FedEx', 'delivered'),
  ('ship-008', 'ord-008', 'wh-001', '2024-02-11 08:00:00', '2024-02-14 13:00:00', 'FedEx', 'delivered'),
  ('ship-009', 'ord-009', 'wh-001', '2024-02-15 09:00:00', '2024-02-18 10:00:00', 'FedEx', 'delivered'),
  ('ship-010', 'ord-010', 'wh-002', '2024-02-19 10:00:00', '2024-02-26 14:00:00', 'USPS',  'delivered'),  -- LATE
  ('ship-011', 'ord-011', 'wh-003', '2024-03-02 08:00:00', '2024-03-05 16:00:00', 'FedEx', 'delivered'),
  ('ship-012', 'ord-012', 'wh-002', '2024-03-06 09:00:00', '2024-03-12 11:00:00', 'UPS',   'delivered'),  -- LATE
  ('ship-013', 'ord-013', 'wh-001', '2024-03-11 10:00:00', '2024-03-14 09:00:00', 'FedEx', 'delivered'),
  ('ship-014', 'ord-014', 'wh-002', '2024-03-16 08:00:00', '2024-03-23 15:00:00', 'UPS',   'delivered'),  -- LATE
  ('ship-015', 'ord-015', 'wh-003', '2024-03-21 09:00:00', '2024-03-24 12:00:00', 'FedEx', 'delivered'),
  ('ship-016', 'ord-016', 'wh-002', '2024-04-03 10:00:00', '2024-04-10 14:00:00', 'USPS',  'delivered'),  -- LATE
  ('ship-017', 'ord-017', 'wh-001', '2024-04-09 08:00:00', '2024-04-12 11:00:00', 'FedEx', 'delivered'),
  ('ship-018', 'ord-018', 'wh-003', '2024-04-13 09:00:00', '2024-04-16 15:00:00', 'FedEx', 'delivered'),
  ('ship-019', 'ord-019', 'wh-002', '2024-04-21 10:00:00', '2024-04-30 13:00:00', 'UPS',   'returned'),   -- LATE + RETURNED
  ('ship-020', 'ord-020', 'wh-001', '2024-05-02 08:00:00', '2024-05-05 10:00:00', 'FedEx', 'delivered'),
  ('ship-021', 'ord-021', 'wh-001', '2024-05-06 09:00:00', '2024-05-09 14:00:00', 'FedEx', 'delivered'),
  ('ship-022', 'ord-023', 'wh-003', '2024-05-16 10:00:00', '2024-05-19 12:00:00', 'FedEx', 'delivered'),
  ('ship-023', 'ord-024', 'wh-002', '2024-05-21 08:00:00', '2024-05-28 16:00:00', 'USPS',  'delivered'),  -- LATE
  ('ship-024', 'ord-025', 'wh-001', '2024-06-02 09:00:00', '2024-06-05 11:00:00', 'FedEx', 'delivered'),
  ('ship-025', 'ord-027', 'wh-002', '2024-06-12 10:00:00', '2024-06-11 08:00:00', 'UPS',   'delivered');  -- DATA ERROR: delivered before shipped


-- Support Tickets
INSERT INTO support_tickets (ticket_id, order_id, customer_id, created_at, resolved_at, category, priority, status) VALUES
  ('tick-001', 'ord-002', 'cust-002', '2024-01-17 10:00:00', '2024-01-18 14:00:00', 'late_delivery',  'high',     'resolved'),
  ('tick-002', 'ord-004', 'cust-004', '2024-01-23 09:00:00', '2024-01-25 11:00:00', 'late_delivery',  'medium',   'resolved'),
  ('tick-003', 'ord-006', 'cust-006', '2024-02-10 14:00:00', '2024-02-12 16:00:00', 'late_delivery',  'high',     'resolved'),
  ('tick-004', 'ord-010', 'cust-009', '2024-02-27 10:00:00', '2024-03-01 09:00:00', 'late_delivery',  'medium',   'resolved'),
  ('tick-005', 'ord-003', 'cust-003', '2024-01-17 11:00:00', '2024-01-18 15:00:00', 'wrong_item',     'high',     'resolved'),
  ('tick-006', 'ord-012', 'cust-011', '2024-03-13 09:00:00', '2024-03-15 14:00:00', 'late_delivery',  'high',     'resolved'),
  ('tick-007', 'ord-014', 'cust-013', '2024-03-24 10:00:00', '2024-03-26 11:00:00', 'late_delivery',  'high',     'resolved'),
  ('tick-008', 'ord-016', 'cust-014', '2024-04-11 14:00:00', '2024-04-14 10:00:00', 'late_delivery',  'critical', 'resolved'),
  ('tick-009', 'ord-019', 'cust-003', '2024-05-01 09:00:00', NULL,                  'return_request', 'high',     'in_progress'),
  ('tick-010', 'ord-008', 'cust-008', '2024-02-15 10:00:00', '2024-02-16 12:00:00', 'damaged',        'high',     'resolved'),
  ('tick-011', 'ord-023', 'cust-008', '2024-05-20 11:00:00', '2024-05-21 15:00:00', 'billing',        'low',      'resolved'),
  ('tick-012', NULL,       'cust-001', '2024-03-10 09:00:00', '2024-03-11 10:00:00', 'other',          'low',      'resolved'),
  ('tick-013', 'ord-024', 'cust-019', '2024-05-29 10:00:00', NULL,                  'late_delivery',  'high',     'open'),
  ('tick-014', 'ord-029', 'cust-001', '2024-06-16 14:00:00', NULL,                  'billing',        'medium',   'open'),
  ('tick-015', 'ord-022', 'cust-018', '2024-05-11 10:00:00', '2024-05-13 09:00:00', 'other',          'low',      'closed');

