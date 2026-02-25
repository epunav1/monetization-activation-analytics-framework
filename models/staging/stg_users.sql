-- models/staging/stg_users.sql
select
  trim(user_id)               as user_id,
  cast(signup_ts as timestamp) as signup_ts,
  lower(trim(signup_channel)) as signup_channel,
  upper(trim(state))          as state
from raw_users
where user_id is not null;
