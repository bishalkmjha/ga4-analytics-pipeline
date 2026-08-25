# GA4 → BigQuery → Looker Studio Analytics Pipeline

An end-to-end analytics pipeline built on Google's public GA4 e-commerce sample dataset: SQL modelling in BigQuery, visualised as a six-tile KPI dashboard in Looker Studio.

**Live dashboard:** https://datastudio.google.com/reporting/af364063-d8dc-4a75-b2f8-d9c106ca16a6

---

## Dataset

`bigquery-public-data.ga4_obfuscated_sample_ecommerce`

Google Analytics 4 event-level export from the Google Merchandise Store, obfuscated and published by Google. Period analysed: **1 Nov 2020 – 31 Jan 2021** (92 days).

| Metric | Value |
|---|---|
| Sessions | 360,129 |
| Users | 270,154 |
| Page views | 1,350,428 |

---

## Queries

| File | Purpose |
|---|---|
| `01_overview_kpis.sql` | Headline sessions, users, page views |
| `02_daily_sessions.sql` | Daily session volume for the time series |
| `03_traffic_sources.sql` | Users by acquisition source and medium |
| `04_device_mix.sql` | Device category breakdown |
| `05_daily_revenue.sql` | Daily purchases and revenue |
| `06_data_quality_checks.sql` | Date coverage and missing-session-ID checks |

---

## Notes on the data

**GA4 exports events, not sessions.** There is no session table. A session is reconstructed by concatenating `user_pseudo_id` with the `ga_session_id` event parameter and counting distinct values.

**Event parameters are nested.** `event_params` is a repeated record, so every parameter lookup uses an `UNNEST` subquery rather than direct field access.

**Tables are sharded by day.** The export creates one table per date (`events_20201101`, `events_20201102`, …). Queries use a wildcard with `_TABLE_SUFFIX` filtering so the scan is limited to the target date range rather than the full dataset.

**Field types needed correcting downstream.** `sessions` and `page_views` were inferred as dates by the BI layer on import and had to be reset to numeric before they would aggregate.

---

## Finding

Session volume held roughly steady across the 92 days, while daily revenue declined over the same period. Traffic was not the constraint — the drop sits in conversion or basket size.

Confirming which would require average order value by day and conversion rate segmented by acquisition source; the current queries model volume and revenue but do not yet separate those two effects.

---

## Built with

BigQuery (Sandbox tier) · Standard SQL · Looker Studio
