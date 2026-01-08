Customer Retention & Churn Analysis
---
Olist E-Commerce Dataset | SQL (MSSQL), Excel, Tableau
***
Project Overview

This project analyzes customer purchasing behavior in an e-commerce marketplace to understand why customers fail to return after their first purchase and how retention impacts long-term business value.

Using SQL, Excel, and Tableau, I examined customer cohorts, churn behavior, and repeat purchase patterns to surface actionable business insights relevant to large marketplaces such as Shopee.
***
Business Objective

Identify key drivers of customer churn and retention in order to propose data-driven actions that improve repeat purchase behavior and customer lifetime value (CLV).
***
Dashboards

1️⃣ Overview Dashboard

Purpose: To understand overall customer behaviour and purchasing pattern.

Key metrics
- Average order frequency: 1.0
- Repeat purchase rate: 3.0%

Visuals
- Monthly Active Customers (line chart)
- Monthly New vs Returning Customers (stacked bar)

<img width="1574" height="1011" alt="Overview" src="https://github.com/user-attachments/assets/92180f7e-5809-4586-8d41-a247c476f344" />

2️⃣ Cohort Retention Dashboard

Purpose: To identify when customers churn.

Visuals
- Retention Heatmap by cohort month
- Retention Curve

Key observation
- Retention drops sharply from 100% in Month 0 to 0.48% in Month 1
- Retention stabilizes at extremely low levels afterward

<img width="1574" height="1011" alt="Cohort Retention" src="https://github.com/user-attachments/assets/58494a2a-4c01-405f-bc87-cfc0c0801b30" />

3️⃣ Churn Analysis Dashboard

Purpose: To quantify disengagement and inactivity.

Key Metrics
- Overall churn rate: 80%
- Average days of inactivity: 237 days

Visuals
- Active vs Churned Customers by Cohort Month

<img width="1574" height="1011" alt="Churn Analysis" src="https://github.com/user-attachments/assets/31044cb4-dc0c-4eeb-82ca-d625cc1d615a" />

***
Key Business Insights

:one: The platform functions primarily as a one-time purchase marketplace
- Average order frequency is 1.
- Only 3% of customers make repeat purchases.
> Most users transact once and never return.

:two: Early-stage churn is the largest value leak
- Over 99% of customers churn after their first month.
> Retention failure occurs immediately after the first purchase.

:three: Retention weakness is structural, not cohort-specific
- All cohorts exhibit similar early drop-offs.
> Indicates a platform-wide lifecycle issue rather than seasonal effects.

:four: Churn is the default customer outcome
- 80% churn rate with long inactivity periods.
> The business continuously replaces lost customers instead of compounding value.

:five: Acquisition masks retention failure
- Stable activity is driven by new customers.
> Top-line metrics hide severe underlying retention problems.
***
Business Recommendations
- Focus retention efforts on the first 30 days after purchase
- Introduce second-purchase incentives and post-purchase engagement
- Shift KPIs from acquisition volume to retention quality
- Prioritize reactivation for customers inactive for 30–90 days
***
Business Impact

➡️ Improving Month-1 retention would deliver disproportionate gains in customer lifetime value, reduce dependency on continuous acquisition, and improve marketing efficiency.
***
Dataset

Source: Olist E-Commerce Public Dataset (Kaggle)

Key tables:
- olist_orders
- olist_customers

Primary keys & fields:
- order_id
- customer_unique_id
- order_purchase_timestamp
***
Tools Used

:one: SQL (Microsoft SQL Server)
- Checking for data consistency
- Table joins and customer-level aggregation
- Cohort creation (first purchase month)
- Churn labeling using inactivity thresholds

:two: Excel
- Metric validation and sanity checks
- Retention heatmap (PivotTable)
- Churn and inactivity analysis

:three: Tableau
- KPI dashboards
- Cohort retention heatmaps
- Retention curves
- Churn and lifecycle analysis






