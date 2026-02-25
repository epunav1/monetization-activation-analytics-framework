-- models/staging/stg_products.sql
select
  trim(product_id)            as product_id,
  trim(product_name)          as product_name,
  trim(department)            as department,
  trim(aisle)                 as aisle,
  cast(unit_price as numeric(10,2)) as unit_price
from raw_products
where product_id is not null;
