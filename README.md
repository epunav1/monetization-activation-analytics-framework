![SQL](https://img.shields.io/badge/lang-SQL-blue)
![dbt Style](https://img.shields.io/badge/dbt%20style-yes-green)

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
## Data Dictionary (Key Columns)

**raw_users**
- user_id
- signup_ts
- signup_channel

**raw_orders**
- order_id, user_id, campaign_id, order_ts

**raw_order_items**
- order_id, product_id, quantity, unit_price, discount_usd

(…similar for campaigns/products)
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

## Key Models

### **Dimension Tables**
- `dim_users`  
- `dim_products`  
- `dim_campaigns`

### **Fact Tables**
- `fct_orders`  
- `fct_order_items`  
  - Includes **gross & net revenue logic**

### **KPI Marts**
- `mart_campaign_performance` — campaign revenue, purchases, AOV, ROAS proxy  
- `mart_user_activation` — activation and repeat behavior  
- `mart_product_monetization` — revenue drivers + repeat buyers

---

## Data Quality
Included basic `unique` and `not_null` tests in `models/schema.yml`:
- Ensures PK integrity for dims and facts
- Validates core attribute expectations

---

## Usage Notes
1. Populate raw tables with `data/raw_setup.sql`  
2. Run transformations in dependency order:
   staging → core → marts  
3. Review KPI marts for business insights

---

## Future Enhancements
- Incremental strategy for large tables  
- Referential integrity constraints  
- BI dashboard design (Looker/Power BI mockups)  
- Cohort metrics & time-based retention analysis

---

## Author
**Victor Epuna**  
Analytics Engineer — monetization, activation & measurement  
LinkedIn: https://www.linkedin.com/in/victor-epuna-9905a2210  
Email: victor.epunae@gmail.com
