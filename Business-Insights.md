# Business Insights — AI Job Market Analytics

### This project analyzes global AI job market trends using SQL, Power BI, DAX, and dimensional modeling techniques. The goal was to transform raw job posting data into an interactive Business Intelligence dashboard capable of identifying salary trends, hiring growth, skill demand, geographic opportunities, and experience-level insights.
-- 
## Market Overview

- **976 total job postings** tracked across 16 companies and 24 unique skills
- **Average salary: $118,126** (standardized USD across currencies)
- **Average benefits score: 7.40 / 10** — above-average compensation packages across the market
- **49% average remote ratio** — nearly half of all AI roles offer remote or hybrid flexibility

---

## Salary Insights

### Salary Distribution
| Category | Jobs | Share |
|---|---|---|
| High (> $120K) | 380 | 38% |
| Medium ($70K – $120K) | 234 | 24% |
| Low (< $70K) | 362 | 37% |

- **38% of AI roles pay above $120K** — strong market for senior and specialized profiles
- **37% still fall below $70K**, concentrated in entry-level and freelance roles
- The **top paying role is AI Product Manager / Principal Data role** reaching ~$140K average

### Company Size vs Salary
- Large companies pay the highest average salaries, followed by mid-size
- Small companies compensate with higher remote flexibility and benefits scores in some cases

### Top Paying Companies
| Company | Avg Salary | Benefits | Remote |
|---|---|---|---|
| Cognitive Computing | $1,74,277 | 9.10 | 17% |
| Digital Transformation LLC | $1,54,368 | 9.20 | 25% |
| Algorithmic Solutions | $92,290 | 6.60 | 36% |
| Cloud AI Solutions | $1,19,350 | 8.00 | 36% |

> Note: The top two companies show very high salary figures — likely senior/executive-heavy hiring pipelines driving the average up.

---

## Skills Insights

### Top 5 Most Demanded Skills
1. **Python** — dominant across all AI roles, non-negotiable
2. **SQL** — consistently required even in ML-heavy roles
3. **TensorFlow** — top deep learning framework demand
4. **Kubernetes** — infrastructure and deployment skills entering mainstream AI hiring
5. **Git** — version control remains a baseline requirement

**Takeaway:** Python + SQL + one deep learning framework covers the minimum viable skill set for 80%+ of AI job postings. Kubernetes appearing in top 5 signals a shift toward MLOps and production-ready AI skills being expected even at mid-level.

---

## Experience and Employment Pattern

### Experience Level vs Employment Type
- **Executive and Senior levels** are predominantly full-time — companies are not hiring senior AI talent on contract
- **Entry level** has the highest share of freelance and contract roles — companies are testing talent before committing
- **Mid level** shows the most balanced distribution across full-time, contract, and freelance

**Takeaway:** If you are targeting full-time roles, senior-track positioning is critical. Entry-level candidates are more likely to land contract-to-hire than direct full-time offers.

---

## Industry Hiring Trend

- Hiring peaked around **July–October 2024** across Tech, Finance, and Healthcare
- A dip was observed in **late Q4 2024** — consistent with typical year-end hiring freezes
- Recovery visible from **January 2025** onward, especially in Tech and Finance
- Healthcare AI hiring shows the most consistent growth with fewer seasonal dips

**Takeaway:** January–March and July–September are the strongest windows for job applications in AI roles.

---

## Geographic Insights

- **North America dominates** AI job postings — US accounts for the majority of large-company hiring
- **Europe (UK, Germany, France)** is the second largest hub, particularly for Finance and Consulting AI roles
- **Asia-Pacific** presence is growing, concentrated in enterprise and mid-size companies
- **49% remote ratio** means geographic location is less of a barrier than it was 3–4 years ago

---

## Business Risk Flags

- **Only 16 unique companies** in the dataset — this is a relatively small sample and insights should be interpreted directionally, not as market-wide conclusions
- **Currency standardization used fixed rates** (EUR × 1.08, GBP × 1.27) — actual salary comparisons may vary with exchange rate fluctuations
- **Cognitive Computing's average salary of $174K** is a significant outlier — likely skewed by a small number of executive postings rather than reflecting typical compensation

---

## Summary for Recruiters

This dashboard demonstrates:
- End-to-end SQL pipeline with star schema modeling
- Currency normalization and data standardization
- DAX calculated measures and columns in Power BI
- Business storytelling across salary, skills, geography, and hiring trends
- Executive-level dashboard design with interactive slicers

