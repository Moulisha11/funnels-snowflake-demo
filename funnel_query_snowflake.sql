-- Assumes a table EVENTS(user_id, event_name, event_time TIMESTAMP, treatment INT)
-- If loading CSV to Snowflake, create a stage and COPY INTO events first (not included here).

-- 1. Create a materialized-like view (as SELECT) with first signup per user
WITH first_signup AS (
  SELECT user_id,
         MIN(event_time)::TIMESTAMP_NTZ AS signup_time
  FROM events
  WHERE event_name = 'signup'
  GROUP BY user_id
),

-- 2. events within 14 days of signup for core funnel
funnel_events AS (
  SELECT f.user_id,
         f.signup_time,
         e.event_name,
         e.event_time,
         DATEDIFF('day', f.signup_time, e.event_time) AS days_after_signup,
         e.treatment
  FROM first_signup f
  JOIN events e ON f.user_id = e.user_id
  WHERE e.event_time BETWEEN f.signup_time AND DATEADD(day, 14, f.signup_time)
    AND e.event_name IN ('signup','activate','first_deposit')
),

-- 3. funnel counts (distinct users per step)
funnel_counts AS (
  SELECT event_name,
         COUNT(DISTINCT user_id) AS users
  FROM funnel_events
  GROUP BY event_name
  ORDER BY CASE WHEN event_name='signup' THEN 1
                WHEN event_name='activate' THEN 2
                WHEN event_name='first_deposit' THEN 3 END
),

-- 4. cohort retention example (weekly cohorts)
cohorts AS (
  SELECT f.user_id,
         DATE_TRUNC('week', f.signup_time) AS cohort_week,
         DATE_TRUNC('week', e.event_time) AS event_week
  FROM first_signup f
  LEFT JOIN events e ON f.user_id = e.user_id
  WHERE e.event_time BETWEEN f.signup_time AND DATEADD(day, 90, f.signup_time)
),

cohort_agg AS (
  SELECT cohort_week,
         DATE_DIFF('week', cohort_week, event_week) AS week_num,
         COUNT(DISTINCT user_id) AS users
  FROM cohorts
  GROUP BY cohort_week, week_num
  ORDER BY cohort_week, week_num
)

-- Final result: you can run individual queries. 
SELECT * FROM funnel_counts;

-- To get cohort table: SELECT * FROM cohort_agg ORDER BY cohort_week, week_num;
