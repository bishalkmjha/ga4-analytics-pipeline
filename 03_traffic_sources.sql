-- Users by acquisition source and medium.
-- COALESCE guards against NULL traffic_source fields, which appear
-- for direct traffic and some internal events.

SELECT
  COALESCE(traffic_source.source, '(none)') AS source,
  COALESCE(traffic_source.medium, '(none)') AS medium,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY source, medium
ORDER BY users DESC
