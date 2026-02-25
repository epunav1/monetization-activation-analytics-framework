-- data/raw_setup.sql
-- Simulated "raw" layer for a consumer purchase / rewards platform
-- Works in most SQL warehouses with minor tweaks (Snowflake/BigQuery/Postgres)

-- =========================
-- 1) RAW USERS
-- =========================
create table if not exists raw_users (
  user_id        varchar,
  signup_ts      timestamp,
  signup_channel varchar,
  state          varchar
);

insert into raw_users (user_id, signup_ts, signup_channel, state) values
('u001', '2025-01-03 10:12:00', 'organic', 'TX'),
('u002', '2025-01-05 08:40:00', 'paid_search', 'CA'),
('u003', '2025-01-06 21:15:00', 'referral', 'NY'),
('u004', '2025-01-10 13:05:00', 'paid_social', 'TX'),
('u005', '2025-01-12 09:30:00', 'organic', 'NJ');

-- =========================
-- 2) RAW PRODUCTS
-- =========================
create table if not exists raw_products (
  product_id   varchar,
  product_name varchar,
  department   varchar,
  aisle        varchar,
  unit_price   numeric(10,2)
);

insert into raw_products (product_id, product_name, department, aisle, unit_price) values
('p101', 'Sparkling Water 12pk', 'Beverages', 'Water', 5.99),
('p102', 'Protein Bar Box',      'Snacks',    'Nutrition', 12.49),
('p103', 'Ground Coffee 12oz',   'Beverages', 'Coffee', 9.49),
('p104', 'Greek Yogurt 4ct',     'Dairy',     'Yogurt', 4.79),
('p105', 'Laundry Detergent',    'Household', 'Laundry', 14.99);

-- =========================
-- 3) RAW CAMPAIGNS (monetization/activation)
-- =========================
create table if not exists raw_campaigns (
  campaign_id   varchar,
  campaign_name varchar,
  channel       varchar,
  start_date    date,
  end_date      date,
  budget_usd    numeric(12,2)
);

insert into raw_campaigns (campaign_id, campaign_name, channel, start_date, end_date, budget_usd) values
('c001', 'New Year Cashback',  'paid_social', '2025-01-01', '2025-01-31', 25000.00),
('c002', 'Search Brand Push',  'paid_search', '2025-01-05', '2025-02-05', 18000.00),
('c003', 'Referral Boost',     'referral',    '2025-01-10', '2025-02-10',  6000.00);

-- =========================
-- 4) RAW ORDERS
-- =========================
create table if not exists raw_orders (
  order_id      varchar,
  user_id       varchar,
  order_ts      timestamp,
  campaign_id   varchar,
  store_id      varchar,
  status        varchar
);

insert into raw_orders (order_id, user_id, order_ts, campaign_id, store_id, status) values
('o9001', 'u001', '2025-01-04 12:05:00', 'c001', 's001', 'completed'),
('o9002', 'u002', '2025-01-06 18:22:00', 'c002', 's002', 'completed'),
('o9003', 'u003', '2025-01-08 09:10:00', null,   's001', 'completed'),
('o9004', 'u001', '2025-01-15 20:45:00', 'c001', 's003', 'completed'),
('o9005', 'u004', '2025-01-18 11:02:00', 'c003', 's002', 'cancelled'),
('o9006', 'u005', '2025-01-20 14:35:00', 'c002', 's001', 'completed'),
('o9007', 'u002', '2025-01-28 16:50:00', 'c002', 's002', 'completed');

-- =========================
-- 5) RAW ORDER ITEMS (line-items)
-- =========================
create table if not exists raw_order_items (
  order_id      varchar,
  product_id    varchar,
  quantity      integer,
  unit_price    numeric(10,2),
  discount_usd  numeric(10,2)
);

insert into raw_order_items (order_id, product_id, quantity, unit_price, discount_usd) values
('o9001','p101',2, 5.99, 0.50),
('o9001','p104',1, 4.79, 0.00),
('o9002','p102',1,12.49, 1.00),
('o9002','p103',1, 9.49, 0.00),
('o9003','p101',1, 5.99, 0.00),
('o9004','p105',1,14.99, 2.00),
('o9004','p103',2, 9.49, 0.00),
('o9006','p104',3, 4.79, 0.75),
('o9006','p101',1, 5.99, 0.00),
('o9007','p102',1,12.49, 0.00);
