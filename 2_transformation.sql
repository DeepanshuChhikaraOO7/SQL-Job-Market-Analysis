-- Populating the lookup table
INSERT INTO industry_ratings (industry_name, work_life_balance_rating) VALUES
('Technology', 8),
('Healthcare', 7),
('Finance', 6),
('Education', 9),
('Manufacturing', 5);

-- THE MAIN ETL SCRIPT:
-- This single query performs all the data cleaning, transformation, and loading.
INSERT INTO job_postings_clean (
    job_title, seniority_level, status, company_name, location, post_date,
    headquarter, industry, ownership, company_size, revenue,
    salary_min, salary_max, salary_avg, skills
)
SELECT 
    TRIM(job_title),
    TRIM(seniority_level),
    TRIM(status),
    TRIM(company_name),
    TRIM(location),
    
    -- Date transformation logic (with fixes for 'a' and pluralization)
    CASE
        WHEN post_date LIKE '%day% ago' THEN CURRENT_DATE - (CAST(SPLIT_PART(REPLACE(post_date, 'a ', '1 '), ' ', 1) AS INTEGER) * INTERVAL '1 day')
        WHEN post_date LIKE '%days% ago' THEN CURRENT_DATE - (CAST(SPLIT_PART(post_date, ' ', 1) AS INTEGER) * INTERVAL '1 day')
        WHEN post_date LIKE '%month% ago' THEN CURRENT_DATE - (CAST(SPLIT_PART(REPLACE(post_date, 'a ', '1 '), ' ', 1) AS INTEGER) * INTERVAL '1 month')
        WHEN post_date LIKE '%months% ago' THEN CURRENT_DATE - (CAST(SPLIT_PART(post_date, ' ', 1) AS INTEGER) * INTERVAL '1 month')
        ELSE NULL
    END,
    
    TRIM(headquarter),
    TRIM(industry),
    TRIM(ownership),
    TRIM(company_size),
    TRIM(revenue),
    
    -- Min Salary Calculation
    CAST(REPLACE(TRIM(SPLIT_PART(REPLACE(salary, '€', ''), '-', 1)), ',', '') AS INTEGER),

    -- Max Salary Calculation
    CASE
        WHEN salary LIKE '%-%' THEN CAST(REPLACE(TRIM(SPLIT_PART(REPLACE(salary, '€', ''), '-', 2)), ',', '') AS INTEGER)
        ELSE CAST(REPLACE(TRIM(SPLIT_PART(REPLACE(salary, '€', ''), '-', 1)), ',', '') AS INTEGER)
    END,
    
    -- Average Salary Calculation (with fixes for € symbol)
    CASE
        WHEN salary LIKE '%-%' THEN 
            CAST(((CAST(REPLACE(TRIM(SPLIT_PART(REPLACE(salary, '€', ''), '-', 1)), ',', '') AS INTEGER) +
                   CAST(REPLACE(TRIM(SPLIT_PART(REPLACE(salary, '€', ''), '-', 2)), ',', '') AS INTEGER)) / 2.0) AS INTEGER)
        WHEN salary NOT LIKE '%-%' THEN 
            CAST(REPLACE(REPLACE(TRIM(salary), '€', ''), ',', '') AS INTEGER)
        ELSE NULL
    END,
    
    TRIM(skills)
FROM job_posting;