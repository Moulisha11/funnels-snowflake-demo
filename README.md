# Funnel & Cohort demo — Moulisha R.

Short demo of event funnels, cohort retention, and a time-windowed A/B readout using synthetic data and Snowflake-compatible SQL. No PHI. This repo shows the exact queries and a short notebook with analysis.

Contents
- events.csv : synthetic event stream (user_id,event_name,event_time,treatment)
- funnel_query_snowflake.sql : Snowflake SQL to build funnels and cohort tables
- funnel_notebook.md : notebook-style steps (pandas) to run the analysis locally and produce one_page_readout.png

Conclusion (sample)
On this sample data the largest drop is between signup → activate. A lightweight uplift + survival prototype shows modest short-term lift for treatment; next step would be product instrumentation to validate on real event data.

If you want a quick walkthrough, I can demo the SQL and notebook in 10 minutes.
