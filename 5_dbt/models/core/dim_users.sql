{{ config(materialized = 'table') }} 

-- age column in the users dimension is considered to be a SCD2 change. Just for the purpose of learning to write SCD2 change queries. 
-- The below query is constructed to accommodate changing ages from free to paid and maintaining the latest state of the user along with
-- historical record of the user's age

SELECT
    {{ dbt_utils.surrogate_key(['customerId', 'rowActivationDate', 'age']) }} as userKey,
    *
FROM
(
    SELECT
        SAFE_CAST(REGEXP_REPLACE(customerId, '[^0-9 ]','') AS BIGINT) as customerId,
        gender,
        age,
        minDate as rowActivationDate,
        -- Choose the start date from the next record and add that as the expiration date for the current record
        LEAD(minDate, 1, '9999-12-31') OVER(PARTITION BY customerId, gender
                                            ORDER BY grouped) as rowExpirationDate,
        -- Assign a flag indicating which is the latest row for easier select queries 
        CASE WHEN RANK() OVER(
                PARTITION BY customerId, gender
                ORDER BY grouped desc
            ) = 1 THEN 1
            ELSE 0
        END AS currentRow
    FROM
    (
        -- Find the earliest date available for each free/paid status change
        SELECT customerId, gender, age, grouped,
            cast(min(date) as date) as minDate
        FROM
        -- Create distinct group of each age change to identify the change in age accurately
        (
            SELECT *,
                SUM(lagged) OVER(
                    PARTITION BY customerId, gender
                    ORDER BY date
                ) AS grouped
            FROM
            -- Lag the age and see where the user changes age from free to paid or otherwise
            (
                SELECT *,
                    CASE WHEN LAG(age, 1, -1) OVER (
                            PARTITION BY customerId, gender
                            ORDER BY date
                        ) <> age THEN 1
                        ELSE 0
                    END AS lagged
                FROM
                -- Select distinct state of user in each timestamp
                (
                    SELECT DISTINCT customer_id AS customerId, gender, age, invoice_date AS date
                    FROM {{ source('staging', 'customer_shopping_data') }}
                    WHERE customer_id <> 'NA'
                )
            )
        )
        GROUP BY customerId, gender, age, grouped
    )
    UNION ALL
    SELECT
        SAFE_CAST(REGEXP_REPLACE(customer_id, '[^0-9 ]','') AS BIGINT) as userKey,
        gender,
        age,
        CAST(min(invoice_date) as date) as rowActivationDate,
        DATE '9999-12-31' as rowExpirationDate,
        1 as currentRow
    FROM {{ source('staging', 'customer_shopping_data') }}
    WHERE
        customer_id = 'NA'
    GROUP BY
        customer_id,
        gender,
        age
)