-- Device category breakdown by users and page views.

SELECT
  device.category AS device,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNTIF(event_name = 'page_view') AS page_views
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY device
ORDER BY users DESC
