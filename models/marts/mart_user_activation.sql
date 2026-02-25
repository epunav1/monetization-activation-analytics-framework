-- models/marts/mart_user_activation.sql
with orders as (
  select *
  from {{ ref('fct_orders') }}
  where status = 'completed'
),

user_orders as (
  select
    user_id,
    order_id,
    order_ts,
    row_number() over (partition by user_id order by order_ts) as order_num
  from orders
),

first_second as (
  select
    u.user_id,
    max(case when order_num = 1 then order_ts end) as first_order_ts,
    max(case when order_num = 2 then order_ts end) as second_order_ts,
    count(*) as total_orders
  from user_orders u
  group by 1
)

select
  u.user_id,
  u.signup_channel,
  u.state,

  f.first_order_ts,
  f.second_order_ts,
  f.total_orders,

  -- activation: user makes 2+ completed orders
  case when f.total_orders >= 2 then 1 else 0 end as is_activated,

  -- days to 2nd order (activation speed)
  case
    when f.second_order_ts is null then null
    else datediff('day', f.first_order_ts, f.second_order_ts)
  end as days_to_second_order

from {{ ref('dim_users') }} u
left join first_second f using (user_id);
