-- models/core/dim_products.sql
select
  product_id,
  product_name,
  department,
  aisle,
  unit_price
from {{ ref('stg_products') }};
