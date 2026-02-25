-- models/core/dim_users.sql
select
  user_id,
  signup_ts,
  signup_channel,
  state
from {{ ref('stg_users') }};
