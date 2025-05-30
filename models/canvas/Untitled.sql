WITH customers AS (
  /* Customer overview data mart, offering key details for each unique customer. One row per customer. */
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'customers') }}
), aggregation AS (
  SELECT
    SUM(LIFETIME_SPEND) AS sum_LIFETIME_SPEND
  FROM customers
), untitled_sql AS (
  SELECT
    *
  FROM aggregation
)
SELECT
  *
FROM untitled_sql