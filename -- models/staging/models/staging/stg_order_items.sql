-- models/staging/stg_order_items.sql
select
  trim(order_id)                    as order_id,
  trim(product_id)                  as product_id,
  cast(quantity as integer)         as quantity,
  cast(unit_price as numeric(10,2)) as unit_price,
  cast(discount_usd as numeric(10,2)) as discount_usd
from raw_order_items
where order_id is not null
  and product_id is not null;
