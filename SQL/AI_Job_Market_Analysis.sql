CREATE DATABASE job_market;

USE job_market;

-- Enable local file loading from client machine 
 -- This allows MySQL to read files from your local system 
SET GLOBAL local_infile = 1;
 
-- -- Check if local_infile is currently enabled
-- Returns: local_infile = ON (or OFF)
-- Confirms whether file loading is active 
SHOW VARIABLES LIKE 'local_infile';

-- skills data
CREATE TABLE skills_job (
    job_id VARCHAR(20),
    skill VARCHAR(100)
);

-- load skills data from csv
LOAD DATA LOCAL INFILE
'C:/Users/shara/Desktop/LAHARI/2025/Resume Projects/Job market analytics/Data/skills_job.csv'
INTO TABLE skills_job
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- view the data 
SELECT * FROM skills_job LIMIT 5;

-- table for main dataset
CREATE TABLE cleaned_jobs (
    job_id VARCHAR(20),
    job_title VARCHAR(100),
    salary_usd INT,
    salary_currency VARCHAR(10),
    experience_level VARCHAR(30),
    employment_type VARCHAR(100),
    company_location VARCHAR(100),
    company_size VARCHAR(20),
    employee_residence VARCHAR(100),
    remote_ratio INT,
    education_required VARCHAR(50),
    years_experience INT,
    industry VARCHAR(100),
    posting_date DATE,
    application_deadline DATE,
    benefits_score DECIMAL(3,1),
    company_name VARCHAR(100)
);

-- load cleaned / main dataset 
LOAD DATA LOCAL INFILE
'C:/Users/shara/Desktop/LAHARI/2025/Resume Projects/Job market analytics/Data/cleaned_jobs.csv'
INTO TABLE cleaned_jobs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- View main data
SELECT * FROM cleaned_jobs LIMIT 5;

-- --------------------------------------
-- DIMENSIONS
-- --------------------------------------

-- 1. dim_job ( describes - what type of role )
CREATE TABLE dim_job AS
SELECT  DISTINCT 
		job_title,
        experience_level,
		employment_type
FROM cleaned_jobs;

-- 2. dim_company ( describes - company)
CREATE TABLE dim_company AS 
SELECT DISTINCT 
	company_name , 
    industry,
    company_size,
    company_location
FROM cleaned_jobs;

-- 3. dim_location (describes - geography)
CREATE TABLE  dim_location AS 
SELECT DISTINCT
	company_location , 
    employee_residence
FROM cleaned_jobs ;

-- 4. dim_date 
CREATE TABLE dim_date AS 
SELECT DISTINCT
	posting_date
FROM cleaned_jobs;
 
-- 5. dim_skills
CREATE TABLE dim_skills AS
SELECT DISTINCT
    skill
FROM skills_job;

-- --------------------------------------------
-- FACTS 
-- --------------------------------------------
CREATE TABLE fact_job_postings AS
SELECT
    job_title,
    company_name,
    company_location,
    posting_date,

    salary_usd,
    remote_ratio,
    years_experience,
    benefits_score

FROM cleaned_jobs;

SELECT * FROM fact_job_postings LIMIT 10;

-- ------------------------------------------------------
-- Standardize the currency column in Cleaned_jobs
-- ------------------------------------------------------
ALTER TABLE cleaned_jobs 
ADD salary_usd_standard DECIMAL(10,2);

UPDATE cleaned_jobs
SET salary_usd_standard =
CASE 
	WHEN salary_currency = 'USD' THEN salary_usd
    WHEN salary_currency = 'EUR' THEN salary_usd * 1.08
    WHEN salary_currency = 'GBP' THEN salary_usd * 1.27
    ELSE salary_usd
END;

SELECT * FROM cleaned_jobs LIMIT 5;

-- ------------------------------------------------------
-- ANALYSIS
-- ------------------------------------------------------
-- MARKET OVERVIEW

-- Total number of jobs posted
SELECT COUNT(*) AS total_jobs
FROM fact_job_postings;

-- Total number of companies
SELECT COUNT(*) AS total_companies
FROM dim_company;

-- Total unique skills required
SELECT COUNT(*) AS total_skills
FROM dim_skills;

-- Average salary (using FACT table + CTE)
WITH avg_salary_cte AS (
    SELECT salary_usd
    FROM fact_job_postings
)
SELECT ROUND(AVG(salary_usd),2) AS average_salary
FROM avg_salary_cte;

-- ------------------------------------------------------------
-- SALARY ANALYSIS
-- ------------------------------------------------------------

-- Job title vs average salary
SELECT 
    d.job_title,
    ROUND(AVG(f.salary_usd),2) AS avg_salary
FROM fact_job_postings f
JOIN dim_job d
ON f.job_title = d.job_title
GROUP BY d.job_title
ORDER BY avg_salary DESC;

-- Experience level vs salary stats
SELECT 
    d.experience_level,
    MIN(f.salary_usd) AS min_salary,
    MAX(f.salary_usd) AS max_salary,
    ROUND(AVG(f.salary_usd),2) AS avg_salary
FROM fact_job_postings f
JOIN dim_job d
ON f.job_title = d.job_title
GROUP BY d.experience_level
ORDER BY avg_salary DESC;

-- Company size vs average salary
SELECT 
    c.company_size,
    ROUND(AVG(f.salary_usd),2) AS avg_salary
FROM fact_job_postings f
JOIN dim_company c
ON f.company_name = c.company_name
GROUP BY c.company_size
ORDER BY avg_salary DESC;

-- Industry salary classification using CASE
SELECT 
    c.industry,
    ROUND(AVG(f.salary_usd),2) AS avg_salary,

    CASE
        WHEN AVG(f.salary_usd) >= 120000 THEN 'High Paying'
        WHEN AVG(f.salary_usd) >= 80000 THEN 'Medium Paying'
        ELSE 'Low Paying'
    END AS salary_category

FROM fact_job_postings f
JOIN dim_company c
ON f.company_name = c.company_name

GROUP BY c.industry
ORDER BY avg_salary DESC;

-- ------------------------------------------------------------
-- EXPERIENCE & WORK PATTERN
-- ------------------------------------------------------------

-- Experience level vs employment type
SELECT 
    d.experience_level,
    d.employment_type,
    COUNT(*) AS total_jobs
FROM fact_job_postings f
JOIN dim_job d
ON f.job_title = d.job_title
GROUP BY d.experience_level, d.employment_type
ORDER BY total_jobs DESC;

-- Company size vs experience level hiring
SELECT 
    c.company_size,
    d.experience_level,
    COUNT(*) AS total_hires
FROM fact_job_postings f
JOIN dim_company c
ON f.company_name = c.company_name
JOIN dim_job d
ON f.job_title = d.job_title
GROUP BY c.company_size, d.experience_level
ORDER BY total_hires DESC;

-- Remote work classification using CASE
SELECT 
    CASE
        WHEN remote_ratio = 100 THEN 'Fully Remote'
        WHEN remote_ratio = 50 THEN 'Hybrid'
        ELSE 'On Site'
    END AS remote_category,

    COUNT(*) AS total_jobs

FROM fact_job_postings
GROUP BY remote_category
ORDER BY total_jobs DESC;

-- ------------------------------------------------------------
-- SKILLS INTELLIGENCE
-- ------------------------------------------------------------

-- Most demanded skills overall
SELECT 
    skill,
    COUNT(*) AS demand_count
FROM skills_job
GROUP BY skill
ORDER BY demand_count DESC;

-- Industry vs most demanded skills
WITH skill_demand AS (
    SELECT 
        c.industry,
        s.skill,
        COUNT(*) AS demand_count
    FROM skills_job s
    JOIN cleaned_jobs c
    ON s.job_id = c.job_id

    GROUP BY c.industry, s.skill
)

SELECT *
FROM skill_demand
ORDER BY industry, demand_count DESC;

-- Skills with highest salary
SELECT 
    s.skill,
    ROUND(AVG(f.salary_usd),2) AS avg_salary
FROM skills_job s
JOIN cleaned_jobs c
ON s.job_id = c.job_id
JOIN fact_job_postings f
ON c.job_title = f.job_title
GROUP BY s.skill
ORDER BY avg_salary DESC;

-- ------------------------------------------------------------
-- GEOGRAPHY INSIGHTS
-- ------------------------------------------------------------

-- Country-wise job distribution
SELECT 
    l.company_location,
    COUNT(*) AS total_jobs
FROM fact_job_postings f
JOIN dim_location l
ON f.company_location = l.company_location
GROUP BY l.company_location
ORDER BY total_jobs DESC;

-- Employee residence distribution
SELECT 
    employee_residence,
    COUNT(*) AS total_jobs
FROM dim_location
GROUP BY employee_residence
ORDER BY total_jobs DESC;

-- ------------------------------------------------------------
-- COMPANY & INDUSTRY ANALYSIS
-- ------------------------------------------------------------

-- Top companies by hiring
SELECT 
    c.company_name,
    COUNT(*) AS total_hires
FROM fact_job_postings f
JOIN dim_company c
ON f.company_name = c.company_name
GROUP BY c.company_name
ORDER BY total_hires DESC;

-- Industry vs job postings
SELECT 
    c.industry,
    COUNT(*) AS total_jobs
FROM fact_job_postings f
JOIN dim_company c
ON f.company_name = c.company_name
GROUP BY c.industry
ORDER BY total_jobs DESC;

-- Company size vs hiring volume
SELECT 
    company_size,
    COUNT(*) AS total_jobs
FROM dim_company
GROUP BY company_size
ORDER BY total_jobs DESC;

-- ------------------------------------------------------------
-- TREND & TIME ANALYSIS
-- ------------------------------------------------------------

-- Year-wise hiring trend
SELECT 
    YEAR(d.posting_date) AS year,
    COUNT(*) AS total_jobs
FROM fact_job_postings f
JOIN dim_date d
ON f.posting_date = d.posting_date
GROUP BY YEAR(d.posting_date)
ORDER BY year;

-- Month-wise job trend
SELECT 
    DATE_FORMAT(d.posting_date,'%Y-%m') AS year_month,
    COUNT(*) AS total_jobs
FROM fact_job_postings f
JOIN dim_date d
ON f.posting_date = d.posting_date
GROUP BY year_month
ORDER BY year_month;

-- Highest hiring month
WITH monthly_jobs AS (
    SELECT 
        DATE_FORMAT(posting_date,'%Y-%m') AS year_month,
        COUNT(*) AS total_jobs
    FROM fact_job_postings
    GROUP BY year_month
)

SELECT *
FROM monthly_jobs
ORDER BY total_jobs DESC
LIMIT 1;

-- ------------------------------------------------------------
-- ADVANCED INSIGHTS
-- ------------------------------------------------------------

-- Benefits score classification
SELECT 
    company_name,

    ROUND(AVG(benefits_score),2) AS avg_benefits,

    CASE
        WHEN AVG(benefits_score) >= 8 THEN 'Excellent Benefits'
        WHEN AVG(benefits_score) >= 5 THEN 'Average Benefits'
        ELSE 'Low Benefits'
    END AS benefit_category

FROM fact_job_postings
GROUP BY company_name
ORDER BY avg_benefits DESC;

-- Seniority classification using CASE
SELECT 
    years_experience,

    CASE
        WHEN years_experience <= 2 THEN 'Junior'
        WHEN years_experience <= 5 THEN 'Mid-Level'
        ELSE 'Senior'
    END AS seniority_level,

    COUNT(*) AS total_jobs

FROM fact_job_postings
GROUP BY years_experience, seniority_level
ORDER BY years_experience;