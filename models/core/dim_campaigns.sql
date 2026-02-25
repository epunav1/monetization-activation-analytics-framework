-- models/core/dim_campaigns.sql
select
  campaign_id,
  campaign_name,
  channel,
  start_date,
  end_date,
  budget_usd
from {{ ref('stg_campaigns') }};
