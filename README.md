
# Marketing Growth Funnel Analysis (2018–2023)

This project analyzes user growth, acquisition, engagement, and retention for a fintech product across European markets (Austria, Germany, Spain, France, Greece, Italy, Northern Europe) between 2018 and 2023. It focuses on the full marketing and product funnel, from signups and KYC completion to activation (first-time MAU), net active users, churn, and reactivation.

## Project Objectives

- Describe trends in user signups and market share across countries over time  
- Evaluate funnel performance from signup → KYC → first-time MAU (FTMAU)  
- Measure net user engagement through net active MAU across years and markets  
- Assess churn and reactivation patterns to understand long-term user stickiness

This is a **descriptive analytics** project and does not aim to establish causal relationships (e.g., specific campaigns or macro events).

## Key Findings

### Signups & Growth
- France historically has the highest share of signups, but its share declines over time
- Germany's share of signups increases steadily and reaches ~40% by 2023
- Italy's signups drop to 0 in 2023 due to halted onboarding after 2022
- Austria and Northern Europe are the smallest but consistent markets

### Acquisition Funnel (Signup → KYC → FTMAU)
- Austria leads overall conversion from signup to FTMAU (~59%); Germany and Spain also perform strongly
- France and Northern Europe have weaker conversion rates and leaky funnels
- KYC completion is relatively strong in AUT/ESP/DEU/ITA and weaker in France

### Engagement (Net Active Users)
- 2022 shows a negative change in net active users in **all markets** (broad engagement decline)
- Germany, Spain, France, and Italy recover in 2023 but remain below 2019 levels
- Spain shows one of the strongest recoveries in 2023

### Retention (Churn & Reactivation)
- France and Germany have the highest churn rates (6-7%), partly reflecting their large user bases
- Austria and Germany show strong reactivation rates (~89-91%)
- Reactivation rates generally improve over time across all markets

## Repository Structure

| File | Purpose |
|------|---------|
| `Marketing-data-analysis_Python.ipynb` | Data cleaning, EDA, visualizations (Pandas/Matplotlib/Seaborn) |
| `Marketing-data-analysis_SQL.sql` | Postgres table creation, aggregations (conversions, YoY deltas) |
| `Marketing-data-analysis_Excel_vf.xlsx` | Data dictionary, pivots, seasonality, summary tables |
| `Marketing-data-analysis_ppt_Final.pptx/pdf` | Executive summary, charts, business inferences/actions |

## Data and Metrics

**Core fields** (per country, per month):
- `countrygroup` – Market/region (AUT, DEU, ESP, FRA, GrE, ITA, NEuro)
- `signups` – Users who completed signup
- `kyccompleted` – Users who completed KYC
- `firsttimemau` – First-time Monthly Active Users
- `lapsedmau` – Users who became inactive
- `reactivatedmau` – Previously lapsed users who returned
- `churnedmau` – Users who closed their account

**Calculated metrics**:
```

Net Active MAU = firsttimemau + reactivatedmau – lapsedmau
KYC conversion = kyccompleted / signups
FTMAU conversion = firsttimemau / kyccompleted
Signup → FTMAU = firsttimemau / signups
Reactivation rate = reactivatedmau / lapsedmau
Churn rate = churnedmau / lapsedmau

```

## Assumptions and Data Filters

- Italy data after 2022 excluded (halted new customer onboarding)
- Global/GLO/USA segments dropped to focus on European markets
- Duplicate rows removed (exact matches across all key metrics)
- 2017/2024 excluded due to incomplete data

##  How to Reproduce

### 1. Python Environment
```bash
pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook Marketing-data-analysis_Python.ipynb
```


### 2. SQL (Postgres)

```sql
-- Run create table + insert queries, then aggregation queries
-- See Marketing-data-analysis_SQL.sql
```


### 3. Excel

- Open `Marketing-data-analysis_Excel_vf.xlsx` for pivots and refresh data


## Tools Used

- **Python**: Pandas, NumPy, Matplotlib, Seaborn
- **SQL**: PostgreSQL
- **Excel**: Pivot tables, charts
- **PowerPoint**: Executive presentation


