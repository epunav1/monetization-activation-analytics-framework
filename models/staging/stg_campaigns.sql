-- models/staging/stg_campaigns.sql
select
  trim(campaign_id)           as campaign_id,
  trim(campaign_name)         as campaign_name,
  lower(trim(channel))        as channel,
  cast(start_date as date)    as start_date,
  cast(end_date as date)      as end_date,
  cast(budget_usd as numeric(12,2)) as budget_usd
from raw_campaigns
where campaign_id is not null;
