WITH customers AS (
  /* Customer overview data mart, offering key details for each unique customer. One row per customer. */
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'customers') }}
), filter AS (
  SELECT
    *
  FROM customers
  WHERE
    LIFETIME_SPEND_PRETAX > 10
), untitled_sql AS (
  SELECT
    *
  FROM filter
)
SELECT
  *
FROM untitled_sql