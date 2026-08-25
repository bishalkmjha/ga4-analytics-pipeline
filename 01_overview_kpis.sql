-- Overview KPIs: sessions, users, page views across the full period
-- Sessions are derived by concatenating user_pseudo_id with ga_session_id,
-- since GA4 exports events rather than pre-aggregated sessions.

SELECT
  COUNT(DISTINCT CONCAT(user_pseudo_id,
    CAST((SELECT value.int_value FROM UNNEST(event_params)
          WHERE key = 'ga_session_id') AS STRING))) AS sessions,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(event_name = 'page_view') AS page_views
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
