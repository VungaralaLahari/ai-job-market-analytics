# AI Job Market Analytics Dashboard

End-to-end Business Intelligence project analyzing global AI job market trends using SQL, Power BI, DAX, and dimensional modeling.

---

##  Project Overview

This project transforms raw AI job posting data into an interactive analytics dashboard to uncover:

- High-demand AI skills
- Salary trends across roles and industries
- Hiring growth patterns
- Geographic hiring distribution
- Experience-level salary differences
- Remote work and benefits trends

The goal was to build a complete BI workflow — from raw CSV data to a professional Power BI dashboard using star schema modeling and analytical SQL.

---

##  Tech Stack

- **Python (Pandas)** — data cleaning & transformation
- **MySQL** — database creation & analytical SQL
- **Power BI** — dashboard development
- **DAX** — KPI measures & calculated columns
- **MySQL Workbench** — SQL development
- **Git & GitHub** — version control

---

##  Data Modeling

Implemented a **Star Schema** warehouse model:

- **Fact Table**
  - `fact_job_postings`

- **Dimension Tables**
  - `dim_job`
  - `dim_company`
  - `dim_location`
  - `dim_skills`

The model was designed to support clean many-to-one relationships and scalable BI analytics.

---

##  Dashboard Features

### KPI Cards
- Total Jobs
- Total Companies
- Average Salary
- Unique Skills
- Average Benefits Score
- Average Remote Ratio

### Visuals
- Salary by Job Role
- Industry Hiring Trends
- Top Skills Analysis
- Experience vs Employment Type
- Company Size vs Salary
- Salary Category Distribution
- Geographic Hiring Map
- Executive Insights Table

### Interactive Filters
- Industry
- Experience Level
- Company Size
- Location
- Posting Date

---

##  Key Insights

- Python and SQL are the most demanded skills across industries.
- Executive and Senior roles receive the highest salaries.
- Large companies offer higher average compensation packages.
- Remote work adoption remains consistently high across AI roles.
- Hiring activity peaked during mid-2024.
- AI hiring is globally distributed across multiple countries and industries.

---

##  Project Structure

```text
AI-Job-Market-Analytics/
│
├── Data/
├── notebook/
│   └── Data_Cleaning.ipynb
│
├── SQL/
│   └── AI_Job_Market_Analysis.sql
│
├── Power bi/
│   ├── AI_Job_Market_Analysis_Dashboard.pbix
│   └── AI_Job_Market_Analysis_Dashboard.zip
│
├── Output/
│   └── AI_Job_Market_Analysis_Dashboard.png
│
└── README.md
|_ Business-Insights.md
```
---

## Project Workflow
``` text
Kaggle Dataset
      ↓
Python Data Cleaning
      ↓
Data Transformation
      ↓
MySQL Database
      ↓
Fact & Dimension Tables
      ↓
Power BI Modeling
      ↓
DAX Measures & KPIs
      ↓
Interactive Dashboard
```

## Project Notebook

### View the Jupyter Notebook

If GitHub notebook preview is unavailable, use the rendered notebook below:

**Data Cleaning Notebook:**

https://nbviewer.org/github/VungaralaLahari/ai-job-market-analytics/blob/main/notebook/Data_Cleaning.ipynb



```
