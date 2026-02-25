# Monetization & Activation Analytics Framework

End-to-end Analytics Engineering portfolio project demonstrating scalable transformation layers, dimensional modeling (star schema), data quality checks, and KPI-ready marts for **monetization, activation, and measurement** workflows.

This repo is intentionally structured in a **dbt-style** layout (staging → core → marts) to mirror how modern analytics engineering teams build reliable, reusable data assets.

---

## Tech Stack (Portfolio Focus)
- **SQL** (primary)
- **dbt-style modeling** (`ref()`-based dependencies)
- **Dimensional modeling** (facts + dimensions)
- **Data quality testing** (uniqueness, not-null, basic integrity)

> Note: The project uses **simulated raw data** to avoid confidentiality issues and keep the focus on modeling, transformations, and KPI logic.

---

## Business Use Cases
This framework supports common monetization + activation questions such as:
- Which campaigns drive the most revenue and purchasers?
- What is average order value (AOV) by campaign/channel?
- How quickly do users become “activated” (2nd purchase)?
- Which products/categories drive repeat purchasing and revenue?

---

## Architecture
**Raw → Staging → Core → Marts**

- **Raw**: source-like tables representing transactional and marketing data  
- **Staging**: standardizes column names/types, handles nulls, normalizes formats  
- **Core**: star schema (facts + dimensions) as the trusted foundation  
- **Marts**: KPI-ready models used for dashboards, reporting, and decision making

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
