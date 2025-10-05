------------------------------------------------
-- SECTION 1: DATA QUALITY AND AUDIT CHECKS
-------------------------------------------------

-- Audit 1: Checking for NULL values after cleaning
-- This confirms the reliability of our cleaning process.
-- Finding: The salary data was perfectly cleaned (0 NULLs), while the date transformation
-- had a ~1% failure rate (11 NULLs), which is an acceptable margin.
SELECT
    (SELECT COUNT(*) FROM job_postings_clean WHERE salary_avg IS NULL) AS null_salary_count,
    (SELECT COUNT(*) FROM job_postings_clean WHERE post_date IS NULL) AS null_date_count;


-- Audit 2: Sanity checking numerical ranges for outliers
-- This helps us understand the distribution and spot potential data entry errors.
-- Finding: The salary range is very wide, with a max of ~$2.7M, indicating a
-- potential outlier that could skew averages if not handled carefully.
SELECT
    MIN(salary_avg) AS lowest_salary,
    MAX(salary_avg) AS highest_salary,
    AVG(salary_avg) AS average_salary
FROM job_postings_clean;


-- Audit 3: Consistency check for categorical data
-- This ensures that our GROUP BY clauses will produce accurate results.
-- Finding: The seniority levels are clean and consistent, with 4 distinct categories.
SELECT DISTINCT seniority_level FROM job_postings_clean;


-------------------------------------------------
-- SECTION 2: ANALYTICAL QUESTIONS & INSIGHTS
-------------------------------------------------

-- Q1: Which companies are hiring the most?
-- Insight: The dataset is anonymized, but shows that hiring is concentrated,
-- with the top 10 companies accounting for over 20% of all job postings.
SELECT
    company_name,
    COUNT(*) AS posting_count
FROM job_postings_clean
GROUP BY company_name
ORDER BY posting_count DESC
LIMIT 10;


-- Q2: What is the distribution of jobs by seniority level?
-- Insight: The market demand is strongest for 'Senior' level professionals,
-- highlighting a need for experienced talent.
SELECT
    seniority_level,
    COUNT(*) AS number_of_jobs
FROM job_postings_clean
GROUP BY seniority_level
ORDER BY number_of_jobs DESC;


-- Q3: What is the pay gap between Junior and Senior roles?
-- Insight: There is a significant financial incentive for career progression,
-- with Senior roles earning on average over 40% more than Junior roles.
SELECT
    seniority_level,
    AVG(salary_avg) AS average_salary
FROM job_postings_clean
WHERE seniority_level IN ('Senior', 'Junior')
GROUP BY seniority_level
ORDER BY average_salary;


-- Q4: Which tech skills are the most in-demand?
-- Insight: Foundational skills like Python, SQL, and R are ubiquitous. After these,
-- specialized skills in Machine Learning and Cloud (AWS) are most frequently required.
SELECT
    SUM(CASE WHEN skills LIKE '%python%' THEN 1 ELSE 0 END) AS python_jobs,
    SUM(CASE WHEN skills LIKE '%sql%' THEN 1 ELSE 0 END) AS sql_jobs,
    SUM(CASE WHEN skills LIKE '%aws%' THEN 1 ELSE 0 END) AS aws_jobs,
    SUM(CASE WHEN skills LIKE '%r%' THEN 1 ELSE 0 END) AS r_jobs,
    SUM(CASE WHEN skills LIKE '%machine learning%' THEN 1 ELSE 0 END) AS ml_jobs,
    SUM(CASE WHEN skills LIKE '%spark%' THEN 1 ELSE 0 END) AS spark_jobs
FROM job_postings_clean;


-- Q5: Do jobs requiring cloud skills pay more?
-- Insight: Yes, jobs mentioning cloud skills (AWS, Azure, GCP) have a higher
-- average salary, demonstrating the high value of cloud expertise in the market.
WITH JobTags AS (
    SELECT
        salary_avg,
        CASE
            WHEN skills LIKE '%aws%' OR skills LIKE '%azure%' OR skills LIKE '%gcp%' THEN 'Cloud Job'
            ELSE 'Non-Cloud Job'
        END AS job_type
    FROM job_postings_clean
)
SELECT
    job_type,
    AVG(salary_avg) AS average_salary,
    COUNT(*) AS number_of_jobs
FROM JobTags
GROUP BY job_type;


-- Q6: Which job titles appear most frequently and pay over $100k?
-- Insight: 'Data Scientist' is the dominant job title in this dataset. Both it and
-- 'Machine Learning Engineer' are high-frequency, high-paying roles.
SELECT
    job_title,
    COUNT(*) AS job_title_count,
    AVG(salary_avg) AS average_salary
FROM job_postings_clean
GROUP BY job_title
HAVING COUNT(*) > 5 AND AVG(salary_avg) >= 100000
ORDER BY job_title_count DESC;


-- Q7: Which locations are the epicenters for high-paying data jobs (>$120k)?
-- Insight: The market for high-paying data jobs is heavily concentrated in the US,
-- with major tech hubs like San Francisco, Mountain View, and New York leading the way.
SELECT
    headquarter,
    COUNT(*) AS number_of_high_paying_jobs
FROM job_postings_clean
WHERE salary_avg >= 120000
GROUP BY headquarter
ORDER BY number_of_high_paying_jobs DESC
LIMIT 10;


-- Q8: (Using JOIN) What are the top 5 highest-paying jobs in industries with good work-life balance (rating >= 8)?
-- Insight: It is possible to find high-paying roles in industries rated for good work-life balance.
-- Technology and Education lead in offering these premium opportunities.
SELECT
    jpc.job_title,
    jpc.salary_avg,
    jpc.industry,
    ir.work_life_balance_rating
FROM job_postings_clean AS jpc
JOIN industry_ratings AS ir ON jpc.industry = ir.industry_name
WHERE ir.work_life_balance_rating >= 8
ORDER BY jpc.salary_avg DESC
LIMIT 5;