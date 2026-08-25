-- Data quality checks run before building the dashboard.
--
-- 1. Confirms the expected 92 days are present with no gaps.
-- 2. Surfaces events missing a ga_session_id, which would silently
--    undercount sessions in every downstream query.

SELECT
  COUNT(DISTINCT event_date) AS days_present,
  MIN(event_date) AS first_day,
  MAX(event_date) AS last_day,
  DATE_DIFF(PARSE_DATE('%Y%m%d', MAX(event_date)),
            PARSE_DATE('%Y%m%d', MIN(event_date)), DAY) + 1 AS days_expected,
  COUNTIF((SELECT value.int_value FROM UNNEST(event_params)
           WHERE key = 'ga_session_id') IS NULL) AS events_missing_session_id,
  COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
