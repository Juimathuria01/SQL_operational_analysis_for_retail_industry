-- ============================================================
--  RetailCo — Database Schema (fixed)
--  Compatible with: PostgreSQL 15 / standard ANSI SQL
--  Uses TEXT primary keys — no UUID extension required
-- ============================================================

DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS warehouses;


CREATE TABLE warehouses (
    warehouse_id  TEXT          PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL,
    city          VARCHAR(100)  NOT NULL,
    state         CHAR(2)       NOT NULL,
    capacity      INT           NOT NULL
);

CREATE TABLE customers (
    customer_id   TEXT          PRIMARY KEY,
    email         VARCHAR(255)  NOT NULL UNIQUE,
    full_name     VARCHAR(255)  NOT NULL,
    city          VARCHAR(100),
    state         CHAR(2),
    created_at    DATE          NOT NULL,
    tier          VARCHAR(20)   NOT NULL DEFAULT 'standard'
        CHECK (tier IN ('standard', 'silver', 'gold', 'vip'))
);

CREATE TABLE products (
    product_id    TEXT          PRIMARY KEY,
    name          VARCHAR(255)  NOT NULL,
    category      VARCHAR(100)  NOT NULL,
    sku           VARCHAR(50)   NOT NULL UNIQUE,
    cost_price    NUMERIC(10,2) NOT NULL,
    list_price    NUMERIC(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id              TEXT           PRIMARY KEY,
    customer_id           TEXT           NOT NULL REFERENCES customers(customer_id),
    ordered_at            TIMESTAMP      NOT NULL,
    promised_delivery_at  TIMESTAMP      NOT NULL,
    status                VARCHAR(20)    NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','processing','shipped','delivered','cancelled','returned')),
    total_amount          NUMERIC(10,2)  NOT NULL,
    channel               VARCHAR(20)    NOT NULL DEFAULT 'web'
        CHECK (channel IN ('web','mobile','marketplace'))
);

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status   ON orders(status);
CREATE INDEX idx_orders_ordered  ON orders(ordered_at);

CREATE TABLE order_items (
    item_id       TEXT           PRIMARY KEY,
    order_id      TEXT           NOT NULL REFERENCES orders(order_id),
    product_id    TEXT           NOT NULL REFERENCES products(product_id),
    quantity      INT            NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2)  NOT NULL
);

CREATE INDEX idx_items_order   ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);

CREATE TABLE shipments (
    shipment_id   TEXT          PRIMARY KEY,
    order_id      TEXT          NOT NULL REFERENCES orders(order_id),
    warehouse_id  TEXT          NOT NULL REFERENCES warehouses(warehouse_id),
    shipped_at    TIMESTAMP,
    delivered_at  TIMESTAMP,
    carrier       VARCHAR(50)   NOT NULL,
    status        VARCHAR(20)   NOT NULL DEFAULT 'in_transit'
        CHECK (status IN ('in_transit','delivered','lost','returned'))
);

CREATE INDEX idx_shipments_order     ON shipments(order_id);
CREATE INDEX idx_shipments_warehouse ON shipments(warehouse_id);

CREATE TABLE support_tickets (
    ticket_id     TEXT          PRIMARY KEY,
    order_id      TEXT          REFERENCES orders(order_id),
    customer_id   TEXT          NOT NULL REFERENCES customers(customer_id),
    created_at    TIMESTAMP     NOT NULL,
    resolved_at   TIMESTAMP,
    category      VARCHAR(30)   NOT NULL
        CHECK (category IN ('late_delivery','wrong_item','damaged','billing','return_request','other')),
    priority      VARCHAR(10)   NOT NULL DEFAULT 'medium'
        CHECK (priority IN ('low','medium','high','critical')),
    status        VARCHAR(20)   NOT NULL DEFAULT 'open'
        CHECK (status IN ('open','in_progress','resolved','closed'))
);

CREATE INDEX idx_tickets_customer ON support_tickets(customer_id);
CREATE INDEX idx_tickets_order    ON support_tickets(order_id);
CREATE INDEX idx_tickets_created  ON support_tickets(created_at);
CREATE INDEX idx_tickets_status   ON support_tickets(status);

