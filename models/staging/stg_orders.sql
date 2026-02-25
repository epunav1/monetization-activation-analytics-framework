-- models/staging/stg_orders.sql
select
  trim(order_id)                 as order_id,
  trim(user_id)                  as user_id,
  cast(order_ts as timestamp)    as order_ts,
  nullif(trim(campaign_id), '')  as campaign_id,
  trim(store_id)                 as store_id,
  lower(trim(status))            as status
from raw_orders
where order_id is not null;
