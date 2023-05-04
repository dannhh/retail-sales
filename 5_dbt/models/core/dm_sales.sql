{{ config(
      materialized = 'view',
      partition_by={
        "field": "invoice_date",
        "data_type": "timestamp",
        "granularity": "day"
      }
  ) }}

SELECT
    fact_sales.userKey AS userKey,
    fact_sales.dateKey AS dateKey,
    fact_sales.invoice_date AS timestamp,
    fact_sales.category AS category,
    fact_sales.quantity AS quantity,
    fact_sales.price AS price,
    fact_sales.payment_method AS payment_method,
    fact_sales.shopping_mall AS shopping_mall,

    dim_users.gender AS gender,
    dim_users.age AS level,
    dim_users.customerId as customerId,
    dim_users.currentRow as currentUserRow,

    dim_datetime.date AS dateHour,
    dim_datetime.dayOfMonth AS dayOfMonth,
    dim_datetime.dayOfWeek AS dayOfWeek,
    
FROM
    {{ ref('fact_sales') }}
JOIN
    {{ ref('dim_users') }} ON fact_sales.userKey = dim_users.userKey
JOIN
    {{ ref('dim_datetime') }} ON fact_sales.dateKey = dim_datetime.dateKey
