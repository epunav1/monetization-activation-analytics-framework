-- models/marts/mart_campaign_performance.sql
with orders as (
  select * from {{ ref('fct_orders') }}
  where status = 'completed'
),

order_rev as (
  select
    oi.order_id,
    sum(oi.net_revenue_usd) as order_net_revenue_usd
  from {{ ref('fct_order_items') }} oi
  group by 1
),

joined as (
  select
    o.campaign_id,
    o.order_id,
    o.user_id,
    o.order_ts,
    coalesce(r.order_net_revenue_usd, 0) as order_net_revenue_usd
  from orders o
  left join order_rev r using (order_id)
)

select
  c.campaign_id,
  c.campaign_name,
  c.channel,
  c.start_date,
  c.end_date,
  c.budget_usd,

  count(distinct j.order_id) as orders,
  count(distinct j.user_id)  as purchasers,
  sum(j.order_net_revenue_usd) as net_revenue_usd,
  avg(j.order_net_revenue_usd) as avg_order_value_usd,

  case
    when c.budget_usd is null or c.budget_usd = 0 then null
    else sum(j.order_net_revenue_usd) / c.budget_usd
  end as roas_proxy

from {{ ref('dim_campaigns') }} c
left join joined j
  on c.campaign_id = j.campaign_id
group by 1,2,3,4,5,6;
