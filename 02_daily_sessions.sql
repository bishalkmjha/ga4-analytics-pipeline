-- Daily session volume across the 92-day period.
-- event_date arrives as a STRING (YYYYMMDD), so it is parsed to DATE
-- for correct time-series plotting downstream.

SELECT
  PARSE_DATE('%Y%m%d', event_date) AS day,
  COUNT(DISTINCT CONCAT(user_pseudo_id,
    CAST((SELECT value.int_value FROM UNNEST(event_params)
          WHERE key = 'ga_session_id') AS STRING))) AS sessions
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY day
ORDER BY day
