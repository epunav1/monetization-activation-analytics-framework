# Monetization & Activation Analytics Framework

End-to-end analytics engineering project demonstrating scalable transformation layers, dimensional modeling, and KPI-ready marts to support monetization, activation, and measurement workflows.

---

## Tech Stack
- **SQL**  
- **dbt-style modeling** (`ref()`-based modular transforms)  
- **Dimensional modeling** (facts + dimensions)  
- **Data quality testing** (uniqueness, not null)  
- Warehouse concepts compatible with Snowflake / BigQuery / Postgres

---

## Business Use Cases
This project supports analytics questions like:
- Which campaigns drive the most revenue and purchasers?
- How effectively does budget translate into revenue (ROAS proxy)?
- What is the activation rate (users with 2+ orders)?
- Which products/categories generate the most repeat buyers?

---

## Architecture

**Raw → Staging → Core (Star Schema) → Marts (KPIs)**

- **Raw** — source-like raw tables
- **Staging** — cleaning + standardizing source layer
- **Core** — star schema (dims + facts)
- **Marts** — KPI-ready analytics outputs

---

## Repository Structure

### `data/`
- `raw_setup.sql`  
Creates and populates the **raw** tables:
- `raw_users`
- `raw_products`
- `raw_campaigns`
- `raw_orders`
- `raw_order_items`

### `models/`
#### `staging/` — Cleaning & Standardization
Staging models clean raw inputs and standardize values.

- `stg_users.sql`
- `stg_products.sql`
- `stg_campaigns.sql`
- `stg_orders.sql`
- `stg_order_items.sql`

#### `core/` — Star Schema (Trusted Layer)
Core models form the dimensional foundation used across analytics.

**Dimensions**
- `dim_users.sql`
- `dim_products.sql`
- `dim_campaigns.sql`

**Facts**
- `fct_orders.sql` (one row per order)
- `fct_order_items.sql` (one row per product per order, includes revenue calculations)

#### `marts/` — KPI Layer (Business-Ready Outputs)
KPI marts provide analytics-ready tables for reporting.

- `mart_campaign_performance.sql`  
  **Revenue + purchasers + AOV + ROAS proxy** (using campaign budget)

- `mart_user_activation.sql`  
  **Activation rate + repeat behavior + time-to-2nd order**

- `mart_product_monetization.sql`  
  **Revenue drivers + repeat buyers by product/category**

### `models/schema.yml`
Defines documentation + tests (dbt-style), including:
- `unique` and `not_null` tests for primary keys
- basic integrity checks for critical columns

---

## Key Models (What to Look At)

### Core Facts
- **`fct_orders`**
  - Grain: **one row per order**
  - Includes: user, timestamp, campaign, status

- **`fct_order_items`**
  - Grain: **one row per product per order**
  - Includes revenue logic:
    - `gross_revenue_usd = quantity * unit_price`
    - `net_revenue_usd = gross_revenue_usd - discount_usd`

### KPI Marts
- **`mart_campaign_performance`**
  - Orders, purchasers, net revenue, AOV
  - ROAS proxy = `net_revenue_usd / budget_usd`

- **`mart_user_activation`**
  - Activation definition: **2+ completed orders**
  - `days_to_second_order` measures activation speed

- **`mart_product_monetization`**
  - Net revenue, units sold, unique buyers
  - Repeat buyers = users purchasing a product in **2+ orders**

---

## Data Quality & Governance
This repo includes:
- **Primary key tests** (`unique`, `not_null`)
- **Standardized business logic** in shared transformation layers
- **Clear model grains** (order-level vs line-item-level)
- KPI logic built on trusted fact tables (prevents metric drift)

---

## How to Use (Portfolio / Demo)
This is a portfolio project, so you can:
1. Review `data/raw_setup.sql` to understand the source layer
2. Follow the dependency chain:
   - `staging/` → `core/` → `marts/`
3. Open the marts to see the final KPI outputs

---

## Future Enhancements
Possible next steps (if extending the project):
- Incremental materializations for large fact tables
- Stronger referential integrity tests
- BI layer (Looker/Power BI mock dashboard)
- Campaign attribution logic and cohort retention tables
- Cost/performance optimization notes (partitioning/clustering patterns)

---

## Author
**Victor Epuna**  
Analytics Engineer | Monetization, Activation & Measurement  
LinkedIn: https://www.linkedin.com/in/victor-epuna-9905a2210  
Email: victor.epunae@gmail.com
