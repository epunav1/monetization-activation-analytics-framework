-- models/marts/mart_product_monetization.sql
with orders as (
  select *
  from {{ ref('fct_orders') }}
  where status = 'completed'
),

items as (
  select
    oi.order_id,
    oi.product_id,
    oi.quantity,
    oi.net_revenue_usd
  from {{ ref('fct_order_items') }} oi
),

joined as (
  select
    o.user_id,
    o.order_id,
    o.order_ts,
    i.product_id,
    i.quantity,
    i.net_revenue_usd
  from orders o
  join items i using (order_id)
),

user_product_orders as (
  select
    user_id,
    product_id,
    count(distinct order_id) as orders_with_product
  from joined
  group by 1,2
)

select
  p.department,
  p.aisle,
  p.product_id,
  p.product_name,

  count(distinct j.order_id) as orders,
  count(distinct j.user_id)  as unique_buyers,
  sum(j.quantity)            as units_sold,
  sum(j.net_revenue_usd)     as net_revenue_usd,

  -- repeat buyers: users who bought the same product in 2+ orders
  sum(case when up.orders_with_product >= 2 then 1 else 0 end) as repeat_buyers

from joined j
join {{ ref('dim_products') }} p
  on j.product_id = p.product_id
join user_product_orders up
  on j.user_id = up.user_id
 and j.product_id = up.product_id
group by 1,2,3,4;
