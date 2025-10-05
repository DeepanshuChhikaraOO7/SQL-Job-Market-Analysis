-- STAGING TABLE: Designed to accept the raw, messy CSV data without errors.
-- Every column is TEXT to ensure the initial import is successful.
CREATE TABLE job_posting (
    job_title TEXT,
    seniority_level TEXT,
    status TEXT,
    company_name TEXT,
    location TEXT,
    post_date TEXT,
    headquarter TEXT,
    industry TEXT,
    ownership TEXT,
    company_size TEXT,
    revenue TEXT,
    salary TEXT,
    skills TEXT
);

-- PRODUCTION TABLE: Designed with clean, appropriate data types for analysis.
CREATE TABLE job_postings_clean (
    job_title TEXT,
    seniority_level VARCHAR(100),
    status VARCHAR(50),
    company_name TEXT,
    location TEXT,
    post_date DATE,
    headquarter TEXT,
    industry TEXT,
    ownership VARCHAR(100),
    company_size TEXT,
    revenue TEXT,
    salary_min INTEGER,
    salary_max INTEGER,
    salary_avg INTEGER,
    skills TEXT
);

-- LOOKUP TABLE: A small table created to practice and demonstrate JOINs.
CREATE TABLE industry_ratings (
    industry_name TEXT,
    work_life_balance_rating INT
);