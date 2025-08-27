# Funnel & Cohort demo 
Short demo showing event funnels, cohort retention, and a simple A/B time-window readout. No real customers or PHI — this uses synthetic data and a Jupyter notebook.

What’s in this repo

- events.csv —> synthetic event stream (user_id, event_name, event_time, treatment)

- funnel_notebook.ipynb (and funnel_notebook.md) —> Jupyter notebook that loads the CSV, builds funnels, cohorts, and runs a lightweight uplift/logistic prototype. Produces PNG visuals.

- funnel_query_snowflake.sql —> Snowflake-ready SQL version of the funnel & cohort queries (I added the SQL but did not run it on Snowflake).

- funnel_counts.png, cohort_retention.png, ab_time_windows_pct.png —> outputs from the notebook (generated locally).

Run it locally (quick)

1.Clone the repo.

2.Create a virtual env and install deps:

python -m venv .venv
source .venv/bin/activate   # mac/linux
.venv\Scripts\activate      # windows
pip install -r requirements.txt


(If you don’t have requirements.txt, install: pandas numpy matplotlib seaborn statsmodels lifelines.)

3.Generate the synthetic events and run the notebook:

python make_synthetic_events.py   # writes events.csv
jupyter lab                       # open and run funnel_notebook.ipynb


Running the notebook will create the PNGs used in this repo.

About the Snowflake SQL

funnel_query_snowflake.sql is Snowflake-compatible SQL for building first_signup, funnel_events, and a cohort aggregation. I added the file as a ready-to-run script, but I have not executed it on a Snowflake instance. To run it in Snowflake you’ll need to: create a table for events, stage and copy the CSV, then run the SQL. The SQL uses Snowflake date functions — it’s ready to paste into the worksheet.

Quick takeaways (what these files show)

- funnel_counts.png —> where users drop off in the first 14 days (signup → activate → first_deposit).

- cohort_retention.png —> weekly retention heatmap by cohort; you can spot trends and changes over time.

- ab_time_windows_pct.png —> conversion rates by treatment across time windows (0–7, 8–30, 31+ days) with basic 95% CIs.

Notes

- All data is synthetic. No PHI.

- If you want me to run the Snowflake steps and push the results, I can do that (requires Snowflake access).

- Want a 10-minute walkthrough? Message me and I’ll share the exact queries and notebook cells I’d walk through.
