# SQL-Powered Analysis of the Data Science Job Market

---

## 📌 Project Overview
The goal of this project was to perform an end-to-end data analysis of the data science job market. Starting with a raw, messy dataset of job postings, this project involved designing a database schema, executing a robust ETL (Extract, Transform, Load) process, cleaning and verifying the data, and performing analytical queries to uncover key insights into industry trends, required skills, and salary benchmarks.  

This project showcases a comprehensive understanding of data processing and analysis using SQL in a PostgreSQL environment, connected and managed through **DBeaver**.

---

## 🛠 Tools Used
- **Database:** PostgreSQL  
- **IDE:** DBeaver (for connecting and managing PostgreSQL)  
- **Language:** SQL  

---

## 🔄 Project Workflow

### 1. Database Schema Design (`1_schema.sql`)
A two-table schema was designed to ensure data integrity and facilitate a robust ETL process.  

- **job_posting (Staging Table):** All columns were set to the `TEXT` data type. This strategic choice guaranteed that the raw CSV data, with all its inconsistencies and errors, could be loaded successfully without failure.  
- **job_postings_clean (Production Table):** This final table was designed with clean, appropriate data types (`INTEGER`, `DATE`, `TEXT`, etc.) to hold the structured data ready for analysis.  

---

### 2. ETL and Data Cleaning (`2_transformation.sql`)
A single, sophisticated SQL script was written to transform the raw data from the staging table and load it into the clean production table. This crucial step solved several real-world data problems:  

- **Date Transformation:** Converted human-readable relative date strings (e.g., "12 days ago", "a month ago") into absolute `DATE` values that the database can use for calculations.  
- **Salary Parsing:** Extracted and cleaned complex salary data which was stored as text. This involved removing currency symbols and commas, and intelligently splitting salary ranges (e.g., "€100,000 - €150,000") into separate `salary_min`, `salary_max`, and calculated `salary_avg` integer columns.  
- **Error Handling:** Systematically identified and fixed data type errors, value-too-long errors, and character encoding issues during the development of the script.  

---

### 3. Data Analysis (`3_analysis.sql`)
The analysis was conducted in two phases. First, a series of data quality and audit checks were performed to verify the integrity of the cleaned data. Second, a series of analytical queries were written to interrogate the clean dataset and answer key business questions.  

---

## 📊 Key Findings & Insights

- **Insight 1: Senior Roles Dominate in Demand and Compensation**  
  The analysis shows a market geared towards experienced professionals, with 'Senior' level roles being the most numerous. Furthermore, there is a significant financial incentive for career progression, with the data showing an average salary jump of over 40% when moving from a Junior to a Senior position.  

- **Insight 2: The Most Valuable Tech Skills are Foundational & Cloud-Based**  
  While foundational skills like Python and SQL are nearly ubiquitous across all job postings, the analysis reveals that specialized skills in Machine Learning and Cloud platforms (particularly AWS) are frequently required. This indicates their high value and importance in the current data science landscape.  

- **Insight 3: The US Tech Hubs are Epicenters for High-Paying Roles**  
  The market for high-paying data jobs (over $120,000) is heavily concentrated in major US tech hubs. San Francisco leads the pack with 76 such roles in this dataset, followed by other key locations like Mountain View (home of Google), New York, and Seattle, confirming their status as centers of opportunity for data professionals.  

- **Insight 4: Cloud Expertise Commands a Salary Premium**  
  A direct comparison between jobs that require cloud skills and those that do not shows a clear trend: jobs that explicitly list cloud technologies (AWS, Azure, GCP) in their requirements have a demonstrably higher average salary. This highlights the significant return on investment for professionals who develop expertise in cloud technologies.  

---

## ⚠️ Analytical Note: Dataset Skew
A preliminary investigation into salary ranges across different job titles revealed that the dataset is heavily skewed towards the 'Data Scientist' role (856 out of 944 postings). While this provides a deep insight into that specific role, it makes direct salary range comparisons to other roles (like Data Analyst or Data Engineer) statistically insignificant. This finding was crucial in guiding the direction of the subsequent analysis.  
