{{ config(
    materialized = 'table',
    partition_by = { 
        "field": "invoice_date",
        "data_type": "timestamp",
        "granularity": "day" 
    }
) }}

WITH customer_shopping_data AS (
    SELECT * 
    FROM {{ source('staging', 'customer_shopping_data') }}
)
SELECT
    dim_users.userKey AS userKey,
    dim_datetime.dateKey AS dateKey,
    customer_shopping_data.invoice_date AS invoice_date,
    customer_shopping_data.category AS category,
    customer_shopping_data.quantity AS quantity,
    customer_shopping_data.price AS price,
    customer_shopping_data.payment_method AS payment_method,
    customer_shopping_data.shopping_mall AS shopping_mall,
FROM
    customer_shopping_data
    LEFT JOIN {{ ref('dim_users') }} 
        ON SAFE_CAST(REGEXP_REPLACE(customer_shopping_data.customer_id, '[^0-9 ]','') AS BIGINT) = dim_users.customerId
        AND CAST(customer_shopping_data.invoice_date AS DATE) >= dim_users.rowActivationDate
        AND CAST(customer_shopping_data.invoice_date AS DATE) < dim_users.RowExpirationDate
    LEFT JOIN {{ ref('dim_datetime') }} 
        ON dim_datetime.date = date_trunc(customer_shopping_data.invoice_date, HOUR)