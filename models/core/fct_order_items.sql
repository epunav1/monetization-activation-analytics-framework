-- models/core/fct_order_items.sql
select
  oi.order_id,
  oi.product_id,
  oi.quantity,
  oi.unit_price,
  oi.discount_usd,
  -- line revenue before discount
  (oi.quantity * oi.unit_price) as gross_revenue_usd,
  -- net revenue after discount
  (oi.quantity * oi.unit_price) - coalesce(oi.discount_usd, 0) as net_revenue_usd
from {{ ref('stg_order_items') }} oi;
