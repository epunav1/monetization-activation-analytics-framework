-- models/core/fct_orders.sql
select
  order_id,
  user_id,
  order_ts,
  campaign_id,
  store_id,
  status
from {{ ref('stg_orders') }};
