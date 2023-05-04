INSERT {{ BIGQUERY_DATASET }}.{{ CUSTOMER_SHOPPING_DATA_TABLE }}
SELECT
    COALESCE(invoice_no, 'NA') AS invoice_no,
    COALESCE(customer_id, 'NA') AS customer_id,
    COALESCE(gender, 'NA') AS gender,
    COALESCE(age, -1) AS age,
    COALESCE(category, 'NA') AS category,
    COALESCE(quantity, -1) AS quantity,
    COALESCE(price, -1.0) AS price,
    COALESCE(payment_method, 'NA') AS payment_method,
    invoice_date AS invoice_date,
    COALESCE(shopping_mall, 'NA') AS shopping_mall,

FROM {{ BIGQUERY_DATASET }}.{{ CUSTOMER_SHOPPING_DATA_TABLE}}_{{ logical_date.strftime("%m%d%H") }} -- Creates a table name with month day and hour values appended to it
                                                                                      -- like customer_shopping_data.json_032313 for 23-03-2022 13:00:00